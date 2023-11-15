import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_parking_app/controllers/auth_controller.dart';

class JWTToken extends StatefulWidget {
  const JWTToken({super.key});

  @override
  State<JWTToken> createState() => _JWTTokenState();
}

class _JWTTokenState extends State<JWTToken> {
  String token = "";
  final AppUserController _authController = Get.find();

  void jwtToClipboard() async {
    token = (await _authController.getCognitoAccessToken())!;
    setState(() {
      token = token;
      Clipboard.setData(ClipboardData(text: token));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Copy JWT for debug'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: jwtToClipboard,
              child: const Text('Copy JWT'),
            ),
            const SizedBox(height: 20),
            SelectableText(token),
          ],
        ),
      ),
    );
  }
}
