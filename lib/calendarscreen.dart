import 'package:paytmmatka/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    Color primary = const Color(0xFFEEF444C);

    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child: Text(
              'My Attendance',
              style: TextStyle(
                fontFamily: 'Nexa Bold',
                fontSize: screenWidth / 18,
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 32),
                child: Text(
                  User.month,
                  style: TextStyle(
                    fontFamily: 'Nexa Bold',
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(top: 32),
                child: GestureDetector(
                  onTap: () async {
                    final month = await showMonthYearPicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2099),
                      builder: (context, child) {
                        return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                  primary: primary,
                                  secondary: primary,
                                  onSecondary: Colors.white),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: primary,
                                ),
                              ),
                              textTheme: const TextTheme(
                                headlineMedium:
                                    TextStyle(fontFamily: 'Nexa Bold'),
                                labelSmall: TextStyle(fontFamily: 'Nexa Bold'),
                                labelLarge: TextStyle(fontFamily: 'Nexa Bold'),
                                // displaySmall:
                                //     TextStyle(fontFamily: 'Nexa Light'),
                              ),
                            ),
                            child: child!);
                      },
                    );

                    if (month != null) {
                      setState(() {
                        User.month = DateFormat('MMMM').format(month);
                      });
                    }
                  },
                  child: Text(
                    'Pick a Month',
                    style: TextStyle(
                      fontFamily: 'Nexa Bold',
                      fontSize: screenWidth / 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
              height: screenHeight / 1.4,
              child: User.id != ''
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Employee')
                          .doc(User.id)
                          .collection('Record')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          final snap = snapshot.data!.docs;
                          return ListView.builder(
                              itemCount: snap.length,
                              itemBuilder: (context, index) {
                                return DateFormat('MMMM').format(
                                            snap[index]['date'].toDate()) ==
                                        User.month
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            top: index > 0 ? 12 : 0,
                                            left: 6,
                                            right: 6),
                                        height: 150,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 10,
                                                  offset: Offset(2, 2))
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                  color: primary,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    DateFormat('EE\ndd').format(
                                                        snap[index]['date']
                                                            .toDate()),
                                                    style: TextStyle(
                                                      fontFamily: 'Nexa Light',
                                                      fontSize:
                                                          screenWidth / 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Check In',
                                                    style: TextStyle(
                                                      fontFamily: 'Nexa Light',
                                                      fontSize:
                                                          screenWidth / 20,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  Text(
                                                    snap[index]['checkIn'],
                                                    style: TextStyle(
                                                      fontFamily: 'Nexa Bold',
                                                      fontSize:
                                                          screenWidth / 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Check Out',
                                                    style: TextStyle(
                                                      fontFamily: 'Nexa Light',
                                                      fontSize:
                                                          screenWidth / 20,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  Text(
                                                    snap[index]['checkOut'],
                                                    style: TextStyle(
                                                      fontFamily: 'Nexa Bold',
                                                      fontSize:
                                                          screenWidth / 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox();
                              });
                        } else {
                          return const SizedBox();
                        }
                      },
                    )
                  : const SizedBox())
        ],
      ),
    ));
  }
}
