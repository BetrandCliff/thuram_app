import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/asset-paths.dart';
import '../../../../../util/next-screen.dart';
import '../../../../../util/video-player.dart';
import '../../../../../util/widthandheight.dart';
import '../../../../admin/presentations/database/db.dart';
import '../pages/profile.dart';
import 'create_club_post.dart';
import 'package:sqflite/sqflite.dart';

class PersonalClubsAndPost extends StatelessWidget {
  const PersonalClubsAndPost({super.key, required this.isStudent, required this.userId});
  final bool isStudent;
  final String userId;

  // Future<String?> _getMediaPathFromDb(int mediaId) async {
  //   final db = await DatabaseHelper().database;
  //   final List<Map<String, dynamic>> mediaRecords = await db.query(
  //     'club_posts',
  //     where: 'id = ?',
  //     whereArgs: [mediaId],
  //   );
  //   if (mediaRecords.isNotEmpty) {
  //     return mediaRecords.first['mediaPath'] as String?;
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(context) / 2.5,
      child: Column(
        children: [

          SizedBox(
            height: height(context) / 2.5,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('clubPosts')
                  .where('userId', isEqualTo: userId) // Fetch only the posts of this user
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Bad Network'));
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
                    String mediaPath = post['mediaUrl'] ?? "";
                    return Container(
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
                                title: Text("${post['userName'] ?? "Anonymous"}"),
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
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    );


                    // return FutureBuilder<String?>(
                    //   future: _getMediaPathFromDb(mediaId),
                    //   builder: (context, mediaSnapshot) {
                    //     if (mediaSnapshot.connectionState == ConnectionState.waiting) {
                    //       return Center(child: CircularProgressIndicator());
                    //     }
                    //
                    //     if (mediaSnapshot.hasError || !mediaSnapshot.hasData) {
                    //       return Center(child: Text('Empty'));
                    //     }
                    //
                    //     String mediaPath = mediaSnapshot.data ?? "";
                    //
                    //
                    //   },
                    // );
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
