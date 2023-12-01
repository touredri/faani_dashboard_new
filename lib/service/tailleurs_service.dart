import '../models/modele_modele.dart';
import '../models/tailleur_modele.dart';

class TaiileurService {
  // get all the tailleur
  Stream<List<Tailleur>> fetchTailleurs() {
    return firestore
        .collection('Tailleur')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Tailleur.fromMap(doc.data(), doc.reference))
            .toList());
  }

  // get total number of modele in collection favorite for a particular tailleur
  Stream<int> totalTailleurFavorite(String id) {
    return firestore
        .collection('favorite')
        .where('id', isEqualTo: id)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.length);
  }

    Future<Tailleur> getTailleur(String id) {
    return firestore.collection('Tailleur').doc(id).get().then(
        (value) => Tailleur.fromMap(value.data() as Map<String, dynamic>, value.reference));
  }


  // delete a tailleur
  deleteTailleur(String id) {
    firestore.collection('Tailleur').doc(id).delete();
  }

}