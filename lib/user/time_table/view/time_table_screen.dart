import 'package:collage_project/common/colors.dart';
import 'package:collage_project/common/common_widget.dart';
import 'package:collage_project/model/time_table_model.dart';
import 'package:collage_project/user/time_table/controller/time_table_controller.dart';
import 'package:collage_project/utiles/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({super.key});

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  TimeTableController controller = Get.put(TimeTableController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                              text: "Your Time Table",
                              color: AppColor.white,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                bottomScreenView(),
              ],
            ),
            CommonWidget.bottomImageCommonView(),
          ],
        ),
      ),
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
        child: Column(
          children: [
            dayListView(),
            timeTableDataView(),
          ],
        ),
      ),
    );
  }

  Widget dayListView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            controller.weekNameList.length,
            (index) {
              return InkWell(
                onTap: () {
                  controller.dayIndex = controller.weekNameList[index];
                  setState(() {});
                },
                child: Container(
                  width: 70.w,
                  height: 25.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    color: controller.dayIndex == controller.weekNameList[index]
                        ? AppColor.teal
                        : AppColor.white,
                  ),
                  child: CommonWidget.commonText(
                    fontSize: 14.sp,
                    text: controller.weekNameList[index],
                    color: controller.dayIndex == controller.weekNameList[index]
                        ? AppColor.white
                        : AppColor.textColor,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget timeTableDataView() {
    return Expanded(
      child: StreamBuilder(
        stream: controller.readStudentTimeTable(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                snapshot.data?.docs ?? [];
            controller.listOfTimeTable.clear();
            for (var e in data) {
              TimeTableModel model = TimeTableModel(
                id: e.id,
                startingTime: e['startingTime'],
                endingTime: e['endingTime'],
                sirName: e['sirName'],
                subjectName: e['subjectName'],
                periodName: e['periodName'],
                weekName: e['weekName'],
                std: e['std'],
              );
              if (userDetails?.std == model.std &&
                  model.weekName == controller.dayIndex) {
                controller.listOfTimeTable.add(model);
              }
            }
            controller.listOfTimeTable.sort(
              (a, b) {
                return a.startingTime.compareTo(b.startingTime);
              },
            );
            if (controller.listOfTimeTable.isNotEmpty) {
              return ListView.builder(
                  itemCount: controller.listOfTimeTable.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    TimeTableModel model = controller.listOfTimeTable[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonWidget.commonText(
                            text: model.subjectName,
                          ),
                          CommonWidget.sizedBox(height: 5),
                          CommonWidget.commonText(
                            text: "Std :- ${model.std}",
                            color: AppColor.hintTextColor,
                            fontSize: 14.sp,
                          ),
                          CommonWidget.sizedBox(height: 5),
                          CommonWidget.commonText(
                            text:
                                "${model.startingTime} To ${model.endingTime}",
                            color: AppColor.hintTextColor,
                            fontSize: 14.sp,
                          ),
                          CommonWidget.sizedBox(height: 5),
                          CommonWidget.commonText(
                            text: 'Day :- ${model.weekName}',
                            color: AppColor.hintTextColor,
                            fontSize: 14.sp,
                          ),
                          CommonWidget.sizedBox(height: 5),
                          const Divider(),
                          CommonWidget.sizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonWidget.commonText(
                                text: model.sirName,
                                color: AppColor.hintTextColor,
                                fontSize: 14.sp,
                              ),
                              CommonWidget.commonText(
                                text: model.periodName,
                                color: AppColor.textColor,
                                fontSize: 14.sp,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              return CommonWidget.noDataFound();
            }
          }
          return CommonWidget.loadingBar();
        },
      ),
    );
  }
}
