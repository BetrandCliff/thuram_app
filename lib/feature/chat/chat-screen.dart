// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String receiverId; // The user ID of the person to chat with
//
//   ChatScreen({required this.receiverId});
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   late User _currentUser;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentUser = _auth.currentUser!;
//   }
//
//   // Generate a chat ID using both user IDs (ensures unique chat)
//   String getChatId() {
//     List<String> ids = [_currentUser.uid, widget.receiverId];
//     ids.sort(); // Ensure consistent order
//     return ids.join("_");
//   }
//
//   // Send message
//   void _sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       String chatId = getChatId();
//
//       _firestore.collection('chats').doc(chatId).collection('messages').add({
//         'text': _controller.text,
//         'senderId': _currentUser.uid,
//         'receiverId': widget.receiverId,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       _controller.clear();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String chatId = getChatId();
//
//     return Scaffold(
//       appBar: AppBar(title: Text("Chat with ${widget.receiverId}")),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('chats')
//                   .doc(chatId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(child: Text("No messages yet"));
//                 }
//
//                 var messages = snapshot.data!.docs;
//                 List<Widget> messageWidgets = messages.map((message) {
//                   var messageText = message['text'];
//                   var senderId = message['senderId'];
//                   bool isCurrentUser = senderId == _currentUser.uid;
//
//                   return ChatBubble(
//                     messageText: messageText,
//                     isCurrentUser: isCurrentUser,
//                   );
//                 }).toList();
//
//                 return ListView(
//                   reverse: true, // Most recent message at the bottom
//                   children: messageWidgets,
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: "Type a message",
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ChatBubble extends StatelessWidget {
//   final String messageText;
//   final bool isCurrentUser;
//
//   ChatBubble({required this.messageText, required this.isCurrentUser});
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isCurrentUser ? Colors.blueAccent : Colors.grey[300],
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Text(
//           messageText,
//           style: TextStyle(
//             color: isCurrentUser ? Colors.white : Colors.black,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId; // The user ID of the person to chat with
  final String userName;
  ChatScreen({required this.receiverId, required this.userName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _currentUser;
  final TextEditingController _controller = TextEditingController();

  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _loadMessages();
  }

  // Generate a chat ID using both user IDs (ensures unique chat)
  String getChatId() {
    List<String> ids = [_currentUser.uid, widget.receiverId];
    ids.sort(); // Ensure consistent order
    return ids.join("_");
  }

  // Load messages from Firestore
  void _loadMessages() {
    String chatId = getChatId();

    _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        messages = snapshot.docs.map((doc) {
          return ChatMessage(
            text: doc['text'],
            user: ChatUser(
              id: doc['senderId'],
              firstName: doc['senderId'] == _currentUser.uid
                  ? 'You'
                  : 'Receiver',
              profileImage: 'https://example.com/default_avatar.png', // Replace with user avatar if available
            ),
            createdAt: doc['timestamp'].toDate(),
          );
        }).toList();
      });
    });
  }

  // Send message
  void _sendMessage(ChatMessage message) {
    String chatId = getChatId();

    _firestore.collection('chats').doc(chatId).collection('messages').add({
      'text': message.text,
      'senderId': _currentUser.uid,
      'receiverId': widget.receiverId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _controller.clear(); // Clear the text field
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat with ${widget.userName}")),
      body: DashChat(
        currentUser: ChatUser(
          id: _currentUser.uid,
          firstName: _currentUser.displayName ?? 'User',
          profileImage: 'https://example.com/default_avatar.png', // Replace with user avatar if available
        ),
        messages: messages,
        onSend: _sendMessage,
        // inputDecoration: InputDecoration(hintText: 'Type a message...'),
        // inputTextController: _controller,
        // isAttachmentButtonEnabled: false, // Disable attachment button if not needed
        // onQuickReply: (reply) {
        //   // Handle quick reply if needed
        // },
      ),
    );
  }
}

