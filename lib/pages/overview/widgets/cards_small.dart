import 'package:faani_dashboard/constants/constants.dart';
import 'package:faani_dashboard/controllers/clients_controller.dart';
import 'package:faani_dashboard/controllers/commandes_controller.dart';
import 'package:faani_dashboard/controllers/modeles_controller.dart';
import 'package:faani_dashboard/controllers/tailleurs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'info_card_small.dart';

class OverviewCardsSmallScreen extends StatefulWidget {
  const OverviewCardsSmallScreen({super.key});

  @override
  State<OverviewCardsSmallScreen> createState() =>
      _OverviewCardsSmallScreenState();
}

class _OverviewCardsSmallScreenState extends State<OverviewCardsSmallScreen> {
  final ModeleController modeleController = Get.put(ModeleController());
  final CommandeController commandeController = Get.put(CommandeController());
  final TailleurController tailleuController = Get.put(TailleurController());
  final ClientController clientsController = Get.put(ClientController());

  @override
  void initState() {
    super.initState();
    modeleController.fetchModeles();
    commandeController.fetchCommandes();
    tailleuController.fetchTailleurs();
    clientsController.fetchClient();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 400,
      child: Obx(
        () => Column(
          children: [
            InfoCardSmall(
              title: Constants.totalModele,
              value: modeleController.modeles.length,
              onTap: () {},
              isActive: true,
            ),
            SizedBox(
              height: width / 64,
            ),
            InfoCardSmall(
              title: Constants.totalCommande,
              value: commandeController.commandes.length,
              onTap: () {},
            ),
            SizedBox(
              height: width / 64,
            ),
            InfoCardSmall(
              title: Constants.totalTailleur,
              value: tailleuController.tailleur.length,
              onTap: () {},
            ),
            SizedBox(
              height: width / 64,
            ),
            InfoCardSmall(
              title: Constants.totalClient,
              value: clientsController.clients.length,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
