import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'video-player.dart';

class MediaViewer extends StatelessWidget {
  final String mediaPath;

  const MediaViewer({super.key, required this.mediaPath});

  void _openFullScreenMedia(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Close when tapping outside
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(), // Close on tap
          child: Container(
            color: Colors.black.withOpacity(0.9),
            alignment: Alignment.center,
            child: mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov')
                ? VideoPlayerWidget(mediaPath: mediaPath)
                : Image.network(
              mediaPath,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text("Image failed to load", style: TextStyle(color: Colors.white)));
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () => _openFullScreenMedia(context),
        child: mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov')
            ? VideoPlayerWidget(mediaPath: mediaPath)
            : ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            mediaPath,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text("Image failed to load"));
            },
          ),
        ),
      ),
    );
  }
}
