import 'package:page_transition/page_transition.dart';
import 'package:paytmmatka/mainscreen.dart';
import 'package:paytmmatka/model/test.dart';
import 'package:paytmmatka/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paytmmatka/screens/fgt_pass.dart';
import 'package:paytmmatka/services/task_data.dart';
import 'package:paytmmatka/signupscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  Color primary = Colors.blue.shade300;
  bool pass = true;
  bool circular = false;
  late SharedPreferences sharedPreferences;

  int _id = 0;
  String _password = '';

  @override
  Widget build(BuildContext context) {
    // Provider
    final taskData = Provider.of<TaskData>(context);

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight / 2.5,
              width: screenWidth,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(70))),
              child: Center(
                  child: Image.asset(
                'assets/images/logo.jpg',
                width: screenWidth / 3,
                height: screenHeight / 3,
              )),
            ),
            Container(
                margin: EdgeInsets.only(
                    top: screenHeight / 15, bottom: screenHeight / 20),
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: screenWidth / 18, fontFamily: 'Nexa Bold'),
                )),
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: screenWidth / 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // fieldTitle('Mobile Number'),
                    customField(
                      'Mobile Number',
                      Icons.person,
                      null,
                      idController,
                      false,
                      (String id) {
                        setState(() {
                          _id = int.parse(id);
                        });
                      },
                      () {},
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // fieldTitle('Password'),
                        fgtPass('Forget Password?', onTap: () { Navigator.push(
                                context,
                                PageTransition(
                                  child: const ForgetPassScreen(),
                                  type: PageTransitionType.leftToRight,
                                  duration: const Duration(milliseconds: 500),
                                  reverseDuration:
                                      const Duration(milliseconds: 500),
                                ),
                              );})
                      ],
                    ),
                    customField(
                        'Password',
                        Icons.password,
                        pass ? Icons.visibility_off : Icons.visibility,
                        passController,
                        pass, (String pass) {
                      setState(() {
                        _password = pass;
                      });
                    }, () {
                      setState(() {
                        pass = !pass;
                      });
                    }),
                    GestureDetector(
                      onTap: () async {
                        // Keypad closes
                        FocusScope.of(context).unfocus();

                        // Start rolling
                        setState(() {
                          circular = true;
                        });

                        if (_id == 0 && _password == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.blue.shade300,
                              content: Text(
                                'Enter a valid number and password and try again!',
                                style: TextStyle(
                                  fontFamily: 'Nexa Light',
                                  fontSize: screenWidth / 30,
                                  color: Colors.white,
                                ),
                              )));
                          // Stop rolling
                          setState(() {
                            circular = false;
                          });
                        } else if (_id == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.blue.shade300,
                              content: Text(
                                'Mobile number is empty, try again!',
                                style: TextStyle(
                                  fontFamily: 'Nexa Light',
                                  fontSize: screenWidth / 30,
                                  color: Colors.white,
                                ),
                              )));
                          // Stop rolling
                          setState(() {
                            circular = false;
                          });
                        } else if (_password == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.blue.shade300,
                              content: Text(
                                'Password is empty, make changes and try again!',
                                style: TextStyle(
                                  fontFamily: 'Nexa Light',
                                  fontSize: screenWidth / 30,
                                  color: Colors.white,
                                ),
                              )));
                          // Stop rolling
                          setState(() {
                            circular = false;
                          });
                        } else {
                          try {
                            QuerySnapshot snap = await FirebaseFirestore
                                .instance
                                .collection('Users')
                                .where('id', isEqualTo: _id)
                                .get();

                            // Variables
                            String name = snap.docs[0]['name'];
                            double pts = snap.docs[0]['points'];
                            int mpin = snap.docs[0]['mpin'];

                            if (snap.docs[0].exists &&
                                _password == snap.docs[0]['pass']) {
                              taskData.saveLogs(_id, name, pts, mpin);
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  child: const MainScreen(),
                                  type: PageTransitionType.leftToRight,
                                  duration: const Duration(milliseconds: 500),
                                  reverseDuration:
                                      const Duration(milliseconds: 500),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      backgroundColor: Colors.blue.shade300,
                                      content: Text(
                                        'Password is not correct!',
                                        style: TextStyle(
                                          fontFamily: 'Nexa Light',
                                          fontSize: screenWidth / 30,
                                          color: Colors.white,
                                        ),
                                      )));
                            }
                          } catch (e) {
                            print(e.toString());
                            String error = '';

                            if (e.toString() ==
                                'RangeError (index): Invalid value: Valid value range is empty: 0') {
                              setState(() {
                                error = 'Invalid account, does not exist!';
                              });
                            } else {
                              setState(() {
                                error = 'Error occurred!';
                              });
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.blue.shade300,
                                content: Text(
                                  error,
                                  style: TextStyle(
                                    fontFamily: 'Nexa Light',
                                    fontSize: screenWidth / 30,
                                    color: Colors.white,
                                  ),
                                )));
                          }
                          // Stop rolling
                          setState(() {
                            circular = false;
                          });
                        }
                      },
                      child: Container(
                        height: 60,
                        width: screenWidth,
                        margin: EdgeInsets.only(top: screenHeight / 40),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Center(
                          child: circular
                              ? Transform.scale(
                                  scale: 0.5,
                                  child: const CircularProgressIndicator(
                                      color: Colors.white))
                              : Text(
                                  'Login',
                                  style: TextStyle(
                                      fontFamily: 'Nexa Bold',
                                      fontSize: screenWidth / 26,
                                      color: Colors.white,
                                      letterSpacing: 2),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight / 50,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: const SignUpScreen(),
                              type: PageTransitionType.rightToLeft,
                              duration: const Duration(milliseconds: 500),
                              reverseDuration:
                                  const Duration(milliseconds: 500),
                            ),
                          );
                        },
                        child: Text(
                          'Register Now',
                          style: TextStyle(
                              fontFamily: 'Nexa Bold',
                              fontSize: screenWidth / 30,
                              color: Colors.blue.shade300,
                              letterSpacing: 2),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight / 20,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(fontSize: screenWidth / 26, fontFamily: 'Nexa Bold'),
      ),
    );
  }

  Widget fgtPass(String title, {required Function onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Text(
          title,
          style: TextStyle(
              fontSize: screenWidth / 30,
              fontFamily: 'Nexa Bold',
              color: Colors.blue.shade300),
        ),
      ),
    );
  }

  Widget customField(
      String hint,
      IconData icon,
      IconData? suffixicon,
      TextEditingController controller,
      bool obscure,
      Function(String) onChanged,
      Function onTap) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 2),
            )
          ]),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth / 6,
            child: Icon(
              icon,
              color: primary,
              size: screenWidth / 15,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 30),
              child: TextFormField(
                style: TextStyle(
                    fontFamily: 'Nexa Light',
                    fontSize: screenWidth / 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                controller: controller,
                onChanged: (value) {
                  onChanged(value);
                },
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: screenHeight / 35),
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(
                      fontFamily: 'Nexa Light',
                      fontSize: screenWidth / 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      onTap();
                    },
                    child: Icon(
                      suffixicon,
                      color: Colors.grey.shade600,
                      size: screenWidth / 15,
                    ),
                  ),
                ),
                maxLines: 1,
                obscureText: obscure,
              ),
            ),
          )
        ],
      ),
    );
  }
}
