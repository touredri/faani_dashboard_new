import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faani_dashboard/env/env.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../controllers/logged_user_controller.dart';
import '../models/logged_user.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<User?> userLogin(String email, String password) async {
  try {
    // Initialize LoggedUserController
    LoggedUserController loggedUserController = Get.put(LoggedUserController());
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // LoggedUser user = LoggedUser();
    if (userCredential.user != null) {
    }
    return userCredential.user;
  } catch (e) {
    return null;
  }
}

Future<void> isAdmin(String userEmail) async {
  final docSnapshot =
      await FirebaseFirestore.instance.collection('admin').get();
  if (docSnapshot.docs.isNotEmpty) {
    return;
  } else {
    // Create an admin user if no admin user exists
    // Create an admin user in Firebase Authentication if no admin user exists
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: userEmail,
      password: Env.adminPassword,
    );
    if (userCredential.user != null) {
      await FirebaseFirestore.instance.collection('admin').doc(userEmail).set({
        'role': 'admin',
        'email': userEmail,
        'name': 'Drissa',
        'surname': 'Touré'
      });
      await userCredential.user!.linkWithPhoneNumber('+22393734481');
    }
  }
}
