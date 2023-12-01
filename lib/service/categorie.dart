import 'package:cloud_firestore/cloud_firestore.dart';

class Categorie {}

final FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<List<Map<String, dynamic>>> getCategories() async {
  List<Map<String, dynamic>> categories = [];
  final collection = FirebaseFirestore.instance.collection('categorie');
  final querySnapshot = await collection.get();
  querySnapshot.docs.forEach((doc) {
    categories.add({
      'id': doc.id,
      'libele': doc.data()['libelle'],
    });
  });
  return categories;
}
