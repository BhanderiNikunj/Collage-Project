// ignore_for_file: must_be_immutable, library_private_types_in_public_api, no_logic_in_create_state

import 'package:collage_project/common/colors.dart';
import 'package:collage_project/common/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownButton extends StatefulWidget {
  final String selectedOptions;
  final List<String>? dataList;
  final Function(String option) onOptionSelected;
  final bool useTextField;
  Widget? dropDownWidget;
  double? fontSize;
  EdgeInsetsGeometry? padding;
  VoidCallback? onTap;

  CustomDropdownButton({
    required this.selectedOptions,
    required this.useTextField,
    required this.onOptionSelected,
    this.dataList,
    this.dropDownWidget,
    this.fontSize,
    this.padding,
    this.onTap,
    super.key,
  });

  @override
  _CustomDropdownButtonState createState() =>
      _CustomDropdownButtonState(selectedOptions, dataList ?? []);
}

class _CustomDropdownButtonState extends State<CustomDropdownButton>
    with SingleTickerProviderStateMixin {
  String optionItemSelected = "";
  List<String> dataList;
  late AnimationController expandController;
  late Animation<double> animation;
  TextEditingController searchController = TextEditingController();
  _CustomDropdownButtonState(this.optionItemSelected, this.dataList);
  bool changeIcon = false;

  @override
  void initState() {
    super.initState();
    dataList = widget.dataList ?? [];
    expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    runExpandCheck();
  }

  void runExpandCheck() {
    if (changeIcon) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return relationDropDownWidget(context: context);
  }

  Widget relationDropDownWidget({required BuildContext context}) {
    return Column(
      children: [
        Container(
          padding: widget.padding ??
              EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColor.white,
            border: Border.all(
              color: AppColor.hintTextColor,
              width: 1.2.r,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    changeIcon = !changeIcon;
                    runExpandCheck();
                    setState(() {});
                    widget.onTap?.call();
                  },
                  child: CommonWidget.commonText(
                    text: optionItemSelected,
                    style: TextStyle(
                      color: const Color(0xff293847),
                      fontSize: widget.fontSize ?? 16.sp,
                    ),
                  ),
                ),
              ),
              Icon(
                changeIcon
                    ? Icons.arrow_drop_up_outlined
                    : Icons.arrow_drop_down_outlined,
                size: 26.r,
                color: const Color(0xff293847),
              ),
            ],
          ),
        ),
        SizeTransition(
          axisAlignment: 1,
          sizeFactor: animation,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.only(bottom: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              color: AppColor.white,
              border:
                  Border.all(color: const Color(0xff084277).withOpacity(0.2)),
            ),
            child: _buildDropListOptions(
              context: context,
              dataList: dataList,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropListOptions({
    required BuildContext context,
    required List<String> dataList,
  }) {
    return Scrollbar(
      child: SizedBox(
        child: widget.dropDownWidget ??
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: List.generate(
                  dataList.length,
                  (index) => InkWell(
                    onTap: () {
                      widget.onOptionSelected(dataList[index]);
                      optionItemSelected = dataList[index];
                      changeIcon = false;
                      expandController.reverse();
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        SizedBox(height: 7.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: dataList[index] == optionItemSelected
                                  ? AppColor.teal.withOpacity(0.7)
                                  : Colors.transparent,
                              width: ScreenUtil().screenWidth,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.h, vertical: 5.h),
                              child: CommonWidget.commonText(
                                text: dataList[index],
                                style: TextStyle(
                                  color: dataList[index] == optionItemSelected
                                      ? AppColor.white
                                      : AppColor.textColor,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
