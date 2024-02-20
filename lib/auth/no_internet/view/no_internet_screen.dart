// ignore_for_file: use_build_context_synchronously

import 'package:collage_project/common/colors.dart';
import 'package:collage_project/common/common_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NoInterNetScreen extends StatefulWidget {
  const NoInterNetScreen({super.key});

  @override
  State<NoInterNetScreen> createState() => _NoInterNetScreenState();
}

class _NoInterNetScreenState extends State<NoInterNetScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonWidget.imageBuilder(
                width: ScreenUtil().screenWidth * 0.7,
                imagePath: 'assets/images/no_internet.png',
              ),
              CommonWidget.sizedBox(height: 15),
              CommonWidget.commonText(
                text: "Please Start Your Internet",
              ),
              CommonWidget.sizedBox(height: 15),
              CommonWidget.commonButton(
                width: ScreenUtil().screenWidth * 0.7,
                text: "Try Again",
                onTap: () async {
                  final connectivityResult =
                      await Connectivity().checkConnectivity();
                  if (connectivityResult == ConnectivityResult.wifi ||
                      connectivityResult == ConnectivityResult.mobile) {
                    Get.offAndToNamed('/');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: CommonWidget.commonText(
                          text: "Please Start Your Internet",
                          color: AppColor.white,
                        ),
                        backgroundColor: AppColor.teal,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
