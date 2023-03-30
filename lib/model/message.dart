import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String senderEmail;
  String recipientId;
  String recipientEmail;
  String message;
  Timestamp time;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.recipientId,
    required this.recipientEmail,
    required this.message,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'recipientId': recipientId,
      'recipientEmail': recipientEmail,
      'message': message,
      'time': time,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      senderEmail: map['senderEmail'],
      recipientId: map['recipientId'],
      recipientEmail: map['recipientEmail'],
      message: map['message'],
      time: map['time'],
    );
  }

  static fromFirestore(QueryDocumentSnapshot<Object?> doc) {}
}
