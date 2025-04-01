import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/util/next-screen.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../util/mediaviewer.dart';
import '../../../../admin/presentations/database/db.dart';
import 'academy_post.dart';
import 'dart:convert';

/*
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

              List<Map<String, dynamic>> cachedPosts = cacheSnapshot.data ?? [];

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
                    _cachePosts(snapshot.data!.docs, cachedPosts);
                    return _buildPostList(snapshot.data!.docs
                        .map((doc) =>
                            Map<String, dynamic>.from(doc.data() as Map))
                        .toList());
                  }

                  return _buildPostList(cachedPosts);
                },
              );
            },
          ),
        ),
      ],
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
            onTap: () => nextScreen(context, AcademyPostScreen()),
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

  void _cachePosts(List<DocumentSnapshot> firestorePosts,
      List<Map<String, dynamic>> cachedPosts) async {
    if (isCaching) return;
    isCaching = true;

    // Build a set of cached IDs ensuring no null/empty values.
    Set<String> cachedIds = cachedPosts
        .map((e) => e['id']?.toString() ?? "")
        .where((id) => id.isNotEmpty)
        .toSet();

    print("THE CACHED IDS: $cachedIds");
    print("FIRESTORE IDS: ${firestorePosts.map((e) => e.id).toList()}");

    for (var post in firestorePosts) {
      if (!cachedIds.contains(post.id)) {
        var data = Map<String, dynamic>.from(post.data() as Map);

        // Convert createdAt from Firestore Timestamp (if available) to String.
        String createdAt;
        if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
          createdAt = (data['createdAt'] as Timestamp).toDate().toString();
        } else {
          createdAt = DateTime.now().toString();
        }
        print("ID THAT IS BEING CACHED ${post.id}");
        await _dbHelper.insertAcademicPost({
          'id': post.id,
          'message': data['message'] ?? '',
          'mediaPath': data['mediaPath'] is Map<String, dynamic>
              ? jsonEncode(data['mediaPath'])
              : (data['mediaPath']?.toString() ?? ''),
          'createdAt': createdAt,
          'userId': data['userId']?.toString() ?? '',
        });
      }
      if (mounted) {
        setState(() {
          isCaching = false;
        });
      }
    }
  }

  Widget _buildPostList(List<Map<String, dynamic>> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        var post = posts[index];
        String postOwnerId = post['userId']?.toString() ?? "";
        String mediaPath = post['mediaPath']?.toString() ?? "";

        return Dismissible(
          key: Key(post['id']?.toString() ?? ""),
          direction: currentUserId == postOwnerId
              ? DismissDirection.endToStart
              : DismissDirection.none,
          onDismissed: (direction) async {
            await FirebaseFirestore.instance
                .collection('academy')
                .doc(post['id'])
                .delete();
            await _dbHelper.deletePost(
                'academy_posts', post['id']?.toString() ?? "");
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
                  if (mediaPath.isNotEmpty) MediaViewer(mediaPath: mediaPath),
                  Row(
                    children: [
                      LikeButton(
                          postId:
                              post['id']?.toString() ?? "",
                          currentUserId: currentUserId),
                      CommentButton(
                          postId:
                              post['id']?.toString() ?? "",
                          onCommentTapped: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
    print("THE COMMENT ID IS: $postId");
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

class SectionButton extends StatelessWidget {
  final String postId;
  SectionButton({required this.postId});

  @override
  Widget build(BuildContext context) {
    print("THE COMMENT ID IS: $postId");
    return IconButton(
      icon: Icon(Icons.bookmark_border),
      onPressed: () {
        // Handle section button action
      },
    );
  }
}

class LikeButton extends StatelessWidget {
  final String postId;
  final String? currentUserId;

  LikeButton({required this.postId, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    print("THE COMMENT ID IS: $postId");
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

class CommentButton extends StatelessWidget {
  final VoidCallback onCommentTapped;
  CommentButton({required this.onCommentTapped, required this.postId});
  final String postId;
  @override
  Widget build(BuildContext context) {
    print("THE COMMENT ID IS: $postId");
    return Column(
      children: [
        IconButton(
          icon: Icon(Icons.comment),
          onPressed: onCommentTapped,
        ),
        CommentCount(
          postId: postId,
        )
      ],
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
  int commentLimit = 5; // Start with 5 comments

  @override
  Widget build(BuildContext context) {
    print("THE COMMENT ID IS: ${widget.postId}");
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('academy')
              .doc(widget.postId)
              .collection('comments')
              .orderBy('createdAt', descending: true)
              .limit(commentLimit) // Limit to first 5 comments
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
                        backgroundImage: comment['profilePic'] != null
                            ? AssetImage(AppImages.profile)
                            : NetworkImage(comment['profilePic']),
                      ),
                      title: Text(comment['text']),
                      subtitle: Text(
                          comment['createdAt']?.toDate().toString() ??
                              'Just now'),
                    );
                  },
                ),
                if (comments.length >= commentLimit)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        commentLimit += 5; // Load 5 more comments
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
          width: MediaQuery.of(context).size.width -
              (MediaQuery.of(context).size.width / 8),
          child: TextField(
            controller: widget.commentController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (widget.commentController.text.isNotEmpty) {
                    FirebaseFirestore.instance
                        .collection('academy')
                        .doc(widget.postId)
                        .collection('comments')
                        .add({
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
*/

