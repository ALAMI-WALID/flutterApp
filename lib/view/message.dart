import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/message.dart';

class ChatScreen extends StatefulWidget {
  final String? currentUserId;
  final String? recipientId;

  ChatScreen(
      {Key? key, required this.currentUserId, required this.recipientId});

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

                  print("user cible : "+widget.recipientId.toString());
                  print("user courant : "+FirebaseAuth.instance.currentUser!.uid);

    FirebaseFirestore.instance.collection('messages').add({
      'message': messageText,
      'senderId': widget.currentUserId,
      'recipientId': widget.recipientId,
      'recipientEmail': "emaildest@gmail.com",
      "conversationId": widget.currentUserId.toString()+"_"+widget.recipientId.toString(),
      'senderEmail': senderEmail,
      'timestamp': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat : ' + widget.recipientId.toString()),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  // recuperer les messages de la collection messages en fonction de l'id de l'utilisateur courant et de l'id du destinataire
                  FirebaseFirestore.instance
                      .collection('messages')
                      // .where('users', arrayContainsAny: [widget.currentUserId, widget.recipientId])

                      // .where('senderId', whereIn: [widget.currentUserId, widget.recipientId])
                            .where('conversationId', isEqualTo: '${widget.currentUserId}_${widget.recipientId}')

                      // .where('senderId', isEqualTo:  widget.recipientId)
                      // .where('recipientId', isEqualTo: widget.currentUserId)
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

                Widget _buildSentMessage(Message message) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              message.message,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              message.timestamp.toString(),
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                Widget _buildReceivedMessage(Message message) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.message,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              message.timestamp.toString(),
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    // if (
                    // (message.senderId == widget.currentUserId && message.recipientId == widget.recipientId)|| 
                    // (message.senderId == widget.recipientId && message.recipientId == widget.currentUserId)) {
                                        return message.senderId == widget.currentUserId
                        ? _buildSentMessage(message)
                        : _buildReceivedMessage(message);
                    // }
  
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
