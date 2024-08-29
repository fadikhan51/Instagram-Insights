import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class StoryLikesScreen extends StatelessWidget {
  const StoryLikesScreen({
    super.key,
    required this.jsonData,
    required this.folderName,
  });

  final String jsonData;
  final String folderName;

  List<dynamic> _parseJsonData() {
    try {
      final decodedJson = json.decode(jsonData);
      return decodedJson['story_activities_story_likes'] as List<dynamic>? ?? [];
    } catch (e) {
      // If JSON parsing fails, return an empty list
      return [];
    }
  }

  int _countLikes(String username, List<dynamic> data) {
    return data.where((item) => item['title'] == username).length;
  }

  Future<void> _launchURL(BuildContext context, String? url) async {
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Don\'t have the URL information')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final storyLikesData = _parseJsonData();

    // Create a map to aggregate likes by username
    final Map<String, Map<String, dynamic>> userLikesMap = {};

    for (var likeData in storyLikesData) {
      final String? username = likeData['title'] as String?;
      final List<dynamic>? stringListData = likeData['string_list_data'] as List<dynamic>?;

      if (username != null && stringListData != null && stringListData.isNotEmpty) {
        final int? timestamp = stringListData[0]['timestamp'] as int?;

        if (userLikesMap.containsKey(username)) {
          // Update the most recent timestamp if necessary
          if (timestamp != null && timestamp > userLikesMap[username]!['timestamp']) {
            userLikesMap[username]!['timestamp'] = timestamp;
          }
        } else {
          // Initialize the entry for a new username
          userLikesMap[username] = {
            'likeCount': _countLikes(username, storyLikesData),
            'timestamp': timestamp ?? 0,
          };
        }
      }
    }

    // Convert map to a list and sort by like count in descending order
    final userLikes = userLikesMap.entries.map((entry) {
      return {
        'username': entry.key,
        'likeCount': entry.value['likeCount'],
        'timestamp': entry.value['timestamp']
      };
    }).toList()
      ..sort((a, b) => b['likeCount'].compareTo(a['likeCount']));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Likes'),
      ),
      body: ListView.builder(
        itemCount: userLikes.length,
        itemBuilder: (context, index) {
          final String username = userLikes[index]['username'];
          final int likeCount = userLikes[index]['likeCount'];
          final int timestamp = userLikes[index]['timestamp'];

          final String formattedDate;
          if (timestamp != 0) {
            final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
            formattedDate = DateFormat('d MMM yyyy').format(date);
          } else {
            formattedDate = 'Unknown date'; // Placeholder for null timestamp
          }

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                username.isNotEmpty ? username[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(username),
            subtitle: Text('Likes: $likeCount'),
            trailing: Text('Last story liked on\n$formattedDate', textAlign: TextAlign.right,), // Updated subtitle format
          );
        },
      ),
    );
  }
}
