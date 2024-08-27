import 'dart:convert';
import 'package:flutter/material.dart';

class AccountsReachScreen extends StatefulWidget {
  const AccountsReachScreen({super.key, required this.data, required this.folderName});

  final String data;
  final String folderName;

  @override
  _AccountsReachScreenState createState() => _AccountsReachScreenState();
}

class _AccountsReachScreenState extends State<AccountsReachScreen> {

  List<dynamic> reachInsights = [];

  @override
  void initState() {
    super.initState();
    parseJson();
  }

  void parseJson() {
    final Map<String, dynamic> Accdata = json.decode(widget.data);
    reachInsights = Accdata['organic_insights_reach'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts Reach Insights'),
      ),
      body: ListView.builder(
        itemCount: reachInsights.length,
        itemBuilder: (context, index) {
          final insight = reachInsights[index]['string_map_data'];
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
                  _buildInsightRow('Accounts Reached', insight['Accounts Reached']['value']),
                  _buildInsightRow('Accounts Reached Delta', insight['Accounts Reached Delta']['value']),
                  _buildInsightRow('Followers', insight['Followers']['value']),
                  _buildInsightRow('Non-Followers', insight['Non-Followers']['value']),
                  _buildInsightRow('Non-Followers Delta', insight['Non-Followers Delta']['value']),
                  _buildInsightRow('Impressions', insight['Impressions']['value']),
                  _buildInsightRow('Impressions Delta', insight['Impressions Delta']['value']),
                  _buildInsightRow('Profile visits', insight['Profile visits']['value']),
                  _buildInsightRow('Profile Visits Delta', insight['Profile Visits Delta']['value']),
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
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
