import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const UserDetailsPage({Key? key, required this.doc}) : super(key: key);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController pointsController;
  late TextEditingController bankController;
  late TextEditingController acctHolderController;
  late TextEditingController acctNoController;
  late TextEditingController ifscController;
  late TextEditingController paytmController;
  late TextEditingController phonepeController;
  late TextEditingController gpayController;

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.doc['id'].toString());
    nameController = TextEditingController(text: widget.doc['name']);
    pointsController =
        TextEditingController(text: widget.doc['points'].toString());
    bankController = TextEditingController(text: widget.doc['bank']);
    acctHolderController =
        TextEditingController(text: widget.doc['acctholder']);
    acctNoController =
        TextEditingController(text: widget.doc['acctno'].toString());
    ifscController = TextEditingController(text: widget.doc['ifsc'].toString());
    paytmController =
        TextEditingController(text: widget.doc['paytm'].toString());
    phonepeController =
        TextEditingController(text: widget.doc['phonepe'].toString());
    gpayController = TextEditingController(text: widget.doc['gpay'].toString());
  }

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
                nameController.text.trim(),
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
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'Personal Information',
              style: TextStyle(
                fontFamily: 'Nexa Bold',
                fontSize: screenWidth / 20,
                color: Colors.black,
              ),
            ),
            _buildTextField("ID", idController),
            _buildTextField("Name", nameController),
            _buildTextField("Points", pointsController),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Payment Information',
              style: TextStyle(
                fontFamily: 'Nexa Bold',
                fontSize: screenWidth / 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildTextField("Bank", bankController),
            _buildTextField("Account Holder", acctHolderController),
            _buildTextField("Account Number", acctNoController),
            _buildTextField("IFSC", ifscController),
            _buildTextField("Paytm", paytmController),
            _buildTextField("PhonePe", phonepeController),
            _buildTextField("Google Pay", gpayController),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateUserDetails,
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
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
      child: Padding(
        padding: EdgeInsets.only(left: screenWidth / 30),
        child: TextFormField(
          controller: controller,
          style: TextStyle(
            fontFamily: 'Nexa Light',
            fontSize: screenWidth / 25,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: screenHeight / 50,
            ),
            border: InputBorder.none,
            labelText: label,
            labelStyle: TextStyle(
              fontFamily: 'Nexa Bold',
              fontSize: screenWidth / 25,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void _updateUserDetails() {
    final Map<String, dynamic> updatedData = {
      'id': int.parse(idController.text),
      'name': nameController.text,
      'points': double.parse(pointsController.text),
      'bank': bankController.text,
      'acctholder': acctHolderController.text,
      'acctno': int.parse(acctNoController.text),
      'ifsc': int.parse(ifscController.text),
      'paytm': int.parse(paytmController.text),
      'phonepe': int.parse(phonepeController.text),
      'googlepay': int.parse(gpayController.text),
    };

    widget.doc.reference.update(updatedData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blue.shade300,
          content: Text(
            'Saved!',
            style: TextStyle(
              fontFamily: 'Nexa Light',
              fontSize: screenWidth / 30,
              color: Colors.white,
            ),
          ),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Unable to update, try again later!',
            style: TextStyle(
              fontFamily: 'Nexa Light',
              fontSize: screenWidth / 30,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }
}
