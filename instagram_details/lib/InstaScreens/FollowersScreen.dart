import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FollowersScreen extends StatelessWidget {
  const FollowersScreen({super.key, required this.jsonData, required this.folderName});

  final String jsonData;
  final String folderName;

  List<dynamic> _parseJsonData() {
    return json.decode(jsonData) as List<dynamic>;
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
          final follower = followersData[index]['string_list_data'][0];
          final timestamp = follower['timestamp'];
          final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
          final formattedDate = DateFormat.yMMMd().format(date);

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                follower['value'][0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(follower['value']),
            subtitle: Text(follower['href']),
            trailing: Text(formattedDate),
          );
        },
      ),
    );
  }
}
