import 'package:collage_project/model/user_detail_model.dart';
import 'package:collage_project/utiles/firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUserDetailsController extends GetxController {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  List<String> listOfStudyType = ['Gujarati', "Hindi", 'English'];
  String std = "1";
  String studyType = "Gujarati";

  Future<String> addStudentDetail({required UserDetailModel model}) {
    return FirebaseHelper.addStudentDetail(model: model);
  }

  Future<String> findFcm() {
    return FirebaseHelper.findFcmToken();
  }

  String findUid() {
    return FirebaseHelper.findUid();
  }
}
