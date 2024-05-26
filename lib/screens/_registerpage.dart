import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yohann_application/composants/_loginbutton.dart';
import 'package:yohann_application/composants/_loginfield.dart';
import 'package:yohann_application/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Ajoutez cette ligne

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
  final usernameText =
      TextEditingController(); // Ajoutez cette ligne pour le nom d'utilisateur

  void register() async {
    if (passwordText.text != confirmpasswordText.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Les mots de passe ne correspondent pas !")),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      UserCredential userCredential = await authService
          .createUserWithEmailPassword(emailText.text, passwordText.text);

      // Ajouter le nom d'utilisateur à la base de données
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': emailText.text,
        'username': usernameText.text, // Ajoutez le nom d'utilisateur
        'uid': userCredential.user!.uid,
      });

      // Afficher un message de succès ou naviguer vers une autre page
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
                    controller: usernameText, // Champ pour le nom d'utilisateur
                    hintText: "Nom d'utilisateur",
                    obscureText: false),
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
                    hintText: "Mot de passe",
                    obscureText: true),
                SizedBox(
                  height: 20,
                ),
                MyLoginField(
                    controller: confirmpasswordText,
                    hintText: "Confirmer le mot de passe",
                    obscureText: true),
                SizedBox(
                  height: 30,
                ),
                MyloginButton(onTap: () => register(), text: "Créer le compte"),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Vous avez déjà un compte?"),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Connectez-vous!",
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
