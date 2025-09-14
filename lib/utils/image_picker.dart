import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:universal_html/html.dart' as html;

class ImagePickerUtils {
  static Future<String> pickImageBase64() async {
    final bytes = await _pickImageAsBytes();
    if (bytes == null) return "";
    return base64Encode(bytes);
  }

  static Future<Uint8List?> pickImageAsBytes() async {
    return await _pickImageAsBytes();
  }

  static Future<Uint8List?> _pickImageAsBytes() async {
    if (kIsWeb) {
      return await _pickImageWeb();
    } else {
      return await _pickImageMobile();
    }
  }

  static Future<Uint8List?> _pickImageMobile() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;
    return await picked.readAsBytes();
  }

  static Future<Uint8List?> _pickImageWeb() async {
    final completer = Completer<Uint8List?>();

    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.onChange.listen((event) {
      final file = input.files?.first;
      if (file == null) {
        completer.complete(null);
        return;
      }

      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);

      reader.onLoadEnd.listen((_) {
        if (reader.result is Uint8List) {
          completer.complete(reader.result as Uint8List);
        } else if (reader.result is ByteBuffer) {
          completer.complete(Uint8List.view(reader.result as ByteBuffer));
        } else {
          completer.complete(null);
        }
      });
    });

    input.click();
    return completer.future;
  }
}

