import 'package:faani_dashboard/models/tailleur_modele.dart';
import 'package:faani_dashboard/service/tailleurs_service.dart';
import 'package:get/get.dart';

class TailleurController extends GetxController {
  var tailleur = <Tailleur>[].obs;
  var isLoading = true.obs;

  void fetchTailleurs() async {
    try {
      isLoading(true);
      TaiileurService().fetchTailleurs().listen((tailleur) {
        if (tailleur.isNotEmpty) {
          this.tailleur.assignAll(tailleur);
        }
        // isLoading(false);
      });
    } finally {
      isLoading(false);
    }
  }
}
