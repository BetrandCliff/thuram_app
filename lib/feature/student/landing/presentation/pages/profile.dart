import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/util/custom-button.dart';
import 'package:thuram_app/util/next-screen.dart';
import 'package:thuram_app/util/widthandheight.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../chat/chat-screen.dart';
import '../widget/staff_notes_only.dart';
import '../widget/staff_post_only.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.userId,this.isStaff=false });
final String userId;
final bool isStaff;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _headerText = "Following";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = true;
  String profileImage = "";
  // int postsCount = 0;

  void _followUser(String userId) async {
    try {
      await _firestore.collection(widget.isStaff ? "Staff" : 'users').doc(widget.userId).update({
        "following": FieldValue.arrayUnion([userId])
      });
      await _firestore.collection(widget.isStaff ? "Staff" : 'users').doc(userId).update({
        "followers": FieldValue.arrayUnion([widget.userId])
      });
    } catch (e) {
      print("Error following user: $e");
    }
  }

  void _unfollowUser(String userId) async {
    try {
      await _firestore.collection('users').doc(widget.userId).update({
        "following": FieldValue.arrayRemove([userId])
      });
      await _firestore.collection('users').doc(userId).update({
        "followers": FieldValue.arrayRemove([widget.userId])
      });
    } catch (e) {
      print("Error unfollowing user: $e");
    }
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(widget.isStaff ? "Staff" : 'users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<void> _startChat(String receiverId, String receiverName) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      String chatId = _generateChatId(currentUserId, receiverId);
      DocumentReference chatDoc = _firestore.collection('chats').doc(chatId);
      DocumentSnapshot chatSnapshot = await chatDoc.get();

      if (!chatSnapshot.exists) {
        await chatDoc.set({
          'users': [currentUserId, receiverId],
          'createdAt': FieldValue.serverTimestamp(),
          'lastMessage': '',
        });

        await _firestore.collection('users').doc(currentUserId).update({
          "chats": FieldValue.arrayUnion([chatId])
        });
        await _firestore.collection('users').doc(receiverId).update({
          "chats": FieldValue.arrayUnion([chatId])
        });
      }
    } catch (e) {
      print("Error starting chat: $e");
    }
  }

  String _generateChatId(String user1, String user2) {
    List<String> users = [user1, user2];
    users.sort();
    return users.join("_");
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _headerText = _tabController.index == 0 ? "Following" : "Follower";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: FutureBuilder(
          future: fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text("Error fetching data"));
            }

            final userData = snapshot.data!;
            int followersCount = (userData["followers"] as List<dynamic>?)?.length ?? 0;
            int followingCount = (userData["following"] as List<dynamic>?)?.length ?? 0;
            int postsCount = (userData["lostItems"] as List<dynamic>?)?.length ?? 0;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: profileImage.isNotEmpty
                              ? NetworkImage(profileImage)
                              : AssetImage(AppImages.profile) as ImageProvider,
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData['username'] ?? "",
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                _buildStatColumn(postsCount, "posts"),
                                SizedBox(width: 20),
                                _buildStatColumn(followersCount, "followers"),
                                SizedBox(width: 20),
                                _buildStatColumn(followingCount, "following"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButton(
                          text: _headerText,
                          onTap: () => _followUser(widget.userId),
                          width: 150,
                          isColorBlack: true,
                        ),
                        CustomButton(
                          text: "Message",
                          onTap: () async {
                            await _startChat(widget.userId, userData['username']);
                            nextScreen(
                              context,
                              ChatScreen(receiverId: widget.userId, userName: userData['username']),
                            );
                          },
                          width: 150,
                          isColorBlack: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    const TabBar(
                      labelColor: Colors.red,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.red,
                      tabs: [
                        Tab(text: "Club Post", icon: Icon(Icons.book)),
                        Tab(text: "L&F", icon: Icon(Icons.shopping_basket)),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          PersonalClubsAndPost(isStudent: false, userId: widget.userId),
                          PersonalMissingItemsPost(userId: widget.userId),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatColumn(int count, String label) {
    return Column(
      children: [
        Text(
          "$count",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(label),
      ],
    );
  }
}

//
// class _ProfilePageState extends State<ProfilePage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String _headerText = "Following";
//
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   // String? currentUserId = FirebaseAuth.instance.currentUser?.uid; // Replace with logged-in user's ID
//
//
//   bool isLoading = true;
//
//
//   String profileImage = "";
//   int postsCount = 0;
//
//
//
//
//   void _followUser(String userId) async {
//     try {
//       await _firestore.collection(widget.isStaff?"Staff":'users').doc(widget.userId).update({
//         "following": FieldValue.arrayUnion([userId])
//       });
//       await _firestore.collection(widget.isStaff?"Staff":'users').doc(userId).update({
//         "followers": FieldValue.arrayUnion([widget.userId])
//       });
//     } catch (e) {
//       print("Error following user: $e");
//     }
//   }
//
//   void _unfollowUser(String userId) async {
//     try {
//       await _firestore.collection('users').doc(widget.userId).update({
//         "following": FieldValue.arrayRemove([userId])
//       });
//       await _firestore.collection('users').doc(userId).update({
//         "followers": FieldValue.arrayRemove([widget.userId])
//       });
//     } catch (e) {
//       print("Error unfollowing user: $e");
//     }
//   }
//
//
//   Future<Map<String, dynamic>?> fetchUserData() async {
//     try {
//       // String userId = FirebaseAuth.instance.currentUser!.uid; // Dynamically get user ID
//
//       // String userId = widget.userId; // Dynamically get user ID
//
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection(widget.isStaff?"Staff":'users')
//           .doc(widget.userId)
//           .get();  // Use userId instead of hardcoded 'userId123'
//
//       if (userDoc.exists) {
//         return userDoc.data() as Map<String, dynamic>;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print("Error fetching user data: $e");
//       return null;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _headerText = _tabController.index == 0 ? "Following" : "Follower";
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("CURRENT USER NAMAE ${FirebaseAuth.instance.currentUser?.uid}");
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Profile"),
//         ),
//         body: FutureBuilder(
//           future: fetchUserData(),
//           builder: (context,snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError || !snapshot.hasData) {
//               return const Center(child: Text("Error fetching data"));
//             }
//
//             final userData = snapshot.data!;
//
//             // Get the number of followers and following from the data
//             int followersCount = (userData["followers"] as List<dynamic>?)?.length ?? 0;
//             int followingCount = (userData["following"] as List<dynamic>?)?.length ?? 0;
//
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         SizedBox(width: 10),
//                         Container(
//                           width: 90,
//                           height: 90,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: Colors.grey,
//                               width: 1,
//                             ),
//                           ),
//                           child: CircleAvatar(
//                             radius: 45,
//                             backgroundImage: profileImage.isNotEmpty
//                                 ? NetworkImage(profileImage)
//                                 : AssetImage(AppImages.profile) as ImageProvider,
//                           ),
//                         ),
//                         SizedBox(width: 20),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               userData['username']??"",
//                               style:
//                                   Theme.of(context).textTheme.displayMedium?.copyWith(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20,
//                                       ),
//                             ),
//                             SizedBox(height: 10),
//                             Row(
//                               children: [
//                                 _buildStatColumn(postsCount, "posts"),
//                                 SizedBox(width: 20),
//                                 _buildStatColumn(followersCount, "followers"),
//                                 SizedBox(width: 20),
//                                 _buildStatColumn(followingCount, "following"),
//                               ],
//                             ),
//
//
//                           ],
//                         ),
//                       ],
//                     ),
//
//                     SizedBox(height: 20,),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         CustomButton(text: "Follow", onTap: (){_followUser(widget.userId);},width: 150,isColorBlack: true,),
//                         CustomButton(text: "Message", onTap: (){nextScreen(context, ChatScreen(receiverId: widget.userId,userName: userData['username'],));},width: 150, isColorBlack: true,),
//                       ],
//                     ),
//
//
//                     SizedBox(height: 10,),
//                     const TabBar(
//                       labelColor: Colors.red,
//                       unselectedLabelColor: Colors.grey,
//                       indicatorColor: Colors.red,
//                       // dividerColor: Colors.transparent,
//                       tabs: [
//                         Tab(
//                           text: "Club Post",
//                           icon: Icon(Icons.book),
//                         ),
//                         Tab(
//                           text: "L&F",
//                           icon: Icon(Icons.shopping_basket),
//                         ),
//
//                       ],
//                     ),
//
//                     // Expanded TabBarView
//                     Expanded(
//                       child: TabBarView(
//                         children:  [
//                           PersonalClubsAndPost(isStudent: false,userId: widget.userId,),
//                           // Center(child: Text("Club Post")),
//                           PersonalMissingItemsPost(userId: widget.userId,)
//                           // LostAndFound()
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatColumn(int count, String label) {
//     return Column(
//       children: [
//         Text(
//           "$count",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         Text(label),
//       ],
//     );
//   }
// }
