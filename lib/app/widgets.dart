import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../memory/models.dart';

String formatBytes(num b) {
  if (b < 1024) return '${b.round()} B';
  if (b < 1024 * 1024) return '${(b / 1024).toStringAsFixed(1)} KB';
  return '${(b / 1048576).toStringAsFixed(1)} MB';
}

String formatTime(DateTime t) {
  const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final mm = t.minute.toString().padLeft(2, '0');
  return '${t.day} ${m[t.month - 1]}, $h:$mm ${t.hour < 12 ? 'AM' : 'PM'}';
}

IconData sourceIcon(SourceType s) => switch (s) {
  SourceType.doctorAudio => Icons.medical_services_outlined,
  SourceType.nurseAudio => Icons.health_and_safety_outlined,
  SourceType.pharmacistAudio => Icons.local_pharmacy_outlined,
  SourceType.familyVoice => Icons.mic_none,
  SourceType.prescription => Icons.receipt_long_outlined,
  SourceType.labReport => Icons.science_outlined,
  SourceType.dischargeSummary => Icons.description_outlined,
  SourceType.medicinePackage => Icons.medication_outlined,
  SourceType.vitalReading => Icons.monitor_heart_outlined,
  SourceType.note => Icons.sticky_note_2_outlined,
  SourceType.task => Icons.task_alt,
};

String sourceLabel(SourceType s) => switch (s) {
  SourceType.doctorAudio => 'Doctor audio',
  SourceType.nurseAudio => 'Nurse audio',
  SourceType.pharmacistAudio => 'Pharmacist audio',
  SourceType.familyVoice => 'Family voice',
  SourceType.prescription => 'Prescription',
  SourceType.labReport => 'Lab report',
  SourceType.dischargeSummary => 'Discharge summary',
  SourceType.medicinePackage => 'Medicine package',
  SourceType.vitalReading => 'Vital reading',
  SourceType.note => 'Note',
  SourceType.task => 'Task',
};

TextStyle monoStyle(BuildContext context, {double size = 11.5}) =>
    Theme.of(context).textTheme.bodySmall!.copyWith(
      fontFamily: 'monospace',
      fontSize: size,
      height: 1.35,
    );

/// A titled card section.
class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.step,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final int? step;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (step != null) ...[
                  CircleAvatar(
                    radius: 11,
                    backgroundColor: c.primary,
                    child: Text(
                      '$step',
                      style: t.labelSmall!.copyWith(color: c.onPrimary),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(child: Text(title, style: t.titleSmall)),
                ?trailing,
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle!, style: t.bodySmall!.copyWith(color: c.onSurfaceVariant)),
            ],
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

/// Monospace block on a tinted background.
class CodeBlock extends StatelessWidget {
  const CodeBlock(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(6),
    ),
    child: SelectableText(text, style: monoStyle(context)),
  );
}

/// Key/value rows.
class KeyValues extends StatelessWidget {
  const KeyValues(this.rows, {super.key});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      children: [
        for (final (k, v) in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 130,
                  child: Text(k, style: t.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
                ),
                Expanded(child: SelectableText(v, style: t.bodySmall)),
              ],
            ),
          ),
      ],
    );
  }
}

/// Every component of a vector as a thin bar around a zero line.
class VectorStrip extends StatelessWidget {
  const VectorStrip(this.values, {super.key, this.height = 56});

  final List<num> values;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: CustomPaint(
      painter: _StripPainter(
        values,
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.tertiary,
        Theme.of(context).colorScheme.outlineVariant,
      ),
    ),
  );
}

class _StripPainter extends CustomPainter {
  _StripPainter(this.values, this.pos, this.neg, this.axis);

  final List<num> values;
  final Color pos, neg, axis;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxAbs = values.fold<double>(0, (m, v) => math.max(m, v.abs().toDouble()));
    final mid = size.height / 2;
    canvas.drawLine(Offset(0, mid), Offset(size.width, mid), Paint()..color = axis);
    if (maxAbs == 0) return;
    final w = size.width / values.length;
    final pPos = Paint()..color = pos;
    final pNeg = Paint()..color = neg;
    for (var i = 0; i < values.length; i++) {
      final v = values[i] / maxAbs;
      final h = v.abs() * mid;
      canvas.drawRect(
        Rect.fromLTWH(i * w, v >= 0 ? mid - h : mid, math.max(w * 0.8, 0.6), h),
        v >= 0 ? pPos : pNeg,
      );
    }
  }

  @override
  bool shouldRepaint(_StripPainter old) => old.values != values;
}

String hexDump(List<int> bytes, {int max = 64, int perLine = 16}) {
  final b = StringBuffer();
  final n = math.min(bytes.length, max);
  for (var i = 0; i < n; i += perLine) {
    b.write(i.toRadixString(16).padLeft(4, '0'));
    b.write('  ');
    for (var j = i; j < math.min(i + perLine, n); j++) {
      b.write((bytes[j] & 0xff).toRadixString(16).padLeft(2, '0'));
      b.write(' ');
    }
    b.writeln();
  }
  if (bytes.length > n) b.write('…  (${bytes.length - n} more bytes)');
  return b.toString().trimRight();
}

String previewNumbers(List<num> v, {int n = 8, int digits = 4}) {
  final shown = v.take(n).map((x) => x is int ? '$x' : x.toStringAsFixed(digits));
  return '[${shown.join(', ')}${v.length > n ? ', … ${v.length - n} more' : ''}]';
}
