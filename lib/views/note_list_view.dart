import 'package:myapp/views/note_edit_view.dart';
import 'package:myapp/models/note.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({super.key});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  late Box<Note> notesBox;

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box<Note>('notes');
  }

  void _openNoteEditor({Note? note, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NoteEditView(
                note: note,
                noteIndex: index,
              )),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          'ChroNote',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: notesBox.listenable(),
          builder: (context, Box<Note> box, _) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: box.length,
              itemBuilder: (context, index) {
                final note = box.getAt(index);
                if (note == null) return const SizedBox.shrink();

                return InkWell(
                  onTap: () => _openNoteEditor(note: note, index: index),
                  child: Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            note.content,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _formatDateTime(note.lastModified),
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[700],
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _openNoteEditor(),
      ),
    );
  }
}
