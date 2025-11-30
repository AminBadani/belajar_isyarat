import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashVideo extends StatefulWidget {
  const SplashVideo({super.key});
  @override
  State<SplashVideo> createState() => _SplashVideoState();
}

class _SplashVideoState extends State<SplashVideo> {
  late VideoPlayerController _controller;
  bool _videoFinished = false;
  bool _bgFinished = false;
  bool _navigated = false; // mencegah navigasi ganda

  @override
  void initState() {
    super.initState();
    print("SPLASH VIDEO INITSTATE JALAN");
    _initVideoAndListeners();
    _startBackgroundTask();
  }

  void _initVideoAndListeners() {
    _controller = VideoPlayerController.asset("lib/database/video/opening_app.mp4")
      ..setLooping(false)
      ..initialize().then((_) {
          print("VIDEO INIT SUCCESS");
          if (!mounted) return;
          setState(() {});
          _controller.play();
      }).catchError((e) {
          print("VIDEO INIT ERROR: $e");
      });

    // Listener untuk mendeteksi selesai video
    _controller.addListener(_videoListener);
  }

  void _videoListener() {
    if (!_controller.value.isInitialized) return;

    final position = _controller.value.position;
    

      // gunakan sedikit margin untuk menghindari jitter
    final duration = _controller.value.duration;
    if (duration == Duration.zero) return;
    final remaining = duration - position;

      if (remaining <= const Duration(milliseconds: 200)) {
        _videoFinished = true;
        _tryNavigate();
      }
  }

  Future<void> _startBackgroundTask() async {
    // Contoh: inisialisasi database, load provider, dll.
    // Jalankan kerja nyata di sini.
    await Future.delayed(const Duration(seconds: 7));
    if (!mounted) return;
    _bgFinished = true;
    debugPrint("Background task selesai");
    _tryNavigate();
  }

  void _tryNavigate() {
    if (_navigated) return;
    if (_videoFinished && _bgFinished && mounted) {
      _navigated = true;
      _navigate();
    }
  }

  void _navigate() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MenuKosong()),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("BUILD SPLASH VIDEO");
    if (!_controller.value.isInitialized) {
      return const Scaffold(
        body: ColoredBox(color: Colors.black),
      );
    }

    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}

class MenuKosong extends StatelessWidget {
  const MenuKosong({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}