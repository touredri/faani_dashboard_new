import '../models/commande_modele.dart';
import '../models/modele_modele.dart';

class CommandeService {
  // get all commande
  Stream<List<Commande>> fetchCommandes() {
    return firestore
        .collection('commande')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Commande.fromMap(doc.data(), doc.reference))
            .toList());
  }
  // get all commande by id user
  Stream<List<Commande>> fetchCommandeByIdUser(String idUser) {
    return firestore
        .collection('commande')
        .where('idUser', isEqualTo: idUser)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Commande.fromMap(doc.data(), doc.reference))
            .toList());
  }
}
