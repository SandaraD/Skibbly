// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../db/database_helper.dart';
// import '../note.dart';
// import 'add_note_screen.dart';
// import 'edit_note_screen.dart';
// import 'note_detail_screen.dart';
//
// class NoteListScreen extends StatefulWidget {
//   @override
//   _NoteListScreenState createState() => _NoteListScreenState();
// }
//
// class _NoteListScreenState extends State<NoteListScreen> {
//   List<Note> notes = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadNotes();
//   }
//
//   Future<void> _loadNotes() async {
//     final data = await DatabaseHelper.instance.getNotes();
//     setState(() {
//       notes = data;
//     });
//   }
//
//   // Formatting date outside _loadNotes for accessibility
//   String formatDate(String dateString) {
//     DateTime date = DateTime.parse(dateString);
//     return DateFormat('yMMMd').format(date);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('MySimpleNote'),
//         backgroundColor: Colors.amber[600],
//       ),
//       body: notes.isEmpty
//           ? Center(child: Text('No notes available'))
//           : ListView.builder(
//         itemCount: notes.length,
//         itemBuilder: (context, index) {
//           final note = notes[index];
//           return Card(
//             color: Colors.amber[50],
//             margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             child: ListTile(
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '${formatDate(note.dateCreated)}',
//                     style: TextStyle(fontSize: 15, color: Colors.grey[600]),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     note.title,
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                   ),
//                 ],
//               ),
//               subtitle: Text(
//                 note.content.split('.').first + "...",
//                 maxLines: 1,
//                 style: TextStyle(fontSize: 18),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => NoteDetailScreen(note: note),
//                   ),
//                 );
//               },
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.edit, color: Colors.teal[900]),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EditNoteScreen(note: note),
//                         ),
//                       ).then((_) => _loadNotes());
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete, color: Colors.red),
//                     onPressed: () async {
//                       await DatabaseHelper.instance.deleteNote(note.id!);
//                       _loadNotes();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.amber[600],
//         foregroundColor: Colors.cyan[900],
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddNoteScreen()),
//           );
//
//           if (result == true) {
//             _loadNotes();
//           }
//         },
//         child: Icon(Icons.add),
//         tooltip: 'Add Note',
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/database_helper.dart';
import '../note.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';
import 'note_detail_screen.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> notes = [];
  String searchQuery = '';
  ThemeMode themeMode = ThemeMode.light;

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

  void _toggleTheme() {
    setState(() {
      themeMode =
      themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = notes.where((note) {
      return note.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: Scaffold(
    body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Greeting Message
    // Text(
    //   'Hey ${widget.userName}! Ideas in mind? Let’s note them!',
    //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, ),
    // ),
    SizedBox(height: 15),

    // Search Bar
    TextField(
    onChanged: (value) {
    setState(() {
    searchQuery = value;
    });
    },
    decoration: InputDecoration(
    labelText: 'Search notes by title',
    filled: true,
    fillColor: Colors.grey[100],
    border: InputBorder.none,
    suffixIcon: Icon(Icons.search),
    ),
    ),
    SizedBox(height: 1),
    Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
    ElevatedButton.icon(
    onPressed: _toggleTheme,
    icon: Icon(Icons.dark_mode, color: Colors.cyan[50]),
    label: Text('Theme'),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.cyan[700],
      foregroundColor: Colors.white
    ),
    ),

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
    style: ElevatedButton.styleFrom(
    // primary: Colors.amber[600],
    ),
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
    color: Colors.teal[50],
    margin: EdgeInsets.symmetric(vertical: 10),
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
    await DatabaseHelper.instance.deleteNote(note.id!);
    _loadNotes();
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
    // floatingActionButton: FloatingActionButton(
    //   backgroundColor: Colors.amber[600],
    //   foregroundColor: Colors.cyan[900],
    //   onPressed: () async {
    //     final result = await Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => AddNoteScreen()),
    //     );
    //
    //     if (result == true) {
    //       _loadNotes();
    //     }
    //   },
    //   child: Icon(Icons.add),
    //   tooltip: 'Add Note',
    // ),
    )
    );
  }
}
