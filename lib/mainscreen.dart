import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/asset-paths.dart';

import 'feature/chat/push_notification.dart';
import 'feature/student/login/presentation/login.dart';
import 'feature/student/login/presentation/signup.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
    @override
  void initState() {
    super.initState();
    PushNotificationService().initialize();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Login & Signup
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.logo, // Replace with AppImages.logo
                      width: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "GUCONNECT",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  "Stay Engaged and Connected",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 25,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  "The best way to get the most out of our app is to participate actively.",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w200),
                ),
                const SizedBox(height: 20),

                // TabBar for Login & Signup
                const TabBar(
                  labelColor: Colors.red,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.red,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      text: "Login",
                    ),
                    Tab(text: "Create Account"),
                  ],
                ),

                // Expanded TabBarView
                Expanded(
                  child: TabBarView(
                    children: [
                      LoginForm(),
                      SignupForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
