import '../models/modele_modele.dart';
import '../models/tailleur_modele.dart';

class TaiileurService {
  Stream<List<Tailleur>> fetchTailleurs() {
    return firestore
        .collection('Tailleur')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Tailleur.fromMap(doc.data(), doc.reference))
            .toList());
  }
}