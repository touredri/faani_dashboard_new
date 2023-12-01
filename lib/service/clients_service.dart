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

  Future<void> deleteClient(String id) {
    return firestore
        .collection('client')
        .doc(id)
        .delete()
        .then((value) => print("Client Deleted"))
        .catchError((error) => print("Failed to delete client: $error"));
  }
  
    Future<Client> getClient(String id) {
    return firestore.collection('client').doc(id).get().then(
        (value) => Client.fromMap(value.data() as Map<String, dynamic>, value.reference));
  }
}