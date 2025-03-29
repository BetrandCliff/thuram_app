
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat-screen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chats')
            .snapshots(), // Get all chat documents
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No chats available"));
          }

          var chatDocs = snapshot.data!.docs;

          // Filter chats where the current user is a participant
          var userChats = chatDocs.where((doc) {
            String chatId = doc.id;
            return chatId.contains(_currentUser.uid);
          }).toList();

          return ListView.builder(
            itemCount: userChats.length,
            itemBuilder: (context, index) {
              var chatDoc = userChats[index];
              var chatId = chatDoc.id;
              List<String> participants = chatId.split("_");

              // Get receiver ID (other user in chat)
              String receiverId =
              participants.firstWhere((id) => id != _currentUser.uid);

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users').doc(receiverId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return const SizedBox(); // Skip if user data not found
                  }

                  var userData = userSnapshot.data!;
                  String receiverName = userData['username'] ?? 'Unknown User';
                  String receiverAvatar = userData['profilePic'] ??
                      "https://example.com/default_avatar.png";

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(receiverAvatar),
                    ),
                    title: Text(receiverName),
                    subtitle: FutureBuilder<QuerySnapshot>(
                      future: _firestore
                          .collection('chats')
                          .doc(chatId)
                          .collection('messages')
                          .orderBy('timestamp', descending: true)
                          .limit(1)
                          .get(),
                      builder: (context, messageSnapshot) {
                        if (!messageSnapshot.hasData ||
                            messageSnapshot.data!.docs.isEmpty) {
                          return const Text("No messages yet");
                        }
                        var lastMessage =
                        messageSnapshot.data!.docs.first['text'];
                        return Text(lastMessage);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            receiverId: receiverId,
                            userName: receiverName,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}


 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/asset-paths.dart';

import 'chat-screen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
  }

  // Method to delete the chat
  Future<void> _deleteChat(String chatId) async {
    try {
      await _firestore.collection('chats').doc(chatId).delete();
      print("Chat deleted successfully");
    } catch (e) {
      print("Error deleting chat: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chats')
            .snapshots(), // Get all chat documents
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No chats available"));
          }

          var chatDocs = snapshot.data!.docs;

          // Filter chats where the current user is a participant
          var userChats = chatDocs.where((doc) {
            String chatId = doc.id;
            return chatId.contains(_currentUser.uid);
          }).toList();

          return ListView.builder(
            itemCount: userChats.length,
            itemBuilder: (context, index) {
              var chatDoc = userChats[index];
              var chatId = chatDoc.id;
              List<String> participants = chatId.split("_");

              // Get receiver ID (other user in chat)
              String receiverId =
              participants.firstWhere((id) => id != _currentUser.uid);

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users').doc(receiverId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return const SizedBox(); // Skip if user data not found
                  }

                  var userData = userSnapshot.data!;
                  String receiverName = userData['username'] ?? 'Unknown User';
                  String receiverAvatar = userData['profilePic'] ??
                      "https://example.com/default_avatar.png";

                  return Dismissible(
                    key: Key(chatId),
                    direction: DismissDirection.endToStart, // Swipe from right to left to delete
                    onDismissed: (direction) {
                      // Delete the chat when swiped
                      _deleteChat(chatId);
                    },
                    background: Container(
                      color: Colors.red, // Background color when swiped
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: receiverAvatar.isNotEmpty? NetworkImage(receiverAvatar):AssetImage(AppImages.profile),
                      ),
                      title: Text(receiverName),
                      subtitle: FutureBuilder<QuerySnapshot>(
                        future: _firestore
                            .collection('chats')
                            .doc(chatId)
                            .collection('messages')
                            .orderBy('timestamp', descending: true)
                            .limit(1)
                            .get(),
                        builder: (context, messageSnapshot) {
                          if (!messageSnapshot.hasData ||
                              messageSnapshot.data!.docs.isEmpty) {
                            return const Text("No messages yet");
                          }
                          var lastMessage =
                          messageSnapshot.data!.docs.first['text'];
                          return Text(lastMessage);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              receiverId: receiverId,
                              userName: receiverName,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
