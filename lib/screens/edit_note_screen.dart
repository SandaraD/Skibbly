import 'package:flutter/material.dart';
import 'package:my_simple_notes_cw1a/db/database_helper.dart';
import 'package:my_simple_notes_cw1a/note.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  const EditNoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill the text fields with the note data
    _titleController.text = widget.note.title;
    _contentController.text = widget.note.content;
  }

  Future<void> _updateNote() async {
    // Create a new note object with updated data
    final updatedNote = Note(
      id: widget.note.id,
      title: _titleController.text,
      content: _contentController.text,
    );

    // Update the note in the database
    await DatabaseHelper.instance.updateNote(updatedNote);

    // Go back to the previous screen
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateNote,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

