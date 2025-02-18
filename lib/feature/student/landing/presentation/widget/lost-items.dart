
import 'package:flutter/material.dart';
import 'package:thuram_app/util/widthandheight.dart';

import '../../../../../core/constants/asset-paths.dart';
import '../../../../../util/next-screen.dart';
import '../pages/profile.dart';

class MissingItems extends StatelessWidget {
  const MissingItems({super.key});

  @override
  Widget build(BuildContext context) {
     return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              nextScreen(context, ProfilePage());
            },
            child: Text(
              "All view",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: Colors.blue),
            ),
          ),
        ),
        Expanded( // This ensures the ListView doesn't cause overflow
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: width(context),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(AppImages.profile),
                          ),
                          title: Text("Thuram"),
                          subtitle: Text("4 hours ago"),
                        ),
                        Text(
                          "Hakeem forgot his book inside the library, please anybody who finds it should get to me",
                        ),
                        Image.asset(
                          AppImages.equation,
                          width: width(context)/3,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );


  }
}