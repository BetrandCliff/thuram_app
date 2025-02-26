import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'veiw_confession.dart'; // For formatting timestamps

class Confession {
  final String id;
  final String anonymousName;
  final String anonymousProfilePic;
  final String title;
  final String reportContent;
  final String reasonForReport;
  final String clarification;
  final DateTime createdAt;
  String status; // Change from final to non-final

  Confession({
    required this.id,
    required this.anonymousName,
    required this.anonymousProfilePic,
    required this.title,
    required this.reportContent,
    required this.reasonForReport,
    required this.clarification,
    required this.createdAt,
    this.status = "pending", // default status
  });

  factory Confession.fromMap(String id, Map<String, dynamic> data) {
    return Confession(
      id: id,
      anonymousName: data['anonymousName'] ?? 'Anonymous',
      anonymousProfilePic: data['anonymousProfilePic'] ?? '',
      title: data['title'] ?? '',
      reportContent: data['reportContent'] ?? '',
      reasonForReport: data['reasonForReport'] ?? '',
      clarification: data['clarification'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
    );
  }
}

class Report {
  final String reason;
  final String clarification;
  final DateTime reportedAt;

  Report({
    required this.reason,
    required this.clarification,
    required this.reportedAt,
  });

  factory Report.fromMap(Map<String, dynamic> data) {
    return Report(
      reason: data['reason'] ?? 'No reason given',
      clarification: data['clarification'] ?? '',
      reportedAt: (data['reportedAt'] as Timestamp).toDate(),
    );
  }
}

class AdminConfessionScreen extends StatefulWidget {
  @override
  _AdminConfessionScreenState createState() => _AdminConfessionScreenState();
}

class _AdminConfessionScreenState extends State<AdminConfessionScreen> {
  List<Confession> confessions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchConfessions();
  }

  Future<void> fetchConfessions() async {
    print("Fetching all confessions...");
    setState(() => isLoading = true);

    try {
      QuerySnapshot confessionSnapshot =
          await FirebaseFirestore.instance.collection('confessions').get();

      List<Confession> fetchedConfessions = confessionSnapshot.docs.map((doc) {
        return Confession.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      setState(() {
        confessions = fetchedConfessions;
        isLoading = false;
      });

      print("Fetched ${fetchedConfessions.length} confessions.");
    } catch (e) {
      print("Error fetching confessions: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to fetch confessions')));
      setState(() => isLoading = false);
    }
  }

  Future<void> updateConfessionStatus(
      String confessionId, String status, int index) async {
    try {
      if (status == "denied") {
        // If denied, delete the confession
        await FirebaseFirestore.instance
            .collection('confessions')
            .doc(confessionId)
            .delete();
        setState(() {
          confessions.removeAt(index); // Remove from the list
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Confession denied and deleted')));
      } else {
        // If approved, update the status
        await FirebaseFirestore.instance
            .collection('confessions')
            .doc(confessionId)
            .update({'status': status});
        setState(() {
          confessions[index].status = status; // Update the status
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Confession $status')));
      }
    } catch (e) {
      print("Error updating confession status: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update confession')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Confessions")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : confessions.isEmpty
              ? Center(child: Text("No Confessions Available"))
              : ListView.builder(
                  itemCount: confessions.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfessionDetailScreen(
                                confession: confessions[index]),
                          ),
                        );

                        // If the confession was deleted (denied), update the list
                        if (result == 'deleted') {
                          setState(() {
                            confessions.removeAt(index); // Remove from the list
                          });
                        } else if (result != null) {
                          setState(() {
                            // Update the status on the UI
                            confessions[index].status = result;
                          });
                        }
                      },
                      child: Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        elevation: 4,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                confessions[index].anonymousProfilePic),
                          ),
                          title: Text(
                            confessions[index].title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "By ${confessions[index].anonymousName} • ${DateFormat.yMMMd().format(confessions[index].createdAt)}",
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 18),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class ConfessionDetailScreen extends StatelessWidget {
  final Confession confession;

  ConfessionDetailScreen({required this.confession});

  Future<void> updateConfessionStatus(
      String newStatus, BuildContext context) async {
    try {
      if (newStatus == "denied") {
        // If the confession is denied, delete it from Firestore
        await FirebaseFirestore.instance
            .collection('confessions')
            .doc(confession.id)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Confession has been denied and deleted')),
        );
        Navigator.pop(
            context, 'deleted'); // Indicate that the confession was deleted
      } else {
        // If the confession is approved, update its status
        await FirebaseFirestore.instance
            .collection('confessions')
            .doc(confession.id)
            .update({'status': newStatus});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Confession $newStatus successfully')),
        );
        Navigator.pop(
            context, newStatus); // Return updated status to previous screen
      }
    } catch (e) {
      print("Error updating status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update confession')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(confession.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(confession.anonymousProfilePic),
              radius: 30,
            ),
            SizedBox(height: 8),
            Text(
              confession.anonymousName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              DateFormat.yMMMd().format(confession.createdAt),
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(confession.reportContent),
            SizedBox(height: 16),
            Text('Reason for Report: ${confession.reasonForReport}'),
            SizedBox(height: 8),
            Text('Clarification: ${confession.clarification}'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => updateConfessionStatus('approved', context),
                  child: Text('Approve'),
                  style:
                      ElevatedButton.styleFrom(foregroundColor: Colors.green),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => updateConfessionStatus('denied', context),
                  child: Text('Deny'),
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
