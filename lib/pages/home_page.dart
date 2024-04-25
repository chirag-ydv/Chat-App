import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/pages/chat_page.dart';
import 'package:whatsapp/services/authentication/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //instance of auth
  final FirebaseAuth _auth=FirebaseAuth.instance;

  //sign user out
  void signOut() {
    //get auth service
    final authService=Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
        //sign out button
        IconButton(
          onPressed: signOut, 
          icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error!');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading...');
        }

        return ListView(
          children: snapshot.data!.docs
          .map<Widget>((doc) => _buildUserListItem(doc))
          .toList(),
        );
      },
    );
  }

  //build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
    if (data == null) {
        return Container();
    }

    //display all users except current user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          //pass the clicked user's uid to the chat app
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiveruseremail: data['email'],
                receiveruserID: data['UID'],
              ),
            ),
          );
        },
      );
    } else {
      //return empty container
      return Container();
    }
  }
}