import "package:flutter/material.dart";
import "package:yohann_application/screens/_pagedeconnexion.dart";
import "package:yohann_application/screens/_registerpage.dart";

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return PageDeConnexion(onTap: togglePages);
    } else {
      return registerPage(
        onTap: togglePages,
      );
    }
  }
}
