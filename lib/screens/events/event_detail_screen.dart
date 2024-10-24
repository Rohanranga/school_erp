import 'dart:io'; // Import this for File
import 'package:flutter/material.dart';
import 'package:school_erp/screens/events/event.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(
              "${event.date.toLocal()}".split(' ')[0],
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              event.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16),
            if (event.mediaUrls != null && event.mediaUrls!.isNotEmpty)
              Column(
                children: event.mediaUrls!.map((imagePath) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.file(
                      File(imagePath), // Use File to load local images
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
