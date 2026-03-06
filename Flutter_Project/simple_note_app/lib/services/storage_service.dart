import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

/// Service quản lý lưu trữ file cho Note App
///
/// Cấu trúc lưu trữ:
/// - Android: /data/data/com.example.simple_note_app/files/notes/
/// - iOS: /Library/Application Support/notes/
/// - Windows: AppData/Local/simple_note_app/
///
/// Thư mục con:
/// - notes/ (chứa data note)
/// - images/ (chứa ảnh được chọn)
/// - attachments/ (chứa file đính kèm)
/// - drawings/ (chứa file vẽ tay)

class StorageService {
  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  /// Lấy thư mục gốc cho ứng dụng
  /// Trả về: /data/data/com.example.simple_note_app/files/ (Android)
  ///         /Library/Application Support/ (iOS)
  ///         AppData/Local/simple_note_app/ (Windows)
  Future<Directory> get _appDir async {
    final dir = await getApplicationDocumentsDirectory();
    return dir;
  }

  /// Lấy thư mục lưu trữ Notes
  Future<Directory> get notesDir async {
    final appDir = await _appDir;
    final dir = Directory(path.join(appDir.path, 'notes'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Lấy thư mục lưu ảnh
  Future<Directory> get imagesDir async {
    final appDir = await _appDir;
    final dir = Directory(path.join(appDir.path, 'notes', 'images'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Lấy thư mục lưu file đính kèm
  Future<Directory> get attachmentsDir async {
    final appDir = await _appDir;
    final dir = Directory(path.join(appDir.path, 'notes', 'attachments'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Lấy thư mục lưu file vẽ tay
  Future<Directory> get drawingsDir async {
    final appDir = await _appDir;
    final dir = Directory(path.join(appDir.path, 'notes', 'drawings'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Yêu cầu cấp quyền truy cập file
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    return true; // Windows không cần cấp quyền
  }

  /// Lưu ảnh vào thư mục images
  /// Trả về: đường dẫn đầy đủ của file được lưu
  Future<String> saveImage(String sourcePath) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw Exception('File không tồn tại: $sourcePath');
      }

      final imagesDirectory = await imagesDir;
      final fileName =
          'img_${DateTime.now().millisecondsSinceEpoch}.${sourcePath.split('.').last}';
      final destinationPath = path.join(imagesDirectory.path, fileName);

      final savedFile = await sourceFile.copy(destinationPath);
      return savedFile.path;
    } catch (e) {
      throw Exception('Lỗi lưu ảnh: $e');
    }
  }

  /// Lưu file đính kèm vào thư mục attachments
  /// Trả về: đường dẫn đầy đủ của file được lưu
  Future<String> saveAttachment(String sourcePath) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw Exception('File không tồn tại: $sourcePath');
      }

      final attachmentsDirectory = await attachmentsDir;
      final fileName =
          'attach_${DateTime.now().millisecondsSinceEpoch}.${sourcePath.split('.').last}';
      final destinationPath = path.join(attachmentsDirectory.path, fileName);

      final savedFile = await sourceFile.copy(destinationPath);
      return savedFile.path;
    } catch (e) {
      throw Exception('Lỗi lưu file đính kèm: $e');
    }
  }

  /// Lưu file vẽ tay (PNG bytes) vào thư mục drawings
  /// Trả về: đường dẫn đầy đủ của file được lưu
  Future<String> saveDrawing(Uint8List imageBytes) async {
    try {
      final drawingsDirectory = await drawingsDir;
      final fileName = 'draw_${DateTime.now().millisecondsSinceEpoch}.png';
      final destinationPath = path.join(drawingsDirectory.path, fileName);

      final file = File(destinationPath);
      await file.writeAsBytes(imageBytes);
      return file.path;
    } catch (e) {
      throw Exception('Lỗi lưu file vẽ tay: $e');
    }
  }

  /// Xóa file theo đường dẫn
  Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Lỗi xóa file: $e');
    }
  }

  /// Xóa tất cả file của một note
  /// Gồm: ảnh, file đính kèm, file vẽ tay
  Future<void> deleteNoteFiles(
    List<String> imageFiles,
    List<String> attachmentFiles,
    List<String> drawingFiles,
  ) async {
    try {
      for (final filePath in imageFiles) {
        await deleteFile(filePath);
      }
      for (final filePath in attachmentFiles) {
        await deleteFile(filePath);
      }
      for (final filePath in drawingFiles) {
        await deleteFile(filePath);
      }
    } catch (e) {
      throw Exception('Lỗi xóa file của note: $e');
    }
  }

  /// Lấy kích thước file theo đường dẫn (bytes)
  Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Lấy tổng kích thước lưu trữ của app
  Future<int> getTotalStorageSize() async {
    try {
      int totalSize = 0;

      // Tính kích thước thư mục images
      final images = await imagesDir;
      if (await images.exists()) {
        await for (final file in images.list(recursive: true)) {
          if (file is File) {
            totalSize += await file.length();
          }
        }
      }

      // Tính kích thước thư mục attachments
      final attachments = await attachmentsDir;
      if (await attachments.exists()) {
        await for (final file in attachments.list(recursive: true)) {
          if (file is File) {
            totalSize += await file.length();
          }
        }
      }

      // Tính kích thước thư mục drawings
      final drawings = await drawingsDir;
      if (await drawings.exists()) {
        await for (final file in drawings.list(recursive: true)) {
          if (file is File) {
            totalSize += await file.length();
          }
        }
      }

      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  /// Kiểm tra file có tồn tại hay không
  Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Format kích thước file thành chuỗi có thể đọc được (B, KB, MB, GB,...)
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    i = i.clamp(0, suffixes.length - 1);
    final size = bytes / pow(1024, i);
    return '${size.toStringAsFixed(2)} ${suffixes[i]}';
  }
}
