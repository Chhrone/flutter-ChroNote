import 'package:myapp/models/note.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteEditView extends StatefulWidget {
  final Note? note;
  final int? noteIndex;

  const NoteEditView({super.key, this.note, this.noteIndex});

  @override
  State<NoteEditView> createState() => _NoteEditViewState();
}

class _NoteEditViewState extends State<NoteEditView> {
  late TextEditingController _contentController;
  late String _title;
  bool _isPinned = false;
  late Box<Note> notesBox;

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box<Note>('notes');
    _title = widget.note?.title ?? 'Title here';
    _contentController =
        TextEditingController(text: widget.note?.content ?? '');
    _isPinned = false;

    _setupAutoSave();
  }

  void _setupAutoSave() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _saveNote();
        _setupAutoSave();
      }
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final note = Note(
      title: _title,
      content: _contentController.text,
      lastModified: DateTime.now(),
    );

    if (widget.noteIndex != null) {
      notesBox.putAt(widget.noteIndex!, note);
    } else {
      notesBox.add(note);
    }
  }

  Future<void> _showTitleEditDialog() async {
    String newTitle = _title;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Edit title',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter title',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          onChanged: (value) => newTitle = value,
          controller: TextEditingController(text: _title),
          onSubmitted: (value) {
            setState(() => _title = value);
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() => _title = newTitle);
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          onPressed: () {
            _saveNote();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isPinned = !_isPinned;
              });
            },
            icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: Colors.white),
          ),
        ],
        title: GestureDetector(
          onTap: _showTitleEditDialog,
          child: Text(
            _title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      body: TextField(
        controller: _contentController,
        style: const TextStyle(color: Colors.white),
        maxLines: null,
        expands: true,
        decoration: const InputDecoration(
          hintText: 'Start Typing...',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }
}
