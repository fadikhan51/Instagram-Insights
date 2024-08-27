import 'dart:convert';
import 'package:flutter/material.dart';

class ContentInteractionScreen extends StatelessWidget {
  const ContentInteractionScreen({super.key, required this.jsonData, required this.folderName});

  final String jsonData;
  final String folderName;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = jsonDecode(jsonData);
    List<dynamic> insightsList = data["organic_insights_interactions"] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: insightsList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> stringMapData =
                insightsList[index]["string_map_data"] ?? {};

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date Range: ${getValue(stringMapData, 'Date Range')}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  buildDataRow('Content Interactions', getValue(stringMapData, 'Content Interactions')),
                  buildDataRow('Content Interactions Delta', getValue(stringMapData, 'Content Interactions Delta')),
                  buildDataRow('Post Interactions', getValue(stringMapData, 'Post Interactions')),
                  buildDataRow('Post Interactions Delta', getValue(stringMapData, 'Post Interactions Delta')),
                  buildDataRow('Story Interactions', getValue(stringMapData, 'Story Interactions')),
                  buildDataRow('Story Interactions Delta', getValue(stringMapData, 'Story Interactions Delta')),
                  buildDataRow('Video Interactions', getValue(stringMapData, 'Video Interactions')),
                  buildDataRow('Video Interactions Delta', getValue(stringMapData, 'Video Interactions Delta')),
                  buildDataRow('Reels Interactions', getValue(stringMapData, 'Reels Interactions')),
                  buildDataRow('Reels Interactions Delta', getValue(stringMapData, 'Reels Interactions Delta')),
                  buildDataRow('Live Video Interactions', getValue(stringMapData, 'Live Video Interactions')),
                  buildDataRow('Live Video Interactions Delta', getValue(stringMapData, 'Live Video Interactions Delta')),
                  buildDataRow('Accounts Engaged', getValue(stringMapData, 'Accounts engaged')),
                  buildDataRow('Accounts Engaged Delta', getValue(stringMapData, 'Accounts Engaged Delta')),
                  buildDataRow(
                    'You engaged delta% more accounts that weren’t following you compared to previous period',
                    getValue(stringMapData, "You engaged delta% more accounts that weren’t following you compared to previous period"),
                  ),
                  const Divider(thickness: 2),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String getValue(Map<String, dynamic> stringMapData, String key) {
    return stringMapData[key]?['value'] ?? '';
  }

  Widget buildDataRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
