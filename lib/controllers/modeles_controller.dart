import 'package:faani_dashboard/models/modele_modele.dart';
import 'package:faani_dashboard/service/models_service.dart';
import 'package:get/get.dart';

class ModeleController extends GetxController {
  var modeles = <Modele>[].obs;
  var isLoading = true.obs;
  var topFiveModele = <Modele>[].obs;
  RxList<Map<String, int>> favoriteCount = <Map<String, int>>[].obs;

  void fetchModeles() async {
    try {
      isLoading(true);
      ModeleService().fetchModeles().listen((modeles) {
        if (modeles.isNotEmpty) {
          this.modeles.assignAll(modeles);
        }
        // isLoading(false);
      });
    } finally {
      isLoading(false);
    }
  }

  void removeModele(String id) async {
    try {
      isLoading(true);
      await ModeleService().removeModele(id);
      modeles.removeWhere((modele) => modele.id == id);
    } finally {
      isLoading(false);
    }
  }

  void updateModele(Modele modele) async {
    try {
      isLoading(true);
      await ModeleService().updateModele(modele);
      var index = modeles.indexWhere((m) => m.id == modele.id);
      modeles[index] = modele;
    } finally {
      isLoading(false);
    }
  }

  void addModele(Modele modele) async {
    try {
      isLoading(true);
      await ModeleService().addModele(modele);
      modeles.add(modele);
    } finally {
      isLoading(false);
    }
  }

  void fetchMostFavoriteModele() async {
    try {
      isLoading(true);
      var favoriteModels = await ModeleService().getTopFiveFavoriteModels();
      favoriteCount.assignAll(favoriteModels);
      for (var element in favoriteModels) {
        var modele = await ModeleService().getModele(element.keys.first);
        topFiveModele.add(modele);
      }
    } finally {
      isLoading(false);
    }
  }
}
