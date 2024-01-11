import 'dart:io';

import 'package:attendxpert/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  Color primary = const Color(0xFFEEF444C);
  String birth = 'Date of Birth';

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    Reference ref = FirebaseStorage.instanceFor(
            bucket: 'gs://attendance-app-479e1.appspot.com')
        .ref()
        .child('${User.employeeid.toLowerCase()}_profilepic.jpg');

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) {
      setState(() {
        User.profilePicLink = value;
      });
    });
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
            GestureDetector(
              onTap: () {
                pickUploadProfilePic();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 80, bottom: 24),
                height: 120,
                width: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: primary),
                child: Center(
                  child: User.profilePicLink == ''
                      ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 80,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(User.profilePicLink)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Employee ${User.employeeid}',
                style: const TextStyle(fontFamily: 'Nexa Bold', fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            textField(
                'First Name',
                User.canEdit ? 'First name' : User.firstName,
                firstNameController),
            textField('Last Name', User.canEdit ? 'Last name' : User.lastName,
                lastNameController),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Date of Birth',
                style:
                    TextStyle(fontFamily: 'Nexa Bold', color: Colors.black87),
              ),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
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
                  ).then((value) {
                    setState(() {
                      birth = DateFormat('MM/dd/yyyy').format(value!);
                    });
                  });
                } catch (e) {
                  null;
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.only(left: 11),
                height: kToolbarHeight,
                width: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.black54),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    User.canEdit ? birth : User.birthDate,
                    style: const TextStyle(
                      fontFamily: 'Nexa Bold',
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            textField('Address', User.canEdit ? 'Address' : User.address,
                addressController),
            GestureDetector(
              onTap: () async {
                // Keypad closes
                FocusScope.of(context).unfocus();

                String firstName = firstNameController.text.trim();
                String lastName = lastNameController.text;
                String birthDate = birth;
                String address = addressController.text;
                String profilePic = User.profilePicLink;

                if (User.canEdit) {
                  if (firstName.isEmpty) {
                    showAlertDialog(context, 'Please enter your first name!');
                  } else if (lastName.isEmpty) {
                    showAlertDialog(context, 'Please enter your last name!');
                  } else if (birthDate.isEmpty ||
                      birthDate == 'Date of Birth') {
                    showAlertDialog(
                        context, 'Please enter your date of birth!');
                  } else if (address.isEmpty) {
                    showAlertDialog(context, 'Please enter your address!');
                  } else {
                    await FirebaseFirestore.instance
                        .collection('Employee')
                        .doc(User.id)
                        .update({
                      'firstName': firstName,
                      'lastName': lastName,
                      'birthDate': birthDate,
                      'address': address,
                      'profilePic': profilePic,
                      'canEdit': false
                    }).then((_) {
                      setState(() {
                        User.firstName = firstName;
                        User.lastName = lastName;
                        User.birthDate = birthDate;
                        User.address = address;
                        User.profilePicLink = profilePic;
                        User.canEdit = false;
                      });
                      showAlertDialog(context, 'Your changes have been saved!');
                    });
                  }
                } else {
                  showAlertDialog(context,
                      'You can\'t edit anymore, please contact support team.');
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: kToolbarHeight,
                width: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: User.canEdit
                      ? primary
                      : const Color.fromARGB(255, 193, 116, 116),
                ),
                child: const Center(
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      fontFamily: 'Nexa Bold',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textField(
      String title, String hint, TextEditingController controller) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style:
                const TextStyle(fontFamily: 'Nexa Bold', color: Colors.black87),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            cursorColor: Colors.black54,
            controller: controller,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontFamily: 'Nexa Bold',
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showAlertDialog(BuildContext context, String text) {
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
                Text(
                  text,
                  style: const TextStyle(fontFamily: 'Nexa Light'),
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
}
