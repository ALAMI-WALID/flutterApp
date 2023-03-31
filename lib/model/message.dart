import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String senderId;
  final DateTime timestamp;
  final String senderEmail;
  final String recipientId;
  final String recipientEmail;
  final String conversationId;



  Message({
    required this.message,
    required this.senderId,
    required this.timestamp,
    required this.senderEmail,
    required this.recipientId,
    required this.recipientEmail,
    required this.conversationId,
  });

  static Message fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      message: data['message'] ?? '',
      senderId: data['senderId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      senderEmail: data['senderEmail'] ?? '',
      recipientId: data['recipientId'] ?? '',
      recipientEmail: data['recipientEmail'] ?? '',
      conversationId: data['conversationId'] ?? '',
    );
  }
}
