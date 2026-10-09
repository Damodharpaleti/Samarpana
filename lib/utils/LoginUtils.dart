import 'package:Samarpana/utils/dataBase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUtils {
  /// Checks if user is properly logged in
  static Future<bool> isUserLoggedIn() async {
    try {
      final allRows = await DBProvider.instance.queryuserRows();
      if (allRows.isEmpty) {
        print('❌ No user data in database');
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      
      // Check required fields
      final mobileNumber = allRows[0]['mobileNumber'];
      final token = allRows[0]['token'];
      final role = prefs.getString('ROLE');

      print('✅ Login Check Results:');
      print('   Mobile: $mobileNumber');
      print('   Token: ${token != null && token.isNotEmpty ? 'Present' : 'Missing'}');
      print('   Role: $role');
      print('   Role Assigned: ${role != null && role.isNotEmpty}');

      if (mobileNumber == null || mobileNumber.isEmpty) {
        print('❌ Mobile number is empty!');
        return false;
      }

      if (token == null || token.isEmpty) {
        print('❌ Token is empty!');
        return false;
      }

      print('✅ User is properly logged in!');
      return true;
    } catch (e) {
      print('❌ Error checking login: $e');
      return false;
    }
  }

  /// Gets the logged-in user's mobile number
  static Future<String?> getLoggedInMobileNumber() async {
    try {
      final allRows = await DBProvider.instance.queryuserRows();
      if (allRows.isNotEmpty) {
        return allRows[0]['mobileNumber'] as String?;
      }
    } catch (e) {
      print('Error getting mobile number: $e');
    }
    return null;
  }

  /// Gets the logged-in user's token
  static Future<String?> getLoggedInToken() async {
    try {
      final allRows = await DBProvider.instance.queryuserRows();
      if (allRows.isNotEmpty) {
        return allRows[0]['token'] as String?;
      }
    } catch (e) {
      print('Error getting token: $e');
    }
    return null;
  }
}
