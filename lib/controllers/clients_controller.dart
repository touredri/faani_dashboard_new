import 'package:faani_dashboard/models/client_modele.dart';
import 'package:faani_dashboard/service/clients_service.dart';
import 'package:get/get.dart';

class ClientController extends GetxController {
  var clients = <Client>[].obs;
  var isLoading = true.obs;

  void fetchClient() async {
    try {
      isLoading(true);
      ClientService().fetchClient().listen((clients) {
        if (clients.isNotEmpty) {
          this.clients.assignAll(clients);
        }
        // isLoading(false);
      });
    } finally {
      isLoading(false);
    }
  }
}
