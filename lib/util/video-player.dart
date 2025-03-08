// import 'dart:io' show File, Platform;  // Ensure dart:io is only used conditionally
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoPlayerWidget extends StatefulWidget {
//   final String mediaPath;
//
//   const VideoPlayerWidget({super.key, required this.mediaPath});
//
//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }
//
// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (kIsWeb || widget.mediaPath.startsWith("http")) {
//       // Web & Network Video Support
//       _controller = VideoPlayerController.network(widget.mediaPath);
//     } else {
//       // Mobile: Local File Support
//       _controller = VideoPlayerController.file(File(widget.mediaPath));
//     }
//
//     _controller.initialize().then((_) {
//       setState(() {
//         _isInitialized = true;
//       });
//     });
//
//     _controller.setLooping(true);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _isInitialized
//         ? AspectRatio(
//       aspectRatio: _controller.value.aspectRatio,
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           VideoPlayer(_controller),
//           _PlayPauseOverlay(controller: _controller),
//         ],
//       ),
//     )
//         : const Center(child: CircularProgressIndicator());
//   }
// }
//
// class _PlayPauseOverlay extends StatelessWidget {
//   final VideoPlayerController controller;
//
//   const _PlayPauseOverlay({required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         controller.value.isPlaying ? controller.pause() : controller.play();
//       },
//       child: AnimatedOpacity(
//         opacity: controller.value.isPlaying ? 0.0 : 1.0,
//         duration: Duration(milliseconds: 300),
//         child: Container(
//           color: Colors.black26,
//           child: Center(
//             child: Icon(
//               controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//               color: Colors.white,
//               size: 50.0,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String mediaPath;

  const VideoPlayerWidget({super.key, required this.mediaPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    try {
      if (kIsWeb || widget.mediaPath.startsWith("http")) {
        _controller = VideoPlayerController.network(widget.mediaPath);
      } else {
        _controller = VideoPlayerController.file(File(widget.mediaPath));
      }

      await _controller!.initialize();
      _controller!.setLooping(true);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Video initialization error: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          VideoPlayer(_controller!),
          _PlayPauseOverlay(controller: _controller!),
          VideoProgressIndicator(_controller!, allowScrubbing: true),
        ],
      ),
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  final VideoPlayerController controller;

  const _PlayPauseOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.value.isPlaying ? controller.pause() : controller.play();
      },
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, VideoPlayerValue value, child) {
          return AnimatedOpacity(
            opacity: value.isPlaying ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              color: Colors.black26,
              child: const Center(
                child: Icon(Icons.play_arrow, color: Colors.white, size: 50.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
