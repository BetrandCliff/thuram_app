
import 'package:flutter/material.dart';
import 'package:thuram_app/util/widthandheight.dart';

import '../../../../../core/constants/asset-paths.dart';

class MissingItems extends StatelessWidget {
  const MissingItems({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: width(context),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
               ListTile(
                            contentPadding: EdgeInsets.all(0),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(AppImages.profile),
                            ),
                            title: Text("Thuram"),
                            subtitle: Text("4 hours ago"),
                            
                            ),
          
                  Text("Hakeem forgot his book inside the library, place anybody who finds it should please get to me.")
                          
            ],
          ),
        ),
      ),
    );
  }
}