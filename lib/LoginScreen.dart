import 'package:carpooling_service/AvailableRoutes.dart';
import 'package:carpooling_service/RegistrationScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreenHomePage(),
    );
  }
}

class LoginScreenHomePage extends StatelessWidget {
  LoginScreenHomePage({Key? key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 500,
                  height: 380,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Carpool',
                      style: TextStyle(
                        fontSize: 60,
                        fontFamily: 'monoton',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email:'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 200,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password:'),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    if (email.isEmpty && password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter your Email and Password.'),
                        ),
                      );
                      return;
                    }

                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter your email.')),
                      );
                      return;
                    }

                    if (password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter your password.')),
                      );
                      return;
                    }

                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    )
                        .then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AvailableRoutes(userEmail: email),
                        ),
                      );
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                          Text('Invalid email or password. Please try again.'),
                        ),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const SizedBox(
                    width: 250,
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(fontSize: 16.0),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Register now',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
