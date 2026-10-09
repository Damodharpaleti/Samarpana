import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/components/loader_provider.dart';
import 'package:Samarpana/model/MyPayments_Model.dart';
import 'package:Samarpana/pages/AccountPage.dart';
import 'package:Samarpana/pages/Delivery_status.dart';
import 'package:Samarpana/pages/Order_detailsPage.dart';
import 'package:Samarpana/pages/categorylist.dart'; 
import 'package:Samarpana/pages/loggin.dart';
import 'package:Samarpana/provider/product_provider.dart';
import 'package:Samarpana/widgets/samarapanaProduct.dart';
import 'package:Samarpana/widgets/widget_cart_card.dart';
import 'package:Samarpana/utils/DatabaseDebugger.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/CategoryProvider.dart';
import 'style.dart';
// import 'package:Samarpana/models/orders_model.dart'; // Add import for Myorders model

// const LocationsRoute = '/';
// const LocationDetailRoute = '/location_detail';
// const CategoryRoute = '/category_detail';
String? loginMobNumber;

class App extends StatelessWidget {
  /// Check if user is properly logged in
  Future<bool> isUserLoggedIn() async {
    try {
      print('\n🔍 Checking login status...');
      
      // Check SharedPreferences for login mobile number
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      loginMobNumber = prefs.getString("LoginMobNumber");
      print('   LoginMobNumber from prefs: $loginMobNumber');
      
      // Check if mobile number was saved
      if (loginMobNumber == null || loginMobNumber!.isEmpty) {
        print('❌ User not logged in - no mobile number in preferences');
        // Run database diagnostic on app start
        await DatabaseDebugger.debugAllTables();
        return false;
      }

      // Check if user data exists in database
      final allRows = await DBProvider.instance.queryuserRows();
      print('   Database records found: ${allRows.length}');
      
      if (allRows.isEmpty) {
        print('❌ User data not found in database - corrupted login state');
        await DatabaseDebugger.debugAllTables();
        return false;
      }

      // Verify token exists
      final token = allRows[0]['token'];
      if (token == null || (token as String).isEmpty) {
        print('❌ Token missing from database');
        await DatabaseDebugger.debugAllTables();
        return false;
      }

      print('✅ User is logged in');
      print('   Mobile: $loginMobNumber');
      print('   Token: Present');
      print('   Database: OK\n');
      return true;
    } catch (e) {
      print('❌ Error checking login: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: isUserLoggedIn(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          // Still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          // Error occurred
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return home(); // Show login page on error
          }

          // User is NOT logged in - show login page
          if (snapshot.data == false || snapshot.data == null) {
            return home();
          }

          // User IS logged in - show main app
          return multi();
        });
  }

  Widget home() {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CartProvider(),
            child: OrderDetails(status: "P", orderModel: Myorders.fromJson({})),
          ),
          ChangeNotifierProvider(
            create: (context) => ProductProvider(),
            child: samarapanaProduct(key: UniqueKey(), categoryId: 0),
          ),
          ChangeNotifierProvider(
            create: (context) => LoaderProvider(),
            child: cartpage(),
          ),
          ChangeNotifierProvider(
            create: (context) => CategoryProvider(),
            child: categorylist(),
          ),
          ChangeNotifierProvider(
            create: (context) => CategoryProvider(),
            child: WalletUIscreen(),
          ),
        ],
        child: MaterialApp(
          theme: _theme(),
          home: Scaffold(
            body: LoginPage(),
          ),
          debugShowCheckedModeBanner: false,
        ));
  }

  // RouteFactory _routes() {
  //   return (settings) {
  //     final Map<String, dynamic> arguments = settings.arguments;
  //     Widget screen;
  //     switch (settings.name) {
  //       case LocationsRoute:
  //         screen = LoginPage();
  //         break;
  //       case CategoryRoute:
  //         //screen = LocationDetail(arguments['id']);
  //         screen = LoginPage();
  //         break;
  //       default:
  //         return null;
  //     }
  //     return MaterialPageRoute(builder: (BuildContext context) => screen);
  //   };
  // }

  ThemeData _theme() {
    return ThemeData(
        appBarTheme:
            AppBarTheme(titleTextStyle: AppBarTextStyle),
        textTheme: TextTheme(
          titleMedium: TitleTextStyle,
          bodyMedium: Body1TextStyle,
        ));
  }
}

Widget multi() {
  return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: OrderDetails(status: "P", orderModel: Myorders.fromJson({})),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
          child: samarapanaProduct(key: UniqueKey(), categoryId: 0),
        ),
        ChangeNotifierProvider(
          create: (context) => LoaderProvider(),
          child: cartpage(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(),
          child: categorylist(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(),
          child: WalletUIscreen(),
        ),
      ],
      child: MaterialApp(
        theme: _theme(),
        home: Scaffold(
          body: OrderStatus(
            status: "P",
          ),
        ),
        debugShowCheckedModeBanner: false,
      ));
}

ThemeData _theme() {
  return ThemeData(
      appBarTheme:
          AppBarTheme(titleTextStyle: AppBarTextStyle),
      textTheme: TextTheme(
        titleMedium: TitleTextStyle,
        bodyMedium: Body1TextStyle,
      ));
}

// RouteFactory _routes() {
//   return (settings) {
//     final Map<String, dynamic> arguments = settings.arguments;
//     Widget screen;
//     switch (settings.name) {
//       case LocationsRoute:
//         screen = OrderStatus(
//           status: "P",
//         );
//         break;
//       case CategoryRoute:
//         //screen = LocationDetail(arguments['id']);
//         screen = HomePage();
//         break;
//       default:
//         return null;
//     }
//     return MaterialPageRoute(builder: (BuildContext context) => screen);
//   };
// }

  //  ThemeData _theme() {
  //   return ThemeData(
  //       appBarTheme: AppBarTheme(textTheme: TextTheme(title: AppBarTextStyle)),
  //       textTheme: TextTheme(
  //         title: TitleTextStyle,
  //         body1: Body1TextStyle,
  //       ));
  // }

