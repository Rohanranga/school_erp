import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final String description;
  final DateTime date;
  final String? imageUrl; // Add this line

  Event({
    required this.title,
    required this.description,
    required this.date,
    this.imageUrl, // Add this line
  });

  factory Event.fromMap(Map<String, dynamic> data) {
    return Event(
      title: data['title'],
      description: data['description'],
      date: (data['date'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'], // Add this line
    );
  }
}
