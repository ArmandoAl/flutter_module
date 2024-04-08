import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('com.example.androidflutter/note');

Future<void> sendNoteData(String title, String content) async {
  try {
    await _channel
        .invokeMethod('addNote', {'title': title, 'content': content});
  } on PlatformException catch (e) {
    print("Failed to send note data to Android: '${e.message}'.");
  }
}
