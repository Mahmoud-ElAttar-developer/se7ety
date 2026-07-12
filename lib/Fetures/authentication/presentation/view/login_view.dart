import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:se7ety/Core/utils/colors.dart';
import 'package:se7ety/Core/utils/styles.dart';
import 'package:se7ety/Fetures/authentication/presentation/view_model/auth_cubit.dart';
import 'package:se7ety/Fetures/authentication/presentation/view_model/auth_states.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.index});
  final int index;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisible = true;

  String handleUserType() {
    return widget.index == 0 ? 'دكتور' : 'مريض';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          // إغلاق أي دايالوج مفتوح أولاً ثم الانتقال
          Navigator.of(context, rootNavigator: true).pop();
          if (widget.index == 0) {
            context.go('/navBarDoc');
          } else {
            context.go('/navBarPatient');
          }
        } else if (state is LoginLoadingState) {
          // عرض دايالوج التحميل فقط عند حالة الـ Loading
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black.withAlpha((0.7 * 255).round()),
            builder: (BuildContext dialogContext) {
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
        } else if (state is LoginErrorState) {
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
                    const SizedBox(height: 15),

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
                            // دالة login واحدة كافية للجميع (دكتور ومريض)
                            await context.read<AuthCubit>().login(
                              _emailController.text
                                  .trim(), // تأكد من وجود الشرطة السفلية أو حذفها حسب تعريفك لها
                              _passwordController.text.trim(),
                            );
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
                              context.push('/register', extra: widget.index);

                              // context.go('/register');
                            },
                            child: Text(
                              'سجل الآن',
                              style: getbodyStyle(color: AppColors.color1),
                            ),
                          ),
                          Text('ليس لديك حساب؟', style: getbodyStyle()),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
