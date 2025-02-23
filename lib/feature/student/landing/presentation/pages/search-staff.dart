import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/util/next-screen.dart';

import 'courses.dart';
import 'profile.dart';
import 'register_courses.dart';

class SearchStaffScreen extends StatefulWidget {
  @override
  _SearchStaffScreenState createState() => _SearchStaffScreenState();
}


class _SearchStaffScreenState extends State<SearchStaffScreen> {
  String searchQuery = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Set<String> followingIds = {}; // Store IDs of users the current user is following

  @override
  void initState() {
    super.initState();
    _fetchFollowingUsers();
  }

  Future<void> _fetchFollowingUsers() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    if (userDoc.exists && userDoc.data() != null) {
      List<String> following = List<String>.from(userDoc['following'] ?? []);
      setState(() {
        followingIds = Set<String>.from(following);
      });
    }
  }

  void _filterList(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
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
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'Search',
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
                  _buildFirestoreList('staff'),
                  _buildFirestoreList('users'),
                  _buildCourseList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirestoreList(String collectionName) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No data available"));
        }

        var items = snapshot.data!.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .where((item) =>
                item['username'] != null &&
                item['username'].toLowerCase().contains(searchQuery))
            .toList();

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index];
            bool isFollowing = followingIds.contains(item['id']);

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      item['image'] != null && item['image'].isNotEmpty
                          ? NetworkImage(item['image'])
                          : null,
                  child: item['image'] == null || item['image'].isEmpty
                      ? Icon(Icons.person)
                      : null,
                ),
                title: Text(item['username'] ?? 'No Name'),
                subtitle: Text(item['email'] ?? 'No Email'),
                trailing: collectionName == 'users'
                    ? ElevatedButton(
                        onPressed: () {
                          isFollowing
                              ? _unfollowUser(item['id'])
                              : _followUser(item['id']);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFollowing
                              ? Colors.blueGrey
                              : Colors.orange,
                        ),
                        child: Text(
                          isFollowing ? 'Following' : 'Follow',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Icon(Icons.arrow_forward_ios),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _followUser(String userIdToFollow) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    try {
      DocumentReference userRef = _firestore.collection('users').doc(user.uid);
      DocumentSnapshot userDoc = await userRef.get();

      if (userDoc.exists) {
        await userRef.update({
          'following': FieldValue.arrayUnion([userIdToFollow])
        });

        await _firestore
            .collection('users')
            .doc(userIdToFollow)
            .update({'followers': FieldValue.arrayUnion([user.uid])});

        setState(() {
          followingIds.add(userIdToFollow);
        });
      }
    } catch (e) {
      print("Error following user: $e");
    }
  }

  Future<void> _unfollowUser(String userIdToUnfollow) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    try {
      DocumentReference userRef = _firestore.collection('users').doc(user.uid);
      DocumentSnapshot userDoc = await userRef.get();

      if (userDoc.exists) {
        await userRef.update({
          'following': FieldValue.arrayRemove([userIdToUnfollow])
        });

        await _firestore
            .collection('users')
            .doc(userIdToUnfollow)
            .update({'followers': FieldValue.arrayRemove([user.uid])});

        setState(() {
          followingIds.remove(userIdToUnfollow);
        });
      }
    } catch (e) {
      print("Error unfollowing user: $e");
    }
  }

  Widget _buildCourseList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('courses').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text("Error loading courses. Please try again."));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No courses available"));
        }

        var courses = snapshot.data!.docs;

        return ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            var course = courses[index];
            var courseData = course.data() as Map<String, dynamic>?;

            if (courseData == null) {
              return SizedBox();
            }

            return RegisterCourseItem(
              courseData: courseData,
              courseId: course.id,
              isStudent: true,
              onRegister: _registerForCourse,
            );
          },
        );
      },
    );
  }

  void _registerForCourse(String courseId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please log in to register for a course.")),
      );
      return;
    }

    try {
      DocumentReference registrationRef = FirebaseFirestore.instance
          .collection('registrations')
          .doc(user.uid)
          .collection('courses')
          .doc(courseId);

      DocumentSnapshot registrationSnapshot = await registrationRef.get();
      if (registrationSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("You are already registered for this course.")),
        );
        return;
      }

      await registrationRef.set({
        'courseId': courseId,
        'registeredAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successfully registered for the course!")),
      );
    } catch (e) {
      print("Error registering for course: $e");
    }
  }
}



