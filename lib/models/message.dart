
import 'package:whatsapp_riverpod/cummon/enums/message_enum.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final String messageId;
  final MessageEnum type;
  final DateTime timeSent;
  final bool isSeen;
  //replay message
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.messageId,
    required this.type,
    required this.timeSent,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedMessageType,
    required this.repliedTo,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'messageId': messageId,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType' : repliedMessageType.type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      messageId: map['messageId'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      isSeen: map['isSeen'] ?? false,
      repliedMessage: map['repliedMessage'] ?? '',
      repliedTo: map['repliedTo'],
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
    );
  }
}
