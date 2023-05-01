import 'package:flutter/material.dart';

import '../../models/buttons_enum.dart';

class SocialSignInButton extends StatelessWidget {
  final Color color;
  final String text;
  final Color textColor;
  final double height;
  static const double borderRadius = 4.0;
  final VoidCallback onPressed;
  final Buttons button;

  const SocialSignInButton({
    Key? key,
    required this.color,
    required this.onPressed,
    this.height = 50,
    required this.button,
    required this.text,
    required this.textColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        ),
        child: buildRow(),
      ),
    );
  }

  Row buildRow() {
    switch (button) {
      case Buttons.Google:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/varios/google.png'),
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            Opacity(
                opacity: 0.0,
                child: Image.asset('assets/images/varios/google.png')),
          ],
        );
      case Buttons.Email:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.email,
            ),
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            const Opacity(
              opacity: 0.0,
              child: Icon(
                Icons.email,
              ),
            ),
          ],
        );
      default:
        return Row();
    }
  }
}
