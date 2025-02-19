import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/asset-paths.dart';
import 'package:thuram_app/core/constants/colors.dart';
import 'package:thuram_app/feature/admin/presentations/pages/approve-and-reject.dart';
import 'package:thuram_app/feature/student/landing/presentation/pages/edit-profile.dart';
import 'package:thuram_app/feature/student/landing/presentation/widget/confersions.dart';
import 'package:thuram_app/feature/student/landing/presentation/widget/lost_and_found.dart';
import 'package:thuram_app/feature/student/login/presentation/login.dart';
import 'package:thuram_app/util/next-screen.dart';

import '../../../../mainscreen.dart';

class AdminDrawerItems extends StatelessWidget {
  const AdminDrawerItems({super.key});

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
                      "GUCONNECT",
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
                GestureDetector(
                  onTap: () {
                    nextScreen(context, Comment());
                  },
                  child: ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text("Confessions"),
                    trailing: Badge(
                      label:
                          Text("2", style: TextStyle(color: Colors.white)),
                      child: Icon(Icons.notifications),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    nextScreen(context, EditProfile());
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.edit,
                      size: 16,
                    ),
                    title: Text("Edit Profile"),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    nextScreen(context, EditProfile());
                  },
                  child: const ListTile(
                    leading: Icon(Icons.share),
                    title: Text("share"),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    nextScreen(context, EditProfile());
                  },
                  child: const ListTile(
                    leading: Icon(Icons.policy),
                    title: Text("Policies"),
                  ),
                )
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    nextScreen(context, MainScreen());
                  },
                  child: const ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Log out"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
