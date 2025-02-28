import 'package:carpooling_service/PaymentScreen.dart';
import 'package:flutter/material.dart';
import 'RideClass.dart';

class CartScreen extends StatefulWidget {
  final Ride selectedRide;
  final String userEmail;

  const CartScreen({Key? key, required this.selectedRide, required this.userEmail}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Example data, replace it with the actual data from your application
  String pickupLocation = '';
  String destination = '';
  String selectedDate = ''; // Replace with actual date
  String selectedTime = ''; // Replace with actual time
  String totalFare = ''; // Replace with actual fare

  @override
  void initState() {
    super.initState();
    // Initialize data based on the selected ride
    pickupLocation = widget.selectedRide.startingLocation;
    destination = widget.selectedRide.destination;
    selectedDate = widget.selectedRide.date;
    selectedTime = widget.selectedRide.time;
    totalFare = widget.selectedRide.price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Your Cart',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reservation Summary', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    const Text('Selected Route Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Pickup: $pickupLocation', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 10),
                    Text('Destination: $destination', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 1,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    const Text('Date and Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Selected Date: $selectedDate', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 10),
                    Text('Selected Time: $selectedTime', style: TextStyle(fontSize: 14)),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 1,
                      color: Colors.grey,
                    ),
                    const Text('Payment Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Total Fare: \$$totalFare', style: TextStyle(fontSize: 14)),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 30,),
                    Row(
                      children: [
                        Text('Promo Code: '),
                        SizedBox(width: 130, child: TextField()),
                        SizedBox(width: 90, child: ElevatedButton(onPressed: () {}, child: Text('Apply'))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentScreen(selectedRide: widget.selectedRide, userEmail: widget.userEmail)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: Text('Proceed to Payment', style: TextStyle(fontSize: 17, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
