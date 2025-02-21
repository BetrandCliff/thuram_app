import 'package:flutter/material.dart';
import 'package:thuram_app/util/custom-button.dart';
import 'package:thuram_app/util/next-screen.dart';
import 'package:thuram_app/util/widthandheight.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../chat/chat-screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 90, // Diameter of the CircleAvatar (2 * radius)
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.secondaryColor, // Border color
                        width: 1, // Border width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage:
                          AssetImage(AppImages.equation) as ImageProvider,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daily Mail",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "15.6K",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "posts",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              Text(
                                "3.3M",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "followers",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              Text(
                                "15.6K",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "following",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: width(context),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: width(context) / 2 - 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black,
                          border: Border.all(width: 2, color: Colors.white)),
                      child: Center(
                          child: Text(
                        "Following",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Colors.white),
                      )),
                    ),
                    GestureDetector(
                      onTap: () {
                        nextScreen(context, ChatScreen());
                      },
                      child: Container(
                        height: 50,
                        width: width(context) / 2 - 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.black,
                            border: Border.all(width: 2, color: Colors.white)),
                        child: Center(
                            child: Text(
                          "Message",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: Colors.white),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
