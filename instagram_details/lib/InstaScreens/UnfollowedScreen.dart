import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class UnfollowedScreen extends StatelessWidget {
  const UnfollowedScreen({super.key, required this.jsonData, required this.folderName});

  final String jsonData;
  final String folderName;

  Map<String, dynamic> _parseJsonData() {
    return json.decode(jsonData) as Map<String, dynamic>;
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
          final timestamp = unfollowed['timestamp'];
          final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
          final formattedDate = DateFormat.yMMMd().format(date);

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Text(
                unfollowed['value'][0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(unfollowed['value']),
            subtitle: Text(unfollowed['href']),
            trailing: Text(formattedDate),
          );
        },
      ),
    );
  }
}
