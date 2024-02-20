import 'package:collage_project/common/colors.dart';
import 'package:collage_project/common/common_widget.dart';
import 'package:collage_project/model/leave_model.dart';
import 'package:collage_project/user/leave/controller/leave_controller.dart';
import 'package:collage_project/utiles/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  LeaveController controller = Get.put(LeaveController());

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                              text: "Your Leaves",
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
        floatingActionButton: CommonWidget.commonAddButton(
          onPressed: () => Get.toNamed('/add_leave_screen', arguments: -1),
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
        child: leaveDataView(),
      ),
    );
  }

  Widget leaveDataView() {
    return StreamBuilder(
      stream: controller.readStudentLeave(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
              snapshot.data!.docs;
          controller.listOfLeave.clear();
          for (var e in data) {
            LeaveModel leaveModel = LeaveModel(
              id: e.id,
              firstName: e['firstName'],
              std: e['std'],
              resion: e['resion'],
              dateFrom: e['dateFrom'],
              dateTo: e['dateTo'],
              status: e['status'],
            );
            if (leaveModel.std == userDetails?.std) {
              controller.listOfLeave.add(leaveModel);
            }
          }
          controller.listOfLeave.sort(
            (a, b) => b.dateFrom.compareTo(a.dateFrom),
          );
          if (controller.listOfLeave.isNotEmpty) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: controller.listOfLeave.length,
              itemBuilder: (context, index) {
                LeaveModel model = controller.listOfLeave[index];
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  margin:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColor.teal.withOpacity(0.2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonWidget.commonText(
                              text: model.firstName,
                              fontWeight: FontWeight.bold,
                            ),
                            model.status == "Success"
                                ? CommonWidget.sizedBox(isShrink: true)
                                : Row(
                                    children: [
                                      CommonWidget.commonIconButton(
                                        icon: Icons.delete,
                                        onPressed: () =>
                                            controller.deleteStudentLeave(
                                          id: model.id,
                                        ),
                                      ),
                                      CommonWidget.commonIconButton(
                                        icon: Icons.edit,
                                        onPressed: () => Get.toNamed(
                                          '/add_leave_screen',
                                          arguments: index,
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      CommonWidget.sizedBox(height: 8),
                      CommonWidget.sizedBox(
                        width: ScreenUtil().screenWidth * 0.8,
                        child: CommonWidget.commonText(
                          maxLines: 6,
                          text: model.resion,
                        ),
                      ),
                      const Divider(),
                      CommonWidget.commonText(
                        text: "Start :- ${model.dateFrom}",
                      ),
                      CommonWidget.commonText(
                        text: "End :- ${model.dateTo}",
                      ),
                      const Divider(),
                      CommonWidget.commonText(
                        text: "Status :- ${model.status}",
                      ),
                    ],
                  ),
                );
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
}
