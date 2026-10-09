import 'dart:convert';
import 'dart:io';
import 'package:Samarpana/model/AdduserAddressModel.dart';
import 'package:Samarpana/model/BankTransactionDetails.dart';
import 'package:Samarpana/model/Order_details_Model.dart';
import 'package:Samarpana/model/PlaceOrder_model.dart';
import 'package:Samarpana/model/Product.dart';
import 'package:Samarpana/model/SamarpanaProductDetails.dart';
import 'package:Samarpana/model/TimeSlot_Model.dart';
import 'package:Samarpana/model/UpdatePasswordModel.dart';
import 'package:Samarpana/model/UseraddressModel.dart';
import 'package:Samarpana/model/Vendor_AccountModel.dart';
import 'package:Samarpana/model/WalletTransacDetailsModel.dart';
import 'package:Samarpana/model/Walletbalance.dart';
import 'package:Samarpana/model/WithdrawModel.dart';
import 'package:Samarpana/model/category.dart';
import 'package:Samarpana/model/order_status_Model.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:dio/dio.dart';
import 'package:Samarpana/model/ForgotPassword_model.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'package:Samarpana/model/MyPayments_Model.dart';
import 'package:Samarpana/components/globals.dart' as globals;

class APIService {
  late List<UserdatafromDB> list = [];
  late UserdatafromDB model;
  final dbHelper = DBProvider.instance;


Future<List<Myorders>> myPaymentsList({
  required String orderstatus,
  required String token,
  required String mobileNumber,
}) async {

  List<Myorders> data = [];

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String userRole = prefs.getString("ROLE") ?? "CUSTOMER";

  try {

    String url =
        "${Config.url}${Config.orders}?status=$orderstatus&user=$mobileNumber&userRole=$userRole";

    print("=========== ORDERS API ===========");
    print("URL: $url");
    print("Status: $orderstatus");
    print("User: $mobileNumber");
    print("Role: $userRole");

    var response = await Dio().get(
      url,
      options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      ),
    );

    print("=========== RESPONSE ===========");
    print("Response Status Code: ${response.statusCode}");
    print("Response Data Type: ${response.data.runtimeType}");
    
    if (response.data is List) {
      print("Response Array Length: ${(response.data as List).length} orders");
      print("Full Response: ${response.data}");
    } else {
      print("Response Data: ${response.data}");
    }

    if (response.statusCode == 200) {

      List list = response.data ?? [];

      print("Parsing ${list.length} orders into Myorders objects");
      
      data = list.map((e) {
        try {
          return Myorders.fromJson(e);
        } catch (err) {
          print("ERROR parsing order: $err");
          rethrow;
        }
      }).toList();
      
      print("Successfully parsed ${data.length} orders");
      data.forEach((order) {
        print("  - Order #${order.orderNumber}: ${order.orderFullPrice} (${order.orderStatus})");
      });
    }

  } on DioException catch (e) {

    print("=========== API ERROR ===========");

    if (e.response != null) {
      print("STATUS : ${e.response?.statusCode}");
      print("DATA : ${e.response?.data}");
    } else {
      print(e.message);
    }
  }

  return data;
}

/// NEW: Fetch ALL pending orders from a specific PINCODE (all users)
/// Uses the proven working myPaymentsList endpoint
Future<List<Myorders>> getAllPendingOrdersByPincode({
  required String token,
  required String userPincode,
}) async {
  List<Myorders> allOrders = [];

  try {
    print("\n=========== FETCH ALL PENDING ORDERS BY PINCODE ===========");
    print("Pincode: $userPincode");
    print("Fetching ALL pending orders for this pincode (all users)");

    // Fetch pending orders without user filter to get all orders for the pincode
    // FIXED: Use Config.ordersByPincode instead of Config.orders
    String url = "${Config.url}${Config.ordersByPincode}?status=P&pincode=$userPincode";
    
    print("URL: $url");

    var response = await Dio().get(
      url,
      options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      ),
    );

    print("Response Status: ${response.statusCode}");

    if (response.statusCode == 200) {
      List list = response.data ?? [];
      print("Received ${list.length} TOTAL pending orders for pincode $userPincode (ALL USERS)");

      List<Myorders> parsedOrders = list.map((e) {
        try {
          return Myorders.fromJson(e);
        } catch (err) {
          print("ERROR parsing order: $err");
          return null;
        }
      }).whereType<Myorders>().toList();

      allOrders.addAll(parsedOrders);
      
      print("✅ Successfully parsed ${allOrders.length} pending orders");
      allOrders.forEach((order) {
        print("  - Order #${order.orderNumber}: ₹${order.orderFullPrice} | User: ${order.orderUserId}");
      });
    }

    return allOrders;
  } on DioException catch (e) {
    print("❌ ERROR fetching pending orders by pincode");
    if (e.response != null) {
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
    } else {
      print("ERROR: ${e.message}");
    }
    return [];
  } catch (e) {
    print("❌ ERROR: $e");
    return [];
  }
}

