import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/constants/asset-paths.dart';
import '../core/constants/colors.dart';
import '../core/constants/values.dart';

// class CustomDescriptionCard extends StatelessWidget {
//   const CustomDescriptionCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(
//             minHeight: 100,
//             maxWidth: 600,
//           ),
//           child: Card(
//             color: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(buttonBorderRadius),
//             ),
//             elevation: 3,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min, // Wrap content height
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Profile Row
//                   Row(
//                     children: [
//                       // Profile Image
//                       Container(
//                         width: 120,
//                         height: 120,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.shade300,
//                               blurRadius: 10,
//                               spreadRadius: 4,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                           border: Border.all(
//                             color: Colors.white,
//                             width: 4,
//                           ),
//                         ),
//                         child: ClipOval(
//                           child: Image.asset(
//                             AppImages.profile, // Replace with your image
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 20), // Spacing
//                       // Name and Post Count
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Folefac Thuram",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleMedium!
//                                 .copyWith(fontSize: 20),
//                           ),
//                           const SizedBox(height: 10),
//                           Container(
//                             height: 70,
//                             width: 70,
//                             decoration: BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.circular(buttonBorderRadius),
//                               color: AppColors.primaryColor.withOpacity(0.6),
//                             ),
//                             child: Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Avg\nRating",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .displayMedium!
//                                         .copyWith(fontSize: 14),
//                                   ),
//                                   Text(
//                                     "4.5", // Example Rating
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .displayMedium!
//                                         .copyWith(fontSize: 14),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 26), // Spacing
//                   // Activity Section
//                   Text(
//                     "Activity Overview:",
//                     style: Theme.of(context).textTheme.displayMedium!.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                   ),
//                   const SizedBox(height: 16), // Spacing
//                   // Posts, Courses, Followers, Following
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       _ActivityCard("Posts", "45"),
//                       _ActivityCard("Courses", "12"),
//                       _ActivityCard("Followers", "356"),
//                       _ActivityCard("Following", "189"),
//                     ],
//                   ),
//                   const SizedBox(height: 26), // Spacing
//                   // Contact Information Section
//                   Text(
//                     "Contact Information:",
//                     style: Theme.of(context).textTheme.displayMedium!.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Email: folefacthuram@example.com",
//                     style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                           fontSize: 14,
//                         ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Phone: +123 456 7890",
//                     style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                           fontSize: 14,
//                         ),
//                   ),
//                   const SizedBox(height: 26), // Spacing
//                   // Skills Section
//                   Text(
//                     "Skills:",
//                     style: Theme.of(context).textTheme.displayMedium!.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                   ),
//                   const SizedBox(height: 8),
//                   Wrap(
//                     spacing: 8.0,
//                     runSpacing: 4.0,
//                     children: [
//                       Chip(label: Text("AI")),
//                       Chip(label: Text("Machine Learning")),
//                       Chip(label: Text("Python")),
//                       Chip(label: Text("Flutter")),
//                       Chip(label: Text("JavaScript")),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _ActivityCard(String title, String count) {
//     return Column(
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           count,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: AppColors.primaryColor,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDescriptionCard extends StatelessWidget {
  const CustomDescriptionCard({super.key});

  Future<Map<String, dynamic>?> fetchUserData() async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid; // Dynamically get user ID
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();  // Use userId instead of hardcoded 'userId123'

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
  return Scaffold(
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
        int followersCount = (userData["followers"] as List<dynamic>?)?.length ?? 0;
        int followingCount = (userData["following"] as List<dynamic>?)?.length ?? 0;

        return SingleChildScrollView(
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
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  AppImages.profile, // Replace with the path to your default image asset
                                  fit: BoxFit.cover,
                                );
                              },
                                  )
                                : Image.asset(
                                    AppImages.profile, // Default image if no profile image is found
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
                              userData["username"] ?? "Unknown User",
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
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.blue.withOpacity(0.6),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Avg\nRating",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      userData["rating"]?.toString() ?? "N/A",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 26), // Spacing
                    // Activity Section
                    Text(
                      "Activity Overview:",
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                    ),
                    const SizedBox(height: 16), // Spacing
                    // Posts, Courses, Followers, Following
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ActivityCard(
                            "Posts", userData["posts"]?.toString() ?? "0"),
                        _ActivityCard("Courses",
                            userData["courses"]?.toString() ?? "0"),
                        _ActivityCard("Followers", followersCount.toString()),
                        _ActivityCard("Following", followingCount.toString()),
                      ],
                    ),
                    const SizedBox(height: 26), // Spacing
                    // Contact Information Section
                    Text(
                      "Contact Information:",
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Email: ${userData["email"] ?? "N/A"}",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Phone: ${userData["phone"] ?? "N/A"}",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(height: 26), // Spacing
                    // Skills Section
                    Text(
                      "Skills:",
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: userData["skills"] != null
                          ? (userData["skills"] as List<dynamic>)
                              .map((skill) => Chip(label: Text(skill)))
                              .toList()
                          : [const Chip(label: Text("No skills listed"))],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
