import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountsNotFollowingBackScreen extends StatelessWidget {
  final String followersJsonData;
  final String followingJsonData;
  final String folderName;

  const AccountsNotFollowingBackScreen({
    super.key,
    required this.followersJsonData,
    required this.followingJsonData,
    required this.folderName,
  });

  List<Map<String, dynamic>> findNotFollowing(List<dynamic> l1, List<dynamic> l2) {
    // Create an empty list to store the missing entries.
    List<Map<String, dynamic>> missingEntries = [];

    // Helper function to find a username in a list and return the entry.
    bool _isUsernameInList(List<dynamic> list, String username) {
      for (var item in list) {
        if (item is Map<String, dynamic> &&
            item['string_list_data'] is List) {
          for (var entry in item['string_list_data']) {
            if (entry is Map<String, dynamic> &&
                entry['value'] == username) {
              return true; // Username found in the list.
            }
          }
        }
      }
      return false; // Username not found.
    }

    // Iterate through each item in l1.
    for (var item in l1) {
      if (item is Map<String, dynamic> &&
          item['string_list_data'] is List) {
        for (var entry in item['string_list_data']) {
          // Extract the username.
          String? username = entry['value'];

          // If username is not found in l2, add it to missingEntries.
          if (username != null && !_isUsernameInList(l2, username)) {
            missingEntries.add({
              'username': entry['value'] ?? 'Unknown User',
              'href': entry['href'] ?? '',
              'timestamp': entry['timestamp'] ?? 0,
            });
          }
        }
      }
    }

    // Return the list of missing entries.
    return missingEntries;
  }

  @override
  Widget build(BuildContext context) {
    // Safely decode JSON data with error handling
    List<dynamic> followingData = [];
    List<dynamic> followers = [];

    try {
      followingData = jsonDecode(followingJsonData)['relationships_following']
      as List<dynamic>? ??
          [];
      followers = jsonDecode(followersJsonData) as List<dynamic>? ?? [];
    } catch (e) {
      print('Error decoding JSON data: $e');
      // Show a message or handle the error accordingly
    }

    // Find accounts that don't follow back
    final notFollowingBack = findNotFollowing(followingData, followers);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts Not Following Back'),
      ),
      body: notFollowingBack.isEmpty
          ? const Center(
        child: Text('No accounts found.'),
      )
          : ListView.builder(
        itemCount: notFollowingBack.length,
        itemBuilder: (context, index) {
          final user = notFollowingBack[index];
          final String? username = user['username'] as String?;
          final String? href = user['href'] as String?;
          final int? timestamp = user['timestamp'] as int?;

          final String formattedDate = timestamp != null
              ? DateFormat.yMMMd().format(
              DateTime.fromMillisecondsSinceEpoch(timestamp * 1000))
              : 'Unknown date';

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                username?.isNotEmpty == true
                    ? username![0].toUpperCase()
                    : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(username ?? 'Unknown User'),
            subtitle: const Text('Tap to view profile'),
            trailing: Text(formattedDate),
            onTap: href != null && href.isNotEmpty
                ? () => _launchURL(context, href)
                : () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Profile URL is unavailable.')),
              );
            },
          );
        },
      ),
    );
  }

  // Launch URL
  Future<void> _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.tryParse(url) ?? Uri();
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open the URL.')),
      );
    }
  }
}
