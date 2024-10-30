import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zoomer/presentations/screens/custom_widgets/onboarding_info.dart';
import 'package:zoomer/presentations/screens/login_screens/mapenable_screen.dart';
import 'package:zoomer/presentations/screens/onboarding_screens.dart/onboarding_two.dart';
import 'package:zoomer/presentations/screens/styles/appstyles.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pageController = PageController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SmoothPageIndicator(
            controller: pageController,
            count: controller.items.length,
            onDotClicked: (index) => pageController.animateToPage(index,
                duration: const Duration(microseconds: 600),
                curve: Curves.easeIn),
            effect: const WormEffect(
              activeDotColor: ThemeColors.primaryColor,
              dotHeight: 12,
              dotWidth: 12,
            ),
          ),
        ],
      ),
      body: PageView.builder(
        itemCount: controller.items.length,
        controller: pageController,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(controller.items[index].image,
                      fit: BoxFit.contain),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Text(
                    controller.items[index].title,
                    style: Textstyles.titleText
                        .copyWith(fontSize: screenWidth * 0.05),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    controller.items[index].description,
                    style: Textstyles.bodytext
                        .copyWith(fontSize: screenWidth * 0.04),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                  CustomCircleButton(
                      onTap: () {
                        if (index < controller.items.length - 1) {
                          // Move to the next page
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeIn,
                          );
                        } else {
                       
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MapenableScreen()));
                        }
                      },
                      icon: Icons.arrow_forward)
                  // Container(
                  //   decoration: const BoxDecoration(
                  //       color: ThemeColors.primaryColor,
                  //       shape: BoxShape.circle),
                  //   child: IconButton(
                  //       onPressed: () {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) =>
                  //                     const OnboardingScreenTwo()));
                  //       },
                  //       icon: Icon(
                  //         Icons.arrow_forward,
                  //         color: ThemeColors.titleColor,
                  //         size: screenWidth * 0.07,
                  //       )),
                  // ),
                ]),
          );
        },
      ),
    );
  }
}
