import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controller/firebase_manager.dart';

class listUserDisplay extends StatefulWidget {
  const listUserDisplay({Key? key}) : super(key: key);

  @override
  _listUserDisplayState createState() => _listUserDisplayState();
}

class _listUserDisplayState extends State<listUserDisplay> {
  late Future<List<String>> _userEmails;
    FirebaseManager firebaseManager = FirebaseManager();


  @override
  void initState() {
    super.initState();
    _userEmails = firebaseManager.getAllUsersExceptCurrent(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _userEmails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final userEmails = snapshot.data ?? [];

        return ListView.builder(
          itemCount: userEmails.length,
          itemBuilder: (context, index) {
            final userEmail = userEmails[index];
            return ListTile(
              title: Text(userEmail),
              onTap: () {
                final userSelectedId = 'userSelectedId';
                print(userSelectedId);
              },
            );
          },
        );
      },
    );
  }
}
