import 'dart:convert';
import 'package:flutter/material.dart';

class SecretConversationsScreen extends StatelessWidget {
  const SecretConversationsScreen({super.key, required this.data, required this.folderName});

  final String data;
  final String folderName;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jsonData = jsonDecode(data);
    List<dynamic> devices = jsonData['ig_secret_conversations']['armadillo_devices'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Secret Conversations Devices'),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Device Type: ${device['device_type']}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Manufacturer: ${device['device_manufacturer']}'),
                  Text('Model: ${device['device_model']}'),
                  Text('OS Version: ${device['device_os_version']}'),
                  Text('Last Connected IP: ${device['last_connected_ip']}'),
                  Text(
                    'Last Active Time: ${DateTime.fromMillisecondsSinceEpoch(device['last_active_time'] * 1000)}',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

