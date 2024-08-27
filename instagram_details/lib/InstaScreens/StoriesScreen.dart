import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key, required this.jsonData, required this.folderName});

  final String jsonData;
  final String folderName;

  Future<String> _getAbsolutePath(String? uri) async {
    if (uri == null) return ''; // Return an empty path if URI is null
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$folderName/$uri';
  }

  String _formatTimestamp(int? timestamp) {
    if (timestamp == null) return ''; // Return empty string if timestamp is null
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> stories = json.decode(jsonData)["ig_stories"] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Stories'),
      ),
      body: ListView.builder(
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          final storyTitle = story['title'] ?? '';
          final creationTimestamp = _formatTimestamp(story['creation_timestamp']);
          final mediaMetadata = story['media_metadata'] ?? {};

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (storyTitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    storyTitle,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Timestamp: $creationTimestamp',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              FutureBuilder<String>(
                future: _getAbsolutePath(story['uri']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                    return const Text('Error loading image');
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (snapshot.hasData && snapshot.data!.isNotEmpty)
                          Image.file(
                            File(snapshot.data!),
                            fit: BoxFit.cover,
                          ),
                        if (mediaMetadata['photo_metadata'] != null &&
                            mediaMetadata['photo_metadata']['exif_data'] != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildExifData(mediaMetadata['photo_metadata']['exif_data']),
                          ),
                      ],
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildExifData(List<dynamic>? exifData) {
    if (exifData == null) return const SizedBox(); // Return empty widget if exifData is null
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: exifData.map((data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (data as Map<String, dynamic>).entries.map<Widget>((entry) {
            return Text('${entry.key}: ${entry.value}');
          }).toList(),
        );
      }).toList(),
    );
  }
}
