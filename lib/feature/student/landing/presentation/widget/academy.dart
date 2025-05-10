import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/util/next-screen.dart';

import '../../../../../core/constants/asset-paths.dart';

import '../../../../../util/mediaviewer.dart';
import '../../../../../util/video-player.dart';
import '../../../../admin/presentations/database/db.dart';
import '../pages/profile.dart';
import 'academy_post.dart';
import 'dart:convert';


class Academy extends StatefulWidget {
  const Academy({super.key});

  @override
  State<Academy> createState() => _AcademyState();
}

class _AcademyState extends State<Academy> {
  final TextEditingController commentController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  bool isCaching = false;
  Map<String, bool> postVisibilityMap = {}; // Track visibility for each post

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _dbHelper.getCachedAcademicPosts(),
            builder: (context, cacheSnapshot) {
              if (cacheSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (cacheSnapshot.hasError) {
                return const Center(child: Text('Something went wrong!'));
              }

              print("ACADEMY ${cacheSnapshot.data }");
              List<Map<String, dynamic>> cachedPosts = cacheSnapshot.data ?? [];
              print("ACADEMY $cachedPosts");
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('academy')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      cachedPosts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong!'));
                  }

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    _cachePosts(snapshot.data!.docs,
                        cachedPosts); // Cache posts from Firebase
                    return _buildPostList(snapshot.data!.docs
                        .map((doc) =>
                            Map<String, dynamic>.from(doc.data() as Map))
                        .toList());
                  }
                  print("ACADEMY2  $cachedPosts");
                  return _buildPostList(cachedPosts);
                },
              );
            },
          ),
        ),
      ],
    );
  }

// Import this for JSON encoding

 // Import for JSON encoding

  Future<void> _cachePosts(List<QueryDocumentSnapshot> firebaseDocs, List<Map<String, dynamic>> cachedPosts) async {
    final Set<String> cachedPostIds = cachedPosts.map((post) => post['id'].toString()).toSet();

    for (var doc in firebaseDocs) {
      String postId = doc.id;

      // if (cachedPostIds.contains(postId)) {
      //   continue; // Skip already cached posts
      // }

      var postData = doc.data();
      if (postData == null || postData is! Map<String, dynamic>) {
        print("Skipping invalid post: $postId");
        continue;
      }

      postData['id'] = postId;

      // Ensure 'createdAt' is stored correctly
      if (postData['createdAt'] is Timestamp) {
        postData['createdAt'] = (postData['createdAt'] as Timestamp).toDate().toString();
      } else if (postData['createdAt'] == null) {
        postData['createdAt'] = DateTime.now().toString();
      }

      // ✅ Store comments & likes as JSON strings
      postData['comments'] = jsonEncode(postData['comments'] ?? []);
      postData['likes'] = jsonEncode(postData['likes'] ?? []);

      try {
        print("FINAL CACHED POST  $postData");
        await _dbHelper.insertAcademicPost(postData);
        print("✅ Cached post: $postId");
      } catch (e) {
        print("❌ Error caching post $postId: $e");
      }
    }
  }




  Widget _buildPostList(List<Map<String, dynamic>> posts) {
    print("\n\n\n  ALL POSTS ${posts[0]}");
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        print("ITEM INDEXIS  $index");
        var post = posts[index];
        print("THIS IS THE POST  $post");
        print('POST CONTAINS ID ${post.containsKey('id')}');
        String postId = post.containsKey('id') ? post['id'].toString() : "";

        print("ITEM ID IS ${postId}");
        String postOwnerId = post['userId']?.toString() ?? "";
        String mediaPath = post['mediaPath']?.toString() ?? "";

        return Dismissible(
          key: Key(postId),
          direction: currentUserId == postOwnerId
              ? DismissDirection.endToStart
              : DismissDirection.none,
          onDismissed: (direction) async {
            await FirebaseFirestore.instance
                .collection('academy')
                .doc(postId)
                .delete();
            await _dbHelper.deletePost('academy_posts', postId);
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
                    title: Text(post['name']?.toString() ?? 'Unknown'),
                  ),
                  Text(post['message']?.toString() ?? '',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  Text("Post id  $postId"),
                  if (mediaPath.isNotEmpty) MediaViewer(mediaPath: mediaPath),
                  Row(
                    children: [
                      LikeButton(
                          postId: postId.isEmpty? "wZhB30BDFy6tvFzj26B9":postId,
                          currentUserId: currentUserId),
                      CommentButton(
                        postId: postId.isEmpty? "wZhB30BDFy6tvFzj26B9":postId,
                        onCommentTapped: () {
                          setState(() {
                            postVisibilityMap[postId.isEmpty? "wZhB30BDFy6tvFzj26B9":postId] =
                                !(postVisibilityMap[postId.isEmpty? "wZhB30BDFy6tvFzj26B9":postId] ?? false);
                          });
                        },
                      ),
                    ],
                  ),
                  if (postVisibilityMap[postId.isEmpty? "wZhB30BDFy6tvFzj26B9":postId] ?? false)
                    CommentSection(
                        postId: postId.isEmpty? "wZhB30BDFy6tvFzj26B9":postId,
                        commentController: commentController),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.topRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("All view",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: Colors.blue)),
          GestureDetector(
            onTap: () => nextScreen(
                context, AcademyPostScreen()), // Navigate to AcademyPostScreen
            child: Text("Create Post",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}class CommentButton extends StatelessWidget {
  final VoidCallback onCommentTapped;
  final String postId;

  const CommentButton({Key? key, required this.onCommentTapped, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('academy_posts') // ✅ Fixed Firestore collection name
          .doc(postId)
          .collection('comments')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: onCommentTapped,
              ),
              Text("Loading..."), // ✅ Show loading state
            ],
          );
        }

        if (snapshot.hasError) {
          return Column(
            children: [
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: onCommentTapped,
              ),
              Text("Error"), // ✅ Handle errors
            ],
          );
        }

        int commentCount = snapshot.data?.docs.length ?? 0;

        return Column(
          children: [
            IconButton(
              icon: Icon(Icons.comment),
              onPressed: onCommentTapped,
            ),
            Text("$commentCount comments"), // ✅ Fixed dynamic comment count
          ],
        );
      },
    );
  }
}

