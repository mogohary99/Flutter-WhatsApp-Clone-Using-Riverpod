import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_riverpod/cummon/providers/message_replay_provider.dart';
import 'package:whatsapp_riverpod/features/chat/widgets/display_text_image_gif.dart';

class MessageReplayPreview extends ConsumerWidget {
  const MessageReplayPreview({super.key});

  void cancelReplay(WidgetRef ref) {
    ref.read(messageReplayProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReplay = ref.watch(messageReplayProvider);
    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
          )),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReplay!.isMe ? 'Me' : 'opposite',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => cancelReplay(ref),
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          DisplayTextImageGif(
            message: messageReplay.message,
            messageType: messageReplay.messageEnum,
          ),
        ],
      ),
    );
  }
}