/// Fallback: If pincode parameter doesn't work, fetch by status only
Future<List<Myorders>> getAllPendingOrdersNoFilter({
  required String token,
}) async {
  List<Myorders> allOrders = [];

  try {
    print("\n=========== FETCH ALL PENDING ORDERS (NO USER FILTER) ===========");
    print("Fetching ALL pending orders from system");

    // FIXED: Use Config.ordersByPincode to fetch all pending orders without pincode filter
    String url = "${Config.url}${Config.ordersByPincode}?status=P";
    
    print("URL: $url");

    var response = await Dio().get(
      url,
      options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      ),
    );

    print("Response Status: ${response.statusCode}");

    if (response.statusCode == 200) {
      List list = response.data ?? [];
      print("Received ${list.length} pending orders");

      List<Myorders> parsedOrders = list.map((e) {
        try {
          return Myorders.fromJson(e);
        } catch (err) {
          print("ERROR parsing order: $err");
          return null;
        }
      }).whereType<Myorders>().toList();

      allOrders.addAll(parsedOrders);
      
      print("✅ Successfully parsed ${allOrders.length} orders");
    }

    return allOrders;
  } on DioException catch (e) {
    print("❌ ERROR fetching pending orders");
    if (e.response != null) {
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
    } else {
      print("ERROR: ${e.message}");
    }
    return [];
  }
}

/// NEW: Fetch ALL pending orders from a specific PINCODE (all users)
/// Uses the proven working myPaymentsList endpoint
Future<List<Myorders>> getAllPendingOrdersForPincode({
  required String token,
  required String mobileNumber,
}) async {
  List<Myorders> allOrders = [];

  try {
    print("\n=========== FETCH ALL PENDING ORDERS ===========");
    print("Mobile Number: $mobileNumber");
    print("Fetching from proven working endpoint: myPaymentsList()");

    // Use proven working endpoint - just fetch with status P for pending orders
    List<Myorders> pendingOrders = await myPaymentsList(
      orderstatus: "P",
      token: token,
      mobileNumber: mobileNumber,
    );

    allOrders.addAll(pendingOrders);

    print("\n✅ SUCCESSFULLY FETCHED PENDING ORDERS");
    print("Total Pending Orders: ${allOrders.length}");
    allOrders.forEach((order) {
      print("  📦 Order #${order.orderNumber}: ₹${order.orderFullPrice} | Mobile: ${order.orderUserId}");
    });

    return allOrders;
  } catch (e) {
    print("❌ ERROR fetching pending orders: $e");
    return [];
  }
}

/// Fetch ALL orders (Pending + Delivery + Cancel) - uses proven working endpoint
Future<List<Myorders>> getAllOrdersAllStatuses({
  required String token,
  required String mobileNumber,
}) async {
  List<Myorders> allOrders = [];

  try {
    print("\n=========== FETCH ALL ORDERS (ALL STATUSES) ===========");
    print("Mobile Number: $mobileNumber");

    // Fetch Pending
    print("\n📦 Fetching PENDING orders...");
    List<Myorders> pending = await myPaymentsList(
      orderstatus: "P",
      token: token,
      mobileNumber: mobileNumber,
    );
    allOrders.addAll(pending);
    print("✅ Found ${pending.length} pending orders");

    // Fetch Delivery
    print("\n🚚 Fetching DELIVERY orders...");
    List<Myorders> delivery = await myPaymentsList(
      orderstatus: "D",
      token: token,
      mobileNumber: mobileNumber,
    );
    allOrders.addAll(delivery);
    print("✅ Found ${delivery.length} delivery orders");

    // Fetch Cancelled
    print("\n❌ Fetching CANCELLED orders...");
    List<Myorders> cancelled = await myPaymentsList(
      orderstatus: "C",
      token: token,
      mobileNumber: mobileNumber,
    );
    allOrders.addAll(cancelled);
    print("✅ Found ${cancelled.length} cancelled orders");

    print("\n========== SUMMARY ==========");
    print("Total Orders: ${allOrders.length}");
    print("  - Pending (P): ${pending.length}");
    print("  - Delivery (D): ${delivery.length}");
    print("  - Cancelled (C): ${cancelled.length}");

    return allOrders;
  } catch (e) {
    print("❌ ERROR fetching all orders: $e");
    return [];
  }
}

