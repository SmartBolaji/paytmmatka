// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameRatesScreen extends StatefulWidget {
  const GameRatesScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<GameRatesScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<GameRatesScreen> {
  TextEditingController pointController = TextEditingController();

  // Late variables
  late SharedPreferences sharedPreferences;

  // Get the current date
  DateTime now = DateTime.now();

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  Color primary = Colors.blue.shade300;

  // @override
  // void initState() {
  //   super.initState();
  //   checkCharacterLimit();
  // }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: screenHeight / 30,
            color: Colors.white,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Game Rates',
                style: TextStyle(
                  fontFamily: 'Nexa Bold',
                  fontSize: screenWidth / 17,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: screenWidth / 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customField('Single Digit', Icons.circle, '10 - 95', null,
                      false, true, null),
                  customField('Jodi Digit', Icons.circle, '10 - 950', null,
                      false, true, null),
                  customField('Single Pana', Icons.circle, '10 - 1400', null,
                      false, true, null),
                  customField('Double Pana', Icons.circle, '10 - 2800', null,
                      false, true, null),
                  customField('Triple Pana', Icons.circle, '10 - 10000', null,
                      false, true, null),
                  customField('Half Sangam', Icons.circle, '10 - 12000', null,
                      false, true, null),
                  customField('Full Sangam', Icons.circle, '10 - 120000', null,
                      false, true, null),
                  SizedBox(
                    height: screenHeight / 50,
                  ),
                ],
              ),
            )
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
      IconData? icon,
      String suffixtext,
      TextEditingController? controller,
      bool obscure,
      bool readOnly,
      Function(String)? onChanged) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(
        vertical: readOnly ? screenHeight / 35 : screenHeight / 50,
      ),
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
          readOnly
              ? SizedBox(
                  width: screenWidth / 6,
                  child: Icon(
                    icon,
                    color: primary,
                    size: screenWidth / 15,
                  ),
                )
              : SizedBox(
                  width: screenWidth / 10,
                ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(right: screenWidth / 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hint,
                      style: TextStyle(
                          fontFamily: 'Nexa Bold',
                          fontSize: screenWidth / 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    // SizedBox(
                    //   height: screenHeight / 30,
                    // ),
                    Text(
                      suffixtext,
                      style: TextStyle(
                          fontFamily: 'Nexa Bold',
                          fontSize: screenWidth / 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
