import 'package:collage_project/model/leave_model.dart';
import 'package:collage_project/utiles/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveController extends GetxController {
  List<LeaveModel> listOfLeave = [];

  TextEditingController firstNameController = TextEditingController();
  TextEditingController leaveResionController = TextEditingController();
  TextEditingController leaveStartDateController = TextEditingController(
    text:
        "${DateTime.now().day} / ${DateTime.now().month} / ${DateTime.now().year}",
  );
  TextEditingController leaveEndDateController = TextEditingController(
    text:
        "${DateTime.now().day} / ${DateTime.now().month} / ${DateTime.now().year}",
  );

  Stream<QuerySnapshot<Map<String, dynamic>>> readStudentLeave() {
    return FirebaseHelper.readLeave();
  }

  Future<String> addStudentLeave({required LeaveModel model}) {
    return FirebaseHelper.addLeave(model: model);
  }

  Future<String> updateStudentLeave({ required LeaveModel model}) {
    return FirebaseHelper.updateLeave(model:model);
  }

  Future<String> deleteStudentLeave({required String id}) {
    return FirebaseHelper.deleteLeave(id: id);
  }
}
