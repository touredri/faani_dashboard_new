import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faani_dashboard/env/env.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future userSignup(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } catch (e) {
    return e.toString();
  }
}

Future<User?> userLogin(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user!;
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
        await FirebaseFirestore.instance
            .collection('admin')
            .doc(userEmail)
            .set({
          'role': 'admin',
          'email': userEmail,
          'name': 'Drissa',
          'surname': 'Touré'
        });
        await userCredential.user!.linkWithPhoneNumber('+22393734481');
    }
  }
}
