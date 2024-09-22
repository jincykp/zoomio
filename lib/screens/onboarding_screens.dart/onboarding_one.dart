import 'package:flutter/material.dart';

class OnboardingScreenOne extends StatefulWidget {
  const OnboardingScreenOne({super.key});

  @override
  State<OnboardingScreenOne> createState() => _OnboardingScreenOneState();
}

class _OnboardingScreenOneState extends State<OnboardingScreenOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/Anywhere you are.png"),
              const SizedBox(
                height: 50,
              ),
              const Text('Any Where You Are'),
              const SizedBox(
                height: 50,
              ),
              const Text(
                  'Get a ride at your doorstep, anytime,\n anywhere. Fast, reliable, and always at\n your service.')
            ],
          ),
        ),
      ),
    );
  }
}
