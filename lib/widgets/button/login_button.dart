// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
    required this.buttonText,
    required this.buttonColor,
    this.buttonRadius = 15,
    this.buttonHeight = 65,
    this.buttonIcon = const Icon(Icons.add),
    required this.onPressed,
    this.textColor = Colors.white,
  }) : super(key: key);
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double buttonRadius;
  final double buttonHeight;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(buttonRadius),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buttonIcon,
              Text(
                buttonText,
                style: TextStyle(color: textColor),
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
