import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:se7ety/Core/utils/colors.dart';
import 'package:se7ety/Core/utils/styles.dart';
import 'package:se7ety/Fetures/onboarding/onboarding_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  var pageController = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              context.go('/welcome');
            },
            child: Text(
              'تخطى',
              style: getbodyStyle(
                fontSize: 18,
                color: AppColors.color1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: 3,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      SvgPicture.asset(model[index].image, width: 350),

                      Gap(30),
                      Text(
                        model[index].title,
                        style: TextStyle(
                          color: AppColors.color1,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(10),
                      Text(
                        model[index].description,
                        textAlign: TextAlign.center,
                        style: getbodyStyle(
                          fontSize: 16,
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(flex: 3),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: WormEffect(
                      activeDotColor: AppColors.color1,
                      dotHeight: 10,
                      dotWidth: 20,
                      spacing: 5,
                    ),
                  ),
                  Spacer(),
                  if (currentIndex == 2)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.color1,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        context.go('/welcome');
                      },
                      child: Text(
                        'التالي',
                        style: getbodyStyle(
                          fontSize: 18,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
