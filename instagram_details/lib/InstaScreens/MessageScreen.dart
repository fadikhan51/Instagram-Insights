import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ChatMessagesScreen extends StatefulWidget {
  const ChatMessagesScreen({super.key, required this.dirName});

  final String dirName;
  @override
  _ChatMessagesScreenState createState() => _ChatMessagesScreenState();
}

class _ChatMessagesScreenState extends State<ChatMessagesScreen> {
  List<String> folders = [];

  @override
  void initState() {
    super.initState();
    _listChatFolders();
  }

  Future<void> _listChatFolders() async {
    final directory = await getApplicationDocumentsDirectory();
    final baseDir = Directory('${directory.path}/${widget.dirName}/your_instagram_activity/messages/inbox');

    if (baseDir.existsSync()) {
      setState(() {
        folders = baseDir.listSync().whereType<Directory>().map((dir) => dir.path.split('/').last).toList();
      });
    }
  }

  Future<Map<String, dynamic>> _readMessages(String folderName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${widget.dirName}/your_instagram_activity/messages/inbox/$folderName/message_1.json';
    final file = File(filePath);

    var dir = Directory('${directory.path}/${widget.dirName}/your_instagram_activity/messages/inbox/$folderName');
    List contents = dir.listSync();
    for (var fileOrDir in contents) {
      if (fileOrDir is File) {
        print(fileOrDir.path);
      } else if (fileOrDir is Directory) {
        print(fileOrDir.path);
      }
    }

    if (file.existsSync()) {
      final content = await file.readAsString();
      return jsonDecode(content);
    } else {
      print("FILE DOES NOT EXISTS");
      return {};
    }
  }

  void _showMessagesDialog(BuildContext context, String folderName) async {
    final messageData = await _readMessages(folderName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Messages'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: messageData['messages'].map<Widget>((message) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "${message['sender_name']}: ${message['content']}",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Messages'),
      ),
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folderName = folders[index];
          return ListTile(
            title: ElevatedButton(
              onPressed: () => _showMessagesDialog(context, folderName),
              child: Text(folderName),
            ),
          );
        },
      ),
    );
  }
}
