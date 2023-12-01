// ignore_for_file: avoid_print
import 'package:faani_dashboard/constants/style.dart';
import 'package:faani_dashboard/controllers/clients_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/tailleurs_controller.dart';
import '../../../widgets/custom_text.dart';

class ListClient extends StatefulWidget {
  const ListClient({super.key});

  @override
  State<ListClient> createState() => _ListClientState();
}

class _ListClientState extends State<ListClient> {
  final ClientController clientController = Get.put(ClientController());

  @override
  void initState() {
    super.initState();
    clientController.fetchClient();
  }

  @override
  Widget build(BuildContext context) {
    var columns = const [
      DataColumn(label: Text('Nom')),
      DataColumn(label: Text('Téléphone')),
      // DataColumn(label: Text('Quartier')),
      // DataColumn(label: Text('Likes')),
      // DataColumn(label: Text('Genre Couture')),
      // DataColumn(label: Text('is Verified')),
      DataColumn(label: Text('Actions')),
    ];

    final DataTableSource data = MyData();

    return Obx(() => Padding(
          padding: const EdgeInsets.all(16),
          child: clientController.clients.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : PaginatedDataTable(
                  columns: columns,
                  source: data,
                  header: const Text('Tous les clients'),
                  columnSpacing: 50,
                  horizontalMargin: 30,
                  rowsPerPage: 10,
                ),
        ));
  }
}

class MyData extends DataTableSource {
  final ClientController clientController = Get.put(ClientController());

  List<Map<String, dynamic>> data = [];

  MyData() {
    for (var i = 0; i < clientController.clients.length; i++) {
      // tailleurController
      //     .totalTailleurFavorite(tailleurController.clients[i].id!);
      // final int favoriteNumber =
      //     tailleurController.totalTailleurFavorites.value;
      data.add({
        'nom': clientController.clients[i].nomPrenom,
        'telephone': clientController.clients[i].telephone.toString(),
        // 'quartier': tailleurController.tailleur[i].quartier,
        // 'likes': favoriteNumber.toString(),
        // 'genreHabit': tailleurController.tailleur[i].genreHabit,
        // 'isVerify': tailleurController.tailleur[i].isVerify.toString(),
        'actions': {
          'block': () {
            print('Blocker');
          },
          'delete': () {
            clientController.deleteClient(clientController.clients[i].id!);
            print('Supprimer');
          },
        },
      });
    }
  }

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(CustomText(text: data[index]['nom'])),
      DataCell(CustomText(text: data[index]['telephone'])),
      // DataCell(CustomText(text: data[index]['quartier'])),
      // DataCell(Row(
      //   children: [
      //     Icon(Icons.favorite, color: primaryColor),
      //     const SizedBox(width: 5),
      //     CustomText(text: data[index]['likes']),
      //   ],
      // )),
      // DataCell(CustomText(text: data[index]['genreHabit'])),
      // DataCell(CustomText(text: data[index]['isVerify'])),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.lock_clock),
            color: Colors.indigo,
            onPressed: data[index]['actions']['block'],
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.redAccent,
            onPressed: data[index]['actions']['delete'],
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