/// OLD: Fetch ALL orders by pincode (Pending + Delivery + Cancel combined)
/// This fetches orders for all statuses using the existing working endpoint
/// 
/// IMPORTANT: Backend needs to update the Order/v1/getOrdersByuser endpoint to:
/// 1. Accept 'pincode' as an optional query parameter
/// 2. When pincode is provided, return ALL orders for that pincode from ALL users
/// 3. When pincode is NOT provided, return only the current user's orders (existing behavior)
/// 
/// Sample SQL query for backend implementation:
/// SELECT so.* FROM sabji_order so
/// JOIN sabjorder_Address soa ON so.orderUserId = soa.userId
/// WHERE soa.post_code = @pincode AND so.orderStatus = @status
/// ORDER BY so.orderDate DESC
Future<List<Myorders>> getOrdersByPincode({
  required String pincode,
  required String token,
  required String mobileNumber,
}) async {
  List<Myorders> allOrders = [];

  try {
    print("=========== GET ALL ORDERS BY PINCODE (NEW ENDPOINT) ===========");
    print("Pincode: $pincode");
    print("Mobile: $mobileNumber (current user)");
    
    // Use the new pincode-based endpoint instead of the user-based one
    String url = "${Config.url}${Config.ordersByPincode}?pincode=$pincode";
    
    print("URL: $url");
    
    var response = await Dio().get(
      url,
      options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      ),
    );

    print("Response Status: ${response.statusCode}");
    
    if (response.statusCode == 200) {
      List list = response.data ?? [];
      print("Received ${list.length} TOTAL orders for pincode $pincode (from ALL users)");
      
      List<Myorders> parsedOrders = list.map((e) {
        try {
          return Myorders.fromJson(e);
        } catch (err) {
          print("ERROR parsing order: $err");
          return null;
        }
      }).whereType<Myorders>().toList();
      
      allOrders.addAll(parsedOrders);
    }
    
    print("\n=========== ORDERS BREAKDOWN BY STATUS ===========");
    print("Total: ${allOrders.length} orders");
    
    // Count by status
    int pendingCount = allOrders.where((o) => o.orderStatus == 'P').length;
    int deliveryCount = allOrders.where((o) => o.orderStatus == 'D').length;
    int cancelCount = allOrders.where((o) => o.orderStatus == 'C').length;
    
    print("📦 Pending (P): $pendingCount");
    print("🚚 Delivery (D): $deliveryCount");
    print("❌ Cancelled (C): $cancelCount");
    
    // Group by mobile number
    Map<String, List<Myorders>> ordersByMobile = {};
    for (var order in allOrders) {
      String mobile = order.orderUserId ?? 'Unknown';
      if (!ordersByMobile.containsKey(mobile)) {
        ordersByMobile[mobile] = [];
      }
      ordersByMobile[mobile]!.add(order);
    }
    
    print("\nOrders by Mobile Number:");
    ordersByMobile.forEach((mobile, orders) {
      print("  Mobile: $mobile - ${orders.length} orders");
      for (var order in orders) {
        String statusStr = _getStatusName(order.orderStatus);
        print("    ✓ Order #${order.orderNumber}: ₹${order.orderFullPrice} ($statusStr)");
      }
    });
    
    print("\nIMPORTANT: If only 1 mobile number is showing, the backend needs to be updated");
    print("to support the 'pincode' parameter in Order/v1/getOrdersByuser endpoint");

  } on DioException catch (e) {
    print("=========== API ERROR ===========");
    if (e.response != null) {
      print("STATUS : ${e.response?.statusCode}");
      print("DATA : ${e.response?.data}");
    } else {
      print("ERROR: ${e.message}");
    }
  } catch (e) {
    print("ERROR: $e");
  }

  return allOrders;
}

