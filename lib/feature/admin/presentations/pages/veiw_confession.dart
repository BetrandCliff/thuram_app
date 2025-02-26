// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// import 'fetch_confession.dart';

// class ConfessionDetailScreen extends StatelessWidget {
//   final Confession confession;

//   ConfessionDetailScreen({required this.confession});

//   Future<void> updateConfessionStatus(String newStatus, BuildContext context) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('confessions')
//           .doc(confession.id)
//           .update({'status': newStatus});

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Confession $newStatus successfully')),
//       );

//       Navigator.pop(context, newStatus);
//     } catch (e) {
//       print("Error updating status: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update confession')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Confession Details")),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: CircleAvatar(
//                 backgroundImage: NetworkImage(confession.anonymousProfilePic),
//                 radius: 40,
//               ),
//             ),
//             SizedBox(height: 10),
//             Center(
//               child: Text(
//                 confession.anonymousName,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               confession.title,
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               confession.content,
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 20),
//             Text(
//               "Created: ${DateFormat.yMMMd().add_jm().format(confession.createdAt)}",
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//             if (confession.reports!.isNotEmpty) ...[
//               Divider(),
//               Text("🚨 Reports:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               for (var report in confession.reports!)
//                 ListTile(
//                   title: Text("Reason: ${report.reason}"),
//                   subtitle: Text("Clarification: ${report.clarification}"),
//                   trailing: Text(DateFormat.yMMMd().format(report.reportedAt)),
//                 ),
//             ],
//             Spacer(),
//             if (confession.status == "pending")
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () => updateConfessionStatus("approved", context),
//                     child: Text("Approve"),
//                   ),
//                   ElevatedButton(
//                     onPressed: () => updateConfessionStatus("denied", context),
//                     child: Text("Deny"),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
