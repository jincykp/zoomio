import 'package:flutter/material.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.primaryColor,
        title: const Text("Payment"),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
                width: 350,
                height: 200,
                decoration:
                    const BoxDecoration(color: ThemeColors.successColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('vehicle Brand'),
                    Container(
                      width: 150,
                      height: 100,
                      color: ThemeColors.baseColor,
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
