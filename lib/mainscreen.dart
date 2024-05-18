import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:iconly/iconly.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paytmmatka/admin/admin_panel.dart';
import 'package:paytmmatka/play.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paytmmatka/screens/main_starline.dart';
import 'package:paytmmatka/screens/points.dart';
import 'package:paytmmatka/screens/wthpoints.dart';
import 'package:paytmmatka/services/task_data.dart';
import 'package:paytmmatka/widgets/all_tile.dart';
import 'package:paytmmatka/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<void> fetchDataFuture;
  final Uri _url = Uri.parse('https://flutter.dev');

  QuerySnapshot? _snap;
  QuerySnapshot? _snap1;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  int currentSize = 0;

  // Variables (admin)
  int adminId = 0;
  String alertMsg = '';

  // Functions
  Future<void> _launchUrl({required String url}) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  // Method to load games data
  Future<void> loadMrkData() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('Games')
          .where('status', isEqualTo: 'Active')
          .where('mrksection', isEqualTo: 'Mumbai')
          .orderBy('created', descending: false)
          .get();
      if (snap.docs.isEmpty) {
        _snap = await FirebaseFirestore.instance
            .collection('Games')
            .where('status', isEqualTo: 'Active')
            .where('mrksection', isEqualTo: 'Mumbai')
            .orderBy('created', descending: false)
            .get(const GetOptions(source: Source.cache));
      } else {
        _snap = snap;
      }
      if (_snap!.size > 30) {
        setState(() {
          currentSize = 30; // Update to 20
        });
      } else {
        setState(() {
          currentSize = _snap!.size; // Update default
        });
      }
    } catch (e) {
      e.toString();
    }
  }

  // load the app settings
  Future<void> loadSettingsData() async {
    try {
      final snap =
          await FirebaseFirestore.instance.collection('Settings').get();
      if (snap.docs.isEmpty) {
        _snap1 = await FirebaseFirestore.instance
            .collection('Settings')
            .get(const GetOptions(source: Source.cache));
      } else {
        _snap1 = snap;
      }

      if (_snap1!.docs[0].exists) {
        final doc = _snap1!.docs[0];
        adminId = doc.get('adminid');
        alertMsg = doc.get('alertmsg');
      }
      setState(() {});
    } catch (e) {
      e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    loadSettingsData();
    fetchDataFuture = loadMrkData();
  }

  @override
  Widget build(BuildContext context) {
    // Provider
    final taskData = Provider.of<TaskData>(context);

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // Start of the Floating Action Button
      floatingActionButton: taskData.id == adminId
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const AdminPanelScreen(),
                    type: PageTransitionType.bottomToTop,
                    duration: const Duration(milliseconds: 1000),
                    reverseDuration: const Duration(milliseconds: 500),
                  ),
                );
              },
              backgroundColor: Colors.blue.shade300,
              child: Icon(
                Icons.vpn_key,
                color: Colors.white,
                size: screenWidth / 25,
              ))
          : null,
      // End of Floating Action Button
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const PointsScreen(),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 500),
                      reverseDuration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                child: Row(
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
                    Text(taskData.points.toString(),
                        style: TextStyle(
                            fontFamily: 'Nexa Bold',
                            fontSize: screenWidth / 22,
                            color: Colors.white)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      drawer: const SafeArea(child: DrawerWidget()),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Container(
              padding: const EdgeInsets.all(16),
              height: screenHeight / 7,
              width: screenWidth,
              // color: Colors.black,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Center(
                child: Text(
                  alertMsg,
                  style: TextStyle(
                      fontFamily: 'Nexa Bold',
                      fontSize: screenWidth / 20,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: topButtons(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: const WthPointsScreen(),
                                  type: PageTransitionType.leftToRight,
                                  duration: const Duration(milliseconds: 500),
                                  reverseDuration:
                                      const Duration(milliseconds: 500),
                                ),
                              );
                            },
                            icon: IconlyBold.wallet,
                            text: 'Add Points',
                            screenWidth: screenWidth),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: topButtons(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: const WthPointsScreen(),
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 500),
                                  reverseDuration:
                                      const Duration(milliseconds: 500),
                                ),
                              );
                            },
                            icon: FontAwesomeIcons.wallet,
                            text: "Withdraw",
                            screenWidth: screenWidth),
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
                              _launchUrl(url: 'https://flutter.dev');
                            },
                            icon: FontAwesomeIcons.whatsapp,
                            text: "+919530196562",
                            screenWidth: screenWidth),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: topButtons(
                            onTap: () {},
                            icon: Icons.call_outlined,
                            text: "+919530196562",
                            screenWidth: screenWidth),
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
                                PageTransition(
                                  child: const PlayStarlineScreen(),
                                  type: PageTransitionType.leftToRight,
                                  duration: const Duration(milliseconds: 500),
                                  reverseDuration:
                                      const Duration(milliseconds: 500),
                                ),
                              );
                            },
                            icon: RpgAwesome.perspective_dice_one,
                            text: 'PLAY STARLINE',
                            screenWidth: screenWidth),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: topButtons(
                            onTap: () {},
                            icon: Icons.play_circle_outlined,
                            text: "How To Play",
                            screenWidth: screenWidth),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _snap == null
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight / 8,
                        ),
                        child: CircleAvatar(
                            backgroundColor: Colors.blue.shade400,
                            radius: 50,
                            child: const CircularProgressIndicator(
                                color: Colors.white)),
                      )
                    : ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          currentSize,
                          (index) {
                            final doc = _snap!.docs[index];
                            String market = doc.get('mrkname');
                            String mrkSection = doc.get('mrksection');
                            String mrkOpen = doc.get('mrkopen');
                            String mrkClose = doc.get('mrkclose');
                            String mrkDigit = doc.get('digit').toString();
                            String mrkOpenPana = doc.get('openpana').toString();
                            String mrkClosePana =
                                doc.get('closepana').toString();

                            return AllTile(
                              allTitle: market,
                              allsub1: 'Open $mrkOpen | Close $mrkClose',
                              allsub2: mrkDigit == '1000' ||
                                      mrkOpenPana == '1000' ||
                                      mrkClosePana == '1000'
                                  ? 'XXX-XX-XXX'
                                  : '$mrkOpenPana-$mrkDigit-$mrkClosePana',
                              allisChecked: mrkDigit == '1000' ||
                                      mrkOpenPana == '1000' ||
                                      mrkClosePana == '1000'
                                  ? false
                                  : true,
                              allonTapCallback: () {
                                mrkDigit == '1000' ||
                                        mrkOpenPana == '1000' ||
                                        mrkClosePana == '1000'
                                    ? Navigator.push(
                                        context,
                                        PageTransition(
                                          child: PlayScreen(
                                            mainTitle: market,
                                            mainSection: mrkSection,
                                          ),
                                          type: PageTransitionType.bottomToTop,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          reverseDuration:
                                              const Duration(milliseconds: 500),
                                        ),
                                      )
                                    : ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                            'Market Close!',
                                            style: TextStyle(
                                              fontFamily: 'Nexa Light',
                                              fontSize: screenWidth / 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                ;
                              },
                            );
                            // : const SizedBox();
                          },
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget topButtons(
      {required Function onTap,
      required IconData icon,
      required String text,
      required double screenWidth}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, right: 10, left: 10),
        // width: screenWidth / 2.2,
        decoration: BoxDecoration(
          color: text == 'PLAY STARLINE' || text == 'How To Play'
              ? Colors.grey.shade800
              : Colors.blue.shade900,
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
