import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for timestamp formatting
import 'package:path_provider/path_provider.dart';

class ProfileInfoScreen extends StatelessWidget {

  const ProfileInfoScreen({super.key, required this.jsonData, required this.folderName});

  final String jsonData;
  final String folderName;

  Future<String> _getAbsolutePath(String uri) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$folderName/$uri';
  }

  String _formatTimestamp(int timestamp) {
    // Format the timestamp using intl package
    if (timestamp != 0) {
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final profileData = json.decode(jsonData.replaceAll(RegExp(r"[\x00-\x1F\u0080-\uFFFF]"), "").replaceAll('\\\"', ''))["profile_user"][0];

    final title = profileData['title'] ?? '';
    final mediaMapData = profileData['media_map_data'] ?? {};
    final stringMapData = profileData['string_map_data'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title.isNotEmpty)
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 16.0),
              if (mediaMapData.isNotEmpty)
                FutureBuilder<String>(
                  future: _getAbsolutePath(mediaMapData['Profile Photo']['uri']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('Error loading profile photo');
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (snapshot.hasData)
                            Image.file(
                              File(snapshot.data!),
                              fit: BoxFit.cover,
                            ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Created on: ${_formatTimestamp(mediaMapData['Profile Photo']['creation_timestamp'])}',
                          ),
                        ],
                      );
                    }
                  },
                ),
              const SizedBox(height: 16.0),
              if (stringMapData.isNotEmpty)
                ...stringMapData.entries.map<Widget>((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('${entry.key}: ${entry.value['value']}'),
                  );
                }).toList(),
            ],
          ),
        ),
      )
    );
  }
}
