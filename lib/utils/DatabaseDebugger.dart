import 'package:Samarpana/utils/dataBase.dart';

class DatabaseDebugger {
  /// Comprehensive database diagnostic
  static Future<void> debugAllTables() async {
    print('\n╔════════════════════════════════════════════════════════════╗');
    print('║           DATABASE DIAGNOSTIC REPORT                       ║');
    print('╚════════════════════════════════════════════════════════════╝\n');

    await _checkUserDataTable();
    await _checkCartTable();
    
    print('\n╔════════════════════════════════════════════════════════════╗');
    print('║                   DIAGNOSIS COMPLETE                        ║');
    print('╚════════════════════════════════════════════════════════════╝\n');
  }

  static Future<void> _checkUserDataTable() async {
    print('📋 TABLE: userdata (User Login Information)');
    print('─' * 60);
    
    try {
      final rows = await DBProvider.instance.queryuserRows();
      
      if (rows.isEmpty) {
        print('❌ STATUS: EMPTY');
        print('   ⚠️  This table is required for API calls!');
        print('   📝 ACTION: User must complete LOGIN first\n');
      } else {
        print('✅ STATUS: POPULATED (${rows.length} record(s))\n');
        rows.asMap().forEach((index, row) {
          print('   Record ${index + 1}:');
          print('      ID: ${row['id']}');
          print('      Name: ${row['name']}');
          print('      Mobile: ${row['mobileNumber']}');
          print('      Token: ${row['token'] != null && (row['token'] as String).isNotEmpty ? '✅Present' : '❌Missing'}');
          print('      Address1: ${row['address1']}');
          print('      Address2: ${row['address2']}');
          print('      City: ${row['city']}');
          print('      State: ${row['state']}');
          print('      PinCode: ${row['pinCode']}');
          print('      Wallet: ${row['walletamt']}');
          print('');
        });
      }
    } catch (e) {
      print('❌ ERROR: $e\n');
    }
  }

  static Future<void> _checkCartTable() async {
    print('📋 TABLE: cart_table (Shopping Cart Items)');
    print('─' * 60);
    
    try {
      final db = await DBProvider.instance.database;
      final rows = await db.query(DBProvider.table);
      
      if (rows.isEmpty) {
        print('ℹ️  STATUS: EMPTY (No items in cart)');
        print('   This is OK - user just hasn\'t added items yet\n');
      } else {
        print('✅ STATUS: HAS ITEMS (${rows.length} product(s))\n');
        rows.asMap().forEach((index, row) {
          print('   Item ${index + 1}:');
          print('      Product Name: ${row['productName']}');
          print('      Product Code: ${row['productCode']}');
          print('      Price: ${row['price']}');
          print('      Total Price: ${row['totalPrice']}');
          print('      Quantity: ${row['numOfItems']}');
          print('');
        });
      }
    } catch (e) {
      print('❌ ERROR: $e\n');
    }
  }

  /// Checks if user can make API calls
  static Future<bool> canMakeAPICalls() async {
    try {
      final rows = await DBProvider.instance.queryuserRows();
      if (rows.isEmpty) {
        print('❌ Cannot make API calls: No user data in database');
        return false;
      }

      final mobile = rows[0]['mobileNumber'];
      final token = rows[0]['token'];

      if (mobile == null || (mobile as String).isEmpty) {
        print('❌ Cannot make API calls: Mobile number is empty');
        return false;
      }

      if (token == null || (token as String).isEmpty) {
        print('❌ Cannot make API calls: Token is empty');
        return false;
      }

      print('✅ Can make API calls');
      print('   Mobile: $mobile');
      print('   Token: ${(token).substring(0, 10)}...');
      return true;
    } catch (e) {
      print('❌ Error checking API call capability: $e');
      return false;
    }
  }

  /// Clear all database tables
  static Future<void> clearAllData() async {
    print('\n⚠️  CLEARING ALL DATA...');
    try {
      await DBProvider.instance.userdelete();
      print('✅ User data cleared');
      
      await DBProvider.instance.cartdelete();
      print('✅ Cart data cleared');
      
      print('✅ All data cleared successfully\n');
    } catch (e) {
      print('❌ Error clearing data: $e\n');
    }
  }
}
