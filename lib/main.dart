import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/note_list_screen.dart';
import 'screens/splash_screen.dart';
import 'provider/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MySimpleNoteApp(),
    ),
  );
}

class MySimpleNoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: themeProvider.getTheme(),
      themeMode: themeProvider.themeMode,
      home: SplashScreen(),
    );
  }
}
