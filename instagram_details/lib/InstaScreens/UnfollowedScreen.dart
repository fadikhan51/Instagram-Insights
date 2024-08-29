import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class UnfollowedScreen extends StatelessWidget {
  const UnfollowedScreen({
    super.key,
    required this.jsonData,
    required this.folderName,
  });

  final String jsonData;
  final String folderName;

  Map<String, dynamic> _parseJsonData() {
    return json.decode(jsonData) as Map<String, dynamic>;
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
    final data = _parseJsonData();
    final unfollowedData = data['relationships_unfollowed_users'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recently Unfollowed'),
      ),
      body: ListView.builder(
        itemCount: unfollowedData.length,
        itemBuilder: (context, index) {
          final unfollowed = unfollowedData[index]['string_list_data'][0];

          final String? username = unfollowed['value'] as String?;
          final String? href = unfollowed['href'] as String?;
          final int? timestamp = unfollowed['timestamp'] as int?;

          final String formattedDate;
          if (timestamp != null) {
            final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
            formattedDate = DateFormat.yMMMd().format(date);
          } else {
            formattedDate = 'Unknown date'; // Placeholder for null timestamp
          }

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Text(
                username?.isNotEmpty == true ? username![0].toUpperCase() : '?', // Handle null and empty username
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(username ?? 'Unknown User'), // Handle null username
            subtitle: const Text('Tap to view profile'), // Always display "Tap to view profile"
            trailing: Text(formattedDate),
            onTap: href != null ? () => _launchURL(context, href) : null, // Launch URL if not null
          );
        },
      ),
    );
  }
}
