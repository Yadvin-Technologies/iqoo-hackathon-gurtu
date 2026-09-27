import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ai/on_device_ai.dart';
import '../cloud/cloud_sync.dart';
import '../data/attachment_store.dart';
import '../data/care_repository.dart';
import '../data/medicine_models.dart';
import '../data/visit_models.dart';
import '../l10n/language.dart';
import '../medicines/medicine_text.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';
import 'medicine_plan.dart';

/// After a visit is saved (or from the visit's page): what Gurtu read about
/// each medicine, for the family to check and correct before the reminders
/// are turned on. Turning them on also adds the medicines to the list.
class ReminderReviewPage extends StatefulWidget {
  const ReminderReviewPage({super.key, required this.visitId});

  final String visitId;

  @override
  State<ReminderReviewPage> createState() => _ReminderReviewPageState();
}

class _ReminderReviewPageState extends State<ReminderReviewPage> {
  List<PlannedMedicine>? _plan;
  final _names = <String, TextEditingController>{};
  final _strengths = <String, TextEditingController>{};
  final _notes = <String, TextEditingController>{};
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _load();
  }

  @override
  void dispose() {
    for (final c in [
      ..._names.values,
      ..._strengths.values,
      ..._notes.values,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  DoctorVisit? _visit(CareRepository repo) =>
      repo.visits.where((v) => v.id == widget.visitId).firstOrNull;

  /// The plan confirmed before, if any; medicines added since are read
  /// now (by Gurtu AI when it is installed).
  Future<void> _load() async {
    final visit = _visit(CareScope.of(context));
    final cloud = CloudScope.of(context);
    final ai = AiScope.read(context);
    if (visit == null) {
      setState(() => _plan = []);
      return;
    }
    final saved = {
      for (final p in cloud.planFor(visit.id) ?? const <PlannedMedicine>[])
        p.visitMedicineId: p,
    };
    final missing = {
      for (final m in visit.medicines)
        if (!saved.containsKey(m.id)) m.id,
    };
    var fresh = <PlannedMedicine>[];
    if (missing.isNotEmpty) {
      try {
        fresh = await MedicinePlanner(ai: ai).plan(visit, only: missing);
      } on Object catch (e) {
        debugPrint('Reading the medicines failed, using the rules: $e');
        fresh = [
          for (final m in visit.medicines)
            if (missing.contains(m.id))
              const MedicineRules().read(m.note, visitMedicineId: m.id),
        ];
      }
    }
    final read = {for (final p in fresh) p.visitMedicineId: p};
    final plan = [
      for (final m in visit.medicines)
        if (saved[m.id] ?? read[m.id] case final p?) _withFiles(p, visit, m),
    ];
    if (!mounted) return;
    for (final p in plan) {
      final id = p.visitMedicineId;
      _names[id] = TextEditingController(text: p.name);
      _strengths[id] = TextEditingController(text: p.strength);
      _notes[id] = TextEditingController(text: p.note);
    }
    setState(() => _plan = plan);
  }

  /// [p] with the medicine's photo and voice note as they are now (one may
  /// have been added or removed since the plan was saved).
  static PlannedMedicine _withFiles(
    PlannedMedicine p,
    DoctorVisit visit,
    VisitMedicine m,
  ) {
    final files = visit.attachmentsOf(m);
    String? first(AttachmentKind kind) =>
        files.where((a) => a.kind == kind).firstOrNull?.file;
    return PlannedMedicine(
      visitMedicineId: p.visitMedicineId,
      name: p.name,
      strength: p.strength,
      times: {...p.times},
      food: p.food,
      days: p.days,
      note: p.note,
      photoFile: first(AttachmentKind.photo),
      audioFile: first(AttachmentKind.audio),
      byAi: p.byAi,
    );
  }

  void _turnOn() {
    final plan = _plan;
    final repo = CareScope.of(context);
    final visit = _visit(repo);
    if (plan == null || visit == null) return;
    for (final p in plan) {
      final id = p.visitMedicineId;
      p
        ..name = _names[id]!.text.trim()
        ..strength = _strengths[id]!.text.trim()
        ..note = _notes[id]!.text.trim();
    }
    final on = plan.where((p) => p.isOn).toList();
    // Sent in the background; kept and retried when offline.
    CloudScope.of(context).setVisitReminders(
      patientId: visit.patientId,
      visitId: visit.id,
      plan: plan,
    );
    repo.saveFromReminders(visit.patientId, [
      for (final p in on)
        (
          name: p.name,
          strength: p.strength,
          times: p.orderedTimes,
          food: p.food,
        ),
    ]);
    HapticFeedback.mediumImpact();
    final count = on.fold(0, (sum, p) => sum + p.times.length);
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    Navigator.pop(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l.remindersSaved(count))));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final repo = CareScope.of(context);
    final cloud = CloudScope.of(context);
    final visit = _visit(repo);
    final patient = visit == null ? null : repo.patientById(visit.patientId);
    final name = patient?.name ?? '';
    final circle = cloud.circleFor(visit?.patientId);
    final patientMember = circle?.members
        .where((m) => m.role == 'patient')
        .firstOrNull;
    final toPatient = patientMember?.usesApp ?? patient?.isSelf ?? false;
    final plan = _plan;

    return GurtuPage(
      title: l.medRemindersTitle,
      subtitle: l.medRemindersIntro(name),
      bottom: GurtuButton(
        label: l.turnOnReminders,
        icon: Icons.alarm_on_rounded,
        onPressed: plan == null || plan.isEmpty ? null : _turnOn,
      ),
      children: [
        if (plan == null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                const CircularProgressIndicator(color: GurtuColors.primary),
                const SizedBox(height: 16),
                Text(l.readingMedicines, style: t.bodyLarge),
              ],
            ),
          )
        else ...[
          for (final (i, p) in plan.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _MedicineCard(
                key: ValueKey(p.visitMedicineId),
                number: i + 1,
                medicine: p,
                name: _names[p.visitMedicineId]!,
                strength: _strengths[p.visitMedicineId]!,
                note: _notes[p.visitMedicineId]!,
                onChanged: () => setState(() {}),
              ),
            ),
          InfoBanner(
            text: toPatient
                ? l.remindersGoToPatient(name)
                : l.remindersGoToFamily(name),
            icon: Icons.notifications_active_rounded,
            color: GurtuColors.info,
          ),
        ],
      ],
    );
  }
}

