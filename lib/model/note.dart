import 'package:intl/intl.dart';

class Note {
  final int? id;
  final String title;
  final String content;
  final String dateCreated;

  Note({
    this.id,
    required this.title,
    required this.content,
    String? dateCreated,
  }) : dateCreated = dateCreated ?? DateFormat('yyyy-MM-dd').format(DateTime.now());

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dateCreated': dateCreated,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      dateCreated: map['dateCreated'],
    );
  }
}
