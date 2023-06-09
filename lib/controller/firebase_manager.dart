import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/utilisateur.dart';

class FirebaseManager {
  //attributs
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final cloudMessages = FirebaseFirestore.instance.collection("MESSAGES");
  final cloudUsers = FirebaseFirestore.instance.collection("UTILISATEURS");

  //creer un utilisateur
  Future<Utilisateur> Inscription(String email, String password) async {
    UserCredential authResult = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    String? uid = authResult.user?.uid;
    if (uid == null) {
      return Future.error(("error"));
    } else {
      Map<String, dynamic> map = {"EMAIL": email};
      addUser(uid, map);
      return getUser(uid);
    }
  }

  //ajoouter un utlisateur
  addUser(String uid, Map<String, dynamic> map) {
    cloudUsers.doc(uid).set(map);
  }

  //récuperer un utilisateur
  Future<Utilisateur> getUser(String uid) async {
    DocumentSnapshot snapshot = await cloudUsers.doc(uid).get();
    return Utilisateur(snapshot);
  }

  //utilisateur actuel courant connecter 
  Future<Utilisateur> getCurrentUser() async {
    User? user = auth.currentUser;
    if (user == null) {
      return Future.error(("error"));
    } 
      return getUser(user.uid);
    
  }

  // id de ltutilisateur actuel courant connecter
  Future<String> getCurrentUserId() async {
    User? user = auth.currentUser;
    if (user == null) {
      return Future.error(("error"));
    } else {
      return user.uid;
    }
  }


  //connecter avec un utilisateur
  Future<Utilisateur> connect(String email, String password) async {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    String? uid = userCredential.user?.uid;
    if (uid == null) {
      return Future.error(("problème de connexion"));
    } else {
      return getUser(uid!);
    }
  }

// mise à jour d'un utlisateur

//suppression d'un utlisateur

// get list sender
  Future<List<String>> getUniqueSenders(String userId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('MESSAGES')
        .where('recipientId', isEqualTo: userId)
        .get();
    List<String> senders = snapshot.docs
        .map((doc) =>
            (doc.data() as Map<String, dynamic>)['senderEmail']?.toString() ??
            '')
        .toList();
    print("JE SUIS LA MON AMIS ");
    print(senders.toSet().toList());
    return senders.toSet().toList();
  }

  Future<List<Map<String, String>>>  getAllUsersExceptCurrent(String currentUserId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('UTILISATEURS')
        .where('uid', isNotEqualTo: currentUserId)
        .get();
    List<String> users2 = snapshot.docs
        .map((doc) =>
            (doc.data() as Map<String, dynamic>)['EMAIL']?.toString() ?? '')
        .toList();

    print(users2);
        
      List<Map<String, String>> users = snapshot.docs
      .map((doc) => {
        'email': (doc.data() as Map<String, dynamic>)['EMAIL']?.toString() ?? '',
        'uid':(doc.data() as Map<String, dynamic>)['uid']?.toString() ?? '',
      })
      .toList();

    print(users);
    return users;
  }
}
