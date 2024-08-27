import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for timestamp formatting

class ProfileChangesScreen extends StatelessWidget {
  const ProfileChangesScreen({super.key, required this.jsonData, required this.folderName});

  final String jsonData;
  final String folderName;

  String _formatTimestamp(int timestamp) {
    // Format the timestamp using the intl package
    if (timestamp != 0) {
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    final profileChanges = json.decode(jsonData)["profile_profile_change"] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Changes'),
      ),
      body: ListView.builder(
        itemCount: profileChanges.length,
        itemBuilder: (context, index) {
          final changeData = profileChanges[index]['string_map_data'];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Changed: ${changeData["Changed"]["value"]}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    if (changeData["Previous Value"]["value"].isNotEmpty)
                      Text('Previous Value: ${changeData["Previous Value"]["value"]}'),
                    Text('New Value: ${changeData["New Value"]["value"]}'),
                    const SizedBox(height: 8.0),
                    Text(
                      'Change Date: ${_formatTimestamp(changeData["Change Date"]["timestamp"])}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
