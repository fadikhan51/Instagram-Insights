import 'dart:convert';
import 'package:flutter/material.dart';

class LikedCommentsScreen extends StatelessWidget {

  const LikedCommentsScreen({super.key, required this.jsonData, required this.folderName});

  final String jsonData;
  final String folderName;

  // Function to format the timestamp
  String getFormattedDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }


  @override
  Widget build(BuildContext context) {
    // Decode the JSON data
    final decodedData = jsonDecode(jsonData);
    final likedComments = decodedData['likes_comment_likes'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Comments'),
      ),
      body: ListView.builder(
        itemCount: likedComments.length,
        itemBuilder: (context, index) {
          final comment = likedComments[index];
          final commentData = comment['string_list_data'][0];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Card(
              child: ListTile(
                leading: const Text('👍', style: TextStyle(fontSize: 24.0)),
                title: Text(comment['title']),
                subtitle: Text(getFormattedDate(commentData['timestamp'])),
              ),
            ),
          );
        },
      ),
    );
  }
}
