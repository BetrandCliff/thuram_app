

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thuram_app/util/next-screen.dart';
import 'package:thuram_app/util/widthandheight.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
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
                    String? mediaPathFromFirebase = confession['mediaPath']; // Path from Firebase Firestore

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
                                // Display video thumbnail or image if available
                                if (mediaPathFromFirebase != null && mediaPathFromFirebase.isNotEmpty)
                                  FutureBuilder<File?>(
                                    future: _generateThumbnailFromSqflite(mediaPathFromFirebase), // Generate thumbnail for video
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      }

                                      if (snapshot.hasError) {
                                        return const Center(child: Text("Error generating thumbnail"));
                                      }

                                      if (snapshot.hasData && snapshot.data != null) {
                                        return Image.file(
                                          snapshot.data!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 200,
                                        );
                                      }

                                      return const SizedBox.shrink(); // No thumbnail, no fallback
                                    },
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

  // Function to generate thumbnail from video path stored in SQLite
  Future<File?>? _generateThumbnailFromSqflite(String mediaPathFromFirebase) async {
    try {
      // Fetch the actual video path from SQLite using the mediaPathFromFirebase
      final database = await openDatabase(join(await getDatabasesPath(), 'confessions.db'));
      final List<Map<String, dynamic>> result = await database.query(
        'confessions', 
        where: 'mediaPath = ?', 
        whereArgs: [mediaPathFromFirebase]
      );
      
      if (result.isNotEmpty) {
        String localVideoPath = result.first['localFilePath']; // Assuming 'localFilePath' stores the local path

        // Generate thumbnail
        final directory = await getTemporaryDirectory();
        final thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: localVideoPath,
          thumbnailPath: directory.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 200,
          quality: 75,
        );

        if (thumbnailPath != null) {
          return File(thumbnailPath); // Return the generated thumbnail file
        }
      }
    } catch (e) {
      print('Error generating video thumbnail: $e');
    }
    return null;
  }
}
*/

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
                    String? mediaPath = confession['mediaPath']; // Check if mediaPath exists

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
                                          FutureBuilder<String>(
                                            future: _generateThumbnail(mediaPath), // Get thumbnail
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return const Center(child: CircularProgressIndicator());
                                              }

                                              if (snapshot.hasError) {
                                                return const Center(child: Text("Error generating thumbnail"));
                                              }

                                              if (snapshot.hasData) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    // You can add functionality here to play the video
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8.0),
                                                    child: Image.file(
                                                      File(snapshot.data!),
                                                      width: double.infinity,
                                                      height: 200,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              }

                                              return const Center(child: Text("No thumbnail available"));
                                            },
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

  // Function to generate thumbnail from video
  Future<String> _generateThumbnail(String videoPath) async {
    final String? thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200, // Width of the thumbnail
      quality: 75, // Quality of the thumbnail
    );

    return thumbnail!;
  }
}
*/



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
                    String? mediaPath = confession['mediaPath']; // Check if mediaPath exists

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



// class Confessions extends StatelessWidget {
//   const Confessions({super.key});

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

//                 if (snapshot.hasError) {
//                    print("Firestore Error: ${snapshot.error}");
//                   return const Center(child: Text('Something went wrong!'));
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text('No approved confessions available.'));
//                 }

//                 var confessions = snapshot.data!.docs;

//                 return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: confessions.length,
//                   itemBuilder: (context, index) {
//                     var confession = confessions[index];
//                     String? imageUrl = confession['imagePath']; // Check if imagePath exists

//                     return GestureDetector(
//                       onTap: () {
//                         nextScreen(context, ProfilePage());
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
//                                   contentPadding: EdgeInsets.zero,
//                                   leading: CircleAvatar(
//                                     radius: 20,
//                                     backgroundImage: NetworkImage(
//                                       confession['profilePic'] ?? AppImages.profile,
//                                     ),
//                                   ),
//                                   title: Text(confession['userName'] ?? 'Anonymous'),
//                                   subtitle: Text(
//                                     confession['createdAt']
//                                         .toDate()
//                                         .toString(), // Assuming 'createdAt' is a Timestamp
//                                   ),
//                                 ),
//                                 Text(
//                                   confession['message'] ?? "No message available",
//                                   style: Theme.of(context).textTheme.displayMedium,
//                                 ),
//                                 const SizedBox(height: 10),
//                                 // Display image if it exists
//                                 if (imageUrl != null && imageUrl.isNotEmpty)
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(vertical: 10),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(8.0),
//                                       child: Image.file(
//                                         File(imageUrl),
//                                         width: double.infinity,
//                                         height: 200,
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (context, error, stackTrace) {
//                                           return const Center(
//                                             child: Text("Image failed to load"),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                 const SizedBox(height: 20),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
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


// class Confessions extends StatelessWidget {
//   const Confessions({super.key,});

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
//                   nextScreen(context, CreateConfessionScreen()); // Navigate to the CreateConfessionScreen
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
//             // height: height(context) / 2.5,
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('confessions') // Adjust to your Firestore collection name
//                   .where('status', isEqualTo: 'approved') // Filter for approved confessions
//                   .orderBy('createdAt', descending: true) // Assuming you have a 'createdAt' field
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return Center(child: Text('Something went wrong!'));
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(child: Text('No approved confessions available.'));
//                 }

//                 var confessions = snapshot.data!.docs;

//                 return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: confessions.length,
//                   itemBuilder: (context, index) {
//                     var confession = confessions[index];
//                     return GestureDetector(
//                       onTap: () {
//                         nextScreen(context, ProfilePage());
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
//                                         confession['profilePic'] ??
//                                             AppImages.profile),
//                                   ),
//                                   title: Text(confession['userName'] ?? 'Anonymous'),
//                                   subtitle: Text(
//                                     confession['createdAt']
//                                         .toDate()
//                                         .toString(), // Assuming 'createdAt' is a Timestamp
//                                   ),
//                                 ),
//                                 Text(
//                                   confession['message'] ?? 
//                                       "No message available", // Assuming 'message' is a field
//                                   style: Theme.of(context).textTheme.displayMedium,
//                                 ),
//                                 const SizedBox(height: 20),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
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

