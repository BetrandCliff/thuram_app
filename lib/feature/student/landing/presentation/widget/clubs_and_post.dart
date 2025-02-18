

import 'package:flutter/material.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../util/next-screen.dart';
import '../../../../../util/widthandheight.dart';
import '../pages/profile.dart';

class ClubsAndPost extends StatelessWidget {
  const ClubsAndPost({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: height(context) / 2.5,
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
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(
            height: height(context) / 2.5,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
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
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(0),
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(AppImages.profile),
                                ),
                                title: Text("Thuram"),
                                subtitle: Text("4 hours ago"),
                               
                              ),
                              Text(
                                "I have found that credit card at the platform and dropped it at the C lost&found office",
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                              const SizedBox(height: 20),
                              // const SizedBox(
                              //   height: 300,
                              //   child: VideoPlayerWidget(
                              //     videoUrl:
                              //         "https://www.youtube.com/watch?v=_LwOjCdLMvc&list=PPSV",
                              //   ),
                              // ),
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}