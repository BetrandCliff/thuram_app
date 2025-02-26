
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/asset-paths.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/values.dart';



class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 100,
            maxWidth: 600, 
          ),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonBorderRadius),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(
                        'users') // Assuming your users are stored in the "users" collection
                    .doc(FirebaseAuth.instance.currentUser
                        ?.uid) // Get current user's document
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator()); // Loading state
                  }

                  var userData = snapshot.data!.data() as Map<String, dynamic>;

                  // Get user details from the fetched data
                  String profilePic = userData['profilePic'] ??
                      AppImages.profile; // Default profile pic
                  String userName = userData['username'] ?? 'User Name';
                  String userEmail = userData['email'] ?? 'Role not specified';
                  String userPhone = userData['phone'] ?? 'No number';
                  String userStatus =
                      userData['status'] ?? 'No status available';
                  return Column(
                    mainAxisSize: MainAxisSize.min, // Wrap content height
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
                              child: Image.asset(
                                AppImages.profile, // Replace with your image
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20), // Spacing
                          // Name and Post Count
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$userName",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontSize: 20),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(buttonBorderRadius),
                                  color: AppColors.primaryColor.withOpacity(0.6),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Avg\nRating",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(fontSize: 14),
                                      ),
                                      Text(
                                        "4.5", // Example Rating
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // const SizedBox(height: 26), // Spacing
                      // // Activity Section
                      // Text(
                      //   "Activity Overview:",
                      //   style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 16,
                      //       ),
                      // ),
                      // const SizedBox(height: 16), // Spacing
                      // // Posts, Courses, Followers, Following
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     _ActivityCard("Posts", "45"),
                      //     _ActivityCard("Courses", "12"),
                      //     _ActivityCard("Followers", "356"),
                      //     _ActivityCard("Following", "189"),
                      //   ],
                      // ),
                      const SizedBox(height: 26), // Spacing
                      // Contact Information Section
                      Text(
                        "Contact Information:",
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Email: ${userEmail}",
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Phone: ${userPhone}",
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      const SizedBox(height: 26), // Spacing
                      // Skills Section
                      // Text(
                      //   "Skills:",
                      //   style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 16,
                      //       ),
                      // ),
                      // const SizedBox(height: 8),
                      // Wrap(
                      //   spacing: 8.0,
                      //   runSpacing: 4.0,
                      //   children: [
                      //     Chip(label: Text("AI")),
                      //     Chip(label: Text("Machine Learning")),
                      //     Chip(label: Text("Python")),
                      //     Chip(label: Text("Flutter")),
                      //     Chip(label: Text("JavaScript")),
                      //   ],
                      // ),
                    ],
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ActivityCard(String title, String count) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
