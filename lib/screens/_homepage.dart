import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yohann_application/model/add_user_dialog.dart';
import 'chat_page.dart';
import '../services/auth_service.dart';
import '../services/friend_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  void _sendFriendRequest(String friendUserId) {
    sendFriendRequest(_auth.currentUser!.uid, friendUserId);
  }

  void _openFriendRequestsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FriendRequestsDialog(
          currentUserId: _auth.currentUser!.uid,
          currentUserEmail: _auth.currentUser!.email!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Mes Amis',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: _openFriendRequestsDialog,
            icon: const Icon(Icons.person_add),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: _buildFriendsList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddUserDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }

  void _openAddUserDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddUserDialog(onUserSelected: _sendFriendRequest);
      },
    );
  }

  Widget _buildFriendsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('friends')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Erreur');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text('Aucun ami dans votre liste d\'amis.'));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['username']),
              trailing: IconButton(
                icon: Icon(Icons.chat),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        receiverUserEmail: data['email'],
                        receiverUserID: data['uid'],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class FriendRequestsDialog extends StatelessWidget {
  final String currentUserId;
  final String currentUserEmail;

  const FriendRequestsDialog({
    Key? key,
    required this.currentUserId,
    required this.currentUserEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Demandes d\'amis'),
      content: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('friend_requests')
            .where('to', isEqualTo: currentUserId)
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Erreur');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucune demande d\'ami.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['fromEmail']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentSnapshot snapshot =
                              await transaction.get(doc.reference);
                          if (snapshot.exists) {
                            transaction
                                .update(doc.reference, {'status': 'accepted'});
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUserId)
                                .collection('friends')
                                .doc(data['from'])
                                .set({
                              'uid': data['from'],
                              'email': data['fromEmail']
                            });
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(data['from'])
                                .collection('friends')
                                .doc(currentUserId)
                                .set({
                              'uid': currentUserId,
                              'email': currentUserEmail
                            });
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        doc.reference.delete();
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      actions: [
        TextButton(
          child: Text('Fermer'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
