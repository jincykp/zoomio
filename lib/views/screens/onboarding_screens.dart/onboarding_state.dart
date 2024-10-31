import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zoomer/views/screens/custom_widgets/onboarding_info.dart';
import 'package:zoomer/views/screens/login_screens/map_enable.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';

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
                    controller.items[index].title, style: Textstyles.gText,
                    // style: Textstyles.titleText
                    //     .copyWith(fontSize: screenWidth * 0.05),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    controller.items[index].description,
                    style: Textstyles.gTextdescription,
                    // style: Textstyles.bodytext
                    //     .copyWith(fontSize: screenWidth * 0.04),
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
                ]),
          );
        },
      ),
    );
  }
}
