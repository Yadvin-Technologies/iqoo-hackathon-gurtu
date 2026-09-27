import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../reminders/medicine_plan.dart';

/// Picks documents (PDF, Word, text, photos) and reads the words in them,
/// all on the phone. Behind an interface so tests run without Android.
abstract class DocumentReader {
  static DocumentReader instance = DeviceDocumentReader();

  bool get available;

  /// The phone's file picker; the chosen files, copied into the app. Empty
  /// when cancelled.
  Future<List<String>> pick();

  /// The text of the file at [path], or '' when there is none to read (or
  /// it can't be read, e.g. a password-protected PDF).
  Future<String> read(String path);
}

enum DocumentKind { image, pdf, word, text, other }

DocumentKind documentKind(String name) {
  final ext = name.toLowerCase().split('.').last;
  return switch (ext) {
    'jpg' || 'jpeg' || 'png' || 'webp' || 'heic' => DocumentKind.image,
    'pdf' => DocumentKind.pdf,
    'docx' => DocumentKind.word,
    'txt' || 'text' || 'md' || 'csv' => DocumentKind.text,
    _ => DocumentKind.other,
  };
}

/// PDF pages are drawn by Android's own PDF renderer and read like photos
/// (so scanned reports work too); Word text is taken from the file.
class DeviceDocumentReader implements DocumentReader {
  static const _channel = MethodChannel('gurtu/documents');

  /// More pages are kept with the memory but not read, to stay quick.
  static const maxPages = 10;

  /// A damaged file must never leave the screen waiting.
  static const _limit = Duration(seconds: 90);

  @override
  bool get available =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<List<String>> pick() async {
    if (!available) return const [];
    try {
      final paths = await _channel.invokeListMethod<String>('pick');
      return paths ?? const [];
    } on Object catch (e) {
      debugPrint('Picking a document failed: $e');
      return const [];
    }
  }

  @override
  Future<String> read(String path) async {
    try {
      switch (documentKind(path)) {
        case DocumentKind.image:
          return (await PhotoTextReader.instance.read(path)).trim();
        case DocumentKind.text:
          final bytes = await File(path).readAsBytes();
          return utf8.decode(bytes, allowMalformed: true).trim();
        case DocumentKind.word:
          if (!available) return '';
          return (await _channel
                      .invokeMethod<String>('docxText', {'path': path})
                      .timeout(_limit) ??
                  '')
              .trim();
        case DocumentKind.pdf:
          if (!available) return '';
          final pages =
              await _channel
                  .invokeListMethod<String>('pdfPages', {
                    'path': path,
                    'maxPages': maxPages,
                  })
                  .timeout(_limit) ??
              const [];
          final text = <String>[];
          for (final page in pages) {
            final words = (await PhotoTextReader.instance.read(page)).trim();
            if (words.isNotEmpty) text.add(words);
            try {
              await File(page).delete();
            } on FileSystemException {
              // Already gone.
            }
          }
          return text.join('\n\n');
        case DocumentKind.other:
          return '';
      }
    } on Object catch (e) {
      debugPrint('Reading the document failed: $e');
      return '';
    }
  }
}
