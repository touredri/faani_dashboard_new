import 'package:faani_dashboard/constants/constants.dart';
import 'package:faani_dashboard/controllers/clients_controller.dart';
import 'package:faani_dashboard/controllers/commandes_controller.dart';
import 'package:faani_dashboard/controllers/modeles_controller.dart';
import 'package:faani_dashboard/controllers/tailleurs_controller.dart';
import 'package:flutter/material.dart';
import 'package:faani_dashboard/pages/overview/widgets/info_card.dart';
import 'package:get/get.dart';

import '../../../controllers/customers_controller.dart';
import '../../../controllers/products_controller.dart';
import '../../../models/product.dart';

class OverviewCardsMediumScreen extends StatefulWidget {
  const OverviewCardsMediumScreen({super.key});

  @override
  State<OverviewCardsMediumScreen> createState() =>
      _OverviewCardsMediumScreenState();
}

class _OverviewCardsMediumScreenState extends State<OverviewCardsMediumScreen> {
  final ModeleController modeleController = Get.put(ModeleController());
  final CommandeController commandeController = Get.put(CommandeController());
  final TailleurController tailleuController = Get.put(TailleurController());
  final ClientController clientsController = Get.put(ClientController());

  @override
  void initState() {
    super.initState();
    // productsController.fetchProducts();
    // customersController.fetchCustomers();
    modeleController.fetchModeles();
    commandeController.fetchCommandes();
    tailleuController.fetchTailleurs();
    clientsController.fetchClient();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // int calculateTotalStock(List<Product> stock) {
    //   int totalStock = 0;
    //   for (int i = 0; i < productsController.products.length; i++) {
    //     totalStock += productsController.products[i].stock!;
    //   }
    //   return totalStock;
    // }

    // int calculateTotalValue(List<Product> stock) {
    //   int totalValue = 0;
    //   for (int i = 0; i < productsController.products.length; i++) {
    //     totalValue += productsController.products[i].stock! *
    //         productsController.products[i].price!;
    //   }
    //   return totalValue;
    // }

    return Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                InfoCard(
                  title: Constants.totalModele,
                  value: modeleController.modeles.length,
                  onTap: () {},
                  topColor: Colors.orange,
                ),
                SizedBox(
                  width: width / 64,
                ),
                InfoCard(
                  title: Constants.totalCommande,
                  value: commandeController.commandes.length,
                  topColor: Colors.lightGreen,
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(
              height: width / 64,
            ),
            Row(
              children: [
                InfoCard(
                  title: Constants.totalTailleur,
                  value: tailleuController.tailleur.length,
                  topColor: Colors.redAccent,
                  onTap: () {},
                ),
                SizedBox(
                  width: width / 64,
                ),
                InfoCard(
                  title: Constants.totalClient,
                  value: clientsController.clients.length,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ));
  }
}
