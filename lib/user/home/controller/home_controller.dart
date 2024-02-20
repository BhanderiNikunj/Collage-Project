import 'package:collage_project/model/image_model.dart';
import 'package:collage_project/model/title_model.dart';
import 'package:collage_project/model/user_detail_model.dart';
import 'package:collage_project/utiles/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  List<TitleModel> listOfHomeData = [
    TitleModel(
      image: 'assets/images/assignment.png',
      routes: '/home_work_screen',
      name: 'Home Works',
    ),
    TitleModel(
      image: 'assets/images/fees.png',
      routes: '/fees_screen',
      name: 'Fees',
    ),
    TitleModel(
      image: 'assets/images/leave_application.png',
      routes: '/leave_screen',
      name: 'Leaves',
    ),
    TitleModel(
      image: 'assets/images/time_table.png',
      routes: '/time_table_screen',
      name: 'Time Table',
    ),
    TitleModel(
      image: 'assets/images/result.png',
      routes: '/result_screen',
      name: 'Result',
    ),
    TitleModel(
      image: 'assets/images/school_gallery.png',
      routes: '/bright_gallery_screen',
      name: 'Bright Gallery',
    ),
    TitleModel(
      image: 'assets/images/message.png',
      routes: '/message_screen',
      name: 'Message',
    ),
    TitleModel(
      image: 'assets/images/log_out.png',
      routes: '',
      name: 'Log Out',
    ),
  ];
  List<ImageModel> listOfImage = [];

  void logOut({required BuildContext context}) {
    FirebaseHelper.logOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login_screen',
      (route) => false,
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readStudentDetail() {
    return FirebaseHelper.readStudentDetail();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readImages() {
    return FirebaseHelper.readImages();
  }

  String findUid() {
    return FirebaseHelper.findUid();
  }

  Future<String> updateStudentDetail({required UserDetailModel model}) {
    return FirebaseHelper.updateStudentDetail(model: model);
  }
}
