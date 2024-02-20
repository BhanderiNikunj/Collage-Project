import 'package:collage_project/auth/user_details/controller/add_user_detail_controller.dart';
import 'package:collage_project/common/colors.dart';
import 'package:collage_project/common/common_widget.dart';
import 'package:collage_project/common/drop_down.dart';
import 'package:collage_project/model/user_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddUserDetailsScreen extends StatefulWidget {
  const AddUserDetailsScreen({super.key});

  @override
  State<AddUserDetailsScreen> createState() => _AddUserDetailsScreenState();
}

class _AddUserDetailsScreenState extends State<AddUserDetailsScreen> {
  AddUserDetailsController controller = Get.put(AddUserDetailsController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Stack(
              children: [
                Container(
                  height: ScreenUtil().screenHeight,
                  decoration: BoxDecoration(
                    color: AppColor.teal.withOpacity(0.85),
                  ),
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "assets/images/star_pattern.png",
                          ),
                          Image.asset(
                            "assets/images/star_pattern.png",
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonWidget.commonText(
                              text: "Your Details",
                              color: AppColor.white,
                              fontSize: 20.sp,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: ScreenUtil().screenHeight * 0.80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                      color: AppColor.white,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    child: textFeildView(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget textFeildView() {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidget.sizedBox(height: 20),
            CommonWidget.commonText(
              text: "Enter Your Name",
            ),
            CommonWidget.sizedBox(height: 8),
            CommonWidget.textFormField(
              controller: controller.firstNameController,
              hintText: "Enter Your Name",
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Enter Your Name';
                }
                return null;
              },
            ),
            CommonWidget.sizedBox(height: 10),
            CommonWidget.commonText(
              text: "Enter Your Surname",
            ),
            CommonWidget.sizedBox(height: 8),
            CommonWidget.textFormField(
              controller: controller.lastNameController,
              hintText: "Enter Your Surname",
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Enter Your Surname';
                }
                return null;
              },
            ),
            CommonWidget.sizedBox(height: 10),
            CommonWidget.commonText(
              text: "Enter Your Father Name",
            ),
            CommonWidget.sizedBox(height: 8),
            CommonWidget.textFormField(
              controller: controller.fatherNameController,
              hintText: "Enter Your Father Name",
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Enter Your Father Name';
                }
                return null;
              },
            ),
            CommonWidget.sizedBox(height: 10),
            CommonWidget.commonText(
              text: "Enter Your EmailId",
            ),
            CommonWidget.sizedBox(height: 8),
            CommonWidget.textFormField(
              controller: controller.emailIdController,
              hintText: "Enter Your EmailId",
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Enter Your Email';
                }
                return null;
              },
            ),
            CommonWidget.sizedBox(height: 10),
            CommonWidget.commonText(
              text: "Enter Your Mobile No.",
            ),
            CommonWidget.sizedBox(height: 8),
            CommonWidget.textFormField(
              maxLength: 10,
              controller: controller.mobileNoController,
              keyboardType: TextInputType.phone,
              hintText: "Enter Your Mobile No.",
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Enter Your Mobile No.';
                }
                return null;
              },
            ),
            CommonWidget.sizedBox(height: 10),
            CommonWidget.commonText(
              text: "Select Your Std",
            ),
            CommonWidget.sizedBox(height: 8),
            CustomDropdownButton(
              selectedOptions: controller.std,
              useTextField: false,
              onOptionSelected: (v) => setState(() {
                controller.std = v;
              }),
              dataList: List.generate(
                12,
                (index) => (index + 1).toString(),
              ),
            ),
            CommonWidget.sizedBox(height: 10),
            CommonWidget.commonText(
              text: "Select Your Study Language",
            ),
            CommonWidget.sizedBox(height: 8),
            CustomDropdownButton(
              selectedOptions: controller.studyType,
              useTextField: false,
              onOptionSelected: (v) => setState(() {
                controller.studyType = v;
              }),
              dataList: List.generate(
                controller.listOfStudyType.length,
                (index) => controller.listOfStudyType[index],
              ),
            ),
            CommonWidget.sizedBox(height: 30),
            Center(
              child: CommonWidget.commonButton(
                text: "Submit",
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    UserDetailModel model = UserDetailModel(
                      id: "",
                      firstName: controller.firstNameController.text,
                      lastName: controller.lastNameController.text,
                      fatherName: controller.fatherNameController.text,
                      std: controller.std,
                      mobileNo: controller.mobileNoController.text,
                      studentType: controller.studyType,
                      emailId: controller.emailIdController.text,
                      fcmToken: await controller.findFcm(),
                      uid: controller.findUid(),
                    );
                    String messgae = await controller.addStudentDetail(
                      model: model,
                    );

                    if (messgae == 'Success') {
                      Get.offAndToNamed(
                        '/home_screen',
                        arguments: model.firstName + model.lastName,
                      );
                      Get.snackbar("Success", "");
                    } else {
                      Get.snackbar("Failed", "");
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
