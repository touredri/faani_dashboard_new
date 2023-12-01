import 'package:cloud_firestore/cloud_firestore.dart';

class Tendance {
  String? id;
  String? details;
  String categorie;
  String image;

  Tendance({
    required this.id,
    this.details,
    required this.categorie,
    required this.image,
  });

  // from map
  factory Tendance.fromMap(Map<String, dynamic> map, DocumentReference docRef) {
    if (map['details'] != null && map['categorie'] != null) {
      return Tendance(
        id: docRef.id,
        details: map['details'] as String,
        categorie: map['categorie'] as String,
        image: map['image'] as String,
      );
    } else {
      throw Exception('Unexpected null value');
    }
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      'categorie': categorie,
      'details': details,
      'image': image,
    };
  }

  // add tendance
  Future<void> addTendance() async {
    final docRef =
        await FirebaseFirestore.instance.collection('tendance').add(toMap());
    id = docRef.id;
  }

  // detele tendance
  Future<void> deleteTendance(String id) async {
    final docRef = FirebaseFirestore.instance.collection('tendance').doc(id);
    await docRef.delete();
    print('Document supprimé');
  }
}
