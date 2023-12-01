import 'package:faani_dashboard/models/tendence.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/modele_modele.dart';

class TendanceService {
  // get all the tendance
    Stream<List<Tendance>> fetchTendance() {
    return firestore
        .collection('tendance')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Tendance.fromMap(doc.data(), doc.reference))
            .toList());
  }

  deleteTendance(String id) async {
    final docRef = firestore.collection('tendance').doc(id);
    final doc = await docRef.get();
    var imagePath = doc.data()!['image'];
    await FirebaseStorage.instance.ref(imagePath).delete();
    await docRef.delete();
  }
}