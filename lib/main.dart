import 'package:flutter/material.dart';
import 'package:notes_app/modules/screens/note_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontFamily: "Sans",
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24,
          ),
          bodyMedium: TextStyle(
            fontFamily: "Sans",
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
          bodyLarge: TextStyle(
            fontFamily: "Sans",
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontSize: 18,
          ),
          titleSmall: TextStyle(
            fontFamily: "Sans",
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ),
      home: const NoteListScreen(),
    );
  }
}
