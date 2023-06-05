import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  /// /// *****************Firebase Service*************

  Future uploadImageToStorage({
    required File image,
  }) async {
    try {
      String fileName = 'collection_${DateTime.now().millisecondsSinceEpoch}';
      Reference reference =
          _firebaseStorage.ref().child('images').child('/$fileName');
      UploadTask uploadTask = reference.putFile(image);

      uploadTask.snapshotEvents.listen((event) async {
        if (kDebugMode) {
          print('processing ${event.bytesTransferred}/${event.totalBytes}');
        }
      });
      await uploadTask.whenComplete(() => null);
      String imageUrl = await reference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      log(e.toString());
    }
  }
}
