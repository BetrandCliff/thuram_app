//   import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String? currentUserId = FirebaseAuth.instance.currentUser?.uid;


//   Future<void> fetchFollowerList() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       // Fetch the current user document
//       DocumentSnapshot userDoc =
//           await _firestore.collection('users').doc(currentUserId).get();

//       if (!userDoc.exists) {
//         print("User document does not exist");
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }

//       // Convert Firestore data to a map and handle missing fields
//       Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
//       List<String> followingIds =
//           List<String>.from(userData['following'] ?? []);
//       List<String> followerIds = List<String>.from(userData['follower'] ?? []);

//       // Fetch following users (if any)
//       List<Map<String, dynamic>> followingList = [];
//       if (followingIds.isNotEmpty) {
//         QuerySnapshot followingSnapshot = await _firestore
//             .collection('users')
//             .where(FieldPath.documentId, whereIn: followingIds)
//             .get();

//         followingList = followingSnapshot.docs.map((doc) {
//           return {
//             'id': doc.id,
//             'username': doc['username'],
//             'email': doc['email'],
//           };
//         }).toList();
//       }

//       // Fetch follower users (if any)
//       List<Map<String, dynamic>> followerList = [];
//       if (followerIds.isNotEmpty) {
//         QuerySnapshot followerSnapshot = await _firestore
//             .collection('users')
//             .where(FieldPath.documentId, whereIn: followerIds)
//             .get();

//         followerList = followerSnapshot.docs.map((doc) {
//           return {
//             'id': doc.id,
//             'username': doc['username'],
//             'email': doc['email'],
//           };
//         }).toList();
//       }

//       // Fetch suggested users (users not followed by the current user)
//       List<Map<String, dynamic>> suggestedUsers = [];
//       QuerySnapshot suggestedSnapshot = await _firestore
//           .collection('users')
//           .where(FieldPath.documentId, whereNotIn: [
//             currentUserId,
//             ...followingIds
//           ]) // Exclude current user and those already followed
//           .limit(5)
//           .get();

//       suggestedUsers = suggestedSnapshot.docs.map((doc) {
//         return {
//           'id': doc.id,
//           'username': doc['username'],
//           'email': doc['email'],
//         };
//       }).toList();

//       // Update state
//       setState(() {
//         filteredFollowingList = followingList;
//         filteredFollowersList = followerList;
//         suggestedUsersList = suggestedUsers;
//         isLoading = false;
//       });

//       print("Suggested Users Count: ${suggestedUsersList.length}");
//     } catch (e) {
//       print("Error fetching followers: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

  
//   @override
//   void initState() {
//     super.initState();
//     fetchFollowerList();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _headerText = _tabController.index == 0 ? "Following" : "Follower";
//       });
//     });
//   }

//   void _followUser(String userId) async {
//     try {
//       await _firestore.collection('users').doc(currentUserId).update({
//         "following": FieldValue.arrayUnion([userId])
//       });
//       await _firestore.collection('users').doc(userId).update({
//         "followers": FieldValue.arrayUnion([currentUserId])
//       });
//       fetchFollowerList();
//     } catch (e) {
//       print("Error following user: $e");
//     }
//   }

//   void _unfollowUser(String userId) async {
//     try {
//       await _firestore.collection('users').doc(currentUserId).update({
//         "following": FieldValue.arrayRemove([userId])
//       });
//       await _firestore.collection('users').doc(userId).update({
//         "followers": FieldValue.arrayRemove([currentUserId])
//       });
//       fetchFollowerList();
//     } catch (e) {
//       print("Error unfollowing user: $e");
//     }
//   }