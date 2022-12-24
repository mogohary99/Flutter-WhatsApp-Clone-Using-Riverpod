import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_riverpod/cummon/enums/message_enum.dart';
import 'package:whatsapp_riverpod/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum messageType;

  const DisplayTextImageGif(
      {super.key, required this.message, required this.messageType,});

  @override
  Widget build(BuildContext context) {
    // print(message);
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    switch (messageType) {
      case MessageEnum.text:
        return Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
        );
      case MessageEnum.image:
        return CachedNetworkImage(
          imageUrl: message,
        );
      case MessageEnum.video:
        return VideoPlayerItem(videoUrl: message);
      case MessageEnum.gif:
        return CachedNetworkImage(
          imageUrl: message,
        );
      case MessageEnum.audio:
        return StatefulBuilder(
            builder: (context, setState) {
          return IconButton(
            onPressed: () async {
              if (isPlaying) {
                await audioPlayer.pause();
                setState(() {
                  isPlaying = false;
                });
              } else {
                await audioPlayer.play(UrlSource(message));
                setState(() {
                  isPlaying = true;
                });
              }
            },
            constraints: const BoxConstraints(
              minWidth: 100,
            ),
            icon: Icon(
              isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled_rounded,
            ),
          );
        });
      default:
        return Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
        );
    }
    /*
    return messageType == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : CachedNetworkImage(
            imageUrl: message,
          );

     */
  }
}
