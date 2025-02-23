import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/asset-paths.dart';

import '../../../../../util/next-screen.dart';
import '../../../../../util/widthandheight.dart';
import 'profile.dart';

class Following extends StatefulWidget {
  const Following({super.key});

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _headerText = "Following";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentUserId = "currentUserId"; // Replace with logged-in user's ID

  List<Map<String, dynamic>> filteredFollowersList = [];
  List<Map<String, dynamic>> filteredFollowingList = [];
  List<Map<String, dynamic>> suggestedUsersList = [];
  bool isLoading = true;

  Future<void> fetchFollowerList() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUserId).get();
      List<String> followingIds = List<String>.from(userDoc['following'] ?? []);
      List<String> followerIds = List<String>.from(userDoc['followers'] ?? []);

      QuerySnapshot? followingSnapshot;
      if (followingIds.isNotEmpty) {
        followingSnapshot = await _firestore
            .collection('users')
            .where(FieldPath.documentId, whereIn: followingIds)
            .get();
      }

      QuerySnapshot? followerSnapshot;
      if (followerIds.isNotEmpty) {
        followerSnapshot = await _firestore
            .collection('users')
            .where(FieldPath.documentId, whereIn: followerIds)
            .get();
      }

      QuerySnapshot suggestedSnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId,
              whereNotIn: [currentUserId, ...followingIds])
          .limit(5)
          .get();

      setState(() {
        filteredFollowingList = followingSnapshot != null
            ? followingSnapshot.docs.map((doc) {
                return {
                  'id': doc.id,
                  'username': doc['username'],
                  'email': doc['email'],
                } as Map<String, dynamic>;
              }).toList()
            : [];

        filteredFollowersList = followerSnapshot != null
            ? followerSnapshot.docs.map((doc) {
                return {
                  'id': doc.id,
                  'username': doc['username'],
                  'email': doc['email'],
                } as Map<String, dynamic>;
              }).toList()
            : [];

        suggestedUsersList = suggestedSnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'username': doc['username'],
            'email': doc['email'],
          } as Map<String, dynamic>;
        }).toList();

        isLoading = false;
      });
    } catch (e) {
      print("Error fetching followers: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFollowerList();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _headerText = _tabController.index == 0 ? "Following" : "Follower";
      });
    });
  }

  void _followUser(String userId) async {
    try {
      await _firestore.collection('users').doc(currentUserId).update({
        "following": FieldValue.arrayUnion([userId])
      });
      await _firestore.collection('users').doc(userId).update({
        "followers": FieldValue.arrayUnion([currentUserId])
      });
      fetchFollowerList();
    } catch (e) {
      print("Error following user: $e");
    }
  }

  void _unfollowUser(String userId) async {
    try {
      await _firestore.collection('users').doc(currentUserId).update({
        "following": FieldValue.arrayRemove([userId])
      });
      await _firestore.collection('users').doc(userId).update({
        "followers": FieldValue.arrayRemove([currentUserId])
      });
      fetchFollowerList();
    } catch (e) {
      print("Error unfollowing user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.red,
            tabs: [Tab(text: "Following"), Tab(text: "Follower")],
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      Column(
                        children: [
                          filteredFollowingList.isNotEmpty
                              ? Expanded(
                                  child: _buildUserList(
                                      filteredFollowingList, true))
                              : Center(
                                  child:
                                      Text("You're not following anyone yet.")),
                          Text("Suggested Users"),
                          Expanded(
                              child: _buildUserList(suggestedUsersList, false)),
                        ],
                      ),
                      _buildUserList(filteredFollowersList, false),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(List<Map<String, dynamic>> list, bool isFollowing) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final user = list[index];
        return _buildFollowerItem(user, isFollowing);
      },
    );
  }

  Widget _buildFollowerItem(Map<String, dynamic> item, bool isFollowing) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage(AppImages.profile),
      ),
      title: Text(item['username']!),
      subtitle: Text(isFollowing ? "Following" : "Suggested"),
      trailing: ElevatedButton(
        onPressed: () {
          isFollowing ? _unfollowUser(item['id']!) : _followUser(item['id']!);
        },
        child: Text(isFollowing ? 'Unfollow' : 'Follow'),
      ),
    );
  }
}


// class _FollowingState extends State<Following>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String _headerText = "Following";

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   List<Map<String, String>> filteredFollowersList = [];
//   List<Map<String, String>> filteredFollowingList = [];
//   bool isLoading = true; // Loading state

