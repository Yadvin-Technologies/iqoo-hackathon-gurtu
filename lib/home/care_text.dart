import 'package:flutter/material.dart';

import '../data/care_models.dart';
import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';

/// Localized labels for care data. Sample content resolves through l10n so it
/// follows the app language; user-entered text is shown exactly as typed.
extension CareText on AppLocalizations {
  String taskTitle(CareTask t) => switch (t.sample) {
    SampleText.taskMorningMedicine => sampleTaskMorningMedicine,
    SampleText.taskRecordBp => sampleTaskRecordBp,
    SampleText.taskBloodTest => sampleTaskBloodTest,
    SampleText.taskDoctorVisit => sampleTaskDoctorVisit,
    _ => t.title,
  };

  String momentTitle(CareMoment m) => switch (m.sample) {
    SampleText.momentDoctorTalk => sampleMomentDoctorTalk,
    SampleText.momentPrescription => sampleMomentPrescription,
    SampleText.momentBp => sampleMomentBp,
    _ => m.title.isNotEmpty ? m.title : momentTypeLabel(m.type),
  };

  String momentDetail(CareMoment m) => switch (m.sample) {
    SampleText.momentDoctorTalk => sampleMomentDoctorTalkDetail,
    SampleText.momentPrescription => sampleMomentPrescriptionDetail,
    // Numbers and units read the same in every language.
    SampleText.momentBp => '128 / 82 mmHg',
    _ => m.detail,
  };

  String momentTypeLabel(MomentType t) => switch (t) {
    MomentType.voice => captureVoice,
    MomentType.scan => captureScan,
    MomentType.vital => captureVital,
    MomentType.document => captureDocument,
    MomentType.note => captureNote,
    MomentType.medicine => captureScan,
  };

  String sourceLabel(MomentType t) => switch (t) {
    MomentType.voice => sourceRecording,
    MomentType.scan || MomentType.medicine => sourceScan,
    MomentType.vital => sourceVital,
    MomentType.document => sourceDocument,
    MomentType.note => sourceNote,
  };

  /// Verb for opening the original: play audio, view image, open note.
  String sourceAction(MomentType t) => switch (t) {
    MomentType.voice => sourcePlay,
    MomentType.note => sourceOpen,
    _ => sourceView,
  };

  String roleLabel(CareRole r) => switch (r) {
    CareRole.patient => rolePatient,
    CareRole.caregiver => roleCaregiver,
    CareRole.family => roleFamily,
    CareRole.helper => roleHelper,
  };

  String greeting(String name, [DateTime? now]) {
    final h = (now ?? DateTime.now()).hour;
    if (h < 12) return goodMorning(name);
    if (h < 17) return goodAfternoon(name);
    return goodEvening(name);
  }
}

IconData momentIcon(MomentType t) => switch (t) {
  MomentType.voice => Icons.graphic_eq_rounded,
  MomentType.scan => Icons.document_scanner_rounded,
  MomentType.vital => Icons.monitor_heart_rounded,
  MomentType.document => Icons.description_rounded,
  MomentType.note => Icons.edit_note_rounded,
  MomentType.medicine => Icons.medication_rounded,
};

Color momentColor(MomentType t) => switch (t) {
  MomentType.voice => GurtuColors.danger,
  MomentType.scan || MomentType.medicine => GurtuColors.info,
  MomentType.vital => GurtuColors.leaf,
  MomentType.document => GurtuColors.primary,
  MomentType.note => GurtuColors.orange,
};

/// "10:42 AM" in the device's locale format.
String timeLabel(BuildContext context, DateTime t) =>
    MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(t));

/// "Today · 10:42 AM", "Yesterday · 6:20 PM" or "25 Sep · 6:20 PM".
String whenLabel(BuildContext context, DateTime t, [DateTime? now]) {
  final l = context.l10n;
  final today = DateUtils.dateOnly(now ?? DateTime.now());
  final day = DateUtils.dateOnly(t);
  final dayText = day == today
      ? l.today
      : day == today.subtract(const Duration(days: 1))
      ? l.yesterday
      : MaterialLocalizations.of(context).formatShortMonthDay(t);
  return '$dayText · ${timeLabel(context, t)}';
}
