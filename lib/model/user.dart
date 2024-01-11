import 'package:intl/intl.dart';

class User {
  static String? id = '';
  static String employeeid = '';
  static String firstName = '';
  static String lastName = '';
  static String birthDate = '';
  static String address = '';
  static String profilePicLink = '';
  static String month = DateFormat('MMMM').format(DateTime.now());
  static double lat = 0;
  static double long = 0;
  static bool canEdit = true;
}
