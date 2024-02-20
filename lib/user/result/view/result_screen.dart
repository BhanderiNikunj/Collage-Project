// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:collage_project/common/colors.dart';
import 'package:collage_project/common/common_widget.dart';
import 'package:collage_project/model/result_model.dart';
import 'package:collage_project/user/result/controller/result_controller.dart';
import 'package:collage_project/utiles/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:collage_project/common/drop_down1.dart' as drop;

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  ResultController controller = Get.put(ResultController());

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
              CommonWidget.imageBuilder(
                imagePath: 'assets/images/star_pattern.png',
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                      text: "Your Result",
                      color: AppColor.white,
                    )
                  ],
                ),
                CommonWidget.sizedBox(
                  width: 150.w,
                  child: drop.DropdownButton(
                    menuMaxHeight: 300,
                    focusColor: Colors.white,
                    items: List.generate(
                      controller.monthList.length,
                      (index) {
                        String name = controller.monthList[index];
                        return drop.DropdownMenuItem(
                          value: name,
                          child: Text(name),
                        );
                      },
                    ),
                    isExpanded: true,
                    value: controller.month,
                    onChanged: (v) => setState(() {
                      controller.month = v ?? "";
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

  Widget bottomView() {
    return Align(
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
        child: resultView(),
      ),
    );
  }

  Widget resultView() {
    return StreamBuilder(
      stream: controller.readStudentResult(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
              snapshot.data?.docs ?? [];
          double totalPersentage = 0;
          controller.listOfResult = [];
          for (var e in data) {
            ResultModel model = ResultModel(
              id: e.id,
              name: e['name'],
              uid: e['uid'],
              mathMark: e['mathMark'],
              scienceMark: e['scienceMark'],
              englishMark: e['englishMark'],
              ssMark: e['ssMark'],
              totalMark: e['totalMark'],
              totalOutOfMark: e['totalOutOfMark'],
              month: e['month'],
              totalSingleSubjectMark: e['totalSingleSubjectMark'],
            );
            if (model.uid == userDetails?.uid &&
                controller.month == model.month) {
              double total = double.parse(model.totalMark);
              double totalOutOfMark = double.parse(model.totalOutOfMark);
              totalPersentage = (totalOutOfMark / total) * 100;
              controller.listOfResult.add(model);
            }
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                CommonWidget.sizedBox(height: 10),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/bright.png",
                      height: 100.h,
                    ),
                    CommonWidget.sizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ScreenUtil().screenWidth * 0.6,
                          child: CommonWidget.commonText(
                            text:
                                "Name :- ${userDetails?.firstName} ${userDetails?.lastName}",
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        CommonWidget.sizedBox(height: 5),
                        CommonWidget.commonText(
                          text: "Std :- ${userDetails?.std}",
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ],
                    ),
                  ],
                ),
                CommonWidget.sizedBox(height: 15),
                if (controller.listOfResult.isEmpty)
                  CommonWidget.sizedBox(
                    height: 300,
                    child: CommonWidget.noDataFound(),
                  )
                else
                  Column(
                    children: List.generate(
                      controller.listOfResult.length,
                      (index) {
                        ResultModel model = controller.listOfResult[index];
                        return singleResultView(
                          model: model,
                          index: index,
                          totalPersentage: totalPersentage,
                          context: _,
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        }
        return CommonWidget.loadingBar();
      },
    );
  }

  Widget singleResultView({
    required ResultModel model,
    required int index,
    required BuildContext context,
    required double totalPersentage,
  }) {
    return InkWell(
      onTap: () async {
            List<int> bytes = await controller.createPDF(
              totalPersentage: totalPersentage,
              detailes: userDetails!,
              model: model,
              index: index,
            );
            if (bytes.isNotEmpty) {
              final directory = Directory('/storage/emulated/0/Download');
              final path = directory.path;
              File file = File(
                '$path/${model.name.split(' ').first} Result.pdf',
              );
              await file.writeAsBytes(bytes, flush: true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.white,
                  content: CommonWidget.commonText(
                    maxLines: 2,
                    text: file.path,
                  ),
                ),
              );
            }
          },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonWidget.sizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonWidget.commonText(
                text: "Month Name :- ${model.month}",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          CommonWidget.sizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.listOfSubject.length,
                  (subjectIndex) => Container(
                    height: 40.h,
                    width: 65.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5.h),
                    color: AppColor.teal,
                    child: CommonWidget.commonText(
                      text: controller.listOfSubject[subjectIndex],
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonResultBox(
                    text: "Total",
                    border: const Border(
                      left: BorderSide(),
                      top: BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: controller.listOfResult[index].totalSingleSubjectMark,
                    border: const Border(
                      left: BorderSide(),
                      top: BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: controller.listOfResult[index].totalSingleSubjectMark,
                    border: const Border(
                      left: BorderSide(),
                      top: BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: controller.listOfResult[index].totalSingleSubjectMark,
                    border: const Border(
                      left: BorderSide(),
                      top: BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: controller.listOfResult[index].totalSingleSubjectMark,
                    border: const Border(
                      left: BorderSide(),
                      top: BorderSide(),
                      right: BorderSide(),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonResultBox(
                    text: "Out",
                    border: const Border(
                      left: BorderSide(),
                      top: BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: controller.listOfResult[index].mathMark,
                    border: const Border(
                      left: BorderSide(),
                      top: BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: controller.listOfResult[index].scienceMark,
                    border: const Border(
                      left: BorderSide(),
                      top: BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: controller.listOfResult[index].englishMark,
                    border: const Border(
                      left: BorderSide(),
                      top: BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: controller.listOfResult[index].ssMark,
                    border: const Border(
                      left: BorderSide(),
                      top: BorderSide(),
                      right: BorderSide(),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonResultBox(
                    text:
                        "Total :- ${controller.listOfResult[index].totalMark}",
                    border: const Border(
                      bottom: BorderSide(),
                      left: BorderSide(),
                      top: BorderSide(),
                    ),
                    width: 163.w,
                  ),
                  commonResultBox(
                    text:
                        "Obtaine :- ${controller.listOfResult[index].totalOutOfMark}",
                    border: const Border(
                      bottom: BorderSide(),
                      left: BorderSide(),
                      top: BorderSide(),
                      right: BorderSide(),
                    ),
                    width: 163.w,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonResultBox(
                    text:
                        "Total Percentage :- ${totalPersentage.toStringAsFixed(2)}%",
                    border: const Border(
                      bottom: BorderSide(),
                      left: BorderSide(),
                      right: BorderSide(),
                    ),
                    width: 325.w,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget commonResultBox({
    required String text,
    bool isColor = false,
    required BoxBorder border,
    double? width,
  }) {
    return Container(
      height: 40.h,
      width: width ?? 65.w,
      alignment: Alignment.center,
      padding: EdgeInsets.all(5.h),
      decoration: BoxDecoration(border: border),
      child: CommonWidget.commonText(
        text: text,
        color: isColor == true ? AppColor.green : null,
      ),
    );
  }
}
