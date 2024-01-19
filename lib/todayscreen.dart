// ignore_for_file: use_full_hex_values_for_flutter_colors, use_build_context_synchronously

import 'dart:async';

import 'package:attendxpert/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  // Define a GlobalKey
  GlobalKey<SlideActionState> slideActionKey = GlobalKey<SlideActionState>();

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  String checkIn = '--/--';
  String checkOut = '--/--';
  String location = '';
  String scanResult = '';
  String officeCode = '';

  Color primary = const Color(0xFFEEF444C);

  @override
  void initState() {
    super.initState();
    _getRecord();
    _getOfficeCode();
  }

  void _getOfficeCode() async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('Attributes')
          .doc('Office1')
          .get();

      setState(() {
        officeCode = snap['code'];
      });
    } catch (e) {
      null;
    }
  }

  Future<void> _scanQR() async {
    String result = '';

    try {
      result = await FlutterBarcodeScanner.scanBarcode(
          '#ffffff', 'Cancel', false, ScanMode.QR);
    } catch (e) {
      null;
    }

    setState(() {
      scanResult = result;
    });

    if (scanResult == officeCode) {
      if (User.long != 0) {
        // Search for the current location
        _getLocation();

        // get the current user id
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection('Employee')
            .where('id', isEqualTo: User.employeeid)
            .get();

        // assign the Record of the user to snap2
        DocumentSnapshot snap2 = await FirebaseFirestore.instance
            .collection('Employee')
            .doc(snap.docs[0].id)
            .collection('Record')
            .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
            .get();

        try {
          String checkIn = snap2['checkIn'];
          // perform this upon initial checkin and save update the Record
          await FirebaseFirestore.instance
              .collection('Employee')
              .doc(snap.docs[0].id)
              .collection('Record')
              .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
              .update({
            'date': Timestamp.now(),
            'checkIn': checkIn,
            'checkOut': DateFormat('hh:mm').format(DateTime.now()),
            'checkOutLocation': location,
          });
          setState(() {
            checkOut = DateFormat('hh:mm').format(DateTime.now());
          });
        } catch (e) {
          // otherwise, perform this as the checkIn
          await FirebaseFirestore.instance
              .collection('Employee')
              .doc(snap.docs[0].id)
              .collection('Record')
              .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
              .set({
            'date': Timestamp.now(),
            'checkIn': DateFormat('hh:mm').format(DateTime.now()),
            'checkOut': '--/--',
            'checkInLocation': location,
            'checkOutLocation': '',
          });
          setState(() {
            checkIn = DateFormat('hh:mm').format(DateTime.now());
          });
        }
        // Delay the reset operation
        Timer(const Duration(seconds: 1), () {
          if (slideActionKey.currentState != null) {
            slideActionKey.currentState!.reset();
          }
        });
      } else {
        showLocationDialog(context);
      }
    }
  }

  void _getLocation() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(User.lat, User.long);
    setState(() {
      location =
          '${placemark[0].street}, ${placemark[0].administrativeArea}, ${placemark[0].postalCode}, ${placemark[0].country}';
    });
  }

  void _getRecord() async {
    try {
      // get the current user id
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('Employee')
          .where('id', isEqualTo: User.employeeid)
          .get();

      // assign the Record of the user to snap2
      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection('Employee')
          .doc(snap.docs[0].id)
          .collection('Record')
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();

      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
      });
    } catch (e) {
      checkIn = '--/--';
      checkIn = '--/--';
    }
  }

  void showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0), // Adjust the padding as needed
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Please confirm that your location and internet are enabled before giving it another try.',
                  style: TextStyle(fontFamily: 'Nexa Light'),
                ),
                const SizedBox(
                    height:
                        20), // Adjust the spacing between content and button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Rounded corners for the button
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                  child: Container(
                    width: double.infinity, // Make button full width
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0), // Adjust button padding
                    child: const Center(
                      child: Text(
                        'OK',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Nexa Bold'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 32),
                      child: Text(
                        'Welcome',
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Nexa Light',
                          fontSize: screenWidth / 20,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Employee ${User.employeeid}',
                        style: TextStyle(
                          fontFamily: 'Nexa Bold',
                          fontSize: screenWidth / 18,
                        ),
                      ),
                    ),
                  ],
                ),
                checkOut == '--/--'
                    ? GestureDetector(
                        onTap: () {
                          _scanQR();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 26),
                          height: screenHeight / 18,
                          width: screenWidth / 10,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 10,
                                )
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.expand,
                                    size: 20,
                                    color: primary,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.qrcode,
                                    size: 10,
                                    color: primary,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : const Center()
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                'Today\'s status',
                style: TextStyle(
                  fontFamily: 'Nexa Bold',
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 32),
              height: 150,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(2, 2))
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Check In',
                          style: TextStyle(
                            fontFamily: 'Nexa Light',
                            fontSize: screenWidth / 20,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          checkIn,
                          style: TextStyle(
                            fontFamily: 'Nexa Bold',
                            fontSize: screenWidth / 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Check Out',
                          style: TextStyle(
                            fontFamily: 'Nexa Light',
                            fontSize: screenWidth / 20,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          checkOut,
                          style: TextStyle(
                            fontFamily: 'Nexa Bold',
                            fontSize: screenWidth / 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                    text: DateTime.now().day.toString(),
                    style: TextStyle(
                        color: primary,
                        fontSize: screenWidth / 18,
                        fontFamily: 'Nexa Bold'),
                    children: [
                      TextSpan(
                        text: DateFormat(' MMM yyyy').format(DateTime.now()),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth / 20,
                            fontFamily: 'Nexa Bold'),
                      )
                    ]),
              ),
            ),
            StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
                      style: TextStyle(
                        fontFamily: 'Nexa Light',
                        fontSize: screenWidth / 20,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }),
            checkOut == '--/--'
                ? Container(
                    margin: const EdgeInsets.only(top: 24, bottom: 12),
                    child: Builder(builder: (context) {
                      return SlideAction(
                        text: checkIn == '--/--'
                            ? 'Slide to Check In'
                            : 'Slide to Check Out',
                        textStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: screenWidth / 20,
                            fontFamily: 'Nexa Light'),
                        outerColor: Colors.white,
                        innerColor: primary,
                        key: slideActionKey,
                        onSubmit: () async {
                          if (User.long != 0) {
                            // Search for the current location
                            _getLocation();

                            // get the current user id
                            QuerySnapshot snap = await FirebaseFirestore
                                .instance
                                .collection('Employee')
                                .where('id', isEqualTo: User.employeeid)
                                .get();

                            // assign the Record of the user to snap2
                            DocumentSnapshot snap2 = await FirebaseFirestore
                                .instance
                                .collection('Employee')
                                .doc(snap.docs[0].id)
                                .collection('Record')
                                .doc(DateFormat('dd MMMM yyyy')
                                    .format(DateTime.now()))
                                .get();

                            try {
                              String checkIn = snap2['checkIn'];
                              // perform this upon initial checkin and save update the Record
                              await FirebaseFirestore.instance
                                  .collection('Employee')
                                  .doc(snap.docs[0].id)
                                  .collection('Record')
                                  .doc(DateFormat('dd MMMM yyyy')
                                      .format(DateTime.now()))
                                  .update({
                                'date': Timestamp.now(),
                                'checkIn': checkIn,
                                'checkOut':
                                    DateFormat('hh:mm').format(DateTime.now()),
                                'checkOutLocation': location,
                              });
                              setState(() {
                                checkOut =
                                    DateFormat('hh:mm').format(DateTime.now());
                              });
                            } catch (e) {
                              // otherwise, perform this as the checkIn
                              await FirebaseFirestore.instance
                                  .collection('Employee')
                                  .doc(snap.docs[0].id)
                                  .collection('Record')
                                  .doc(DateFormat('dd MMMM yyyy')
                                      .format(DateTime.now()))
                                  .set({
                                'date': Timestamp.now(),
                                'checkIn':
                                    DateFormat('hh:mm').format(DateTime.now()),
                                'checkOut': '--/--',
                                'checkInLocation': location,
                                'checkOutLocation': '',
                              });
                              setState(() {
                                checkIn =
                                    DateFormat('hh:mm').format(DateTime.now());
                              });
                            }
                            // Delay the reset operation
                            Timer(const Duration(seconds: 1), () {
                              if (slideActionKey.currentState != null) {
                                slideActionKey.currentState!.reset();
                              }
                            });
                          } else {
                            showLocationDialog(context);
                          }
                        },
                      );
                    }),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 32, bottom: 32),
                    child: Text(
                      'You have completed this day!',
                      style: TextStyle(
                        fontFamily: 'Nexa Light',
                        fontSize: screenWidth / 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
            // location != '' ? Text('Location + $location') : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
