import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final String description;
  final DateTime date;
  final List<String>? mediaUrls; // Assume mediaUrls is a list

  Event({
    required this.title,
    required this.description,
    required this.date,
    this.mediaUrls,
  });

  factory Event.fromMap(Map<String, dynamic> data) {
    return Event(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      mediaUrls: List<String>.from(data['mediaUrls'] ?? []), // List of URLs
    );
  }
}
