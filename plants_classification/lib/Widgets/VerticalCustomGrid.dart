import 'package:flutter/material.dart';

class PlantCardGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Max 2 items per row
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2 / 2, // Adjust for card proportions
      ),
      itemCount: 6, // Number of cards
      itemBuilder: (context, index) {
        return PlantCard(
          title: 'Plant $index',
          imageUrl: 'assets/plant_image.jpg', // Replace with your image asset
        );
      },
    );
  }
}





class PlantCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  PlantCard({required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),  // Margin for spacing around the card
      // width: double.infinity,  // Ensure the card takes up available width in the grid
      // height: 150,  // Fixed height to maintain the square shape
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),  // Rounded borders
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 2,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),  // Ensure the image is clipped within rounded borders
        child: Stack(
          children: [
            // Background image filling the entire container
            Positioned.fill(
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,  // Make sure the image covers the entire container
              ),
            ),
            // Title at the top left corner
            Positioned(
              top: 16,
              left: 16,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,  // Text color contrasting with the background
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black54,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}