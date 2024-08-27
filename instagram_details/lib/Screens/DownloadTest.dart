import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:path_provider/path_provider.dart';

class DownloadTest extends StatelessWidget{
  const DownloadTest({super.key});

  downloadZip() async {
  // /data/user/0/com.example.instagram_details/app_flutter/comsians/media/stories/
  //   var dl = DownloadManager();
  //   var url = "https://bigzipfiles.instagram.com/p/dl/download/file.php?r=17841462356551804&t=17841462356551804&j=26&i=1227378138704467&file_secret=WZDCUQRWLE4MZDOUG3OQ&f=1683959592363213&ext=1724751999&hash=AaZqP4agJpRvs9la";
  //   await dl.addDownload(url, "/data/user/0/com.example.instagram_details/app_flutter/");
  //
  //   DownloadTask? task = dl.getDownload(url);
  //
  //   task?.status.addListener(() {
  //     print(task.status.value);
  //   });
  //
  //   task?.progress.addListener(() {
  //     print(task.progress.value);
  //   });
  //
  //   await dl.whenDownloadComplete(url);

    var dir = Directory('/data/user/0/com.example.instagram_details/app_flutter/media/posts/202401/');
    var contents = dir.listSync();
    for (var entity in contents) {
      print(entity);
    }


  }

  Future<void> downloadFile() async {

    bool downloading = false;
    var progressString = "";

    final imgUrl = "https://bigzipfiles.instagram.com/p/dl/download/file.php?r=17841462356551804&t=17841462356551804&j=26&i=1227378138704467&file_secret=WZDCUQRWLE4MZDOUG3OQ&f=1683959592363213&ext=1724754594&hash=AaZvkHW9jRNP9-t_";
    Dio dio = Dio();
    Directory dir = await getApplicationDocumentsDirectory();
    try {
      dir = await getApplicationDocumentsDirectory();
      print("path ${dir.path}");
      await dio.download(imgUrl, "${dir.path}/test.zip",
          onReceiveProgress: (rec, total) {
            // print("Rec: $rec , Total: $total");
            downloading = true;
            progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
            print(progressString);


          });
    } catch (e) {
      print(e);
    }
    downloading = false;
    progressString = "Completed";

    print("Download completed");
    File f = File("${dir.path}/test1.zip");
    Directory zipDir = Directory(dir.path);

    _extractZipFile(f, zipDir);
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

      print("ZIP file extracted successfully");

      print('ZIP file extracted to: ${destinationDir.path}');
    } catch (e) {
      throw Exception('Error extracting ZIP file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: (){
          downloadZip();
        }, child: const Text('testing download'))
      ),
    );
  }

}