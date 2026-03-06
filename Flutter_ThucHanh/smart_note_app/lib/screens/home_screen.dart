import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/note.dart';
import '../services/auth_service.dart';
import '../storage/note_storage.dart';
import 'edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];
  List<Note> _filtered = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  // palette for note cards
  final List<Color> _cardPalette = [
    Colors.yellow.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.pink.shade100,
    Colors.orange.shade100,
  ];

  Color _cardColor(String id) {
    return _cardPalette[id.hashCode % _cardPalette.length];
  }

  // Replace these placeholders with your actual name and student ID.

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(_applyFilter);
  }

  Future<void> _load() async {
    final notes = await NoteStorage.loadNotes();
    setState(() {
      _notes = notes;
      _filtered = notes;
      _isLoading = false;
    });
  }

  void _applyFilter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filtered = List<Note>.from(_notes);
      } else {
        _filtered = _notes
            .where((n) => n.title.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _addOrUpdateNote(Note note, {bool isNew = false}) {
    setState(() {
      if (isNew) {
        _notes.add(note);
      } else {
        final index = _notes.indexWhere((n) => n.id == note.id);
        if (index != -1) {
          _notes[index] = note;
        }
      }
      _applyFilter();
    });
    NoteStorage.saveNotes(_notes);
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn xóa ghi chú này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final ok = await _confirmDelete(context);
        if (ok == true) {
          setState(() {
            _notes.removeWhere((n) => n.id == note.id);
            _applyFilter();
          });
          await NoteStorage.saveNotes(_notes);
        }
        return ok;
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () async {
          final updated = await Navigator.of(context).push<Note>(
            MaterialPageRoute(builder: (_) => EditNoteScreen(note: note)),
          );
          if (updated != null) {
            _addOrUpdateNote(updated);
          }
        },
        child: Hero(
          tag: note.id,
          child: Card(
            color: _cardColor(note.id),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title.isEmpty ? '(Không có tiêu đề)' : note.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note.content,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _formatDate(note.timestamp),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $h:$min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Note'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Đăng xuất'),
                    content: const Text(
                      'Bạn có chắc chắn muốn đăng xuất không?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Đăng xuất'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await AuthService().logout();
                  if (mounted) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text('Đăng xuất'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Tìm kiếm...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _filtered.isEmpty
                      ? _buildEmptyState()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: MasonryGridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            itemCount: _filtered.length,
                            itemBuilder: (ctx, index) {
                              return _buildNoteCard(_filtered[index]);
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = await Navigator.of(context).push<Note>(
            MaterialPageRoute(builder: (_) => const EditNoteScreen()),
          );
          if (newNote != null) {
            _addOrUpdateNote(newNote, isNew: true);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.note_add, size: 120, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            '''Bạn chưa có ghi chú nào,
hãy tạo mới nhé!''',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
