import 'package:myapp/views/note_list_view.dart';
import 'package:myapp/models/note.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register adapter
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());

  // Open the notes box
  await Hive.openBox<Note>('notes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChroNote',
      theme: ThemeData(
        // Adding dark theme to match the design
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
      ),
      home: const NoteListView(),
    );
  }
}
