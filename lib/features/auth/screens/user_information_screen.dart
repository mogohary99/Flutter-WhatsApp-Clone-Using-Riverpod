import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_riverpod/features/auth/controller/auth_controller.dart';

import '../../../cummon/utils/utils.dart';

String image3 =
    'https://scontent.fcai20-5.fna.fbcdn.net/v/t39.30808-6/273023955_148189687581197_2137633451673961077_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=8fvDEoPjXBYAX9_xtn1&_nc_ht=scontent.fcai20-5.fna&oh=00_AT__j9rU2PFjHfSDWs6dWEvLC8Nww4QfizLN5Lg1TYHXCQ&oe=635398C7';
String image2 =
    'https://png.pngtree.com/png-clipart/20210311/original/pngtree-customer-login-avatar-png-image_6015290.jpg';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const routeName = '/user-info-scren';

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
            context,
            name,
            image,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 100),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    image == null
                        ? CircleAvatar(
                            radius: 90,
                            backgroundImage: NetworkImage(image2),
                          )
                        : CircleAvatar(
                            radius: 90,
                            backgroundImage: FileImage(image!),
                          ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your name',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: storeUserData,
                      icon: const Icon(Icons.check),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
