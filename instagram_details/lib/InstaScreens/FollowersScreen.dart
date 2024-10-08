import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class FollowersScreen extends StatelessWidget {
  const FollowersScreen({
    super.key,
    required this.jsonData,
    required this.folderName,
  });

  final String jsonData;
  final String folderName;

  List<dynamic> _parseJsonData() {
    try {
      return json.decode(jsonData) as List<dynamic>;
    } catch (e) {
      // If JSON parsing fails, return an empty list
      return [];
    }
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
    final followersData = _parseJsonData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
      ),
      body: ListView.builder(
        itemCount: followersData.length,
        itemBuilder: (context, index) {
          final followerData = followersData[index]['string_list_data'] as List<dynamic>?;
          if (followerData == null || followerData.isEmpty) {
            return const SizedBox.shrink();
          }

          final follower = followerData[0];

          final String? username = follower['value'] as String?;
          final String? href = follower['href'] as String?;
          final int? timestamp = follower['timestamp'] as int?;

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
