import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_riverpod/cummon/providers/message_replay_provider.dart';
import 'package:whatsapp_riverpod/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_riverpod/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_riverpod/models/chat_contact.dart';
import 'package:whatsapp_riverpod/models/message.dart';

import '../../../cummon/enums/message_enum.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
  ) {
    final messageReplay = ref.read(messageReplayProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            senderUser: value!,
            messageReplay: messageReplay,
          ),
        );
    ref.read(messageReplayProvider.state).update((state) => null);
  }

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String receiverId) {
    return chatRepository.getChatStream(receiverId);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUserId,
    MessageEnum messageEnum,
  ) {
    final messageReplay = ref.read(messageReplayProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverUserId: receiverUserId,
            senderUserData: value!,
            ref: ref,
            messageEnum: messageEnum,
            messageReplay: messageReplay,
          ),
        );
    ref.read(messageReplayProvider.state).update((state) => null);
  }

  void sendGifMessage(
    BuildContext context,
    String gifUrl,
    String receiverUserId,
  ) {
    //to change url of gif to work on mobile
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

    final messageReplay = ref.read(messageReplayProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendGifMessage(
            context: context,
            gifUrl: newgifUrl,
            receiverUserId: receiverUserId,
            senderUser: value!,
            messageReplay: messageReplay,
          ),
        );
    ref.read(messageReplayProvider.state).update((state) => null);
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      receiverUserId,
      messageId,
    );
  }
}
