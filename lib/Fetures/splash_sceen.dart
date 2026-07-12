import 'package:flutter/material.dart';
import 'package:flutter_application_6/Core/utils/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashSceen extends StatefulWidget {
  const SplashSceen({super.key});

  @override
  State<SplashSceen> createState() => _SplashSceenState();
}

class _SplashSceenState extends State<SplashSceen> {
  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/on_boarding_view');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/Pediatrics.json', width: 350),
          Text('المستشفى الطبي',style: TextStyle(color:AppColors.color1,fontSize: 22, fontWeight: FontWeight.bold),)
        ],
      ),),
    );
  }
}
