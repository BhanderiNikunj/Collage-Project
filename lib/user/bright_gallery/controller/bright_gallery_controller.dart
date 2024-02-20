import 'package:collage_project/model/image_model.dart';
import 'package:collage_project/utiles/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BrightGalleryController extends GetxController {
  List<ImageModel> listOfBrightGallery = [];

  Stream<QuerySnapshot<Map<String, dynamic>>> readBrightGallery() {
    return FirebaseHelper.readBrightGallery();
  }
}
