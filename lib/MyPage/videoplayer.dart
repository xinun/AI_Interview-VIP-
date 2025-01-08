import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ChewiePlayerScreen extends StatefulWidget {
  final String videoUrl;

  const ChewiePlayerScreen({super.key, required this.videoUrl});

  @override
  State<ChewiePlayerScreen> createState() => _ChewiePlayerScreenState();
}

class _ChewiePlayerScreenState extends State<ChewiePlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    // VideoPlayerController 초기화
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);

    // ChewieController 초기화
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true, // 자동 재생
      looping: false, // 반복 재생 여부
      allowedScreenSleep: false, // 재생 중 화면 잠금 방지
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.orange,
        handleColor: Colors.orange,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
    );

    _videoPlayerController.initialize().then((_) {
      setState(() {}); // 화면 갱신
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영상 재생'),
        backgroundColor: const Color(0xFF1F5EFF),
      ),
      body: Center(
        child: _chewieController != null &&
            _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : const CircularProgressIndicator(), // 로딩 표시
      ),
    );
  }
}
