import 'dart:convert';

import 'package:flutter/material.dart';

class JsonParserScreen extends StatefulWidget {
  const JsonParserScreen({required this.jsonData, super.key});

  final String jsonData;

  @override
  _JsonParserScreenState createState() => _JsonParserScreenState();
}

class _JsonParserScreenState extends State<JsonParserScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? parsedData;
  List<dynamic>? followingData;

  void _parseJson() {
    setState(() {
      try {
        parsedData = jsonDecode(widget.jsonData);
        followingData = parsedData?['relationships_following'] as List<dynamic>;
      } catch (e) {
        parsedData = {'Error': 'Invalid JSON string'};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON Parser'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter JSON string',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _parseJson,
              child: Text('Parse JSON'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: parsedData == null
                  ? Center(child: Text('Enter JSON to parse'))
                  : Text(followingData![0].toString())
            ),
          ],
        ),
      ),
    );
  }
}