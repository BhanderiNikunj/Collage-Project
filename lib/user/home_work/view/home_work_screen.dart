import 'package:collage_project/common/colors.dart';
import 'package:collage_project/common/common_widget.dart';
import 'package:collage_project/model/home_work_model.dart';
import 'package:collage_project/user/home_work/controller/home_work_controller.dart';
import 'package:collage_project/utiles/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:collage_project/common/drop_down1.dart' as drop;

class HomeWorkScreen extends StatefulWidget {
  const HomeWorkScreen({super.key});

  @override
  State<HomeWorkScreen> createState() => _HomeWorkScreenState();
}

class _HomeWorkScreenState extends State<HomeWorkScreen> {
  HomeWorkControlle controller = Get.put(HomeWorkControlle());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Stack(
              children: [
                topView(context: context),
                bottomView(),
              ],
            ),
            CommonWidget.bottomImageCommonView(),
          ],
        ),
      ),
    );
  }

  Widget bottomView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: ScreenUtil().screenHeight * 0.8,
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
        child: homeWorkDataView(),
      ),
    );
  }

  Widget topView({required BuildContext context}) {
    return Container(
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
            padding: EdgeInsets.only(top: 8.h),
            child: Column(
              children: [
                Row(
                  children: [
                    CommonWidget.commonIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onPressed: () => Navigator.pop(context),
                      color: AppColor.white,
                    ),
                    CommonWidget.commonText(
                      text: "Home Work",
                      color: AppColor.white,
                    )
                  ],
                ),
                CommonWidget.sizedBox(
                  width: 150,
                  child: drop.DropdownButton(
                    value: controller.subject,
                    isExpanded: true,
                    items: List.generate(
                      controller.listOfSubject.length,
                      (index) => drop.DropdownMenuItem(
                        value: controller.listOfSubject[index],
                        child: CommonWidget.commonText(
                          text: controller.listOfSubject[index],
                        ),
                      ),
                    ),
                    onChanged: (v) => setState(() {
                      controller.subject = v.toString();
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget homeWorkDataView() {
    return StreamBuilder(
      stream: controller.readHomeWork(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
              snapshot.data?.docs ?? [];
          controller.listOfHomeWork.clear();
          for (var e in data) {
            HomeWorkModel model = HomeWorkModel(
              id: e.id,
              homeWork: e['homeWork'],
              subject: e['subject'],
              dueDate: e['dueDate'],
              std: e['std'],
            );
            if (userDetails?.std == model.std &&
                model.subject == controller.subject) {
              controller.listOfHomeWork.add(model);
            }
          }
          if (controller.listOfHomeWork.isNotEmpty) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: controller.listOfHomeWork.length,
              itemBuilder: (context, index) {
                HomeWorkModel model = controller.listOfHomeWork[index];
                return dataView(model: model);
              },
            );
          } else {
            return CommonWidget.noDataFound();
          }
        }
        return CommonWidget.loadingBar();
      },
    );
  }

  Widget dataView({required HomeWorkModel model}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: AppColor.teal.withOpacity(0.2),
            ),
            child: CommonWidget.commonText(
              text: model.subject,
              color: AppColor.teal,
            ),
          ),
          CommonWidget.sizedBox(height: 10),
          CommonWidget.sizedBox(
            width: ScreenUtil().screenWidth * 0.8,
            child: CommonWidget.commonText(
              maxLines: 3,
              text: model.homeWork,
              fontWeight: FontWeight.bold,
            ),
          ),
          CommonWidget.sizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonWidget.commonText(
                text: "Std",
                fontSize: 14.sp,
              ),
              CommonWidget.commonText(
                text: model.std,
                fontSize: 14.sp,
              ),
            ],
          ),
          CommonWidget.sizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonWidget.commonText(
                text: "Assign Date",
                fontSize: 14.sp,
              ),
              CommonWidget.commonText(
                text: model.dueDate,
                fontSize: 14.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
