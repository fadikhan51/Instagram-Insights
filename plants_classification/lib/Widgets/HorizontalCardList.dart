import 'dart:ui';

import 'package:flutter/material.dart';
class HorizontalCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Height of the cards
      child: ListView(
        padding: EdgeInsets.all(20),
        scrollDirection: Axis.horizontal,
        children: [
          CustomCard(
            imageUrl: 'assets/plant_image.jpg', // Replace with your image asset
            title: 'How to identify plants?',
            subtitle: 'Life Style',
          ),
          const SizedBox(width: 16), // Spacing between cards
          CustomCard(
            imageUrl: 'assets/plant_care.jpg', // Replace with your image asset
            title: 'Differences of plants',
            subtitle: 'Plant Identify',
          ),
          const SizedBox(width: 16,),
          CustomCard(
            imageUrl: 'assets/plant_image.jpg', // Replace with your image asset
            title: 'How to identify plants?',
            subtitle: 'Life Style',
          ),
        ],
      ),
    );
  }
}

// class CustomCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String subtitle;
//
//   CustomCard({required this.imageUrl, required this.title, required this.subtitle});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Background Image
//         Container(
//           width: 250, // Width of the card
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             image: DecorationImage(
//               image: AssetImage(imageUrl),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//
//         // Foreground Box with Text
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.5),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(12),
//                 bottomRight: Radius.circular(12),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class CustomCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  CustomCard({required this.imageUrl, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          width: 250, // Width of the card
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Foreground Box with Blurred Background
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // Slight black tint
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}