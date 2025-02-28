import 'package:carpooling_service/OrderHistoryScreen.dart';
import 'package:carpooling_service/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'AvailableRoutes.dart';
import 'RegistrationScreen.dart';
import 'CartScreen.dart';
import 'PaymentScreen.dart';
import 'OrderHistoryScreen.dart';
import 'RideClass.dart';
import 'ProfileDatabase.dart';


Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  mydatabaseclass databaseHelper = mydatabaseclass();
  await databaseHelper.initiatedatabase();

  runApp(MaterialApp(

    initialRoute: '/LoginScreen',
    routes: {
      '/LoginScreen': (context) => LoginScreen(),
      '/AvailableRoutes': (context) => AvailableRoutes(userEmail: 'Default User Email',),
      '/RegistrationScreen': (context) => RegistrationScreen(),
      '/CartScreen': (context) {
        // Provide a default or initial value for selectedRide
        Ride defaultRide = Ride(
          startingLocation: 'Default Starting Location',
          destination: 'Default Destination',
          date: 'Default Date',
          price: 'Default Price',
          time: 'Default Time',
          status: 'Default Status',
          seats: 4,

        );

        return CartScreen(selectedRide: defaultRide, userEmail: 'Email',);
      },
      '/PaymentScreen': (context) {
        // Provide a default or initial value for selectedRide
          Ride defaultRide = Ride(
          startingLocation: 'Default Starting Location',
          destination: 'Default Destination',
          date: 'Default Date',
          price: 'Default Price',
          time: 'Default Time',
            status: 'Default Status',
            seats: 4,
        );

          return PaymentScreen(selectedRide: defaultRide, userEmail: 'Email',);
      },
      '/OrderHistoryScreen': (context) => OrderHistoryScreen(userEmail: 'Email',),


    },


  ));
}


