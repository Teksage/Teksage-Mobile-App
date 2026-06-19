import 'dart:io';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

// class FileStorage {
//   /// Gets the appropriate download directory path.
//   static Future<String> getDownloadPath() async {
//     if (Platform.isAndroid) {
//       // Check MANAGE_EXTERNAL_STORAGE for Android 11+ (SDK 30+)
//       final manageExternalStorageStatus = await Permission.manageExternalStorage.status;
//       final storageStatus = await Permission.storage.status;
//
//       if (!manageExternalStorageStatus.isGranted && !storageStatus.isGranted) {
//         // Request both permissions
//         final statuses = await [
//           Permission.manageExternalStorage,
//           Permission.storage,
//         ].request();
//
//         final manageGranted = statuses[Permission.manageExternalStorage]?.isGranted ?? false;
//         final storageGranted = statuses[Permission.storage]?.isGranted ?? false;
//
//         if (!manageGranted && !storageGranted) {
//           throw Exception("Storage permission not granted");
//         }
//       }
//
//       final directory = Directory("/storage/emulated/0/Download");
//       if (await directory.exists()) {
//         return directory.path;
//       } else {
//         final fallbackDir = await getExternalStorageDirectory();
//         return fallbackDir?.path ?? '/';
//       }
//     } else if (Platform.isIOS) {
//       final dir = await getApplicationDocumentsDirectory();
//       return dir.path;
//     } else {
//       throw UnsupportedError("Unsupported platform");
//     }
//   }
//
//   /// Writes bytes to a file in the download path, resolving name conflicts.
//   static Future<File> writeBytes(Uint8List bytes, String fileName) async {
//     final path = await getDownloadPath();
//
//     String baseName = fileName;
//     String name = baseName;
//     String fullPath = '$path/$name';
//     int count = 1;
//
//     String nameWithoutExt = fileName.split('.').first;
//     String ext = fileName.contains('.') ? '.${fileName.split('.').last}' : '';
//
//     while (await File(fullPath).exists()) {
//       name = '$nameWithoutExt($count)$ext';
//       fullPath = '$path/$name';
//       count++;
//     }
//
//     final file = File(fullPath);
//     return file.writeAsBytes(bytes);
//   }
//
//   static Future<String> savePdfToDownloads(Uint8List bytes, String fileName) async {
//     try {
//       final path = await FileSaver.instance.saveFile(
//         name: fileName,
//         bytes: bytes,
//         ext: "pdf",
//         mimeType: MimeType.pdf,
//       );
//       print("📁 Saved PDF path: $path");
//       return path;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }

// class FileStorage {
//   static Future<String> getDownloadPath() async {
//     if (Platform.isAndroid) {
//       final status = await Permission.storage.request();
//       if (!status.isGranted) {
//         throw Exception("Storage permission not granted");
//       }
//
//       final directory = Directory("/storage/emulated/0/Download");
//       if (await directory.exists()) {
//         return directory.path;
//       } else {
//         final fallbackDir = await getExternalStorageDirectory();
//         return fallbackDir?.path ?? '/';
//       }
//     } else if (Platform.isIOS) {
//       final dir = await getApplicationDocumentsDirectory();
//       return dir.path;
//     } else {
//       throw UnsupportedError("Unsupported platform");
//     }
//   }
//
//   static Future<File> writeBytes(Uint8List bytes, String fileName) async {
//     final path = await getDownloadPath();
//
//     String baseName = fileName;
//     String name = baseName;
//     String fullPath = '$path/$name';
//     int count = 1;
//
//     String nameWithoutExt = fileName.split('.').first;
//     String ext = fileName.contains('.') ? '.${fileName.split('.').last}' : '';
//
//     while (await File(fullPath).exists()) {
//       name = '$nameWithoutExt($count)$ext';
//       fullPath = '$path/$name';
//       count++;
//     }
//
//     final file = File(fullPath);
//     return file.writeAsBytes(bytes);
//   }
// }

class FileStorage {
  static const _channel = MethodChannel('com.venzo.astroPrompt/filesaver');

  static Future<String> savePdfToDownloads(Uint8List bytes, String fileName) async {
    if (Platform.isAndroid) {
      try {
        final result = await _channel.invokeMethod<String>(
          'saveFileToDownloads',
          {
            'fileName': "$fileName.pdf",
            'bytes': bytes,
            'mimeType': 'application/pdf',
          },
        );
        return result ?? "$fileName.pdf";
      } on PlatformException catch (e) {
        throw Exception("Failed to save file on Android: ${e.message}");
      }
    } else if (Platform.isIOS) {
      // For iOS, save to app's Documents directory
      final dir = await getApplicationDocumentsDirectory();
      final filePath = p.join(dir.path, "$fileName.pdf");
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      return filePath;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
