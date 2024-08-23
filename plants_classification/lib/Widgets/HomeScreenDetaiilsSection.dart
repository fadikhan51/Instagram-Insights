import 'package:flutter/material.dart';
import 'package:plants_classification/Widgets/HorizontalCardList.dart';
import 'package:plants_classification/Widgets/VerticalCustomGrid.dart';

class HomeScreenDetailsSection extends StatelessWidget {
  const HomeScreenDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, top: 20),
            child: Text(
              "Get Started",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: HorizontalCardList(), // Horizontal list of cards
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0,),            child: Text(
              "Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2 / 2, // Adjust as necessary
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PlantCard(
                  title: 'Plant $index',
                  imageUrl:
                      'assets/${(index % 3) + 1}.png', // Replace with your image asset
                );
              },
              childCount: 6, // Number of cards
            ),
          ),
        ),
      ],
    );
  }
}
