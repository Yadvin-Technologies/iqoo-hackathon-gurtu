import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../cloud/cloud_models.dart';
import '../../cloud/cloud_sync.dart';
import '../../cloud/gurtu_api.dart';
import '../../data/care_models.dart';
import '../../home/care_text.dart';
import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_page.dart';
import '../../widgets/gurtu_widgets.dart';

/// "I have a family code": someone already set Gurtu up for the person they
/// care for; this phone joins that care circle instead of starting a new
/// one. Pops with the circle and the name typed, once joined.
class JoinCirclePage extends StatefulWidget {
  const JoinCirclePage({super.key, this.defaultName = ''});

  /// Your name, when you already use Gurtu for someone else.
  final String defaultName;

  @override
  State<JoinCirclePage> createState() => _JoinCirclePageState();
}

class _JoinCirclePageState extends State<JoinCirclePage> {
  final _code = TextEditingController();
  late final _name = TextEditingController(text: widget.defaultName);
  CareRole _role = CareRole.family;

  /// Joining as the person cared for: the circle already has their name.
  bool get _asPatient => _role == CareRole.patient;
  bool _busy = false;
  String? _error;

  bool get _ready =>
      _code.text.length == 6 &&
      (_asPatient || _name.text.trim().isNotEmpty) &&
      !_busy;

  @override
  void initState() {
    super.initState();
    _code.addListener(_changed);
    _name.addListener(_changed);
  }

  void _changed() => setState(() => _error = null);

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    final cloud = CloudScope.of(context);
    final l = context.l10n;
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final circle = await cloud.join(
        code: _code.text,
        name: _name.text.trim(),
        role: _role.name,
      );
      HapticFeedback.mediumImpact();
      // Reminders from the family need this on Android 13+.
      try {
        await Permission.notification.request();
      } on Object {
        // No runtime permission here (tests, older Android).
      }
      if (!mounted) return;
      Navigator.pop<(CircleInfo, String)>(context, (
        circle,
        _asPatient ? circle.patientName : _name.text.trim(),
      ));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(
        () => _error = switch (e.error) {
          ApiError.invalidCode || ApiError.notFound => l.invalidCode,
          ApiError.tooMany => l.tooManyTries,
          ApiError.patientTaken => l.patientTaken,
          ApiError.offline => l.connectionFailed,
          _ => l.somethingWrong,
        },
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return GurtuPage(
      title: l.joinTitle,
      subtitle: l.joinSubtitle,
      bottom: _busy
          ? const SizedBox(
              height: 60,
              child: Center(child: CircularProgressIndicator()),
            )
          : GurtuButton(
              label: l.joinButton,
              icon: Icons.arrow_forward_rounded,
              onPressed: _ready ? _join : null,
            ),
      children: [
        FieldLabel(l.familyCode, icon: Icons.pin_rounded),
        TextField(
          controller: _code,
          autofocus: true,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: 12,
            color: GurtuColors.textPrimary,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
          decoration: const InputDecoration(
            hintText: '······',
            counterText: '',
            hintStyle: TextStyle(
              fontSize: 32,
              letterSpacing: 12,
              color: GurtuColors.outline,
            ),
          ),
        ),
        // Right under the code: that's what it's about, and it stays on screen.
        if (_error != null) ...[
          const SizedBox(height: 12),
          InfoBanner(
            text: _error!,
            icon: Icons.error_outline_rounded,
            color: GurtuColors.danger,
          ),
        ],
        const SizedBox(height: 20),
        FieldLabel(l.howHelping, icon: Icons.volunteer_activism_rounded),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final role in const [
              CareRole.family,
              CareRole.caregiver,
              CareRole.helper,
              CareRole.patient,
            ])
              GurtuChip(
                label: role == CareRole.patient
                    ? l.iAmPatient
                    : l.roleLabel(role),
                selected: _role == role,
                onTap: () => setState(() {
                  _role = role;
                  _error = null;
                }),
              ),
          ],
        ),
        if (!_asPatient) ...[
          const SizedBox(height: 20),
          FieldLabel(l.yourName, icon: Icons.person_rounded),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(fontSize: 17),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _ready ? _join() : null,
          ),
        ],
      ],
    );
  }
}
