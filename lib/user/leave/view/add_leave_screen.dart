import 'package:collage_project/common/colors.dart';
import 'package:collage_project/common/common_widget.dart';
import 'package:collage_project/model/leave_model.dart';
import 'package:collage_project/user/leave/controller/leave_controller.dart';
import 'package:collage_project/utiles/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddLeaveScreen extends StatefulWidget {
  const AddLeaveScreen({super.key});

  @override
  State<AddLeaveScreen> createState() => AddLeaveScreenState();
}

class AddLeaveScreenState extends State<AddLeaveScreen> {
  int index = Get.arguments;
  LeaveController controller = Get.put(LeaveController());
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    controller.firstNameController = TextEditingController(
      text: "${userDetails?.firstName} ${userDetails?.lastName}",
    );
    if (index != -1) {
      controller.leaveResionController = TextEditingController(
        text: controller.listOfLeave[index].resion,
      );
      controller.leaveStartDateController = TextEditingController(
        text: controller.listOfLeave[index].dateFrom,
      );
      controller.leaveEndDateController = TextEditingController(
        text: controller.listOfLeave[index].dateTo,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            topImageView(context: context),
            CommonWidget.bottomImageCommonView(),
          ],
        ),
      ),
    );
  }

  Widget topImageView({required BuildContext context}) {
    return Stack(
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
                  CommonWidget.imageBuilder(
                    imagePath: 'assets/images/star_pattern.png',
                  ),
                  CommonWidget.imageBuilder(
                    imagePath: 'assets/images/star_pattern.png',
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CommonWidget.commonIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onPressed: () => Navigator.pop(context),
                      color: AppColor.white,
                    ),
                    CommonWidget.commonText(
                      text:
                          index != -1 ? "Update Your Leave" : "Add Your Leave",
                      color: AppColor.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomScreenView(),
      ],
    );
  }

  Widget bottomScreenView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: ScreenUtil().screenHeight * 0.80,
        width: ScreenUtil().screenWidth,
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
        child: Form(
          key: key,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidget.sizedBox(height: 15),
                CommonWidget.commonText(
                  text: "Your Name",
                  fontSize: 14.sp,
                ),
                CommonWidget.sizedBox(height: 8),
                CommonWidget.textFormField(
                  controller: controller.firstNameController,
                  hintText: "Enter Your Name",
                  enabled: false,
                  fillColor: AppColor.teal.withOpacity(0.3),
                  textColor: AppColor.textColor,
                ),
                CommonWidget.sizedBox(height: 10),
                CommonWidget.commonText(
                  text: "Your Leave Resion",
                  fontSize: 14.sp,
                ),
                CommonWidget.sizedBox(height: 8),
                CommonWidget.textFormField(
                  controller: controller.leaveResionController,
                  hintText: "Enter Your Leave Resion",
                  fillColor: AppColor.teal.withOpacity(0.3),
                  textColor: AppColor.textColor,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "Enter a Leave Resion";
                    }
                    return null;
                  },
                ),
                CommonWidget.sizedBox(height: 10),
                CommonWidget.commonText(
                  text: "Leave Start Date",
                  fontSize: 14.sp,
                ),
                CommonWidget.sizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    DateTime dateTime = await CommonWidget.commonDatePicker(
                      context: context,
                    );
                    controller.leaveStartDateController = TextEditingController(
                      text:
                          "${dateTime.day} / ${dateTime.month} / ${dateTime.year}",
                    );
                    setState(() {});
                  },
                  child: CommonWidget.textFormField(
                    controller: controller.leaveStartDateController,
                    hintText: "Enter Leave Start Day",
                    enabled: false,
                    fillColor: AppColor.teal.withOpacity(0.3),
                    textColor: AppColor.textColor,
                  ),
                ),
                CommonWidget.sizedBox(height: 10),
                CommonWidget.commonText(
                  text: "Leave End Date",
                  fontSize: 14.sp,
                ),
                CommonWidget.sizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    List date =
                        controller.leaveStartDateController.text.split(' / ');
                    DateTime dateTime = await CommonWidget.commonDatePicker(
                      context: context,
                      minDate: DateTime(
                        int.parse(date[2]),
                        int.parse(date[1]),
                        int.parse(date[0]),
                      ),
                    );
                    controller.leaveEndDateController = TextEditingController(
                      text:
                          "${dateTime.day} / ${dateTime.month} / ${dateTime.year}",
                    );
                    setState(() {});
                  },
                  child: CommonWidget.textFormField(
                    controller: controller.leaveEndDateController,
                    hintText: "Enter Leave End Day",
                    enabled: false,
                    fillColor: AppColor.teal.withOpacity(0.3),
                    textColor: AppColor.textColor,
                  ),
                ),
                CommonWidget.sizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonWidget.commonButton(
                      fontSize: 14.sp,
                      text: index == -1 ? "Add Data" : "Update Data",
                      onTap: () async {
                        if (key.currentState!.validate()) {
                          String message = "";
                          LeaveModel model = LeaveModel(
                            status: 'pending',
                            id: index != -1
                                ? controller.listOfLeave[index].id
                                : "",
                            firstName: controller.firstNameController.text,
                            std: userDetails?.std ?? "",
                            resion: controller.leaveResionController.text,
                            dateFrom:
                                controller.leaveStartDateController.value.text,
                            dateTo:
                                controller.leaveEndDateController.value.text,
                          );
                          if (index == -1) {
                            message = await controller.addStudentLeave(
                              model: model,
                            );
                          } else {
                            message = await controller.updateStudentLeave(
                              model: model,
                            );
                          }
                          if (message.compareTo("Success") == 0) {
                            Get.back();
                            Get.snackbar("Success", "");
                            removeData();
                          } else {
                            Get.snackbar("Enter Valid Data", "");
                          }
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void removeData() {
    controller.firstNameController.clear();
    controller.leaveEndDateController = TextEditingController(
      text:
          "${DateTime.now().day} / ${DateTime.now().month} / ${DateTime.now().year}",
    );
    controller.leaveResionController.clear();
    controller.leaveStartDateController = TextEditingController(
      text:
          "${DateTime.now().day} / ${DateTime.now().month} / ${DateTime.now().year}",
    );
  }
}
