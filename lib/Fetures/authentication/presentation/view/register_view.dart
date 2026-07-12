import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_6/Core/utils/colors.dart';
import 'package:flutter_application_6/Core/utils/styles.dart';
import 'package:flutter_application_6/Fetures/authentication/presentation/view_model/auth_cubit.dart';
import 'package:flutter_application_6/Fetures/authentication/presentation/view_model/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key, required this.index});
  final int index;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisible = true;

  String handleUserType() {
    return widget.index == 0 ? 'دكتور' : 'مريض';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) async {
       
        if (state is RegisterSuccessState) {
          // إغلاق أي دايالوج مفتوح أولاً ثم الانتقال
         if (widget.index==0) {
          context.go('/doctorUpload');
        }else{
          context.go('/navBarPatient');
        }
        } else if (state is RegisterLoadingState) {
          // عرض دايالوج التحميل فقط عند حالة الـ Loading
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black.withAlpha((0.7 * 255).round()),
            builder: (BuildContext context) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/Sandy Loading.json',
                    width: 150,
                    height: 150,
                  ),
                ],
              );
            },
          );
        } else if (state is RegisterErrorState) {
          // إغلاق دايالوج التحميل أولاً ثم عرض الخطأ
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('خطأ'),
              content: Text(state.error),
            ),
          );
        }
      },

      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "سجل دخول الآن كـ ${handleUserType()}",
                      style: getTitleStyle(),
                    ),
                    const SizedBox(height: 30),

                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _nameController,
                      textAlign: TextAlign.end,
                      decoration: const InputDecoration(
                        hintText: 'name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'من فضلك أدخل الاسم';
                        }
                        return null;
                      },
                    ),

                    Gap(15),

                    // حقل البريد الإلكتروني
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      textAlign: TextAlign.end,
                      decoration: const InputDecoration(
                        hintText: 'Sayed@example.com',
                        prefixIcon: Icon(Icons.email_rounded),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'من فضلك أدخل الإيميل';
                        }
                        return null;
                      },
                    ),
                    Gap(15),

                    // حقل كلمة المرور
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      textAlign: TextAlign.end,
                      obscureText: isVisible,
                      decoration: InputDecoration(
                        hintText: '********',
                        prefixIcon: const Icon(Icons.lock_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isVisible ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'من فضلك أدخل كلمة المرور';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // زر تسجيل الدخول
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (widget.index == 0) {
                              // 1. تسجيل حساب دكتور
                              await context.read<AuthCubit>().registerDoctor(
                                _nameController.text.trim(),
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );
                            } else {
                              // 2. تسجيل حساب مريض
                              await context.read<AuthCubit>().registerPatient(
                                _nameController.text.trim(),
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.color1,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          "تسجيل الدخول",
                          style: getTitleStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // التوجيه لإنشاء حساب جديد
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              
                              context.go('/login');
                            },
                            child: Text(
                              'تسجيل دخول',
                              style: getbodyStyle(color: AppColors.color1),
                            ),
                          ),
                          Text('لديك حساب؟', style: getbodyStyle()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
