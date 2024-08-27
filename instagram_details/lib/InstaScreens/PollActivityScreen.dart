import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PollActivityScreen extends StatelessWidget {

  const PollActivityScreen({super.key, required this.data, required this.folderName});

  final String data;
  final String folderName;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jsonData = jsonDecode(data);
    List<dynamic> pollActivities = jsonData['story_activities_polls'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Poll Activities'),
      ),
      body: ListView.builder(
        itemCount: pollActivities.length,
        itemBuilder: (context, index) {
          final poll = pollActivities[index];
          final title = poll['title'];
          final pollValue = poll['string_list_data'][0]['value'];
          final timestamp = poll['string_list_data'][0]['timestamp'];
          final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));

          return Card(
            margin: EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Poll: $pollValue'),
                  Text('Voted at: $formattedTime'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

