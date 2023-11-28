import '../models/client_modele.dart';
import '../models/modele_modele.dart';

class ClientService {
  Stream<List<Client>> fetchClient() {
    return firestore
        .collection('client')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Client.fromMap(doc.data(), doc.reference))
            .toList());
  }
}