import 'package:flutter/material.dart';

class CustomOutlineButton extends StatefulWidget {
  final String text;
  final Color color;
  final Color textColor;
  final int fontSize;
  final Function onPressed;
  final Image? image;
  const CustomOutlineButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.color,
      required this.textColor,
      required this.fontSize,
      this.image});

  @override
  State<CustomOutlineButton> createState() => _CustomOutlineButtonState();
}

class _CustomOutlineButtonState extends State<CustomOutlineButton> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Center(
      child: OutlinedButton(
        onPressed: () {
          widget.onPressed();
        },
        style: OutlinedButton.styleFrom(
          textStyle: TextStyle(color: color.background),
          minimumSize: const Size(400, 50),
          backgroundColor: color.onBackground,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Colors.green),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          widget.text,
          style: TextStyle(color: color.background, fontSize: 20),
        ),
      ),
    );
  }
}
