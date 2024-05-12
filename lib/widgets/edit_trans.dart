import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

Future<dynamic> editTransact(
  BuildContext context,
  DocumentSnapshot doc,
  double screenHeight,
  double screenWidth,
) {
  TextEditingController statusController =
      TextEditingController(text: doc['status']);

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
                            doc['txnid'],
                            style: const TextStyle(
                              fontFamily: 'Nexa Bold',
                              fontSize: 23,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: doc['txnid']));
                          },
                          child: Icon(
                            Icons.copy,
                            size: 20,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildInfoRow("ID", doc['id'].toString(),
                        doc['id'].toString(), () {}),
                    _buildInfoRow(
                        "Amount", doc['points'].toString(), null, null),
                    _buildInfoRow("Type", doc['type'], null, null),
                    _buildInfoRow("Method", doc['method'], null, null),
                    _buildStatusDropdown(
                        "Status", statusController, doc.reference, setState),
                    _buildInfoRow(
                        "Created",
                        DateFormat('M/dd/yyyy, h:mm:ss a').format(
                          doc['created'].toDate(),
                        ),
                        null,
                        null),
                    _buildInfoRow("Txn ID", doc['txnid'], null, null),
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

Widget _buildInfoRow(
    String label, String value, String? userid, Function? onTap) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
          child: GestureDetector(
            onTap: () {
              value == userid ? onTap!() : null;
            },
            child: Text(
              value,
              style: TextStyle(
                  fontFamily: 'Nexa Light',
                  fontSize: 16,
                  color: value == userid ? Colors.blue : Colors.black),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildStatusDropdown(String label, TextEditingController controller,
    DocumentReference documentRef, StateSetter setState) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
        const SizedBox(width: 8),
        DropdownButton<String>(
          dropdownColor: Colors.grey.shade200,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          value: controller.text,
          onChanged: (newValue) {
            controller.text = newValue!;
            documentRef.update({'status': newValue}).then((_) {
              setState(() {
                // Update local state to reflect the change immediately
                // This will trigger a rebuild and display the updated status
              });
            }).catchError((error) {
              error.toString();
            });
          },
          items: <String>['Pending', 'Completed']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Nexa Light',
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}
