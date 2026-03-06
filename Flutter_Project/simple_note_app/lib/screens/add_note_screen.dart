import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/note_model.dart';
import '../services/storage_service.dart';
import '../widgets/drawing_board_screen.dart';

class AddNotePage extends StatefulWidget {
  final Note? noteToEdit;

  const AddNotePage({Key? key, this.noteToEdit}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage>
    with SingleTickerProviderStateMixin {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  final ImagePicker _imagePicker = ImagePicker();
  late List<String> _imageFiles = [];
  late List<String> _attachmentFiles = [];
  late List<String> _drawingFiles = [];

  @override
  void initState() {
    super.initState();

    // Khởi tạo animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    // Khởi tạo controllers
    _titleController = TextEditingController(
      text: widget.noteToEdit?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.noteToEdit?.content ?? '',
    );

    // Khởi tạo file lists
    _imageFiles = List.from(widget.noteToEdit?.imageFiles ?? []);
    _attachmentFiles = List.from(widget.noteToEdit?.attachmentFiles ?? []);
    _drawingFiles = List.from(widget.noteToEdit?.drawingFiles ?? []);

    // Bắt đầu animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Lưu note và quay lại
  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tiêu đề hoặc nội dung')),
      );
      return;
    }

    final now = DateTime.now();
    final note = Note(
      id: widget.noteToEdit?.id ?? DateTime.now().toString(),
      title: title.isEmpty ? 'Ghi chú không tiêu đề' : title,
      content: content,
      createdAt: widget.noteToEdit?.createdAt ?? now,
      updatedAt: now,
      imageFiles: _imageFiles,
      attachmentFiles: _attachmentFiles,
      drawingFiles: _drawingFiles,
    );

    Navigator.pop(context, note);
  }

  /// Chọn ảnh từ thư viện
  void _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final savedPath = await StorageService().saveImage(pickedFile.path);
        setState(() {
          _imageFiles.add(savedPath);
        });
        _showSnackBar('✅ Ảnh đã được thêm');
      }
    } catch (e) {
      _showSnackBar('❌ Lỗi: $e');
    }
  }

  /// Chụp ảnh từ camera
  void _capturePhoto() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final savedPath = await StorageService().saveImage(pickedFile.path);
        setState(() {
          _imageFiles.add(savedPath);
        });
        _showSnackBar('✅ Ảnh chụp đã được lưu');
      }
    } catch (e) {
      _showSnackBar('❌ Lỗi: $e');
    }
  }

  /// Chọn file đính kèm
  void _pickFile() async {
    try {
      final pickedFile = await _imagePicker.pickMedia();

      if (pickedFile != null) {
        final savedPath = await StorageService().saveAttachment(
          pickedFile.path,
        );
        setState(() {
          _attachmentFiles.add(savedPath);
        });
        _showSnackBar('✅ File đã được thêm');
      }
    } catch (e) {
      _showSnackBar('❌ Lỗi: $e');
    }
  }

  /// Mở bảng vẽ tay
  void _openDrawingBoard() async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (context) => const DrawingBoardScreen(title: '✏️ Vẽ Tay'),
      ),
    );

    if (result != null) {
      try {
        final savedPath = await StorageService().saveDrawing(result);
        setState(() {
          _drawingFiles.add(savedPath);
        });
        _showSnackBar('✅ Bản vẽ đã được lưu');
      } catch (e) {
        _showSnackBar('❌ Lỗi lưu bản vẽ: $e');
      }
    }
  }

  /// Xóa ảnh
  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
    _showSnackBar('🗑️ Ảnh đã xóa');
  }

  /// Xóa file đính kèm
  void _removeAttachment(int index) {
    setState(() {
      _attachmentFiles.removeAt(index);
    });
    _showSnackBar('🗑️ File đã xóa');
  }

  /// Xóa bản vẽ
  void _removeDrawing(int index) {
    setState(() {
      _drawingFiles.removeAt(index);
    });
    _showSnackBar('🗑️ Bản vẽ đã xóa');
  }

  /// Hiển thị thông báo
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.noteToEdit != null;

    return SlideTransition(
      position: _slideAnimation,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? '✏️ Sửa ghi chú' : '✨ Ghi chú mới'),
          centerTitle: true,
          elevation: 8,
          shadowColor: const Color(0xFF6366F1).withOpacity(0.3),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFFF0F4FF), Colors.white.withOpacity(0.95)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Tiêu đề
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Tiêu đề...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0E7FF),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0E7FF),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF6366F1),
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.title,
                        color: Color(0xFF6366F1),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Nội dung
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: 'Nội dung ghi chú...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0E7FF),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0E7FF),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF6366F1),
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.description,
                        color: Color(0xFF6366F1),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Thanh công cụ thêm file/ảnh/vẽ tay
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        // Nút thêm ảnh từ thư viện
                        _buildActionButton(
                          icon: Icons.image,
                          label: 'Ảnh',
                          onPressed: _pickImage,
                          color: Colors.blue,
                        ),
                        // Nút chụp ảnh camera
                        _buildActionButton(
                          icon: Icons.camera_alt,
                          label: 'Chụp',
                          onPressed: _capturePhoto,
                          color: Colors.orange,
                        ),
                        // Nút thêm file
                        _buildActionButton(
                          icon: Icons.attach_file,
                          label: 'File',
                          onPressed: _pickFile,
                          color: Colors.purple,
                        ),
                        // Nút vẽ tay
                        _buildActionButton(
                          icon: Icons.edit,
                          label: 'Vẽ',
                          onPressed: _openDrawingBoard,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Hiển thị ảnh
                if (_imageFiles.isNotEmpty)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🖼️ Ảnh (${_imageFiles.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _imageFiles.length,
                            itemBuilder: (context, index) {
                              return _buildFilePreview(
                                file: _imageFiles[index],
                                onRemove: () => _removeImage(index),
                                isImage: true,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                // Hiển thị file đính kèm
                if (_attachmentFiles.isNotEmpty)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📎 File (${_attachmentFiles.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _attachmentFiles.length,
                            itemBuilder: (context, index) {
                              return _buildFileItem(
                                file: _attachmentFiles[index],
                                onRemove: () => _removeAttachment(index),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                // Hiển thị bản vẽ
                if (_drawingFiles.isNotEmpty)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '✏️ Bản vẽ (${_drawingFiles.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _drawingFiles.length,
                            itemBuilder: (context, index) {
                              return _buildFilePreview(
                                file: _drawingFiles[index],
                                onRemove: () => _removeDrawing(index),
                                isImage: true,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: Color(0xFF6366F1),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Hủy',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _saveNote,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isEditing ? 'Cập nhật' : 'Lưu',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Xây dựng nút hành động
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(8),
              minimumSize: const Size(48, 48),
            ),
            child: Icon(icon, size: 20),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  /// Xây dựng preview file ảnh
  Widget _buildFilePreview({
    required String file,
    required VoidCallback onRemove,
    required bool isImage,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          if (isImage)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(File(file)),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image_not_supported),
            ),
          Positioned(
            top: -8,
            right: -8,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Xây dựng mục file đính kèm
  Widget _buildFileItem({
    required String file,
    required VoidCallback onRemove,
  }) {
    final fileName = file.split('/').last;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_file, color: Colors.purple),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fileName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: onRemove,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
