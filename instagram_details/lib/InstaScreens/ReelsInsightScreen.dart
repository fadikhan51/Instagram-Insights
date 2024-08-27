import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';


class ReelsInsightsScreen extends StatelessWidget {
  const ReelsInsightsScreen({super.key, required this.data, required this.folderName});

  final String data;
  final String folderName;

  @override
  Widget build(BuildContext context) {
    // Parse the JSON string
    Map<String, dynamic> reelsData = jsonDecode(data);
    List<dynamic> reels = reelsData['organic_insights_reels'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reels Insights'),
      ),
      body: ListView.builder(
        itemCount: reels.length,
        itemBuilder: (context, index) {
          var reel = reels[index];
          var mediaData = reel['media_map_data']['Media Thumbnail'];
          var stringData = reel['string_map_data'];

          // Parse the upload timestamp
          var timestamp = int.parse(stringData['Upload Timestamp']['timestamp'].toString());
          var formattedTime = DateFormat.yMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VideoPlayerWidget(uri: mediaData['uri']),
                  const SizedBox(height: 8),
                  Text(mediaData['title'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(stringData['Caption']['value'] ?? ''),
                  const SizedBox(height: 8),
                  Text('Upload Timestamp: $formattedTime'),
                  Text('Duration: ${stringData['Duration']['value']} seconds'),
                  Text('Accounts Reached: ${stringData['Accounts reached']['value']}'),
                  Text('Instagram Plays: ${stringData['Instagram Plays']['value']}'),
                  Text('Instagram Likes: ${stringData['Instagram Likes']['value']}'),
                  Text('Instagram Comments: ${stringData['Instagram Comments']['value']}'),
                  Text('Instagram Shares: ${stringData['Instagram Shares']['value']}'),
                  Text('Instagram Saves: ${stringData['Instagram Saves']['value']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String uri;

  VideoPlayerWidget({super.key, required this.uri});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.uri)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
