import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_riverpod/cummon/enums/message_enum.dart';
import 'package:whatsapp_riverpod/cummon/providers/message_replay_provider.dart';
import 'package:whatsapp_riverpod/cummon/widgets/loader.dart';
import 'package:whatsapp_riverpod/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_riverpod/models/message.dart';
import 'sender_message_card.dart';

import 'my_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverId;

  const ChatList({Key? key, required this.receiverId}) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref.read(messageReplayProvider.state).update(
          (state) => MessageReplay(
            message,
            isMe,
            messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: ref.watch(chatControllerProvider).chatStream(widget.receiverId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final message = snapshot.data![index];
              if (!message.isSeen &&
                  message.receiverId ==
                      FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setChatMessageSeen(
                      context,
                      widget.receiverId,
                      message.messageId,
                    );
              }

              //if(message.senderId != receiverId) //check
              if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: message.text,
                  date: DateFormat.Hm().format(message.timeSent),
                  messageType: message.type,
                  username: message.repliedTo,
                  repliedText: message.repliedMessage,
                  repliedMessageType: message.repliedMessageType,
                  onLeftSwipe: () => onMessageSwipe(
                    message.text,
                    true,
                    message.type,
                  ),
                  isSeen: message.isSeen
                );
              }
              return SenderMessageCard(
                message: message.text,
                date: DateFormat.Hm().format(message.timeSent),
                messageType: message.type,
                username: message.repliedTo,
                repliedText: message.repliedMessage,
                repliedMessageType: message.repliedMessageType,
                onRightSwipe: () => onMessageSwipe(
                  message.text,
                  false,
                  message.type,
                ),
              );
            },
          );
        });
  }
}
