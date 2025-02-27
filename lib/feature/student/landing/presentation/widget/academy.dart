// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:thuram_app/util/next-screen.dart';
// import 'package:thuram_app/util/widthandheight.dart';

// import '../../../../../core/constants/asset-paths.dart';
// import '../../../../../core/constants/colors.dart';
// import '../pages/profile.dart';

// class Academy extends StatefulWidget {
//   const Academy({super.key});

//   @override
//   State<Academy> createState() => _AcademyState();
// }

// class _AcademyState extends State<Academy> {
//   late List<int> likes;
//   late List<bool> isTapped;
//   late List<List<String>> likedUsers;
//   late List<List<String>> messages;
//   bool showLikes = false;
//   bool showMessages = false;
//   int tapPostLikes = 0;
//   int tapPostMessages = 0;
//   TextEditingController commentController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     likes = List.filled(5, 0);
//     isTapped = List.filled(5, false);
//     likedUsers = List.generate(5, (index) => []);
//     messages = List.generate(5, (index) => []);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Column(
//         children: [
//           Align(
//             alignment: Alignment.topRight,
//             child: GestureDetector(
//               onTap: () {
//                 nextScreen(context, ProfilePage());
//               },
//               child: Text(
//                 "All view",
//                 style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.blue),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: 5,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {},
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     child: Card(
//                       elevation: 3,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: [
//                             ListTile(
//                               onTap: () {
//                                 nextScreen(context, ProfilePage());
//                               },
//                               contentPadding: EdgeInsets.all(0),
//                               leading: CircleAvatar(
//                                 radius: 20,
//                                 backgroundImage: AssetImage(AppImages.profile),
//                               ),
//                               title: Text("Thuram"),
//                               subtitle: Text("4 hours ago"),
//                             ),
//                             Text(
//                               "I have found that credit card at the platform and dropped it at the Lost & Found office",
//                               style: Theme.of(context).textTheme.displayMedium,
//                             ),
//                             const SizedBox(height: 20),
//                             Row(
//                               children: [
//                                 Column(
//                                   children: [
//                                     IconButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           if (isTapped[index]) {
//                                             likes[index]--;
//                                             isTapped[index] = false;
//                                             likedUsers[index].remove('User ${index + 1}');
//                                           } else {
//                                             likes[index]++;
//                                             isTapped[index] = true;
//                                             likedUsers[index].add('User ${index + 1}');
//                                           }
//                                         });
//                                       },
//                                       icon: Icon(
//                                         isTapped[index] ? Icons.favorite : Icons.favorite_border,
//                                         color: isTapped[index] ? Colors.red : Colors.grey,
//                                       ),
//                                     ),
//                                     Text.rich(
//                                       TextSpan(
//                                         children: [
//                                           TextSpan(
//                                             text: "${likes[index]}",
//                                             style: Theme.of(context).textTheme.displaySmall,
//                                           ),
//                                           TextSpan(
//                                             text: " likes",
//                                             style: Theme.of(context).textTheme.displaySmall,
//                                             recognizer: TapGestureRecognizer()
//                                               ..onTap = () {
//                                                 setState(() {
//                                                   showLikes = !showLikes;
//                                                   showMessages = false;
//                                                   tapPostLikes = index;
//                                                 });
//                                               },
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     IconButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           showMessages = !showMessages;
//                                           showLikes = false;
//                                           tapPostMessages = index;
//                                         });
//                                       },
//                                       icon: const Icon(Icons.message),
//                                     ),
//                                     Text(
//                                       "${messages[index].length}",
//                                       style: Theme.of(context).textTheme.displaySmall,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             if (showLikes && index == tapPostLikes)
//                               SizedBox(
//                                 height: 150,
//                                 child: ListView.builder(
//                                   itemCount: likedUsers[index].length.clamp(0, 3),
//                                   itemBuilder: (context, i) => ListTile(
//                                     leading: CircleAvatar(
//                                       radius: 20,
//                                       backgroundImage: AssetImage(AppImages.profile),
//                                     ),
//                                     title: Text(
//                                       likedUsers[index][i],
//                                       style: Theme.of(context).textTheme.displayMedium,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             if (showMessages && index == tapPostMessages)
//                               Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: TextField(
//                                           controller: commentController,
//                                           decoration: InputDecoration(
//                                             hintStyle: Theme.of(context).textTheme.displaySmall,
//                                             hintText: 'Add a comment...',
//                                             border: OutlineInputBorder(),
//                                           ),
//                                         ),
//                                       ),
//                                       IconButton(
//                                         icon: Icon(Icons.send),
//                                         onPressed: () {
//                                           setState(() {
//                                             if (commentController.text.isNotEmpty) {
//                                               messages[index].add(commentController.text);
//                                               commentController.clear();
//                                             }
//                                           });
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 150,
//                                     child: ListView.builder(
//                                       itemCount: messages[index].length.clamp(0, 3),
//                                       itemBuilder: (context, i) => ListTile(
//                                         leading: CircleAvatar(
//                                           radius: 20,
//                                           backgroundImage: AssetImage(AppImages.profile),
//                                         ),
//                                         title: Text(
//                                           messages[index][i],
//                                           style: Theme.of(context).textTheme.displayMedium,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/feature/student/landing/presentation/widget/confersions.dart';
import 'package:thuram_app/util/next-screen.dart';
import 'package:thuram_app/util/widthandheight.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../util/video-player.dart';
import '../pages/profile.dart';
import 'academy_post.dart';
class Academy extends StatefulWidget {
  const Academy({super.key});

  @override
  State<Academy> createState() => _AcademyState();
}

class _AcademyState extends State<Academy> {
  TextEditingController commentController = TextEditingController();
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  String? currentUserProfilePic = FirebaseAuth.instance.currentUser?.photoURL;
  bool showComments = false;
  int commentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  nextScreen(context, ProfilePage());
                },
                child: Text(
                  "All view",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.blue),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  nextScreen(context, AcademyPostScreen());
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
            stream: FirebaseFirestore.instance.collection('academy').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong!'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No posts available.'));
              }

              var posts = snapshot.data!.docs;

              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  var post = posts[index];
                  String? mediaPath = post['mediaPath'];
                  String postOwnerId = post['userId']; // Ensure the post has userId field

                  return Dismissible(
                    key: Key(post.id),
                    direction: currentUserId == postOwnerId
                        ? DismissDirection.endToStart
                        : DismissDirection.none, // Allow swipe only if user owns the post
                    onDismissed: (direction) async {
                      // Delete the post and its comments
                      await FirebaseFirestore.instance.collection('academy').doc(post.id).delete();
                      await FirebaseFirestore.instance
                          .collection('academy')
                          .doc(post.id)
                          .collection('comments')
                          .get()
                          .then((snapshot) {
                        for (DocumentSnapshot doc in snapshot.docs) {
                          doc.reference.delete();
                        }
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
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
                                onTap: () {
                                  nextScreen(context, ProfilePage());
                                },
                                contentPadding: EdgeInsets.all(0),
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(post['profilePic'] ?? AppImages.profile),
                                ),
                                title: Text(post['name']),
                                subtitle: Text(post['createdAt'].toDate().toString()),
                              ),
                              Text(
                                post['message'],
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                              const SizedBox(height: 20),
                              if (mediaPath != null && mediaPath.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov')
                                      ? Container(
                                    width: double.infinity,
                                    height: 200,
                                    child: VideoPlayerWidget(mediaPath: mediaPath),
                                  )
                                      : ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.file(
                                      File(mediaPath),
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(
                                          child: Text("Image failed to load"),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance.collection('academy').doc(post.id).snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) return CircularProgressIndicator();

                                          var data = snapshot.data!.data() as Map<String, dynamic>;

                                          List<String> likes = [];
                                          if (data['likes'] is List<dynamic>) {
                                            likes = List<String>.from(data['likes']);
                                          }

                                          bool isLiked = likes.contains(currentUserId);

                                          return Column(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  if (!isLiked) {
                                                    FirebaseFirestore.instance.collection('academy').doc(post.id).update({
                                                      'likes': FieldValue.arrayUnion([currentUserId])
                                                    });
                                                  } else {
                                                    FirebaseFirestore.instance.collection('academy').doc(post.id).update({
                                                      'likes': FieldValue.arrayRemove([currentUserId])
                                                    });
                                                  }
                                                },
                                                icon: Icon(
                                                  isLiked ? Icons.favorite : Icons.favorite_border,
                                                  color: isLiked ? Colors.red : Colors.grey,
                                                ),
                                              ),
                                              Text("${likes.length} likes"),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showComments = !showComments;
                                            commentIndex = index;
                                          });

                                          print("CURRENT TAPPED COMMENT IS  $commentIndex");
                                        },
                                        icon: const Icon(Icons.message),
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('academy')
                                            .doc(post.id)
                                            .collection('comments')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) return CircularProgressIndicator();

                                          var comments = snapshot.data!.docs;
                                          return Text("${comments.length} comments");
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              if (showComments &&commentIndex==index)
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('academy')
                                      .doc(post.id)
                                      .collection('comments')
                                      .orderBy('createdAt', descending: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) return CircularProgressIndicator();

                                    var comments = snapshot.data!.docs;

                                    return SizedBox(
                                      height: comments.isNotEmpty ? 150 : 0,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: comments.length,
                                        itemBuilder: (context, i) {
                                          var comment = comments[i];

                                          return Dismissible(
                                            key: Key(comment.id),
                                            direction: DismissDirection.endToStart,
                                            onDismissed: (direction) async {
                                              await FirebaseFirestore.instance
                                                  .collection('academy')
                                                  .doc(post.id)
                                                  .collection('comments')
                                                  .doc(comment.id)
                                                  .delete();
                                            },
                                            background: Container(
                                              color: Colors.red,
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.only(right: 16),
                                              child: Icon(Icons.delete, color: Colors.white),
                                            ),
                                            child: ListTile(
                                              onTap: (){

                                              },
                                              leading: CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(post['profilePic'] ?? AppImages.profile),
                                              ),
                                              title: Text(comment['text']),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),

                              // Add comment input field and button
                              if (showComments &&commentIndex==index)
                                Row(
                                  children: [


                                    Expanded(
                                      child: TextField(
                                        controller: commentController,
                                        decoration: InputDecoration(
                                          hintStyle: Theme.of(context).textTheme.displayMedium,
                                          hintText: 'Add a comment...',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () async {
                                        if (commentController.text.isNotEmpty) {
                                          await FirebaseFirestore.instance.collection('academy').doc(post.id).collection('comments').add({
                                            'text': commentController.text,
                                            'createdAt': FieldValue.serverTimestamp(),
                                          });

                                          commentController.clear();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                            ],
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



/*
class _AcademyState extends State<Academy> {
  TextEditingController commentController = TextEditingController();
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  bool showComments = false; // Variable to toggle comment section visibility
  int commentIndex =-1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  nextScreen(context, ProfilePage());
                },
                child: Text(
                  "All view",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.blue),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  nextScreen(context, AcademyPostScreen());
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
            stream: FirebaseFirestore.instance.collection('academy').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong!'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No posts available.'));
              }

              var posts = snapshot.data!.docs;

              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  var post = posts[index];
                  String? mediaPath = post['mediaPath'];  

                  return GestureDetector(
                    onTap: () {},
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
                                onTap: () {
                                  nextScreen(context, ProfilePage());
                                },
                                contentPadding: EdgeInsets.all(0),
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(post['profilePic'] ?? AppImages.profile),
                                ),
                                title: Text(post['name']),
                                subtitle: Text(post['createdAt'].toDate().toString()),
                              ),
                              Text(
                                post['message'],
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                              const SizedBox(height: 20),
                              // Display image or video if mediaPath exists
                              if (mediaPath != null && mediaPath.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov')
                                      ? // Video player if the file is a video
                                          Container(
                                            width: double.infinity,
                                            height: 200,
                                            child: VideoPlayerWidget(mediaPath: mediaPath),
                                          )
                                      : 
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Image.file(
                                              File(mediaPath),
                                              width: double.infinity,
                                              height: 200,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return const Center(
                                                  child: Text("Image failed to load"),
                                                );
                                              },
                                            ),
                                          ),
                                ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance.collection('academy').doc(post.id).snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) return CircularProgressIndicator();

                                          var data = snapshot.data!.data() as Map<String, dynamic>;

                                          List<String> likes = [];
                                          if (data['likes'] is List<dynamic>) {
                                            likes = List<String>.from(data['likes']);
                                          }

                                          bool isLiked = likes.contains(currentUserId);

                                          return Column(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  if (!isLiked) {
                                                    FirebaseFirestore.instance.collection('academy').doc(post.id).update({
                                                      'likes': FieldValue.arrayUnion([currentUserId])
                                                    });
                                                  } else {
                                                    FirebaseFirestore.instance.collection('academy').doc(post.id).update({
                                                      'likes': FieldValue.arrayRemove([currentUserId])
                                                    });
                                                  }
                                                },
                                                icon: Icon(
                                                  isLiked ? Icons.favorite : Icons.favorite_border,
                                                  color: isLiked ? Colors.red : Colors.grey,
                                                ),
                                              ),
                                              Text("${likes.length} likes"),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showComments = !showComments; // Toggle comment section visibility
                                            commentIndex=index;
                                          });

                                          print("CURRENT TAPPED COMMENT IS  $commentIndex");
                                        },
                                        icon: const Icon(Icons.message),
                                      ),
                                      // Show the number of comments below the message icon
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('academy')
                                            .doc(post.id)
                                            .collection('comments')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) return CircularProgressIndicator();

                                          var comments = snapshot.data!.docs;
                                          return Text("${comments.length} comments");
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Only show comments if showComments is true
                              if (showComments &&commentIndex==index)
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('academy')
                                      .doc(post.id)
                                      .collection('comments')
                                      .orderBy('createdAt', descending: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) return CircularProgressIndicator();

                                    var comments = snapshot.data!.docs;

                                    return SizedBox(
                                      height: comments.isNotEmpty ? 150 : 0,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: comments.length,
                                        itemBuilder: (context, i) {
                                          var comment = comments[i];

                                          return Dismissible(
                                            key: Key(comment.id),
                                            direction: DismissDirection.endToStart,
                                            onDismissed: (direction) async {
                                              await FirebaseFirestore.instance
                                                  .collection('academy')
                                                  .doc(post.id)
                                                  .collection('comments')
                                                  .doc(comment.id)
                                                  .delete();
                                            },
                                            background: Container(
                                              color: Colors.red,
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.only(right: 16),
                                              child: Icon(Icons.delete, color: Colors.white),
                                            ),
                                            child: ListTile(
                                              onTap: (){
                                                
                                              },
                                              leading: CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(post['profilePic'] ?? AppImages.profile),
                                              ),
                                              title: Text(comment['text']),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              // Add comment input field and button
                              if (showComments &&commentIndex==index)
                                Row(
                                  children: [


                                    Expanded(
                                      child: TextField(
                                        controller: commentController,
                                        decoration: InputDecoration(
                                          hintStyle: Theme.of(context).textTheme.displayMedium,
                                          hintText: 'Add a comment...',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () async {
                                        if (commentController.text.isNotEmpty) {
                                          await FirebaseFirestore.instance.collection('academy').doc(post.id).collection('comments').add({
                                            'text': commentController.text,
                                            'createdAt': FieldValue.serverTimestamp(),
                                          });

                                          commentController.clear();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                            ],
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
*/

