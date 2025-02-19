import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/asset-paths.dart';
import 'package:thuram_app/core/constants/colors.dart';
import 'package:thuram_app/feature/student/landing/presentation/pages/following.dart';
import 'package:thuram_app/feature/student/landing/presentation/pages/homepage.dart';
import 'package:thuram_app/feature/student/landing/presentation/pages/profile.dart';
import 'package:thuram_app/feature/student/landing/presentation/widget/lost_and_found.dart';
import 'package:thuram_app/util/drawer.dart';
import 'package:thuram_app/util/next-screen.dart';

import '../../../../core/constants/values.dart';
import '../../../../util/custom-description-card.dart';
import '../../../student/login/presentation/login.dart';
import '../../../student/login/presentation/signup.dart';
import '../../../student/landing/presentation/widget/academy.dart';
import '../../../student/landing/presentation/pages/edit-profile.dart';
import '../../../student/landing/presentation/pages/search-staff.dart';
import 'add-office.dart';
import 'add-staff.dart';
import 'addcourse.dart';
import 'admin-drawer.dart';
import 'admin-profile.dart';
import 'approve-and-reject.dart';

class AdminLandingPage extends StatefulWidget {
  const AdminLandingPage({super.key});

  @override
  State<AdminLandingPage> createState() => _AdminLandingPageState();
}

GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

class _AdminLandingPageState extends State<AdminLandingPage> {
  final List<Widget> Pages = [
    AddStaffForm(),
    AddCourse(),
    AddOfficer(),
    AdminProfile(),
  ];
  final List<String> ScreenTitles = [
    "Add Staff",
    "Add Course",
    "Add Office / Outlet",
    "Profile"
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: key,
        drawer: Drawer(
          backgroundColor: Color(0xffffffff),
          child: AdminDrawerItems(),
        ),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                key.currentState!.openDrawer();
              },
              icon: Icon(Icons.menu)),
          centerTitle: true,
          title: Text(
            ScreenTitles[_selectedIndex],
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontWeight: FontWeight.w900),
          ),
          // title: Image.asset(
          //   AppImages.logo,
          //   width: 25,
          // ),

          actions: [
            GestureDetector(
              onTap: () {
                nextScreen(context, Comment());
              },
              child: Badge(
                label: Text("2", style: TextStyle(color: Colors.white)),
                child: Icon(Icons.notifications),
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Pages[_selectedIndex],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
                  onPressed: () => _onItemTapped(0),
                ),
                IconButton(
                  icon: Icon(Icons.file_copy),
                  color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
                  onPressed: () => _onItemTapped(1),
                ),
                IconButton(
                  icon: Icon(Icons.location_on_sharp),
                  color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
                  onPressed: () => _onItemTapped(2),
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  color: _selectedIndex == 3 ? Colors.blue : Colors.grey,
                  onPressed: () => _onItemTapped(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