/// Helper method to get status name
String _getStatusName(String? status) {
  switch (status?.toUpperCase()) {
    case 'P':
      return 'Pending';
    case 'D':
      return 'Delivery';
    case 'C':
      return 'Cancelled';
    default:
      return status ?? 'Unknown';
  }
}

/// Fetch ALL orders from ALL PINCODES (without pincode filter)
/// Returns combined list of orders for all statuses (P, D, C) from all pincodes
Future<List<Myorders>> getAllOrdersAllPincodes({
  required String token,
  required String mobileNumber,
}) async {
  List<Myorders> allOrders = [];

  try {
    print("=========== GET ALL ORDERS FROM ALL PINCODES ===========");
    print("Mobile: $mobileNumber (current user)");
    print("Fetching ALL orders without pincode filter...");
    
    // Fetch orders for all statuses (P, D, C)
    final statuses = ['P', 'D', 'C'];
    
    for (String status in statuses) {
      try {
        String url = "${Config.url}${Config.orders}?status=$status&user=$mobileNumber";
        
        print("\nFetching $status orders from: $url");
        
        var response = await Dio().get(
          url,
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: "Bearer $token",
            },
          ),
        );

        if (response.statusCode == 200) {
          List list = response.data ?? [];
          print("Received ${list.length} orders with status $status");
          
          List<Myorders> parsedOrders = list.map((e) {
            try {
              return Myorders.fromJson(e);
            } catch (err) {
              print("ERROR parsing order: $err");
              return null;
            }
          }).whereType<Myorders>().toList();
          
          allOrders.addAll(parsedOrders);
        }
      } catch (statusError) {
        print("Error fetching status $status: $statusError");
        // Continue with next status even if one fails
      }
    }
    
    print("\n=========== ALL ORDERS BREAKDOWN ===========");
    print("Total: ${allOrders.length} orders from all pincodes");
    
    // Count by status
    int pendingCount = allOrders.where((o) => o.orderStatus == 'P').length;
    int deliveryCount = allOrders.where((o) => o.orderStatus == 'D').length;
    int cancelCount = allOrders.where((o) => o.orderStatus == 'C').length;
    
    print("📦 Pending (P): $pendingCount");
    print("🚚 Delivery (D): $deliveryCount");
    print("❌ Cancelled (C): $cancelCount");
    
    // Group by mobile number
    Map<String, List<Myorders>> ordersByMobile = {};
    for (var order in allOrders) {
      String mobile = order.orderUserId ?? 'Unknown';
      
      if (!ordersByMobile.containsKey(mobile)) {
        ordersByMobile[mobile] = [];
      }
      
      ordersByMobile[mobile]!.add(order);
    }
    
    print("\nOrders by Mobile Number:");
    ordersByMobile.forEach((mobile, orders) {
      print("  📱 Mobile: $mobile - ${orders.length} total orders");
      for (var order in orders) {
        String statusStr = _getStatusName(order.orderStatus);
        print("    ✓ Order #${order.orderNumber}: ₹${order.orderFullPrice} ($statusStr)");
      }
    });

  } on DioException catch (e) {
    print("=========== API ERROR ===========");
    if (e.response != null) {
      print("STATUS : ${e.response?.statusCode}");
      print("DATA : ${e.response?.data}");
    } else {
      print("ERROR: ${e.message}");
    }
  } catch (e) {
    print("ERROR: $e");
  }

  return allOrders;
}

//   Future<List<Myorders>> myPaymentsList(
//       {required String orderstatus, required String token, required String mobileNumber}) async {
//     List<Myorders> data = [];
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
// String userRole = prefs.getString("ROLE") ?? "CUSTOMER";    try {
//       String url = Config.url +
//           Config.orders +
// "?status=$orderstatus&user=$mobileNumber&userRole=$userRole";
//       print(url);
//       var response = await Dio().get(url,
//           options: Options(headers: {
//             HttpHeaders.contentTypeHeader: 'application/json',
//             HttpHeaders.authorizationHeader: 'Bearer $token',
//           }));
//       final int status = response.statusCode ?? 0;
//       if (status == 200) {
//         final List respList = (response.data as List?) ?? [];
//         data = respList.map((i) => Myorders.fromJson(i as Map<String, dynamic>)).toList();
//       }
//       print(response.data);
//     } on DioException catch (e) {
//       print(e.response);
//     }

