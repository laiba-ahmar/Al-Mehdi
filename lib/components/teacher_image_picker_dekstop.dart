import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

Future<Uint8List?> pickImagePlatform() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    withData: true,
  );

  if (result != null && result.files.single.bytes != null) {
    return result.files.single.bytes!;
  }

  return null;
}
