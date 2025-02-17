import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/asset-paths.dart';
import 'package:thuram_app/core/constants/colors.dart';
import 'package:thuram_app/feature/student/landing/presentation/pages/profile.dart';
import 'package:thuram_app/feature/student/landing/presentation/widget/lost_and_found.dart';
import 'package:thuram_app/util/drawer.dart';

import '../../../../core/constants/values.dart';
import '../../../../util/custom-description-card.dart';
import '../../../student/login/presentation/login.dart';
import '../../../student/login/presentation/signup.dart';
import '../../../student/landing/presentation/widget/conversation.dart';
import '../../../student/landing/presentation/pages/edit-profile.dart';
import '../../../student/landing/presentation/pages/search-staff.dart';
import 'add-office.dart';
import 'add-staff.dart';
import 'addcourse.dart';
import 'approve-and-reject.dart';

class AdminLandingPage extends StatefulWidget {
  const AdminLandingPage({super.key});

  @override
  State<AdminLandingPage> createState() => _AdminLandingPageState();
}

GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

class _AdminLandingPageState extends State<AdminLandingPage> {
  final List<Widget> Pages =  [AddStaffForm(),AddCourse(),AddOfficer(),Comment(),ProfilePage(),];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: key,
        drawer: Drawer(
          backgroundColor: Color(0xffffffff),
          child: DrawerItems(),
        ),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                key.currentState!.openDrawer();
              },
              icon: Icon(Icons.menu)),
          centerTitle: true,
          title: Image.asset(
            AppImages.logo,
            width: 25,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:Pages[_selectedIndex] ,
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
                  icon: Icon(Icons.favorite),
                  color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
                  onPressed: () => _onItemTapped(1),
                ),
                SizedBox(width: 40),
                Transform.rotate(
                  angle: 45,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.8),
                      shape: BoxShape.rectangle,
                      borderRadius:
                          BorderRadius.circular(20), // Four-sided shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Transform.rotate(
                      angle: 30.17,
                      child: GestureDetector(
                        onTap: () => _onItemTapped(2),
                        child:
                            Icon(Icons.search, color: Colors.white, size: 30),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 40), // Space for the center button
                IconButton(
                  icon: Icon(Icons.notifications),
                  color: _selectedIndex == 3 ? Colors.blue : Colors.grey,
                  onPressed: () => _onItemTapped(3),
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  color: _selectedIndex == 4 ? Colors.blue : Colors.grey,
                  onPressed: () => _onItemTapped(4),
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
