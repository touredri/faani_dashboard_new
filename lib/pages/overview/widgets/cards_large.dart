import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faani_dashboard/constants/constants.dart';
import 'package:faani_dashboard/controllers/clients_controller.dart';
import 'package:faani_dashboard/controllers/commandes_controller.dart';
import 'package:faani_dashboard/controllers/modeles_controller.dart';
import 'package:faani_dashboard/controllers/tailleurs_controller.dart';
import 'package:flutter/material.dart';
import 'package:faani_dashboard/pages/overview/widgets/info_card.dart';
import 'package:get/get.dart';
import '../../../controllers/logged_user_controller.dart';
import '../../../models/logged_user.dart';

class OverviewCardsLargeScreen extends StatefulWidget {
  const OverviewCardsLargeScreen({
    super.key,
  });

  @override
  State<OverviewCardsLargeScreen> createState() =>
      _OverviewCardsLargeScreenState();
}

class _OverviewCardsLargeScreenState extends State<OverviewCardsLargeScreen> {
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
    uerFetch();
  }

  void uerFetch() async {
    LoggedUserController loggedUserController = Get.put(LoggedUserController());
    LoggedUser user = LoggedUser();
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore
        .instance
        .collection('admin')
        .doc('dcompte223@gmail.com')
        .get();
    Map<String, dynamic> data = docSnapshot.data()!;
    user.uid = data['uid'];
    user.email = data['email'];
    user.name = data['name'];
    user.imageUrl = data['imageUrl'] ?? '';
    loggedUserController.loggedUser = user;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Obx(() => Row(
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
            SizedBox(
              width: width / 64,
            ),
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
        ));
  }
}
