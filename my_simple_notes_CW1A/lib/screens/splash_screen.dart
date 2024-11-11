import 'dart:async';
import 'package:flutter/material.dart';
import 'note_list_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Automatically navigate to NoteListScreen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NoteListScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Scribbly",
              style: TextStyle(
                fontFamily: 'Joti_One', // Ensure the font is correctly loaded
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.cyan[700],
              ),
            ),
            SizedBox(height: 30),
            Image.asset(
              'assets/images/Add notes-pana.png', // Adjust path if needed
              width: 350,
              height: 350,
            ),
            SizedBox(height: 30),
            Text(
              'Ideas in mind? Let’s note them!',
              style: TextStyle(fontSize: 24, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: Colors.cyan[700],
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}

