import 'package:flutter/material.dart';
import 'ProfileDatabase.dart';

class UserProfileScreen extends StatelessWidget {
  final mydatabaseclass databaseHelper = mydatabaseclass();
  final String userEmail;

  UserProfileScreen({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        // Fetch user profile data from the database based on the passed email
        future: fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            Map<String, dynamic> userProfile = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 60),
                    Text(
                      '${userProfile['riderName']}',
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 50),
                    ListTile(
                      title: Text('First Name'),
                      subtitle: Text('${userProfile['riderFirstName']}'),
                      leading: Icon(Icons.person),
                    ),
                    ListTile(
                      title: Text('Last Name'),
                      subtitle: Text('${userProfile['riderLastName']}'),
                      leading: Icon(Icons.account_box),
                    ),
                    ListTile(
                      title: Text('Email'),
                      subtitle: Text('${userProfile['riderEmail']}'),
                      leading: Icon(Icons.email),
                    ),
                    ListTile(
                      title: Text('Rating'),
                      subtitle: Text('4 / 5.0'),
                      leading: Icon(Icons.star),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Function to fetch user profile data from the database based on the email
  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      return await databaseHelper.fetchUserProfileByEmail(userEmail);
    } catch (e) {
      throw ('Error fetching user profile data: $e');
    }
  }
}
