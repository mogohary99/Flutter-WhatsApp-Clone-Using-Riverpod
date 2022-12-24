import 'package:flutter/material.dart';
import 'package:whatsapp_riverpod/colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPress;
  final String text;

  const CustomButton({super.key, required this.onPress, required this.text});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: tabColor,
        minimumSize: const Size(double.infinity,50)
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16
        ),
      ),
    );
  }
}
