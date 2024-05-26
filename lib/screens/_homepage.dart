import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yohann_application/screens/chat_page.dart';
import 'package:yohann_application/services/auth_service.dart';
import 'package:yohann_application/services/friend_service.dart';
import 'package:yohann_application/model/add_user_dialog.dart'; // Ajoutez cette ligne

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

  void _refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Message',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: _refreshPage,
            icon: const Icon(Icons.refresh),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: _buildUserList()),
          Expanded(
              child:
                  _buildFriendRequests()), // Ajoutez cette ligne pour afficher les demandes d'amis
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

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
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
              return ListTile(
                title: Text(data['email']),
                trailing: IconButton(
                  icon: Icon(Icons.person_add),
                  onPressed: () => _sendFriendRequest(data['uid']),
                ),
                onTap: () {
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
              );
            } else {
              return Container();
            }
          }).toList(),
        );
      },
    );
  }

  Widget _buildFriendRequests() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('friend_requests')
          .where('to', isEqualTo: _auth.currentUser!.uid)
          .where('status', isEqualTo: 'pending')
          .snapshots(),
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
            return ListTile(
              title: Text('Demande d\'ami de ${data['from']}'),
              trailing: IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  acceptFriendRequest(
                      doc.id, _auth.currentUser!.uid, data['from']);
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
