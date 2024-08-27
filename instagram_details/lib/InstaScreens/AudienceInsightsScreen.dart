import 'dart:convert';
import 'package:flutter/material.dart';

class AudienceInsightsScreen extends StatefulWidget {
  const AudienceInsightsScreen({super.key, required this.AudienceData, required this.folderName});

  final String AudienceData;
  final String folderName;
  @override
  _AudienceInsightsScreenState createState() => _AudienceInsightsScreenState();
}

class _AudienceInsightsScreenState extends State<AudienceInsightsScreen> {

  List<dynamic> insights = [];

  @override
  void initState() {
    super.initState();
    parseJson();
  }

  void parseJson() {
    final Map<String, dynamic> data = json.decode(widget.AudienceData);
    insights = data['organic_insights_audience'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audience Insights'),
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
                  _buildInsightRow('Date Range', insight['Date Range']['value']),
                  _buildInsightRow('Followers', insight['Followers']['value']),
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
