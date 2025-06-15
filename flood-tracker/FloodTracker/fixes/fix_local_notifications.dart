import 'dart:io';
import 'package:logger/logger.dart';

void main() async {
  final file = File(
    'C:/Users/alifa/AppData/Local/Pub/Cache/hosted/pub.dev/flutter_local_notifications-15.1.3/android/src/main/java/com/dexterous/flutterlocalnotifications/FlutterLocalNotificationsPlugin.java',
  );

  if (await file.exists()) {
    String content = await file.readAsString();

    // Replace the ambiguous call with an explicit cast
    content = content.replaceAll(
      'bigPictureStyle.bigLargeIcon(null);',
      'bigPictureStyle.bigLargeIcon((android.graphics.Bitmap) null);',
    );

    await file.writeAsString(content);
    Logger().i('Fixed flutter_local_notifications package');
  } else {
    Logger().e('Could not find the file to patch. Path: ${file.path}');
  }
}
