import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:archive/archive.dart'; // Changed to 'archive' package for manual zip extraction
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../OptionsScreen.dart';

class ViewDetails extends StatefulWidget {
  const ViewDetails({super.key});

  @override
  State<ViewDetails> createState() {
    return _ViewDetailsState();
  }
}

class _ViewDetailsState extends State<ViewDetails> {
  double _progress = 0.0;
  bool _isExtracting = false;

  @override
  void initState() {
    super.initState();
    final status2 = Permission.manageExternalStorage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View your Details"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Handle file upload action
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                child: const Icon(
                  Icons.cloud_upload,
                  color: Colors.blue,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Drag files to upload, or',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _pickZipFile();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Choose File'),
            ),
            const SizedBox(height: 16),
            if (_isExtracting)
              CircularProgressIndicator(value: _progress),
          ],
        ),
      ),
    );
  }

  Future<void> _pickZipFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result != null) {
      // Get the file details
      File zipFile = File(result.files.single.path!);
      String fileName = result.files.single.name;

      // Validate if the file starts with "instagram"
      if (!fileName.toLowerCase().startsWith('instagram')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a valid ZIP file that starts with "instagram".')),
        );
        return;
      }

      // Get the app's document directory
      Directory? appDocDir = await _getDocumentDirectory();

      if (appDocDir != null) {
        // Create the folder with the name of the zip file (without .zip) inside the app's document directory
        String folderName = fileName.split('.zip').first;
        Directory zipDir = Directory('${appDocDir.path}/$folderName');
        if (!await zipDir.exists()) {
          await zipDir.create(recursive: true);
        }

        setState(() {
          _isExtracting = true;
          _progress = 0.0;
        });

        try {
          // Extract the zip file to the new directory
          await _extractZipFile(zipFile, zipDir);
          print('ZIP file extracted to: ${zipDir.path}');

          // Navigate to the Options screen, passing the zip file name
          _navigateToOptionsScreen(context, folderName);
        } catch (e) {
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to extract the ZIP file.')),
          );
        } finally {
          setState(() {
            _isExtracting = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not find document directory.')),
        );
      }
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a ZIP file first.')),
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ZIP file extracted successfully!')),
      );

      print('ZIP file extracted to: ${destinationDir.path}');
    } catch (e) {
      throw Exception('Error extracting ZIP file: $e');
    }
  }

  Future<Directory?> _getDocumentDirectory() async {
    if (Platform.isAndroid || Platform.isIOS) {
      // Use getApplicationDocumentsDirectory for both Android and iOS
      return await getApplicationDocumentsDirectory();
    }
    return null;
  }

  void _navigateToOptionsScreen(BuildContext context, String zipFileName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OptionsScreen(folderName: zipFileName),
      ),
    );
  }
}
