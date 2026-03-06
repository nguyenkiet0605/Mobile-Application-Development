import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';

class NoteStorage {
  static const String _kNotesKey = 'notes';

  /// Load list of notes from SharedPreferences. Returns empty list when no data.
  static Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kNotesKey);
    if (jsonString == null) return <Note>[];
    try {
      final List<dynamic> decoded = json.decode(jsonString) as List<dynamic>;
      return decoded
          .map((e) => Note.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // If parsing fails, return empty list to avoid crashing.
      return <Note>[];
    }
  }

  /// Persist the given list of notes into SharedPreferences.
  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(notes.map((n) => n.toJson()).toList());
    await prefs.setString(_kNotesKey, jsonString);
  }
}
