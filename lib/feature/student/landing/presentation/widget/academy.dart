

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/util/next-screen.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../util/video-player.dart';
import '../pages/profile.dart';
import 'academy_post.dart';
class Academy extends StatefulWidget {
  const Academy({super.key});

  @override
  State<Academy> createState() => _AcademyState();
}

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
                            if (mediaPath != null && mediaPath.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov')
                                    ? VideoPlayerWidget(mediaPath: mediaPath)
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    mediaPath,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(child: Text("Image failed to load"));
                                    },
                                  ),
                                ),
                              ),
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
                        backgroundImage: AssetImage(AppImages.profile),),
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
              for(int  i=0; i<posts.length; i++){

              }
              return SizedBox(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    var post = posts[index];
                    String? mediaPath = post['mediaPath'];
                    String postOwnerId = post['userId']; // Ensure the post has userId field

                    return Dismissible(
                      key: Key(post.id),
                      direction: currentUserId == postOwnerId
                          ? DismissDirection.endToStart
                          : DismissDirection.none, // Allow swipe only if user owns the post
                      onDismissed: (direction) async {
                        // Delete the post and its comments
                        await FirebaseFirestore.instance.collection('academy').doc(post.id).delete();
                        await FirebaseFirestore.instance
                            .collection('academy')
                            .doc(post.id)
                            .collection('comments')
                            .get()
                            .then((snapshot) {
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
                                  onTap: () {

                                    nextScreen(context, ProfilePage(userId: post['userId'] ,));
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
                                if (mediaPath != null && mediaPath.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov')
                                        ? Container(
                                      width: double.infinity,
                                      // height: 200,
                                      child: VideoPlayerWidget(mediaPath: mediaPath),
                                    )
                                        : ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        File(mediaPath),
                                        width: double.infinity,
                                        // height: 200,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Center(
                                            child: Text("Image failed to load"),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance.collection('academy').doc(post.id).snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) return CircularProgressIndicator();

                                            var data = snapshot.data!.data() as Map<String, dynamic>;

                                            List<String> likes = [];
                                            if (data['likes'] is List<dynamic>) {
                                              likes = List<String>.from(data['likes']);
                                            }

                                            bool isLiked = likes.contains(currentUserId);

                                            return Column(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    if (!isLiked) {
                                                      FirebaseFirestore.instance.collection('academy').doc(post.id).update({
                                                        'likes': FieldValue.arrayUnion([currentUserId])
                                                      });
                                                    } else {
                                                      FirebaseFirestore.instance.collection('academy').doc(post.id).update({
                                                        'likes': FieldValue.arrayRemove([currentUserId])
                                                      });
                                                    }
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
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              showComments = !showComments;
                                              commentIndex = index;
                                            });

                                            print("CURRENT TAPPED COMMENT IS  $commentIndex");
                                          },
                                          icon: const Icon(Icons.message),
                                        ),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('academy')
                                              .doc(post.id)
                                              .collection('comments')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) return CircularProgressIndicator();

                                            var comments = snapshot.data!.docs;
                                            return Text("${comments.length} comments");
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                if (showComments &&commentIndex==index)
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('academy')
                                        .doc(post.id)
                                        .collection('comments')
                                        .orderBy('createdAt', descending: true)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) return CircularProgressIndicator();

                                      var comments = snapshot.data!.docs;

                                      return SizedBox(
                                        height: comments.isNotEmpty ? 150 : 0,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: comments.length,
                                          itemBuilder: (context, i) {
                                            var comment = comments[i];

                                            return Dismissible(
                                              key: Key(comment.id),
                                              direction: DismissDirection.endToStart,
                                              onDismissed: (direction) async {
                                                await FirebaseFirestore.instance
                                                    .collection('academy')
                                                    .doc(post.id)
                                                    .collection('comments')
                                                    .doc(comment.id)
                                                    .delete();
                                              },
                                              background: Container(
                                                color: Colors.red,
                                                alignment: Alignment.centerRight,
                                                padding: EdgeInsets.only(right: 16),
                                                child: Icon(Icons.delete, color: Colors.white),
                                              ),
                                              child: ListTile(
                                                onTap: (){

                                                },
                                                leading: CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(post['profilePic'] ?? AppImages.profile),
                                                ),
                                                title: Text(comment['text']),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),

                                // Add comment input field and button
                                if (showComments &&commentIndex==index)
                                  Row(
                                    children: [


                                      Expanded(
                                        child: TextField(
                                          controller: commentController,
                                          decoration: InputDecoration(
                                            hintStyle: Theme.of(context).textTheme.displayMedium,
                                            hintText: 'Add a comment...',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.send),
                                        onPressed: () async {
                                          if (commentController.text.isNotEmpty) {
                                            await FirebaseFirestore.instance.collection('academy').doc(post.id).collection('comments').add({
                                              'text': commentController.text,
                                              'createdAt': FieldValue.serverTimestamp(),
                                            });

                                            commentController.clear();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}*/



/*
class _AcademyState extends State<Academy> {
  TextEditingController commentController = TextEditingController();
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  bool showComments = false; // Variable to toggle comment section visibility
  int commentIndex =-1;
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
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.blue),
                ),
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

                  return GestureDetector(
                    onTap: () {},
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
                                onTap: () {
                                  nextScreen(context, ProfilePage());
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
                                      : 
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
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance.collection('academy').doc(post.id).snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) return CircularProgressIndicator();

                                          var data = snapshot.data!.data() as Map<String, dynamic>;

                                          List<String> likes = [];
                                          if (data['likes'] is List<dynamic>) {
                                            likes = List<String>.from(data['likes']);
                                          }

                                          bool isLiked = likes.contains(currentUserId);

                                          return Column(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  if (!isLiked) {
                                                    FirebaseFirestore.instance.collection('academy').doc(post.id).update({
                                                      'likes': FieldValue.arrayUnion([currentUserId])
                                                    });
                                                  } else {
                                                    FirebaseFirestore.instance.collection('academy').doc(post.id).update({
                                                      'likes': FieldValue.arrayRemove([currentUserId])
                                                    });
                                                  }
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
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showComments = !showComments; // Toggle comment section visibility
                                            commentIndex=index;
                                          });

                                          print("CURRENT TAPPED COMMENT IS  $commentIndex");
                                        },
                                        icon: const Icon(Icons.message),
                                      ),
                                      // Show the number of comments below the message icon
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('academy')
                                            .doc(post.id)
                                            .collection('comments')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) return CircularProgressIndicator();

                                          var comments = snapshot.data!.docs;
                                          return Text("${comments.length} comments");
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Only show comments if showComments is true
                              if (showComments &&commentIndex==index)
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('academy')
                                      .doc(post.id)
                                      .collection('comments')
                                      .orderBy('createdAt', descending: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) return CircularProgressIndicator();

                                    var comments = snapshot.data!.docs;

                                    return SizedBox(
                                      height: comments.isNotEmpty ? 150 : 0,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: comments.length,
                                        itemBuilder: (context, i) {
                                          var comment = comments[i];

                                          return Dismissible(
                                            key: Key(comment.id),
                                            direction: DismissDirection.endToStart,
                                            onDismissed: (direction) async {
                                              await FirebaseFirestore.instance
                                                  .collection('academy')
                                                  .doc(post.id)
                                                  .collection('comments')
                                                  .doc(comment.id)
                                                  .delete();
                                            },
                                            background: Container(
                                              color: Colors.red,
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.only(right: 16),
                                              child: Icon(Icons.delete, color: Colors.white),
                                            ),
                                            child: ListTile(
                                              onTap: (){
                                                
                                              },
                                              leading: CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(post['profilePic'] ?? AppImages.profile),
                                              ),
                                              title: Text(comment['text']),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              // Add comment input field and button
                              if (showComments &&commentIndex==index)
                                Row(
                                  children: [


                                    Expanded(
                                      child: TextField(
                                        controller: commentController,
                                        decoration: InputDecoration(
                                          hintStyle: Theme.of(context).textTheme.displayMedium,
                                          hintText: 'Add a comment...',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () async {
                                        if (commentController.text.isNotEmpty) {
                                          await FirebaseFirestore.instance.collection('academy').doc(post.id).collection('comments').add({
                                            'text': commentController.text,
                                            'createdAt': FieldValue.serverTimestamp(),
                                          });

                                          commentController.clear();
                                        }
                                      },
                                    ),
                                  ],
                                ),
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
    );
  }
}
*/

