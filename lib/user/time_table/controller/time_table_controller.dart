import 'package:collage_project/model/time_table_model.dart';
import 'package:collage_project/utiles/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TimeTableController extends GetxController {
  List<TimeTableModel> listOfTimeTable = [];
  String dayIndex = "MON";
  List<String> weekNameList = ["MON", "TUE", "WED", "THU", "FRI", "SAT"];

  Stream<QuerySnapshot<Map<String, dynamic>>> readStudentTimeTable() {
    return FirebaseHelper.readStudentTimeTable();
  }
}