class CommentSection extends StatefulWidget {
  final String postId;
  final TextEditingController commentController;

  CommentSection({required this.postId, required this.commentController});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  int commentLimit = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('academy_posts') // ✅ Fixed Firestore collection name
              .doc(widget.postId)
              .collection('comments')
              .orderBy('createdAt', descending: true)
              .limit(commentLimit)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            var comments = snapshot.data!.docs;
            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    var comment = comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 15,
                        backgroundImage: (comment['profilePic'] == null || comment['profilePic'].isEmpty) // ✅ Fixed empty profilePic check
                            ? AssetImage(AppImages.profile) as ImageProvider
                            : NetworkImage(comment['profilePic']),
                      ),
                      title: Text(comment['text']),
                      subtitle: Text(
                          comment['createdAt']?.toDate().toString() ?? 'Just now'),
                    );
                  },
                ),
                if (comments.length >= commentLimit)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        commentLimit += 5;
                      });
                    },
                    child: Text("View More"),
                  ),
              ],
            );
          },
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width / 8),
          child: TextField(
            controller: widget.commentController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (widget.commentController.text.isNotEmpty) {
                    FirebaseFirestore.instance
                        .collection('academy_posts') // ✅ Fixed Firestore collection name
                        .doc(widget.postId)
                        .collection('comments')
                        .add({
                      'profilePic': FirebaseAuth.instance.currentUser?.photoURL ?? "",
                      'text': widget.commentController.text,
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                    widget.commentController.clear();
                  }
                },
              ),
              hintStyle: Theme.of(context).textTheme.displaySmall,
              hintText: 'Add a comment...',
            ),
          ),
        ),
      ],
    );
  }
}


class LikeButton extends StatelessWidget {
  final String postId;
  final String? currentUserId;

