// import 'package:flutter/material.dart';
// import 'package:thuram_app/util/next-screen.dart';
// import 'package:thuram_app/util/widthandheight.dart';

// import '../../../../../core/constants/asset-paths.dart';
// import '../../../../../core/constants/colors.dart';
// import '../pages/profile.dart';

// class Confessions extends StatelessWidget {
//   const Confessions({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
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
//                                 title: Text("Anoninous"),
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
//                               // Row(
//                               //   children: [
//                               //     Column(
//                               //       children: [
//                               //         IconButton(
//                               //             onPressed: () {},
//                               //             icon: const Icon(Icons.favorite)),
//                               //         Text(
//                               //           "0 likes",
//                               //           style: Theme.of(context)
//                               //               .textTheme
//                               //               .displaySmall,
//                               //         )
//                               //       ],
//                               //     ),
//                               //     Column(
//                               //       children: [
//                               //         IconButton(
//                               //             onPressed: () {},
//                               //             icon: const Icon(Icons.message)),
//                               //         Text(
//                               //           "24",
//                               //           style: Theme.of(context)
//                               //               .textTheme
//                               //               .displaySmall,
//                               //         )
//                               //       ],
//                               //     ),
//                               //   ],
//                               // )
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
import 'package:thuram_app/util/next-screen.dart';
import 'package:thuram_app/util/widthandheight.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
import '../pages/profile.dart';
// import '../pages/create_confession.dart';
import 'create_confession.dart'; // Import the CreateConfessionScreen

class Confessions extends StatelessWidget {
  const Confessions({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(context) / 2.5,
      child: Column(
        children: [
          // Use Row to display "All view" and "Create Confession" at the same level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
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
              ),
              GestureDetector(
                onTap: () {
                  nextScreen(context, CreateConfessionScreen()); // Navigate to the CreateConfessionScreen
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Create Confession",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            // height: height(context) / 2.5,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('confessions') // Adjust to your Firestore collection name
                  .orderBy('createdAt', descending: true) // Assuming you have a 'createdAt' field
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong!'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No confessions available.'));
                }

                var confessions = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: confessions.length,
                  itemBuilder: (context, index) {
                    var confession = confessions[index];
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
                                    backgroundImage: NetworkImage(
                                        confession['profilePic'] ??
                                            AppImages.profile),
                                  ),
                                  title: Text(confession['userName'] ?? 'Anonymous'),
                                  subtitle: Text(
                                    confession['createdAt']
                                        .toDate()
                                        .toString(), // Assuming 'createdAt' is a Timestamp
                                  ),
                                ),
                                Text(
                                  confession['message'] ??
                                      "No message available", // Assuming 'message' is a field
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
