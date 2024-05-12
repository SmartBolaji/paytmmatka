import 'package:iconly/iconly.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paytmmatka/play.dart';
import 'package:paytmmatka/resultscreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paytmmatka/widgets/all_tile.dart';
import 'package:paytmmatka/widgets/drawer_widget.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  double screenHeight = 0.0;

  double screenWidth = 0.0;

  // Color primary = const Color(0xFFEEF444C);
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade300,
        title: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Paytm Matka',
                style: TextStyle(
                    fontFamily: 'Nexa Bold',
                    fontSize: screenWidth / 17,
                    color: Colors.white),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    IconlyBold.wallet,
                    size: screenWidth / 15,
                    color: Colors.blue.shade50,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text('5.0',
                      style: TextStyle(
                          fontFamily: 'Nexa Bold',
                          fontSize: screenWidth / 22,
                          color: Colors.white)),
                ],
              )
            ],
          ),
        ),
      ),
      drawer: const SafeArea(child: DrawerWidget()),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            height: screenHeight / 7,
            width: screenWidth,
            // color: Colors.black,
            decoration: const BoxDecoration(
                color: Colors.black,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black, // Shadow color
                //     spreadRadius: 3, // Spread radius
                //     blurRadius: 3, // Blur radius
                //     offset: Offset(0, 3), // Offset from the top left corner
                //   ),
                // ],
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: Text(
                "Make use of PayTM or Google Pay to make a transaction",
                style: TextStyle(
                    fontFamily: 'Nexa Bold',
                    fontSize: screenWidth / 20,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: topButtons(
                            onTap: () {},
                            icon: FontAwesomeIcons.whatsapp,
                            text: "+919530196562"),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: topButtons(
                            onTap: () {},
                            icon: FontAwesomeIcons.wallet,
                            text: "Withdraw"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: topButtons(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ResultScreen()));
                            },
                            icon: FontAwesomeIcons.chartBar,
                            text: "Live Result"),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: topButtons(
                            onTap: () {},
                            icon: Icons.play_circle_fill,
                            text: "How To Play"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AllTile(
                  allTitle: 'STAR MORNING',
                  allsub1: 'Open 09:10 AM | Close 11:10 AM',
                  allsub2: '123-567-901',
                  allisChecked: false,
                  // allshortcutCallback: () {},
                  allonTapCallback: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: const PlayScreen(
                          mainTitle: 'STAR MORNING',
                        ),
                        type: PageTransitionType.bottomToTop,
                        duration: const Duration(milliseconds: 500),
                        reverseDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget topButtons(
      {required Function onTap, required IconData icon, required String text}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, right: 10, left: 10),
        // width: screenWidth / 2.2,
        decoration: BoxDecoration(
          color: Colors.blue.shade900,
          borderRadius: const BorderRadius.all(
            Radius.circular(40),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: screenWidth / 15,
              color: Colors.white,
            ),
            const SizedBox(
              width: 7,
            ),
            Text(
              text,
              style: TextStyle(
                  fontFamily: 'Nexa Bold',
                  fontSize: screenWidth / 28,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
