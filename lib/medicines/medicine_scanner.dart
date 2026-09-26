import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

/// Photographs a strip, box or prescription and reads the printed text.
/// Behind an interface so tests (and the web preview, which has no on-device
/// text recognition) can replace it.
abstract class MedicineScanner {
  /// Replaced in tests.
  static MedicineScanner instance = DeviceMedicineScanner();

  /// False where there is no camera + on-device OCR (web, desktop).
  bool get available;

  /// The text on the photo, or null if the person cancelled.
  Future<String?> scan({bool fromGallery = false});
}

/// Google ML Kit text recognition. Runs fully on the phone: the photo never
/// leaves the device.
class DeviceMedicineScanner implements MedicineScanner {
  final _picker = ImagePicker();

  @override
  bool get available =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Future<String?> scan({bool fromGallery = false}) async {
    final photo = await _picker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      maxWidth: 2000,
      imageQuality: 90,
    );
    if (photo == null) return null;
    final recognizer = TextRecognizer();
    try {
      final result = await recognizer.processImage(
        InputImage.fromFilePath(photo.path),
      );
      return result.text;
    } finally {
      await recognizer.close();
    }
  }
}
