import 'package:flutter/material.dart';

// import firebase FirebaseManager
import '../controller/firebase_manager.dart';


class listUserDisplay extends StatelessWidget {
  final String userId;
  FirebaseManager firebaseManager = FirebaseManager();


  listUserDisplay({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.all(20),
        child: FutureBuilder<List<String>>(
          future: firebaseManager.getUniqueSenders(userId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<String> senders = snapshot.data!;
              return ListView.builder(
                itemCount: senders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(senders[index]),
                    onTap: () {
                      // Do something when the item is clicked
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
