import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../model/note.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      // Display an alert if title or content is missing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in both title and content')),
      );
      return;
    }

    // Create a new Note object and save it to the database
    final newNote = Note(
      title: _titleController.text,
      content: _contentController.text,
    );

    await DatabaseHelper.instance.addNote(newNote);

    // Go back to the previous screen and refresh the list of notes
    Navigator.pop(context, true); // Passing true to signal a refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
        backgroundColor: Colors.teal[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
                style: TextStyle(fontSize: 22)
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 4,
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[100],
                foregroundColor: Colors.black// Sets the button color to blue
              ),
              child: Text('Save Note'),
            )
          ],
        ),
      ),
    );
  }
}
