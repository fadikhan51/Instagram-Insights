import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StoryLikesScreen extends StatelessWidget {
  const StoryLikesScreen({super.key, required this.jsonData, required this.folderName});

  final String jsonData;
  final String folderName;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> storiesJsonData = jsonDecode(jsonData);
    List<dynamic> storyLikes = storiesJsonData['story_activities_story_likes'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Likes'),
      ),
      body: ListView.builder(
        itemCount: storyLikes.length,
        itemBuilder: (context, index) {
          final like = storyLikes[index];
          final title = like['title'];
          final timestamp = like['string_list_data'][0]['timestamp'];
          final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));

          return Card(
            margin: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(title),
              subtitle: Text('Liked at: $formattedTime'),
            ),
          );
        },
      ),
    );
  }
}

