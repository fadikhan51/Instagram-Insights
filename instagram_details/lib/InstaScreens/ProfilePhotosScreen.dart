import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the timestamp
import 'package:path_provider/path_provider.dart';

class ProfilePhotosScreen extends StatelessWidget {
  const ProfilePhotosScreen({super.key, required this.jsonData, required this.folderName});

  final String jsonData;
  final String folderName;

  Future<String> _getAbsolutePath(String uri) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$folderName/$uri';
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> profiles = json.decode(jsonData.replaceAll(RegExp(r"[\x00-\x1F\u0080-\uFFFF]"), "").replaceAll('\\\"', ''))["ig_profile_picture"];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Pictures'),
      ),
      body: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          final profileTitle = profile['title'] ?? '';
          final isProfilePicture = profile['is_profile_picture'] ?? false;
          final creationTimestamp = _formatTimestamp(profile['creation_timestamp']);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (profileTitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    profileTitle,
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
                    color: Colors.black,
                  ),
                ),
              ),
              FutureBuilder<String>(
                future: _getAbsolutePath(profile['uri']),
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
                        if (isProfilePicture)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Profile Picture',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (profile['media_metadata'] != null &&
                            profile['media_metadata']['camera_metadata'] !=
                                null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildCameraMetadata(
                                profile['media_metadata']['camera_metadata']),
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

  Widget _buildCameraMetadata(Map<String, dynamic> cameraMetadata) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cameraMetadata.entries.map<Widget>((entry) {
        return Text('${entry.key}: ${entry.value}');
      }).toList(),
    );
  }
}
