import 'package:cloud_firestore/cloud_firestore.dart';
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
  static QuerySnapshot? allSnapshots;
}

// // Function
// Future<void> loadGamesData() async {
//   print('Snap is top');
//   try {
//     // Query to fetch the scores
//     User.allSnapshots = await FirebaseFirestore.instance
//         .collection('Games')
//         .orderBy('created', descending: false)
//         .get()
//         .then((value) {
//       print('Snap is not empty');
//       if (value.docs.isEmpty) {
//         return FirebaseFirestore.instance
//             .collection('Games')
//             .orderBy('created', descending: false)
//             .get(const GetOptions(source: Source.cache));
//       }
//       return value;
//     });
//     print('Snap is unavailable');
//   } catch (e) {
//     print('$e Snap is unavailable again');
//   }
// }