//   Future<void> fetchFollowerList() async {
//     setState(() {
//       isLoading = true; // Start loading
//     });

//     try {
//       QuerySnapshot snapshot = await _firestore.collection('users').get();

//       setState(() {
//         filteredFollowersList = snapshot.docs.map((doc) {
//           return {
//             'username': doc['username'] as String,
//             'email': doc['email'] as String,
//           };
//         }).toList();

//         filteredFollowingList = snapshot.docs.map((doc) {
//           return {
//             'username': doc['username'] as String,
//             'email': doc['email'] as String,
//           };
//         }).toList();

//         isLoading = false; // Stop loading
//       });
//     } catch (e) {
//       print("Error fetching followers: $e");
//       setState(() {
//         isLoading = false; // Stop loading on error
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchFollowerList(); // Fetch followers on init

//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _headerText = _tabController.index == 0 ? "Following" : "Follower";
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: SizedBox(
//         height: height(context),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TabBar(
//               controller: _tabController,
//               labelColor: Colors.red,
//               unselectedLabelColor: Colors.grey,
//               indicatorColor: Colors.red,
//               dividerColor: Colors.transparent,
//               tabs: [
//                 Tab(text: "Following"),
//                 Tab(text: "Follower"),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextField(
//                 onChanged: _filterList,
//                 decoration: InputDecoration(
//                   hintText: 'Search',
//                   hintStyle: Theme.of(context).textTheme.displaySmall,
//                   prefixIcon: Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//               ),
//             ),
//             Text(
//               _headerText,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyMedium!
//                   .copyWith(fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: isLoading
//                   ? Center(
//                       child:
//                           CircularProgressIndicator()) // Show loading spinner
//                   : TabBarView(
//                       controller: _tabController,
//                       children: [
//                         _buildUserList(filteredFollowingList, true),
//                         _buildUserList(filteredFollowersList, false),
//                       ],
//                     ),
//             ),
//             Text("Suggested for you"),
//             for (int i = 0; i < filteredFollowersList.length; i++)
//               _buildSuggestedUser(filteredFollowersList[i]),
//           ],
//         ),
//       ),
//     );
//   }

//   // Build the list of users
//   Widget _buildUserList(List<Map<String, String>> list, bool isFollowing) {
//     return ListView.builder(
//       itemCount: 2,
//       // itemCount: list.length,
//       itemBuilder: (context, index) {
//         final user = list[index];
//         return _buildFollowerItem(user, isFollowing);
//       },
//     );
//   }

//   // Build a follower item (both for Following and Follower)
//   Widget _buildFollowerItem(Map<String, String> item, bool isFollowing) {
//     return GestureDetector(
//       onTap: () {
//         nextScreen(context, ProfilePage());
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               ListTile(
//                 contentPadding: EdgeInsets.all(0),
//                 leading: CircleAvatar(
//                   radius: 30,
//                   backgroundImage: item['image'] != null
//                       ? NetworkImage(item['image']!)
//                       : AssetImage(AppImages.profile),
//                 ),
//                 title: Text(item['username']!),
//                 subtitle: Row(
//                   children: [
//                     // Text(item['level']!),
//                     Container(
//                       margin: EdgeInsets.only(left: 5, right: 5),
//                       width: 15,
//                       height: 15,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: Colors.black,
//                       ),
//                       child: Center(
//                         child: Icon(
//                           Icons.done,
//                           size: 12,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     Text(isFollowing ? "following" : "follower"),
//                   ],
//                 ),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     // Handle follow/unfollow logic based on the tab
//                     if (isFollowing) {
//                       _unfollowUser(item['email']!);
//                     } else {
//                       _followUser(item['email']!);
//                     }
//                   },
//                   child: Text(isFollowing ? 'Unfollow' : 'Follow'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Build a suggested user item with a follow button
//   Widget _buildSuggestedUser(Map<String, String> item) {
//     return GestureDetector(
//       onTap: () {
//         nextScreen(context, ProfilePage());
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               ListTile(
//                 trailing: Container(
//                   width: 60,
//                   height: 40,
//                   decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black, width: 1),
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Center(child: Text("Follow")),
//                 ),
//                 contentPadding: EdgeInsets.all(0),
//                 leading: CircleAvatar(
//                   radius: 30,
//                   backgroundImage: item['image'] != null
//                       ? NetworkImage(item['image']!)
//                       : AssetImage(AppImages.profile),
//                 ),
//                 title: Text(item['username']!),
//                 subtitle: Row(
//                   children: [
//                     // Text(item['level']!),
//                     Container(
//                       margin: EdgeInsets.only(left: 5, right: 5),
//                       width: 15,
//                       height: 15,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: Colors.black,
//                       ),
//                       child: Center(
//                         child: Icon(
//                           Icons.done,
//                           size: 12,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     Text("suggested"),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _followUser(String email) {
//     // Logic to follow the user
//     print("Following $email");
//   }

//   void _unfollowUser(String email) {
//     // Logic to unfollow the user
//     print("Unfollowing $email");
//   }

//   // Filter the followers and following lists based on search query
//   void _filterList(String query) {
//     setState(() {
//       filteredFollowersList = filteredFollowersList.where((follower) {
//         final nameLower = follower['username']!.toLowerCase();
//         final emailLower = follower['email']!.toLowerCase();
//         // final levelLower = follower['level']!.toLowerCase();
//         final searchLower = query.toLowerCase();
//         return nameLower.contains(searchLower) ||
//             emailLower.contains(searchLower);
//         //  ||
//         // levelLower.contains(searchLower);
//       }).toList();

//       filteredFollowingList = filteredFollowingList.where((follower) {
//         final nameLower = follower['username']!.toLowerCase();
//         final emailLower = follower['email']!.toLowerCase();
//         // final levelLower = follower['level']!.toLowerCase();
//         final searchLower = query.toLowerCase();
//         return nameLower.contains(searchLower) ||
//             emailLower.contains(searchLower);
//         // ||
//         // levelLower.contains(searchLower);
//       }).toList();
//     });
//   }
// }


// class _FollowingState extends State<Following>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String _headerText = "Following";

//   // Define the Firebase Firestore instance
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Lists to hold the filtered data
//   List<Map<String, String>> filteredFollowersList = [];
//   List<Map<String, String>> filteredFollowingList = [];

//   Future<void> fetchFollowerList() async {
//     try {
//       // Fetch the followers list from Firestore
//       QuerySnapshot snapshot = await _firestore.collection('users').get();

//       // Map the snapshot data to a list of users
//       setState(() {
//         filteredFollowersList = snapshot.docs.map((doc) {
//           // Casting the fields to String
//           print("USERS");
//           print(doc['username']);
//           print(doc['email']);
//           // print(doc['username']);
//           return {
//             'username': doc['username'] as String, // Explicit casting to String
//             'email': doc['email'] as String, // Explicit casting to String
//             // 'image': doc['image'] as String, // Explicit casting to String
//             // 'level': doc['level'] as String, // Explicit casting to String
//           };
//         }).toList();

//         // Assuming the following list is stored similarly
//         filteredFollowingList = snapshot.docs.map((doc) {
//           // Casting the fields to String
//           return {
//             'username': doc['username'] as String, // Explicit casting to String
//             'email': doc['email'] as String, // Explicit casting to String
//             // 'image': doc['image'] as String, // Explicit casting to String
//             // 'level': doc['level'] as String, // Explicit casting to String
//           };
//         }).toList();
//       });
//     } catch (e) {
//       print("Error fetching followers: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Fetch followers data when the widget is initialized
//     fetchFollowerList();

//     // Initialize TabController
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _headerText = _tabController.index == 0 ? "Following" : "Follower";
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

  // // Filter the followers and following lists based on search query
  // void _filterList(String query) {
  //   setState(() {
  //     filteredFollowersList = filteredFollowersList.where((follower) {
  //       final nameLower = follower['username']!.toLowerCase();
  //       final emailLower = follower['email']!.toLowerCase();
  //       // final levelLower = follower['level']!.toLowerCase();
  //       final searchLower = query.toLowerCase();
  //       return nameLower.contains(searchLower) ||
  //           emailLower.contains(searchLower);
  //       //  ||
  //       // levelLower.contains(searchLower);
  //     }).toList();

  //     filteredFollowingList = filteredFollowingList.where((follower) {
  //       final nameLower = follower['username']!.toLowerCase();
  //       final emailLower = follower['email']!.toLowerCase();
  //       // final levelLower = follower['level']!.toLowerCase();
  //       final searchLower = query.toLowerCase();
  //       return nameLower.contains(searchLower) ||
  //           emailLower.contains(searchLower);
  //       // ||
  //       // levelLower.contains(searchLower);
  //     }).toList();
  //   });
  // }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: SizedBox(
//         height: height(context),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TabBar(
//               controller: _tabController,
//               labelColor: Colors.red,
//               unselectedLabelColor: Colors.grey,
//               indicatorColor: Colors.red,
//               dividerColor: Colors.transparent,
//               tabs: [
//                 Tab(text: "Following"),
//                 Tab(text: "Follower"),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextField(
//                 onChanged: _filterList,
//                 decoration: InputDecoration(
//                   hintText: 'Search',
//                   hintStyle: Theme.of(context).textTheme.displaySmall,
//                   prefixIcon: Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//               ),
//             ),
//             Text(
//               _headerText,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyMedium!
//                   .copyWith(fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   // Tab 1 - Following
//                   _buildUserList(filteredFollowingList, true),

//                   // Tab 2 - Followers
//                   _buildUserList(filteredFollowersList, false),
//                 ],
//               ),
//             ),
            // Text("Suggested for you"),
            // for (int i = 0; i < filteredFollowersList.length; i++)
            //   _buildSuggestedUser(filteredFollowersList[i]),
//           ],
//         ),
//       ),
//     );
//   }

  // // Build the list of users
  // Widget _buildUserList(List<Map<String, String>> list, bool isFollowing) {
  //   return ListView.builder(
  //     itemCount: 2,
  //     // itemCount: list.length,
  //     itemBuilder: (context, index) {
  //       final user = list[index];
  //       return _buildFollowerItem(user, isFollowing);
  //     },
  //   );
  // }

  // // Build a follower item (both for Following and Follower)
  // Widget _buildFollowerItem(Map<String, String> item, bool isFollowing) {
  //   return GestureDetector(
  //     onTap: () {
  //       nextScreen(context, ProfilePage());
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(vertical: 10),
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Column(
  //           children: [
  //             ListTile(
  //               contentPadding: EdgeInsets.all(0),
  //               leading: CircleAvatar(
  //                 radius: 30,
  //                 backgroundImage: item['image'] != null
  //                     ? NetworkImage(item['image']!)
  //                     : AssetImage(AppImages.profile),
  //               ),
  //               title: Text(item['username']!),
  //               subtitle: Row(
  //                 children: [
  //                   // Text(item['level']!),
  //                   Container(
  //                     margin: EdgeInsets.only(left: 5, right: 5),
  //                     width: 15,
  //                     height: 15,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(15),
  //                       color: Colors.black,
  //                     ),
  //                     child: Center(
  //                       child: Icon(
  //                         Icons.done,
  //                         size: 12,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                   Text(isFollowing ? "following" : "follower"),
  //                 ],
  //               ),
  //               trailing: ElevatedButton(
  //                 onPressed: () {
  //                   // Handle follow/unfollow logic based on the tab
  //                   if (isFollowing) {
  //                     _unfollowUser(item['email']!);
  //                   } else {
  //                     _followUser(item['email']!);
  //                   }
  //                 },
  //                 child: Text(isFollowing ? 'Unfollow' : 'Follow'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // // Build a suggested user item with a follow button
  // Widget _buildSuggestedUser(Map<String, String> item) {
  //   return GestureDetector(
  //     onTap: () {
  //       nextScreen(context, ProfilePage());
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(vertical: 10),
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Column(
  //           children: [
  //             ListTile(
  //               trailing: Container(
  //                 width: 60,
  //                 height: 40,
  //                 decoration: BoxDecoration(
  //                     border: Border.all(color: Colors.black, width: 1),
  //                     borderRadius: BorderRadius.circular(10)),
  //                 child: Center(child: Text("Follow")),
  //               ),
  //               contentPadding: EdgeInsets.all(0),
  //               leading: CircleAvatar(
  //                 radius: 30,
  //                 backgroundImage: item['image'] != null
  //                     ? NetworkImage(item['image']!)
  //                     : AssetImage(AppImages.profile),
  //               ),
  //               title: Text(item['username']!),
  //               subtitle: Row(
  //                 children: [
  //                   // Text(item['level']!),
  //                   Container(
  //                     margin: EdgeInsets.only(left: 5, right: 5),
  //                     width: 15,
  //                     height: 15,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(15),
  //                       color: Colors.black,
  //                     ),
  //                     child: Center(
  //                       child: Icon(
  //                         Icons.done,
  //                         size: 12,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                   Text("suggested"),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

//   // Mock functions to handle follow/unfollow
//   void _followUser(String email) {
//     // Logic to follow the user
//     print("Following $email");
//   }

//   void _unfollowUser(String email) {
//     // Logic to unfollow the user
//     print("Unfollowing $email");
//   }
// }



/*
import 'package:flutter/material.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../util/next-screen.dart';
import '../../../../../util/widthandheight.dart';
import 'profile.dart';

class Following extends StatefulWidget {
  const Following({super.key});

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _headerText = "Following";

  @override
  void initState() {
    super.initState();
    filteredFollowersList = followerList;
    filteredFollowingList = followerList;

    // Initialize TabController
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _headerText = _tabController.index == 0 ? "Following" : "Follower";
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _filterList(String query) {
    setState(() {
      filteredFollowersList = followerList.where((follower) {
        final nameLower = follower['name']!.toLowerCase();
        final emailLower = follower['email']!.toLowerCase();
        final levelLower = follower['level']!.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) ||
            emailLower.contains(searchLower) ||
            levelLower.contains(searchLower);
      }).toList();

      filteredFollowingList = followerList.where((follower) {
        final nameLower = follower['name']!.toLowerCase();
        final emailLower = follower['email']!.toLowerCase();
        final levelLower = follower['level']!.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) ||
            emailLower.contains(searchLower) ||
            levelLower.contains(searchLower);
      }).toList();
    });
  }

  final List<Map<String, String>> followerList = [
    {
      'name': 'Haythem Othman Ismail',
      'email': 'haythem.ismail@guc.edu.eg',
      'image': 'https://randomuser.me/api/portraits/men/1.jpg',
      'level': "300"
    },
    {
      'name': 'Mervat Abouelkhier',
      'email': 'mervat.abouelkhier@guc.edu.eg',
      'image': 'https://randomuser.me/api/portraits/men/4.jpg',
      'level': "400"
    },
    {
      'name': 'Milad Ghantous',
      'email': 'milad.ghantous@guc.edu.eg',
      'image': 'https://randomuser.me/api/portraits/men/2.jpg',
      'level': "200"
    },
    {
      'name': 'Wael Abouelsadaat',
      'email': 'wael.abosadaat@guc.edu.eg',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
      'level': "300"
    },
  ];

  List<Map<String, String>> filteredFollowersList = [];
  List<Map<String, String>> filteredFollowingList = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SizedBox(
        height: height(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.red,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: "Following"),
                Tab(text: "Follower"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: _filterList,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: Theme.of(context).textTheme.displaySmall,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Text(
              _headerText,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                   for (int i = 0; i < filteredFollowersList.length-2; i++)

              SizedBox(
                height: height(context)/9,
                child: follower(name: filteredFollowersList[i]['name']??"",level:filteredFollowersList[i]['level']??"",img: filteredFollowersList[i]['image']??"" )),
                  // follower(filteredFollowersList),

                  for (int i = 0; i < filteredFollowersList.length-2; i++)
              SizedBox(
                height: height(context)/9,
                child: Column(
                  children: [
                    following(name: filteredFollowersList[i]['name']??"",level:filteredFollowersList[i]['level']??"",img: filteredFollowersList[i]['image']??"" ),
                  ],
                ))
                ],
              ),
            ),
            Text("Suggested for you"),
            for (int i = 0; i < filteredFollowersList.length-3; i++)

              suggestions(name: filteredFollowersList[i]['name']??"",level:filteredFollowersList[i]['level']??"",img: filteredFollowersList[i]['image']??"" )
          ],
        ),
      ),
    );
  }

  Widget follower({required String name, required String img, required String level}) {
    return  GestureDetector(
              onTap: () {
                nextScreen(context, ProfilePage());
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(img),
                        ),
                        title: Text(name),
                        subtitle: Row(
                          children: [
                            Text(level),
                            Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.done,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text("following"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
       
    
  }

  Widget following({required String name, required String img, required String level}) {
    return follower(name: name,img: img,level: level);
  }

  Widget suggestions(
      {required String name, required String img, required String level}) {
    return GestureDetector(
        onTap: () {
          nextScreen(context, ProfilePage());
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  trailing: Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text("Follow")),
                  ),
                  contentPadding: EdgeInsets.all(0),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(img),
                  ),
                  title: Text(name),
                  subtitle: Row(
                    children: [
                      Text(level),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.done,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text("following"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
*/
// import 'package:flutter/material.dart';

// import '../../../../../core/constants/asset-paths.dart';
// import '../../../../../util/next-screen.dart';
// import '../../../../../util/widthandheight.dart';
// import 'profile.dart';

// class Following extends StatefulWidget {
//   const Following({super.key});

//   @override
//   State<Following> createState() => _FollowingState();
// }

// class _FollowingState extends State<Following> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String _headerText = "Following";

//   @override
//   void initState() {
//     super.initState();
//     filteredFollowersList = followerList;
//     filteredFollowingList = followerList;
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(_handleTabChange);
//   }

//   @override
//   void dispose() {
//     _tabController.removeListener(_handleTabChange);
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _handleTabChange() {
//     if (_tabController.indexIsChanging || _tabController.index != _tabController.previousIndex) {
//       setState(() {
//         _headerText = _tabController.index == 0 ? "Following" : "Follower";
//       });
//     }
//   }

//   void _filterList(String query) {
//     setState(() {
//       filteredFollowersList = followerList.where((follower) {
//         final nameLower = follower['name']!.toLowerCase();
//         final searchLower = query.toLowerCase();
//         return nameLower.contains(searchLower);
//       }).toList();

//       filteredFollowingList = followerList.where((follower) {
//         final nameLower = follower['name']!.toLowerCase();
//         final searchLower = query.toLowerCase();
//         return nameLower.contains(searchLower);
//       }).toList();
//     });
//   }

//   final List<Map<String, String>> followerList = [
//     {
//       'name': 'Haythem Othman Ismail',
//       'email': 'haythem.ismail@guc.edu.eg',
//       'image': 'https://randomuser.me/api/portraits/men/1.jpg',
//       'level': "300"
//     },
//     {
//       'name': 'Mervat Abouelkhier',
//       'email': 'mervat.abouelkhier@guc.edu.eg',
//       'image': 'https://randomuser.me/api/portraits/men/4.jpg',
//       'level': "400"
//     },
//     {
//       'name': 'Milad Ghantous',
//       'email': 'milad.ghantous@guc.edu.eg',
//       'image': 'https://randomuser.me/api/portraits/men/2.jpg',
//       'level': "200"
//     },
//     {
//       'name': 'Wael Abouelsadaat',
//       'email': 'wael.abosadaat@guc.edu.eg',
//       'image': 'https://randomuser.me/api/portraits/men/3.jpg',
//       'level': "300"
//     },
//   ];

//   List<Map<String, String>> filteredFollowersList = [];
//   List<Map<String, String>> filteredFollowingList = [];

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: SizedBox(
//         height: height(context),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TabBar(
//               controller: _tabController,
//               labelColor: Colors.red,
//               unselectedLabelColor: Colors.grey,
//               indicatorColor: Colors.red,
//               dividerColor: Colors.transparent,
//               tabs: const [
//                 Tab(text: "Following"),
//                 Tab(text: "Follower"),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextField(
//                 onChanged: _filterList,
//                 decoration: InputDecoration(
//                   hintText: 'Search',
//                   hintStyle: Theme.of(context).textTheme.displaySmall,
//                   prefixIcon: Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//               ),
//             ),
//             Text(
//               _headerText,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyMedium!
//                   .copyWith(fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   _buildTabContent(filteredFollowingList),
//                   _buildTabContent(filteredFollowersList),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTabContent(List<Map<String, String>> list) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Text("Your Followers", style: Theme.of(context).textTheme.titleLarge),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: list.length,
//             itemBuilder: (context, index) {
//               return _buildFollowerItem(list[index]);
//             },
//           ),
//           SizedBox(height: 20),
//           Text("Suggestions for You", style: Theme.of(context).textTheme.displayMedium),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: list.length,
//             itemBuilder: (context, index) {
//               return _buildSuggestionItem(list[index]);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFollowerItem(Map<String, String> item) {
//     return ListTile(
//       leading: CircleAvatar(
//         radius: 30,
//         backgroundImage: NetworkImage(item['image']!),
//       ),
//       title: Text(item['name']!),
//       subtitle: Text(item['level']!),
//     );
//   }

//   Widget _buildSuggestionItem(Map<String, String> item) {
//     return ListTile(
//       leading: CircleAvatar(
//         radius: 30,
//         backgroundImage: NetworkImage(item['image']!),
//       ),
//       title: Text(item['name']!),
//       subtitle: Text(item['level']!),
//       trailing: ElevatedButton(
//         onPressed: () {},
//         child: Text("Follow"),
//       ),
//     );
//   }
// }


/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Following extends StatefulWidget {
  const Following({super.key});

  @override
  State<Following> createState() => _FollowingState();
}
class _FollowingState extends State<Following> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _headerText = "Following";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, String>> filteredFollowersList = [];
  List<Map<String, String>> filteredFollowingList = [];
  List<Map<String, String>> allUsersList = [];
  List<Map<String, String>> filteredAllUsersList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging || _tabController.index != _tabController.previousIndex) {
      setState(() {
        _headerText = _tabController.index == 0 ? "Following" : "Followers";
      });
    }
  }

  // Load user followers, following, and all users from Firestore
  Future<void> _loadUserData() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      // Fetch current user's data
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(currentUser.uid).get();
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

      // Get followers and following from current user's data
      setState(() {
        filteredFollowersList = userData['followers']
            .map<Map<String, String>>((e) => {
                  'name': e['name'],
                  'image': e['image'],
                  'level': e['level'],
                  'id': e['id'],
                })
            .toList();
        filteredFollowingList = userData['following']
            .map<Map<String, String>>((e) => {
                  'name': e['name'],
                  'image': e['image'],
                  'level': e['level'],
                  'id': e['id'],
                })
            .toList();
      });

      // Get all users from the users collection
      QuerySnapshot allUsersSnapshot = await _firestore.collection('users').get();
      setState(() {
        allUsersList = allUsersSnapshot.docs
            .where((doc) => doc.id != currentUser.uid)  // Exclude the current user
            .map((doc) => {
                  'name': doc['name'] as String,
                  'image': doc['image'] as String,
                  'level': doc['level'] as String,
                  'id': doc.id,
                })
            .toList();
        filteredAllUsersList = List.from(allUsersList); // Initialize filtered list
      });
    }
  }

  void _filterList(String query) {
    setState(() {
      filteredFollowersList = filteredFollowersList.where((follower) {
        final nameLower = follower['name']!.toLowerCase();
        return nameLower.contains(query.toLowerCase());
      }).toList();

      filteredFollowingList = filteredFollowingList.where((follower) {
        final nameLower = follower['name']!.toLowerCase();
        return nameLower.contains(query.toLowerCase());
      }).toList();

      filteredAllUsersList = allUsersList.where((user) {
        final nameLower = user['name']!.toLowerCase();
        return nameLower.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _followUser(String userId) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userRef = _firestore.collection('users').doc(currentUser.uid);
      final targetUserRef = _firestore.collection('users').doc(userId);

      // Add user to the following list and add current user to followers list
      await userRef.update({
        'following': FieldValue.arrayUnion([userId]),
      });
      await targetUserRef.update({
        'followers': FieldValue.arrayUnion([currentUser.uid]),
      });

      _loadUserData(); // Reload the data after following
    }
  }

  Future<void> _unfollowUser(String userId) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userRef = _firestore.collection('users').doc(currentUser.uid);
      final targetUserRef = _firestore.collection('users').doc(userId);

      // Remove user from the following list and remove current user from followers list
      await userRef.update({
        'following': FieldValue.arrayRemove([userId]),
      });
      await targetUserRef.update({
        'followers': FieldValue.arrayRemove([currentUser.uid]),
      });

      _loadUserData(); // Reload the data after unfollowing
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.red,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: "Following"),
                Tab(text: "Followers"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: _filterList,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: Theme.of(context).textTheme.displayMedium,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1 - Following
                  Column(
                    children: [
                      _buildTabContent(filteredFollowingList, true), // Show following list
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Follow New Users",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                      _buildTabContent(filteredAllUsersList, false), // List of users to follow
                    ],
                  ),
                  // Tab 2 - Followers
                  _buildTabContent(filteredFollowersList, false), // Show followers list
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(List<Map<String, String>> list, bool isFollowing) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: list.map((item) {
            return _buildFollowerItem(item, isFollowing);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFollowerItem(Map<String, String> item, bool isFollowing) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(item['image']!),
      ),
      title: Text(item['name']!),
      subtitle: Text(item['level']!),
      trailing: ElevatedButton(
        onPressed: () {
          if (isFollowing) {
            _unfollowUser(item['id']!); // Unfollow if it's in the following list
          } else {
            _followUser(item['id']!); // Follow if it's in the new users list
          }
        },
        child: Text(isFollowing ? 'Unfollow' : 'Follow'),
      ),
    );
  }
}

*/

// class _FollowingState extends State<Following> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String _headerText = "Following";
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
  
//   List<Map<String, String>> filteredFollowersList = [];
//   List<Map<String, String>> filteredFollowingList = [];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(_handleTabChange);
//     _loadUserData();
//   }

//   @override
//   void dispose() {
//     _tabController.removeListener(_handleTabChange);
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _handleTabChange() {
//     if (_tabController.indexIsChanging || _tabController.index != _tabController.previousIndex) {
//       setState(() {
//         _headerText = _tabController.index == 0 ? "Following" : "Follower";
//       });
//     }
//   }

//   // Load user followers and following from Firestore
//   Future<void> _loadUserData() async {
//     final currentUser = _auth.currentUser;
//     if (currentUser != null) {
//       DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(currentUser.uid).get();
//       Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
//       setState(() {
//         filteredFollowersList = userData['followers'].map((e) => {'name': e['name'], 'image': e['image'], 'level': e['level']}).toList();
//         filteredFollowingList = userData['following'].map((e) => {'name': e['name'], 'image': e['image'], 'level': e['level']}).toList();
//       });
//     }
//   }

//   void _filterList(String query) {
//     setState(() {
//       filteredFollowersList = filteredFollowersList.where((follower) {
//         final nameLower = follower['name']!.toLowerCase();
//         return nameLower.contains(query.toLowerCase());
//       }).toList();

//       filteredFollowingList = filteredFollowingList.where((follower) {
//         final nameLower = follower['name']!.toLowerCase();
//         return nameLower.contains(query.toLowerCase());
//       }).toList();
//     });
//   }

//   Future<void> _followUser(String userId) async {
//     final currentUser = _auth.currentUser;
//     if (currentUser != null) {
//       final userRef = _firestore.collection('users').doc(currentUser.uid);
//       final targetUserRef = _firestore.collection('users').doc(userId);

//       // Add user to the following list and add current user to followers list
//       await userRef.update({
//         'following': FieldValue.arrayUnion([userId]),
//       });
//       await targetUserRef.update({
//         'followers': FieldValue.arrayUnion([currentUser.uid]),
//       });

//       _loadUserData();
//     }
//   }

//   Future<void> _unfollowUser(String userId) async {
//     final currentUser = _auth.currentUser;
//     if (currentUser != null) {
//       final userRef = _firestore.collection('users').doc(currentUser.uid);
//       final targetUserRef = _firestore.collection('users').doc(userId);

//       // Remove user from the following list and remove current user from followers list
//       await userRef.update({
//         'following': FieldValue.arrayRemove([userId]),
//       });
//       await targetUserRef.update({
//         'followers': FieldValue.arrayRemove([currentUser.uid]),
//       });

//       _loadUserData();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TabBar(
//               controller: _tabController,
//               labelColor: Colors.red,
//               unselectedLabelColor: Colors.grey,
//               indicatorColor: Colors.red,
//               dividerColor: Colors.transparent,
//               tabs: const [
//                 Tab(text: "Following"),
//                 Tab(text: "Follower"),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextField(
//                 onChanged: _filterList,
//                 decoration: InputDecoration(
//                   hintText: 'Search',
//                   hintStyle: Theme.of(context).textTheme.displayMedium,
//                   prefixIcon: Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//               ),
//             ),
//             Text(
//               _headerText,
//               style: Theme.of(context)
//                   .textTheme
//                   .displayMedium!
//                   .copyWith(fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   _buildTabContent(filteredFollowingList),
//                   _buildTabContent(filteredFollowersList),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTabContent(List<Map<String, String>> list) {
//     return SingleChildScrollView(
//       child: Column(
//         children: list.map((item) {
//           return _buildFollowerItem(item);
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildFollowerItem(Map<String, String> item) {
//     return ListTile(
//       leading: CircleAvatar(
//         radius: 30,
//         backgroundImage: NetworkImage(item['image']!),
//       ),
//       title: Text(item['name']!),
//       subtitle: Text(item['level']!),
//       trailing: ElevatedButton(
//         onPressed: () {
//           // Follow or unfollow logic based on current status
//           _followUser(item['id']!);  // Pass user ID
//         },
//         child: Text('Follow'),
//       ),
//     );
//   }
// }
