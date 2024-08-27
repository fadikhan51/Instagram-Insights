import 'dart:convert';
import 'package:flutter/material.dart';

class LikedPostsScreen extends StatelessWidget {
  const LikedPostsScreen({super.key, required this.jsonData, required this.folderName});

  final String jsonData;
  final String folderName;

  // Function to format the timestamp
  String getFormattedDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Decode Unicode string to its emoji
  String decodeUnicode(String input) {
    return String.fromCharCodes(input.codeUnits);
  }

  @override
  Widget build(BuildContext context) {
    final decodedData = jsonDecode(jsonData); // Decode the JSON data
    final likedPosts = decodedData['likes_media_likes'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Posts'), // AppBar title as "Liked Posts"
      ),
      body: ListView.builder(
        itemCount: likedPosts.length,
        itemBuilder: (context, index) {
          final post = likedPosts[index];
          final postData = post['string_list_data'][0];
          const iconEmoji = '👍';
          final formattedDate = getFormattedDate(postData['timestamp']);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Card(
              child: ListTile(
                leading: const Text(
                  iconEmoji, // Display the emoji instead of Icon
                  style: TextStyle(fontSize: 24), // Adjust the font size of emoji
                ),
                title: Text(post['title']),
                subtitle: Text(formattedDate),
              ),
            ),
          );
        },
      ),
    );
  }
}
