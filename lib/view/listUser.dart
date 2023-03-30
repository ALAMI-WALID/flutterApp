import 'package:flutter/material.dart';
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
      body: ListView.builder(
        itemCount: _users?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          Map<String, String> user = _users[index];
          return ListTile(
            title: Text(user['email'] ?? ''),
            onTap: () {
              print(user['uid'] ?? '');
            },
          );
        },
      ),
    );
  }
}
