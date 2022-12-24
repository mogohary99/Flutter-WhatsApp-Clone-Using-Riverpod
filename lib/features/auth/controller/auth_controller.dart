import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_riverpod/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_riverpod/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider=FutureProvider((ref){
  final authController = ref.watch(authControllerProvider).getUserData();
  return authController;
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({required this.authRepository, required this.ref});



  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(
    BuildContext context,
    String verificationId,
    String userOTP,
  ) {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  void saveUserDataToFirebase(
    BuildContext context,
    String name,
    File? profilePic,
  ) {
    authRepository.saveUserDataToFirebase(
      context: context,
      name: name,
      profilePic: profilePic,
      ref: ref,
    );
  }

  Future<UserModel?> getUserData()async{
    UserModel? user=await authRepository.getCurrentUserData();
  return user;
  }

  Stream<UserModel> userDataById(String userId){
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline){
    authRepository.setUserState(isOnline);
}
}
