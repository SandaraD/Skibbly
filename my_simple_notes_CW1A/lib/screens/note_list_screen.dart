
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import provider package

import '../db/database_helper.dart';
import '../model/note.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';
import 'note_detail_screen.dart';
import '../provider/theme_provider.dart'; // Import your theme provider

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> notes = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final data = await DatabaseHelper.instance.getNotes();
    setState(() {
      notes = data;
    });
  }

  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('yMMMd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final filteredNotes = notes.where((note) {
      return note.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            // Search Bar
            TextField(
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search notes by title',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: themeProvider.toggleTheme, // Toggle theme using provider
                  icon: Icon(themeProvider.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                      color: Colors.cyan[50]),
                  label: Text('Toggle Theme'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan[700],
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 1),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddNoteScreen()),
                    );
                    if (result == true) {
                      _loadNotes();
                    }
                  },
                  icon: Icon(Icons.add, color: Colors.black),
                  label: Text('Add Note'),
                ),
              ],
            ),
            // Notes List
            Expanded(
              child: filteredNotes.isEmpty
                  ? Center(child: Text('No notes available'))
                  : ListView.builder(
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = filteredNotes[index];
                  return Card(
                    color: Theme.of(context).cardColor,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${formatDate(note.dateCreated)}',
                            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                          ),
                          SizedBox(height: 4),
                          Text(
                            note.title,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        note.content.split('.').first + "...",
                        maxLines: 1,
                        style: TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteDetailScreen(note: note),
                          ),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.teal[500]),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditNoteScreen(note: note),
                                ),
                              ).then((_) => _loadNotes());
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              bool? confirmDelete = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white, // Set the dialog background to white
                                    title: Text(
                                      'Confirm Delete',
                                      style: TextStyle(color: Colors.black), // Set title color to black
                                    ),
                                    content: Text(
                                      'Are you sure you want to delete this note?',
                                      style: TextStyle(color: Colors.black), // Set content color to black
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.black), // Set button text color to black
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop(false); // Dismiss the dialog
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(color: Colors.black), // Set button text color to black
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop(true); // Confirm delete
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmDelete == true) {
                                await DatabaseHelper.instance.deleteNote(note.id!);
                                _loadNotes(); // Reload notes to update the list

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Note deleted successfully!',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2), // Duration for how long the SnackBar should be shown
                                  ),
                                );
                              }
                            },
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}