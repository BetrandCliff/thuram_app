
// import 'package:flutter/material.dart';
// import 'package:thuram_app/util/widthandheight.dart';

// import '../../../../../core/constants/asset-paths.dart';
// import '../../../../../util/next-screen.dart';
// import '../pages/profile.dart';

// class MissingItems extends StatelessWidget {
//   const MissingItems({super.key});

//   @override
//   Widget build(BuildContext context) {
//      return Column(
//       children: [
//         Align(
//           alignment: Alignment.topRight,
//           child: GestureDetector(
//             onTap: () {
//               nextScreen(context, ProfilePage());
//             },
//             child: Text(
//               "All view",
//               style: Theme.of(context)
//                   .textTheme
//                   .displayMedium!
//                   .copyWith(color: Colors.blue),
//             ),
//           ),
//         ),
//         Expanded( // This ensures the ListView doesn't cause overflow
//           child: ListView.builder(
//             itemCount: 5,
//             itemBuilder: (context, index) {
//               return Container(
//                 margin: EdgeInsets.symmetric(vertical: 10),
//                 width: width(context),
//                 child: Card(
//                   elevation: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const ListTile(
//                           contentPadding: EdgeInsets.all(0),
//                           leading: CircleAvatar(
//                             radius: 20,
//                             backgroundImage: AssetImage(AppImages.profile),
//                           ),
//                           title: Text("Thuram"),
//                           subtitle: Text("4 hours ago"),
//                         ),
//                         Text(
//                           "Hakeem forgot his book inside the library, please anybody who finds it should get to me",
//                         ),
//                         Image.asset(
//                           AppImages.equation,
//                           width: width(context)/3,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );


//   }
// }


// import 'package:flutter/material.dart';
// import 'package:thuram_app/util/widthandheight.dart';

// import '../../../../../core/constants/asset-paths.dart';
// import '../../../../../util/next-screen.dart';
// import '../pages/profile.dart';
// // import '../pages/create_post_screen.dart';
// import 'post_lost_items.dart';  // Import the Create Post screen

// class MissingItems extends StatelessWidget {
//   const MissingItems({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Align(
//           alignment: Alignment.topRight,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   nextScreen(context, ProfilePage());
//                 },
//                 child: Text(
//                   "All view",
//                   style: Theme.of(context)
//                       .textTheme
//                       .displayMedium!
//                       .copyWith(color: Colors.blue),
//                 ),
//               ),
//               SizedBox(width: 20), // Add some space between the texts
//               GestureDetector(
//                 onTap: () {
//                   // Navigate to the screen where users can create a post
//                   nextScreen(context, PostLostFoundScreen());  // Make sure CreatePostScreen is implemented
//                 },
//                 child: Text(
//                   "Create Post",
//                   style: Theme.of(context)
//                       .textTheme
//                       .displayMedium!
//                       .copyWith(color: Colors.blue),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded( // This ensures the ListView doesn't cause overflow
//           child: ListView.builder(
//             itemCount: 5,
//             itemBuilder: (context, index) {
//               return Container(
//                 margin: EdgeInsets.symmetric(vertical: 10),
//                 width: width(context),
//                 child: Card(
//                   elevation: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const ListTile(
//                           contentPadding: EdgeInsets.all(0),
//                           leading: CircleAvatar(
//                             radius: 20,
//                             backgroundImage: AssetImage(AppImages.profile),
//                           ),
//                           title: Text("Thuram"),
//                           subtitle: Text("4 hours ago"),
//                         ),
//                         Text(
//                           "Hakeem forgot his book inside the library, please anybody who finds it should get to me",
//                         ),
//                         Image.asset(
//                           AppImages.equation,
//                           width: width(context) / 3,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }



import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/feature/student/landing/presentation/widget/confersions.dart';
import '../../../../../core/constants/asset-paths.dart';
import '../../../../../util/mediaviewer.dart';
import '../../../../../util/next-screen.dart';
import '../../../../../util/video-player.dart';
import '../pages/profile.dart';
import 'post_lost_items.dart';  // Import the Create Post screen

import 'package:sqflite/sqflite.dart';

class MissingItems extends StatelessWidget {
  const MissingItems({super.key});

  // Function to delete post from Firestore
  Future<void> deletePostFromFirestore(String postId) async {
    await FirebaseFirestore.instance.collection('lostFoundPosts').doc(postId).delete();
  }

