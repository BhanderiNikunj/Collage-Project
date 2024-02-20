import 'package:collage_project/model/home_work_model.dart';
import 'package:collage_project/utiles/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeWorkControlle extends GetxController {
  List<HomeWorkModel> listOfHomeWork = [];
  String subject = "math";
  List<String> listOfSubject = ["math", "social science", "science", "english"];

  Stream<QuerySnapshot<Map<String, dynamic>>> readStudentDetail() {
    return FirebaseHelper.readStudentDetail();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readHomeWork() {
    return FirebaseHelper.readStudentHomeWork();
  }

  String findUid() {
    return FirebaseHelper.findUid();
  }
}
