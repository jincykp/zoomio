import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromARGB(
                            255, 66, 60, 60) // Dark theme outer box color
                        : const Color.fromARGB(
                            255, 226, 220, 220), // Light theme outer box color
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Colors.black
                                // Dark theme shadow
                                : const Color.fromARGB(
                                    255, 182, 174, 174), // Light theme shadow
                            spreadRadius: 1,
                            // blurRadius: 5,
                            // offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Where would you go?",
                          hintStyle: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey // Dark theme hint color
                                    : Colors.black54, // Light theme hint color
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 25,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey // Dark theme icon color
                                    : Colors.black54, // Light theme icon color
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide.none, // No border line
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
