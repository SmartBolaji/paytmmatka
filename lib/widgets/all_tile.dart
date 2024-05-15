import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AllTile extends StatelessWidget {
  final bool allisChecked;
  final String allTitle;
  final String allsub1;
  final String allsub2;
  // final String allStatus;
  // final Function allcheckboxCallback;
  // final Function allshortcutCallback;
  final Function allonTapCallback;

  const AllTile({
    super.key,
    required this.allisChecked,
    required this.allTitle,
    required this.allsub1,
    required this.allsub2,
    // required this.allStatus,
    // required this.allcheckboxCallback,
    // required this.allshortcutCallback,
    required this.allonTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    String status = allisChecked ? 'Market Close' : 'Market Open';

    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 5, 17, 0),
      child: ListTile(
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth / 80, right: screenWidth / 30),
                  child: Icon(
                    FontAwesomeIcons.fileContract,
                    size: screenWidth / 17,
                    color: allisChecked ? Colors.red : Colors.blue.shade300,
                  ),
                ),
              ],
            ),
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  allTitle,
                  style: TextStyle(
                      fontFamily: 'Nexa Bold',
                      fontSize: screenWidth / 20,
                      color: allisChecked ? Colors.red : Colors.blue.shade300),
                ),
                Text(
                  allsub1,
                  style: TextStyle(
                      fontFamily: 'Nexa Bold',
                      fontSize: screenWidth / 30,
                      color: Colors.black54),
                ),
                Text(
                  allsub2,
                  style: TextStyle(
                      fontFamily: 'Nexa Bold',
                      fontSize: screenWidth / 19,
                      color: Colors.black54),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: screenWidth / 10, // Adjust size as needed
                  height: screenHeight / 15, // Adjust size as needed
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: allisChecked ? Colors.red : Colors.blue,
                    border: Border.all(
                      color: allisChecked
                          ? Colors.red
                          : Colors.blue, // Blue border
                      width: 3, // Border width
                    ),
                  ),
                  child: Icon(FontAwesomeIcons.play,
                      size: screenWidth / 30, color: Colors.white),
                ),
                Text(
                  status,
                  style: TextStyle(
                      fontFamily: 'Nexa Bold',
                      fontSize: screenWidth / 38,
                      color: allisChecked ? Colors.red : Colors.green),
                ),
              ],
            ),
          ],
        ),
        tileColor: Colors.grey.shade200,
        selected: allisChecked,
        selectedColor: Colors.black,
        selectedTileColor: Colors.black26,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black26)),
        onTap:  () {
                allonTapCallback();
              },
      ),
    );
  }
}
