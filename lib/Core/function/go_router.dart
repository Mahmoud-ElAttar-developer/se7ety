import 'package:flutter_application_6/Fetures/authentication/presentation/view/doctor_upload_view.dart';
import 'package:flutter_application_6/Fetures/authentication/presentation/view/login_view.dart';
import 'package:flutter_application_6/Fetures/authentication/presentation/view/register_view.dart';
import 'package:flutter_application_6/Fetures/doctor/nav_bar.dart';
import 'package:flutter_application_6/Fetures/onboarding/on_boarding_view.dart';
import 'package:flutter_application_6/Fetures/patient/home/presentation/nav_bar.dart';
import 'package:flutter_application_6/Fetures/splash_sceen.dart';
import 'package:flutter_application_6/Fetures/welcome_view.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashSceen()),
    GoRoute(
      path: '/on_boarding_view',
      builder: (context, state) => const OnBoardingView(),
    ),
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomeView()),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        // استخراج الـ index الذي قمنا بتمريره عند الضغط على الزر
        final index = state.extra as int? ?? 0;
        return LoginView(index: index);
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        // استخراج الـ index الذي قمنا بتمريره عند الضغط على الزر
        final index = state.extra as int? ?? 0;
        return RegisterView(index: index);
      },
    ),
    GoRoute(
      path: '/doctorUpload',
      builder: (context, state) {
        // استخراج الـ index الذي قمنا بتمريره عند الضغط على الزر
        final index = state.extra as int? ?? 0;
        return DoctorUploadData(index: index);
      },
    ),
    GoRoute(
      path: '/navBarPatient',
      builder: (context, state) => const PatientMainPage(),
      
    ),
    GoRoute(
      path: '/navBarDoc',
      builder: (context, state) => const DoctorMainPage(),
    ),
  ],
);


