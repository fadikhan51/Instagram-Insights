import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({super.key, required this.jsonData, required this.folderName});

  final String jsonData;
  final String folderName;

  Map<String, dynamic> _parseJsonData() {
    return json.decode(jsonData) as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final data = _parseJsonData();
    final followingData = data['relationships_following'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Following'),
      ),
      body: ListView.builder(
        itemCount: followingData.length,
        itemBuilder: (context, index) {
          final following = followingData[index]['string_list_data'][0];
          final timestamp = following['timestamp'];
          final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
          final formattedDate = DateFormat.yMMMd().format(date);

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                following['value'][0].toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(following['value']),
            subtitle: Text(following['href']),
            trailing: Text(formattedDate),
          );
        },
      ),
    );
  }
}
