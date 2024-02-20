import 'dart:async';
import 'package:collage_project/common/common_widget.dart';
import 'package:collage_project/model/color_model.dart';
import 'package:collage_project/utiles/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseHelper.readColor(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                  snapshot.data?.docs ?? [];
              List<ColorsModel> colorList = [];
              for (var e in data) {
                colorList.add(ColorsModel(color: "0x${e['color']}", id: e.id));
              }
              // AppColor.teal = Color(int.parse(colorList.first.color));
              return logIn();
            }
            return CommonWidget.sizedBox(isShrink: true);
          },
        ),
      ),
    );
  }

  Widget logIn() {
    Timer(
      const Duration(seconds: 3),
      () async {
        ConnectivityResult connectivityResult =
            await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.wifi ||
            connectivityResult == ConnectivityResult.mobile) {
          if (FirebaseHelper.checkLogin()) {
            Get.offAndToNamed('/home_screen');
          } else {
            Get.offAndToNamed('/login_screen');
          }
        } else {
          Get.offAllNamed('/no_internet_screen');
        }
      },
    );
    return imageView();
  }

  Widget imageView() {
    return Center(
      child: CommonWidget.imageBuilder(
        imagePath: "assets/images/bright.png",
        height: ScreenUtil().screenWidth * 0.7,
      ),
    );
  }
}
