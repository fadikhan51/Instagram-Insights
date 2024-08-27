import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  int currentImageIndex = 0;
  bool isNewUser = false;

  @override
  void initState() {
    super.initState();
    checkIfNewUser();
  }

  Future<void> checkIfNewUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      // Show modal dialog for first time users
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showHelpDialog();
      });
      await prefs.setBool('isFirstTime', false); // Update that user is not new anymore
    }
  }

  void showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Column(
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
                        SizedBox(width: 48), // Invisible placeholder to balance the Row
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0), // Add margins around the image
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
                          });
                        }
                            : null, // Disable button if on the first image
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: currentImageIndex < imageList.length - 1
                            ? () {
                          setState(() {
                            currentImageIndex++;
                          });
                        }
                            : null, // Disable button if on the last image
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Modal Demo'),
      ),
      body: Center(
        child: Text(
          'HI good morning',
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showHelpDialog,
        child: Icon(Icons.help),
      ),
    );
  }
}
