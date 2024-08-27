import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCheckUtil {
  static Future<bool> checkIfNewUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      // Show modal dialog for first-time users
      WidgetsBinding.instance.addPostFrameCallback((_) {
        List<String> imageList = [
          'assets/help/Help1.png',
          'assets/help/Help2.png',
          'assets/help/Help3.png',
          'assets/help/Help4.png',
          'assets/help/Help5.png',
          'assets/help/Help6.png',
          'assets/help/Help7.png',
          'assets/help/Help8.png',
          'assets/help/Help9.png',
          'assets/help/Help10.png',
          'assets/help/Help11.png',
        ];
        showHelpDialog(context, imageList);
      });
      await prefs.setBool('isFirstTime', false); // Update that user is not new anymore
      return true;
    }
    return false;
  }

  // static void showHelpDialog(BuildContext context, List<String> imageList) {
  //   // List<String> imageList = [
  //   //   'assets/help/Help1.png',
  //   //   'assets/help/Help2.png',
  //   //   'assets/help/Help3.png',
  //   //   'assets/help/Help4.png',
  //   //   'assets/help/Help5.png',
  //   //   'assets/help/Help6.png',
  //   //   'assets/help/Help7.png',
  //   //   'assets/help/Help8.png',
  //   //   'assets/help/Help9.png',
  //   //   'assets/help/Help10.png',
  //   //   'assets/help/Help11.png',
  //   // ];
  //   int currentImageIndex = 0;
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             contentPadding: EdgeInsets.zero,
  //             content: Container(
  //               width: MediaQuery.of(context).size.width, // Set width to screen width
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         IconButton(
  //                           icon: Icon(Icons.close),
  //                           onPressed: () {
  //                             Navigator.of(context).pop();
  //                           },
  //                         ),
  //                         Text(
  //                           'Step ${currentImageIndex + 1}',
  //                           style: TextStyle(
  //                             fontSize: 20,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         SizedBox(width: 48), // Invisible placeholder to balance the Row
  //                       ],
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(16.0), // Add margins around the image
  //                     child: Image.asset(imageList[currentImageIndex]),
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       IconButton(
  //                         icon: Icon(Icons.arrow_back),
  //                         onPressed: currentImageIndex > 0
  //                             ? () {
  //                           setState(() {
  //                             currentImageIndex--;
  //                           });
  //                         }
  //                             : null, // Disable button if on the first image
  //                       ),
  //                       IconButton(
  //                         icon: Icon(Icons.arrow_forward),
  //                         onPressed: currentImageIndex < imageList.length - 1
  //                             ? () {
  //                           setState(() {
  //                             currentImageIndex++;
  //                           });
  //                         }
  //                             : null, // Disable button if on the last image
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  static void showHelpDialog(BuildContext context, List<String> imageList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentImageIndex = prefs.getInt('currentImageIndex') ?? 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Text(
                            'Step ${currentImageIndex + 1}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 48),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(imageList[currentImageIndex]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: currentImageIndex > 0
                              ? () {
                            setState(() {
                              currentImageIndex--;
                              prefs.setInt('currentImageIndex', currentImageIndex);
                            });
                          }
                              : null,
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: currentImageIndex < imageList.length - 1
                              ? () {
                            setState(() {
                              currentImageIndex++;
                              prefs.setInt('currentImageIndex', currentImageIndex);
                            });
                          }
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

}
