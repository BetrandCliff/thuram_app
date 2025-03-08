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


/*
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
}*/

//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String receiverId;
//   final String userName;
//
//   const ChatScreen({Key? key, required this.receiverId, required this.userName})
//       : super(key: key);
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   String? currentUserId;
//   String? receiverFCMToken;
//
//   @override
//   void initState() {
//     super.initState();
//     currentUserId = _auth.currentUser?.uid;
//     _initializeNotifications();
//     _fetchReceiverFCMToken();
//   }
//
//   // Initialize local notifications
//   void _initializeNotifications() {
//     const InitializationSettings initializationSettings =
//     InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//     );
//     _localNotificationsPlugin.initialize(initializationSettings);
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showNotification(message);
//     });
//   }
//
//   // Fetch recipient's FCM token
//   void _fetchReceiverFCMToken() async {
//     DocumentSnapshot userDoc =
//     await _firestore.collection('users').doc(widget.receiverId).get();
//     setState(() {
//       receiverFCMToken = userDoc['fcmToken'];
//     });
//   }
//
//   // Send a message & trigger push notification
//   void _sendMessage() async {
//     if (_messageController.text.isEmpty || currentUserId == null) return;
//
//     String message = _messageController.text.trim();
//     _messageController.clear();
//
//     await _firestore
//         .collection('chats')
//         .doc(currentUserId)
//         .collection('messages')
//         .add({
//       'senderId': currentUserId,
//       'receiverId': widget.receiverId,
//       'text': message,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     await _firestore
//         .collection('chats')
//         .doc(widget.receiverId)
//         .collection('messages')
//         .add({
//       'senderId': currentUserId,
//       'receiverId': widget.receiverId,
//       'text': message,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     // Send push notification
//     _sendPushNotification(message);
//   }
//
//   // Send push notification
//   void _sendPushNotification(String message) async {
//     if (receiverFCMToken == null) return;
//
//     try {
//       await FirebaseFirestore.instance.collection('notifications').add({
//         'token': receiverFCMToken,
//         'title': "New message from ${_auth.currentUser?.displayName ?? 'Someone'}",
//         'body': message,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print("Error sending notification: $e");
//     }
//   }
//
//   // Show notification locally
//   Future<void> _showNotification(RemoteMessage message) async {
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: AndroidNotificationDetails(
//         'chat_messages',
//         'Chat Messages',
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker',
//       ),
//     );
//
//     await _localNotificationsPlugin.show(
//       message.hashCode,
//       message.notification?.title,
//       message.notification?.body,
//       notificationDetails,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.userName)),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('chats')
//                   .doc(currentUserId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//
//                 var messages = snapshot.data!.docs;
//
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     var message = messages[index];
//                     bool isMe = message['senderId'] == currentUserId;
//
//                     return Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         padding: EdgeInsets.all(10),
//                         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.blueAccent : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           message['text'],
//                           style: TextStyle(color: isMe ? Colors.white : Colors.black),
//                         ),
//                       ),
//                     );
//                   },
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
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.blue),
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


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId; // The user ID of the person to chat with
  final String userName;

  const ChatScreen({Key? key, required this.receiverId, required this.userName})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  late String currentUserId;
  String? receiverFCMToken;
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser!.uid;
    _initializeNotifications();
    _fetchReceiverFCMToken();
    _loadMessages();
  }

  // Initialize local notifications
  void _initializeNotifications() {
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    _localNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });
  }

  // Fetch recipient's FCM token
  void _fetchReceiverFCMToken() async {
    DocumentSnapshot userDoc =
    await _firestore.collection('users').doc(widget.receiverId).get();
    setState(() {
      receiverFCMToken = userDoc['fcmToken'];
    });
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
              firstName: doc['senderId'] == currentUserId
                  ? 'You'
                  : widget.userName,
              profileImage: 'https://example.com/default_avatar.png', // Placeholder, replace with user data
            ),
            createdAt: doc['timestamp'].toDate(),
          );
        }).toList();
      });
    });
  }

  // Generate a chat ID using both user IDs (ensures unique chat)
  String getChatId() {
    List<String> ids = [currentUserId, widget.receiverId];
    ids.sort(); // Ensure consistent order
    return ids.join("_");
  }

  // Send a message & trigger push notification
  void _sendMessage(ChatMessage message) async {
    if (message.text.isEmpty || currentUserId == null) return;

    String chatId = getChatId();

    // Send message to Firestore for both users
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'receiverId': widget.receiverId,
      'text': message.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Send push notification
    _sendPushNotification(message.text);
  }

  // Send push notification
  void _sendPushNotification(String message) async {
    if (receiverFCMToken == null) return;

    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'token': receiverFCMToken,
        'title': "New message from ${_auth.currentUser?.displayName ?? 'Someone'}",
        'body': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  // Show notification locally
  Future<void> _showNotification(RemoteMessage message) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'chat_messages',
        'Chat Messages',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      ),
    );

    await _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.userName)),
      body: DashChat(
        currentUser: ChatUser(
          id: currentUserId,
          firstName: _auth.currentUser?.displayName ?? 'User',
          profileImage: 'https://example.com/default_avatar.png', // Placeholder, replace with user data
        ),
        messages: messages,
        onSend: _sendMessage,
        // avatarBuilder: (user) => CircleAvatar(
        //   backgroundImage: NetworkImage(user.profileImage),
        // ),
        inputOptions: InputOptions(
          inputDecoration: InputDecoration(
            hintText: 'Type a message...',
            hintStyle: Theme.of(context).textTheme.displaySmall,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}


