import 'package:flutter/widgets.dart';
import 'package:paytmmatka/firebase_options.dart';
import 'package:paytmmatka/mainscreen.dart';
import 'package:paytmmatka/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:paytmmatka/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:paytmmatka/services/task_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Paytm Matka',
        theme: ThemeData(
          timePickerTheme: const TimePickerThemeData(
            helpTextStyle:
                TextStyle(fontFamily: 'Nexa Bold', color: Colors.blue),
            hourMinuteTextStyle: TextStyle(
              fontFamily: 'Nexa Bold',
              fontSize: 40,
            ),
            dayPeriodTextStyle: TextStyle(
              fontFamily: 'Nexa Bold',
            ),
            dialTextStyle: TextStyle(
              fontFamily: 'Nexa Bold',
            ),
            cancelButtonStyle: ButtonStyle(
              textStyle: MaterialStatePropertyAll(
                TextStyle(
                  fontFamily: 'Nexa Bold',
                ),
              ),
            ),
            confirmButtonStyle: ButtonStyle(
              textStyle: MaterialStatePropertyAll(
                TextStyle(
                  fontFamily: 'Nexa Bold',
                ),
              ),
            ),
          ),
        ),
        home: const KeyboardVisibilityProvider(child: AuthCheck()),
        localizationsDelegates: const [MonthYearPickerLocalizations.delegate],
      ));
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();

    try {
      if (sharedPreferences.getString('employeeid') != null) {
        setState(() {
          User.employeeid = sharedPreferences.getString('employeeid')!;
          userAvailable = true;
          // print('Show: + ${User.employeeid}');
        });
      }
    } catch (e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: userAvailable ? MainScreen() : const LoginScreen());
  }
}
