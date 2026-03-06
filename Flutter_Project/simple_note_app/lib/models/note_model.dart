/// Model cho Note
class Note {
  String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  /// Danh sách đường dẫn file ảnh (lưu trữ locally)
  List<String> imageFiles;

  /// Danh sách đường dẫn file đính kèm (lưu trữ locally)
  List<String> attachmentFiles;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.imageFiles = const [],
    this.attachmentFiles = const [],
  });

  /// Tạo copy của Note với các thay đổi tùy ý
  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? imageFiles,
    List<String>? attachmentFiles,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageFiles: imageFiles ?? this.imageFiles,
      attachmentFiles: attachmentFiles ?? this.attachmentFiles,
    );
  }

  /// Format ngày để hiển thị
  String getFormattedDate() {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${updatedAt.day}/${updatedAt.month}/${updatedAt.year}';
    }
  }

  /// Preview nội dung (50 ký tự đầu)
  String getPreview() {
    if (content.isEmpty) {
      return '(Không có nội dung)';
    }
    return content.length > 50 ? '${content.substring(0, 50)}...' : content;
  }
}
