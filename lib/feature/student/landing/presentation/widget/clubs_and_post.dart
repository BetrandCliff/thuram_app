

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

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thuram_app/feature/student/landing/presentation/widget/confersions.dart';
import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../util/mediaviewer.dart';
import '../../../../../util/next-screen.dart';
import '../../../../../util/video-player.dart';
import '../../../../../util/widthandheight.dart';
import '../../../../admin/presentations/database/db.dart';
import '../pages/profile.dart';
import 'create_club_post.dart';
/*


class ClubsAndPost extends StatelessWidget {
  const ClubsAndPost({super.key, required this.isStudent});
  final bool isStudent;

  Future<String?> _getMediaPathFromDb(int mediaId) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> mediaRecords = await db.query(
      'club_posts',
      where: 'id = ?',
      whereArgs: [mediaId],
    );
    if (mediaRecords.isNotEmpty) {
      return mediaRecords.first['mediaPath'] as String?;
    }
    return null;  // Return null if media is not found
  }

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
                SizedBox(width: 20),
                if (!isStudent)
                  GestureDetector(
                    onTap: () {
                      nextScreen(context, CreateClubPostScreen());
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
              stream: FirebaseFirestore.instance
                  .collection('clubPosts')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
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
                    int mediaId = post['mediaId'] ?? 0; // Get mediaId from Firestore

                    return FutureBuilder<String?>(
                      future: _getMediaPathFromDb(mediaId), // Fetch media path from SQLite
                      builder: (context, mediaSnapshot) {
                        if (mediaSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (mediaSnapshot.hasError || !mediaSnapshot.hasData) {
                          return Center(child: Text('Failed to load media.'));
                        }

                        String mediaPath = mediaSnapshot.data ?? ""; // Media path from SQLite

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
                                          post['profilePic'] ?? AppImages.profile,
                                        ),
                                      ),
                                      title: Text("${post['userName']??"Anonymous"}"),
                                      subtitle: Text(post['createdAt'].toDate().toString()),
                                    ),
                                    Text(
                                      "${post['message']}",
                                      style: Theme.of(context).textTheme.displayMedium,
                                    ),
                                    const SizedBox(height: 10),
                                    if (mediaPath.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov')
                                            ? // Video player if the file is a video
                                              Container(
                                                width: double.infinity,
                                                height: 200,
                                                child: VideoPlayerWidget(mediaPath: mediaPath),
                                              )
                                            : // Image if the file is an image
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/
/*

class ClubsAndPost extends StatelessWidget {
  const ClubsAndPost({super.key, required this.isStudent});
  final bool isStudent;

  @override
  Widget build(BuildContext context) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return SizedBox(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All view",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Colors.blue),
                ),
                if (!isStudent)
                  GestureDetector(
                    onTap: () {
                      nextScreen(context, CreateClubPostScreen());
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
            height: height(context) / 2.06,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('clubPosts')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
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
                    String? postOwnerId = post['userId'];
                    String? mediaUrl = post['mediaUrl'];

                    return Dismissible(
                      key: Key(post.id),
                      direction: currentUserId == postOwnerId
                          ? DismissDirection.endToStart
                          : DismissDirection.none,
                      onDismissed: (direction) async {
                        await FirebaseFirestore.instance
                            .collection('clubPosts')
                            .doc(post.id)
                            .delete();
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
                                  contentPadding: EdgeInsets.all(0),
                                  leading: GestureDetector(
                                    onTap: () {
                                      nextScreen(context, ProfilePage(userId: postOwnerId!));
                                    },
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        post['profilePic'] ?? AppImages.profile,
                                      ),
                                    ),
                                  ),
                                  title: Text("${post['userName'] ?? "Anonymous"}"),
                                  subtitle: Text(post['createdAt']?.toDate().toString() ?? ""),
                                ),
                                Text(
                                  "${post['message']}",
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                                const SizedBox(height: 10),
                                MediaViewer(mediaPath: mediaUrl??"",),
                    //         if (mediaUrl != null && mediaUrl.isNotEmpty)
                    //       Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10),
                    //   child: post['type'] == 'video'
                    //       ? VideoPlayerWidget(mediaPath: mediaUrl)
                    //       : ClipRRect(
                    //     borderRadius: BorderRadius.circular(8.0),
                    //     child: CachedNetworkImage(
                    //       imageUrl: mediaUrl,
                    //       width: double.infinity,
                    //       fit: BoxFit.cover,
                    //       placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    //       errorWidget: (context, url, error) => Center(child: Text("Image failed to load")),
                    //     ),
                    //   ),
                    // ),

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

 */
