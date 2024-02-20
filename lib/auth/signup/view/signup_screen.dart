// ignore_for_file: unnecessary_null_comparison

import 'package:collage_project/auth/signup/controller/signup_controller.dart';
import 'package:collage_project/common/colors.dart';
import 'package:collage_project/common/common_widget.dart';
import 'package:collage_project/model/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpController signUpController = Get.put(SignUpController());
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
                        text: "Sign Up to continue",
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
                          controller: signUpController.txtEmailController,
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
                              icon: signUpController.checkPasswordShow.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              onPressed: () =>
                                  signUpController.changePassword(),
                            ),
                            controller: signUpController.txtPasswordController,
                            hintText: "Ex. * * * * * * * *",
                            obscureText:
                                signUpController.checkPasswordShow.value
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
                          text: "Sign Up",
                          width: ScreenUtil().screenWidth,
                          onTap: () async {
                            AuthModel authModel = AuthModel(
                              email: signUpController.txtEmailController.text,
                              password:
                                  signUpController.txtPasswordController.text,
                              id: "",
                            );
                            if (key.currentState!.validate()) {
                              bool check = authModel.email.endsWith(
                                "gmail.com",
                              );
                              if (check == false) {
                                Get.snackbar(
                                  "Enter Valid Email Ex. user@gmail.com",
                                  "",
                                );
                              } else {
                                if (authModel.password.length >= 8) {
                                  String data = await signUpController.signUp(
                                    authModel: authModel,
                                  );
                                  if (data == "true") {
                                    Get.offAndToNamed(
                                      '/add_user_detail_screen',
                                      arguments: authModel.email,
                                    );
                                    Get.snackbar("LogIn Success", "");
                                  } else {
                                    Get.snackbar("Password Is Incorrect", data);
                                  }
                                } else {
                                  Get.snackbar(
                                    "Enter 8 characters or more",
                                    "",
                                  );
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
                          text: "Alrady Have An Accountt",
                          fontSize: 15.sp,
                          onTap: () {
                            Get.back();
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
