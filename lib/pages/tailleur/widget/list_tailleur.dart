// ignore_for_file: avoid_print
import 'package:faani_dashboard/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/products_controller.dart';
import '../../../controllers/tailleurs_controller.dart';
import '../../../widgets/custom_text.dart';

class ListTailleur extends StatefulWidget {
  const ListTailleur({super.key});

  @override
  State<ListTailleur> createState() => _ListTailleurState();
}

class _ListTailleurState extends State<ListTailleur> {
  final ProductsController productsController = Get.put(ProductsController());
  final TailleurController tailleurController = Get.put(TailleurController());

  @override
  void initState() {
    super.initState();
    productsController.fetchProducts();
    tailleurController.fetchTailleurs();
  }

  @override
  Widget build(BuildContext context) {
    var columns = const [
      DataColumn(label: Text('Nom')),
      DataColumn(label: Text('Téléphone')),
      DataColumn(label: Text('Quartier')),
      DataColumn(label: Text('Likes')),
      DataColumn(label: Text('Genre Couture')),
      DataColumn(label: Text('is Verified')),
      DataColumn(label: Text('Actions')),
    ];

    final DataTableSource data = MyData();

    return Obx(() => Padding(
          padding: const EdgeInsets.all(16),
          child: tailleurController.tailleur.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : PaginatedDataTable(
                  columns: columns,
                  source: data,
                  header: const Text('Tous les tailleurs'),
                  columnSpacing: 50,
                  horizontalMargin: 30,
                  rowsPerPage: 10,
                ),
        ));
  }
}

class MyData extends DataTableSource {
  final TailleurController tailleurController = Get.put(TailleurController());

  List<Map<String, dynamic>> data = [];

  MyData() {
    for (var i = 0; i < tailleurController.tailleur.length; i++) {
      tailleurController
          .totalTailleurFavorite(tailleurController.tailleur[i].id!);
      final int favoriteNumber =
          tailleurController.totalTailleurFavorites.value;
      data.add({
        'nom': tailleurController.tailleur[i].nomPrenom,
        'telephone': tailleurController.tailleur[i].telephone.toString(),
        'quartier': tailleurController.tailleur[i].quartier,
        'likes': favoriteNumber.toString(),
        'genreHabit': tailleurController.tailleur[i].genreHabit,
        'isVerify': tailleurController.tailleur[i].isVerify.toString(),
        'actions': {
          'block': () {
            print('Blocker');
          },
          'delete': () {
            tailleurController.deleteTailleur(
                tailleurController.tailleur[i].id!); // ignore: avoid_print
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
      DataCell(CustomText(text: data[index]['quartier'])),
      DataCell(Row(
        children: [
          Icon(Icons.favorite, color: primaryColor),
          const SizedBox(width: 5),
          CustomText(text: data[index]['likes']),
        ],
      )),
      DataCell(CustomText(text: data[index]['genreHabit'])),
      DataCell(CustomText(text: data[index]['isVerify'])),
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
