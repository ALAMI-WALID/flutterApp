import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/message.dart';

class ChatScreen extends StatefulWidget {
  final String? currentUserId;
   final String? recipientId;


  ChatScreen( {Key? key, required this.currentUserId, required this.recipientId});

 @override
  _ChatScreenState createState() => _ChatScreenState();

}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

void _sendMessage() async {
    final String messageText = _textEditingController.text;
    _textEditingController.clear();

    if (messageText.trim().isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    final senderEmail = currentUser!.email;

    FirebaseFirestore.instance.collection('messages').add({
      'message': messageText,
      'senderId': widget.currentUserId,
      'recipientId': widget.recipientId,
      'recipientEmail': FirebaseAuth.instance.currentUser!.email,
      'senderEmail': senderEmail,
      'timestamp': Timestamp.now(),

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  // recuperer les messages de la collection messages en fonction de l'id de l'utilisateur courant et de l'id du destinataire
                  FirebaseFirestore.instance
                      .collection('messages')
                      .where('senderId', isEqualTo:  widget.currentUserId)
                      .where('recipientId', isEqualTo: widget.recipientId)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = snapshot.data!.docs
                    .map((doc) => Message.fromFirestore(doc))
                    .toList()
                  ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

                // Scroll to the end of the list when new messages arrive
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                });

                return ListView.builder(
                  controller:
                      _scrollController, // Attach the ScrollController to the ListView
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message.message),
                      subtitle: Text(message.senderId),
                      trailing: Text(message.timestamp.toString()),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
