import 'package:flutter/material.dart';
import 'package:yohann_application/composants/_loginfield.dart';
import 'package:yohann_application/composants/_loginbutton.dart';
import 'package:provider/provider.dart';
import 'package:yohann_application/services/auth_service.dart';

class PageDeConnexion extends StatefulWidget {
  final void Function()? onTap;

  const PageDeConnexion({Key? key, required this.onTap}) : super(key: key);

  @override
  State<PageDeConnexion> createState() => _PageDeConnexionState();
}

class _PageDeConnexionState extends State<PageDeConnexion> {
  final emailText = TextEditingController();
  final passwordText = TextEditingController();

  @override
  void dispose() {
    emailText.dispose();
    passwordText.dispose();
    super.dispose();
  }

  void login() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailPassword(
          emailText.text, passwordText.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Connexion en cours ..."),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  "assets/logo1.png",
                  fit: BoxFit.contain,
                  width: 150,
                  height: 150,
                ),
                Text(
                  "Connexion",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                MyLoginField(
                  controller: emailText,
                  hintText: "Email",
                  obscureText: false,
                ),
                SizedBox(height: 10),
                MyLoginField(
                  controller: passwordText,
                  hintText: "Password",
                  obscureText: true,
                ),
                SizedBox(height: 30),
                MyloginButton(onTap: login, text: "Connexion"),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Vous etez nouveau?"),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        " creer un compte !",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
