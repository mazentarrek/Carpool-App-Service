import 'package:flutter/material.dart';
import 'RideClass.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderHistoryScreen extends StatefulWidget {
  final String userEmail;

  const OrderHistoryScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  DatabaseReference _ridesReference = FirebaseDatabase.instance.reference().child('rides');
  List<Ride> availableRoutes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRides(widget.userEmail);
  }

  void _fetchRides(String userEmail) {
    print('Fetching rides for userEmail: $userEmail');

    _ridesReference.orderByChild('userEmail').equalTo(userEmail).once().then((DatabaseEvent event) {
      print('Snapshot value: ${event.snapshot.value}');

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> ridesData = event.snapshot.value as Map<dynamic, dynamic>;

        // Convert the data to a list of Ride objects with the specified conditions
        List<Ride> rides = ridesData.values.where((value) {
          print('Checking value: $value');
          return value['status'] == 'Completed';
        }).map<Ride>((value) {
          return Ride(
            startingLocation: value['startingLocation'],
            destination: value['destination'],
            date: value['date'],
            price: value['price'],
            time: value['time'],
            status: value['status'],
            seats: value['seats'],

          );
        }).toList();

        print("Rides: $rides");

        setState(() {
          availableRoutes = rides;
          isLoading = false;
        });
      } else {
        setState(() {
          availableRoutes = [];
          isLoading = false;
        });
      }
    }).catchError((error) {
      print('Error fetching rides: $error');
      setState(() {
        availableRoutes = [];
        isLoading = false;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black), // Adjust color if needed
                onPressed: () => Navigator.of(context).pop(),
              ),
              expandedHeight: 100.0,
              pinned: true,
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: const Text(
                  'Order History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLoading)
                      CircularProgressIndicator()
                    else if (availableRoutes.isEmpty)
                      Text('No completed rides available.')
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: availableRoutes.length,
                        itemBuilder: (context, index) {
                          return _buildOrderItem(availableRoutes[index]);
                        },
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Ride ride) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ride #', // Include the ride number
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Route: [${ride.startingLocation} - ${ride.destination}]',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Delivered on ${ride.date}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Text(
                'Delivery time: ${ride.time}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
