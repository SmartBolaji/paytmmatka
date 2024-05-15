import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:iconly/iconly.dart';

Future<dynamic> rewardUser(
  BuildContext context,
  DocumentSnapshot doc,
  double screenHeight,
  double screenWidth,
) {
  TextEditingController pointsController = TextEditingController();

  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
            ),
            margin: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            doc['id'].toString(),
                            style: const TextStyle(
                              fontFamily: 'Nexa Bold',
                              fontSize: 23,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            doc.reference.delete();
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Points: ',
                      style: TextStyle(
                        fontFamily: 'Nexa Light',
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      doc['points'].toString(),
                      style: const TextStyle(
                          fontFamily: 'Nexa Bold',
                          fontSize: 16,
                          color: Colors.blue),
                    ),
                    const SizedBox(height: 15),
                    _buildPointsField(context, "Enter Points", screenWidth,
                        pointsController, doc, doc.reference, setState),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildPointsField(
    BuildContext context,
    String label,
    double screenWidth,
    TextEditingController controller,
    DocumentSnapshot doc,
    DocumentReference documentRef,
    StateSetter setState) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: screenWidth / 20),
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
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(
                  fontFamily: 'Nexa Light',
                  fontSize: screenWidth / 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    FontAwesome5.save,
                    color: Colors.grey.shade600,
                    size: screenWidth / 15,
                  ),
                ),
                hintText: 'Enter Point',
                hintStyle: TextStyle(
                    fontFamily: 'Nexa Light',
                    fontSize: screenWidth / 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600),
                border: InputBorder.none,
                // filled: true,
                // fillColor: Colors.white,
              ),
              onChanged: (newValue) async {
                // Validate and save the new points value
                double? newPoints = double.tryParse(newValue);
                if (newPoints != null) {
                  await documentRef
                      .update({'points': doc['points'] + newPoints}).then((_) {
                    setState(() {
                      // Update local state to reflect the change immediately
                      // This will trigger a rebuild and display the updated points
                    });
                  }).catchError((error) {
                    error.toString();
                  });
                }
              },
            ),
          ),
        ),
      ],
    ),
  );
}
