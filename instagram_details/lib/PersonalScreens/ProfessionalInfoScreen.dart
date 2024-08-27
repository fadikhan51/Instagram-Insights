import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ProfessionalInfoScreen extends StatelessWidget {

  const ProfessionalInfoScreen({super.key, required this.jsonData, required this.folderName});

  final String jsonData;
  final String folderName;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = jsonDecode(jsonData);
    final List<dynamic> profileBusiness = data['profile_business'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
      ),
      body: ListView.builder(
        itemCount: profileBusiness.length,
        itemBuilder: (context, index) {
          final businessInfo = profileBusiness[index];
          final stringMapData = businessInfo['string_map_data'] ?? {};

          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    businessInfo['title'] ?? '',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...stringMapData.entries.map((entry) {
                    final key = entry.key;
                    final value = entry.value['value'] ?? '';
                    final timestamp = entry.value['timestamp'] ?? 0;

                    // Format the timestamp
                    String formattedDate = timestamp != 0
                        ? DateFormat.yMMMd().add_jm().format(
                        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000))
                        : '';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '$key: ',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(child: Text(value)),
                            ],
                          ),
                          if (formattedDate.isNotEmpty)
                            Text(
                              'Timestamp: $formattedDate',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
