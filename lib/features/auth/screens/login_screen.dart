import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_riverpod/colors.dart';
import 'package:whatsapp_riverpod/cummon/utils/utils.dart';
import 'package:whatsapp_riverpod/cummon/widgets/custom_button.dart';
import 'package:whatsapp_riverpod/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/loginScreen';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref.read(authControllerProvider).signInWithPhone(
            context,
            '+${country!.phoneCode}$phoneNumber',
          );
    } else {
      showSnackBar(context: context, content: 'Fill out all field.');
    }
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text('Enter your phone number'),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'WhatsApp will need to verify your phone number.',
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: pickCountry,
              child: Text('Pick Country'),
            ),
            Row(
              children: [
                if (country != null) Text('+${country!.phoneCode}'),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: 'Phone Number'),
                  ),
                )
              ],
            ),
            const Spacer(),
            SizedBox(
              width: 90,
              child: CustomButton(
                onPress: sendPhoneNumber,
                text: 'Next',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
