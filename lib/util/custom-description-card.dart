import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/util/widthandheight.dart';
import '../core/constants/asset-paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDescriptionCard extends StatelessWidget {
  const CustomDescriptionCard({super.key, this.isLecturer = false});
  final bool isLecturer;
  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      String userId =
          FirebaseAuth.instance.currentUser!.uid; // Dynamically get user ID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get(); // Use userId instead of hardcoded 'userId123'

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

  Future<Map<String, dynamic>?> fetchUserCourse() async {
    try {
      String userId =
          FirebaseAuth.instance.currentUser!.uid; // Dynamically get user ID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get(); // Use userId instead of hardcoded 'userId123'

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: FutureBuilder<Map<String, dynamic>?>(
          future: fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text("Error fetching data"));
            }
      
            final userData = snapshot.data!;
      
            // Get the number of followers and following from the data
            int followersCount =
                (userData["followers"] as List<dynamic>?)?.length ?? 0;
            int followingCount =
                (userData["following"] as List<dynamic>?)?.length ?? 0;
            int postsCount =
                (userData["following"] as List<dynamic>?)?.length ?? 0;
            int courseCount = (userData["course"] as List<dynamic>?)?.length ?? 0;
      
            return Column(
              children: [
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 100,
                      maxWidth: 600,
                    ),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Row
                            Row(
                              children: [
                                // Profile Image
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 10,
                                        spreadRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: userData["profilePic"] != null
                                        ? Image.file(
                                            File(userData["profilePic"]),
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                AppImages
                                                    .profile, // Replace with the path to your default image asset
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          )
                                        : Image.asset(
                                            AppImages
                                                .profile, // Default image if no profile image is found
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 20), // Spacing
                                // Name and Post Count
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          userData["username"] ?? "Unknown User",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(fontSize: 20),
                                        ),
                                        if (isLecturer)
                                          SizedBox(
                                            width: 4,
                                          ),
                                        if (isLecturer)
                                          Container(
                                              height: 20,
                                              width: 20,
                                              child: Icon(
                                                Icons.done,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.blue))
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                     Text(
                            "${userData["email"] ?? ""}",
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontSize: 14,
                                ),
                          ),
                                  ],
                                ),
                              ],
                            ),
                          
                            const SizedBox(height: 16), // Spacing
                            // Posts, Courses, Followers, Following
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // _ActivityCard(
                                //     "Posts", userData["posts"]?.toString() ?? "0"),
                                // _ActivityCard("Courses",
                                //     userData["courses"]?.toString() ?? "0"),
                                _ActivityCard("Posts", followersCount.toString()),
                                 _ActivityCard("Followers", followersCount.toString()),
                                _ActivityCard("Following", followingCount.toString()),
                              ],
                            ),
                           
                             SizedBox(height: 10),
                          SizedBox(
                            width: width(context),
                
                            child: const TabBar(
                              dividerHeight: 0,
                              
                              labelColor: Colors.red,
                              // unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.red,
                              tabs: [
                                Tab(text: "Club Post", icon: Icon(Icons.book)),
                                Tab(text: "L&F", icon: Icon(Icons.shopping_basket)),
                              ],
                            ),
                          ),
                          
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                 const SizedBox(height: 26), // Spacing
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                              child: TabBarView(
                                children: [
                                  Text("Item 1"),
                                   Text("Item 2"),
                                ],
                              ),
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _ActivityCard(String title, String count) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
