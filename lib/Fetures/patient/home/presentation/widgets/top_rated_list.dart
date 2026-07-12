import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_6/Fetures/patient/search/presentaion_view/doctor_profile.dart';
import 'package:flutter_application_6/core/widgets/doctor_card.dart';

class TopRatedList extends StatefulWidget {
  const TopRatedList({super.key});

  @override
 State<TopRatedList> createState() => _TopRatedListState();

}

class _TopRatedListState extends State<TopRatedList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('doctor')
            .orderBy('rating', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doctor = snapshot.data!.docs[index];
                var doctorData = doctor.data() as Map<String, dynamic>? ?? {};
                if (doctor.exists == false || doctorData.isEmpty) {
                  return const SizedBox();
                }

                return DoctorCard(
                  name: doctorData.containsKey('name') && doctor['name'] != null
                      ? doctor['name']
                      : 'طبيب افتراضي',
                                     image: doctorData.containsKey('image') &&
                  doctor['image'] != null &&
                  doctor['image'].toString().trim().isNotEmpty && // فحص لو مش فارغ
                  doctor['image'].toString().startsWith('http')
              ? doctor['image']
              : 'assets/3d-happy-cartoon-doctor-doctor-cartoon-doctor-on-transparent-background-generative-ai-png.webp',


                  specialization:
                      doctorData.containsKey('specialization') &&
                          doctor['specialization'] != null
                      ? doctor['specialization']
                      : 'تخصص عام',
                  rating:
                      doctorData.containsKey('rating') &&
                          doctor['rating'] != null
                      ? doctor['rating']
                      : 0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DoctorProfile(doctor: doctor['name']),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
