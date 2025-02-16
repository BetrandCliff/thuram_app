
import 'package:flutter/material.dart';

class SearchStaffScreen extends StatefulWidget {
  @override
  _SearchStaffScreenState createState() => _SearchStaffScreenState();
}

class _SearchStaffScreenState extends State<SearchStaffScreen> {
  final List<Map<String, String>> staffList = [
    {
      'name': 'Haythem Othman Ismail',
      'email': 'haythem.ismail@guc.edu.eg',
      'image': 'https://randomuser.me/api/portraits/men/1.jpg',
    },
    {
      'name': 'Mervat Abouelkhier',
      'email': 'mervat.abouelkhier@guc.edu.eg',
      'image': '',
    },
    {
      'name': 'Milad Ghantous',
      'email': 'milad.ghantous@guc.edu.eg',
      'image': 'https://randomuser.me/api/portraits/men/2.jpg',
    },
    {
      'name': 'Wael Abouelsadaat',
      'email': 'wael.abosadaat@guc.edu.eg',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
    },
  ];

  final List<Map<String, String>> taList = [
    {
      'name': 'Ahmed Mohamed',
      'email': 'ahmed.mohamed@guc.edu.eg',
      'image': 'https://randomuser.me/api/portraits/men/4.jpg',
    },
    {
      'name': 'Fatma Ali',
      'email': 'fatma.ali@guc.edu.eg',
      'image': 'https://randomuser.me/api/portraits/women/1.jpg',
    },
  ];

  final List<Map<String, String>> courseList = [
    {
      'name': 'Csen 1078:Mobile App Development',
      'email': 'Flutter',
      'image': 'https://randomuser.me/api/portraits/men/5.jpg',
    },
    {
      'name': 'Csen901:Artificial Intelligence Introduction',
      'email': 'Introduction to artificial intelligence, search agents, logical agents and planning agents.',
      'image': 'https://randomuser.me/api/portraits/men/6.jpg',
    },
    {
      'name': 'Csen1089:Data Engineering',
      'email': 'CSEN and NET course for data pipelines, handling the data and preparing it for ML models.',
      'image': 'https://randomuser.me/api/portraits/men/7.jpg',
    },
    {
      'name': 'Csen301:Data Structures And Algorithms',
      'email': '3rd semester DSA course for basic data structures and algorithms.',
      'image': 'https://randomuser.me/api/portraits/men/8.jpg',
    },
  ];

  List<Map<String, String>> filteredStaffList = [];
  List<Map<String, String>> filteredTaList = [];
  List<Map<String, String>> filteredCourseList = [];

  @override
  void initState() {
    super.initState();
    filteredStaffList = staffList;
    filteredTaList = taList;
    filteredCourseList = courseList;
  }

  void _filterList(String query) {
    setState(() {
      filteredStaffList = staffList.where((staff) {
        final nameLower = staff['name']!.toLowerCase();
        final emailLower = staff['email']!.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) || emailLower.contains(searchLower);
      }).toList();

      filteredTaList = taList.where((ta) {
        final nameLower = ta['name']!.toLowerCase();
        final emailLower = ta['email']!.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) || emailLower.contains(searchLower);
      }).toList();

      filteredCourseList = courseList.where((course) {
        final nameLower = course['name']!.toLowerCase();
        final emailLower = course['email']!.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) || emailLower.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // appBar: AppBar(
        //   // title: Text('Search', style: TextStyle(color: Colors.black)),
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   iconTheme: IconThemeData(color: Colors.black),
        //   bottom: 
        // ),
        body: Column(
          children: [
            TabBar(
              dividerColor: Colors.transparent,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.orange,
            tabs: [
              Tab(text: 'Profs'),
              Tab(text: 'TAs'),
              Tab(text: 'Courses'),
            ],
          ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: _filterList,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: Theme.of(context).textTheme.displaySmall,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(filteredStaffList),
                  _buildList(filteredTaList),
                  _buildList(filteredCourseList),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, String>> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: item['image'] != null && item['image']!.isNotEmpty
                ? CircleAvatar(backgroundImage: NetworkImage(item['image']!))
                : CircleAvatar(child: Icon(Icons.school)),
            title: Text(item['name']!),
            subtitle: Text(item['email']!),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        );
      },
    );
  }
}
