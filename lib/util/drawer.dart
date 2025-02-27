import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/asset-paths.dart';
import 'package:thuram_app/core/constants/colors.dart';
import 'package:thuram_app/feature/student/landing/presentation/pages/edit-profile.dart';
import 'package:thuram_app/feature/student/landing/presentation/widget/lost_and_found.dart';
import 'package:thuram_app/mainscreen.dart';
import 'package:thuram_app/util/next-screen.dart';

class DrawerItems extends StatelessWidget {
  const DrawerItems({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      AppImages.logo,
                      width: 60,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "RHIBMS_GUC",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                const Divider(),
                // GestureDetector(
                //   onTap: () {
                //     nextScreen(context, LostAndFound());
                //   },
                //   child: const ListTile(
                //     leading: Icon(Icons.visibility),
                //     title: Text("LOST & FOUND"),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {},
                  child: const ListTile(
                    leading: Icon(Icons.location_on_sharp),
                    title: Text("Offices  and Outlets"),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const ListTile(
                    leading: Icon(Icons.search),
                    title: Text("Search"),
                  ),
                )
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    nextScreen(context, EditProfile());
                  },
                  child: const ListTile(
                    leading: Icon(Icons.edit),
                    title: Text("Edit Profile"),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    nextScreen(context, MainScreen());
                  },
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
