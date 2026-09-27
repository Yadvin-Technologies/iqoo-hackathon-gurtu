import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../ai/medicine_check.dart';
import '../data/attachment_store.dart';
import '../data/care_models.dart';
import '../data/care_repository.dart';
import '../home/care_text.dart';
import '../l10n/language.dart';
import '../medicines/prescription_import_page.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';
import 'memory_editor_page.dart';

/// One saved memory: its photos and documents, what it says, and who
/// added it. Edit, add its medicines to the list, or delete it.
class MemoryDetailPage extends StatefulWidget {
  const MemoryDetailPage({super.key, required this.momentId});

  final String momentId;

  @override
  State<MemoryDetailPage> createState() => _MemoryDetailPageState();
}

class _MemoryDetailPageState extends State<MemoryDetailPage> {
  CareMoment? _shown;

  Future<void> _open(String file) async {
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    try {
      final result = await OpenFilex.open(
        AttachmentStore.instance.pathOf(file),
      );
      if (result.type != ResultType.done) {
        messenger.showSnackBar(SnackBar(content: Text(l.cantOpenFile)));
      }
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l.cantOpenFile)));
    }
  }

  void _zoom(String file) => showDialog<void>(
    context: context,
    builder: (context) => Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              maxScale: 5,
              child: Image.file(
                File(AttachmentStore.instance.pathOf(file)),
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ),
          SafeArea(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              tooltip: context.l10n.close,
              color: Colors.white,
              icon: const Icon(Icons.close_rounded),
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    // Keeps showing while the page closes after a delete.
    final m = _shown = repo.momentById(widget.momentId) ?? _shown;
    if (m == null) return const SizedBox.shrink();
    final by = repo.memberById(m.createdBy);
    final detail = l.momentDetail(m);
    final store = AttachmentStore.instance;
    final photos = [
      for (final f in m.files)
        if (isImageFile(f)) f,
    ];
    final documents = [
      for (final f in m.files)
        if (!isImageFile(f)) f,
    ];
    final medicines = medicinesIn(detail);

    return GurtuPage(
      title: l.momentTitle(m),
      subtitle: [
        whenLabel(context, m.timestamp),
        if (by != null) l.addedBy(by.isYou ? l.rowYou : by.name),
      ].join(' · '),
      children: [
        for (final f in photos)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: store.available ? () => _zoom(f) : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(GurtuSpace.radius),
                child: store.available
                    ? Image.file(
                        File(store.pathOf(f)),
                        fit: BoxFit.cover,
                        semanticLabel: l.momentTitle(m),
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        for (final f in documents)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GurtuCard(
              onTap: () => _open(f),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const IconBadge(
                    icon: Icons.picture_as_pdf_rounded,
                    color: GurtuColors.danger,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      '${l.momentTitle(m)} · ${f.split('.').last.toUpperCase()}',
                      style: t.titleMedium,
                    ),
                  ),
                  const Icon(
                    Icons.open_in_new_rounded,
                    color: GurtuColors.primary,
                  ),
                ],
              ),
            ),
          ),
        if (detail.isNotEmpty)
          GurtuCard(child: SelectableText(detail, style: t.bodyLarge)),
        const SizedBox(height: 20),
        if (medicines.isNotEmpty) ...[
          GurtuButton(
            label: l.addMedicinesFound(medicines.length),
            icon: Icons.medication_rounded,
            onPressed: () =>
                pushPage(context, PrescriptionImportPage(initialText: detail)),
          ),
          const SizedBox(height: 10),
        ],
        if (!m.isSample)
          GurtuButton(
            label: l.editMemory,
            style: GurtuButtonStyle.ghost,
            icon: Icons.edit_rounded,
            onPressed: () => pushPage(context, MemoryEditorPage(editing: m)),
          ),
        const SizedBox(height: 10),
        GurtuButton(
          label: l.delete,
          style: GurtuButtonStyle.ghost,
          icon: Icons.delete_outline_rounded,
          onPressed: () async {
            final ok = await confirmAction(
              context,
              title: l.deleteMemoryTitle,
              body: m.files.isEmpty ? null : l.removeMedicineBody,
              confirm: l.delete,
            );
            if (!ok || !context.mounted) return;
            Navigator.pop(context);
            repo.deleteMoment(m);
          },
        ),
      ],
    );
  }
}
