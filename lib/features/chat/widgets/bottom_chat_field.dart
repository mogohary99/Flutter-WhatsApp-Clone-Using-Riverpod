import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_riverpod/cummon/enums/message_enum.dart';
import 'package:whatsapp_riverpod/cummon/providers/message_replay_provider.dart';
import 'package:whatsapp_riverpod/cummon/utils/utils.dart';
import 'package:whatsapp_riverpod/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_riverpod/features/chat/widgets/message_replay_preview.dart';

import '../../../colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;

  const BottomChatField({super.key, required this.receiverUserId});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic Permision Not Allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
          );
      _messageController.clear();
    }
    else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverUserId,
          messageEnum,
        );
  }

  void sendGifMessage(GiphyGif? gif) {
    if (gif != null) {
      ref.read(chatControllerProvider).sendGifMessage(
            context,
            gif.url!,
            widget.receiverUserId,
          );
    }
  }
//////////
  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectGif() async {
    final gif = await pickGif(context);
    sendGifMessage(gif);
  }
///////
  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showKeyboard() => focusNode.requestFocus();

  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      hideEmojiContainer();
      showKeyboard();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }
/////////
  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReplay=ref.watch(messageReplayProvider);
    final isShowMessageReplay= messageReplay !=null;
    return Column(
      children: [
        isShowMessageReplay ? MessageReplayPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: toggleEmojiKeyboardContainer,
                          icon: const Icon(
                            Icons.emoji_emotions,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: selectGif,
                          icon: const Icon(
                            Icons.gif,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 110,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: selectVideo,
                          splashRadius: 10,
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: CircleAvatar(
                backgroundColor: const Color(0xff128c7e),
                radius: 25,
                child: GestureDetector(
                  onTap: sendTextMessage,
                  child: Icon(
                    isShowSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        // this to show emoji picker
        if (isShowEmojiContainer)
          SizedBox(
            height: 310,
            child: EmojiPicker(
              onBackspacePressed: () {},
              onEmojiSelected: ((category, emoji) {
                setState(() {
                  _messageController.text =
                      _messageController.text + emoji.emoji;
                });
                if (!isShowSendButton) {
                  setState(() {
                    isShowSendButton = true;
                  });
                }
              }),
            ),
          )
      ],
    );
  }
}
