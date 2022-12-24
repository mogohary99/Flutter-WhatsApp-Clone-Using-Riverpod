import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_riverpod/cummon/providers/message_replay_provider.dart';
import 'package:whatsapp_riverpod/cummon/repositories/common_firebase_storage_repository.dart';
import '/cummon/enums/message_enum.dart';
import '/cummon/utils/utils.dart';
import '/models/chat_contact.dart';
import '/models/message.dart';
import '/models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReplay? messageReplay,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1(); // this make unique id

      _saveDataToContactsSubCollection(
        senderUser,
        receiverUserData,
        text,
        timeSent,
        receiverUserId,
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        messageType: MessageEnum.text,
        timeSent: timeSent,
        text: text,
        messageId: messageId,
        receiverUsername: receiverUserData.name,
        username: senderUser.name,
        messageReplay: messageReplay,
        recieverUsername: receiverUserData.name,
        senderUsername: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void _saveDataToContactsSubCollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    DateTime timeSent,
    String receiverUserId,
  ) async {
    // users -> receiver user id => chats -> current user id -> set data
    var receiverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uId,
      lastMessage: text,
      timeSent: timeSent,
    );
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(senderUserData.uId)
        .set(
          receiverChatContact.toMap(),
        );
    // users -> current user id => chats -> receiver user id -> set data
    var senderChatContact = ChatContact(
      name: receiverUserData.name,
      profilePic: receiverUserData.profilePic,
      contactId: receiverUserData.uId,
      lastMessage: text,
      timeSent: timeSent,
    );
    await firestore
        .collection('users')
        .doc(senderUserData.uId)
        .collection('chats')
        .doc(receiverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String text,
    required String messageId,
    required String username,
    required String receiverUsername,
    required DateTime timeSent,
    required MessageEnum messageType,
    required MessageReplay? messageReplay,
    required String senderUsername,
    required String recieverUsername,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      messageId: messageId,
      type: messageType,
      timeSent: timeSent,
      isSeen: false,
      repliedMessage: messageReplay == null ? '' : messageReplay.message,
      repliedTo: messageReplay == null
          ? ''
          : messageReplay.isMe
              ? senderUsername
              : receiverUserId,
      repliedMessageType:
          messageReplay == null ? MessageEnum.text : messageReplay.messageEnum,
    );
    // users -> sender id -> chats -> receiver id -> messages ->message id ->store message
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
    // users -> receiver id -> chats -> sender id -> messages ->message id ->store message
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            lastMessage: chatContact.lastMessage,
            timeSent: chatContact.timeSent,
          ),
        );
      }
      return contacts.reversed.toList();
    });
  }

  Stream<List<Message>> getChatStream(String receiverId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReplay? messageReplay,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      var imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              'chat/${messageEnum.type}/${senderUserData.uId}/$receiverUserId/$messageId}',
            file,
          );
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactMessage;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMessage = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMessage = '🎥 Video';
          break;
        case MessageEnum.audio:
          contactMessage = '🎙️ Audio';
          break;
        case MessageEnum.gif:
          contactMessage = 'Gif';
          break;
        default:
          contactMessage = 'Gif';
      }

      _saveDataToContactsSubCollection(
        senderUserData,
        receiverUserData,
        contactMessage,
        timeSent,
        receiverUserId,
      );
      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: imageUrl,
        messageId: messageId,
        username: senderUserData.name,
        receiverUsername: receiverUserData.name,
        timeSent: timeSent,
        messageType: messageEnum,
        messageReplay: messageReplay,
        senderUsername: senderUserData.name,
        recieverUsername: receiverUserData.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGifMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReplay? messageReplay,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1(); // this make unique id

      _saveDataToContactsSubCollection(
        senderUser,
        receiverUserData,
        'Gif',
        timeSent,
        receiverUserId,
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        messageType: MessageEnum.gif,
        timeSent: timeSent,
        text: gifUrl,
        messageId: messageId,
        receiverUsername: receiverUserData.name,
        username: senderUser.name,
        messageReplay: messageReplay,
        senderUsername: senderUser.name,
        recieverUsername: receiverUserData.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .doc(messageId)
          .update({
        'isSeen': true,
      });
      // users -> receiver id -> chats -> sender id -> messages ->message id ->store message
      await firestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({
        'isSeen': true,
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
