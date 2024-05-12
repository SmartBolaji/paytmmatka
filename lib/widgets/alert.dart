import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<dynamic> alertDialog(
  BuildContext context,
  String message,
  String typeTitle,
  String amount,
  String txnId,
  Function onTap,
) {
  // Variables
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;

  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: const Border(
                top: BorderSide(width: 0.0, color: Colors.transparent),
              ),
            ),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 30, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue.shade700,
                            radius: 25,
                            child: const Icon(
                              Icons.done,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Text(
                            message,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontFamily: 'Nexa Bold',
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 25.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                typeTitle,
                                style: TextStyle(
                                    fontFamily: 'Nexa Light',
                                    fontSize: screenWidth / 25,
                                    // fontStyle: FontStyle.italic,
                                    color: Colors.black),
                              ),
                              Text(
                                amount,
                                style: TextStyle(
                                    fontFamily: 'Nexa Bold',
                                    fontSize: screenWidth / 25,
                                    // fontStyle: FontStyle.italic,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight / 49),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Transaction ID',
                                style: TextStyle(
                                    fontFamily: 'Nexa Light',
                                    fontSize: screenWidth / 25,
                                    // fontStyle: FontStyle.italic,
                                    color: Colors.black),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Copy
                                      Clipboard.setData(
                                          ClipboardData(text: txnId));
                                    },
                                    child: Icon(
                                      Icons.copy,
                                      size: 13,
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    txnId,
                                    style: TextStyle(
                                        fontFamily: 'Nexa Bold',
                                        fontSize: screenWidth / 25,
                                        // fontStyle: FontStyle.italic,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight / 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              onTap();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'View History',
                                  style: TextStyle(
                                      fontFamily: 'Nexa Bold',
                                      fontSize: screenWidth / 35,
                                      // fontStyle: FontStyle.italic,
                                      color: Colors.blue.shade800),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 13,
                                  color: Colors.blue.shade800,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Functions
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.blue[400]!, Colors.blue[900]!],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'OK',
                            style: TextStyle(
                                fontFamily: 'Nexa Bold',
                                fontSize: 18,
                                // fontStyle: FontStyle.italic,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ));
}
