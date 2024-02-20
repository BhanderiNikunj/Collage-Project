import 'package:collage_project/common/colors.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonWidget {
  static Widget textFormField({
    required TextEditingController? controller,
    String? hintText,
    Color? fillColor,
    Color? borderColor,
    double? radius,
    bool obscureText = false,
    String? Function(String?)? validator,
    Color? hintColor,
    Color? textColor,
    double? fontSize,
    bool enabled = true,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
    EdgeInsetsGeometry? contentPadding,
    int? maxLength,
  }) {
    return TextFormField(
      keyboardType: keyboardType ?? TextInputType.name,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      enabled: enabled,
      onChanged: onChanged,
      maxLength: maxLength,
      style: GoogleFonts.poppins(
        color: textColor ?? AppColor.textColor,
        fontSize: fontSize ?? 16.sp,
      ),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText ?? "Enter Data",
        hintStyle: GoogleFonts.poppins(
          color: hintColor ?? AppColor.hintTextColor,
          fontSize: fontSize ?? 16.sp,
        ),
        contentPadding: contentPadding,
        filled: true,
        fillColor: fillColor ?? AppColor.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 10.r),
            borderSide: BorderSide(color: borderColor ?? AppColor.textColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 10.r),
            borderSide: const BorderSide(color: Colors.red)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 10.r),
            borderSide: BorderSide(color: borderColor ?? AppColor.textColor)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 10.r),
            borderSide: BorderSide(color: borderColor ?? AppColor.textColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 10.r),
            borderSide: BorderSide(color: borderColor ?? AppColor.textColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 10.r),
            borderSide: const BorderSide(color: AppColor.orange)),
      ),
    );
  }

  static Widget commonButton({
    required String text,
    required void Function() onTap,
    double? width,
    double? height,
    Color? buttonColor,
    double? radius,
    Color? color,
    double? fontSize,
  }) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: onTap,
      child: Container(
        height: height ?? 40.h,
        width: width ?? 150.h,
        decoration: BoxDecoration(
          color: buttonColor ?? AppColor.teal,
          borderRadius: BorderRadius.circular(radius ?? 10.r),
        ),
        alignment: Alignment.center,
        child: commonText(
          text: text,
          color: color ?? AppColor.white,
          fontSize: fontSize ?? 16.sp,
        ),
      ),
    );
  }

  static Widget commonText({
    required String text,
    TextOverflow? overflow,
    int? maxLines,
    TextStyle? style,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign,
  }) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines ?? 1,
      style: style ??
          GoogleFonts.poppins(
            color: color ?? AppColor.textColor,
            fontWeight: fontWeight ?? FontWeight.w500,
            fontSize: fontSize ?? 16.sp,
          ),
    );
  }

  static Widget commonIconButton({
    required IconData icon,
    required void Function()? onPressed,
    Color? color,
    double? size,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: color ?? AppColor.textColor,
        size: size,
      ),
    );
  }

  static Widget loadingBar() {
    return Center(
      child: CircularProgressIndicator(
        color: AppColor.teal,
      ),
    );
  }

  static Widget commonIcon({required IconData icon, Color? color}) {
    return Icon(
      icon,
      color: color ?? AppColor.textColor,
    );
  }

  static Future<DateTime> commonDatePicker({
    required BuildContext context,
    DateTime? minDate,
  }) async {
    DateTime dateTime = await showDatePickerDialog(
          context: context,
          maxDate: DateTime(2030),
          minDate: minDate ?? DateTime.now(),
          themeColor: AppColor.teal,
        ) ??
        minDate ??
        DateTime.now();
    return dateTime;
  }

  static Widget noDataFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageBuilder(
            imagePath: 'assets/images/no_data_found.png',
            height: 150.h,
          ),
          sizedBox(height: 20),
          commonText(text: "Sorry, No Data Found")
        ],
      ),
    );
  }

  static Widget sizedBox({
    double? height,
    double? width,
    Widget? child,
    bool isShrink = false,
    bool isExpand = false,
  }) {
    if (isShrink) {
      return SizedBox.shrink(child: child);
    }
    if (isExpand) {
      return SizedBox.expand(child: child);
    }
    return SizedBox(height: height?.h, width: width?.w, child: child);
  }

  static Widget commonAddButton({required void Function() onPressed}) {
    return FloatingActionButton(
      backgroundColor: AppColor.teal,
      onPressed: onPressed,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(20.sp),
      ),
      child: CommonWidget.commonIcon(
        icon: Icons.add,
        color: AppColor.white,
      ),
    );
  }

  static String stringToRupee({required text}) {
    return "₹$text";
  }

  static Widget bottomImageCommonView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        "assets/images/bg_design.png",
      ),
    );
  }

  static Widget imageBuilder({
    required String imagePath,
    BoxFit? fit,
    double? height,
    double? width,
    Color? color,
  }) {
    if (imagePath.startsWith('assets')) {
      return Image.asset(
        imagePath,
        fit: fit,
        height: height,
        width: width,
        color: color,
      );
    } else if (imagePath.startsWith('https')) {
      return Image.network(
        imagePath,
        fit: fit ?? BoxFit.cover,
        height: height,
        width: width,
        color: color,
      );
    } else {
      return sizedBox(isShrink: true);
    }
  }
}
