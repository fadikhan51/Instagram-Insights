import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:archive/archive.dart';
import 'package:intl/intl.dart';
import 'UserCheckUtil.dart';

import '../OptionsScreen.dart'; // For formatting the timestamp

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() {
    return _WebViewScreenState();
  }
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  bool isDownloading = false;
  bool isLoading = false;
  double downloadProgress = 0.0;
  List<String> recentExtractedFiles = []; // To store recent extracted file names (timestamps)
  List<String> imgList = [];

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    _requestStoragePermission();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
            debugPrint('Page started loading: $url');
            _handlePageStarted(url);
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            debugPrint('Page finished loading: $url');

            // Redirect when 'info_and_permissions/' page finishes loading
            if (url == 'https://accountscenter.instagram.com/info_and_permissions/') {
              controller.loadRequest(Uri.parse('https://www.instagram.com/accounts/settings/'));
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint("Navigation Request received for ${request.url}");

            if (request.url.contains('bigzipfiles') && request.url.contains('download')) {
              print(request.url);
              downloadZipinUI(request.url);
              return NavigationDecision.prevent;
            } else if (request.url == 'https://www.instagram.com/') {
              controller.loadRequest(Uri.parse('https://accountscenter.instagram.com/info_and_permissions/dyi/'));
              return NavigationDecision.prevent;
            } else if (request.url == 'https://accountscenter.instagram.com/info_and_permissions/') {
              controller.loadRequest(Uri.parse('https://www.instagram.com/accounts/settings/'));
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://accountscenter.instagram.com/info_and_permissions/dyi/'));
    _loadRecentExtractedFiles();

  }

  Future<void> _initializePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Any other initialization code that requires preferences can go here
  }

  void _handlePageStarted(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (url.contains('instagram.com/accounts/login')) {
      imgList = [
        'assets/help/Help1.png',
        'assets/help/Help2.png'
      ];
      prefs.setInt('currentImageIndex', 0);
    } else if (url.contains('accountscenter.instagram.com/info_and_permissions/dyi')) {
      imgList = [
        'assets/help/Help3.png',
        'assets/help/Help4.png',
        'assets/help/Help5.png',
        'assets/help/Help6.png',
        'assets/help/Help7.png',
        'assets/help/Help8.png',
        'assets/help/Help9.png',
        'assets/help/Help10.png',
        'assets/help/Help11.png'
      ];
      prefs.setInt('currentImageIndex', 0);
    }
  }


  Future<void> _requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission must be allowed for downloading files.'),
        ),
      );
    }
  }

  Future<void> _loadRecentExtractedFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final directory = Directory(dir.path);
    final files = directory.listSync();

    setState(() {
      // Filter directories with timestamp-like names and add them to the list
      recentExtractedFiles = files
          .whereType<Directory>()
          .where((dir) => _isTimestamp(dir.path.split('/').last))
          .map((dir) => dir.path.split('/').last)
          .toList();
    });
  }

  bool _isTimestamp(String folderName) {
    // Check if the folder name is a valid timestamp
    try {
      DateTime.fromMillisecondsSinceEpoch(int.parse(folderName));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> downloadZipinUI(String url) async {
    final dio = Dio();
    final dir = await getApplicationDocumentsDirectory();
    final uniqueId = DateTime.now().millisecondsSinceEpoch.toString(); // Create unique ID

    setState(() {
      isDownloading = true; // Show circular progress indicator and block UI
      downloadProgress = 0.0; // Reset progress
    });

    try {
      final zipPath = "${dir.path}/$uniqueId.zip"; // Path for the downloaded ZIP file
      await dio.download(
        url,
        zipPath,
        onReceiveProgress: (rec, total) {
          setState(() {
            downloadProgress = rec / total;
          });
        },
      );

      // Create a directory with the same unique ID to extract files
      final extractDir = Directory("${dir.path}/$uniqueId");
      if (!extractDir.existsSync()) {
        extractDir.createSync(recursive: true);
      }

      // Extract the ZIP file
      await _extractZipFile(File(zipPath), extractDir);

      // Add to recent extracted files
      setState(() {
        isDownloading = false;
        recentExtractedFiles.add(uniqueId); // Store the unformatted timestamp
      });

      // Navigate to the OptionsScreen after extraction
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OptionsScreen(folderName: uniqueId),
        ),
      );
    } catch (e) {
      setState(() {
        isDownloading = false; // Hide progress indicator on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download failed. Please check your internet connection.')),
      );
    }
  }

  Future<void> _extractZipFile(File zipFile, Directory destinationDir) async {
    try {
      final archive = ZipDecoder().decodeBytes(await zipFile.readAsBytes());

      for (final file in archive) {
        final fileName = file.name;
        final filePath = '${destinationDir.path}/$fileName';

        if (file.isFile) {
          final data = file.content as List<int>;
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory(filePath).create(recursive: true);
        }
      }
    } catch (e) {
      throw Exception('Error extracting ZIP file: $e');
    }
  }

  // Helper method to format the timestamp into a readable date
  String _formatTimestamp(String timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    return DateFormat('yyyy-MM-dd – HH:mm:ss').format(date); // Format timestamp
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download your Information'),
        actions: [
          if (!isDownloading)
            IconButton(
              icon: const Icon(Icons.download_done),
              onPressed: () => _showRecentFilesDialog(context),
            ),
          if (isDownloading) const Text("")
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isDownloading)
            Stack(
              children: [
                ModalBarrier(
                  dismissible: false,
                  color: Colors.black.withOpacity(0.3),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: 2.0,
                        child: CircularProgressIndicator(
                          value: downloadProgress,
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          strokeWidth: 2.0,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text('${(downloadProgress * 100).toStringAsFixed(0)}%'),
                    ],
                  ),
                ),
              ],
            ),
          // Show loading indicator when WebView is reloading
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          // Refresh button at the bottom left corner
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              heroTag: 'refresh',
              onPressed: () {
                setState(() {
                  isLoading = true; // Show loading indicator when refresh is initiated
                });
                controller.reload(); // Reload the WebView page
              },
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'help',
        onPressed: () async {
          print(imgList);
          UserCheckUtil.showHelpDialog(context, imgList);
        },
        child: const Icon(Icons.help),
      ),
    );
  }



  void _showRecentFilesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recently Extracted Files'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: recentExtractedFiles.length,
              itemBuilder: (context, index) {
                String formattedName = _formatTimestamp(recentExtractedFiles[index]);
                return ListTile(
                  title: Text(formattedName),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(context, recentExtractedFiles[index]),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OptionsScreen(folderName: recentExtractedFiles[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// Helper method to confirm deletion
  void _confirmDelete(BuildContext context, String folderName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this data?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await _deleteData(folderName);
                Navigator.of(context).pop(); // Close the confirmation dialog
                Navigator.of(context).pop(); // Close the files dialog
                _loadRecentExtractedFiles(); // Refresh the list of recent extracted files
              },
            ),
          ],
        );
      },
    );
  }

// Method to delete data from the document directory
  Future<void> _deleteData(String folderName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final directoryToDelete = Directory('${dir.path}/$folderName');
      if (directoryToDelete.existsSync()) {
        directoryToDelete.deleteSync(recursive: true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete the data.')),
      );
    }
  }
}