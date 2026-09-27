import 'package:flutter/material.dart';

import '../cloud/cloud_sync.dart';
import '../data/care_repository.dart';
import '../data/medicine_models.dart';
import '../l10n/language.dart';
import '../widgets/gurtu_widgets.dart';
import 'medicine_plan.dart';

/// "Send a test reminder now": a real medicine reminder, pushed straight
/// away through the server to the phone that gets reminders, so the family
/// sees how it works without waiting for its time. Follow-ups and the
/// missed-dose alert come a minute apart.
///
/// Uses [visitId]'s first reminder, or else the selected person's most
/// recent one, a medicine from their list, or a stand-in "Test medicine".
class TestReminderButton extends StatefulWidget {
  const TestReminderButton({super.key, this.visitId});

  final String? visitId;

  @override
  State<TestReminderButton> createState() => _TestReminderButtonState();
}

class _TestReminderButtonState extends State<TestReminderButton> {
  bool _sending = false;

  /// The medicine to remind, and the visit its saved reminder belongs to.
  (PlannedMedicine, String?) _pick(
    CareRepository repo,
    CloudSync cloud,
    String patientId,
    AppLocalizations l,
  ) {
    final visits =
        repo.visits
            .where(
              (v) =>
                  v.patientId == patientId &&
                  (widget.visitId == null || v.id == widget.visitId),
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    for (final v in visits) {
      final on = cloud.planFor(v.id)?.where((p) => p.isOn).firstOrNull;
      if (on != null) return (on, v.id);
    }
    final listed = repo.medicines
        .where((m) => m.patientId == patientId && !m.isSample)
        .firstOrNull;
    return (
      PlannedMedicine(
        visitMedicineId: 'test',
        name: listed?.name ?? l.testMedicine,
        strength: listed?.strength ?? '',
        times: {...?listed?.times},
        food: listed?.food ?? FoodTiming.any,
      ),
      null,
    );
  }

  Future<void> _send() async {
    final repo = CareScope.of(context);
    final cloud = CloudScope.of(context);
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final patientId = widget.visitId == null
        ? repo.selectedPatient?.id
        : repo.visits
              .where((v) => v.id == widget.visitId)
              .firstOrNull
              ?.patientId;
    if (patientId == null) return;
    final (medicine, visitId) = _pick(repo, cloud, patientId, l);
    setState(() => _sending = true);
    final sent = await cloud.sendTestReminder(
      patientId,
      medicine,
      visitId: visitId,
    );
    if (!mounted) return;
    setState(() => _sending = false);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(sent == null ? l.connectionFailed : l.testSent(sent)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return GurtuButton(
      label: context.l10n.testReminder,
      style: GurtuButtonStyle.ghost,
      icon: Icons.notifications_active_rounded,
      onPressed: _sending ? null : _send,
    );
  }
}