/// One medicine: its name and strength, when to take it, with or without
/// food, and for how long.
class _MedicineCard extends StatelessWidget {
  const _MedicineCard({
    super.key,
    required this.number,
    required this.medicine,
    required this.name,
    required this.strength,
    required this.note,
    required this.onChanged,
  });

  final int number;
  final PlannedMedicine medicine;
  final TextEditingController name;
  final TextEditingController strength;
  final TextEditingController note;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final p = medicine;
    final photo = p.photoFile;
    final on = name.text.trim().isNotEmpty && p.times.isNotEmpty;

    return GurtuCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow(l.medicineNumber(number)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          p.byAi
                              ? Icons.auto_awesome_rounded
                              : Icons.notes_rounded,
                          size: 16,
                          color: p.byAi
                              ? GurtuColors.primary
                              : GurtuColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            p.byAi ? l.readByAi : l.readByRules,
                            style: t.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    if (!on) ...[
                      const SizedBox(height: 4),
                      Text(
                        l.noReminderForThis,
                        style: t.bodySmall?.copyWith(color: GurtuColors.amber),
                      ),
                    ],
                  ],
                ),
              ),
              if (photo != null && AttachmentStore.instance.available)
                ClipRRect(
                  borderRadius: BorderRadius.circular(GurtuSpace.radiusSm),
                  child: Image.file(
                    File(AttachmentStore.instance.pathOf(photo)),
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          FieldLabel(l.medicineName, icon: Icons.medication_rounded),
          TextField(
            controller: name,
            textCapitalization: TextCapitalization.words,
            // The server's limits (80 and 30).
            maxLength: 80,
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(
              hintText: l.medicineNameHint,
              counterText: '',
            ),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 14),
          FieldLabel(l.strength, optional: true),
          TextField(
            controller: strength,
            maxLength: 30,
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(
              hintText: l.strengthHint,
              counterText: '',
            ),
          ),
          const SizedBox(height: 20),
          FieldLabel(l.whenToTake, icon: Icons.schedule_rounded),
          if (p.times.isEmpty) ...[
            Text(
              l.pickTimes,
              style: t.bodyMedium?.copyWith(color: GurtuColors.amber),
            ),
            const SizedBox(height: 8),
          ],
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final d in DoseTime.values)
                GurtuChip(
                  label: l.doseLabel(d),
                  icon: d.icon,
                  selected: p.times.contains(d),
                  onTap: () {
                    p.times.contains(d) ? p.times.remove(d) : p.times.add(d);
                    onChanged();
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final f in FoodTiming.values)
                GurtuChip(
                  label: l.foodLabel(f),
                  icon: Icons.restaurant_rounded,
                  selected: p.food == f,
                  onTap: () {
                    p.food = f;
                    onChanged();
                  },
                ),
            ],
          ),
          const SizedBox(height: 20),
          FieldLabel(l.howLong, icon: Icons.date_range_rounded),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              GurtuChip(
                label: l.everyDay,
                icon: Icons.all_inclusive_rounded,
                selected: p.days == null,
                onTap: () {
                  p.days = null;
                  onChanged();
                },
              ),
              GurtuChip(
                label: l.forDays(p.days ?? 5),
                icon: Icons.event_rounded,
                selected: p.days != null,
                onTap: () {
                  p.days ??= 5;
                  onChanged();
                },
              ),
              if (p.days != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.filledTonal(
                      onPressed: p.days! > 1
                          ? () {
                              p.days = p.days! - 1;
                              onChanged();
                            }
                          : null,
                      icon: const Icon(Icons.remove_rounded),
                    ),
                    IconButton.filledTonal(
                      onPressed: p.days! < 365
                          ? () {
                              p.days = p.days! + 1;
                              onChanged();
                            }
                          : null,
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ],
                ),
            ],
          ),
          // What Gurtu AI picked out to remember ("with warm water").
          if (p.note.isNotEmpty) ...[
            const SizedBox(height: 16),
            TextField(
              controller: note,
              minLines: 1,
              maxLines: 3,
              maxLength: 120,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.sticky_note_2_outlined),
                counterText: '',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
