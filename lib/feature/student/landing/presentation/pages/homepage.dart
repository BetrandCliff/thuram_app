import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thuram_app/feature/student/landing/presentation/widget/confersions.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/values.dart';
import '../widget/academy.dart';
import '../widget/clubs_and_post.dart';
import '../widget/lost-items.dart';
import '../widget/lost_and_found.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.isStudent=true});
 final bool isStudent;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [


          const SizedBox(height: 10),

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
                text: "Confersions",
                icon: Icon(Icons.message),
              ),
            ],
          ),

          // Expanded TabBarView
          Expanded(
            child: TabBarView(
              children:  [
                Academy(),
                MissingItems(),
                ClubsAndPost(isStudent: isStudent),
                Confessions(),
                // LostAndFound()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
