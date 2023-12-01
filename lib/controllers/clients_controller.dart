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
      });
    } finally {
      isLoading(false);
    }
  }

  void deleteClient(String id) async {
    try {
      isLoading(true);
      await ClientService().deleteClient(id);
      fetchClient();
    } finally {
      isLoading(false);
    }
  }
}
