import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yohann_application/model/add_user_dialog.dart';
import 'package:yohann_application/screens/chat_page.dart';
import 'package:yohann_application/services/auth_service.dart';
import 'package:yohann_application/services/friend_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
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
        return FriendRequestsDialog(currentUserId: _auth.currentUser!.uid);
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
        onPressed: () => _openAddUserDialog(),
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
          children: snapshot.data!.docs.map<Widget>((doc) {
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

  const FriendRequestsDialog({Key? key, required this.currentUserId})
      : super(key: key);

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
            return const Text('Aucune demande d\'ami en attente.');
          }

          return ListView(
            children: snapshot.data!.docs.map<Widget>((doc) {
              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
              return ListTile(
                trailing: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    acceptFriendRequest(
                      doc.id,
                      currentUserId,
                      data['from'],
                      data['from_username'],
                    );
                    Navigator.of(context).pop();
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Fermer'),
        ),
      ],
    );
  }
}
