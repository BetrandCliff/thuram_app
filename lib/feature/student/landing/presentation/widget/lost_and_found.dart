import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/asset-paths.dart';
import 'package:thuram_app/core/constants/colors.dart';

import '../../../../../util/video-player.dart';

class LostAndFound extends StatelessWidget {
  const LostAndFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LOST AND FOUND"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context,index) {
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(AppImages.profile),
                    ),
                    title: Text("Thuram"),
                    subtitle: Text("4 hours ago"),
                    trailing: PopupMenuButton<String>(
                      color: Colors.white,
                      icon: Icon(Icons.more_horiz), // Three dots icon
                      onSelected: (String value) {
                        // Handle menu item selection
                        switch (value) {
                          case 'edit':
                            // Action for "Edit"
                            print("Edit selected");
                            break;
                          // case 'delete':
                          //   // Action for "Delete"
                          //   print("Delete selected");
                          //   break;
                          // case 'report':
                          //   // Action for "Report"
                          //   print("Report selected");
                          //   break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Report',
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_rounded,
                                color: AppColors.primaryColor,
                              ),
                              Text('Report'),
                            ],
                          ),
                        ),
                        // const PopupMenuItem<String>(
                        //   value: 'delete',
                        //   child: Text('Delete'),
                        // ),
                        // const PopupMenuItem<String>(
                        //   value: 'report',
                        //   child: Text('Report'),
                        // ),
                      ],
                    ),
                  ),
                  Text(
                    "I have found that credit card at the platform and dropped it at the C lost&found office",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 20),
                  // const SizedBox(
                  //   height: 300,
                  //   child: VideoPlayerWidget(
                  //     videoUrl:
                  //         "https://www.youtube.com/watch?v=_LwOjCdLMvc&list=PPSV",
                  //   ),
                  // ),
                  Row(
                    children: [
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.favorite)),
                          Text("0 likes",style: Theme.of(context).textTheme.displayMedium,)
                        ],
                      ),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
                    ],
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
