import 'package:flutter/material.dart';
import 'package:zoomer/styles/appstyles.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              "Sign Up",
              style: Textstyles.bodytext,
            )
          ],
        ),
      ),
    );
  }
}
