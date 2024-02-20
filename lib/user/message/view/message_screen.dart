import 'package:collage_project/common/colors.dart';
import 'package:collage_project/common/common_widget.dart';
import 'package:collage_project/model/message_model.dart';
import 'package:collage_project/user/message/controller/message_controller.dart';
import 'package:collage_project/utiles/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  MessageController controller = Get.put(MessageController());
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: key,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: AppColor.teal,
            leading: CommonWidget.commonIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onPressed: () => Get.back(),
              color: AppColor.white,
            ),
            title: CommonWidget.commonText(
              text: "${userDetails?.firstName} chat",
              color: AppColor.white,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: bottomView(),
                ),
              ),
              Container(
                height: 60.h,
                width: ScreenUtil().screenWidth,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: CommonWidget.textFormField(
                  controller: controller.searchController,
                  hintText: "Type Message...",
                  suffixIcon: CommonWidget.commonIconButton(
                    icon: Icons.send,
                    onPressed: () {
                      if (controller.searchController.text.isNotEmpty) {
                        var time = TimeOfDay.now();
                        var date = DateTime.now().microsecondsSinceEpoch;
                        controller.sendMessage(
                          model: MessageModel(
                            isMessageSend: true,
                            id: "",
                            date: date.toString(),
                            time: "${time.hour}:${time.minute}",
                            message: controller.searchController.text,
                          ),
                        );
                        controller.searchController.clear();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomView() {
    return StreamBuilder(
      stream: controller.readMessage(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          controller.listOfMessage.clear();
          for (var e in snapshot.data?.docs ?? []) {
            MessageModel model = MessageModel(
              id: e.id,
              date: e['date'],
              time: e['time'],
              message: e['message'],
              isMessageSend: bool.tryParse(e['isMessageSend']) ?? false,
            );
            controller.listOfMessage.add(model);
          }
          controller.listOfMessage.sort((a, b) => a.time.compareTo(b.time));
          return ListView.builder(
            itemCount: controller.listOfMessage.length,
            itemBuilder: (_, index) {
              MessageModel model = controller.listOfMessage[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Row(
                  mainAxisAlignment: model.isMessageSend
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: model.isMessageSend
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CommonWidget.commonText(
                            text: "${DateTime.fromMicrosecondsSinceEpoch(
                              int.parse(model.date),
                            ).day} / ${DateTime.fromMicrosecondsSinceEpoch(
                              int.parse(model.date),
                            ).month} / ${DateTime.fromMicrosecondsSinceEpoch(
                              int.parse(model.date),
                            ).year} | ${model.time}",
                            fontSize: 12.sp,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 5.h,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                    model.isMessageSend ? 0.r : 10.r,
                                  ),
                                  bottomLeft: Radius.circular(10.r),
                                  bottomRight: Radius.circular(10.r),
                                  topLeft: Radius.circular(
                                    model.isMessageSend ? 10.r : 0.r,
                                  ),
                                ),
                                color: !model.isMessageSend
                                    ? AppColor.blue.withOpacity(0.3)
                                    : AppColor.teal.withOpacity(0.3),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.h,
                                vertical: 8.h,
                              ),
                              constraints: BoxConstraints(maxWidth: 200.w),
                              child: CommonWidget.commonText(
                                text: model.message,
                                maxLines: 50,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
        return CommonWidget.loadingBar();
      },
    );
  }
}
