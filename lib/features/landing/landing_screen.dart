import 'package:flutter/material.dart';
import 'package:whatsapp_riverpod/features/auth/screens/login_screen.dart';
import '/colors.dart';
import '/cummon/widgets/custom_button.dart';

class LandingScreen extends StatelessWidget {

  void navigateToLoginScreen(BuildContext context){
    Navigator.of(context).pushNamed(LoginScreen.routeName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Welcome to WhatsApp',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            //const SizedBox(height: 80,),
            Image.asset(
              'assets/bg.png',
              color: tabColor,
              width: 300,
              height: 300,
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
                style: TextStyle(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width-60,
              child: CustomButton(
                onPress: () =>navigateToLoginScreen(context),
                text: 'AGREE AND CONTINUE',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
