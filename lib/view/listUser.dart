import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mlkit/model/utilisateur.dart';
import '../controller/firebase_manager.dart';

class UserListWidget extends StatefulWidget {
  @override
  _UserListWidgetState createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  late List<Map<String, String>> _users;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    FirebaseManager manager = FirebaseManager();
    String currentUserId = await manager.getCurrentUserId();
    // late String currentUserId;
    // manager.getCurrentUser().then((value) => currentUserId = value.uid);
    List<Map<String, String>> users = await manager.getAllUsersExceptCurrent(currentUserId);
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseManager().cloudUsers.snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List document = snapshot.data!.docs;
            return ListView.builder(
              itemCount: document.length,
              itemBuilder: (context, index) {
               Utilisateur other= Utilisateur(document[index]);
                return ListTile(
                  title: Text(other.email),
                  subtitle: Text(other.uid),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } 

        
        ),
        )

    );
  }
}
