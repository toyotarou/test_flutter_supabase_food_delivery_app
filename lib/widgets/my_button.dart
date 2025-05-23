import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  const MyButton({super.key, required this.onTap, required this.buttontext, this.color = Colors.blueAccent});
  final VoidCallback onTap;
  final String buttontext;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onTap,
      child: Text(buttontext, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
    );
  }
}
