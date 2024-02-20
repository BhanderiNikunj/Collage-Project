import 'package:collage_project/common/colors.dart';
import 'package:collage_project/common/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ImageViewScreen extends StatefulWidget {
  const ImageViewScreen({super.key});

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  String imagePath = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColor.white),
          backgroundColor: AppColor.hintTextColor,
        ),
        body: Container(
          color: AppColor.hintTextColor,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: CommonWidget.imageBuilder(
                imagePath: imagePath,
                fit: BoxFit.cover,
                width: ScreenUtil().screenWidth * 0.95,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
