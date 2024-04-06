import 'package:flutter/material.dart';

typedef StringValidator = String? Function(String?);

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final IconData? icon;
  final String hintText;
  final bool isPassword;
  final StringValidator? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    this.icon,
    required this.hintText,
    this.isPassword = false,
    this.validator,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  late Color _iconColor;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _iconColor = Colors.grey;

    _focusNode.addListener(() {
      setState(() {
        _iconColor = _focusNode.hasFocus ? Colors.deepPurpleAccent : Colors.grey;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword,
      focusNode: _focusNode,
      decoration: InputDecoration(
        icon: Icon(widget.icon, color: _iconColor),
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.deepPurpleAccent),
        ),
      ),
      validator: widget.validator
    );
  }
}