/*
class _SearchStaffScreenState extends State<SearchStaffScreen> {
  String searchQuery = "";

  

  final List<Map<String, String>> staffList = [
   
  ];

  final List<Map<String, String>> taList = [
   
  ];

  final List<Map<String, String>> courseList = [
    
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
      searchQuery = query.toLowerCase();
      filteredStaffList = staffList.where((staff) {
        return staff['name']!.toLowerCase().contains(searchQuery) ||
            staff['email']!.toLowerCase().contains(searchQuery);
      }).toList();

      filteredTaList = taList.where((ta) {
        return ta['name']!.toLowerCase().contains(searchQuery) ||
            ta['email']!.toLowerCase().contains(searchQuery);
      }).toList();

      filteredCourseList = courseList.where((course) {
        return course['name']!.toLowerCase().contains(searchQuery) ||
            course['email']!.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
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
                  hintStyle: Theme.of(context).textTheme.displayMedium,
                  hintText: 'Search',
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
                  _buildFirestoreList('staff'),
                  _buildFirestoreList('users'),
                  _buildList()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirestoreList(String collectionName) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No data available"));
        }

        var items = snapshot.data!.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .where((item) =>
                item['username'] != null &&
                item['username'].toLowerCase().contains(searchQuery))
            .toList();

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index];

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      item['image'] != null && item['image'].isNotEmpty
                          ? NetworkImage(item['image'])
                          : null,
                  child: item['image'] == null || item['image'].isEmpty
                      ? Icon(Icons.person)
                      : null,
                ),
                title: Text(item['username'] ?? 'No Name'),
                subtitle: Text(item['email'] ?? 'No Email'),
                trailing: collectionName=='users'? ElevatedButton(
        onPressed: () {
          isFollowing ? _unfollowUser(item['id']!) : _followUser(item['id']!);
        },
        child: Text(isFollowing ? 'Unfollow' : 'Follow'),
      ) :Icon(Icons.arrow_forward_ios),
              ),
            );
          },
        );
      },
    );
  }

  void _registerForCourse(String courseId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Show an error message or prompt the user to log in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please log in to register for a course.")),
      );
      return;
    }

    try {
      // Reference to the student's registration in Firestore
      DocumentReference registrationRef = FirebaseFirestore.instance
          .collection('registrations')
          .doc(user.uid)
          .collection('courses')
          .doc(courseId);

      // Check if the student is already registered
      DocumentSnapshot registrationSnapshot = await registrationRef.get();
      if (registrationSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("You are already registered for this course.")),
        );
        return;
      }

      // Register the student
      await registrationRef.set({
        'courseId': courseId,
        'registeredAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successfully registered for the course!")),
      );
    } catch (e) {
      print("Error registering for course: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Error registering for the course. Please try again.")),
      );
    }
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('courses').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text("Error loading courses. Please try again."));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No courses available"));
        }

        var courses = snapshot.data!.docs;

        return ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            var course = courses[index];
            var courseData = course.data() as Map<String, dynamic>?;

            // Handle potential null values safely
            if (courseData == null) {
              return SizedBox(); // Skip rendering if data is missing
            }

            return RegisterCourseItem(
              courseData: courseData,
              courseId: course.id,
              isStudent: true,
              onRegister: _registerForCourse,
            );
          },
        );
      },
    );
  }
}*/

/*
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
      'email':
          'Introduction to artificial intelligence, search agents, logical agents and planning agents.',
      'image': 'https://randomuser.me/api/portraits/men/6.jpg',
    },
    {
      'name': 'Csen1089:Data Engineering',
      'email':
          'CSEN and NET course for data pipelines, handling the data and preparing it for ML models.',
      'image': 'https://randomuser.me/api/portraits/men/7.jpg',
    },
    {
      'name': 'Csen301:Data Structures And Algorithms',
      'email':
          '3rd semester DSA course for basic data structures and algorithms.',
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
        return nameLower.contains(searchLower) ||
            emailLower.contains(searchLower);
      }).toList();

      filteredTaList = taList.where((ta) {
        final nameLower = ta['name']!.toLowerCase();
        final emailLower = ta['email']!.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) ||
            emailLower.contains(searchLower);
      }).toList();

      filteredCourseList = courseList.where((course) {
        final nameLower = course['name']!.toLowerCase();
        final emailLower = course['email']!.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) ||
            emailLower.contains(searchLower);
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
                  // _buildList(filteredStaffList),
                  // _buildList(filteredTaList),
                  _buildStaff(),
                  _buildList(),
                  _buildList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registerForCourse(String courseId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Show an error message or prompt the user to log in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please log in to register for a course.")),
      );
      return;
    }

    try {
      // Reference to the student's registration in Firestore
      DocumentReference registrationRef = FirebaseFirestore.instance
          .collection('registrations')
          .doc(user.uid)
          .collection('courses')
          .doc(courseId);

      // Check if the student is already registered
      DocumentSnapshot registrationSnapshot = await registrationRef.get();
      if (registrationSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("You are already registered for this course.")),
        );
        return;
      }

      // Register the student
      await registrationRef.set({
        'courseId': courseId,
        'registeredAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successfully registered for the course!")),
      );
    } catch (e) {
      print("Error registering for course: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Error registering for the course. Please try again.")),
      );
    }
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('courses').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text("Error loading courses. Please try again."));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No courses available"));
        }

        var courses = snapshot.data!.docs;

        return ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            var course = courses[index];
            var courseData = course.data() as Map<String, dynamic>?;

            // Handle potential null values safely
            if (courseData == null) {
              return SizedBox(); // Skip rendering if data is missing
            }

            return RegisterCourseItem(
              courseData: courseData,
              courseId: course.id,
              isStudent: true,
              onRegister: _registerForCourse,
            );
          },
        );
      },
    );
  }

  Widget _buildStaff() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('staff').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No staff available"));
        }

        var staffList = snapshot.data!.docs;

        return ListView.builder(
          itemCount: staffList.length,
          itemBuilder: (context, index) {
            var staff = staffList[index];
            var staffData = staff.data() as Map<String, dynamic>;

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    // Navigate to the staff profile page
                    nextScreen(context, ProfilePage());
                  },
                  child: staffData['image'] != null &&
                          staffData['image'].isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(staffData['image']))
                      : CircleAvatar(child: Icon(Icons.school)),
                ),
                title: Text(staffData['username'] ?? 'No Name'),
                subtitle: Text(staffData['email'] ?? 'No Email'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            );
          },
        );
      },
    );
  }
}*/
