// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:collage_project/model/auth_model.dart';
import 'package:collage_project/model/leave_model.dart';
import 'package:collage_project/model/message_model.dart';
import 'package:collage_project/model/user_detail_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseHelper {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future<String> logIn({required AuthModel authModel}) async {
    return await firebaseAuth
        .signInWithEmailAndPassword(
          email: authModel.email,
          password: authModel.password,
        )
        .then(
          (value) => "Success",
        )
        .catchError(
          (e) => "Failed",
        );
  }

  static Future<String> signUp({required AuthModel authModel}) async {
    return await firebaseAuth
        .createUserWithEmailAndPassword(
          email: authModel.email,
          password: authModel.password,
        )
        .then(
          (value) => "true",
        )
        .catchError(
          (e) => "$e",
        );
  }

  static void logOut() {
    firebaseAuth.signOut();
  }

  static bool checkLogin() {
    return firebaseAuth.currentUser?.uid != null;
  }

  static String findUid() {
    return firebaseAuth.currentUser?.uid ?? "";
  }

  static String? findEmail() {
    return firebaseAuth.currentUser?.email;
  }

  static Future<String> findFcmToken() async {
    return await firebaseMessaging.getToken() ?? "";
  }

  // color

  static Stream<QuerySnapshot<Map<String, dynamic>>> readColor() {
    return firebaseFirestore.collection("color").snapshots();
  }

  // Student Details

  static Future<String> addStudentDetail({
    required UserDetailModel model,
  }) async {
    return firebaseFirestore
        .collection("User Details")
        .add(
          {
            'firstName': model.firstName,
            'lastName': model.lastName,
            'fatherName': model.fatherName,
            'emailId': model.emailId,
            'mobileNo': model.mobileNo,
            'std': model.std,
            'studentType': model.studentType,
            'uid': model.uid,
            'fcm': model.fcmToken,
          },
        )
        .then((value) => "Success")
        .catchError((e) => "Failed");
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> readStudentDetail() {
    return firebaseFirestore.collection("User Details").snapshots();
  }

  static Future<String> updateStudentDetail({
    required UserDetailModel model,
  }) async {
    return firebaseFirestore
        .collection("User Details")
        .doc(model.id)
        .set(
          {
            'firstName': model.firstName,
            'lastName': model.lastName,
            'fatherName': model.fatherName,
            'emailId': model.emailId,
            'mobileNo': model.mobileNo,
            'std': model.std,
            'studentType': model.studentType,
            'uid': model.uid,
            'fcm': model.fcmToken,
          },
        )
        .then((value) => "Success")
        .catchError((e) => "Failed");
  }

  // Home Work

  static Stream<QuerySnapshot<Map<String, dynamic>>> readStudentHomeWork() {
    return firebaseFirestore
        .collection("admin")
        .doc('Home Work')
        .collection("Home Work")
        .snapshots();
  }

  // fees

  static Stream<QuerySnapshot<Map<String, dynamic>>> readStudentFees() {
    return firebaseFirestore
        .collection("admin")
        .doc('Fees')
        .collection("Fees")
        .snapshots();
  }

  // Leave

  static Stream<QuerySnapshot<Map<String, dynamic>>> readLeave() {
    return firebaseFirestore
        .collection("admin")
        .doc("Leave")
        .collection("Leave")
        .snapshots();
  }

  static Future<String> addLeave({required LeaveModel model}) {
    return firebaseFirestore
        .collection("admin")
        .doc("Leave")
        .collection("Leave")
        .add(
          {
            'firstName': model.firstName,
            'std': model.std,
            'resion': model.resion,
            'dateFrom': model.dateFrom,
            'dateTo': model.dateTo,
            'status': model.status,
          },
        )
        .then((value) => "Success")
        .catchError((e) => "Failed");
  }

  static Future<String> updateLeave({required LeaveModel model}) {
    return firebaseFirestore
        .collection("admin")
        .doc("Leave")
        .collection("Leave")
        .doc(model.id)
        .set(
          {
            'firstName': model.firstName,
            'std': model.std,
            'resion': model.resion,
            'dateFrom': model.dateFrom,
            'dateTo': model.dateTo,
            'status': model.status,
          },
        )
        .then((value) => "Success")
        .catchError((e) => "Failed");
  }

  static Future<String> deleteLeave({required String id}) {
    return firebaseFirestore
        .collection("admin")
        .doc("Leave")
        .collection("Leave")
        .doc(id)
        .delete()
        .then((value) => "Success")
        .catchError((e) => "Failed");
  }

  // Time Table

  static Stream<QuerySnapshot<Map<String, dynamic>>> readStudentTimeTable() {
    return firebaseFirestore
        .collection("admin")
        .doc("Time Table")
        .collection("Time Table")
        .snapshots();
  }

  // Result

  static Stream<QuerySnapshot<Map<String, dynamic>>> readStudentResult() {
    return firebaseFirestore
        .collection("admin")
        .doc("Result")
        .collection("Result")
        .snapshots();
  }

  // Bright Memory

  static Stream<QuerySnapshot<Map<String, dynamic>>> readBrightGallery() {
    return firebaseFirestore.collection("Bright Gallery").snapshots();
  }

  // images

  static Stream<QuerySnapshot<Map<String, dynamic>>> readImages() {
    return firebaseFirestore.collection("image").snapshots();
  }

  // Message

  static Stream<QuerySnapshot<Map<String, dynamic>>> readMessage() {
    return firebaseFirestore
        .collection("chat")
        .doc("chat")
        .collection(FirebaseHelper.findUid())
        .snapshots();
  }

  static void sendMessage({required MessageModel model}) {
    firebaseFirestore
        .collection("chat")
        .doc("chat")
        .collection(FirebaseHelper.findUid())
        .add(
      {
        'date': model.date,
        'time': model.time,
        'message': model.message,
        'isMessageSend': model.isMessageSend.toString(),
      },
    );
  }
}
