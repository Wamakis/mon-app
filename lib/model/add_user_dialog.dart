import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddUserDialog extends StatefulWidget {
  final Function(String) onUserSelected;

  const AddUserDialog({required this.onUserSelected, Key? key})
      : super(key: key);

  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter un utilisateur'),
      content: Container(
        width: double.maxFinite,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Erreur');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Chargement...');
            }

            return ListView(
              children: snapshot.data!.docs.map<Widget>((doc) {
                Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                if (_auth.currentUser!.uid != data['uid']) {
                  if (data['username'] == null) {
                    return Container();
                  } else {
                    return ListTile(
                      title: Text(data['username'].toString()),
                      onTap: () {
                        widget.onUserSelected(data['uid']);
                        Navigator.of(context).pop();
                      },
                    );
                  }
                } else {
                  return Container();
                }
              }).toList(),
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Annuler'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
