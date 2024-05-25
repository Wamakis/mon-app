import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:yohann_application/composants/_loginbutton.dart";
import "package:yohann_application/composants/_loginfield.dart";
import "package:yohann_application/services/auth_service.dart";

class registerPage extends StatefulWidget {
  final void Function()? onTap;
  const registerPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  final confirmpasswordText = TextEditingController();

  void register() async {
    if (passwordText.text != confirmpasswordText.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Les mots de passe ne correspondent pas !")),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.createUserWithEmailPassword(
          emailText.text, passwordText.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Une erreur s'est produite lors de l'inscription.")),
      );
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
                  "S'inscrire",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                MyLoginField(
                    controller: emailText,
                    hintText: "Email",
                    obscureText: false),
                SizedBox(
                  height: 10,
                ),
                MyLoginField(
                    controller: passwordText,
                    hintText: "Password",
                    obscureText: true),
                SizedBox(
                  height: 20,
                ),
                MyLoginField(
                    controller: confirmpasswordText,
                    hintText: "Confirm Password",
                    obscureText: true),
                SizedBox(
                  height: 30,
                ),
                MyloginButton(onTap: () => register(), text: "Creer le compte"),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Vous avez deja un compte?"),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Connectez votre compte !",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
