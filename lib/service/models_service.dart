import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/modele_modele.dart';

class ModeleService extends GetConnect {
  final firestore = FirebaseFirestore.instance;
  Future<void> addModele(Modele modele) async {
    await firestore.collection('modele').add(modele.toMap());
  }

  Future<Modele> getModele(String id) async {
    final doc = await firestore.collection('modele').doc(id).get();
    return Modele.fromMap(doc.data()!, doc.reference);
  }

  Stream<List<Modele>> fetchModeles() {
    final collection = firestore.collection('modele');

    return collection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Modele.fromMap(doc.data(), doc.reference);
      }).toList();
    });
  }

  Future<void> removeModele(String id) async {
    final doc = await firestore.collection('modele').doc(id).get();
    return doc.reference.delete();
  }

  Future<void> updateModele(Modele modele) async {
    final doc = await firestore.collection('modele').doc(modele.id).get();
    return doc.reference.update(modele.toMap());
  }

  Future<List<Map<String, int>>> getTopFiveFavoriteModels() async {
    // Create a map to store the count of each model
    Map<String, int> modelCountMap = {};

    // Query the favorites collection
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('favorie').get();

    // Iterate through the documents in the query result
    for (var doc in querySnapshot.docs) {
      // Get the modelId from the document
      String modelId = doc['idModele'];
      // Update the count in the map
      modelCountMap[modelId] = (modelCountMap[modelId] ?? 0) + 1;
    }

    // Sort the models by count in descending order
    List<Map<String, int>> topModels = modelCountMap.entries
      .map((e) => {e.key: e.value})
      .toList()
      ..sort((a, b) => b.values.first.compareTo(a.values.first));

    // Take the top five models
    List<Map<String, int>> topFiveModels = topModels.take(4).toList();
    return topFiveModels;
  }
}
