import 'dart:ui';
import 'package:faani_dashboard/constants/style.dart';
import 'package:faani_dashboard/controllers/menu_controller.dart'
    as menu_controller;
import 'package:faani_dashboard/controllers/navigation_controller.dart';
import 'package:faani_dashboard/env/env.dart';
import 'package:faani_dashboard/firebase_options.dart';
import 'package:faani_dashboard/layout.dart';
import 'package:faani_dashboard/pages/404/error_page.dart';
import 'package:faani_dashboard/pages/authentication/authentication.dart';
import 'package:faani_dashboard/routing/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controllers/logged_user_controller.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: Env.apiKey,
          appId: Env.appId,
          messagingSenderId: Env.messagingSenderId,
          projectId: Env.projectId,
          authDomain: Env.authDomain,
          storageBucket: Env.storageBucket));
  Get.put(menu_controller.MenuController());
  Get.put(NavigationController());
  Get.put(LoggedUserController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      initialRoute: authenticationPageRoute,
      //currently, unknownRoute does not work as expected
      //you need to NOT use '/' as your home route
      //you can use for example '/home' or '/dashboard' or '/overview'
      //as your home route. This is a bug with the GetX package
      unknownRoute:
          GetPage(name: '/not-found', page: () => const PageNotFound()),
      defaultTransition: Transition.leftToRightWithFade,
      getPages: [
        GetPage(name: rootRoute, page: () => SiteLayout()),
        GetPage(
            name: authenticationPageRoute,
            page: () => const AuthenticationPage()),
      ],
      debugShowCheckedModeBanner: false,
      title: "Faani Dashboard",
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        textTheme: GoogleFonts.mulishTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Colors.black,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
        primarySwatch: Colors.indigo,
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
