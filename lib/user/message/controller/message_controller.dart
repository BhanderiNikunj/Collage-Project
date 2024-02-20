import 'package:collage_project/model/message_model.dart';
import 'package:collage_project/utiles/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  List<MessageModel> listOfMessage = [];
  TextEditingController searchController = TextEditingController();

  Stream<QuerySnapshot<Map<String, dynamic>>> readMessage() {
    return FirebaseHelper.readMessage();
  }

  void sendMessage({required MessageModel model}) {
    FirebaseHelper.sendMessage(model: model);
  }
}
