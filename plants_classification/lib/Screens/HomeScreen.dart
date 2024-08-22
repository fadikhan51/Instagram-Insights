import 'package:flutter/material.dart';
import 'package:plants_classification/Widgets/HomeScreenDetaiilsSection.dart';
import 'package:plants_classification/Widgets/HomeScreenSearchSection.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
        body: Column(
          children: [
            HomeScreenSearchSection(),
            Expanded(child: HomeScreenDetailsSection())
          ],
        )
    ),
    );
  }
}


