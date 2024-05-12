import 'package:flutter/material.dart';

class PlayOptionTile extends StatelessWidget {
  final String allsub1;
  final String allsub2;
  final IconData allicon1;
  final IconData? allicon2;
  // final String allStatus;
  // final Function allcheckboxCallback;
  // final Function allshortcutCallback;
  final Function allonTapCallback;

  const PlayOptionTile({
    super.key,
    required this.allsub1,
    required this.allsub2,
    required this.allicon1,
    required this.allicon2,
    // required this.allStatus,
    // required this.allcheckboxCallback,
    // required this.allshortcutCallback,
    required this.allonTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        allonTapCallback();
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(
          left: 4,
          right: 4,
        ),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
            BorderSide(
              width: 3,
              color: Colors.blue,
            ),
          ),
        ),
        child: Container(
          width: screenWidth / 3,
          height: screenHeight / 5,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    allicon1,
                    size: allicon2 != null ? screenWidth / 8 : screenWidth / 8,
                    color: Colors.white,
                    weight: 0.1,
                  ),
                  allicon2 != null
                      ? Icon(
                          allicon2,
                          size: allicon2 != null
                              ? screenWidth / 15
                              : screenWidth / 8,
                          color: Colors.black,
                          weight: 0.1,
                        )
                      : const Center(),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                allsub1.toUpperCase(),
                style: TextStyle(
                    fontFamily: 'Nexa Bold',
                    fontSize: screenWidth / 21,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              ),
              Text(
                allsub2.toUpperCase(),
                style: TextStyle(
                    fontFamily: 'Nexa Bold',
                    fontSize: screenWidth / 24,
                    fontStyle: FontStyle.italic,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
