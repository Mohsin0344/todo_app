import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  bool completed;
  final Timestamp? timestamp;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    this.timestamp,
  });

  factory Todo.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Todo(
      id: snapshot.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      completed: data['completed'] ?? false,
      timestamp: data['timeStamp'] ?? '',
    );
  }
}