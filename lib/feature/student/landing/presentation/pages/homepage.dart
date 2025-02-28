import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/feature/student/landing/presentation/widget/confersions.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/values.dart';
import '../widget/academy.dart';
import '../widget/clubs_and_post.dart';
import '../widget/lost-items.dart';
import '../widget/lost_and_found.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.isStudent=true});
 final bool isStudent;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // SizedBox(
        //   height: 220,
        //   width: double.infinity,
        //   child: Card(
        //     color: Colors.white,
        //     shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(buttonBorderRadius)),
        //     elevation: 3,
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Row(
        //             children: [
        //               Container(
        //                 width: 120, // Adjust size
        //                 height: 120,
        //                 decoration: BoxDecoration(
        //                   shape: BoxShape.circle,
        //                   boxShadow: [
        //                     BoxShadow(
        //                       color: Colors
        //                           .grey.shade300, // Light grey shadow
        //                       blurRadius: 10,
        //                       spreadRadius: 4,
        //                       offset: Offset(0, 4),
        //                     ),
        //                   ],
        //                   border: Border.all(
        //                     color: Colors.white, // White border
        //                     width: 4,
        //                   ),
        //                 ),
        //                 child: ClipOval(
        //                   child: Image.asset(
        //                     AppImages.profile, // Replace with your image
        //                     fit: BoxFit.cover,
        //                   ),
        //                 ),
        //               ),
        //               Container(
        //                 margin: const EdgeInsets.only(
        //                   left: 20,
        //                 ),
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                       "Folefac Thuram",
        //                       style: Theme.of(context)
        //                           .textTheme
        //                           .titleMedium!
        //                           .copyWith(fontSize: 20),
        //                     ),
        //                     Text(
        //                       "(student)",
        //                       style: Theme.of(context)
        //                           .textTheme
        //                           .displaySmall!
        //                           .copyWith(fontSize: 14),
        //                     ),
        //                     Text(
        //                       "@thuram",
        //                       style: Theme.of(context)
        //                           .textTheme
        //                           .displaySmall!
        //                           .copyWith(fontSize: 14),
        //                     ),
        //                     Container(
        //                       margin: const EdgeInsets.only(top: 10),
        //                       height: 70,
        //                       width: 70,
        //                       decoration: BoxDecoration(
        //                           borderRadius: BorderRadius.circular(
        //                               buttonBorderRadius),
        //                           color: AppColors.primaryColor
        //                               .withOpacity(0.6)),
        //                       child: Center(
        //                         child: Column(
        //                           mainAxisAlignment:
        //                               MainAxisAlignment.center,
        //                           children: [
        //                             Text(
        //                               "4",
        //                               style: Theme.of(context)
        //                                   .textTheme
        //                                   .displayMedium!
        //                                   .copyWith(fontSize: 14),
        //                             ),
        //                             Text(
        //                               "Post",
        //                               style: Theme.of(context)
        //                                   .textTheme
        //                                   .displayMedium!
        //                                   .copyWith(fontSize: 14),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                     )
        //                   ],
        //                 ),
        //               )
        //             ],
        //           ),
        //           Container(
        //             margin: EdgeInsets.only(top: 10),
        //             height: 30,
        //             child:
        //                 Text(
        //                   "Watching the movies🎬",
        //                   style:
        //                       Theme.of(context).textTheme.displayMedium,
        //                 ),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),


        SizedBox(
          height: 120,
          width: double.infinity,
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonBorderRadius)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                  String userRole = userData['email'] ?? 'Role not specified';
                  String userHandle = userData['username'] ?? 'username';
                  String userStatus =
                      userData['status'] ?? 'No status available';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 90, 
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.grey.shade300, // Light grey shadow
                                  blurRadius: 10,
                                  spreadRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white, // White border
                                width: 4,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.file(
                                File(profilePic), // Use the user's profile image URL
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(AppImages.profile,
                                      fit: BoxFit
                                          .cover); // Default image on error
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontSize: 20),
                                ),
                                Text(
                                  "($userRole)",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontSize: 14),
                                ),
                                Text(
                                  "@$userHandle",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontSize: 14),
                                ),
                                /*Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          buttonBorderRadius),
                                      color: AppColors.primaryColor
                                          .withOpacity(0.6)),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "4", // This can be dynamic if you fetch the user's post count
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(fontSize: 14),
                                        ),
                                        Text(
                                          "PP",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                )*/
                              ],
                            ),
                          )
                        ],
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(top: 10),
                      //   height: 30,
                      //   child: Text(
                      //     userStatus, // Display the user's status
                      //     style: Theme.of(context).textTheme.displayMedium,
                      //   ),
                      // ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // TabBar for Login & Signup
        const TabBar(
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.red,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(
              text: "Academic",
              icon: Icon(Icons.book),
            ),
            Tab(
              text: "L&F",
              icon: Icon(Icons.shopping_basket),
            ),
            Tab(
              text: "Club Posts",
              icon: Icon(Icons.people),
            ),
            Tab(
              text: "Confersions",
              icon: Icon(Icons.message),
            ),
          ],
        ),

        // Expanded TabBarView
        SizedBox(
          height: MediaQuery.of(context).size.height-(MediaQuery.of(context).size.height/2.04),
          child: Expanded(
            child: TabBarView(
              children:  [
                Academy(),
                MissingItems(),
                ClubsAndPost(isStudent: isStudent),
                Confessions(),
                // LostAndFound()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
