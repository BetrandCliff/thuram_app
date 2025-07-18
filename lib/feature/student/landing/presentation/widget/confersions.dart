

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thuram_app/util/next-screen.dart';
import 'package:thuram_app/util/widthandheight.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../util/mediaviewer.dart';
import '../../../../../util/video-player.dart';
import '../../../../admin/presentations/database/db.dart';
import '../pages/profile.dart';
// import '../pages/create_confession.dart';
import 'create_confession.dart'; // Import the CreateConfessionScreen


import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';



import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



/*

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
                  nextScreen(context, CreateConfessionScreen());
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('confessions')
                  .where('status', isEqualTo: 'approved')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print("Firestore Error: ${snapshot.error}");
                  return const Center(child: Text('Something went wrong!'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No approved confessions available.'));
                }

                var confessions = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: confessions.length,
                  itemBuilder: (context, index) {
                    var confession = confessions[index];
                    String? mediaPath = confession['mediaPath']; 

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
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      confession['profilePic'] ?? AppImages.profile,
                                    ),
                                  ),
                                  title: Text(confession['userName'] ?? 'Anonymous'),
                                  subtitle: Text(
                                    confession['createdAt']
                                        .toDate()
                                        .toString(), // Assuming 'createdAt' is a Timestamp
                                  ),
                                ),
                                Text(
                                  confession['message'] ?? "No message available",
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                                const SizedBox(height: 10),
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
            ),
          ),
        ],
      ),
    );
  }
}

// Stateful widget to manage the video player
class VideoPlayerWidget extends StatefulWidget {
  final String mediaPath;

  const VideoPlayerWidget({super.key, required this.mediaPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller using the file path
    _controller = VideoPlayerController.file(File(widget.mediaPath))
      ..initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown before playing
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
*/

//
// class Confessions extends StatelessWidget {
//   const Confessions({super.key});
//
//   Future<String?> _getMediaPathFromDb(int mediaId) async {
//     final db = await DatabaseHelper().database;
//     final List<Map<String, dynamic>> mediaRecords = await db.query(
//       'confessions', // Assuming you have a table for confessions
//       where: 'id = ?',
//       whereArgs: [mediaId],
//     );
//     if (mediaRecords.isNotEmpty) {
//       return mediaRecords.first['mediaPath'] as String?;
//     }
//     return null; // Return null if media is not found
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height(context) / 2.5,
//       child: Column(
//         children: [
//           // Use Row to display "All view" and "Create Confession" at the same level
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Align(
//                 alignment: Alignment.topRight,
//                 child: GestureDetector(
//                   onTap: () {
//                     nextScreen(context, ProfilePage());
//                   },
//                   child: Text(
//                     "All view",
//                     style: Theme.of(context)
//                         .textTheme
//                         .displayMedium!
//                         .copyWith(color: Colors.blue),
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   nextScreen(context, CreateConfessionScreen());
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     "Create Confession",
//                     style: Theme.of(context).textTheme.displayMedium!.copyWith(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('confessions')
//                   .where('status', isEqualTo: 'approved')
//                   .orderBy('createdAt', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (snapshot.hasError) {
//                   print("Firestore Error: ${snapshot.error}");
//                   return const Center(child: Text('Something went wrong!'));
//                 }
//
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text('No approved confessions available.'));
//                 }
//
//                 var confessions = snapshot.data!.docs;
//
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: confessions.length,
//                   itemBuilder: (context, index) {
//                     var confession = confessions[index];
//                     int mediaId = confession['mediaId'] ?? 0; // Get mediaId from Firestore
//                     // String? mediaPath = confession['mediaId']; // Fallback if mediaPath exists in Firestore
//
//                     return FutureBuilder<String?>(
//                       future: _getMediaPathFromDb(mediaId), // Fetch media path from SQLite
//                       builder: (context, mediaSnapshot) {
//                         if (mediaSnapshot.connectionState == ConnectionState.waiting) {
//                           return Center(child: CircularProgressIndicator());
//                         }
//
//                         if (mediaSnapshot.hasError || !mediaSnapshot.hasData) {
//                           return Center(child: Text('Failed to load media.'));
//                         }
//
//                         String mediaPath = mediaSnapshot.data ?? ""; // Media path from SQLite
//
//                         return GestureDetector(
//                           onTap: () {
//                             nextScreen(context, ProfilePage());
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 10),
//                             child: Card(
//                               elevation: 3,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ListTile(
//                                       contentPadding: EdgeInsets.zero,
//                                       leading: CircleAvatar(
//                                         radius: 20,
//                                         backgroundImage: NetworkImage(
//                                           confession['profilePic'] ?? AppImages.profile,
//                                         ),
//                                       ),
//                                       title: Text(confession['userName'] ?? 'Anonymous'),
//                                       subtitle: Text(
//                                         confession['createdAt']
//                                             .toDate()
//                                             .toString(), // Assuming 'createdAt' is a Timestamp
//                                       ),
//                                     ),
//                                     Text(
//                                       confession['message'] ?? "No message available",
//                                       style: Theme.of(context).textTheme.displayMedium,
//                                     ),
//                                     const SizedBox(height: 10),
//                                     if (mediaPath.isNotEmpty)
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(vertical: 10),
//                                         child: mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov')
//                                             ? // Video player if the file is a video
//                                               Container(
//                                                 width: double.infinity,
//                                                 height: 200,
//                                                 child: VideoPlayerWidget(mediaPath: mediaPath),
//                                               )
//                                             : // Image if the file is an image
//                                               ClipRRect(
//                                                 borderRadius: BorderRadius.circular(8.0),
//                                                 child: Image.file(
//                                                   File(mediaPath),
//                                                   width: double.infinity,
//                                                   height: 200,
//                                                   fit: BoxFit.cover,
//                                                   errorBuilder: (context, error, stackTrace) {
//                                                     return const Center(
//                                                       child: Text("Image failed to load"),
//                                                     );
//                                                   },
//                                                 ),
//                                               ),
//                                       ),
//                                     const SizedBox(height: 20),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class VideoPlayerWidget extends StatefulWidget {
//   final String mediaPath;
//
//   const VideoPlayerWidget({super.key, required this.mediaPath});
//
//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }
//
// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.file(File(widget.mediaPath))
//       ..initialize().then((_) {
//         setState(() {}); // Ensure the first frame is shown before playing
//       });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _controller.value.isInitialized
//         ? AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           )
//         : const Center(child: CircularProgressIndicator());
//   }
// }






