import 'dart:math';

import 'package:allergyalert/model/appwrite_sevices.dart';
import 'package:allergyalert/model/bottom_navgation_bar.dart';
import 'package:allergyalert/model/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  int _selectedIndex = 0;
  String email = '';
  String password = '';
  String name = '';
  String collectionId = '64ac1d467e6083b1bb04';
  String databaseId = '64ac1c588e458119e0d6';
  late String randomString;
  bool isLogin = false;
  bool isSignUp = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    // Define the characters to include in the random string
    const characters =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

    // Generate a random string of length 10
    randomString = String.fromCharCodes(
      List.generate(20,
          (_) => characters.codeUnitAt(Random().nextInt(characters.length))),
    );
    // print(randomString);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _signUp() async {
    setState(() {
      isSignUp = true;
    });
    try {
      final user = await account.create(
        userId: uniqueId,
        email: email,
        password: password,
        name: name,
      );

      if (kDebugMode) {
        print("User created with ID: ${user.$id}");
      }

      await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: uniqueId,
        data: {
          "userId": uniqueId,
          'email': email,
          'password': password,
          'name': name,
        },
      ).then((value) => {
            setState(() {
              _selectedIndex = 1;
            }),
            if (kDebugMode) {print('Document created with ID: ${value.$id}')}
          });

      // ignore: use_build_context_synchronously
    } catch (error) {
      if (kDebugMode) {
        print('Error during sign up: $error');
      }
      setState(() {
        isSignUp = false;
      });
      // Handle any errors that occurred during sign up
    }
  }

  Future<void> _login() async {
    setState(() {
      isLogin = true;
    });
    try {
      await account
          .createEmailSession(email: email, password: password)
          .then((value) => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyBottomNavigationBar(),
                  ),
                )
              });

      // Navigator.push<void>(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => const MyBottomNavigationBar(),
      //   ),
      // );
    } catch (error) {
      print('Error during sign in: $error');
      // Handle any errors that occurred during sign in
    }
    setState(() {
      isLogin = false;
    });
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
        // action: SnackBarAction(
        //   label: 'Undo',
        //   textColor: Colors.white,
        //   onPressed: () {
        //     // Implement your undo logic here
        //   },
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 56.0),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100.0,
                  width: 100.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _onItemTapped(0);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedIndex == 0
                                ? Colors.white
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.all(3),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 6),
                          width: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.login,
                                color: _selectedIndex == 0
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              Text(
                                'Sign In',
                                style: TextStyle(
                                  color: _selectedIndex == 0
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _onItemTapped(1);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedIndex == 1
                                ? Colors.white
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.all(3),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 6),
                          width: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.person_add,
                                color: _selectedIndex == 1
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: _selectedIndex == 1
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            _selectedIndex == 0
                                ? Icons.login
                                : Icons.person_add,
                            color: Colors.blue,
                            size: 28.0,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            _selectedIndex == 0
                                ? 'Welcome Back'
                                : 'Create an Account',
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_selectedIndex == 1) const SizedBox(height: 16.0),
                    if (_selectedIndex == 1)
                      TextField(
                        onChanged: (value) => {
                          setState(() {
                            name = value;
                          })
                        },
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.person),
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.email),
                        fillColor: Colors.grey[200],
                      ),
                      onChanged: (value) => {
                        setState(() {
                          email = value;
                        })
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        fillColor: Colors.grey[200],
                      ),
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24.0),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _selectedIndex == 0 ? _login() : _signUp();
                          _showSnackBar(_selectedIndex == 0
                              ? 'Login successful!'
                              : 'Registration successful! Now login.');
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: isLogin || isSignUp
                            ? Container(
                                // margin: EdgeInsets.all(12),
                                height: 22, width: 22,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3.0,
                                ),
                              )
                            : Text(
                                _selectedIndex == 0 ? 'Sign In' : 'Sign Up',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    const Center(
                      child: Text(
                        '---------- Or Continue With ----------',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            iconSize: 40,
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/images/google.png',
                              height: 60.0,
                              width: 60.0,
                              fit: BoxFit.fill,
                            ),
                          ),
                          IconButton(
                            iconSize: 40,
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/images/apple.png',
                              height: 60.0,
                              width: 60.0,
                              fit: BoxFit.fill,
                            ),
                          ),
                          IconButton(
                            iconSize: 40,
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/images/facebook.png',
                              height: 60.0,
                              width: 60.0,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
