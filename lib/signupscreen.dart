
import 'package:paytmmatka/mainscreen.dart';
import 'package:paytmmatka/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController mController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  Color primary = Colors.blue.shade300;
  bool pass = true;
  bool pinpass = true;
  late SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  'Register!',
                  style: TextStyle(
                      fontSize: screenWidth / 18, fontFamily: 'Nexa Bold'),
                )),
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: screenWidth / 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customField('Username', Icons.person, null, idController,
                        false, () {}),
                    customField('Phone Number', Icons.phone_android, null,
                        mController, false, () {}),
                    customField(
                      'Password',
                      Icons.password,
                      pass ? Icons.visibility_off : Icons.visibility,
                      passController,
                      pass,
                      () {
                        setState(
                          () {
                            pass = !pass;
                          },
                        );
                      },
                    ),
                    customField(
                      'MPin',
                      Icons.pin,
                      pinpass ? Icons.visibility_off : Icons.visibility,
                      pinController,
                      pinpass,
                      () {
                        setState(
                          () {
                            pinpass = !pinpass;
                          },
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () async {
                        // Keypad closes
                        FocusScope.of(context).unfocus();

                        String id = idController.text.trim();
                        String password = passController.text.trim();

                        if (id.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Employee id is empty!')));
                        } else if (password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Password is empty!')));
                        } else {
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection('Employee')
                              .where('id', isEqualTo: id)
                              .get();

                          try {
                            if (password == snap.docs[0]['password']) {
                              User.employeeid = id;

                              sharedPreferences =
                                  await SharedPreferences.getInstance();

                              sharedPreferences
                                  .setString('employeeid', id)
                                  .then((_) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                             SafeArea(child: MainScreen())));
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Password is not correct!')));
                            }
                          } catch (e) {
                            String error = '';

                            if (e.toString() ==
                                'RangeError (index): Invalid value: Valid value range is empty: 0') {
                              setState(() {
                                error = 'Employee id does not exist!';
                              });
                            } else {
                              setState(() {
                                error = 'Error occurred!';
                              });
                            }
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(error)));
                          }
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
                          child: Text(
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
                              MaterialPageRoute(
                                  builder: (context) =>  MainScreen()));
                        },
                        child: Text(
                          'Login Now',
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

  Widget customField(String hint, IconData icon, IconData? suffixicon,
      TextEditingController controller, bool obscure, Function onTap) {
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
          Container(
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
