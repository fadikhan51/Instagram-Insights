import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LiveVideoScreen extends StatefulWidget {
  const LiveVideoScreen({super.key, required this.data, required this.folderName});

  final String data;
  final String folderName;

  @override
  _LiveVideoScreenState createState() => _LiveVideoScreenState();
}

class _LiveVideoScreenState extends State<LiveVideoScreen> {

  List<dynamic> insights = [];

  @override
  void initState() {
    super.initState();
    parseJson();
  }

  void parseJson() {
    final Map<String, dynamic> data = json.decode(widget.data);
    insights = data['organic_insights_live'];
  }

  String formatTimestamp(int timestamp) {
    if (timestamp == 0) return "--";
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat.yMMMd().add_jm().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organic Insights Live'),
      ),
      body: ListView.builder(
        itemCount: insights.length,
        itemBuilder: (context, index) {
          final insight = insights[index]['string_map_data'];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Insight #${index + 1}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  for (String key in insight.keys)
                    _buildInsightRow(
                      key,
                      key == "Start Time"
                          ? formatTimestamp(insight[key]['timestamp'])
                          : insight[key]['value'],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInsightRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
