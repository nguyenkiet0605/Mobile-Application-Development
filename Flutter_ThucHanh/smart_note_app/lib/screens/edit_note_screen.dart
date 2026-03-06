import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/note.dart';

class EditNoteScreen extends StatefulWidget {
  final Note? note;

  const EditNoteScreen({super.key, this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Note _workingNote;

  // same palette as home screen for consistency
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

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _workingNote = Note(
        id: widget.note!.id,
        title: widget.note!.title,
        content: widget.note!.content,
        timestamp: widget.note!.timestamp,
      );
    } else {
      _workingNote = Note(
        id: const Uuid().v4(),
        title: '',
        content: '',
        timestamp: DateTime.now(),
      );
    }
    _titleController = TextEditingController(text: _workingNote.title);
    _contentController = TextEditingController(text: _workingNote.content);
  }

  void _saveAndPop() {
    // update note fields and timestamp
    _workingNote.title = _titleController.text;
    _workingNote.content = _contentController.text;
    _workingNote.timestamp = DateTime.now();

    // if this was a brand new note and user didn't type anything, don't create it
    if (widget.note == null &&
        _workingNote.title.isEmpty &&
        _workingNote.content.isEmpty) {
      Navigator.of(context).pop(null);
      return;
    }

    Navigator.of(context).pop(_workingNote);
  }

  Future<bool> _onWillPop() async {
    _saveAndPop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.note != null
        ? _cardColor(widget.note!.id)
        : Colors.white;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Soạn ghi chú'),
          backgroundColor: bgColor,
        ),
        body: Container(
          color: bgColor.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Hero(
                  tag: widget.note?.id ?? 'new',
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Tiêu đề',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      hintText: 'Nội dung',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
