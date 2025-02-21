
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



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/util/widthandheight.dart';
import '../../../../../core/constants/asset-paths.dart';
import '../../../../../util/next-screen.dart';
import '../pages/profile.dart';
import 'post_lost_items.dart';  // Import the Create Post screen

class MissingItems extends StatelessWidget {
  const MissingItems({super.key});

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
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Colors.blue),
                ),
              ),
              SizedBox(width: 20), // Add some space between the texts
              GestureDetector(
                onTap: () {
                  // Navigate to the screen where users can create a post
                  nextScreen(context, PostLostFoundScreen());  // Make sure CreatePostScreen is implemented
                },
                child: Text(
                  "Create Post",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        Expanded( // This ensures the ListView doesn't cause overflow
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('lostFoundPosts').orderBy('createdAt', descending: true).snapshots(),
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
                  shrinkWrap: true,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    var post = posts[index];
                    return GestureDetector(
                      onTap: () {
                        nextScreen(context, ProfilePage());
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
                                  contentPadding: EdgeInsets.all(0),
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(post['profilePic'] ?? AppImages.profile),
                                  ),
                                  title: Text(post['userName']),
                                  subtitle: Text(post['createdAt'].toDate().toString()),
                                ),
                                Text(
                                  post['message'],
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )
        ),
      ],
    );
  }
}

class LostItem {
  final String description;
  final String user;
  final DateTime postedTime;
  final String? imageUrl;

  LostItem({
    required this.description,
    required this.user,
    required this.postedTime,
    this.imageUrl,
  });
}
