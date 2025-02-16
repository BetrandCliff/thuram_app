import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Import the package

import '../core/constants/asset-paths.dart';
import '../core/constants/colors.dart';
import '../core/constants/values.dart';

class CustomDescriptionCard extends StatelessWidget {
  const CustomDescriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 100,
          maxWidth: 600, // Optional: Add a max width for better responsiveness
        ),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content height
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Row
                Row(
                  children: [
                    // Profile Image
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 10,
                            spreadRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          AppImages.profile, // Replace with your image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20), // Spacing
                    // Name and Post Count
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Folefac Thuram",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(buttonBorderRadius),
                            color: AppColors.primaryColor.withOpacity(0.6),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                
                                Text(
                                  "Avg\nRating",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(fontSize: 14),
                                ),
                                Text(
                                  "0.0",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Spacing
                // Description
                Text(
                  "Description",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 14,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8), // Spacing
                Text(
                  "Introduction to artificial intelligence, search agents, local agent and planning agent",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: 14),
                ),
               // Spacing
                const SizedBox(height: 26), 
                // Hobby Section
                              Text("Rate Artificial Intelligence Introduction:",style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.bold),),
      
                const SizedBox(height: 16), // Spacing
                // Ratable Stars
                 Row(
                   children: [
                     RatingBar.builder(
                        initialRating: 0, // Initial rating value
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20, // Size of the stars
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber, // Star color
                        ),
                        onRatingUpdate: (rating) {
                          // Handle rating changes
                          print("Rating updated to: $rating");
                        },
                      ),
                      SizedBox(width: 10,),
                    ElevatedButton(child: Text("Submit",style: Theme.of(context).textTheme.displayMedium!.copyWith(color: AppColors.primaryColor),),onPressed: (){},)
                   ],
                 ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}