import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ottov1/home_page.dart';
import 'package:ottov1/login_page.dart';

class register_page extends StatefulWidget {
  register_page({Key? key}) : super(key: key);

  static const String id = 'register';

  @override
  State<register_page> createState() => _register_pageState();
}

class _register_pageState extends State<register_page> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final bar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12),),
    );
    scaffoldKey.currentState!.showSnackBar(bar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var nameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void registerUser() async {

    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
    ).catchError((err) {
      PlatformException thisErr = err;
      showSnackBar(err);
    }
    )).user;

    if (user != null) {
      print('Registration Successful!');
      DatabaseReference newUserRef = FirebaseDatabase.instance.reference().child('users/${user.uid}');

      Map userMap = {
        'fullname': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      };

      newUserRef.set(userMap);

      Navigator.pushNamedAndRemoveUntil(context, home_page.id, (route) => false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget> [
                SizedBox(height: 70,),
                // Image(
                //   alignment: Alignment.center,
                //   height: 100.0,
                //   width: 100.0, image: null,
                // ),
                SizedBox(height: 40,),
                Text('Create a new account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget> [
                      // Full Name
                      TextField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10,),
                      // Email
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email address',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10,),
                      // Phone
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: 'Phone number',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10,),
                      // Password
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 40,),
                      RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(25)
                        ),
                        color: Colors.grey,
                        textColor: Colors.white,
                        onPressed: () async{

                          var isConnected = await Connectivity().checkConnectivity();

                          // Check for internet connection
                          if (isConnected != ConnectivityResult.mobile && isConnected != ConnectivityResult.wifi) {
                            showSnackBar('No Internet Connection Found');
                            return;
                          }
                          // Check for valid input
                          if (nameController.text.length < 3) {
                            showSnackBar('Please enter a valid full name');
                            return;
                          }
                          if (phoneController.text.length < 10) {
                            showSnackBar('Please enter a valid phone number');
                            return;
                          }
                          if (!emailController.text.contains('@')) {
                            showSnackBar('Please provide a valid email address');
                            return;
                          }
                          if (passwordController.text.length < 8) {
                            showSnackBar('Please provide a password that has at least 8 characters');
                            return;
                          }
                          registerUser();
                        },
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              'REGISTER',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, login_page.id, (route) => false);
                    },
                    child: Text('Already have an account? Log in here.')
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
