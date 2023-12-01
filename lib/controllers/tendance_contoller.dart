import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/tendence.dart';
import '../service/tendance_service.dart';

class TendanceController extends GetxController {
  var tendances = <Tendance>[].obs;
  var isLoading = true.obs;

  void fetchTendance() async {
    try {
      isLoading(true);
      TendanceService().fetchTendance().listen((tendances) {
        if (tendances.isNotEmpty) {
          this.tendances.assignAll(tendances);
        }
      });
    } finally {
      isLoading(false);
    }
  }

  void deleteTendance(String id) async {
    try {
      isLoading(true);
      await TendanceService().deleteTendance(id);
      fetchTendance();
    } finally {
      isLoading(false);
    }
  }
}
