import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../login_screen.dart';
import 'home_screen.dart';

class AuthController extends GetxController {
  CreateMyUser({String? email, String? password, String? name}) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value)async {
      String uid = value.user!.uid;
      String? deviceToken = await FirebaseMessaging.instance.getToken();

      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'Name': name,
        'Email': email,
        'Password': password,
        'followId': [],
        'token': deviceToken,

      }).then((value) => Get.off(() => loginscreen()));
    }).catchError((e) {
      print(e.toString());
    });
  }
}
