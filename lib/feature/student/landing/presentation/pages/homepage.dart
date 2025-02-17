import 'package:flutter/material.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/values.dart';
import '../widget/academy.dart';
import '../widget/lost-items.dart';
import '../widget/lost_and_found.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              SizedBox(
                height: 220,
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonBorderRadius)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 120, // Adjust size
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors
                                        .grey.shade300, // Light grey shadow
                                    blurRadius: 10,
                                    spreadRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white, // White border
                                  width: 4,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  AppImages.profile, // Replace with your image
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Folefac Thuram",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontSize: 20),
                                  ),
                                  Text(
                                    "(student)",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(fontSize: 14),
                                  ),
                                  Text(
                                    "@thuram",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(fontSize: 14),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            buttonBorderRadius),
                                        color: AppColors.primaryColor
                                            .withOpacity(0.6)),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "4",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium!
                                                .copyWith(fontSize: 14),
                                          ),
                                          Text(
                                            "Post",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium!
                                                .copyWith(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 30,
                          child: Row(
                            children: [
                              Text(
                                "Watching the movies",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              Icon(Icons.movie)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // TabBar for Login & Signup
              const TabBar(
                labelColor: Colors.red,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.red,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    text: "Academic",
                    icon: Icon(Icons.book),
                  ),
                  Tab(
                    text: "L&F",
                    icon: Icon(Icons.shopping_basket),
                  ),
                  Tab(
                    text: "Club Posts",
                    icon: Icon(Icons.people),
                  ),
                  Tab(
                    text: "Conversation",
                    icon: Icon(Icons.message),
                  ),
                ],
              ),

              // Expanded TabBarView
              Expanded(
                child: TabBarView(
                  children:const [
                    Academy(),
                    MissingItems(),
                    LostAndFound(),
                    LostAndFound(),
                    // LostAndFound()
                  ],
                ),
              ),
            ],
          );
  }
}