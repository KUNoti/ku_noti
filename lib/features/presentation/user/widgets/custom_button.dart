import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color? backColor;
  final Color? foreColor;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.backColor,
    required this.foreColor
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: foreColor,
        backgroundColor: backColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        elevation: 3, // Elevation
      ),
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}