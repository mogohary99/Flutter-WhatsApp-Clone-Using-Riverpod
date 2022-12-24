import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_riverpod/cummon/enums/message_enum.dart';

class MessageReplay {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReplay(this.message, this.isMe, this.messageEnum);
}

final messageReplayProvider = StateProvider<MessageReplay?>((ref) => null);
