import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_6/Core/utils/colors.dart';
import 'package:flutter_application_6/Core/utils/styles.dart';
import 'package:flutter_application_6/Fetures/authentication/data/specilaization_list.dart';
import 'package:flutter_application_6/Fetures/authentication/presentation/view_model/auth_cubit.dart';
import 'package:flutter_application_6/Fetures/authentication/presentation/view_model/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class DoctorUploadData extends StatefulWidget {
  const DoctorUploadData({super.key, required int index});

  @override
  DoctorUploadDataState createState() => DoctorUploadDataState();
}

class DoctorUploadDataState extends State<DoctorUploadData> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone1 = TextEditingController();
  final TextEditingController _phone2 = TextEditingController();
  String _specialization = specialization[0];

  late String _startTime =
      DateFormat('hh:mm a').format(DateTime(2023, 9, 7, 10, 00));
  late String _endTime =
      DateFormat('hh:mm a').format(DateTime(2023, 9, 7, 22, 00));

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  // 1- instance of the firebase storage with the bucket URL...

  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: 'gs://se7ety-a9f9b.appspot.com');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _imagePath;
  File? file;
  String? profileUrl;

  User? user;
  String? userID;

  Future<void> _getUser() async {
    user = FirebaseAuth.instance.currentUser;
    userID = user?.uid;
  }


  // method to upload and get the image url

  Future<String> uploadImageToFireStore(File image, String imageName) async {
    // 2- choose file location (path)
    Reference ref =
        _storage.ref().child('doctor/${_auth.currentUser!.uid}$imageName');
        // 3- choose the file tybe ( image/jpeg)
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    // 4- upload Image to storage
    await ref.putFile(image, metadata);
    // 5- get the image url
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<void> _pickImage() async {
    _getUser();
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        // to upload the file (image) to firebase storage
        file = File(pickedFile.path);
      });
    }
    profileUrl = await uploadImageToFireStore(file!, 'doc');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
           listener: (context, state) {
          if (state is UploadDoctorSuccessState) {
            // استخدام حالة النجاح اللي عندك في الـ states
           context.go('/navBarDoc');
          } else if (state is UploadDoctorErrorState) {
            // استخدام حالة الخطأ اللي عندك في الـ states
            Navigator.of(context).pop();
            // إظهار الخطأ باستخدام الـ SnackBar الافتراضي عشان الـ dialog مش معموله import
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is UploadDoctorLoadingState) {
            // دايالوج التحميل المؤقت
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(child: CircularProgressIndicator()),
            );
          }
        },

      child: Scaffold(
        appBar: AppBar(
          title:  Text('إكمال عملية التسجيل',style: TextStyle(color: AppColors.color1),),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                updateProfileDoctor(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(top: 25.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthCubit>().updateDoctorData(
                      uid: userID ?? '',
                      image:  '',
                      specialization: _specialization,
                      email: user!.email ?? '',
                      phone1: _phone1.text,
                      bio: _bio.text,
                      startTime: _startTime,
                      endTime: _endTime,
                      address: _address.text, phone2: '');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.color1,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "التسجيل",
                style: getTitleStyle(fontSize: 16, color: AppColors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget updateProfileDoctor() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                // backgroundColor: AppColors.lightBg,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: (_imagePath != null)
                      ? FileImage(File(_imagePath!)) as ImageProvider
                      : const AssetImage('assets/person.jpg'),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await _pickImage();
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 20,
                    // color: AppColors.color1,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
            child: Row(
              children: [
                Text(
                  'التخصص',
                  style: getbodyStyle(color: AppColors.black),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
                color: AppColors.scaffoldBG,
                borderRadius: BorderRadius.circular(20)),
            child: DropdownButton(
              isExpanded: true,
              iconEnabledColor: AppColors.color1,
              icon: const Icon(Icons.expand_circle_down_outlined),
              value: _specialization,
              onChanged: (String? newValue) {
                setState(() {
                  _specialization = newValue ?? specialization[0];
                });
              },
              items: specialization.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'نبذة تعريفية',
                  style: getbodyStyle(color: AppColors.black),
                )
              ],
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            maxLines: 5,
            controller: _bio,
            style: TextStyle(color: AppColors.black),
            decoration: const InputDecoration(
                hintText:
                    'سجل المعلومات الطبية العامة مثل تعليمك الأكاديمي وخبراتك السابقة...'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'من فضلك ادخل النبذة التعريفية';
              } else {
                return null;
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'عنوان العيادة',
                  style: getbodyStyle(color: AppColors.black),
                )
              ],
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _address,
            style: TextStyle(color: AppColors.black),
            decoration: const InputDecoration(
              hintText: '5 شارع مصدق - الدقي - الجيزة',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'من فضلك ادخل عنوان العيادة';
              } else {
                return null;
              }
            },
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'ساعات العمل من',
                        style: getbodyStyle(color: AppColors.black),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'الي',
                        style: getbodyStyle(color: AppColors.black),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              // ---------- Start Time ----------------
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () async {
                          await showStartTimePicker();
                        },
                        icon: Icon(
                          Icons.watch_later_outlined,
                          color: AppColors.color1,
                        )),
                    hintText: _startTime,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),

              // ---------- End Time ----------------
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () async {
                          await showEndTimePicker();
                        },
                        icon: Icon(
                          Icons.watch_later_outlined,
                          color: AppColors.color1,
                        )),
                    hintText: _endTime,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'رقم الهاتف 1',
                  style: getbodyStyle(color: AppColors.black),
                )
              ],
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _phone1,
            style: TextStyle(color: AppColors.black),
            decoration: const InputDecoration(
              hintText: '+20xxxxxxxxxx',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'من فضلك ادخل الرقم';
              } else {
                return null;
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'رقم الهاتف 2 (اختياري)',
                  style: getbodyStyle(color: AppColors.black),
                )
              ],
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _phone2,
            style: TextStyle(color: AppColors.black),
            decoration: const InputDecoration(
              hintText: '+20xxxxxxxxxx',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showStartTimePicker() async {
    final datePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            timePickerTheme: TimePickerThemeData(
                helpTextStyle: TextStyle(color: AppColors.color1),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor),
            colorScheme: ColorScheme.light(
                surface: Theme.of(context).scaffoldBackgroundColor,
              primary: AppColors.color1, // header background color
              secondary: AppColors.black,
              onSecondary: AppColors.black,
              onPrimary: AppColors.black, // header text color
              onSurface: AppColors.black, // body text color
              // surface: AppColors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.color1, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (datePicked != null) {
      setState(() {
        _startTime = datePicked.format(context);
      });
    }
  }

  Future<void> showEndTimePicker() async {
    final timePicker = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          DateTime.now().add(const Duration(minutes: 15))),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            timePickerTheme: TimePickerThemeData(
                helpTextStyle: TextStyle(color: AppColors.color1),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor),
            colorScheme: ColorScheme.light(
                surface: Theme.of(context).scaffoldBackgroundColor,
              primary: AppColors.color1, // header background color
              secondary: AppColors.black,
              onSecondary: AppColors.black,
              onPrimary: AppColors.black, // header text color
              onSurface: AppColors.black, // body text color
              // surface: AppColors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.color1, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (timePicker != null) {
      setState(() {
        _endTime = timePicker.format(context);
      });
    }
  }
}