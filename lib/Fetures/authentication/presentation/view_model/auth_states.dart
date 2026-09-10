class AuthStates {}

class AuthInitialState extends AuthStates {}

// =================== Login States ===================
class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {}

class LoginErrorState extends AuthStates {
  final String error;
  LoginErrorState({required this.error}); // <--- التعديل السحري هنا عشان الأخطاء الحمراء تختفي
}

// =================== Register States ===================
class RegisterLoadingState extends AuthStates {}

class RegisterSuccessState extends AuthStates {}

class RegisterErrorState extends AuthStates {
  final String error;
  RegisterErrorState({required this.error});
}


// =================== Upload Doctor States ===================

class UploadDoctorLoadingState extends AuthStates {}

class UploadDoctorSuccessState extends AuthStates {}

class UploadDoctorErrorState extends AuthStates {
  final String error;
  UploadDoctorErrorState({required this.error});
}