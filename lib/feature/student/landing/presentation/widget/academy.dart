import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/util/next-screen.dart';
import 'package:thuram_app/util/widthandheight.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
import '../pages/profile.dart';

class Academy extends StatefulWidget {
  const Academy({super.key});

  @override
  State<Academy> createState() => _AcademyState();
}

class _AcademyState extends State<Academy> {
  late List<int> likes;
  late List<bool> isTapped;
  late List<List<String>> likedUsers;
  late List<List<String>> messages;
  bool showLikes = false;
  bool showMessages = false;
  int tapPostLikes = 0;
  int tapPostMessages = 0;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    likes = List.filled(5, 0);
    isTapped = List.filled(5, false);
    likedUsers = List.generate(5, (index) => []);
    messages = List.generate(5, (index) => []);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                nextScreen(context, ProfilePage());
              },
              child: Text(
                "All view",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.blue),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                nextScreen(context, ProfilePage());
                              },
                              contentPadding: EdgeInsets.all(0),
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(AppImages.profile),
                              ),
                              title: Text("Thuram"),
                              subtitle: Text("4 hours ago"),
                            ),
                            Text(
                              "I have found that credit card at the platform and dropped it at the Lost & Found office",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (isTapped[index]) {
                                            likes[index]--;
                                            isTapped[index] = false;
                                            likedUsers[index].remove('User ${index + 1}');
                                          } else {
                                            likes[index]++;
                                            isTapped[index] = true;
                                            likedUsers[index].add('User ${index + 1}');
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        isTapped[index] ? Icons.favorite : Icons.favorite_border,
                                        color: isTapped[index] ? Colors.red : Colors.grey,
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "${likes[index]}",
                                            style: Theme.of(context).textTheme.displaySmall,
                                          ),
                                          TextSpan(
                                            text: " likes",
                                            style: Theme.of(context).textTheme.displaySmall,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                setState(() {
                                                  showLikes = !showLikes;
                                                  showMessages = false;
                                                  tapPostLikes = index;
                                                });
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showMessages = !showMessages;
                                          showLikes = false;
                                          tapPostMessages = index;
                                        });
                                      },
                                      icon: const Icon(Icons.message),
                                    ),
                                    Text(
                                      "${messages[index].length}",
                                      style: Theme.of(context).textTheme.displaySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (showLikes && index == tapPostLikes)
                              SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  itemCount: likedUsers[index].length.clamp(0, 3),
                                  itemBuilder: (context, i) => ListTile(
                                    leading: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage(AppImages.profile),
                                    ),
                                    title: Text(
                                      likedUsers[index][i],
                                      style: Theme.of(context).textTheme.displayMedium,
                                    ),
                                  ),
                                ),
                              ),
                            if (showMessages && index == tapPostMessages)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: commentController,
                                          decoration: InputDecoration(
                                            hintText: 'Add a comment...',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.send),
                                        onPressed: () {
                                          setState(() {
                                            if (commentController.text.isNotEmpty) {
                                              messages[index].add(commentController.text);
                                              commentController.clear();
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      itemCount: messages[index].length.clamp(0, 3),
                                      itemBuilder: (context, i) => ListTile(
                                        leading: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: AssetImage(AppImages.profile),
                                        ),
                                        title: Text(
                                          messages[index][i],
                                          style: Theme.of(context).textTheme.displayMedium,
                                        ),
                                      ),
                                    ),
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
          ),
        ],
      ),
    );
  }
}