  @override
  Widget build(BuildContext context) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All view",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.blue),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  nextScreen(context, const PostLostFoundScreen());
                },
                child: Text(
                  "Create Post",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('lostFoundPosts')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong!'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No posts available.'));
              }

              var posts = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  var post = posts[index];
                  String? mediaPath = post['mediaPath']; // Now fetching from Firestore
                  String? postOwnerId = post['userId'];
                  Timestamp? timestamp = post['createdAt'] as Timestamp?;

                  return Dismissible(
                    key: Key(post.id),
                    direction: currentUserId == postOwnerId ? DismissDirection.endToStart : DismissDirection.none,
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Delete Post"),
                          content: const Text("Are you sure you want to delete this post?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text("Delete", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) async {
                      await deletePostFromFirestore(post.id);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        nextScreen(context, ProfilePage(userId: postOwnerId!));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(post['profilePic'] ?? AppImages.profile),
                                  ),
                                  title: Text(post['userName'] ?? "Anonymous"),
                                  subtitle: Text(timestamp != null ? timestamp.toDate().toString() : "Unknown date"),
                                ),
                                Text(
                                  post['message'],
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),

                                const SizedBox(height: 20),
                                MediaViewer(mediaPath: mediaPath??"",),
                                // if (mediaPath != null && mediaPath.isNotEmpty)
                                //   Padding(
                                //     padding: const EdgeInsets.symmetric(vertical: 10),
                                //     child: mediaPath.startsWith('http')
                                //         ? mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov')
                                //         ? SizedBox(
                                //       width: double.infinity,
                                //       // height: 200,
                                //       child: VideoPlayerWidget(mediaPath: mediaPath),
                                //     )
                                //         : ClipRRect(
                                //       borderRadius: BorderRadius.circular(8.0),
                                //       child: Image.network(
                                //         mediaPath,
                                //         width: double.infinity,
                                //         // height: 200,
                                //         fit: BoxFit.cover,
                                //         errorBuilder: (context, error, stackTrace) {
                                //           return const Center(child: Text("Image failed to load"));
                                //         },
                                //       ),
                                //     )
                                //         : const SizedBox(), // No image if mediaPath is invalid
                                //   ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}


//
// class MissingItems extends StatelessWidget {
//   const MissingItems({super.key});
//
//   // Function to delete post from SQLite
//   Future<void> deletePostFromSQLite(String postId) async {
//     final Database db = await openDatabase('academy.db');
//     await db.delete('lostFoundPosts', where: 'id = ?', whereArgs: [postId]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
//
//     return Column(
//       children: [
//         Align(
//           alignment: Alignment.topRight,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "All view",
//                 style: Theme.of(context)
//                     .textTheme
//                     .displayMedium!
//                     .copyWith(color: Colors.blue),
//               ),
//               SizedBox(width: 20),
//               GestureDetector(
//                 onTap: () {
//                   nextScreen(context, PostLostFoundScreen());
//                 },
//                 child: Text(
//                   "Create Post",
//                   style: Theme.of(context)
//                       .textTheme
//                       .displayMedium!
//                       .copyWith(color: Colors.blue),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('lostFoundPosts')
//                 .orderBy('createdAt', descending: true)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//
//               if (snapshot.hasError) {
//                 return Center(child: Text('Something went wrong!'));
//               }
//
//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return Center(child: Text('No posts available.'));
//               }
//
//               var posts = snapshot.data!.docs;
//
//               return ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: posts.length,
//                 itemBuilder: (context, index) {
//                   var post = posts[index];
//                   String? mediaPath = post['mediaPath'];
//                   String? postOwnerId = post['userId'];
//
//                   return Dismissible(
//                     key: Key(post.id),
//                     direction: currentUserId == postOwnerId
//                         ? DismissDirection.endToStart
//                         : DismissDirection.none,
//                     onDismissed: (direction) async {
//                       // Delete from Firestore
//                       await FirebaseFirestore.instance
//                           .collection('lostFoundPosts')
//                           .doc(post.id)
//                           .delete();
//
//                       // Delete from SQLite
//                       await deletePostFromSQLite(post.id);
//                     },
//                     background: Container(
//                       color: Colors.red,
//                       alignment: Alignment.centerRight,
//                       padding: EdgeInsets.only(right: 16),
//                       child: Icon(Icons.delete, color: Colors.white),
//                     ),
//                     child: GestureDetector(
//                       onTap: () {
//                         nextScreen(context, ProfilePage(userId: postOwnerId!,));
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(vertical: 10),
//                         child: Card(
//                           elevation: 3,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ListTile(
//                                   contentPadding: EdgeInsets.all(0),
//                                   leading: CircleAvatar(
//                                     radius: 20,
//                                     backgroundImage: NetworkImage(
//                                         post['profilePic'] ??
//                                             AppImages.profile),
//                                   ),
//                                   title: Text(post['userName'] ?? "Anonymous"),
//                                   subtitle: Text(
//                                       post['createdAt'].toDate().toString()),
//                                 ),
//                                 Text(
//                                   post['message'],
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .displayMedium,
//                                 ),
//                                 const SizedBox(height: 20),
//                                 if (mediaPath != null && mediaPath.isNotEmpty)
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 10),
//                                     child: mediaPath.endsWith('.mp4') ||
//                                         mediaPath.endsWith('.mov')
//                                         ? Container(
//                                       width: double.infinity,
//                                       height: 200,
//                                       child: VideoPlayerWidget(
//                                           mediaPath: mediaPath),
//                                     )
//                                         : ClipRRect(
//                                       borderRadius:
//                                       BorderRadius.circular(8.0),
//                                       child: Image.file(
//                                         File(mediaPath),
//                                         width: double.infinity,
//                                         height: 200,
//                                         fit: BoxFit.cover,
//                                         errorBuilder:
//                                             (context, error, stackTrace) {
//                                           return const Center(
//                                             child: Text(
//                                                 "Image failed to load"),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
