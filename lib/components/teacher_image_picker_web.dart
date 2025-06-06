import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart';

Future<Uint8List?> pickImagePlatform() async {
  final completer = Completer<Uint8List?>();
  final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
  uploadInput.click();

  uploadInput.onChange.listen((event) {
    final file = uploadInput.files!.first;
    final reader = html.FileReader();

    reader.readAsDataUrl(file);
    reader.onLoadEnd.listen((event) {
      final base64 = (reader.result as String).split(',').last;
      final bytes = base64Decode(base64);
      completer.complete(bytes);
    });
  });

  return completer.future;
}
