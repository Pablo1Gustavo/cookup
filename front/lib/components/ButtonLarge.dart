import 'package:flutter/material.dart';
import 'package:front/utils/constants.dart';

class ButtonLarge extends StatelessWidget {
  final VoidCallback onPressed;
  final String labelTxt;
  final IconData icon;

  const ButtonLarge({
    required this.onPressed,
    required this.labelTxt,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: primaryColor400,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: backgroundColor,
          ),
          SizedBox(height: 4),
          Text(
            labelTxt,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}