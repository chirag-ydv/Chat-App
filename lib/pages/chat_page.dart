import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/components/chat_bubble.dart';
import 'package:whatsapp/components/my_text_field.dart';
import 'package:whatsapp/services/authentication/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiveruseremail;
  final String receiveruserID;
  const ChatPage({
    super.key, 
    required this.receiveruserID, 
    required this.receiveruseremail,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController=TextEditingController();
  final ChatService _chatService=ChatService();
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiveruserID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiveruseremail),),
      body: Column(
        children: [
          //messages
          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _buildMessageInput(),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(stream: _chatService.getMessages(widget.receiveruserID, _firebaseAuth.currentUser!.uid),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error${snapshot.error}');
      }

      if (snapshot.connectionState==ConnectionState.waiting) {
        return const Text('Loading...');
      }

      return ListView(
        children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
      );
     },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
  if (data == null) {
    return Container(); // Handle the case where document data is null
  }
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
      ? Alignment.centerRight
      : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId']==_firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId']==_firebaseAuth.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(data['senderemailId']),
            const SizedBox(height: 5),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          //textfield
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Enter message',
              obscureText: false,
            )
          ),
      
          //send button
          IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_upward, size: 40,
          ),
          )
        ],
      ),
    );
  }
}