import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for timestamp formatting

class AccountInfoScreen extends StatelessWidget {

  const AccountInfoScreen({super.key, required this.jsonData, required this.folderName});

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
    final insightsData = json.decode(jsonData)["profile_account_insights"][0];
    final title = insightsData['title'] ?? '';
    final stringMapData = insightsData['string_map_data'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Insights'),
      ),
      body: Padding(
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
            if (stringMapData.isNotEmpty)
              ...stringMapData.entries.map<Widget>((entry) {
                final timestamp = entry.value['timestamp'];
                final formattedTimestamp = _formatTimestamp(timestamp);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${entry.key}: ${entry.value['value']}'),
                      if (timestamp != 0)
                        Text('Timestamp: $formattedTimestamp'),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
