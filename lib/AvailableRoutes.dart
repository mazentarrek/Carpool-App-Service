import 'package:carpooling_service/CartScreen.dart';
import 'package:carpooling_service/OrderHistoryScreen.dart';
import 'package:carpooling_service/ProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'RideClass.dart';
import 'ProfileDatabase.dart';
import 'package:intl/intl.dart';


class AvailableRoutes extends StatefulWidget {
  final String userEmail;

  AvailableRoutes({Key? key, required this.userEmail});

  @override
  _AvailableRoutesState createState() => _AvailableRoutesState();
}

class _AvailableRoutesState extends State<AvailableRoutes> {
  DatabaseReference _ridesReference = FirebaseDatabase.instance.reference().child('rides');
  List<Ride> availableRoutes = [];

  @override
  void initState() {
    super.initState();
    _fetchRides();
  }

  void _fetchRides() {
    _ridesReference.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> ridesData = event.snapshot.value as Map<dynamic, dynamic>;

        // Convert the data to a list of Ride objects
        List<Ride> rides = ridesData.values.map<Ride>((value) {
          return Ride(
            startingLocation: value['startingLocation'],
            destination: value['destination'],
            date: value['date'],
            price: value['price'],
            time: value['time'],
            status: value['status'],
            seats: value['seats'],

          );
        }).where((ride) => ride.status != 'Completed').toList();

        setState(() {
          availableRoutes = rides;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Available Routes',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.grey),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _fetchRides(); // Refresh the list of rides
                });
              },
            ),
          ],
        ),
        drawer: NavigationDrawer(userEmail: widget.userEmail),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView.builder(
            itemCount: availableRoutes.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _handleRideTap(availableRoutes[index]);
                },
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: Icon(Icons.directions_car, color: Colors.black),
                      title: Text(
                        "${availableRoutes[index].startingLocation} to ${availableRoutes[index].destination}",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      subtitle: Text(
                        "Date: ${availableRoutes[index].date} - Time: ${availableRoutes[index].time} - Price: ${availableRoutes[index].price} - Seats: ${availableRoutes[index].seats} ",
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      trailing: _buildStatusTag(availableRoutes[index].status),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleRideTap(Ride ride) {
    final currentTime = DateTime.now();
    print("Current Time: ${currentTime}");
    final rideTime = DateFormat('h:mm a').parse(ride.time);

    if ((ride.time == '7:30 AM' && !currentTime.isBefore(DateTime(currentTime.year, currentTime.month, currentTime.day, 23, 30))) ||
        (ride.time == '5:30 PM' && !currentTime.isBefore(DateTime(currentTime.year, currentTime.month, currentTime.day, 16, 30)))) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Time Condition Not Met"),
            content: Text("This ride cannot be booked at this time. Do you want to proceed anyway?"),
            actions: <Widget>[
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text("Proceed Anyway"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _goToCartPage(ride);
                },
              ),
            ],
          );
        },
      );
    } else {
      _goToCartPage(ride);
    }
  }

  void _goToCartPage(Ride ride) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(selectedRide: ride, userEmail: widget.userEmail),
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    Color statusColor;

    switch (status) {
      case "Accepted":
        statusColor = Colors.green;
        break;
      case "Pending":
        statusColor = Colors.orange;
        break;
      case "Cancelled":
        statusColor = Colors.red;
        break;
      case "Completed":
        statusColor = Colors.black;
        break;

      default:
        statusColor =
            Colors.black; // Default color or another color for unknown status
    }

    return Container(
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        status,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final String userEmail;
  final mydatabaseclass databaseHelper = mydatabaseclass();

  NavigationDrawer({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FutureBuilder<Map<String, dynamic>>(
              future: databaseHelper.fetchUserFullNameByEmail(userEmail),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return buildHeader(context, snapshot.data!['fullName'], userEmail);
                  } else if (snapshot.hasError) {
                    // Handle error or show default data
                    return buildHeader(context, 'Unknown User', userEmail);
                  }
                }
                return CircularProgressIndicator(); // Loading indicator while fetching data
              },
            ),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, String fullName, String userEmail) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Column(
        children: [
          SizedBox(height: 12),
          Text(
            fullName, // Display the full name
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          SizedBox(height: 12),
          Text(
            userEmail,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    child: Wrap(
      runSpacing: 3,
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Profile'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfileScreen(userEmail: userEmail),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delivery_dining),
          title: const Text('Order History'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderHistoryScreen(userEmail: userEmail,)),
              );
            },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.push(
                context,
                 MaterialPageRoute(builder: (context) => LoginScreen()),
                   );
            });
          },
        ),
      ],
    ),
  );
}
