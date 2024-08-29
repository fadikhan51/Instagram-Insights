import 'dart:io';
import 'package:flutter/material.dart';
import 'package:instagram_details/InstaScreens/PendingFollowRequestScreen.dart';
import 'package:instagram_details/InstaScreens/RecentFollowRequest.dart';
import 'package:instagram_details/InstaScreens/StoryLikesScreen.dart';
import 'package:instagram_details/InstaScreens/UnfollowedScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'InstaScreens/AccountsNotFollowingBackScreen.dart';


class OptionsScreen extends StatelessWidget {
  final String folderName;

  const OptionsScreen({super.key, required this.folderName});

  Future<bool> _fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      print('Error checking file: $e');
      return false;
    }
  }

  Future<String> _getAppDocumentsDirectory() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    return appDocumentsDirectory.path;
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text(
            'You have downloaded the wrong format. Please follow the guidelines.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the OptionsScreen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select any option"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<String>(
          future: _getAppDocumentsDirectory(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final appDocDir = snapshot.data!;
            final startHereFilePath = '$appDocDir/$folderName/start_here.html';

            // Check if the start_here.html file exists
            return FutureBuilder<bool>(
              future: _fileExists(startHereFilePath),
              builder: (context, fileSnapshot) {
                if (!fileSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // If the file exists, show the warning dialog
                if (fileSnapshot.data == true) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showWarningDialog(context);
                  });
                  return const SizedBox.shrink(); // Returning an empty widget as the dialog is shown
                }

                // Proceed with the normal UI rendering if the file does not exist
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCustomButton2(
                      context,
                      r"Accounts that don't Follow Back",
                      '$appDocDir/$folderName/connections/followers_and_following/following.json',
                      '$appDocDir/$folderName/connections/followers_and_following/followers_1.json',
                          (data1, data2) => AccountsNotFollowingBackScreen(
                        followersJsonData: data2,
                        followingJsonData: data1,
                        folderName: folderName,
                      ),
                    ),
                    _buildCustomButton(
                      context,
                      "Recently Unfollowed",
                      '$appDocDir/$folderName/connections/followers_and_following/recently_unfollowed_accounts.json',
                          (data) => UnfollowedScreen(jsonData: data, folderName: folderName),
                    ),
                    _buildCustomButton(
                      context,
                      "Pending Follow Requests",
                      '$appDocDir/$folderName/connections/followers_and_following/pending_follow_requests.json',
                          (data) => PendingFollowRequestScreen(jsonData: data, folderName: folderName),
                    ),
                    _buildCustomButton(
                      context,
                      "Recent Follow Requests",
                      '$appDocDir/$folderName/connections/followers_and_following/recent_follow_requests.json',
                          (data) => RecentFollowRequestScreen(jsonData: data, folderName: folderName),
                    ),
                    _buildCustomButton(
                      context,
                      "Story Likes",
                      '$appDocDir/$folderName/your_instagram_activity/story_sticker_interactions/story_likes.json',
                          (data) => StoryLikesScreen(jsonData: data, folderName: folderName),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomButton2(
      BuildContext context,
      String buttonText,
      String filePath1,
      String filePath2,
      Widget Function(String data1, String data2) screen
      ) {
    return FutureBuilder<bool>(
      future: _fileExists(filePath1),
      builder: (context, snapshot1) {
        if (snapshot1.connectionState == ConnectionState.waiting) {
          return const SizedBox(); // Placeholder while checking file existence
        }
        if (snapshot1.data == true) {
          return FutureBuilder<bool>(
            future: _fileExists(filePath2),
            builder: (context, snapshot2) {
              if (snapshot2.connectionState == ConnectionState.waiting) {
                return const SizedBox(); // Placeholder while checking file existence
              }
              if (snapshot2.data == true) {
                return CustomButton(
                  buttonText: buttonText,
                  filePathFuture: () async => filePath1,
                  onSuccess: (data1) async {
                    // Extract data from filePath2 after data1 is extracted
                    String data2 = await _extractData(filePath2);

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => screen(data1, data2),
                    ));
                  },
                );
              } else {
                return const SizedBox.shrink(); // Hide button if file2 doesn't exist
              }
            },
          );
        } else {
          return const SizedBox.shrink(); // Hide button if file1 doesn't exist
        }
      },
    );
  }

// Sample async function to read data from file
  Future<String> _extractData(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      throw Exception('Error extracting data from file: $e');
    }
  }



  Widget _buildCustomButton(BuildContext context, String buttonText, String filePath, Widget Function(String data) screen) {
    return FutureBuilder<bool>(
      future: _fileExists(filePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(); // Placeholder while checking file existence
        }
        if (snapshot.data == true) {
          return CustomButton(
            buttonText: buttonText,
            filePathFuture: () async => filePath,
            onSuccess: (data) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => screen(data),
              ));
            },
          );
        } else {
          return const SizedBox.shrink(); // Hide button if file doesn't exist
        }
      },
    );
  }
}

class MessagesButton extends StatefulWidget {
  final String buttonText;
  final Future<String> Function() directoryPathFuture;
  final Function(String) onSuccess;

  const MessagesButton({
    Key? key,
    required this.buttonText,
    required this.directoryPathFuture,
    required this.onSuccess,
  }) : super(key: key);

  @override
  _MessagesButtonState createState() => _MessagesButtonState();
}

class _MessagesButtonState extends State<MessagesButton> {
  bool _isLoading = false;

  void _handleOnPressed() async {
    setState(() {
      _isLoading = true;
    });

    final directoryPath = await widget.directoryPathFuture();
    final exists = await _checkDirectoryExists(directoryPath);

    setState(() {
      _isLoading = false;
    });

    if (exists) {
      widget.onSuccess(directoryPath);
    } else {
      // Show message if the directory doesn't exist
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("You don't have any data in this section.")),
      );
    }
  }

  Future<bool> _checkDirectoryExists(String directoryPath) async {
    try {
      final directory = Directory(directoryPath);
      return await directory.exists();
    } catch (e) {
      print('Error checking directory: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleOnPressed,
      child: _isLoading
          ? const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )
          : Text(
        widget.buttonText,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}

class CustomButton extends StatefulWidget {
  final String buttonText;
  final Future<String> Function() filePathFuture;
  final void Function(String data) onSuccess;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.filePathFuture,
    required this.onSuccess,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isLoading = false;

  void _handleOnPressed() async {
    setState(() {
      _isLoading = true;
    });

    final filePath = await widget.filePathFuture();
    final data = await _readFileIfExists(filePath);

    setState(() {
      _isLoading = false;
    });

    if (data != null) {
      widget.onSuccess(data);
    } else {
      // Show message if the file doesn't exist
      print(filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("You don't have any information in this section.")),
      );
    }
  }

  Future<String?> _readFileIfExists(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e) {
      print('Error reading file: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleOnPressed,
      child: _isLoading
          ? const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )
          : Text(
        widget.buttonText,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}