  LikeButton({required this.postId, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('academy')
          .doc(postId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        var data = snapshot.data!.data() as Map<String, dynamic>;
        List<String> likes = List<String>.from(data['likes'] ?? []);
        bool isLiked = likes.contains(currentUserId);

        return Column(
          children: [
            IconButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('academy')
                    .doc(postId)
                    .update({
                  'likes': isLiked
                      ? FieldValue.arrayRemove([currentUserId])
                      : FieldValue.arrayUnion([currentUserId])
                });
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
    );
  }
}

class CommentCount extends StatelessWidget {
  final String postId;

  CommentCount({required this.postId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('academy')
          .doc(postId)
          .collection('comments')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text("0 comments");
        int commentCount = snapshot.data!.docs.length;
        return Text("$commentCount comments");
      },
    );
  }
}



/*
class Academy extends StatefulWidget {
  const Academy({super.key});

  @override
  State<Academy> createState() => _AcademyState();
}

class _AcademyState extends State<Academy> {
  TextEditingController commentController = TextEditingController();
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  bool showComments = false;
  String? selectedPostId;
DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("All view", style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.blue)),
              GestureDetector(
                onTap: () => nextScreen(context, AcademyPostScreen()),
                child: Text("Create Post", style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.blue)),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _dbHelper.getCachedAcademicPosts(),
            builder: (context, cacheSnapshot) {
              if (cacheSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (cacheSnapshot.hasError) {
                return const Center(child: Text('Something went wrong!'));
              }

              List<Map<String, dynamic>> cachedPosts = cacheSnapshot.data ?? [];

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('academy').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting && cachedPosts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong!'));
                  }

                  List<Map<String, dynamic>> posts = snapshot.hasData && snapshot.data!.docs.isNotEmpty
                      ? snapshot.data!.docs.map((doc) => Map<String, dynamic>.from(doc.data() as Map)).toList()
                      : cachedPosts;

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      var post = posts[index];
                      String postId = post['id'] ?? '';
                      String name = post['name'] ?? 'Unknown';
                      String profilePic = post['profilePic'] ?? 'default_profile.png';
                      String message = post['message'] ?? '';
                      String mediaPath = post['mediaPath'] ?? '';
                      Timestamp? createdAt = post['createdAt'];

                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(name),
                                subtitle: Text(createdAt != null ? createdAt.toDate().toString() : 'Unknown date'),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(profilePic),
                                ),
                                onTap: () => nextScreen(context, ProfilePage(userId: post['userId'] ?? '')),
                              ),
                              Text(message, style: Theme.of(context).textTheme.displayMedium),
                              if (mediaPath.isNotEmpty)
                                mediaPath.endsWith('.mp4')
                                    ? VideoPlayerWidget(mediaPath: mediaPath)
                                    : Image.file(File(mediaPath), fit: BoxFit.cover),
                              Row(
                                children: [
                                  LikeButton(postId: postId, currentUserId: currentUserId),
                                  CommentButton(
                                    postId: postId,
                                    onCommentTapped: () {
                                      setState(() {
                                        showComments = selectedPostId == postId ? !showComments : true;
                                        selectedPostId = postId;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              if (showComments && selectedPostId == postId)
                                Column(
                                  children: [
                                    CommentList(postId: postId),
                                    CommentInput(postId: postId, controller: commentController),
                                  ],
                                ),
                            ],
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
    );
  }
}

class CommentButton extends StatelessWidget {
  final VoidCallback onCommentTapped;
  final String postId;

  CommentButton({required this.onCommentTapped, required this.postId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('academy').doc(postId).collection('comments').snapshots(),
      builder: (context, snapshot) {
        int commentCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
        return Column(
          children: [
            IconButton(icon: Icon(Icons.comment), onPressed: onCommentTapped),
            Text("$commentCount comments"),
          ],
        );
      },
    );
  }
}

class CommentList extends StatelessWidget {
  final String postId;

  CommentList({required this.postId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('academy').doc(postId).collection('comments').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        var comments = snapshot.data!.docs;

        return SizedBox(
          height: comments.isNotEmpty ? 150 : 0,
          child: ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, i) {
              var comment = comments[i];
              return ListTile(
                leading: CircleAvatar(),
                title: Text(comment['text']),
              );
            },
          ),
        );
      },
    );
  }
}

class CommentInput extends StatelessWidget {
  final String postId;
  final TextEditingController controller;

  CommentInput({required this.postId, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Add a comment...', border: OutlineInputBorder()),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () async {
            if (controller.text.isNotEmpty) {
              await FirebaseFirestore.instance.collection('academy').doc(postId).collection('comments').add({
                'text': controller.text,
                'createdAt': FieldValue.serverTimestamp(),
              });
              controller.clear();
            }
          },
        ),
      ],
    );
  }
}


class LikeButton extends StatelessWidget {
  final String postId;
  final String? currentUserId;

  LikeButton({required this.postId, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('academy')
          .doc(postId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        var data = snapshot.data!.data() as Map<String, dynamic>;
        List<String> likes = List<String>.from(data['likes'] ?? []);
        bool isLiked = likes.contains(currentUserId);

        return Column(
          children: [
            IconButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('academy')
                    .doc(postId)
                    .update({
                  'likes': isLiked
                      ? FieldValue.arrayRemove([currentUserId])
                      : FieldValue.arrayUnion([currentUserId])
                });
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
    );
  }
}
*/