import 'package:path/path.dart';
class ClubsAndPost extends StatefulWidget {
  const ClubsAndPost({super.key, required this.isStudent});
  final bool isStudent;

  @override
  State<ClubsAndPost> createState() => _ClubsAndPostState();
}

class _ClubsAndPostState extends State<ClubsAndPost> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  bool isCaching = false;

  @override
  void initState() {
    super.initState();
    checkDatabase(); // Check if the database exists
  }

  void checkDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'app_data.db');

    bool exists = await File(path).exists();
    debugPrint("Database exists: $exists");

    if (exists) {
      List<Map<String, dynamic>> cachedPosts = await _dbHelper.getCachedPosts('clubPosts');
      debugPrint("Initial Cached Posts: ${cachedPosts.length}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _dbHelper.getCachedPosts('clubPosts'),
            builder: (context, cacheSnapshot) {
              if (cacheSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (cacheSnapshot.hasError) {
                debugPrint("Cache Error: ${cacheSnapshot.error}");
                return const Center(child: Text('Failed to load cached posts.'));
              }

              List<Map<String, dynamic>> cachedPosts = cacheSnapshot.data ?? [];

              debugPrint("Fetched Cached Posts: ${cachedPosts.length}");
              for (var post in cachedPosts) {
                debugPrint("Cached Post ID: ${post['id']}, Message: ${post['message']}");
              }

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('clubPosts')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting && cachedPosts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong!'));
                  }

                  List<QueryDocumentSnapshot> firestorePosts = snapshot.data?.docs ?? [];

                  if (firestorePosts.isNotEmpty) {
                    _cachePosts(firestorePosts, cachedPosts);
                  }

                  return _buildPostList(
                    firestorePosts.map((doc) => Map<String, dynamic>.from(doc.data() as Map)).toList(),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("All View", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.blue)),
          if (!widget.isStudent)
            GestureDetector(
              onTap: () => nextScreen(context, CreateClubPostScreen()),
              child: Text("Create Post", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.blue)),
            ),
        ],
      ),
    );
  }

  Future<void> _cachePosts(List<QueryDocumentSnapshot> firestorePosts, List<Map<String, dynamic>> cachedPosts) async {
    if (isCaching) return;
    isCaching = true;

    try {
      Set<String> cachedIds = cachedPosts.map((e) => e['id'] as String? ?? "").toSet();

      for (var post in firestorePosts) {
        if (!cachedIds.contains(post.id)) {
          var data = Map<String, dynamic>.from(post.data() as Map);

          Map<String, dynamic> postToInsert = {
            'id': post.id,
            'message': data['message'] ?? '',
            'mediaPath': data['mediaUrl'] is Map<String, dynamic> ? jsonEncode(data['mediaUrl']) : (data['mediaUrl'] ?? ''),
            'createdAt': data['createdAt']?.toDate().toString() ?? '',
            'userId': data['userId'] ?? '',
          };

          debugPrint("Inserting post: $postToInsert");
          await _dbHelper.insertPost('clubPosts', postToInsert);
        }
      }
    } catch (e) {
      debugPrint("Error caching posts: $e");
    } finally {
      if (mounted) setState(() => isCaching = false);
    }
  }

  Widget _buildPostList(List<Map<String, dynamic>> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        var post = posts[index];
        String? postOwnerId = post['userId'];
        String? mediaPath = post['mediaPath'];

        return Dismissible(
          key: Key(post['id'] ?? ""),
          direction: currentUserId == postOwnerId ? DismissDirection.endToStart : DismissDirection.none,
          onDismissed: (direction) async {
            await FirebaseFirestore.instance.collection('clubPosts').doc(post['id']).delete();
            await _dbHelper.deletePost('clubPosts', post['id']);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: GestureDetector(
                      onTap: () => nextScreen(context, ProfilePage(userId: postOwnerId!)),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(post['profilePic'] ?? ""),
                      ),
                    ),
                    title: Text(post['userName'] ?? "Anonymous"),
                    subtitle: Text(post['createdAt'] ?? ""),
                  ),
                  Text(post['message'], style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 10),
                  if (mediaPath != null && mediaPath.isNotEmpty) MediaViewer(mediaPath: mediaPath),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