//     return data;
//   }

  Future<LoginResponse?> login(String username, String password) async {
    LoginResponse? model;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = Config.loginUrl + Config.login;
    try {
      final response = await Dio().post(
        url,
        data: {
          "username": username,
          "password": password,
        },
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );
      final int status = response.statusCode ?? 0;
      if (status == 200 && response.data != null) {
        model = LoginResponse.fromJson(response.data);
        final roles = model.roleDetails ?? [];
        if (roles.isEmpty) {
          prefs.setString("ROLE", "Role not assigned");
          globals.role = prefs.getString("ROLE") ?? "Role not assigned";
        } else {
          final String roleName = (roles.first.name ?? "Role not assigned");
          prefs.setString("ROLE", roleName);
          globals.role = roleName;
        }
      } else {
        prefs.setString("ROLE", "Role not assigned");
        globals.role = prefs.getString("ROLE") ?? "Role not assigned";
      }
    } on DioException catch (e) {
      print(e.message);
      model = LoginResponse();
      model.statusCode = 400;
    }
    return model;
  }

  Future<LoginResponse?> Otplogin(String username, String accessCode) async {
    LoginResponse? model;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String url = Config.loginUrl + Config.login;
    try {
      final response = await Dio().post(
        url,
        data: {"username": username, "acessCode": accessCode},
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      final int status = response.statusCode ?? 0;
      if (status == 200 && response.data != null) {
        model = LoginResponse.fromJson(response.data);
        final roles = model.roleDetails ?? [];
        if (roles.isEmpty) {
          prefs.setString("ROLE", "Role not assigned");
          globals.role = prefs.getString("ROLE") ?? "Role not assigned";
        } else {
          final String roleName = roles.first.name ?? "Role not assigned";
          prefs.setString("ROLE", roleName);
          globals.role = roleName;
        }
      } else {
        prefs.setString("ROLE", "Role not assigned");
        globals.role = prefs.getString("ROLE") ?? "Role not assigned";
      }
    } on DioException catch (e) {
      print(e.message);
      model = LoginResponse();
      model.statusCode = 400;
    }
    return model;
  }

  Future<bool> loginOTP(String mobileNumber) async {
    bool ret = false;
    String url = Config.loginUrl + Config.loginOtp;
    print(url);
    try {
      final response = await Dio().post(
        url,
        data: {
          "mobileNumber": mobileNumber,
        },
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if ((response.statusCode ?? 0) == 201) {
        ret = true;
      }
    } on DioException catch (e) {
      ret = false;
      print(e.message);
    }
    return ret;
  }

  Future<StatusUpdate?> statusUpdate(
    String ordernumber,
    String status,
    String token,
  ) async {
    StatusUpdate? model;
    String url = Config.url + Config.ordersatus;
    print(url);
    try {
      final response = await Dio().put(
        url,
        data: {
          "orderNumber": ordernumber,
          "orderStatus": status,
        },
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
        ),
      );

      if ((response.statusCode ?? 0) == 200 && response.data != null) {
        model = StatusUpdate.fromJson(response.data);
        print(url);
        print(response.data);
      }
    } on DioException catch (e) {
      print(e.message);
    }
    return model;
  }

  Future<bool> loginWithOTP(String mobileNumber) async {
    bool ret = false;
    String url = Config.loginUrl + Config.otp;
    try {
      final response = await Dio().post(
        url,
        data: {
          "mobileNumber": mobileNumber,
        },
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if ((response.statusCode ?? 0) == 201) {
        ret = true;
        print(response.data);
      }
    } on DioException catch (e) {
      ret = false;
      print(e.message);
    }
    return ret;
  }

  Future<bool> forgotpassword(ForgotPasswordOTP model) async {
    bool ret = false;
    String url = Config.loginUrl + Config.forgotPassword;
    try {
      final response = await Dio().post(
        url,
        data: jsonEncode(model.toJson()),
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if ((response.statusCode ?? 0) == 201) {
        ret = true;
        print(response.data);
      }
    } on DioException catch (e) {
      ret = false;
      print(e.message);
    }
    return ret;
  }

  Future<List<Category>> getCategory(String token, String city) async {
    List<Category> data = [];
    try {
      String url = Config.url + Config.categoryUrl + "?cityName=Bengaluru";
      print("category city>>>>>>>>>>>>>>>>>>>>>>>>");
      print(url);

      var response = await Dio().get(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if ((response.statusCode ?? 0) == 200) {
        final List respList = (response.data as List?) ?? [];
        data = respList.map((i) => Category.fromJson(i as Map<String, dynamic>)).toList();
      }
    } on DioException catch (e) {
      print(e.response);
    }
    return data;
  }

  Future<List<SamarpanaProductDetails>> getSamarpanaProducts(
      {required String token, required int categoryId}) async {
    List<SamarpanaProductDetails> data = [];
    try {
      String url =
          Config.url + Config.getSamarpanaProduct + "?categoryId=$categoryId";
      print("token Comming>>>>>>>>>>>>>>>");
      print(token);
      print(categoryId);
      print("token Comming>>>>>>>>>>>>>>>");
      print(url);
      var response = await Dio().get(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if ((response.statusCode ?? 0) == 200) {
        final List respList = (response.data as List?) ?? [];
        data = respList.map((i) => SamarpanaProductDetails.fromJson(i as Map<String, dynamic>)).toList();
      }
    } on DioException catch (e) {
      print(e.response);
    }
    return data;
  }

  Future<List<Product>> getProduct(
      {required int cId,
      required int pageNumber,
      required int pageSize,
      required String strSearch,
      required String sortBy,
      required String token,
      String sortOrder = "asc"}) async {
    List<Product> data = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('Location');
    location ??= '';
    if (location.contains('Mountain View')) {
      location = 'Bengaluru';
    }
    try {
      String url = Config.url + Config.getSamarpanaProduct + "?categoryId=$cId";
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>url");
      print(url);
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>url");
      var response = await Dio().get(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if ((response.statusCode ?? 0) == 200) {
        final List respList = (response.data as List?) ?? [];
        data = respList.map((i) => Product.fromJson(i as Map<String, dynamic>)).toList();
      }
    } on DioException catch (e) {
      print(e.response);
    }

    return data;
  }

  Future<List<OrderModel>> getorderdetails(
      String mobileNumber, String token) async {
    List<OrderModel> data = [];
    try {
      String url =
          Config.url + Config.getOrderDetails + "?customerId=$mobileNumber";
      print(url);
      var response = await Dio().get(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if ((response.statusCode ?? 0) == 200) {
        final List respList = (response.data as List?) ?? [];
        data = respList.map((i) => OrderModel.fromJson(i as Map<String, dynamic>)).toList();
      }
      print(response.data);
    } on DioException catch (e) {
      print(e.response);
    }

    return data;
  }

  Future<List<UserAddressModel>> getuseraddress(
      int userId, String token) async {
    List<UserAddressModel> data = [];
    try {
      String url = Config.loginUrl + Config.useraddress + "?userId=$userId";

      var response = await Dio().get(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if ((response.statusCode ?? 0) == 200) {
        print(url);
        print(response.data);
        final List respList = (response.data as List?) ?? [];
        data = respList.map((i) => UserAddressModel.fromJson(i as Map<String, dynamic>)).toList();
      }
    } on DioException catch (e) {
      print(e.response);
    }
    return data;
  }

  Future<List<Product>> getTopsavingProduct(int cId) async {
    List<Product> data = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('Location');
    location ??= '';
    if (location.contains('Mountain View')) {
      location = 'Bengaluru';
    }
    try {
      String url =
          "http://43.205.203.15:8082/subjeeService/product/v1/topSaving?cId=$cId&cityName=$location";
      var response = await Dio().get(url,
          options: Options(
              headers: {HttpHeaders.contentTypeHeader: 'application/json'}));
      if ((response.statusCode ?? 0) == 200) {
        final List respList = (response.data as List?) ?? [];
        data = respList.map((i) => Product.fromJson(i as Map<String, dynamic>)).toList();
      }
    } on DioException catch (e) {
      print(e.response);
    }

    return data;
  }

  Future<bool> addNewaddress(AddUserAddress model, String token) async {
    bool ret = false;
    try {
      String url = Config.loginUrl + Config.newaddress;

      print(url);
      print(token);
      print(model.userId);
      print(jsonEncode(model.toJson()));
      var response = await Dio().post(url,
          data: model.toJson(),
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: 'Bearer $token',
            },
          ));
      if ((response.statusCode ?? 0) == 201) {
        print(response.data);
        return true;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print(e.error);
        return false;
      } else {
        print(e.message);
        return false;
      }
    }
    return ret;
  }

  Future<List<Timeslot>> getTimeslot(String token) async {
    List<Timeslot> data = [];
    try {
      String url = Config.url + Config.timeslot;
      print(url);
      var response = await Dio().get(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if ((response.statusCode ?? 0) == 200) {
        final List respList = (response.data as List?) ?? [];
        data = respList.map((i) => Timeslot.fromJson(i as Map<String, dynamic>)).toList();
      }
      print(response.data);
      print(token);
    } on DioException catch (e) {
      print(e.response);
    }

    return data;
  }

  Future<bool> createOrder(CreateOrder createOrder, String token) async {
    bool isOrderCreated = false;
    print('Creating order with data: ${createOrder.toJson()}');
    print('Order JSON: ${jsonEncode(createOrder.toJson())}');
    
    String url = Config.url + Config.placeOrderURL;
    print('Order API URL: $url');
    
    try {
      var response = await Dio().post(url,
          data: jsonEncode(createOrder.toJson()),
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: 'Bearer $token',
            },
          ));
      
      print('Order Response Status: ${response.statusCode}');
      print('Order Response Data: ${response.data}');
      
      // Check both HTTP status and API response status
      if ((response.statusCode ?? 0) == 200 || (response.statusCode ?? 0) == 201) {
        // Check if response contains success indicator
        if (response.data is Map) {
          final responseMap = response.data as Map<String, dynamic>;
          final statusCode = responseMap['statusCode'];
          final message = responseMap['message'];
          
          // Backend returns statusCode 400 even with HTTP 200 on validation error
          if (statusCode == 400 || message?.toString().contains('not Validated') == true) {
            print('Order validation failed: $message');
            return false;
          }
          
          if (statusCode == 200 || statusCode == null || message?.toString().contains('Success') == true) {
            print('Order created successfully!');
            return true;
          }
        }
        print('Order created successfully!');
        return true;
      } else {
        print('Order failed with status code: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      print('DioException - Status Code: ${e.response?.statusCode}');
      print('DioException - Error: ${e.error}');
      print('DioException - Message: ${e.message}');
      print('DioException - Response: ${e.response?.data}');
      return false;
    } catch (e) {
      print('Unexpected error creating order: $e');
      return false;
    }
  }

  Future<double> getwalletBal(String mobile, String token) async {
    WalletBalancemodel? data;

    try {
      String url =
          Config.paymentservice + Config.getwalbalance + "?userId=$mobile";
      var response = await Dio().get(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          }));
      if ((response.statusCode ?? 0) == 200 && response.data != null) {
        data = WalletBalancemodel.fromJson(response.data);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setDouble('Walletamt', data.walletBalance ?? 0.0);
        print(url);
        print(prefs.getDouble("Walletamt"));
      }
    } on DioException catch (e) {
      print(e.response);
    }
    return data?.walletBalance ?? 0.0;
  }

  Future<double> getTotalAmount(String mobile, String token) async {
    WalletBalancemodel? data;

    try {
      String url =
          Config.paymentservice + Config.totalTransAmount + "?userId=$mobile";
      var response = await Dio().get(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if ((response.statusCode ?? 0) == 200 && response.data != null) {
        data = WalletBalancemodel.fromJson(response.data);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setDouble('Totalamt', data.walletBalance ?? 0.0);
        print(url);
        print(prefs.getDouble("Totalamt"));
      }
    } on DioException catch (e) {
      print(e.response);
    }
    return data?.walletBalance ?? 0.0;
  }

  Future<FundAccountResponse?> addfundAccount(FundAccount vendor) async {
    FundAccountResponse? data;
    try {
      String username = Config.razorpaykey;
      String password = Config.apiSecret;
      String basicAuth = base64Encode(utf8.encode('$username:$password'));
      print(basicAuth);
      print(vendor);
      String url = "https://api.razorpay.com/v1/fund_accounts";
      var response = await Dio().post(url,
          data: jsonEncode(vendor.toJson()),
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: 'Basic $basicAuth',
            },
          ));
      final int status = response.statusCode ?? 0;
      if (status == 200 || status == 201) {
        print(response.data);
        data = FundAccountResponse.fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        data = null;
        print(data);
      } else {
        if (e.response?.data != null) {
          data = FundAccountResponse.fromJson(e.response!.data);
        } else {
          data = null;
        }
      }
    }
    return data;
  }

  Future<WithdrawRequest?> withdrawmoney(
      WithdrawRequest request, String token) async {
    WithdrawRequest? data;
    try {
      String url = Config.url + Config.withdrawmoney;
      print(request.toJson());
      var response = await Dio().post(url,
          data: jsonEncode(request.toJson()),
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: 'Bearer $token',
            },
          ));
      if ((response.statusCode ?? 0) == 201 && response.data != null) {
        data = WithdrawRequest.fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        data = WithdrawRequest.fromJson(e.response!.data);
      } else {
        data = null;
      }
    }
    return data;
  }

  Future<Contactadded?> addrzpccontact(Contactadded contid, String token) async {
    Contactadded? data;
    try {
      String url = Config.paymentservice + Config.rzpContact;
      var response = await Dio().post(url,
          data: jsonEncode(contid.toJson()),
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: 'Bearer $token',
            },
          ));
      if ((response.statusCode ?? 0) == 200 && response.data != null) {
        data = Contactadded.fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        data = Contactadded.fromJson(e.response!.data);
      } else {
        data = null;
      }
    }
    return data;
  }

  Future<BankContactadded?> addbankcontact(
      BankContactadded contid, String token) async {
    BankContactadded? data;
    try {
      String url = Config.paymentservice + Config.rzpbankid;
      var response = await Dio().post(url,
          data: jsonEncode(contid.toJson()),
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: 'Bearer $token',
            },
          ));
      if ((response.statusCode ?? 0) == 201 && response.data != null) {
        print(response.data);
        data = BankContactadded.fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        data = BankContactadded.fromJson(e.response!.data);
      } else {
        data = null;
      }
    }
    return data;
  }

  Future<ContactResponse?> createContact(CreateContact vendor) async {
    ContactResponse? data;
    try {
      String username = Config.razorpaykey;
      String password = Config.apiSecret;
      String basicAuth = base64Encode(utf8.encode('$username:$password'));
      String url = "https://api.razorpay.com/v1/contacts";
      var response = await Dio().post(url,
          data: jsonEncode(vendor.toJson()),
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: 'Basic $basicAuth',
            },
          ));
      if ((response.statusCode ?? 0) == 200 && response.data != null) {
        print(response.data);
        data = ContactResponse.fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        data = ContactResponse.fromJson(e.response!.data);
      } else {
        data = null;
      }
    }
    return data;
  }

  Future<VendorAccountdetails?> getVendorBankDetails(
      String mobile, String token) async {
    VendorAccountdetails? data;

    try {
      String url =
          Config.paymentservice + Config.getvendorbankdata + "?userId=$mobile";
      print(url);
      var response = await Dio().get(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if ((response.statusCode ?? 0) == 200 && response.data != null) {
        data = VendorAccountdetails.fromJson(response.data);
      }
    } on DioException catch (e) {
      print(e.response);
    }
    return data;
  }

  Future<List<WalletHistory>> getwalletHistorydetails(
      String mobileNumber, String token) async {
    List<WalletHistory> data = [];
    try {
      String url = Config.paymentservice +
          Config.wallethistory +
          "?userId=$mobileNumber";
      print(url);
      var response = await Dio().get(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if ((response.statusCode ?? 0) == 200) {
        final List respList = (response.data as List?) ?? [];
        data = respList.map((i) => WalletHistory.fromJson(i as Map<String, dynamic>)).toList();
      }
      print(response.data);
    } on DioException catch (e) {
      print(e.response);
    }

    return data;
  }

  Future<List<BankTrascationModel>> getBanktHistorydetails(
      String mobileNumber, String token) async {
    List<BankTrascationModel> data = [];
    try {
      String url = Config.paymentservice +
          Config.accountHistory +
          "?userId=$mobileNumber";
      print(url);
      var response = await Dio().get(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      if ((response.statusCode ?? 0) == 200) {
        final List respList = (response.data as List?) ?? [];
        data = respList.map((i) => BankTrascationModel.fromJson(i as Map<String, dynamic>)).toList();
      }
      print(response.data);
    } on DioException catch (e) {
      print(e.response);
    }

    return data;
  }

  Future<UpdatePasswordModel?> updatepassword(UpdatePasswordModel model) async {
    UpdatePasswordModel? data;
    String url = Config.loginUrl + Config.updatePassword;
    try {
      final response = await Dio().post(
        url,
        data: jsonEncode(model.toJson()),
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if ((response.statusCode ?? 0) == 201 && response.data != null) {
        data = UpdatePasswordModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        data = UpdatePasswordModel.fromJson(e.response!.data);
      } else {
        data = null;
      }
    }
    return data;
  }
}
