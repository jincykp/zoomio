import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Make sure to import this package
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zoomer/views/screens/login_screens/welcome.dart';
import 'package:zoomer/views/screens/onboarding/bloc/onboarding_bloc.dart';
import 'package:zoomer/views/screens/custom_widgets/onboarding_info.dart';
import 'package:zoomer/views/screens/login_screens/map_enable.dart';
import 'package:zoomer/views/screens/styles/appstyles.dart';
// Import your bloc

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingItems();
    final pageController = PageController();

    return BlocProvider(
      create: (context) => OnboardingBloc(
          totalPages: controller.items.length), // Pass totalPages here
      child: Scaffold(
        bottomSheet: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: controller.items.length,
                  onDotClicked: (index) => pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeIn,
                  ),
                  effect: const WormEffect(
                    activeDotColor: ThemeColors.primaryColor,
                    dotHeight: 12,
                    dotWidth: 12,
                  ),
                ),
              ],
            );
          },
        ),
        body: PageView.builder(
          itemCount: controller.items.length,
          controller: pageController,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(controller.items[index].image,
                      fit: BoxFit.contain),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    controller.items[index].title,
                    style: Textstyles.gTitle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    controller.items[index].description,
                    style: Textstyles.gTextdescription,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  // Conditionally render the button
                  if (index == controller.items.length - 1)
                    CustomCircleButton(
                      onTap: () {
                        final onboardingBloc =
                            BlocProvider.of<OnboardingBloc>(context);
                        onboardingBloc
                            .add(NextPageEvent()); // Emit the next page event
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomeScreen()),
                        );
                      },
                      icon: Icons.arrow_forward,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
