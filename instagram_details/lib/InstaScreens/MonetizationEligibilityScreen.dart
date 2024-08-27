import 'dart:convert';
import 'package:flutter/material.dart';

class MonetizationEligibilityScreen extends StatelessWidget {
  const MonetizationEligibilityScreen({super.key, required this.jsonData, required this.folderName});

  final String jsonData;
  final String folderName;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> eligibilityJsonData = jsonDecode(jsonData);
    List<dynamic> eligibilityList = eligibilityJsonData['monetization_eligibility'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monetization Eligibility'),
      ),
      body: ListView.builder(
        itemCount: eligibilityList.length,
        itemBuilder: (context, index) {
          final eligibility = eligibilityList[index];
          final stringMapData = eligibility['string_map_data'];

          return Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: stringMapData.entries.map<Widget>((entry) {
                  final String? value = entry.value['value'];
                  if (value != null && value.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '${entry.key}: $value',
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
