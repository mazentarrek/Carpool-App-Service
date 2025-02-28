import 'package:carpooling_service/AvailableRoutes.dart';
import 'package:flutter/material.dart';
import 'RideClass.dart';
import 'package:firebase_database/firebase_database.dart';

class PaymentScreen extends StatefulWidget {
  final Ride selectedRide;
  final String userEmail;

  const PaymentScreen({Key? key, required this.selectedRide, required this.userEmail}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool? isVisaSelected;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Payment', style: TextStyle(color: Colors.purple),),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back when the back button is pressed
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 380,
              height: isVisaSelected == true ? 550 : 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Payment Options',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildPaymentOption('Cash'),
                      _buildPaymentOption('Visa'),
                      if (isVisaSelected == true) _buildVisaDetails(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Implement logic to proceed with payment
                          if (isVisaSelected == true) {

                            _acceptRide(widget.selectedRide, widget.userEmail);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AvailableRoutes(userEmail: widget.userEmail)),
                            );
                          } else {

                            _acceptRide(widget.selectedRide, widget.userEmail);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AvailableRoutes(userEmail: widget.userEmail)),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const SizedBox(
                          width: 200,
                          child: Center(
                            child: Text(
                              'Confirm Payment',
                              style: TextStyle(fontSize: 19, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String option) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Radio(
            value: option == 'Visa', // This line was corrected
            groupValue: isVisaSelected,
            onChanged: (value) {
              setState(() {
                isVisaSelected = value as bool; // This line was corrected
              });
            },
          ),
          Text(
            option,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildVisaDetails() {
    return const Column(
      children: [
        SizedBox(height: 10),
        Text(
          'Visa Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(labelText: 'Card Number'),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(labelText: 'Expiry Date'),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(labelText: 'CVV'),
        ),
      ],
    );
  }

  void _acceptRide(Ride ride, String email) async {
    final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
    try {
      // Search for the ride with the matching starting location and destination
      DatabaseEvent event = await _databaseReference.child('rides')
          .orderByChild('startingLocation')
          .equalTo(ride.startingLocation)
          .once();

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> ridesData = event.snapshot.value as Map<dynamic, dynamic>;
        String rideKey = '';
        int currentSeats = 0;

        // Iterate over the results to find the ride with the matching destination
        ridesData.forEach((key, value) {
          if (value is Map && value['destination'] == ride.destination) {
            rideKey = key;
            currentSeats = int.tryParse(value['seats'].toString()) ?? 0; // Parse the seats count as integer
          }
        });

        if (rideKey.isNotEmpty && currentSeats > 0) {
          int updatedSeats = currentSeats - 1; // Decrement the seats count by 1

          // Update the status and seats of the matching ride
          await _databaseReference.child('rides').child(rideKey).update({
            'status': 'Accepted',
            'userEmail': email,
            'seats': updatedSeats, // Update the seats count
          });
          print('Ride accepted successfully with updated seats');
        } else {
          print('Ride not found or no seats available');
        }
      } else {
        print('Ride not found');
      }
    } catch (error) {
      print('Error searching for or accepting ride: $error');
    }
  }

}