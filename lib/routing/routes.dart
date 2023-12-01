const rootRoute = "/homepage";

const overViewPageDisplayName = "Overview";
const overViewPageRoute = "/overview";

// const productsPageDisplayName = "Products";
// const productsPageRoute = "/products";

// const clientsPageDisplayName = "Clients";
// const clientsPageRoute = "/clients";

const authenticationDisplayName = "Log Out";
const authenticationPageRoute = "/auth";

const homePageDisplayName = "Home";
const homePageRoute = "/homepage";

const clientPageDisplayName = "Client";
const clientPageRoute = "/clientpage";

const tailleurPageDisplayName = "Tailleur";
const tailleurPageRoute = "/tailleurpage";

const commandePageDisplayName = "Commande";
const commandePageRoute = "/commandepage";

const modelePageDisplayName = "Modele";
const modelePageRoute = "/modelepage";

class MenuItem {
  final String name;
  final String route;

  MenuItem({required this.name, required this.route});
}

List<MenuItem> sideMenuItems = [
  // MenuItem(name: overViewPageDisplayName, route: overViewPageRoute),
  MenuItem(name: homePageDisplayName, route: homePageRoute),
  MenuItem(name: tailleurPageDisplayName, route: tailleurPageRoute),
  MenuItem(name: clientPageDisplayName, route: clientPageRoute),
  MenuItem(name: modelePageDisplayName, route: modelePageRoute),
  MenuItem(name: commandePageDisplayName, route: commandePageRoute),
  // MenuItem(name: productsPageDisplayName, route: productsPageRoute),
  // MenuItem(name: clientsPageDisplayName, route: clientsPageRoute),
  MenuItem(name: authenticationDisplayName, route: authenticationPageRoute),
];
