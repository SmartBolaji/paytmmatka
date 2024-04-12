import 'package:paytmmatka/calendarscreen.dart';
import 'package:paytmmatka/model/user.dart';
import 'package:paytmmatka/profilescreen.dart';
import 'package:paytmmatka/services/location_service.dart';
import 'package:paytmmatka/todayscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  Color primary = const Color(0xFFEEF444C);

  int currentIndex = 1;

  List<IconData> navigationIcons = [
    FontAwesomeIcons.calendarDays,
    FontAwesomeIcons.check,
    FontAwesomeIcons.user,
  ];

  @override
  void initState() {
    super.initState();
    _getId().then((_) {
      _getCredentials();
    });
    _startLocationService();
  }

  Future<void> _getId() async {
    // get the current user id
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('Employee')
        .where('id', isEqualTo: User.employeeid)
        .get();

    setState(() {
      User.id = snap.docs[0].id;
      // print('Show: ${User.id}');
    });
  }

  void _getCredentials() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Employee')
        .doc(User.id)
        .get();
    setState(() {
      try {
        User.canEdit = doc['canEdit'];
        User.firstName = doc['firstName'];
        User.lastName = doc['lastName'];
        User.birthDate = doc['birthDate'];
        User.address = doc['address'];
        User.profilePicLink = doc['profilePic'];
      } catch (e) {
        null;
      }
    });
  }

  void _startLocationService() {
    LocationService().initialize();

    LocationService().getLongitude().then((value) {
      setState(() {
        User.long = value!;
      });
    });

    LocationService().getLatitude().then((value) {
      setState(() {
        User.lat = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          new CalendarScreen(),
          new TodayScreen(),
          new ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))
            ]),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < navigationIcons.length; i++) ...<Expanded>{
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = i;
                      });
                    },
                    child: Container(
                      height: screenHeight,
                      width: screenWidth,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              navigationIcons[i],
                              color:
                                  i == currentIndex ? primary : Colors.black54,
                              size: i == currentIndex ? 30 : 26,
                            ),
                            i == currentIndex
                                ? Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    height: 3,
                                    width: 24,
                                    decoration: BoxDecoration(
                                        color: primary,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(40))),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ))
                }
              ],
            )),
      ),
    );
  }
}