/*
class CommentSection extends StatefulWidget {
  final String postId;
  final TextEditingController commentController;

  CommentSection({required this.postId, required this.commentController});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  int commentLimit = 5; // Start with 5 comments

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('academy')
              .doc(widget.postId)
              .collection('comments')
              .orderBy('createdAt', descending: true)
              .limit(commentLimit) // Limit to first 5 comments
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
                        backgroundImage: NetworkImage(comment['userProfilePic']),
                      ),
                      title: Text(comment['userName']),
                      subtitle: Text(comment['comment']),
                    );
                  },
                ),
                if (comments.length == commentLimit)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        commentLimit += 5; // Increase comment limit
                      });
                    },
                    child: Text("Load more comments..."),
                  ),
              ],
            );
          },
        ),
        TextField(
          controller: widget.commentController,
          decoration: InputDecoration(hintText: 'Add a comment...'),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () async {
            if (widget.commentController.text.isNotEmpty) {
              await FirebaseFirestore.instance.collection('academy').doc(widget.postId).collection('comments').add({
                'comment': widget.commentController.text,
                'userId': FirebaseAuth.instance.currentUser!.uid,
                'userName': FirebaseAuth.instance.currentUser!.displayName,
                'userProfilePic': FirebaseAuth.instance.currentUser!.photoURL ?? '',
                'createdAt': FieldValue.serverTimestamp(),
              });
              widget.commentController.clear();
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
      stream: FirebaseFirestore.instance.collection('academy').doc(postId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        var data = snapshot.data!.data() as Map<String, dynamic>;
        List<String> likes = List<String>.from(data['likes'] ?? []);
        bool isLiked = likes.contains(currentUserId);

        return Column(
          children: [
            IconButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('academy').doc(postId).update({
                  'likes': isLiked ? FieldValue.arrayRemove([currentUserId]) : FieldValue.arrayUnion([currentUserId])
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

class CommentButton extends StatelessWidget {
  final String postId;
  final VoidCallback onCommentTapped;

  CommentButton({required this.onCommentTapped, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(Icons.comment),
          onPressed: onCommentTapped,
        ),
        CommentCount(postId: postId),
      ],
    );
  }
}

class CommentCount extends StatelessWidget {
  final String postId;

  CommentCount({required this.postId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('academy').doc(postId).collection('comments').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text("0 comments");
        int commentCount = snapshot.data!.docs.length;
        return Text("$commentCount comments");
      },
    );
  }
}
*/

