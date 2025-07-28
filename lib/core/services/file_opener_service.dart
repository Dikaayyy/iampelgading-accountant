import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

class FileOpenerService {
  /// Membuka file dengan aplikasi default
  static Future<bool> openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      return result.type == ResultType.done;
    } catch (e) {
      // Fallback untuk platform yang tidak didukung
      return await _openWithUrlLauncher(filePath);
    }
  }

  /// Membuka folder yang berisi file
  static Future<bool> openFolder(String folderPath) async {
    try {
      if (Platform.isWindows) {
        await Process.run('explorer', [folderPath.replaceAll('/', '\\')]);
        return true;
      } else if (Platform.isMacOS) {
        await Process.run('open', [folderPath]);
        return true;
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [folderPath]);
        return true;
      } else {
        // Untuk Android/iOS, buka file manager atau folder
        final result = await OpenFile.open(folderPath);
        return result.type == ResultType.done;
      }
    } catch (e) {
      return false;
    }
  }

  /// Fallback menggunakan url_launcher
  static Future<bool> _openWithUrlLauncher(String filePath) async {
    try {
      final uri = Uri.file(filePath);
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      return false;
    }
  }

  /// Cek apakah file bisa dibuka
  static Future<bool> canOpenFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return false;

      final extension = path.extension(filePath).toLowerCase();

      // Daftar ekstensi yang biasanya bisa dibuka
      const supportedExtensions = [
        '.txt',
        '.csv',
        '.pdf',
        '.doc',
        '.docx',
        '.xls',
        '.xlsx',
        '.jpg',
        '.jpeg',
        '.png',
        '.gif',
        '.mp4',
        '.mp3',
      ];

      return supportedExtensions.contains(extension);
    } catch (e) {
      return false;
    }
  }

  /// Get file info untuk ditampilkan ke user
  static Future<Map<String, String>> getFileInfo(String filePath) async {
    try {
      final file = File(filePath);
      final stat = await file.stat();
      final fileName = path.basename(filePath);
      final fileSize = _formatFileSize(stat.size);

      return {
        'name': fileName,
        'size': fileSize,
        'path': filePath,
        'directory': path.dirname(filePath),
      };
    } catch (e) {
      return {};
    }
  }

  static String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
