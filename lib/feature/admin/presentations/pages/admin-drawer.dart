import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/asset-paths.dart';
import 'package:thuram_app/core/constants/colors.dart';
import 'package:thuram_app/feature/admin/presentations/pages/admin-courses.dart';
import 'package:thuram_app/feature/admin/presentations/pages/approve-and-reject.dart';
import 'package:thuram_app/feature/student/landing/presentation/pages/edit-profile.dart';
import 'package:thuram_app/feature/student/landing/presentation/widget/confersions.dart';
import 'package:thuram_app/feature/student/landing/presentation/widget/lost_and_found.dart';
import 'package:thuram_app/feature/student/login/presentation/login.dart';
import 'package:thuram_app/util/next-screen.dart';

import '../../../../mainscreen.dart';
import 'fetch_confession.dart';
import 'fetch_staff.dart';

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
                GestureDetector(
                  onTap: () {
                    nextScreen(context, AdminConfessionScreen());
                  },
                  child: ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text("Confessions"),
                    trailing: Badge(
                      label: Text("2", style: TextStyle(color: Colors.white)),
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
                    nextScreen(context, AdminCourseWidget());
                  },
                  child: const ListTile(
                    leading: Icon(Icons.book),
                    title: Text("courses"),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    nextScreen(context, StaffListScreen());
                  },
                  child: const ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Staffs"),
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
