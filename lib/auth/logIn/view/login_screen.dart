// ignore_for_file: unnecessary_null_comparison

import 'package:collage_project/auth/logIn/controller/login_controller.dart';
import 'package:collage_project/common/colors.dart';
import 'package:collage_project/common/common_widget.dart';
import 'package:collage_project/model/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  LogInController logInController = Get.put(LogInController());
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: key,
          child: Container(
            height: ScreenUtil().screenHeight,
            width: ScreenUtil().screenWidth,
            color: AppColor.teal.withOpacity(0.5),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonWidget.sizedBox(height: 20),
                      CommonWidget.imageBuilder(
                        imagePath: "assets/images/splash_cartoon.png",
                        width: ScreenUtil().screenWidth * 0.95,
                      ),
                      CommonWidget.sizedBox(height: 10),
                      CommonWidget.commonText(
                        text: "Hi. Student",
                        fontSize: 20.sp,
                        color: AppColor.white,
                      ),
                      CommonWidget.sizedBox(height: 5),
                      CommonWidget.commonText(
                        text: "Sign in to continue",
                        color: AppColor.white,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: ScreenUtil().screenHeight * 0.63,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                      color: AppColor.white,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonWidget.sizedBox(height: 15),
                        CommonWidget.commonText(
                          text: "Mobile Number/Email",
                          color: AppColor.hintTextColor,
                        ),
                        CommonWidget.sizedBox(height: 5),
                        CommonWidget.textFormField(
                          controller: logInController.txtEmailController,
                          hintText: "Ex. user@gmail.com",
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Please Enter Enail First";
                            }
                            return null;
                          },
                        ),
                        CommonWidget.sizedBox(height: 10),
                        CommonWidget.commonText(
                          text: "Password",
                          color: AppColor.hintTextColor,
                        ),
                        CommonWidget.sizedBox(height: 5),
                        Obx(
                          () => CommonWidget.textFormField(
                            suffixIcon: CommonWidget.commonIconButton(
                              icon: logInController.checkPasswordShow.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              onPressed: () => logInController.changePassword(),
                            ),
                            controller: logInController.txtPasswordController,
                            hintText: "Ex. * * * * * * * *",
                            obscureText: logInController.checkPasswordShow.value
                                ? true
                                : false,
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "Please Enter Password First";
                              }
                              return null;
                            },
                          ),
                        ),
                        CommonWidget.sizedBox(height: 50),
                        CommonWidget.commonButton(
                          text: "Log In",
                          width: ScreenUtil().screenWidth,
                          onTap: () async {
                            AuthModel authModel = AuthModel(
                              email: logInController.txtEmailController.text,
                              password:
                                  logInController.txtPasswordController.text,
                              id: "",
                            );
                            if (key.currentState!.validate()) {
                              if (authModel.email.endsWith("gmail.com") ==
                                  false) {
                                Get.snackbar(
                                  "Enter Valid Email Ex. user@gmail.com",
                                  "",
                                );
                              } else {
                                if (authModel.password.length >= 8) {
                                  String data = await logInController.logIn(
                                    authModel: authModel,
                                  );
                                  if (data == "Success") {
                                    Get.offAndToNamed('/home_screen');
                                    Get.snackbar("LogIn Success", "");
                                  } else {
                                    Get.snackbar("Password Is Incorrect", "");
                                  }
                                } else {
                                  Get.snackbar(
                                      "Enter 8 characters or more", "");
                                }
                              }
                            }
                          },
                        ),
                        CommonWidget.sizedBox(height: 50),
                        CommonWidget.commonButton(
                          height: 20.h,
                          width: ScreenUtil().screenWidth,
                          buttonColor: Colors.transparent,
                          color: AppColor.blue,
                          text: "Create A New Account",
                          fontSize: 15.sp,
                          onTap: () {
                            Get.toNamed('/signup_screen');
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
