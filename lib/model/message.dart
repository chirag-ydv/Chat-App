import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderemail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message({required this.senderId, required this.senderemail, required this.receiverId, required this.timestamp, required this.message});

  //convert to a map
  Map<String,dynamic> toMap() {
    return {
      'senderID': senderId,
      'senderemail': senderemail,
      'receiverID': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}