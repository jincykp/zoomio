import 'package:flutter/material.dart';
import 'package:zoomer/styles/appstyles.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: 500,
            width: 300,
            child: Card(
              color: ThemeColors.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          backgroundColor: ThemeColors.textColor,
                          radius: 70,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              //color: ThemeColors.titleColor,
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.add_a_photo_outlined,
                                size: 22,
                                color: ThemeColors.titleColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Name:",
                      style: GoogleFonts.inconsolata(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    Text("Street:",
                        style: GoogleFonts.inconsolata(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    const Divider(),
                    Text("City:",
                        style: GoogleFonts.inconsolata(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    const Divider(),
                    Text("District:",
                        style: GoogleFonts.inconsolata(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    const Divider(),
                    Text("Current Address:",
                        style: GoogleFonts.inconsolata(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
