import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/asset-paths.dart';
import 'package:thuram_app/core/constants/colors.dart';
import 'package:thuram_app/feature/student/landing/presentation/pages/homepage.dart';
import 'package:thuram_app/feature/student/landing/presentation/widget/lost_and_found.dart';
import 'package:thuram_app/util/drawer.dart';

import '../../../../../core/constants/values.dart';
import '../../../../../util/custom-description-card.dart';
import '../../../student/landing/presentation/pages/courses.dart';
import '../../../student/landing/presentation/pages/following.dart';
import '../../../student/landing/presentation/pages/search-staff.dart';

class LecturerLandingPage extends StatefulWidget {
  const LecturerLandingPage({super.key, this.currenetPage = 0});
  final currenetPage;
  @override
  State<LecturerLandingPage> createState() => _LecturerLandingPageState();
}

GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

class _LecturerLandingPageState extends State<LecturerLandingPage> {
  final List<Widget> Pages = [
   const HomePage(),
   const Following(),
    // SearchStaffScreen(),
    CourseWidget(isStudent: false,),
   const CustomDescriptionCard(),
  ];

  final List<String> ScreenTitle = ['Home',"Follow","Courses","Profile"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedIndex = widget.currenetPage;
  }

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
          title: Text(ScreenTitle[_selectedIndex],style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w900),),
          // title: Image.asset(
          //   AppImages.logo,
          //   width: 25,
          // ),
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
                  icon: Icon(Icons.people),
                  color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
                  onPressed: () => _onItemTapped(1),
                ),
                // SizedBox(width: 40),
                // Transform.rotate(
                //   angle: 45,
                //   child: Container(
                //     width: 60,
                //     height: 60,
                //     decoration: BoxDecoration(
                //       color: AppColors.primaryColor.withOpacity(0.8),
                //       shape: BoxShape.rectangle,
                //       borderRadius:
                //           BorderRadius.circular(20), // Four-sided shape
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black26,
                //           blurRadius: 5,
                //           spreadRadius: 1,
                //           offset: Offset(0, 3),
                //         ),
                //       ],
                //     ),
                //     child: Transform.rotate(
                //       angle: 30.17,
                //       child: GestureDetector(
                //         onTap: () => _onItemTapped(2),
                //         child:
                //             Icon(Icons.search, color: Colors.white, size: 30),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(width: 40), // Space for the center button
                IconButton(
                  icon: Icon(Icons.file_copy),
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
        floatingActionButton: ClipOval(
            child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.chat),
        )),
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
