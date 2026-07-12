import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_6/Fetures/authentication/presentation/view_model/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  // login
  static AuthCubit get(dynamic context) => BlocProvider.of(context);
    // login for users (Doctor / Patient)
  Future<void> login(String email, String password) async {
    emit(LoginLoadingState());
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
          
      if (credential.user != null) {
        emit(LoginSuccessState());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginErrorState(error: 'الحساب غير موجود'));
      } else if (e.code == 'wrong-password') {
        emit(LoginErrorState(error: 'كلمة المرور خاطئة'));
      } else {
        emit(LoginErrorState(error: e.message ?? 'حدثت مشكلة بالتسجيل حاول لاحقاً'));
      }
    } catch (e) {
      emit(LoginErrorState(error: 'حدث خطأ، يرجى المحاولة في وقت لاحق'));
    }
  }


  // -----------------------register for doctor------------------------

  Future<void> registerDoctor(
    String name,
    String emailAddress,
    String password,
  ) async {
    emit(RegisterLoadingState());
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );

      // حفظ اسم الدكتور داخل الحساب
      await credential.user?.updateDisplayName(name);
      log('User Created Successfully: ${credential.user?.displayName}');

      // Upload data to firestore (database)
      await FirebaseFirestore.instance
          .collection('doctor')
          .doc(credential.user!.uid)
          .set({
            'id': credential.user!.uid,
            'name': name,
            'image': null,
            'specialyzation': null,
            'rating': null,
            'email': emailAddress,
            'phone1': null,
            'phone2': null,
            'bio': null,
            'openHours': null,
            'closeHours': null,
            'address': null,
          }, SetOptions(merge: true));

      // الـ emit جوه الـ try بعد ما الخطوات تنجح وقبل القفل
      emit(RegisterSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
        emit(RegisterErrorState(error: 'كلمة المرور ضعيفة جداً'));
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
        emit(RegisterErrorState(error: 'الحساب موجود بالفعل'));
      } else {
        emit(RegisterErrorState(error: e.message ?? 'حدث خطأ في التسجيل'));
      }
    } catch (e) {
      log(e.toString());
      emit(RegisterErrorState(error: 'حدث خطأ، يرجى المحاولة في وقت لاحق'));
    }
  }

  // ----------------register for patient---------------------------
  Future<void> registerPatient(
    String name,
    String emailAddress,
    String password,
  ) async {
    emit(RegisterLoadingState());
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );

      await credential.user?.updateDisplayName(name);
      log('User Created Successfully: ${credential.user?.displayName}');

      // Upload data to firestore (database)
      await FirebaseFirestore.instance
          .collection('patient')
          .doc(credential.user!.uid)
          .set({
            'id': credential.user!.uid,
            'name': name,
            'image': null,
            'email': emailAddress,
            'role': 'patient',
            'phone': null,
            'gender': null,
            'bio': null,
            'address': null,
          }, SetOptions(merge: true));

      // الـ emit جوه الـ try بعد ما الخطوات تنجح وقبل القفل
      emit(RegisterSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
        emit(RegisterErrorState(error: 'كلمة المرور ضعيفة جداً'));
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
        emit(RegisterErrorState(error: 'الحساب موجود بالفعل'));
      } else {
        emit(RegisterErrorState(error: e.message ?? 'حدث خطأ في التسجيل'));
      }
    } catch (e) {
      log(e.toString());
      emit(RegisterErrorState(error: 'حدث خطأ، يرجى المحاولة في وقت لاحق'));
    }
  }
  //  // =================== دالة تحديث بيانات الطبيب تِبيكال من الشرح ===================
  // Future<void> updateDoctorData({
  //   required String uid,
  //   required String specialization,
  //   required String image,
  //   required String email,
  //   required String phone1,
  //   String? phone2,
  //   required String bio,
  //   required String startTime,
  //   required String endTime,
  //   required String address,
  // }) async {
  //   emit(UploadDoctorLoadingState()); // إذا كان اسمها عندك RegisterLoadingState غيرها لها
  //   try {
  //     await FirebaseFirestore.instance.collection('doctor').doc(uid).set({
  //       'image': image,
  //       'specialization': specialization,
  //       'rating': 3,
  //       'phone1': phone1,
  //       'phone2': phone2,
  //       'bio': bio,
  //       'openHour': startTime,
  //       'closeHour': endTime,
  //       'address': address,
  //     }, SetOptions(merge: true));
      
  //     emit(UploadDoctorSuccessState()); // إذا كان اسمها عندك RegisterSuccessState غيرها لها
  //   } catch (e) {
  //     emit(UploadDoctorErrorState(error: e.toString())); // إذا كان اسمها عندك RegisterErrorState غيرها لها
  //   }
  // }

    // =================== دالة تحديث بيانات الطبيب بدون Storage ===================
  Future<void> updateDoctorData({
    required String uid,
    String? image, // جعلناه اختياري
    required String specialization,
    required String email,
    required String phone1,
    required String phone2,
    required String bio,
    required String startTime,
    required String endTime,
    required String address,
  }) async {
    emit(UploadDoctorLoadingState()); // أو اسم حالة التحميل عندك
    try {
      await FirebaseFirestore.instance.collection('doctor').doc(uid).set({
        // التعديل السحري: إذا لم يرفع صورة، نضع رابط صورة الطبيب الافتراضية الجاهزة من الإنترنت
        'image': image != null && image.isNotEmpty 
            ? image 
            : 'https://flaticon.com',
        'specialization': specialization,
        'rating': 3,
        'phone1': phone1,
        'phone2': null,
        'bio': bio,
        'role': 'doctor',
        'openHour': startTime,
        'closeHour': endTime,
        'address': address,
      }, SetOptions(merge: true));
      
      emit(UploadDoctorSuccessState()); // أو اسم حالة النجاح عندك
    } catch (e) {
      emit(UploadDoctorErrorState(error: e.toString()));
    }
  }


}
