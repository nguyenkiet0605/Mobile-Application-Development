import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../screens/add_note_screen.dart';
import '../widgets/note_card.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  // Danh sách ghi chú
  final List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    // Thêm vài ghi chú mẫu
    _notes.addAll([
      Note(
        id: '1',
        title: '📱 Dự án Flutter',
        content:
            'Cần hoàn thành Simple Note App với các tính năng: thêm, sửa, xóa ghi chú. Áp dụng Material Design 3 và animation.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Note(
        id: '2',
        title: '✨ Học tập',
        content: 'Tìm hiểu về Navigation và Data Passing trong Flutter',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Note(
        id: '3',
        title: '🎯 Mục tiêu',
        content: 'Thành thạo Flutter và xây dựng ứng dụng chất lượng',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);
  }

  /// Thêm ghi chú mới
  void _addNote() async {
    final result = await Navigator.push<Note?>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddNotePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
      ),
    );

    if (result != null) {
      setState(() {
        _notes.insert(0, result);
      });
      _showSnackBar('✅ Ghi chú mới được lưu');
    }
  }

  /// Sửa ghi chú
  void _editNote(Note note) async {
    final result = await Navigator.push<Note?>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddNotePage(noteToEdit: note),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
      ),
    );

    if (result != null) {
      setState(() {
        final index = _notes.indexWhere((n) => n.id == note.id);
        if (index != -1) {
          _notes[index] = result;
        }
      });
      _showSnackBar('✏️ Ghi chú đã được cập nhật');
    }
  }

  /// Xóa ghi chú
  void _deleteNote(Note note) {
    setState(() {
      _notes.removeWhere((n) => n.id == note.id);
    });
    _showSnackBar('🗑️ Ghi chú đã được xóa');
  }

  /// Hiển thị thông báo
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF6366F1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async => await _auth.signOut(),
        ),
        title: const Text(
          '📝 My Notes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 8,
        shadowColor: const Color(0xFF6366F1).withOpacity(0.3),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_notes.length} ghi chú',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFFF0F4FF), Colors.white.withOpacity(0.95)],
          ),
        ),
        child: _notes.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE0E7FF),
                      ),
                      child: const Icon(
                        Icons.note_outlined,
                        size: 64,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '📝 Không có ghi chú',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tạo ghi chú đầu tiên của bạn',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 12, bottom: 100),
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return NoteCard(
                    note: note,
                    onTap: () => _editNote(note),
                    onEdit: () => _editNote(note),
                    onDelete: () => _deleteNote(note),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Thêm ghi chú',
        backgroundColor: const Color(0xFF6366F1),
        elevation: 8,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
