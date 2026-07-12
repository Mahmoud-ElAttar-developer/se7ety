import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:se7ety/Core/function/go_router.dart';
import 'package:se7ety/Core/utils/colors.dart';
import 'package:se7ety/Fetures/authentication/presentation/view_model/auth_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBvG9NoWNmtb9vt5EJ2LXyusMbsliZnY8I",
          appId: "1:270634137337:android:474dce6d74fd31a4609428",
          messagingSenderId: "270634137337",
          projectId: "se7ety-ec09f",
        ),
      );
    }
  } catch (e) {
    debugPrint("Firebase already initialized: $e");
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // 1. لون خلفية الشاشات الأساسية
          scaffoldBackgroundColor: AppColors.white,

          // 2. تخصيص رسائل التنبيه (SnackBar)
          snackBarTheme: SnackBarThemeData(backgroundColor: AppColors.redColor),

          // 3. تخصيص شريط التطبيق العلوي (AppBar)
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ), // تم استبدال getTitleStyle بكود فلاتر القياسي لتجنب الأخطاء
            centerTitle: true,
            elevation: 0.0,
            actionsIconTheme: IconThemeData(color: AppColors.color1),
            backgroundColor: AppColors.white,
          ),

          // 4. تخصيص حقول الإدخال (TextField / TextFormField)
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.only(
              left: 20,
              top: 10,
              bottom: 10,
              right: 20,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide.none,
            ),
            filled: true,
            suffixIconColor: AppColors.color1,
            prefixIconColor: AppColors.color1,
            fillColor: AppColors.scaffoldBG,
            // نص التلميح الافتراضي للحقول (من الصورة الثانية)
            hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
          ),

          // 5. تخصيص شكل الخطوط الفاصلة (Divider) في التطبيق (من الصورة الثانية)
          dividerTheme: const DividerThemeData(
            color: Colors
                .black, // أو يمكنك استخدام AppColors.black إذا قمت بتعريفه
            indent: 10,
            endIndent: 10,
          ),

          // 6. تحديد الخط الافتراضي للتطبيق بالكامل ليدعم العربية (من الصورة الثانية)
          fontFamily: GoogleFonts.cairo().fontFamily,
        ),
        routerConfig: router,
        builder: (context, child) =>
            Directionality(textDirection: TextDirection.rtl, child: child!),
      ),
    );
  }
}