/*
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
              Text(
                "All view",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.blue),
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
                  String postOwnerId = post['userId'];

                  return Dismissible(
                    key: Key(post.id),
                    direction: currentUserId == postOwnerId ? DismissDirection.endToStart : DismissDirection.none,
                    onDismissed: (direction) async {
                      await FirebaseFirestore.instance.collection('academy').doc(post.id).delete();
                      await FirebaseFirestore.instance.collection('academy').doc(post.id).collection('comments').get().then((snapshot) {
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
                    child: Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              onTap: () {
                                nextScreen(context, ProfilePage(userId: post['userId']));
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
                            MediaViewer(mediaPath: mediaPath??"",),
                            // if (mediaPath != null && mediaPath.isNotEmpty)
                            //   Padding(
                            //     padding: const EdgeInsets.symmetric(vertical: 10),
                            //     child: mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov')
                            //         ? VideoPlayerWidget(mediaPath: mediaPath)
                            //         : ClipRRect(
                            //       borderRadius: BorderRadius.circular(8.0),
                            //       child: Image.network(
                            //         mediaPath,
                            //         width: double.infinity,
                            //         fit: BoxFit.cover,
                            //         errorBuilder: (context, error, stackTrace) {
                            //           return const Center(child: Text("Image failed to load"));
                            //         },
                            //       ),
                            //     ),
                            //   ),
                            Row(
                              children: [
                                LikeButton(postId: post.id, currentUserId: currentUserId),
                                CommentButton(postId: post.id, onCommentTapped: () {
                                  setState(() {
                                    showComments = !showComments;
                                    commentIndex = index;
                                  });

                                }),
                                // CommentCount(postId: post.id),
                                // SectionButton(postId: post.id),
                              ],
                            ),
                            if (showComments && commentIndex == index)
                              CommentSection(postId: post.id, commentController: commentController),
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

class CommentCount extends StatelessWidget {
  final String postId;
  CommentCount({required this.postId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('academy').doc(postId).collection('comments').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text("0 comments");
        int commentCount = snapshot.data!.docs.length;
        return Text("$commentCount comments");
      },
    );
  }
}

class SectionButton extends StatelessWidget {
  final String postId;
  SectionButton({required this.postId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.bookmark_border),
      onPressed: () {
        // Handle section button action
      },
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
      stream: FirebaseFirestore.instance.collection('academy').doc(postId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        var data = snapshot.data!.data() as Map<String, dynamic>;
        List<String> likes = List<String>.from(data['likes'] ?? []);
        bool isLiked = likes.contains(currentUserId);

        return Column(
          children: [
            IconButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('academy').doc(postId).update({
                  'likes': isLiked ? FieldValue.arrayRemove([currentUserId]) : FieldValue.arrayUnion([currentUserId])
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

class CommentButton extends StatelessWidget {
  final VoidCallback onCommentTapped;
  CommentButton({required this.onCommentTapped,required this.postId});
  final String postId;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(Icons.comment),
          onPressed: onCommentTapped,
        ),
        CommentCount(postId: postId,)

      ],
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
  int commentLimit = 5; // Start with 5 comments

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('academy')
              .doc(widget.postId)
              .collection('comments')
              .orderBy('createdAt', descending: true)
              .limit(commentLimit) // Limit to first 5 comments
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
                        backgroundImage:comment['profilePic']==null? AssetImage(AppImages.profile):NetworkImage(comment['profilePic']),),
                      title: Text(comment['text']),
                      subtitle: Text(comment['createdAt']?.toDate().toString() ?? 'Just now'),
                    );
                  },
                ),
                if (comments.length >= commentLimit)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        commentLimit += 5; // Load 5 more comments
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
                        .collection('academy')
                        .doc(widget.postId)
                        .collection('comments')
                        .add({
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

*/



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

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    _cachePosts(snapshot.data!.docs, cachedPosts); // Cache posts from Firebase
                    return _buildPostList(snapshot.data!.docs.map((doc) =>
                    Map<String, dynamic>.from(doc.data() as Map)).toList());
                  }

                  return _buildPostList(cachedPosts);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Define the method to cache posts from Firebase
  Future<void> _cachePosts(List<QueryDocumentSnapshot> firebaseDocs, List<Map<String, dynamic>> cachedPosts) async {
    for (var doc in firebaseDocs) {
      String postId = doc.id;
      // Check if this post is already cached
      bool isPostCached = cachedPosts.any((post) => post['id'] == postId);
        print("cached post id $postId");
      print("cached post id $isPostCached");
      if (!isPostCached) {
        // Create a new post to save into the local database
        print("Inserting Post");
        var post = doc.data() as Map<String, dynamic>;
        print("Adding postId $postId");
        post['id'] = postId;

        print("Each post $post");// Add post ID to the post data
        await _dbHelper.insertPost('academy_posts', post); // Cache the post locally
      }
    }
  }

  Widget _buildPostList(List<Map<String, dynamic>> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        var post = posts[index];
        String postId = post['id']?.toString() ?? "";

        String postOwnerId = post['userId']?.toString() ?? "";
        String mediaPath = post['mediaPath']?.toString() ?? "";

        return Dismissible(
          key: Key(postId),
          direction: currentUserId == postOwnerId ? DismissDirection.endToStart : DismissDirection.none,
          onDismissed: (direction) async {
            await FirebaseFirestore.instance.collection('academy').doc(postId).delete();
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
                  Text(post['message']?.toString() ?? '', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  Text("Post id Id $postId"),
                  if (mediaPath.isNotEmpty) MediaViewer(mediaPath: mediaPath),
                  Row(
                    children: [
                      LikeButton(postId: "NKUdiNZJf4WNpzsK10Nc", currentUserId: currentUserId),
                      CommentButton(
                        postId: postId,
                        onCommentTapped: () {
                          setState(() {
                            postVisibilityMap[postId] = !(postVisibilityMap[postId] ?? false);
                          });
                        },
                      ),
                    ],
                  ),
                  if (postVisibilityMap[postId] ?? false)
                    CommentSection(postId: "NKUdiNZJf4WNpzsK10Nc", commentController: commentController),
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
            onTap: () => nextScreen(context, AcademyPostScreen()), // Navigate to AcademyPostScreen
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

}

class CommentButton extends StatelessWidget {
  final VoidCallback onCommentTapped;
  final String postId;
  CommentButton({required this.onCommentTapped, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(Icons.comment),
          onPressed: onCommentTapped,
        ),
      ],
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
              .collection('academy')
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
                        backgroundImage: comment['profilePic'] != null
                            ? AssetImage(AppImages.profile)
                            : NetworkImage(comment['profilePic']),
                      ),
                      title: Text(comment['text']),
                      subtitle: Text(comment['createdAt']?.toDate().toString() ?? 'Just now'),
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
                        .collection('academy')
                        .doc(widget.postId)
                        .collection('comments')
                        .add({
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


