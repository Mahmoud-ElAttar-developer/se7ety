import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:se7ety/Core/utils/colors.dart';
import 'package:se7ety/Core/utils/styles.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية (الصورة)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                opacity: .7,
                image: AssetImage(
                  'assets/beautiful-young-female-doctor-looking-camera-office.jpg',
                ),
              ),
            ),
          ),

          // النصوص العلوية للترحيب
          Container(
            padding: const EdgeInsets.only(top: 100, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('أهلاً بك', style: getTitleStyle(fontSize: 38)),
                const SizedBox(height: 10),
                Text(
                  'سجل واحجز عند دكتورك وانت في البيت',
                  style: getbodyStyle(),
                ),
              ],
            ),
          ),

          // الكارد الأبيض السفلي (الذي يحتوي على الأزرار)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.color1.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.5),
                          blurRadius: 15,
                          offset: const Offset(5, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Column(
                          children: [
                            // الزر الأول: دخول كـ دكتور (index: 0)
                            GestureDetector(
                              onTap: () {
                                context.push(
                                  '/login',
                                  extra: 0,
                                ); // 👈 يمرر الـ index كـ معامل إضافي للشاشة التالية
                              },
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  color: AppColors.scaffoldBG.withValues(
                                    alpha: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    'دكتور',
                                    style: getTitleStyle(
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            // الزر الثاني: دخول كـ مريض (index: 1)
                            GestureDetector(
                              onTap: () {
                                context.push(
                                  '/login',
                                  extra: 1,
                                ); // 👈 يمرر الـ index كـ معامل إضافي للشاشة التالية
                              },

                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  color: AppColors.scaffoldBG.withValues(
                                    alpha: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    'مريض',
                                    style: getTitleStyle(
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80), // مسافة من الأسفل لرفع الكارد
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
