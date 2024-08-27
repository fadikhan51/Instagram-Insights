import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PostsInsightsScreen extends StatelessWidget {
  const PostsInsightsScreen({super.key, required this.data, required this.folderName});

  final String data;
  final String folderName;

  Future<String> _getAbsolutePath(String uri) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$folderName/$uri';
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> posts = json.decode(data)["organic_insights_posts"];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts Insights'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final postTitle = post['media_map_data']['Media Thumbnail']['title'] ?? '';
          final mediaData = post['media_map_data']['Media Thumbnail'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (postTitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    postTitle,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              FutureBuilder<String>(
                future: _getAbsolutePath(mediaData['uri']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading image');
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (snapshot.hasData)
                          Image.file(
                            File(snapshot.data!),
                            fit: BoxFit.cover,
                          ),
                        if (mediaData['media_metadata'] != null &&
                            mediaData['media_metadata']['photo_metadata'] != null &&
                            mediaData['media_metadata']['photo_metadata']['exif_data'] != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildExifData(
                                mediaData['media_metadata']['photo_metadata']['exif_data']),
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

  Widget _buildExifData(List<dynamic> exifData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: exifData.map((data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.entries.map<Widget>((entry) {
            return Text('${entry.key}: ${entry.value}');
          }).toList(),
        );
      }).toList(),
    );
  }
}
