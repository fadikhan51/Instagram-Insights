import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class FollowingScreen extends StatelessWidget {
  const FollowingScreen({
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
    final followingData = data['relationships_following'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
      ),
      body: ListView.builder(
        itemCount: followingData.length,
        itemBuilder: (context, index) {
          final following = followingData[index]['string_list_data'][0];

          final String? username = following['value'] as String?;
          final String? href = following['href'] as String?;
          final int? timestamp = following['timestamp'] as int?;

          final String formattedDate;
          if (timestamp != null) {
            final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
            formattedDate = DateFormat.yMMMd().format(date);
          } else {
            formattedDate = 'Unknown date'; // Placeholder for null timestamp
          }

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                username?.isNotEmpty == true ? username![0].toUpperCase() : '?',
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
