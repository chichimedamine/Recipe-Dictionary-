import 'package:flutter/material.dart';

class Mytextfield extends StatelessWidget {
  final String hinttext;
  final TextEditingController ctrl;
  final IconData icon;
  final TextInputType keybordtype;
  final Function(String) onchanged;
  final bool obscuretext;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextAlign textAlign;
  final TextStyle style;
  final InputDecoration decoration;

  const Mytextfield({
    required Key key,
    required this.ctrl,
    required this.hinttext,
    required this.icon,
    required this.keybordtype,
    required this.onchanged,
    this.obscuretext = false,
    this.autocorrect = false,
    this.enableSuggestions = false,
    this.textAlign = TextAlign.start,
    this.style = const TextStyle(color: Colors.black),
    this.decoration = const InputDecoration(
      filled: true,
      contentPadding: EdgeInsets.all(8),
      fillColor: Colors.white,
      border: InputBorder.none,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: ctrl,
        obscureText: obscuretext,
        keyboardType: keybordtype,
        autocorrect: autocorrect,
        enableSuggestions: enableSuggestions,
        textAlign: textAlign,
        style: style,
        onChanged: onchanged,
        decoration: decoration.copyWith(
          hintText: hinttext,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
