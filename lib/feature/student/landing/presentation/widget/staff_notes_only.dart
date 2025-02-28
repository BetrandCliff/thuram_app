


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/feature/student/landing/presentation/widget/confersions.dart';
import '../../../../../core/constants/asset-paths.dart';
import '../../../../../util/next-screen.dart';
import '../../../../../util/video-player.dart';
import '../pages/profile.dart';
import 'post_lost_items.dart';  // Import the Create Post screen

import 'package:sqflite/sqflite.dart';

class PersonalMissingItemsPost extends StatelessWidget {
  const PersonalMissingItemsPost({super.key, required this.userId});
    final String userId;
  // Function to delete post from SQLite


  @override
  Widget build(BuildContext context) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Column(
      children: [

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            // Query now filters posts by the given userId
            stream: FirebaseFirestore.instance
                .collection('lostFoundPosts')
                .where('userId', isEqualTo: currentUserId) // Filter posts by currentUserId
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Empty'));
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
                  String? mediaPath = post['mediaPath'];
                  // String? postOwnerId = post['userId'];

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
                                    post['profilePic'] ??
                                        AppImages.profile),
                              ),
                              title: Text(post['userName'] ?? "Anonymous"),
                              subtitle: Text(
                                  post['createdAt'].toDate().toString()),
                            ),
                            Text(
                              post['message'],
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium,
                            ),
                            const SizedBox(height: 20),
                            if (mediaPath != null && mediaPath.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10),
                                child: mediaPath.endsWith('.mp4') ||
                                    mediaPath.endsWith('.mov')
                                    ? Container(
                                  width: double.infinity,
                                  height: 200,
                                  child: VideoPlayerWidget(
                                      mediaPath: mediaPath),
                                )
                                    : ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(8.0),
                                  child: Image.file(
                                    File(mediaPath),
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const Center(
                                        child: Text(
                                            "Image failed to load"),
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
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
