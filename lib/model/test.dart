import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otpless_flutter/otpless_flutter.dart';

class MyNewApp extends StatelessWidget {
  const MyNewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTPless Flutter Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EnterPhoneNumberPage(),
    );
  }
}

class EnterPhoneNumberPage extends StatefulWidget {
  const EnterPhoneNumberPage({super.key});

  @override
  _EnterPhoneNumberPageState createState() => _EnterPhoneNumberPageState();
}

class _EnterPhoneNumberPageState extends State<EnterPhoneNumberPage> {
  final TextEditingController phoneController = TextEditingController();

  void navigateToOtpVerificationPage() {
    final phone = phoneController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerificationPage(phone: phone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Enter your phone number',
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            CupertinoButton.filled(
              child: Text('Next'),
              onPressed: navigateToOtpVerificationPage,
            ),
          ],
        ),
      ),
    );
  }
}

class OtpVerificationPage extends StatefulWidget {
  final String phone;

  OtpVerificationPage({super.key, required this.phone});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  String _dataResponse = 'Unknown';
  final _otplessFlutterPlugin = Otpless();
  final TextEditingController otpController = TextEditingController();
  bool loaderVisibility = true;

  @override
  void initState() {
    super.initState();
    _otplessFlutterPlugin.initHeadless("G8KV2HPKJ81PKQXYOHD0");
    _otplessFlutterPlugin.setHeadlessCallback(onHeadlessResult);
  }

  // Function to perform action after verification
  void performPostVerificationAction(String token) {
    // Example action: Navigate to a new page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => VerifiedPage(token: token)),
    );
  }

  Future<void> startHeadlessForPhone() async {
    Map<String, dynamic> arg = {
      "phone": widget.phone,
      "countryCode": "234",
    };

    if (otpController.text.isNotEmpty) {
      arg["otp"] = otpController.text;
    }

    _otplessFlutterPlugin.startHeadless((result) {
      setState(() {
        _dataResponse = jsonEncode(result);
        if (result['data'] != null) {
          final token = result['data']['token'];
          performPostVerificationAction(token);
        } else if (result['error'] != null) {
          // Handle errors and log them
          _dataResponse = "Error: ${result['error']['message']}";
        }
      });
    }, arg);
  }

  void onHeadlessResult(dynamic result) {
    setState(() {
      _dataResponse = jsonEncode(result);
      if (result['data'] != null) {
        final token = result['data']['token'];
        performPostVerificationAction(token);
      }
    });
  }

  Future<void> changeLoaderVisibility() async {
    loaderVisibility = !loaderVisibility;
    _otplessFlutterPlugin.setLoaderVisibility(loaderVisibility);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Enter the OTP sent to ${widget.phone}'),
            TextField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            CupertinoButton.filled(
              child: Text('Verify'),
              onPressed: startHeadlessForPhone,
            ),
            SizedBox(height: 20),
            Text(_dataResponse),
          ],
        ),
      ),
    );
  }
}

class VerifiedPage extends StatelessWidget {
  final String token;

  VerifiedPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verified Page'),
      ),
      body: Center(
        child: Text('Verification successful! Token: $token'),
      ),
    );
  }
}
