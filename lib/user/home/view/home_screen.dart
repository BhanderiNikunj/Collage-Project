import 'package:collage_project/common/colors.dart';
import 'package:collage_project/common/common_widget.dart';
import 'package:collage_project/model/image_model.dart';
import 'package:collage_project/model/title_model.dart';
import 'package:collage_project/model/user_detail_model.dart';
import 'package:collage_project/user/home/controller/home_controller.dart';
import 'package:collage_project/utiles/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: bodyView(),
      ),
    );
  }

  void loadUserDetails() {
    if (userDetails != null) {
      controller.updateStudentDetail(
        model: UserDetailModel(
          id: userDetails?.id ?? "",
          firstName: userDetails?.firstName ?? "",
          lastName: userDetails?.lastName ?? "",
          fatherName: userDetails?.fatherName ?? "",
          std: userDetails?.std ?? "",
          mobileNo: userDetails?.mobileNo ?? "",
          studentType: userDetails?.studentType ?? "",
          emailId: userDetails?.emailId ?? "",
          fcmToken: userDetails?.fcmToken ?? "",
          uid: userDetails?.uid ?? "",
        ),
      );
    }
  }

  Widget bodyView() {
    return StreamBuilder(
      stream: controller.readStudentDetail(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
              snapshot.data?.docs ?? [];
          for (var e in data) {
            if (e['uid'] == controller.findUid()) {
              userDetails = UserDetailModel(
                id: e.id,
                firstName: e['firstName'],
                lastName: e['lastName'],
                fatherName: e['fatherName'],
                std: e['std'],
                mobileNo: e['mobileNo'],
                studentType: e['studentType'],
                emailId: e['emailId'],
                fcmToken: e['fcm'],
                uid: e['uid'],
              );
            }
          }
          if (userDetails?.uid.isEmpty == true || userDetails?.uid == null) {
            Future.delayed(
              const Duration(seconds: 1),
              () {
                Get.offAndToNamed('/add_user_detail_screen');
              },
            );
          }
          return Stack(
            children: [
              Stack(
                children: [
                  topView(),
                  bottomView(context: context),
                ],
              ),
            ],
          );
        }
        return CommonWidget.loadingBar();
      },
    );
  }

  Widget bottomView({required BuildContext context}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: ScreenUtil().screenHeight * 0.85,
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
            sliderView(),
            CommonWidget.sizedBox(height: 20),
            homeDataView(context),
          ],
        ),
      ),
    );
  }

  Widget topView() {
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
            padding: EdgeInsets.only(top: 15.h),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonWidget.commonText(
                    text: "Bright Education Classes",
                    color: AppColor.white,
                    fontSize: 20.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sliderView() {
    return CommonWidget.sizedBox(
      height: 150.h,
      width: ScreenUtil().screenWidth,
      child: StreamBuilder(
        stream: controller.readImages(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            controller.listOfImage.clear();
            for (var e in snapshot.data?.docs ?? []) {
              ImageModel model = ImageModel(
                id: e.id,
                image: e['image'],
                imageName: e['name'],
              );
              controller.listOfImage.add(model);
            }
            if (controller.listOfImage.isEmpty) {
              controller.listOfImage.add(
                ImageModel(
                  id: "",
                  image: "assets/images/bright.png",
                  imageName: "logo",
                ),
              );
            }
            return CarouselSlider(
              items: List.generate(
                controller.listOfImage.length,
                (index) {
                  return CommonWidget.imageBuilder(
                    imagePath: controller.listOfImage[index].image,
                    fit: BoxFit.contain,
                  );
                },
              ),
              options: CarouselOptions(
                initialPage: 0,
                autoPlay: controller.listOfImage.length == 1 ? false : true,
              ),
            );
          }
          return CommonWidget.loadingBar();
        },
      ),
    );
  }

  Widget homeDataView(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisExtent: 125,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10.h,
        ),
        itemCount: controller.listOfHomeData.length,
        itemBuilder: (_, index) {
          TitleModel model = controller.listOfHomeData[index];
          return InkWell(
            onTap: () {
              loadUserDetails();
              if (model.routes.isNotEmpty) {
                Get.toNamed(model.routes);
              } else {
                if (model.name == "Log Out") {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.all(10),
                        backgroundColor: AppColor.white,
                        surfaceTintColor: AppColor.white,
                        title: CommonWidget.commonText(
                          text: "Log Out",
                          textAlign: TextAlign.center,
                        ),
                        content: SizedBox(
                          height: 120,
                          width: ScreenUtil().screenWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CommonWidget.commonText(
                                text: "Are You Sure To Log Out",
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CommonWidget.commonButton(
                                    text: "Yes",
                                    width: 120.w,
                                    onTap: () => controller.logOut(
                                      context: context,
                                    ),
                                  ),
                                  CommonWidget.commonButton(
                                    text: "No",
                                    width: 120.w,
                                    onTap: () => Get.back(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  Get.toNamed('/page_not_found');
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3.h,
                    spreadRadius: 3.h,
                    color: AppColor.shadowColor,
                  ),
                ],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.h,
                      left: 10.h,
                    ),
                    child: CommonWidget.imageBuilder(
                      imagePath: model.image,
                      color: AppColor.teal,
                      height: 40.h,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, left: 10.h),
                    child: CommonWidget.commonText(
                      text: model.name,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
