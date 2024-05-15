import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paytmmatka/admin/games.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:paytmmatka/admin/results.dart';
import 'package:paytmmatka/admin/transt.dart';
import 'package:paytmmatka/admin/users.dart';
import 'package:paytmmatka/services/task_data.dart';
import 'package:paytmmatka/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  // Late variables
  late SharedPreferences sharedPreferences;

  QuerySnapshot? _snap;
  bool circular = false;
  bool refreshCircle = false;
  bool refreshLoad = false;
  int currentSnapSize = 0; // Variable to keep track of snapshot size
  int userStats = 0;
  int gameStats = 0;
  int transStats = 0;

  // Get the current date
  DateTime now = DateTime.now();

  // Market details
  int userId = 0;
  String allMrkName = '';
  String allMrkType = '';
  String allMrkSession = '';
  int allDigit = 0;
  int allOpenPana = 0;
  int allClosePana = 0;
  double allStakeAmt = 0.0;
  String allTrackId = '';
  Timestamp fetchDate = Timestamp.now();

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  Color primary = Colors.blue.shade300;

  // Functions
  // Load admin stats
  Future<int> loadData({
    required String collection,
  }) async {
    try {
      final snap =
          await FirebaseFirestore.instance.collection(collection).get();
      return snap.docs.length;
    } catch (e) {
      e.toString();
      return 0;
    }
  }

  // Method to refresh data
  Future<void> refreshData() async {
    setState(() {
      loadBidsData();
    });
  }

  // Method to load games data
  Future<void> loadBidsData() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('Bids')
          .orderBy('created', descending: true)
          .get();
      if (snap.docs.isEmpty) {
        _snap = await FirebaseFirestore.instance
            .collection('Bids')
            .orderBy('created', descending: true)
            .get(const GetOptions(source: Source.cache));
      } else {
        _snap = snap;
      }
      setState(() {
        if (_snap!.size > 20) {
          currentSnapSize = 20; // Update to 20
        } else {
          currentSnapSize = _snap!.size; // Update default
        }
      });
    } catch (e) {
      e.toString();
    }
  }

  // Load more bids data
  Future<void> loadMoreBidsData() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('Bids')
          .orderBy('created', descending: true)
          .get();
      if (snap.docs.isEmpty) {
        _snap = await FirebaseFirestore.instance
            .collection('Bids')
            .orderBy('created', descending: true)
            .get(const GetOptions(source: Source.cache));
      } else {
        _snap = snap;
      }
      setState(() {
        if (_snap!.size > currentSnapSize &&
            currentSnapSize > currentSnapSize + 10) {
          currentSnapSize += 10; // Increase to 10
        } else {
          currentSnapSize = _snap!.size; // Update default
        }
      });
    } catch (e) {
      e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    loadData(collection: 'Users').then((value) {
      setState(() {
        userStats = value;
      });
    });
    loadData(collection: 'Games').then((value) {
      setState(() {
        gameStats = value;
      });
    });
    loadData(collection: 'Transactions').then((value) {
      setState(() {
        transStats = value;
      });
    });
    loadBidsData();
  }

  @override
  Widget build(BuildContext context) {
    // Provider
    final taskData = Provider.of<TaskData>(context);

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    Color primary = Colors.blue.shade300;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade300,
        title: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Admin Dashboard',
                style: TextStyle(
                    fontFamily: 'Nexa Bold',
                    fontSize: screenWidth / 17,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
          top: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    taskData.month1,
                    style: TextStyle(
                      fontFamily: 'Nexa Bold',
                      fontSize: screenWidth / 20,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () async {
                      final month = await showMonthYearPicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2099),
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
                                  labelSmall:
                                      TextStyle(fontFamily: 'Nexa Bold'),
                                  labelLarge:
                                      TextStyle(fontFamily: 'Nexa Bold'),
                                  // displaySmall:
                                  //     TextStyle(fontFamily: 'Nexa Light'),
                                ),
                              ),
                              child: child!);
                        },
                      );

                      if (month != null) {
                        taskData.updateM1(
                            context, DateFormat('MMMM').format(month));
                      }
                    },
                    child: Text(
                      'Pick a Month',
                      style: TextStyle(
                          fontFamily: 'Nexa Bold',
                          fontSize: screenWidth / 20,
                          color: Colors.blue.shade500),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  )),
              alignment: Alignment.centerLeft,
              // margin: EdgeInsets.symmetric(horizontal: screenWidth / 24),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Bids',
                        style: TextStyle(
                          fontFamily: 'Nexa Bold',
                          fontSize: screenWidth / 18,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            refreshCircle = true;
                            refreshData();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.blue.shade300,
                              content: Text(
                                'Done!',
                                style: TextStyle(
                                  fontFamily: 'Nexa Light',
                                  fontSize: screenWidth / 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              refreshCircle = false;
                            });
                          });
                        },
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.grey.shade800,
                          child: refreshCircle
                              ? Transform.scale(
                                  scale: 0.5,
                                  child: const CircularProgressIndicator(
                                      color: Colors.white))
                              : Icon(
                                  Icons.refresh,
                                  size: screenWidth / 20,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            refreshLoad = true;
                            // refreshData();
                          });
                          loadMoreBidsData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.blue.shade300,
                              content: Text(
                                'Done!',
                                style: TextStyle(
                                  fontFamily: 'Nexa Light',
                                  fontSize: screenWidth / 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              refreshLoad = false;
                            });
                          });
                        },
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.grey.shade800,
                          child: refreshLoad
                              ? Transform.scale(
                                  scale: 0.5,
                                  child: const CircularProgressIndicator(
                                      color: Colors.white))
                              : Icon(
                                  Icons.arrow_forward_ios,
                                  size: screenWidth / 30,
                                  color: Colors.white,
                                ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        // padding: const EdgeInsets.only(left: 2, right: 2),
                        width: 1000,
                        child: // Use ListView to display games
                            _snap != null
                                ? Column(
                                    children: [
                                      ListView(
                                        shrinkWrap: true,
                                        children: [
                                          Table(
                                            border: TableBorder.all(),
                                            columnWidths: const {
                                              0: FractionColumnWidth(0.05),
                                              // 1: FractionColumnWidth(0.14),
                                              // 2: FractionColumnWidth(0.15),
                                              // 3: FractionColumnWidth(0.15),
                                              // 4: FractionColumnWidth(0.15)
                                            },
                                            children: [
                                              buildRow([
                                                '#',
                                                'Track Id',
                                                'Market',
                                                'Type',
                                                'Bid',
                                                'Session',
                                                'Digit',
                                                'Open\nPana',
                                                'Close\nPana',
                                                'Date',
                                                'Member',
                                              ],
                                                  isHeader: true,
                                                  rowIndex: 0,
                                                  onTap: () {}),
                                            ],
                                          ),
                                        ],
                                      ),
                                      ListView(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: List.generate(
                                          currentSnapSize,
                                          (index) {
                                            final doc = _snap!.docs[index];
                                            userId = doc.get('id');
                                            allMrkName = doc.get('market');
                                            allMrkType = doc.get('mrktype');
                                            allMrkSession = doc.get('session');
                                            allDigit = doc.get('digit');
                                            allOpenPana = doc.get('openpana');
                                            allClosePana = doc.get('closepana');
                                            allStakeAmt = doc.get('points');
                                            allTrackId = doc.get('trackid');
                                            fetchDate = doc.get('created');
                                            String formatAllDate =
                                                DateFormat('yyyy-MM-dd HH:mm')
                                                    .format(fetchDate.toDate());

                                            return DateFormat('MMMM').format(
                                                        fetchDate.toDate()) ==
                                                    taskData.month1
                                                ? Table(
                                                    border: const TableBorder(
                                                      verticalInside:
                                                          BorderSide(
                                                              width: 1.0,
                                                              color:
                                                                  Colors.black),
                                                      bottom: BorderSide(
                                                          width: 1.0,
                                                          color: Colors.black),
                                                      left: BorderSide(
                                                          width: 1.0,
                                                          color: Colors.black),
                                                      right: BorderSide(
                                                          width: 1.0,
                                                          color: Colors.black),
                                                    ),
                                                    columnWidths: const {
                                                      0: FractionColumnWidth(
                                                          0.05),
                                                      // 1: FractionColumnWidth(
                                                      //     0.14),
                                                      // 2: FractionColumnWidth(
                                                      //     0.15),
                                                      // 3: FractionColumnWidth(
                                                      //     0.15),
                                                      // 4: FractionColumnWidth(
                                                      //     0.15)
                                                    },
                                                    children: [
                                                      buildRow([
                                                        '${index + 1}',
                                                        allTrackId,
                                                        allMrkName,
                                                        allMrkType,
                                                        allStakeAmt.toString(),
                                                        allMrkSession,
                                                        allDigit.toString(),
                                                        allOpenPana.toString(),
                                                        allClosePana.toString(),
                                                        formatAllDate,
                                                        userId.toString(),
                                                      ],
                                                          isHeader: false,
                                                          rowIndex: 1,
                                                          onTap: () {}),
                                                    ],
                                                  )
                                                : const SizedBox();
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height: 200,
                                    child: CircleAvatar(
                                        backgroundColor: Colors.blue.shade200,
                                        radius: 50,
                                        child:
                                            const CircularProgressIndicator()),
                                  ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight / 50,
            ),
            buildContainer('Users', userStats.toString(), Icons.person, () {
              Navigator.push(
                context,
                PageTransition(
                  child: const UsersScreen(),
                  type: PageTransitionType.topToBottom,
                  inheritTheme: true,
                  ctx: context,
                ),
              );
            }),
            const SizedBox(
              height: 20,
            ),
            buildContainer(
              'Games',
              gameStats.toString(),
              RpgAwesome.perspective_dice_one,
              () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const GamesScreen(),
                    type: PageTransitionType.topToBottom,
                    inheritTheme: true,
                    ctx: context,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            buildContainer(
              'Transactions',
              transStats.toString(),
              FontAwesome5.tasks,
              () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const TranstScreen(),
                    type: PageTransitionType.topToBottom,
                    inheritTheme: true,
                    ctx: context,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            buildContainer(
              'Declare',
              'Results',
              Icons.announcement,
              () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const ResultsScreen(),
                    type: PageTransitionType.topToBottom,
                    inheritTheme: true,
                    ctx: context,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  TableRow buildRow(List<String> cells,
      {required bool isHeader,
      required int rowIndex,
      required Function onTap}) {
    Color backgroundColor =
        rowIndex.isEven ? Colors.white : Colors.grey.shade100;

    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey.shade300 : backgroundColor,
      ),
      children: cells.map((cell) {
        final TextStyle title = TextStyle(
          fontFamily: 'Nexa Bold',
          fontSize: screenWidth / 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        );

        final cellStyle = TextStyle(
          fontFamily: 'Nexa Light',
          fontSize: screenWidth / 26,
          color: cell == allTrackId ? Colors.blue.shade800 : Colors.black,
        );

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () {
              onTap();
            },
            child: Text(
              cell,
              style: isHeader ? title : cellStyle,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(fontSize: screenWidth / 26, fontFamily: 'Nexa Bold'),
      ),
    );
  }

  Widget buildContainer(
      String title, String digit, IconData icon, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.only(
          top: 25,
          bottom: 25,
          right: 20,
          left: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black, // Shadow color
          //     spreadRadius: 3, // Spread radius
          //     blurRadius: 3, // Blur radius
          //     offset: Offset(0, 3), // Offset from the top left corner
          //   ),
          // ],
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Nexa Light',
                    fontSize: screenWidth / 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  digit,
                  style: TextStyle(
                    fontFamily: 'Nexa Bold',
                    fontSize: screenWidth / 18,
                  ),
                ),
              ],
            ),
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
