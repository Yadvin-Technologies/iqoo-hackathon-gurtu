import 'package:flutter/material.dart';

import '../cloud/cloud_models.dart';
import '../cloud/cloud_sync.dart';
import '../data/care_repository.dart';
import '../l10n/language.dart';
import '../onboarding/onboarding_flow.dart';
import '../onboarding/pages/join_circle_page.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';

/// "Add someone to care for": set Gurtu up for a new person (their own care
/// circle and family code), or join a circle the family already made. Either
/// way they become the selected person. [host] must outlive the sheet.
Future<void> showAddPersonSheet(BuildContext host) =>
    showGurtuSheet(host, (_) => _AddPersonSheet(host: host));

class _AddPersonSheet extends StatelessWidget {
  const _AddPersonSheet({required this.host});

  final BuildContext host;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetGrabber(),
            const SizedBox(height: 16),
            Text(
              l.addPersonTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ChoiceTile(
              title: l.setUpNew,
              hint: l.setUpNewHint,
              icon: Icons.person_add_alt_1_rounded,
              selected: false,
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(context);
                _setUpNew(host);
              },
            ),
            const SizedBox(height: 10),
            ChoiceTile(
              title: l.joinWithCode,
              hint: l.joinWithCodeHint,
              icon: Icons.group_add_rounded,
              selected: false,
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(context);
                _join(host);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _setUpNew(BuildContext host) async {
  final repo = CareScope.of(host);
  final cloud = CloudScope.of(host);
  await Navigator.of(host).push<void>(
    MaterialPageRoute(
      builder: (context) => OnboardingFlow(
        prefs: null,
        addingPerson: true,
        yourName: repo.userName,
        allowSelf: !repo.hasSelf,
        onFinished: (data) {
          repo.createFromOnboarding(data);
          final patient = repo.selectedPatient;
          if (patient != null) {
            // Its own circle and code; kept and retried when offline.
            cloud.createCircle(
              patient.id,
              CloudSync.circlePayload(patient, myName: repo.userName),
            );
          }
          Navigator.pop(context);
        },
      ),
    ),
  );
}

Future<void> _join(BuildContext host) async {
  final repo = CareScope.of(host);
  final cloud = CloudScope.of(host);
  final messenger = ScaffoldMessenger.of(host);
  final l = host.l10n;
  final joined = await pushPage<(CircleInfo, String)>(
    host,
    JoinCirclePage(defaultName: repo.userName),
  );
  if (joined == null) return;
  final (circle, name) = joined;
  final patientId = repo.createFromCircle(circle, myName: name);
  cloud.link(patientId, circle);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(l.joinedCircle(circle.patientName))));
}
