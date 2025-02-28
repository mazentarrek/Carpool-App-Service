import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginScreen.dart';
import 'ProfileDatabase.dart'; // Make sure this import is correct

class RegistrationScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final mydatabaseclass databaseHelper = mydatabaseclass();

  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9_.+-]+@eng\.asu\.edu\.eg$');

  void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Registration'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // This line enables the back functionality
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: 400,
                  height: 650,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Create new',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple)),
                        const SizedBox(height: 5),
                        const Text('Account',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple)),
                        Container(
                          width: 300,
                          child: TextField(
                            controller: firstNameController,
                            decoration: InputDecoration(labelText: 'First Name:'),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: 300,
                          child: TextField(
                            controller: lastNameController,
                            decoration: InputDecoration(labelText: 'Last Name:'),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: 300,
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(labelText: 'Email:'),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: 300,
                          child: TextField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(labelText: 'Password:'),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: 300,
                          child: TextField(
                            obscureText: true,
                            controller: confirmPasswordController,
                            decoration: InputDecoration(labelText: 'Confirm Password:'),
                          ),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () async {
                            if (passwordController.text == confirmPasswordController.text) {
                              if (emailRegex.hasMatch(emailController.text)) {
                                try {
                                  // Firebase user registration
                                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ).then((value) async {
                                    // Insert user details into the SQLite database
                                    await databaseHelper.insertUser(
                                      firstNameController.text,
                                      lastNameController.text,
                                      emailController.text,
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginScreen()),
                                    );
                                  });
                                } on FirebaseAuthException catch (e) {
                                  _showErrorDialog(context, 'Registration Error', e.message ?? 'An unknown error occurred');
                                } catch (e) {
                                  _showErrorDialog(context, 'Database Error', 'Failed to save user data.');
                                }
                              } else {
                                _showErrorDialog(context, 'Invalid Email', 'Please register with a valid @eng.asu.edu.eg email.');
                              }
                            } else {
                              _showErrorDialog(context, 'Password Mismatch', 'The passwords do not match.');
                            }
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
                                'Register',
                                style: TextStyle(fontSize: 22, color: Colors.white),
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
      ),
    );
  }
}
