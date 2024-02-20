import 'package:collage_project/model/auth_model.dart';
import 'package:collage_project/utiles/firebase_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LogInController extends GetxController {
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPasswordController = TextEditingController();
  RxBool checkPasswordShow = true.obs;

  Future<String> logIn({required AuthModel authModel}) {
    return FirebaseHelper.logIn(authModel: authModel);
  }

  void changePassword() {
    checkPasswordShow.value = !checkPasswordShow.value;
  }
}
