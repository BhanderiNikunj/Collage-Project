import 'package:collage_project/common/colors.dart';
import 'package:collage_project/model/result_model.dart';
import 'package:collage_project/model/user_detail_model.dart';
import 'package:collage_project/utiles/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ResultController extends GetxController {
  String std = "1";
  String month = "January";
  List<ResultModel> listOfResult = [];
  List<String> monthList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  List<String> listOfSubject = [
    "Sub.",
    "Math",
    "Sci.",
    "Eng.",
    "S.S.",
  ];

  Stream<QuerySnapshot<Map<String, dynamic>>> readStudentResult() {
    return FirebaseHelper.readStudentResult();
  }

  Future<List<int>> createPDF({
    required int index,
    required UserDetailModel detailes,
    required ResultModel model,
    required double totalPersentage,
  }) async {
    String color = AppColor.teal.toHexString().replaceRange(0, 2, '');
    final img = await rootBundle.load('assets/images/bright.png');
    final imageBytes = img.buffer.asUint8List();
    pw.Image image1 = pw.Image(
      pw.MemoryImage(
        imageBytes,
        orientation: PdfImageOrientation.topLeft,
        dpi: 100.h,
      ),
    );
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (_) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Row(
                children: [
                  pw.SizedBox(width: 30.w),
                  pw.Container(
                    height: 150.h,
                    child: image1,
                  ),
                  pw.SizedBox(width: 10.w),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: ScreenUtil().screenWidth * 0.6,
                        child: pw.Text(
                          "Name :- ${detailes.firstName} ${detailes.lastName}",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 5.h),
                      pw.Text(
                        "Std :- ${detailes.std}",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 30.w),
              pw.Text(
                "Month Name :- ${model.month}",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              pw.SizedBox(height: 30.w),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: List.generate(
                  listOfSubject.length,
                  (subjectIndex) => pw.Container(
                    height: 40.h,
                    width: 70.w,
                    alignment: pw.Alignment.center,
                    padding: pw.EdgeInsets.all(5.h),
                    color: PdfColor.fromHex(color),
                    child: pw.Text(
                      listOfSubject[subjectIndex],
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("ffffff"),
                      ),
                    ),
                  ),
                ),
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  commonResultBox(
                    text: "Total",
                    border: const pw.Border(
                      left: pw.BorderSide(),
                      top: pw.BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: listOfResult[index].totalSingleSubjectMark,
                    border: const pw.Border(
                      left: pw.BorderSide(),
                      top: pw.BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: listOfResult[index].totalSingleSubjectMark,
                    border: const pw.Border(
                      left: pw.BorderSide(),
                      top: pw.BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: listOfResult[index].totalSingleSubjectMark,
                    border: const pw.Border(
                      left: pw.BorderSide(),
                      top: pw.BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: listOfResult[index].totalSingleSubjectMark,
                    border: const pw.Border(
                      left: pw.BorderSide(),
                      top: pw.BorderSide(),
                      right: pw.BorderSide(),
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  commonResultBox(
                    text: "Out",
                    border: const pw.Border(
                      left: pw.BorderSide(),
                      top: pw.BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: listOfResult[index].mathMark,
                    border: const pw.Border(
                      left: pw.BorderSide(),
                      top: pw.BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: listOfResult[index].scienceMark,
                    border: const pw.Border(
                      left: pw.BorderSide(),
                      top: pw.BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: listOfResult[index].englishMark,
                    border: const pw.Border(
                      left: pw.BorderSide(),
                      top: pw.BorderSide(),
                    ),
                  ),
                  commonResultBox(
                    text: listOfResult[index].ssMark,
                    border: const pw.Border(
                      left: pw.BorderSide(),
                      top: pw.BorderSide(),
                      right: pw.BorderSide(),
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  commonResultBox(
                    text: "Total :- ${listOfResult[index].totalMark}",
                    border: const pw.Border(
                      bottom: pw.BorderSide(),
                      left: pw.BorderSide(),
                      top: pw.BorderSide(),
                    ),
                    width: 175.w,
                  ),
                  commonResultBox(
                    text: "Obtaine :- ${listOfResult[index].totalOutOfMark}",
                    border: const pw.Border(
                      bottom: pw.BorderSide(),
                      left: pw.BorderSide(),
                      top: pw.BorderSide(),
                      right: pw.BorderSide(),
                    ),
                    width: 175.w,
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  commonResultBox(
                    text:
                        "Total Percentage :- ${totalPersentage.toStringAsFixed(2)}%",
                    border: const pw.Border(
                      bottom: pw.BorderSide(),
                      left: pw.BorderSide(),
                      right: pw.BorderSide(),
                    ),
                    width: 350.w,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  pw.Container commonResultBox({
    required String text,
    bool isColor = false,
    required pw.BoxBorder border,
    double? width,
  }) {
    return pw.Container(
      height: 40.h,
      width: width ?? 70.w,
      alignment: pw.Alignment.center,
      padding: pw.EdgeInsets.all(5.h),
      decoration: pw.BoxDecoration(border: border),
      child: pw.Text(text),
    );
  }
}
