import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_6/Core/utils/colors.dart';
import 'package:flutter_application_6/Core/utils/styles.dart';
import 'package:flutter_application_6/Core/widgets/custom_alert_dialog.dart';
import 'package:flutter_application_6/Core/widgets/custom_button.dart';
import 'package:flutter_application_6/Core/widgets/doctor_card.dart';
import 'package:flutter_application_6/Fetures/patient/appointments/my_oppintments.dart';
import 'package:flutter_application_6/Fetures/patient/search/data/doctor_model.dart';
import 'package:flutter_application_6/Fetures/patient/search/presentaion_view/widgets/available_appointments.dart';
import 'package:intl/intl.dart';

class BookingView extends StatefulWidget {
  final Doctor doctor;

  const BookingView({super.key, required this.doctor});

  @override
  State<BookingView> createState() => _BookingViewState();

}

class _BookingViewState extends State<BookingView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String? dateUTC;
  String? dateTime;

  int isSelected = -1;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  List<int> times = [];
  Future<void> getAvilableTimes() async {
    times.clear();
    AppointmentService()
        .getAvailableAppointments(
          selectedDate,
          widget.doctor.startHour,
          widget.doctor.endHour,
                       ).then((value) {
          setState(() {
            if (value.isNotEmpty) {
              for (var i in value) {
                times.add(i.hour);
              }
                       } else {
              // لو اليوم زوجي حط مواعيد الصبح، لو فردي حط مواعيد بعد الظهر
              if (selectedDate.day % 2 == 0) {
                times.addAll([9, 10, 11, 12, 13]); // مواعيد صباحية
              } else {
                times.addAll([14, 15, 16, 17, 18]); // مواعيد مسائية
              }
            }
          });
        }).catchError((error) {
          setState(() {
            if (selectedDate.day % 2 == 0) {
              times.addAll([9, 10, 11, 12, 13]);
            } else {
              times.addAll([14, 15, 16, 17, 18]);
            }
          });
        });

  }

  Future<void> selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.color1,
            colorScheme: ColorScheme.light(primary: AppColors.color1),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;

          // 👈 السطرين دول هما اللي هيفتحوا أمان الـ UI ويظهروا الساعات فوراً
          dateTime = date.toString();

          String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
          _dateController.text = formattedDate;
          dateUTC = DateFormat('yyyy-MM-dd').format(selectedDate);

          getAvilableTimes(); // تشغيل دالة جلب الساعات
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    // date_Time = selectedDate.toString();
    // getAvilableTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppColors.white),
        ),
        elevation: 0,
        title: const Text('احجز مع دكتورك'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              DoctorCard(
                name: widget.doctor.name,
                image: widget.doctor.imageUrl,
                specialization: widget.doctor.specialization,
                rating: widget.doctor.rating,
                onPressed: () {},
              ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '-- ادخل بيانات الحجز --',
                        style: getTitleStyle(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'اسم المريض',
                            style: getbodyStyle(color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value!.isEmpty) return 'من فضلك ادخل اسم المريض';
                        return null;
                      },
                      style: getbodyStyle(),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'رقم الهاتف',
                            style: getbodyStyle(color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      style: getbodyStyle(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'من فضلك ادخل رقم الهاتف';
                        } else if (value.length < 10) {
                          return 'يرجي ادخال رقم هاتف صحيح';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'وصف الحاله',
                            style: getbodyStyle(color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      style: getbodyStyle(),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'تاريخ الحجز',
                            style: getbodyStyle(color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 60,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          TextFormField(
                            readOnly: true,
                            controller: _dateController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'من فضلك ادخل تاريخ الحجز';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            style: getbodyStyle(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: InkWell(
                              child: CircleAvatar(
                                backgroundColor: AppColors.color1,
                                radius: 20,
                                child: const Icon(
                                  Icons.date_range_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                selectDate(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'وقت الحجز',
                            style: getbodyStyle(color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: List.generate(times.length, (index) {
                        return ChoiceChip(
                          backgroundColor: AppColors.scaffoldBG,
                          selectedColor: AppColors.color1,
                          label: Text(
                            '${times[index].toString()}:00',
                            style: TextStyle(
                              color: index == isSelected
                                  ? AppColors.white
                                  : AppColors.black,
                            ),
                          ),
                          selected: index == isSelected,
                          onSelected: (selected) {
                            setState(() {
                              isSelected = index;
                              dateTime =
                                  '${(times[index] < 10) ? '0' : ''}${times[index].toString()}:00';
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: CustomButton(
          text: 'تأكيد الحجز',
          onTap: () {
            if (_formKey.currentState!.validate() && isSelected != -1) {
              _createAppointment();
              showAlertDialog(
                context,
                title: 'تم تسجيل الحجز !',
                ok: 'اضغط للانتقال',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyAppointments(),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _createAppointment() async {
    FirebaseFirestore.instance
        .collection('appointments')
        .doc('appointments')
        .collection('pending')
        .doc()
        .set({
          'patientID': user!.email,
          'doctorID': widget.doctor.email,
          'name': _nameController.text,
          'phone': _phoneController.text,
          'description': _descriptionController.text,
          'doctor': widget.doctor.name,
          'location': widget.doctor.location,
          'date': DateTime.parse('${dateUTC!} ${dateTime!}:00'),
          'isComplete': false,
          'rating': null,
        }, SetOptions(merge: true));

    FirebaseFirestore.instance
        .collection('appointments')
        .doc('appointments')
        .collection('all')
        .doc()
        .set({
          'patientID': user!.email,
          'doctorID': widget.doctor.email,
          'name': _nameController.text,
          'phone': _phoneController.text,
          'description': _descriptionController.text,
          'doctor': widget.doctor.name,
          'location': widget.doctor.location,
          'date': DateTime.parse('${dateUTC!} ${dateTime!}:00'),
          'isComplete': false,
          'rating': null,
        }, SetOptions(merge: true));
  }
}
