import 'package:flutter/material.dart';
import 'package:ku_noti/core/constants/colors.dart';

class MySearchBarWidget extends StatefulWidget {
  TextEditingController controller;
  MySearchBarWidget(this.controller, {super.key});

  @override
  MySearchBarWidgetState createState() => MySearchBarWidgetState();
}

class MySearchBarWidgetState extends State<MySearchBarWidget> {
  late FocusNode _focusNode;
  Color _iconColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _iconColor = _focusNode.hasFocus ?  MyColors().primary : Colors.grey;
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
    return _buildSearchbar();
  }

  Widget _buildSearchbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      margin: const EdgeInsets.all(16.0),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: 'What event are you looking for...',
          filled: true,
          fillColor: Colors.grey[100],
          prefixIcon: Icon(Icons.search, color: _iconColor),
          suffixIcon: Icon(Icons.tune, color: _iconColor),
          border: InputBorder.none, // No border
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: MyColors().primary),
          ),
        ),
      ),
    );
  }
}
