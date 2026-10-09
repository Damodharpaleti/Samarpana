import 'dart:convert';

import 'package:Samarpana/model/AddmoneyToWallet.dart';
import 'package:Samarpana/model/BankTransactionDetails.dart';
import 'package:Samarpana/model/Order_details_Model.dart';
import 'package:Samarpana/model/PlaceOrder_model.dart';
import 'package:Samarpana/model/ProductLocal.dart';
import 'package:Samarpana/model/SamarpanaProductDetails.dart';
import 'package:Samarpana/model/TimeSlot_Model.dart';
import 'package:Samarpana/model/UseraddressModel.dart';
import 'package:Samarpana/model/Vendor_AccountModel.dart';
import 'package:Samarpana/model/WalletTransacDetailsModel.dart';
import 'package:flutter/widgets.dart';
import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/model/MyPayments_Model.dart';
import 'package:Samarpana/model/User_Signup_Model.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
// ignore: non_constant_identifier_names
  bool _isorderCreated = false;
  late APIService apiService;
  late List<Timeslot> _timeslot;
  late AddMoneyToWallet addMoneyToWallet;
  AddMoneyToWallet get walletdetails => addMoneyToWallet;
  List<Timeslot> get timeslotlist => _timeslot;
  late List<Myorders> _mypayments;
  late List<Myorders> _myDelivery;
  late List<Myorders> _myCancel;
  List<Myorders> _myStatus = [];
  List<Myorders> _ordersByPincode = [];
  List<Myorders> _filteredOrdersByStatus = [];
  String _selectedStatusFilter = '';
  late VendorAccountdetails vendorBankDetails;
  String moblieNumber = '';
  late CreateOrder _timeslotset;
  late BankContactadded bankContactadded;
  bool get ispaymentsucess => _ispayment;
  late CreateOrder _address;
  late FundAccount _fundAccount;
  late FundAccountResponse response;
  bool _ispayment = false;
  CreateOrder get creatingtimeOrder => _timeslotset;
  CreateOrder get creatingaddressOrder => _address;
  FundAccount get getbankdetailsdata => _fundAccount;
  late List<ProductLocal> _cartItems;
  final dbHelper = DBProvider.instance;
    List<SamarpanaProductDetails> _samarpanaproductdetails = [];
    List<SamarpanaProductDetails> get samarpanaproductdetailList =>
      _samarpanaproductdetails;
  List<UserdatafromDB> list = [];
  late List<OrderModel> _orderList;
  late List<WalletHistory> _walletHistory;
  late List<BankTrascationModel> _banktransHistory;
  late List<UserAddressModel> _useraddress;
  List<UserAddressModel> get userAddressmodel => _useraddress;
  List<ProductLocal> get CartItems => _cartItems;
  late CreateOrder _createOrder;
  int flag = 0;
  int bankflag = 0;
  CreateOrder get creatingOrder => _createOrder;
  double get totalRecords => _cartItems.length.toDouble();
  double get totalAmount {
    if (_cartItems.isEmpty) return 0.0;
    return _cartItems
        .map<double>((e) => e.totalPrice)
        .reduce((value, element) => value + element);
  }
  late UserdatafromDB model;
  late User user;
  VendorAccountdetails get vendorBankDetailsdata => vendorBankDetails;
  List<Myorders> get paymentslist => _mypayments;
  int get flagnum => flag;
  int get bankflagnum => bankflag;
  List<Myorders> get deliverylist => _myDelivery;
  List<Myorders> get cancelList => _myCancel;
  List<Myorders> get pendingList => _myStatus;
  List<Myorders> get ordersByPincode => _ordersByPincode;
  List<Myorders> get filteredOrdersByStatus => _filteredOrdersByStatus;
  String get selectedStatusFilter => _selectedStatusFilter;
  bool get isorderCreated => _isorderCreated;
  String email = '';
  String payment = '';
  double walletamt = 0.0;
  List<OrderModel> get allOrders => _orderList;
  List<BankTrascationModel> get banktrascation => _banktransHistory;
  List<WalletHistory> get allwalletdata => _walletHistory;
  //String get idemail => model.emailId;
  String get mobNum => model.mobileNumber ?? '';
  /// userId is used by wallet APIs where the mobile number acts as the identifier.
  /// This mirrors how `getwalletBal` constructs the request using `?userId=$mobile`.
  String get userId => mobNum;

  double get finalamount => creatingtimeOrder.razorpayamt?.toDouble() ?? 0.0;
  int get count => ordercount;
  int ordercount = 0;
  CartProvider() {
    list = [];
    apiService = APIService();
    _cartItems = [];
    _timeslot = [];
    _mypayments = [];
    _myDelivery = [];
    _myCancel = [];
    _myStatus = [];
    _ordersByPincode = [];
    _filteredOrdersByStatus = [];
    _selectedStatusFilter = '';
    _orderList = [];
    _walletHistory = [];
    _banktransHistory = [];
    _useraddress = [];
    _samarpanaproductdetails = [];
    _createOrder = CreateOrder();
    _timeslotset = CreateOrder();
    _address = CreateOrder();
    _fundAccount = FundAccount(contactId: '', accountType: '', bankAccount: BankAccount(name: '', ifsc: '', account_number: ''));
    addMoneyToWallet = AddMoneyToWallet(userId: '', amount: '0.0', transactionid: '');
    bankContactadded = BankContactadded(
      rzpbankid: '',
      mobileNumber: '',
      message: '',
      statusCode: 0,
    );
    vendorBankDetails = VendorAccountdetails();
    response = FundAccountResponse(
      id: '',
      entity: '',
      contactId: '',
      accountType: '',
      bankAccount: BankAccount(name: '', ifsc: '', account_number: ''),
      batchId: '',
      active: true,
      createdAt: 0,
    );
    user = User();
    model = UserdatafromDB('', '', '', '', '', '', '', '', '', 0);
    flag = 0;
    bankflag = 0;
    ordercount = 0;
    moblieNumber = '';
    email = '';
    payment = '';
    walletamt = 0.0;
  }

  fetchOrders() async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          print(allRows);
          model = UserdatafromDB(
            row["id"],
            row["name"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
            row["walletamt"],
          );
          list.add(model);
        });
    print(allRows);

    String customerId = model.mobileNumber ?? '';
    String token = model.token ?? '';
    List<OrderModel> orderList =
        await apiService.getorderdetails(customerId, token);
    print(customerId);
    if (orderList.length > 0) {
      _orderList = [];
      _orderList.addAll(orderList);
    }
    notifyListeners();
  }

  getwalletTransdata() async {
    try {
      final allRows = await dbHelper.queryuserRows();
      if (allRows.isEmpty) {
        print('No user data found in database');
        _walletHistory = [];
        notifyListeners();
        return;
      }
      allRows.forEach((row) {
            print(allRows);
            model = UserdatafromDB(
              row["id"],
              row["name"],
              row["address1"],
              row["address2"],
              row["state"],
              row["city"],
              row["pinCode"],
              row["mobileNumber"],
              row["token"],
              row["walletamt"],
            );
            list.add(model);
          });
      print(allRows);

      // Validate user data before making API call
      if (model.mobileNumber == null || model.mobileNumber!.isEmpty) {
        print('Error: Mobile number is empty. User not logged in properly');
        _walletHistory = [];
        notifyListeners();
        return;
      }

      String customerId = model.mobileNumber ?? '';
      String token = model.token ?? '';
      List<WalletHistory> wallettransList =
          await apiService.getwalletHistorydetails(customerId, token);
      print(customerId);
      // if (_walletHistory == null) {
      //   _walletHistory = new List<WalletHistory>();
      // }
      if (wallettransList.length > 0) {
        flag = 1;
        _walletHistory = [];
        _walletHistory.addAll(wallettransList);
      } else {
        flag = 0;
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching wallet transaction data: $e');
      _walletHistory = [];
      notifyListeners();
    }
  }

  getBankTransdata() async {
    try {
      final allRows = await dbHelper.queryuserRows();
      if (allRows.isEmpty) {
        print('No user data found in database');
        _banktransHistory = [];
        notifyListeners();
        return;
      }
      allRows.forEach((row) {
            print(allRows);
            model = UserdatafromDB(
              row["id"],
              row["name"],
              row["address1"],
              row["address2"],
              row["state"],
              row["city"],
              row["pinCode"],
              row["mobileNumber"],
              row["token"],
              row["walletamt"],
            );
            list.add(model);
          });
      print(allRows);

      // Validate user data before making API call
      if (model.mobileNumber == null || model.mobileNumber!.isEmpty) {
        print('Error: Mobile number is empty. User not logged in properly');
        _banktransHistory = [];
        notifyListeners();
        return;
      }

      String customerId = model.mobileNumber ?? '';
      String token = model.token ?? '';
      List<BankTrascationModel> wallettransList =
          await apiService.getBanktHistorydetails(customerId, token);
      print(customerId);
      if (wallettransList.length > 0) {
        bankflag = 1;
        _banktransHistory = [];
        _banktransHistory.addAll(wallettransList);
      } else {
        bankflag = 0;
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching bank transaction data: $e');
      _banktransHistory = [];
      notifyListeners();
    }
  }

  fetchMypayments({String? status}) async {
    try {
      final allRows = await dbHelper.queryuserRows();
      if (allRows.isEmpty) {
        print('No user data found in database');
        _mypayments = [];
        notifyListeners();
        return;
      }
      allRows.forEach((row) {
            print(allRows);
            // model = UserdatafromDB(
            //   row["id"].toString(),
            //   row["firstName"],
            //   row["lastName"],
            //   row["address1"],
            //   row["address2"],
            //   row["state"],
            //   row["city"],
            //   row["pinCode"],
            //   row["mobileNumber"],
            //   row["token"],
            // ),
            model = UserdatafromDB(
              row["id"],
              row["name"],
              row["address1"],
              row["address2"],
              row["state"],
              row["city"],
              row["pinCode"],
              row["mobileNumber"],
              row["token"],
              row["walletamt"],
            );
            list.add(model);
          });
      print(allRows);

      // Validate user data before making API call
      if (model.mobileNumber == null || model.mobileNumber!.isEmpty) {
        print('Error: Mobile number is empty. User not logged in properly');
        _mypayments = [];
        notifyListeners();
        return;
      }

      String token = model.token ?? '';
      String mobileNumber = model.mobileNumber ?? '';
      
      print('DEBUG fetchMyStatus:');
      print('  Status: $status');
      print('  Mobile: $mobileNumber');
      print('  Fetching orders...');
      
      List<Myorders> orderList = await apiService.myPaymentsList(
          orderstatus: status ?? '', token: token, mobileNumber: mobileNumber);
      
      print('DEBUG fetchMyStatus - Result:');
      print('  Total orders received: ${orderList.length}');
      
      if (orderList.length > 0) {
        _mypayments = [];
        _mypayments.addAll(orderList);
        print('  Orders stored in provider: ${_mypayments.length}');
        _mypayments.forEach((order) {
          print('    - ${order.orderNumber}: ${order.orderFullPrice}');
        });
      } else {
        print('  No orders received');
        _mypayments = [];
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching payments: $e');
      _mypayments = [];
      notifyListeners();
    }
  }

  getwalletbalance() async {
    try {
      final allRows = await dbHelper.queryuserRows();
      if (allRows.isEmpty) {
        print('No user data found in database');
        return;
      }
      allRows.forEach((row) {
            print(allRows);
            model = UserdatafromDB(
              row["id"],
              row["name"],
              row["address1"],
              row["address2"],
              row["state"],
              row["city"],
              row["pinCode"],
              row["mobileNumber"],
              row["token"],
              row["walletamt"],
            );
            list.add(model);
          });
      print(allRows.length);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Validate user data before making API call
      if (model.mobileNumber == null || model.mobileNumber!.isEmpty) {
        print('Error: Mobile number is empty. User not logged in properly');
        return;
      }

      await apiService
        .getwalletBal(model.mobileNumber ?? '', model.token ?? '')
          .then((value) => prefs.setDouble("Walletamt", value));
    } catch (e) {
      print('Error fetching wallet balance: $e');
    }
  }

  gettotalamout() async {
    try {
      final allRows = await dbHelper.queryuserRows();
      if (allRows.isEmpty) {
        print('No user data found in database');
        return;
      }
      allRows.forEach((row) {
            print(allRows);
            model = UserdatafromDB(
              row["id"],
              row["name"],
              row["address1"],
              row["address2"],
              row["state"],
              row["city"],
              row["pinCode"],
              row["mobileNumber"],
              row["token"],
              row["walletamt"],
            );
            list.add(model);
          });
      print(allRows.length);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Validate user data before making API call
      if (model.mobileNumber == null || model.mobileNumber!.isEmpty) {
        print('Error: Mobile number is empty. User not logged in properly');
        return;
      }

      await apiService
        .getTotalAmount(model.mobileNumber ?? '', model.token ?? '')
          .then((value) => prefs.setDouble("Totalamt", value));
    } catch (e) {
      print('Error fetching total amount: $e');
    }
  }

  getbankdetails() async {
    try {
      final allRows = await dbHelper.queryuserRows();
      if (allRows.isEmpty) {
        print('No user data found in database');
        vendorBankDetails = VendorAccountdetails();
        notifyListeners();
        return;
      }
      allRows.forEach((row) {
            model = UserdatafromDB(
              row["id"],
              row["name"],
              row["address1"],
              row["address2"],
              row["state"],
              row["city"],
              row["pinCode"],
              row["mobileNumber"],
              row["token"],
              row["walletamt"],
            );
            list.add(model);
          });
      
      // Validate user data before making API call
      if (model.mobileNumber == null || model.mobileNumber!.isEmpty) {
        print('Error: Mobile number is empty. User not logged in properly');
        vendorBankDetails = VendorAccountdetails();
        notifyListeners();
        return;
      }
      
      vendorBankDetails = await apiService
        .getVendorBankDetails(model.mobileNumber ?? '', model.token ?? '') ??
        VendorAccountdetails();

      notifyListeners();
    } catch (e) {
      print('Error fetching bank details: $e');
      vendorBankDetails = VendorAccountdetails();
      notifyListeners();
    }
  }

  fetchMyDelivery({String? status}) async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          print(allRows);
          // model = UserdatafromDB(
          //   row["id"].toString(),
          //   row["firstName"],
          //   row["lastName"],
          //   row["address1"],
          //   row["address2"],
          //   row["state"],
          //   row["city"],
          //   row["pinCode"],
          //   row["mobileNumber"],
          //   row["token"],
          // ),
          model = UserdatafromDB(
            row["id"],
            row["name"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
            row["walletamt"],
          );
          list.add(model);
        });
    print(allRows);

    String token = model.token ?? '';
    String mobileNumber = model.mobileNumber ?? '';
    List<Myorders> orderList = await apiService.myPaymentsList(
        orderstatus: status ?? '', token: token, mobileNumber: mobileNumber);
    if (orderList.length > 0) {
      _myDelivery = [];
      _myDelivery.addAll(orderList);
    }
    notifyListeners();
  }

  fetchMyCancel({String? status}) async {
    print('\n🔍 fetchMyCancel: Starting to fetch CANCELLED ORDERS');
    
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
      model = UserdatafromDB(
        row["id"],
        row["name"],
        row["address1"],
        row["address2"],
        row["state"],
        row["city"],
        row["pinCode"],
        row["mobileNumber"],
        row["token"],
        row["walletamt"],
      );
      list.add(model);
    });

    String token = model.token ?? '';
    String mobileNumber = model.mobileNumber ?? '';
    
    print('🔍 fetchMyCancel: User Mobile: $mobileNumber');
    print('🔍 fetchMyCancel: Fetching ALL orders (all statuses)...');
    
    try {
      // Use the getAllOrdersAllStatuses method which fetches P, D, and C orders
      final allOrders = await apiService.getAllOrdersAllStatuses(
        token: token,
        mobileNumber: mobileNumber,
      );
      
      print('✅ Fetched ${allOrders.length} total orders from backend');
      
      // Filter for cancelled orders only (status 'C')
      _myCancel = allOrders.where((order) {
        final isCancelled = order.orderStatus?.toUpperCase() == 'C';
        if (isCancelled) {
          print('✅ [CANCELLED] Order #${order.orderNumber}: ${order.orderFullPrice} (Status: ${order.orderStatus}) (User: ${order.orderUserId})');
        }
        return isCancelled;
      }).toList();
      
      print('✅ Total CANCELLED orders found: ${_myCancel.length}');
      
      if (_myCancel.isEmpty) {
        print('⚠️ WARNING: No cancelled orders found for user $mobileNumber');
      }
      
    } catch (e) {
      print('❌ Error fetching cancelled orders: $e');
      _myCancel = [];
    }
    
    notifyListeners();
  }

  fetchMyStatus({String? status}) async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          print(allRows);
          // model = UserdatafromDB(
          //   row["id"].toString(),
          //   row["firstName"],
          //   row["lastName"],
          //   row["address1"],
          //   row["address2"],
          //   row["state"],
          //   row["city"],
          //   row["pinCode"],
          //   row["mobileNumber"],
          //   row["token"],
          // ),
          model = UserdatafromDB(
            row["id"],
            row["name"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
            row["walletamt"],
          );
          list.add(model);
        });
    print(allRows);
    String token = model.token ?? '';
    String mobileNumber = model.mobileNumber ?? '';
    List<Myorders> orderList = await apiService.myPaymentsList(
      orderstatus: status ?? '', token: token, mobileNumber: mobileNumber);
    if (orderList.length > 0) {
      ordercount = orderList.length;
      _myStatus = [];
      _myStatus.addAll(orderList);
    }
    notifyListeners();
  }

  fetchMySamarpanaProduct({int? categoryId}) async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          print(allRows);
          // model = UserdatafromDB(
          //   row["id"].toString(),
          //   row["firstName"],
          //   row["lastName"],
          //   row["address1"],
          //   row["address2"],
          //   row["state"],
          //   row["city"],
          //   row["pinCode"],
          //   row["mobileNumber"],
          //   row["token"],
          // ),
          model = UserdatafromDB(
            row["id"],
            row["name"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
            row["walletamt"],
          );
          list.add(model);
        });
    print(allRows);

    String token = model.token ?? '';
    String mobileNumber = model.mobileNumber ?? '';
    // List<SamarpanaProductDetails> orderList =
    //     await apiService.getSamarpanaProducts(token: token, cId:categoryId);
    List<SamarpanaProductDetails> orderList = await apiService
        .getSamarpanaProducts(token: token, categoryId: categoryId ?? 0);
    if (orderList.length > 0) {
      _samarpanaproductdetails = [];
      _samarpanaproductdetails.addAll(orderList);
    }
    notifyListeners();
  }

  updaterecord() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
    List darta = allRows;
    print(darta);
    _cartItems = darta
        .map((productLocal) => new ProductLocal.fromJson(productLocal))
        .toList();
      notifyListeners();
  }

  getuseraddress() async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          print(allRows);
          // model = UserdatafromDB(
          //   row["id"],
          //   row["firstName"],
          //   row["lastName"],
          //   row["address1"],
          //   row["address2"],
          //   row["state"],
          //   row["city"],
          //   row["pinCode"],
          //   row["mobileNumber"],
          //   row["token"],
          //   // row["emailId"],
          //   // row["walletamt"],
          // ),
          model = UserdatafromDB(
            row["id"],
            row["name"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
            row["walletamt"],
          );
          list.add(model);
        });
    print(allRows);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (list.isNotEmpty && model.id != null && model.id.toString().isNotEmpty) {
      try {
        List<UserAddressModel> timslot =
            await apiService.getuseraddress(int.parse(model.id.toString()), model.token ?? '');

        if (timslot.length > 0) {
          _useraddress = [];
          _useraddress.addAll(timslot);
          bool result =
              await prefs.setString('useraddressdata', jsonEncode(_useraddress));
          print(result);
        }
      } catch (e) {
        print('Error parsing user id or fetching address: $e');
      }
    }
    notifyListeners();
  }

  void resetSreams() {
    // _cartItems = new List<ProductLocal>();
    // list = new List<UserdatafromDB>();
  }
  timeslots() async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          print(allRows);
          model = UserdatafromDB(
            row["id"],
            row["name"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
            row["walletamt"],
          );
          list.add(model);
        });
    print(allRows);

    String token = model.token ?? '';
    moblieNumber = model.mobileNumber ?? '';
    // email = model.emailId;
    List<Timeslot> timslot = await apiService.getTimeslot(token);
    if (timslot.length > 0) {
      _timeslot = [];
      _timeslot.addAll(timslot);
    }
    notifyListeners();
  }

  placetimeslotProcess(CreateOrder order) {
    this._timeslotset = order;
    notifyListeners();
  }

  placeOrderProcess(CreateOrder order) {
    this._createOrder = order;
    notifyListeners();
  }

  addmoneyProcess(AddMoneyToWallet wallet) {
    this.addMoneyToWallet = wallet;
    notifyListeners();
  }

  addresstProcess(CreateOrder order) {
    this._address = order;
    notifyListeners();
  }

  getaccountProcess(FundAccount order) {
    this._fundAccount = order;
    notifyListeners();
  }

  fetch() async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          print(allRows);
          model = UserdatafromDB(
            row["id"],
            row["name"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
            row["walletamt"],
          );
          list.add(model);
        });
    print(allRows);
    notifyListeners();
  }

  void fundcreate() async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          print(allRows);
          model = UserdatafromDB(
            row["id"],
            row["name"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
            row["walletamt"],
          );
          list.add(model);
        });
    print(allRows);
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _fundAccount.bankAccount.account_number =
        getbankdetailsdata.bankAccount.account_number;
    _fundAccount.bankAccount.name = getbankdetailsdata.bankAccount.name;
    _fundAccount.bankAccount.ifsc = getbankdetailsdata.bankAccount.ifsc;
    _fundAccount.contactId = prefs.getString("cont_refId") ?? '';
    _fundAccount.accountType = "bank_account";
    await apiService.addfundAccount(_fundAccount).then((value) {
      if (value != null) {
        bankContactadded.mobileNumber = model.mobileNumber ?? '';
        bankContactadded.rzpbankid = value.id;
        apiService.addbankcontact(bankContactadded, model.token ?? '');
      }
    });
    }

  void ordercreate() async {
    try {
      if (_createOrder.productList == null) {
        _createOrder.productList = [];
      }
      _cartItems.forEach((v) {
        _createOrder.productList!.add(new ProductList(
          productId: v.productId,
          productCode: v.productCode,
          productName: v.productName,
          numOfItems: v.numOfItems.toString(),
          priceId: v.priceId,
          price: v.price,
          marketPrice: v.marketPrice,
          priceMinQuantity: v.priceMinQuantity,
          totalPrice: v.totalPrice.toString(),
          brandname: v.brandname,
        ));
      });
      
      if (_createOrder.shipping == null) {
        _createOrder.shipping = Shipping();
      }
      
      // Try to get address from _address (set by Timeslots page via addresstProcess)
      // If not available, use creatingaddressOrder
      print('DEBUG ordercreate - Checking address sources:');
      print('  _address.shipping: ${_address.shipping}');
      print('  creatingaddressOrder.shipping: ${creatingaddressOrder.shipping}');
      
      final primaryAddress = _address.shipping ?? creatingaddressOrder.shipping;
      
      if (primaryAddress != null) {
        print('DEBUG - Found address data:');
        print('  address1: ${primaryAddress.address1}');
        print('  city: ${primaryAddress.city}');
        print('  state: ${primaryAddress.state}');
        print('  postcode: ${primaryAddress.postcode}');
        
        _createOrder.shipping = Shipping(
          firstName: primaryAddress.firstName ?? '',
          lastName: primaryAddress.lastName ?? '',
          address1: primaryAddress.address1 ?? 'N/A',
          address2: primaryAddress.address2 ?? '',
          city: primaryAddress.city ?? 'N/A',
          state: primaryAddress.state ?? 'N/A',
          postcode: primaryAddress.postcode ?? '0',
          phone: primaryAddress.phone ?? model.mobileNumber.toString(),
          country: primaryAddress.country,
          email: primaryAddress.email,
        );
      } else {
        print('WARNING: No address found in either _address or creatingaddressOrder!');
        _createOrder.shipping?.address1 = 'N/A';
        _createOrder.shipping?.city = 'N/A';
        _createOrder.shipping?.state = 'N/A';
        _createOrder.shipping?.postcode = '0';
        _createOrder.shipping?.phone = model.mobileNumber.toString();
      }
      
      print('DEBUG - Final Shipping Address for Order:');
      print('  address1: ${_createOrder.shipping?.address1}');
      print('  city: ${_createOrder.shipping?.city}');
      print('  state: ${_createOrder.shipping?.state}');
      print('  postcode: ${_createOrder.shipping?.postcode}');
      print('  phone: ${_createOrder.shipping?.phone}');
      
      _createOrder.totalAmount = creatingtimeOrder.totalAmount;
      _createOrder.deliveryCharges = creatingtimeOrder.deliveryCharges ?? 0;
      _createOrder.customerId = model.mobileNumber.toString();
      _createOrder.timeSlot = creatingtimeOrder.timeSlot;
      _createOrder.walletamt = creatingtimeOrder.walletamt ?? 0.0;
      _createOrder.razorpayamt = creatingOrder.razorpayamt ?? creatingtimeOrder.razorpayamt ?? 0.0;
      _createOrder.setPaid = true;
      _createOrder.status = "Order Placed Successfully";
      
      print('Order Data: ${_createOrder.toJson()}');
      
      String token = model.token ?? '';
      if (token.isEmpty) {
        print('ERROR: No token available for order creation');
        return;
      }
      
      bool orderCreated = await apiService.createOrder(_createOrder, token);
      if (orderCreated) {
        _isorderCreated = true;
        await dbHelper.cartdelete();
        print('✅ Order created successfully and cart cleared');
        
        // Call notifyListeners IMMEDIATELY to show success screen
        notifyListeners();
        
        // Refresh orders list in the background (don't wait for it)
        print('🔄 Refreshing orders list after order creation...');
        fetchAllOrdersAllStatuses().then((_) {
          print('✅ Orders list refreshed - new order should now appear in orders tab');
        }).catchError((e) {
          print('⚠️ Error refreshing orders: $e');
        });
      } else {
        print('❌ Failed to create order - validation error from backend');
        _isorderCreated = false;
        notifyListeners();
      }
    } catch (e) {
      print('ERROR in ordercreate: $e');
      _isorderCreated = false;
      notifyListeners();
    }
  }

  void walletpayment() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      if (_address.shipping == null) {
        _address.shipping = Shipping();
      }
      
      if (_address.productList == null) {
        _address.productList = [];
      }
      
      _cartItems.forEach((v) {
        if (!_address.productList!.any((p) => p.productId == v.productId)) {
          _address.productList!.add(new ProductList(
            productId: v.productId,
            productCode: v.productCode,
            productName: v.productName,
            numOfItems: v.numOfItems.toString(),
            priceId: v.priceId,
            price: v.price,
            marketPrice: v.marketPrice,
            priceMinQuantity: v.priceMinQuantity,
            totalPrice: v.totalPrice.toString(),
            brandname: v.brandname,
          ));
        }
      });
      
      // Get address from the selected address order
      final selectedAddress = creatingaddressOrder.shipping;
      _address.shipping?.address1 = (selectedAddress?.address1 ?? '').isEmpty ? 'N/A' : selectedAddress?.address1;
      _address.shipping?.city = (selectedAddress?.city ?? '').isEmpty ? 'N/A' : selectedAddress?.city;
      _address.shipping?.state = (selectedAddress?.state ?? '').isEmpty ? 'N/A' : selectedAddress?.state;
      _address.shipping?.postcode = (selectedAddress?.postcode ?? '').isEmpty ? '0' : selectedAddress?.postcode;
      _address.shipping?.address2 = selectedAddress?.address2 ?? '';
      _address.shipping?.phone = model.mobileNumber.toString();
      
      _address.totalAmount = creatingtimeOrder.totalAmount;
      _address.deliveryCharges = creatingtimeOrder.deliveryCharges ?? 0;
      _address.customerId = model.mobileNumber.toString();
      _address.timeSlot = creatingtimeOrder.timeSlot;
      _address.walletamt = creatingtimeOrder.walletamt ?? 0.0;
      _address.razorpayamt = 0.0;
      _address.paymentMethod = "Wallet";
      _address.paymentMethodTitle = "Wallet";
      _address.transactionId = "Totally_Paid_through_Wallet";
      _address.setPaid = true;
      _address.status = "Order Placed Successfully";
      
      print('Wallet Payment Order: ${_address.toJson()}');

      String token = model.token ?? '';
      if (token.isEmpty) {
        print('ERROR: No token available for wallet payment');
        return;
      }
      
      bool orderCreated = await apiService.createOrder(_address, token);
      if (orderCreated) {
        _isorderCreated = true;
        double oldamt = prefs.getDouble("Walletamt") ?? 0.0;
        prefs.setDouble("Walletamt", oldamt - (creatingtimeOrder.walletamt ?? 0.0));
        await dbHelper.cartdelete();
        print('Wallet payment order created successfully');
        notifyListeners();
      } else {
        print('Failed to create wallet payment order');
        _isorderCreated = false;
        notifyListeners();
      }
    } catch (e) {
      print('ERROR in walletpayment: $e');
      _isorderCreated = false;
      notifyListeners();
    }
  }

  void getVendorBankDetails() async {
    try {
      final allRows = await dbHelper.queryuserRows();
      if (allRows.isEmpty) {
        print('No user data found in database');
        vendorBankDetails = VendorAccountdetails();
        notifyListeners();
        return;
      }
      allRows.forEach((row) {
            model = UserdatafromDB(
              row["id"],
              row["name"],
              row["address1"],
              row["address2"],
              row["state"],
              row["city"],
              row["pinCode"],
              row["mobileNumber"],
              row["token"],
              row["walletamt"],
            );
            list.add(model);
          });
      
      // Validate user data before making API call
      if (model.mobileNumber == null || model.mobileNumber!.isEmpty) {
        print('Error: Mobile number is empty. User not logged in properly');
        vendorBankDetails = VendorAccountdetails();
        notifyListeners();
        return;
      }
      
      final value = await apiService.getVendorBankDetails(model.mobileNumber ?? '', model.token ?? '');
      vendorBankDetails = value ?? VendorAccountdetails();
      notifyListeners();
    } catch (e) {
      print('Error fetching vendor bank details: $e');
      vendorBankDetails = VendorAccountdetails();
      notifyListeners();
    }
  }

  /// Fetch PENDING orders for entire PINCODE (all users)
  /// NOT just the logged-in user's orders
  Future<void> fetchPendingOrders() async {
    try {
      final allRows = await dbHelper.queryuserRows();
      if (allRows.isEmpty) {
        print('❌ No user data found in database');
        _ordersByPincode = [];
        _filteredOrdersByStatus = [];
        notifyListeners();
        return;
      }

      allRows.forEach((row) {
        model = UserdatafromDB(
          row["id"],
          row["name"],
          row["address1"],
          row["address2"],
          row["state"],
          row["city"],
          row["pinCode"],
          row["mobileNumber"],
          row["token"],
          row["walletamt"],
        );
        if (!list.any((u) => u.mobileNumber == model.mobileNumber)) {
          list.add(model);
        }
      });

      String token = model.token ?? '';
      String userPincode = model.pinCode ?? '';
      
      if (token.isEmpty) {
        print('❌ Error: Token is empty. User not logged in properly');
        _ordersByPincode = [];
        _filteredOrdersByStatus = [];
        notifyListeners();
        return;
      }

      print('\n🔍 Fetching ALL PENDING ORDERS for PINCODE: $userPincode');
      print('   (This will show all pending orders in the pincode, not just your orders)');
      
      List<Myorders> orderList = [];

      // Try to fetch by pincode first
      if (userPincode.isNotEmpty) {
        print('📍 Attempting to fetch pending orders by pincode: $userPincode');
        orderList = await apiService.getAllPendingOrdersByPincode(
          token: token,
          userPincode: userPincode,
        );

        if (orderList.isNotEmpty) {
          print('✅ Got ${orderList.length} orders using pincode filter');
        } else {
          print('⚠️ Pincode filter returned 0 orders, trying without filter...');
          // Fallback: fetch all pending orders without pincode filter
          orderList = await apiService.getAllPendingOrdersNoFilter(
            token: token,
          );
        }
      } else {
        print('❌ Pincode is empty, fetching all pending orders without pincode filter');
        orderList = await apiService.getAllPendingOrdersNoFilter(
          token: token,
        );
      }

      if (orderList.isNotEmpty) {
        _ordersByPincode = [];
        _ordersByPincode.addAll(orderList);
        _filteredOrdersByStatus = [];
        _filteredOrdersByStatus.addAll(orderList);
        _selectedStatusFilter = 'Pending';
        
        print('\n✅ Successfully fetched ${orderList.length} PENDING ORDERS');
        print('📊 Orders in pincode $userPincode:');
        orderList.forEach((order) {
          print('  - Order #${order.orderNumber}: ₹${order.orderFullPrice} | Mobile: ${order.orderUserId} | Date: ${order.orderDate}');
        });
      } else {
        print('⚠️ No pending orders found for pincode: $userPincode');
        _ordersByPincode = [];
        _filteredOrdersByStatus = [];
        _selectedStatusFilter = 'Pending';
      }
      notifyListeners();
    } catch (e) {
      print('❌ Error fetching pending orders: $e');
      _ordersByPincode = [];
      _filteredOrdersByStatus = [];
      notifyListeners();
    }
  }

  /// Fetch ALL orders (all statuses) using proven working endpoint
  Future<void> fetchAllOrdersAllStatuses() async {
    try {
      final allRows = await dbHelper.queryuserRows();
      if (allRows.isEmpty) {
        print('❌ No user data found in database');
        _ordersByPincode = [];
        _filteredOrdersByStatus = [];
        notifyListeners();
        return;
      }

      allRows.forEach((row) {
        model = UserdatafromDB(
          row["id"],
          row["name"],
          row["address1"],
          row["address2"],
          row["state"],
          row["city"],
          row["pinCode"],
          row["mobileNumber"],
          row["token"],
          row["walletamt"],
        );
        if (!list.any((u) => u.mobileNumber == model.mobileNumber)) {
          list.add(model);
        }
      });

      String token = model.token ?? '';
      String mobileNumber = model.mobileNumber ?? '';
      
      if (token.isEmpty || mobileNumber.isEmpty) {
        print('❌ Error: Token or Mobile number is empty. User not logged in properly');
        _ordersByPincode = [];
        _filteredOrdersByStatus = [];
        notifyListeners();
        return;
      }

      print('\n🔍 Fetching ALL ORDERS for user: $mobileNumber');
      
      // Use NEW method that uses proven working endpoint
      List<Myorders> orderList = await apiService.getAllOrdersAllStatuses(
        token: token,
        mobileNumber: mobileNumber,
      );

      if (orderList.isNotEmpty) {
        _ordersByPincode = [];
        _ordersByPincode.addAll(orderList);
        _filteredOrdersByStatus = [];
        _filteredOrdersByStatus.addAll(orderList);
        _selectedStatusFilter = '';
        
        print('✅ Successfully fetched ${orderList.length} TOTAL ORDERS');
        print('Breakdown:');
        print('  - Pending (P): ${orderList.where((o) => o.orderStatus == 'P').length}');
        print('  - Delivery (D): ${orderList.where((o) => o.orderStatus == 'D').length}');
        print('  - Cancelled (C): ${orderList.where((o) => o.orderStatus == 'C').length}');
      } else {
        print('⚠️ No orders found for user: $mobileNumber');
        _ordersByPincode = [];
        _filteredOrdersByStatus = [];
        _selectedStatusFilter = '';
      }
      notifyListeners();
    } catch (e) {
      print('❌ Error fetching all orders: $e');
      _ordersByPincode = [];
      _filteredOrdersByStatus = [];
      notifyListeners();
    }
  }

  /// Fetch orders by pincode only
  /// This uses proven working endpoint
  Future<void> fetchOrdersByPincodeWorking({required String pincode}) async {
    try {
      final allRows = await dbHelper.queryuserRows();
      if (allRows.isEmpty) {
        print('No user data found in database');
        _ordersByPincode = [];
        _filteredOrdersByStatus = [];
        notifyListeners();
        return;
      }

      allRows.forEach((row) {
        model = UserdatafromDB(
          row["id"],
          row["name"],
          row["address1"],
          row["address2"],
          row["state"],
          row["city"],
          row["pinCode"],
          row["mobileNumber"],
          row["token"],
          row["walletamt"],
        );
        if (!list.any((u) => u.mobileNumber == model.mobileNumber)) {
          list.add(model);
        }
      });

      String token = model.token ?? '';
      String mobileNumber = model.mobileNumber ?? '';
      
      if (token.isEmpty || mobileNumber.isEmpty) {
        print('Error: Token or Mobile number is empty. User not logged in properly');
        _ordersByPincode = [];
        _filteredOrdersByStatus = [];
        notifyListeners();
        return;
      }

      print('DEBUG: Fetching ALL orders for pincode: $pincode');
      print('DEBUG: Mobile number: $mobileNumber');
      
      // Fetch orders for ALL statuses (P, D, C combined)
      List<Myorders> orderList = await apiService.getOrdersByPincode(
        pincode: pincode,
        token: token,
        mobileNumber: mobileNumber,
      );

      if (orderList.isNotEmpty) {
        _ordersByPincode = [];
        _ordersByPincode.addAll(orderList);
        _filteredOrdersByStatus = [];
        _filteredOrdersByStatus.addAll(orderList);
        _selectedStatusFilter = '';
        
        print('DEBUG: Successfully fetched ${orderList.length} TOTAL orders for pincode $pincode');
        print('DEBUG: Breakdown by status:');
        print('  - Pending (P): ${orderList.where((o) => o.orderStatus == 'P').length}');
        print('  - Delivery (D): ${orderList.where((o) => o.orderStatus == 'D').length}');
        print('  - Cancel (C): ${orderList.where((o) => o.orderStatus == 'C').length}');
      } else {
        print('No orders found for pincode $pincode');
        _ordersByPincode = [];
        _filteredOrdersByStatus = [];
        _selectedStatusFilter = '';
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching orders by pincode: $e');
      _ordersByPincode = [];
      _filteredOrdersByStatus = [];
      notifyListeners();
    }
  }

  /// Filter orders by status (Pending, Delivery, Cancel)
  /// Status values: "P" = Pending, "D" = Delivery, "C" = Cancel
  /// Shows current user's all orders + other users' pending/delivery orders only
  void filterOrdersByStatus({required String status}) {
    try {
      print('DEBUG: Filtering orders by status: $status');
      print('DEBUG: Current user mobile: $mobNum');
      
      if (_ordersByPincode.isEmpty) {
        print('No orders available to filter');
        _filteredOrdersByStatus = [];
        _selectedStatusFilter = status;
        notifyListeners();
        return;
      }

      // Map display status to API status codes
      String statusCode = _getStatusCode(status);
      
      _filteredOrdersByStatus = _ordersByPincode.where((order) {
        final orderStatus = order.orderStatus?.toUpperCase() ?? '';
        final isCurrentUserOrder = order.orderUserId == mobNum;
        
        // Current user: show all statuses with matching status
        if (isCurrentUserOrder) {
          return orderStatus == statusCode;
        }
        
        // Other users: only show P (Pending) and D (Delivery), not C (Cancel)
        // AND only if the status filter is P or D (not C)
        if (statusCode == 'C') {
          // Don't show cancelled orders from other users
          return false;
        }
        
        return orderStatus == statusCode;
      }).toList();

      _selectedStatusFilter = status;
      print('Filtered ${_filteredOrdersByStatus.length} orders with status $status (code: $statusCode)');
      
      _filteredOrdersByStatus.forEach((order) {
        final isCurrentUser = order.orderUserId == mobNum ? 'YOUR' : 'OTHER';
        print('  - [$isCurrentUser] Order #${order.orderNumber}: ${order.orderFullPrice} (Status: ${order.orderStatus}) (User: ${order.orderUserId})');
      });

      notifyListeners();
    } catch (e) {
      print('Error filtering orders: $e');
      _filteredOrdersByStatus = [];
      notifyListeners();
    }
  }

  /// Get API status code from display status
  String _getStatusCode(String displayStatus) {
    switch (displayStatus.toLowerCase()) {
      case 'pending':
        return 'P';
      case 'delivery':
        return 'D';
      case 'delivered':
        return 'D';
      case 'cancel':
        return 'C';
      case 'cancelled':
        return 'C';
      default:
        return '';
    }
  }

  /// Clear all orders data
  void clearOrdersData() {
    _ordersByPincode = [];
    _filteredOrdersByStatus = [];
    _selectedStatusFilter = '';
    notifyListeners();
  }

  /// DEPRECATED: Use fetchPendingOrders() or fetchAllOrdersAllStatuses() instead
  /// Wrapper method for backward compatibility
  Future<void> fetchOrdersByPincode({required String pincode}) async {
    print('⚠️ DEPRECATED: fetchOrdersByPincode() called. Using fetchAllOrdersAllStatuses() instead');
    await fetchAllOrdersAllStatuses();
  }

  /// NEW: Fetch ALL orders from ALL PINCODES (without pincode filter)
  Future<void> fetchAllOrdersAllPincodes() async {
    try {
      final allRows = await dbHelper.queryuserRows();
      if (allRows.isEmpty) {
        print('No user data found in database');
        _ordersByPincode = [];
        _filteredOrdersByStatus = [];
        notifyListeners();
        return;
      }

      allRows.forEach((row) {
        model = UserdatafromDB(
          row["id"],
          row["name"],
          row["address1"],
          row["address2"],
          row["state"],
          row["city"],
          row["pinCode"],
          row["mobileNumber"],
          row["token"],
          row["walletamt"],
        );
        if (!list.any((u) => u.mobileNumber == model.mobileNumber)) {
          list.add(model);
        }
      });

      String token = model.token ?? '';
      String mobileNumber = model.mobileNumber ?? '';
      
      if (token.isEmpty || mobileNumber.isEmpty) {
        print('Error: Token or Mobile number is empty. User not logged in properly');
        _ordersByPincode = [];
        _filteredOrdersByStatus = [];
        notifyListeners();
        return;
      }

      print('DEBUG: Fetching ALL orders from ALL PINCODES');
      print('DEBUG: Mobile number: $mobileNumber');
      
      // Fetch ALL orders from all pincodes
      List<Myorders> orderList = await apiService.getAllOrdersAllPincodes(
        token: token,
        mobileNumber: mobileNumber,
      );

      if (orderList.isNotEmpty) {
        _ordersByPincode = [];
        _ordersByPincode.addAll(orderList);
        _filteredOrdersByStatus = [];
        _filteredOrdersByStatus.addAll(orderList);
        _selectedStatusFilter = '';
        
        print('DEBUG: Successfully fetched ${orderList.length} TOTAL orders from ALL PINCODES');
        print('DEBUG: Breakdown by status:');
        print('  - Pending (P): ${orderList.where((o) => o.orderStatus == 'P').length}');
        print('  - Delivery (D): ${orderList.where((o) => o.orderStatus == 'D').length}');
        print('  - Cancel (C): ${orderList.where((o) => o.orderStatus == 'C').length}');
      } else {
        print('No orders found from any pincode');
        _ordersByPincode = [];
        _filteredOrdersByStatus = [];
        _selectedStatusFilter = '';
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching all orders: $e');
      _ordersByPincode = [];
      _filteredOrdersByStatus = [];
      notifyListeners();
    }
  }
}
