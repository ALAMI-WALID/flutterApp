import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'listUser.dart';
import 'message.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

    String? userId; // L'ID de l'utilisateur connecté
  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid; // Récupérez l'ID de l'utilisateur connecté lors de l'initialisation
  }
  //variable
  int currentPage = 0;


  //méthode
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: listUserDisplay(userId: userId!),
      ),
      appBar: AppBar(),
      body: bodyPage(currentPage),
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentPage,
        onTap: (value){
          setState(() {
            currentPage = value;
          });


        },
        items:const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Listes"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favoris"
          ),

        ],

      ),

    );
  }

  Widget bodyPage(int page){
    switch(page){
      case 0 : return ChatScreen(currentUserId: userId);
      case 1: return Text("Second page");
      default : return const Text("Mauvaise page");
    }

  }
}