import 'dart:convert';
import 'package:intl/intl.dart';  // Import the intl package

class Confessions extends StatelessWidget {
  const Confessions({super.key});

  // Cache confessions in the local database
  Future<void> cacheConfessions(List<QueryDocumentSnapshot> confessions, List<Map<String, dynamic>> cachedConfessions) async {
    final db = DatabaseHelper();
    Set<String> cachedIds = cachedConfessions.map((e) => e['id'] as String ?? "").toSet();

    for (var confession in confessions) {
      if (!cachedIds.contains(confession.id)) {
        DateTime createdAt = confession['createdAt'] is Timestamp
            ? (confession['createdAt'] as Timestamp).toDate()
            : DateTime.parse(confession['createdAt'].toString()); // Handle conversion properly

        await db.insertPost('confessions', {
          'id': confession.id ?? "",
          'message': confession['message'] ?? '',
          'mediaPath': confession['mediaUrl'] is Map<String, dynamic>
              ? jsonEncode(confession['mediaUrl'])
              : confession['mediaUrl'] ?? '',
          'createdAt': createdAt.toString(),  // Store the formatted date string
          'userId': confession['userId'] ?? '',
        });
      }
    }
  }

  // Fetch cached confessions
  Future<List<Map<String, dynamic>>> getCachedConfessions() async {
    final db = DatabaseHelper();
    return await db.getCachedPosts('confessions');
  }

  // Format Timestamp to a readable date string
  String formatTimestamp(Timestamp timestamp) {
    final DateFormat formatter = DateFormat('dd MMM yyyy HH:mm'); // Adjust format as needed
    return formatter.format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.5,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All view",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.blue),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateConfessionScreen()));
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
            child: FutureBuilder<List<Map<String, dynamic>>>(  // Get cached confessions first
              future: getCachedConfessions(),
              builder: (context, cacheSnapshot) {
                if (cacheSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (cacheSnapshot.hasError) {
                  return const Center(child: Text('Something went wrong!'));
                }

                List<Map<String, dynamic>> cachedConfessions = cacheSnapshot.data ?? [];

                return StreamBuilder<QuerySnapshot>(  // Live Firestore data stream
                  stream: FirebaseFirestore.instance
                      .collection('confessions')
                      .where('status', isEqualTo: 'approved')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting && cachedConfessions.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong!'));
                    }

                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      // Cache newly fetched confessions
                      cacheConfessions(snapshot.data!.docs, cachedConfessions);
                      return _buildConfessionList(snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList(), currentUserId);
                    }

                    return _buildConfessionList(cachedConfessions, currentUserId);  // Fallback to cached data
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfessionList(List<Map<String, dynamic>> confessions, String? currentUserId) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: confessions.length,
      itemBuilder: (context, index) {
        var confession = confessions[index];
        String? mediaPath = confession['mediaPath'] ?? "";
        String? postOwnerId = confession['userId'] ?? "";

        // Check if 'createdAt' is a Timestamp
        String formattedDate = "";
        if (confession['createdAt'] is Timestamp) {
          formattedDate = formatTimestamp(confession['createdAt'] as Timestamp);
        } else {
          formattedDate = confession['createdAt'] ?? '';  // Fallback if the field is not available
        }

        return Dismissible(
          key: Key(confession['id'] ?? ""),
          direction: currentUserId == postOwnerId
              ? DismissDirection.endToStart
              : DismissDirection.none,
          onDismissed: (direction) async {
            await FirebaseFirestore.instance.collection('confessions').doc(confession['id']).delete();
            await DatabaseHelper().deletePost('confessions', confession['id']);
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
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(confession['profilePic'] ?? 'assets/profile_placeholder.png'),
                    ),
                    title: const Text('Anonymous'),
                    subtitle: Text(formattedDate),  // Display the formatted date
                  ),
                  Text(
                    confession['message'] ?? "No message available",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  if (mediaPath!.isNotEmpty) MediaViewer(mediaPath: mediaPath),
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





