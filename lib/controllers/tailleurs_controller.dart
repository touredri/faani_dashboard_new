import 'package:faani_dashboard/models/tailleur_modele.dart';
import 'package:faani_dashboard/service/tailleurs_service.dart';
import 'package:get/get.dart';

class TailleurController extends GetxController {
  var tailleur = <Tailleur>[].obs;
  var totalTailleurFavorites = 0.obs;
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

  void deleteTailleur(String id) async {
    try {
      isLoading(true);
      await TaiileurService().deleteTailleur(id);
    } finally {
      isLoading(false);
    }
  }

  void totalTailleurFavorite(String id) async {
    try {
      isLoading(true);
      TaiileurService().totalTailleurFavorite(id).listen((event) { 
        totalTailleurFavorites(event);
      });
    } finally {
      isLoading(false);
    }
  }
}
