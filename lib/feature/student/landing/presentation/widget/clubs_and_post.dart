

// import 'package:flutter/material.dart';

// import '../../../../../core/constants/asset-paths.dart';
// import '../../../../../core/constants/colors.dart';
// import '../../../../../util/next-screen.dart';
// import '../../../../../util/widthandheight.dart';
// import '../pages/profile.dart';

// class ClubsAndPost extends StatelessWidget {
//   const ClubsAndPost({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return  SizedBox(
//       height: height(context) / 2.5,
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
//                 style: Theme.of(context)
//                     .textTheme
//                     .displayMedium!
//                     .copyWith(color: Colors.blue),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: height(context) / 2.5,
//             child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: 5,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       nextScreen(context, ProfilePage());
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(vertical: 10),
//                       child: Card(
//                         elevation: 3,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               ListTile(
//                                 contentPadding: EdgeInsets.all(0),
//                                 leading: CircleAvatar(
//                                   radius: 20,
//                                   backgroundImage: AssetImage(AppImages.profile),
//                                 ),
//                                 title: Text("Thuram"),
//                                 subtitle: Text("4 hours ago"),
                               
//                               ),
//                               Text(
//                                 "I have found that credit card at the platform and dropped it at the C lost&found office",
//                                 style: Theme.of(context).textTheme.displayMedium,
//                               ),
//                               const SizedBox(height: 20),
//                               // const SizedBox(
//                               //   height: 300,
//                               //   child: VideoPlayerWidget(
//                               //     videoUrl:
//                               //         "https://www.youtube.com/watch?v=_LwOjCdLMvc&list=PPSV",
//                               //   ),
//                               // ),
                              
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../util/next-screen.dart';
import '../../../../../util/widthandheight.dart';
import '../pages/profile.dart';
import 'club_post.dart';

class ClubsAndPost extends StatelessWidget {
  const ClubsAndPost({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(context) / 2.5,
      child: Column(
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
                  nextScreen(context, CreateClubPostScreen());  // Make sure CreatePostScreen is implemented
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
          SizedBox(
            height: height(context) / 2.5,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('clubPost').orderBy('createdAt', descending: true).snapshots(),
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
            ),
          ),
        ],
      ),
    );
  }
}
