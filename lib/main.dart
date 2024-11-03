import 'package:flutter/material.dart';
import 'screens/note_list_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MySimpleNoteApp());
}



class MySimpleNoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
