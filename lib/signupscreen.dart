import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paytmmatka/mainscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paytmmatka/services/task_data.dart';
import 'package:paytmmatka/widgets/phoneotp.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mpinController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  Color primary = Colors.blue.shade300;
  bool pass = true;
  bool mpass = true;
  bool circular = false;

  // Valid variables
  int _id = 0;
  String _password = '';
  String _name = '';
  double _points = 9.0;
  int _mPin = 0;
  String _verifyid = '';

  @override
  Widget build(BuildContext context) {
    // Provider
    final taskData = Provider.of<TaskData>(context);

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
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
                      customField('Full Name', Icons.person, false, null,
                          nameController, false, (String name) {
                        setState(() {
                          _name = name;
                        });
                      }, () {}),
                      customField('Mobile Number', Icons.phone_android, false,
                          Icons.quiz, idController, false, (String id) {
                        setState(() {
                          _id = int.parse(id);
                        });
                      }, () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.blue.shade300,
                            content: Text(
                              'Please include your country code before your mobile number, e.g. +919530196562.',
                              style: TextStyle(
                                fontFamily: 'Nexa Bold',
                                fontSize: screenWidth / 30,
                                color: Colors.white,
                              ),
                            )));
                      }),
                      customField(
                        'Password',
                        Icons.password,
                        false,
                        pass ? Icons.visibility_off : Icons.visibility,
                        passController,
                        pass,
                        (String pass) {
                          setState(() {
                            _password = pass;
                          });
                        },
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
                        true,
                        mpass ? Icons.visibility_off : Icons.visibility,
                        mpinController,
                        mpass,
                        (String mpin) {
                          setState(() {
                            _mPin = int.parse(mpin);
                          });
                        },
                        () {
                          setState(
                            () {
                              mpass = !mpass;
                            },
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Keypad closes
                          FocusScope.of(context).unfocus();

                          // Start rolling
                          setState(() {
                            circular = true;
                          });

                          if (_name == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.blue.shade300,
                                content: Text(
                                  'Enter a valid name and try again!',
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.blue.shade300,
                                content: Text(
                                  'Mobile number is empty, make changes and try again!',
                                  style: TextStyle(
                                    fontFamily: 'Nexa Light',
                                    fontSize: screenWidth / 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );

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
                            await _auth.verifyPhoneNumber(
                              phoneNumber: idController.text.trim(),
                              verificationCompleted: (credential) async {
                                // await _auth.signInWithCredential(credential);
                              },
                              verificationFailed: (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.blue.shade300,
                                    content: Text(
                                      e.message.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Nexa Light',
                                        fontSize: screenWidth / 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              codeSent: (verifyId, forceResend) {
                                setState(() {
                                  _verifyid = verifyId;
                                });
                              },
                              codeAutoRetrievalTimeout: (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.blue.shade300,
                                    content: Text(
                                      e.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Nexa Light',
                                        fontSize: screenWidth / 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );

                            QuerySnapshot snap = await FirebaseFirestore
                                .instance
                                .collection('Users')
                                .where('id', isEqualTo: _id)
                                .get();

                            try {
                              if (snap.docs.isEmpty) {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: PhoneOtpScreen(
                                      verifyId: _verifyid,
                                      id: _id,
                                      pass: _password,
                                      mpin: _mPin,
                                      name: _name,
                                      points: _points,
                                    ),
                                    type: PageTransitionType.leftToRight,
                                    duration: const Duration(milliseconds: 500),
                                    reverseDuration:
                                        const Duration(milliseconds: 500),
                                  ),
                                );

                                // Stop rolling
                                setState(() {
                                  circular = false;
                                });
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        backgroundColor: Colors.blue.shade300,
                                        content: Text(
                                          'Account already exist in our database!',
                                          style: TextStyle(
                                            fontFamily: 'Nexa Light',
                                            fontSize: screenWidth / 30,
                                            color: Colors.white,
                                          ),
                                        )));
                              }
                            } catch (e) {
                              String error = '';

                              if (e.toString() ==
                                  'RangeError (index): Invalid value: Valid value range is empty: 0') {
                                setState(() {
                                  error =
                                      'This is an existing account, make changes and try again!';
                                });
                              } else {
                                setState(() {
                                  error = 'Error occurred!';
                                });
                              }
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      backgroundColor: Colors.blue.shade300,
                                      content: Text(
                                        error,
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
                            child: circular
                                ? Transform.scale(
                                    scale: 0.5,
                                    child: const CircularProgressIndicator(
                                        color: Colors.white))
                                : Text(
                                    'Register Now',
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
                            Navigator.pop(context);
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
      bool numOnly,
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
                keyboardType:
                    numOnly ? TextInputType.number : TextInputType.text,
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
