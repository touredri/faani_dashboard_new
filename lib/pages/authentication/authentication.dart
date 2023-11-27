// ignore_for_file: use_build_context_synchronously, avoid_print, avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:faani_dashboard/constants/constants.dart';
import 'package:faani_dashboard/controllers/logged_user_controller.dart';
import 'package:faani_dashboard/controllers/register_controller.dart';
import 'package:faani_dashboard/routing/routes.dart';
import 'package:faani_dashboard/constants/controllers.dart';
import 'package:faani_dashboard/constants/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:faani_dashboard/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../../env/env.dart';
import '../../helpers/authentication.dart';
import '../../helpers/custom_auth.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final RegisterController registerController = Get.put(RegisterController());

  final LoggedUserController loggedUserController =
      Get.put(LoggedUserController());

  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode usernameFocus = FocusNode();

  bool isLoginScreen = true;
  bool isEditingEmail = false;
  bool isEditingPassword = false;
  bool isEditingUsername = false;
  bool isRegistering = false;
  bool isLoggingIn = false;
  bool passwordIsVisible = false;
  String successMessage = 'Utilisateur Connecté avec succès';
  String errorMessage = 'Erreur de connexion';

  String? validateEmail(String value) {
    value = value.trim();
    if (registerController.emailController.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        return 'Enter a correct email address';
      }
    }
    return null;
  }

  String? validatePassword(String value) {
    value = value.trim();
    if (registerController.passwordController.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Password can\'t be empty';
      } else if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }
    }
    return null;
  }

  String? validateUsername(String value) {
    value = value.trim();
    if (registerController.usernameController!.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Username can\'t be empty';
      } else if (value.length < 6) {
        return 'Username must be at least 6 characters';
      }
    }
    return null;
  }

  void checkAdmin() async {
    await isAdmin(Env.adminEmail);
  }

  @override
  void initState() {
    super.initState();
    checkAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text("Connexion",
                      style: GoogleFonts.roboto(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CustomText(
                    text: "Bienvenu sur le Faani .",
                    color: lightGray,
                  ),
                ],
              ),
              Row(
                children: [
                  CustomText(
                    text: isLoginScreen ? "" : "will be stored in Firebase.",
                    color: lightGray,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                focusNode: emailFocus,
                controller: registerController.emailController,
                onChanged: (value) {
                  setState(() {
                    isEditingEmail = true;
                  });
                },
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: inputBorderColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: inputBorderColor)),
                    focusColor: active,
                    hoverColor: active,
                    labelText: "Email",
                    hintText: "abc@domain.com",
                    errorText: isEditingEmail
                        ? validateEmail(registerController.emailController.text)
                        : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                focusNode: passwordFocus,
                controller: registerController.passwordController,
                onChanged: (value) {
                  setState(() {
                    isEditingPassword = true;
                  });
                },
                obscureText: !passwordIsVisible,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFFA4CEFB))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFFA4CEFB))),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            passwordIsVisible = !passwordIsVisible;
                          });
                        },
                        child: Icon(
                          passwordIsVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: lightGray,
                        ),
                      ),
                    ),
                    labelText: "Password",
                    hintText: "123456",
                    errorText: isEditingPassword
                        ? validatePassword(
                            registerController.passwordController.text)
                        : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () async {
                  //if we are in the login screen
                  setState(() {
                    isLoggingIn = true;
                  });
                  //show snackbar if the fields are empty and stop execution
                  if (registerController.emailController.text.isEmpty ||
                      registerController.passwordController.text.isEmpty) {
                    var snackbar = const SnackBar(
                        width: 500,
                        padding: EdgeInsets.all(10),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        duration: Duration(seconds: 3),
                        dismissDirection: DismissDirection.horizontal,
                        closeIconColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        content: Center(
                          child: Text(
                            "S'il vous plait, remplissez tous les champs!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    setState(() {
                      isLoggingIn = false;
                    });
                    return;
                  }

                  try {
                    //custom auth
                    User? result = await userLogin(
                        registerController.emailController.text,
                        registerController.passwordController.text);
                    String msg = "Email ou mot de passe incorrect";
                    //custom auth
                    if (result != null) {
                      setState(() {
                        msg = Constants.loginOk;
                      });
                      menuController
                          .changeActiveItemTo(overViewPageDisplayName);
                      Get.offAllNamed(rootRoute);
                    }

                    var snackbar = SnackBar(
                        width: 500,
                        padding: const EdgeInsets.all(10),
                        behavior: SnackBarBehavior.floating,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        duration: const Duration(seconds: 3),
                        dismissDirection: DismissDirection.horizontal,
                        closeIconColor: Colors.white,
                        backgroundColor:
                            //custom auth
                            msg != Constants.loginOk
                                //firebase auth
                                //result != Constants.loginOk
                                ? Colors.redAccent
                                : Colors.green,
                        content: Center(
                          child: Text(
                            msg,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  } catch (e) {
                    var snackbar = const SnackBar(
                        width: 500,
                        padding: EdgeInsets.all(10),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        duration: Duration(seconds: 3),
                        dismissDirection: DismissDirection.horizontal,
                        closeIconColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        content: Center(
                          child: Text(
                            "Error please check your credentials and try again",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  } finally {
                    setState(() {
                      isLoggingIn = false;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: isRegistering || isLoggingIn
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const CustomText(
                          text: "Se connecter",
                          color: Colors.white,
                        ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Center(
                  child: Text(
                "-   Ou   -",
                style: TextStyle(color: Colors.grey),
              )),
              const SizedBox(
                height: 15,
              ),
              Center(
                  child: SignInButton(
                Buttons.Google,
                text: "Connectezavec Google",
                onPressed: () {
                  signInWithGoogle().then((result) {
                    if (result != null) {
                      menuController
                          .changeActiveItemTo(overViewPageDisplayName);
                      Get.offAllNamed(rootRoute);
                    }
                  }).catchError((e) {
                    var snackbar = SnackBar(
                        width: 500,
                        padding: const EdgeInsets.all(10),
                        behavior: SnackBarBehavior.floating,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        duration: const Duration(seconds: 3),
                        dismissDirection: DismissDirection.horizontal,
                        closeIconColor: Colors.white,
                        backgroundColor: primaryColor,
                        content: const Center(
                          child: Text(
                            "Erreur, verifier vos crédential!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  });
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class CookieManager {
  static CookieManager manager = CookieManager.getInstance();

  static getInstance() {
    return manager;
  }

  void addCookie(String key, String value) {
    // 2592000 sec = 30 days.
    document.cookie =
        "$key=$value; max-age=2592000; path=/; SameSite=Lax; Secure";
  }

  String getCookie(String name) {
    String? cookies = document.cookie;
    List<String> listValues = cookies!.isNotEmpty ? cookies.split(";") : [];
    String matchVal = "";
    for (int i = 0; i < listValues.length; i++) {
      List<String> map = listValues[i].split("=");
      String key = map[0].trim();
      String val = map[1].trim();
      if (name == key) {
        matchVal = val;
        break;
      }
    }
    return matchVal;
  }

  void removeCookie(String name) {
    document.cookie = "$name=; max-age=0; path=/; SameSite=Lax; Secure";
  }
}
