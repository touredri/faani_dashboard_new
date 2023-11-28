import 'package:faani_dashboard/pages/clients/clients.dart';
import 'package:faani_dashboard/pages/modele/modele.dart';
// import 'package:faani_dashboard/pages/overview/overview.dart';
import 'package:faani_dashboard/pages/products/products.dart';
import 'package:faani_dashboard/pages/tailleur/tailleur.dart';
import 'package:faani_dashboard/routing/routes.dart';
import 'package:flutter/material.dart';
import '../pages/authentication/authentication.dart';
import '../pages/client/client.dart';
import '../pages/commande/commande.dart';
import '../pages/home_page/home_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // case overViewPageRoute:
    //   return getPageRoute(const OverviewPage());
    case productsPageRoute:
      return getPageRoute(const ProductsPage());
    case clientsPageRoute:
      return getPageRoute(const ClientsPage());
    case authenticationPageRoute:
      return getPageRoute(const AuthenticationPage());
    case homePageRoute:
      return getPageRoute(const HomePage());
    case clientPageRoute:
      return getPageRoute(const ClientPage());
    case tailleurPageRoute:
      return getPageRoute(const TailleurPage());
    case commandePageRoute:
      return getPageRoute(const CommandePage());
    case modelePageRoute:
      return getPageRoute(const ModelePage());
    default:
      return getPageRoute(const HomePage());
  }
}

PageRoute getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
