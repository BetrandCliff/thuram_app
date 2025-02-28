import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewOfficers extends StatefulWidget {
  @override
  _ViewOfficersState createState() => _ViewOfficersState();
}

class _ViewOfficersState extends State<ViewOfficers> {
  late Stream<QuerySnapshot> _officersStream;

  @override
  void initState() {
    super.initState();
    // Set the Firestore query stream to listen to officer documents
    _officersStream = FirebaseFirestore.instance.collection('officers').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offices/Outlets')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _officersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No offices/outlets found.'));
          }

          // Fetch the list of officer documents
          var officers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: officers.length,
            itemBuilder: (context, index) {
              var officer = officers[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        officer['fullName'] ?? 'N/A',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Role: ${officer['role'] ?? 'N/A'}',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Office Location: ${officer['officeLocation'] ?? 'N/A'}',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Latitude: ${officer['latitude'] ?? 'N/A'}',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          Text(
                            'Longitude: ${officer['longitude'] ?? 'N/A'}',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
