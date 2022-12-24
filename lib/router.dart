import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_riverpod/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_riverpod/features/select_contact/screens/select_contact_screen.dart';
import 'package:whatsapp_riverpod/features/status/screens/confirm_status_screen.dart';
import 'package:whatsapp_riverpod/features/status/screens/status_screen.dart';
import 'package:whatsapp_riverpod/models/status_model.dart';
import 'features/chat/screens/mobile_chat_screen.dart';
import '/cummon/widgets/error.dart';
import '/features/auth/screens/login_screen.dart';
import '/features/auth/screens/otp_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => LoginScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => UserInformationScreen(),
      );
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactScreen(),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
        ),
      );
    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(
         file: file,
        ),
      );
    case StatusScreen.routeName:
      final status = settings.arguments as Status;
      return MaterialPageRoute(
        builder: (context) => StatusScreen(
          status: status,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page does not exist'),
        ),
      );
  }
}
