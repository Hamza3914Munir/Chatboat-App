import 'package:image_picker/image_picker.dart';

/// Thin wrapper over `image_picker` so screens do not depend on it directly.
class PhotoPickerService {
  PhotoPickerService();

  final ImagePicker _picker = ImagePicker();

  /// Returns the picked file path, or null if the user cancelled.
  Future<String?> pickFromGallery() => _pick(ImageSource.gallery);

  Future<String?> takePhoto() => _pick(ImageSource.camera);

  Future<String?> _pick(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      // Keeps the on-device face check fast and the eventual upload small
      // without throwing away the detail a generation needs.
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 92,
    );
    return file?.path;
  }
}
