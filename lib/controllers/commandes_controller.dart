import 'package:faani_dashboard/models/commande_modele.dart';
import 'package:faani_dashboard/service/commandes_service.dart';
import 'package:get/get.dart';

class CommandeController extends GetxController {
  var commandes = <Commande>[].obs;
  var commande = <Commande>[].obs;
  var isLoading = true.obs;

  void fetchCommandes() async {
    try {
      isLoading(true);
      CommandeService().fetchCommandes().listen((commandes) {
        if (commandes.isNotEmpty) {
          this.commandes.assignAll(commandes);
        }
        // isLoading(false);
      });
    } finally {
      isLoading(false);
    }
  }

  void fetchCommandeByIdUser(String idUser) async {
    try {
      isLoading(true);
      CommandeService().fetchCommandeByIdUser(idUser).listen((commandes) {
        if (commandes.isNotEmpty) {
          this.commande.assignAll(commandes);
        }
        // isLoading(false);
      });
    } finally {
      isLoading(false);
    }
  }
}
