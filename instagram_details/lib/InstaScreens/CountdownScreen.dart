import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CountdownActivityScreen extends StatelessWidget {
  const CountdownActivityScreen({super.key, required this.data, required this.folderName});

  final String data;
  final String folderName;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jsonData = jsonDecode(data);
    List<dynamic> countdownActivities = jsonData['story_activities_countdowns'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown Activities'),
      ),
      body: ListView.builder(
        itemCount: countdownActivities.length,
        itemBuilder: (context, index) {
          final activity = countdownActivities[index];
          final title = activity['title'];
          final timestamp = activity['string_list_data'][0]['timestamp'];
          final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));

          return Card(
            margin: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(title),
              subtitle: Text('Countdown at: $formattedTime'),
            ),
          );
        },
      ),
    );
  }
}