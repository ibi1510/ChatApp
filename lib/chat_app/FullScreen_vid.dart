import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideo extends StatefulWidget {
  final String videoUrl;

  FullScreenVideo({required this.videoUrl});

  @override
  _FullScreenVideoState createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  late VideoPlayerController _Vcontroller;

  @override
  void initState() {
    super.initState();
    _Vcontroller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_videoplay) {
        setState(() {});
        _Vcontroller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _Vcontroller.value.isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _Vcontroller.value.aspectRatio,
                    child: VideoPlayer(_Vcontroller),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _Vcontroller.value.isPlaying
                            ? _Vcontroller.pause()
                            : _Vcontroller.play();
                      });
                    },
                    child: Icon(
                      _Vcontroller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
