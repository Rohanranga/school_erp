import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  const EventDetailScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  VideoPlayerController? _videoController;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('events')
            .doc(widget.eventId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Event not found.'));
          }

          var eventData = snapshot.data!.data() as Map<String, dynamic>;
          String title = eventData['title'] ?? 'No Title';
          String date = eventData['date'] ?? 'No Date';
          String description = eventData['description'] ?? 'No Description';
          List<dynamic> mediaUrls = eventData['mediaUrls'] ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: $date',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                // Display all mediaUrls (image, video, file)
                Expanded(
                  child: ListView.builder(
                    itemCount: mediaUrls.length,
                    itemBuilder: (context, index) {
                      return _buildMediaWidget(mediaUrls[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper method to determine media type and build widget accordingly
  Widget _buildMediaWidget(String mediaUrl) {
    if (isImage(mediaUrl)) {
      return Center(
          child: Image.network(
        mediaUrl,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Center(child: Text('Failed to load image'));
        },
      ));
    } else if (isVideo(mediaUrl)) {
      _videoController = VideoPlayerController.network(mediaUrl)
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();
        });
      return Center(
        child: _videoController?.value.isInitialized ?? false
            ? AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              )
            : const CircularProgressIndicator(),
      );
    } else {
      // For files (PDFs, documents, etc.)
      return Center(
        child: Column(
          children: [
            const Icon(Icons.insert_drive_file, size: 100),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                if (await canLaunch(mediaUrl)) {
                  await launch(mediaUrl); // Open the file URL
                } else {
                  throw 'Could not launch $mediaUrl';
                }
              },
              child: const Text('Open File'),
            ),
          ],
        ),
      );
    }
  }

  // Helper methods to check media type
  bool isImage(String url) {
    return url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.png') ||
        url.endsWith('.gif');
  }

  bool isVideo(String url) {
    return url.endsWith('.mp4') ||
        url.endsWith('.mov') ||
        url.endsWith('.avi') ||
        url.endsWith('.mkv');
  }
}
