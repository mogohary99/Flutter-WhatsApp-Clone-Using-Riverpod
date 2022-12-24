import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/cummon/widgets/loader.dart';
import '/features/auth/controller/auth_controller.dart';
import '/models/user_model.dart';

import '../../../colors.dart';
import '../widgets/chat_list.dart';
import '../widgets/bottom_chat_field.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';

  final String name;
  final String uid;

  const MobileChatScreen({super.key, required this.name, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const Loader();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                ),
                Text(
                  snapshot.data!.isOnline ? 'Online' : 'Offline',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal
                  ),
                ),
              ],
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children:  [
           Expanded(
            child: ChatList(receiverId: uid),
          ),
          BottomChatField(receiverUserId: uid),
        ],
      ),
    );
  }
}
