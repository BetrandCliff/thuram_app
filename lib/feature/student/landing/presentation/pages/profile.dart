import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/util/custom-button.dart';
import 'package:thuram_app/util/next-screen.dart';
import 'package:thuram_app/util/widthandheight.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../chat/chat-screen.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Profile"),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             // crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Row(
//                 children: [
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Container(
//                     width: 90, // Diameter of the CircleAvatar (2 * radius)
//                     height: 90,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: AppColors.secondaryColor, // Border color
//                         width: 1, // Border width
//                       ),
//                     ),
//                     child: CircleAvatar(
//                       radius: 45,
//                       backgroundImage:
//                           AssetImage(AppImages.equation) as ImageProvider,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Daily Mail",
//                         style: Theme.of(context)
//                             .textTheme
//                             .displayMedium!
//                             .copyWith(
//                                 fontWeight: FontWeight.bold, fontSize: 20),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         children: [
//                           Column(
//                             children: [
//                               Text(
//                                 "15.6K",
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .displayMedium!
//                                     .copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 "posts",
//                                 style: Theme.of(context).textTheme.displaySmall,
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Column(
//                             children: [
//                               Text(
//                                 "3.3M",
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .displayMedium!
//                                     .copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 "followers",
//                                 style: Theme.of(context).textTheme.displaySmall,
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Column(
//                             children: [
//                               Text(
//                                 "15.6K",
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .displayMedium!
//                                     .copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 "following",
//                                 style: Theme.of(context).textTheme.displaySmall,
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               SizedBox(
//                 width: width(context),
//                 child: Row(
//                   children: [
//                     Container(
//                       height: 50,
//                       width: width(context) / 2 - 10,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           color: Colors.black,
//                           border: Border.all(width: 2, color: Colors.white)),
//                       child: Center(
//                           child: Text(
//                         "Following",
//                         style: Theme.of(context)
//                             .textTheme
//                             .displayMedium!
//                             .copyWith(color: Colors.white),
//                       )),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         nextScreen(
//                             context,
//                             ChatScreen(
//                               receiverId: '5Mxd5oittENenIKHinmhvskxDaG3',
//                             ));
//                       },
//                       child: Container(
//                         height: 50,
//                         width: width(context) / 2 - 10,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             color: Colors.black,
//                             border: Border.all(width: 2, color: Colors.white)),
//                         child: Center(
//                             child: Text(
//                           "Message",
//                           style: Theme.of(context)
//                               .textTheme
//                               .displayMedium!
//                               .copyWith(color: Colors.white),
//                         )),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _headerText = "Following";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentUserId = "currentUserId"; // Replace with logged-in user's ID

  List<Map<String, dynamic>> filteredFollowersList = [];
  List<Map<String, dynamic>> filteredFollowingList = [];
  List<Map<String, dynamic>> suggestedUsersList = [];
  bool isLoading = true;

  String username = "";
  String profileImage = "";
  int postsCount = 0;
  int followersCount = 0;
  int followingCount = 0;

  Future<void> fetchFollowerList() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUserId).get();
      List<String> followingIds = List<String>.from(userDoc['following'] ?? []);
      List<String> followerIds = List<String>.from(userDoc['followers'] ?? []);

      username = userDoc['username'] ?? "";
      profileImage = userDoc['profileImage'] ?? "";
      postsCount = userDoc['postsCount'] ?? 0;
      followersCount = followerIds.length;
      followingCount = followingIds.length;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: profileImage.isNotEmpty
                          ? NetworkImage(profileImage)
                          : AssetImage(AppImages.profile) as ImageProvider,
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
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
            ],
          ),
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
