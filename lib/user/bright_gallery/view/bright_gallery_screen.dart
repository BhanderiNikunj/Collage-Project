import 'package:collage_project/common/colors.dart';
import 'package:collage_project/common/common_widget.dart';
import 'package:collage_project/model/image_model.dart';
import 'package:collage_project/user/bright_gallery/controller/bright_gallery_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BrightGalleryScreen extends StatefulWidget {
  const BrightGalleryScreen({super.key});

  @override
  State<BrightGalleryScreen> createState() => _BrightGalleryScreenState();
}

class _BrightGalleryScreenState extends State<BrightGalleryScreen> {
  BrightGalleryController controller = Get.put(BrightGalleryController());
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
                  text: "Bright Gallery",
                  color: AppColor.white,
                )
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
        height: ScreenUtil().screenHeight * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          color: AppColor.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: StreamBuilder(
          stream: controller.readBrightGallery(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                  snapshot.data?.docs ?? [];
              controller.listOfBrightGallery.clear();
              for (var e in data) {
                ImageModel model = ImageModel(
                  id: e.id,
                  image: e['image'],
                  imageName: e['name'],
                );
                controller.listOfBrightGallery.add(model);
              }
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.listOfBrightGallery.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (_, index) {
                  String image = controller.listOfBrightGallery[index].image;
                  return InkWell(
                    onTap: () {
                      Get.toNamed('/image_view_screen', arguments: image);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: CommonWidget.imageBuilder(
                          imagePath: image,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return CommonWidget.loadingBar();
          },
        ),
      ),
    );
  }
}
