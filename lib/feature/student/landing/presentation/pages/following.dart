// import 'package:flutter/material.dart';

// import '../../../../../core/constants/asset-paths.dart';
// import '../../../../../util/next-screen.dart';
// import '../../../../../util/widthandheight.dart';
// import 'profile.dart';

// class Following extends StatefulWidget {
//   const Following({super.key});

//   @override
//   State<Following> createState() => _FollowingState();
// }

// class _FollowingState extends State<Following>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String _headerText = "Following";

//   @override
//   void initState() {
//     super.initState();
//     filteredFollowersList = followerList;
//     filteredFollowingList = followerList;

//     // Initialize TabController
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _headerText = _tabController.index == 0 ? "Following" : "Follower";
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _filterList(String query) {
//     setState(() {
//       filteredFollowersList = followerList.where((follower) {
//         final nameLower = follower['name']!.toLowerCase();
//         final emailLower = follower['email']!.toLowerCase();
//         final levelLower = follower['level']!.toLowerCase();
//         final searchLower = query.toLowerCase();
//         return nameLower.contains(searchLower) ||
//             emailLower.contains(searchLower) ||
//             levelLower.contains(searchLower);
//       }).toList();

//       filteredFollowingList = followerList.where((follower) {
//         final nameLower = follower['name']!.toLowerCase();
//         final emailLower = follower['email']!.toLowerCase();
//         final levelLower = follower['level']!.toLowerCase();
//         final searchLower = query.toLowerCase();
//         return nameLower.contains(searchLower) ||
//             emailLower.contains(searchLower) ||
//             levelLower.contains(searchLower);
//       }).toList();
//     });
//   }

//   final List<Map<String, String>> followerList = [
//     {
//       'name': 'Haythem Othman Ismail',
//       'email': 'haythem.ismail@guc.edu.eg',
//       'image': 'https://randomuser.me/api/portraits/men/1.jpg',
//       'level': "300"
//     },
//     {
//       'name': 'Mervat Abouelkhier',
//       'email': 'mervat.abouelkhier@guc.edu.eg',
//       'image': 'https://randomuser.me/api/portraits/men/4.jpg',
//       'level': "400"
//     },
//     {
//       'name': 'Milad Ghantous',
//       'email': 'milad.ghantous@guc.edu.eg',
//       'image': 'https://randomuser.me/api/portraits/men/2.jpg',
//       'level': "200"
//     },
//     {
//       'name': 'Wael Abouelsadaat',
//       'email': 'wael.abosadaat@guc.edu.eg',
//       'image': 'https://randomuser.me/api/portraits/men/3.jpg',
//       'level': "300"
//     },
//   ];

//   List<Map<String, String>> filteredFollowersList = [];
//   List<Map<String, String>> filteredFollowingList = [];

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: SizedBox(
//         height: height(context),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TabBar(
//               controller: _tabController,
//               labelColor: Colors.red,
//               unselectedLabelColor: Colors.grey,
//               indicatorColor: Colors.red,
//               dividerColor: Colors.transparent,
//               tabs: [
//                 Tab(text: "Following"),
//                 Tab(text: "Follower"),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextField(
//                 onChanged: _filterList,
//                 decoration: InputDecoration(
//                   hintText: 'Search',
//                   hintStyle: Theme.of(context).textTheme.displaySmall,
//                   prefixIcon: Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//               ),
//             ),
//             Text(
//               _headerText,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyMedium!
//                   .copyWith(fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                    for (int i = 0; i < filteredFollowersList.length-2; i++)

//               SizedBox(
//                 height: height(context)/9,
//                 child: follower(name: filteredFollowersList[i]['name']??"",level:filteredFollowersList[i]['level']??"",img: filteredFollowersList[i]['image']??"" )),
//                   // follower(filteredFollowersList),

//                   for (int i = 0; i < filteredFollowersList.length-2; i++)
//               SizedBox(
//                 height: height(context)/9,
//                 child: Column(
//                   children: [
//                     following(name: filteredFollowersList[i]['name']??"",level:filteredFollowersList[i]['level']??"",img: filteredFollowersList[i]['image']??"" ),
//                   ],
//                 ))
//                 ],
//               ),
//             ),
//             Text("Suggested for you"),
//             for (int i = 0; i < filteredFollowersList.length-3; i++)

//               suggestions(name: filteredFollowersList[i]['name']??"",level:filteredFollowersList[i]['level']??"",img: filteredFollowersList[i]['image']??"" )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget follower({required String name, required String img, required String level}) {
//     return  GestureDetector(
//               onTap: () {
//                 nextScreen(context, ProfilePage());
//               },
//               child: Container(
//                 margin: const EdgeInsets.symmetric(vertical: 10),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       ListTile(
//                         contentPadding: EdgeInsets.all(0),
//                         leading: CircleAvatar(
//                           radius: 30,
//                           backgroundImage:
//                               NetworkImage(img),
//                         ),
//                         title: Text(name),
//                         subtitle: Row(
//                           children: [
//                             Text(level),
//                             Container(
//                               margin: EdgeInsets.only(left: 5, right: 5),
//                               width: 15,
//                               height: 15,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 color: Colors.black,
//                               ),
//                               child: Center(
//                                 child: Icon(
//                                   Icons.done,
//                                   size: 12,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             Text("following"),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ));
       
    
//   }

//   Widget following({required String name, required String img, required String level}) {
//     return follower(name: name,img: img,level: level);
//   }

//   Widget suggestions(
//       {required String name, required String img, required String level}) {
//     return GestureDetector(
//         onTap: () {
//           nextScreen(context, ProfilePage());
//         },
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 10),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 ListTile(
//                   trailing: Container(
//                     width: 60,
//                     height: 40,
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black, width: 1),
//                         borderRadius: BorderRadius.circular(10)),
//                     child: Center(child: Text("Follow")),
//                   ),
//                   contentPadding: EdgeInsets.all(0),
//                   leading: CircleAvatar(
//                     radius: 30,
//                     backgroundImage: NetworkImage(img),
//                   ),
//                   title: Text(name),
//                   subtitle: Row(
//                     children: [
//                       Text(level),
//                       Container(
//                         margin: EdgeInsets.only(left: 5, right: 5),
//                         width: 15,
//                         height: 15,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           color: Colors.black,
//                         ),
//                         child: Center(
//                           child: Icon(
//                             Icons.done,
//                             size: 12,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       Text("following"),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }

import 'package:flutter/material.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../util/next-screen.dart';
import '../../../../../util/widthandheight.dart';
import 'profile.dart';

class Following extends StatefulWidget {
  const Following({super.key});

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _headerText = "Following";

  @override
  void initState() {
    super.initState();
    filteredFollowersList = followerList;
    filteredFollowingList = followerList;
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging || _tabController.index != _tabController.previousIndex) {
      setState(() {
        _headerText = _tabController.index == 0 ? "Following" : "Follower";
      });
    }
  }

  void _filterList(String query) {
    setState(() {
      filteredFollowersList = followerList.where((follower) {
        final nameLower = follower['name']!.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower);
      }).toList();

      filteredFollowingList = followerList.where((follower) {
        final nameLower = follower['name']!.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower);
      }).toList();
    });
  }

  final List<Map<String, String>> followerList = [
    {
      'name': 'Haythem Othman Ismail',
      'email': 'haythem.ismail@guc.edu.eg',
      'image': 'https://randomuser.me/api/portraits/men/1.jpg',
      'level': "300"
    },
    {
      'name': 'Mervat Abouelkhier',
      'email': 'mervat.abouelkhier@guc.edu.eg',
      'image': 'https://randomuser.me/api/portraits/men/4.jpg',
      'level': "400"
    },
    {
      'name': 'Milad Ghantous',
      'email': 'milad.ghantous@guc.edu.eg',
      'image': 'https://randomuser.me/api/portraits/men/2.jpg',
      'level': "200"
    },
    {
      'name': 'Wael Abouelsadaat',
      'email': 'wael.abosadaat@guc.edu.eg',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
      'level': "300"
    },
  ];

  List<Map<String, String>> filteredFollowersList = [];
  List<Map<String, String>> filteredFollowingList = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SizedBox(
        height: height(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.red,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: "Following"),
                Tab(text: "Follower"),
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
            Text(
              _headerText,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabContent(filteredFollowingList),
                  _buildTabContent(filteredFollowersList),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(List<Map<String, String>> list) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text("Your Followers", style: Theme.of(context).textTheme.titleLarge),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _buildFollowerItem(list[index]);
            },
          ),
          SizedBox(height: 20),
          Text("Suggestions for You", style: Theme.of(context).textTheme.displayMedium),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _buildSuggestionItem(list[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFollowerItem(Map<String, String> item) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(item['image']!),
      ),
      title: Text(item['name']!),
      subtitle: Text(item['level']!),
    );
  }

  Widget _buildSuggestionItem(Map<String, String> item) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(item['image']!),
      ),
      title: Text(item['name']!),
      subtitle: Text(item['level']!),
      trailing: ElevatedButton(
        onPressed: () {},
        child: Text("Follow"),
      ),
    );
  }
}

