import 'package:collage_project/model/auth_model.dart';
import 'package:collage_project/model/uid_model.dart';
import 'package:collage_project/utiles/firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPasswordController = TextEditingController();
  TextEditingController txtNameController = TextEditingController();
  List<UidModel> list = [];
  RxBool checkPasswordShow = true.obs;

  Future<String> signUp({required AuthModel authModel}) async {
    return FirebaseHelper.signUp(authModel: authModel);
  }

  void changePassword() {
    checkPasswordShow.value = !checkPasswordShow.value;
  }
}
