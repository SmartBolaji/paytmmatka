import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

Future<dynamic> viewInfo(BuildContext context, DocumentSnapshot doc,
    double screenHeight, screenWidth) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0))),
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      doc['trackid'],
                      style: const TextStyle(
                        fontFamily: 'Nexa Bold',
                        fontSize: 23,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        // Copy
                        Clipboard.setData(ClipboardData(text: doc['trackid']));
                      },
                      child: Icon(
                        Icons.copy,
                        size: 20,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                _buildInfoRow(
                    "ID", doc['id'].toString(), screenHeight, screenWidth),
                _buildInfoRow(
                    "Market", doc['market'], screenHeight, screenWidth),
                _buildInfoRow(
                    "Market Type", doc['mrktype'], screenHeight, screenWidth),
                _buildInfoRow(
                    "Session", doc['session'], screenHeight, screenWidth),
                _buildInfoRow("Digit", doc['digit'].toString(), screenHeight,
                    screenWidth),
                _buildInfoRow("Open Pana", doc['openpana'].toString(),
                    screenHeight, screenWidth),
                _buildInfoRow("Close Pana", doc['closepana'].toString(),
                    screenHeight, screenWidth),
                _buildInfoRow("Points", doc['points'].toString(), screenHeight,
                    screenWidth),
                _buildInfoRow(
                    "Created",
                    DateFormat('M/dd/yyyy, h:mm:ss a')
                        .format(doc['created'].toDate()),
                    screenHeight,
                    screenWidth),
                _buildInfoRow(
                    "Track ID", doc['trackid'], screenHeight, screenWidth),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildInfoRow(
    String label, String value, double screenHeight, screenWidth) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Container(
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
      padding: EdgeInsets.symmetric(
          vertical: screenHeight / 50, horizontal: screenWidth / 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontFamily: 'Nexa Bold',
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Nexa Light',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
