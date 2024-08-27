import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key, required this.jsonData, required this.folderName});

  final String jsonData;
  final String folderName;

  Future<String> _getAbsolutePath(String uri) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$folderName/$uri';
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> posts = json.decode(jsonData.replaceAll(RegExp(r"[\x00-\x1F\u0080-\uFFFF]"), "").replaceAll('\\\"', ''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final postTitle = post['title'] ?? '';
          final mediaList = post['media'] as List<dynamic>;

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
              ...mediaList.map((media) => FutureBuilder<String>(
                future: _getAbsolutePath(media['uri']),
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
                        if (media['media_metadata'] != null &&
                            media['media_metadata']
                            ['photo_metadata'] != null &&
                            media['media_metadata']['photo_metadata']
                            ['exif_data'] !=
                                null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildExifData(
                                media['media_metadata']['photo_metadata']
                                ['exif_data']),
                          ),
                      ],
                    );
                  }
                },
              )),
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
