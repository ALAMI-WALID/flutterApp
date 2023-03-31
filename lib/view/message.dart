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
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final initmessages = snapshot.data!.docs
                    .map((doc) => Message.fromFirestore(doc))
                    .toList();

                final senderToRecipientMessages = initmessages.where(
                    (message) =>
                        message.senderId == widget.currentUserId &&
                        message.recipientId == widget.recipientId);

                final recipientToSenderMessages = initmessages.where(
                    (message) =>
                        message.senderId == widget.recipientId &&
                        message.recipientId == widget.currentUserId);

                final messages = [
                  ...senderToRecipientMessages,
                  ...recipientToSenderMessages
                ];

                messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

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
                    return message.senderId == widget.currentUserId
                        ? _buildSentMessage(message)
                        : _buildReceivedMessage(message);
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
