# Architecture & Data Flow - Status Filtering

## SYSTEM ARCHITECTURE

```
┌─────────────────────────────────────────────────────────────────┐
│                        FLUTTER APP LAYER                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              OrdersByStatusPage.dart                    │   │
│  │  (UI: Search box, status buttons, order list)          │   │
│  │                                                         │   │
│  │  Functions:                                            │   │
│  │  - _fetchOrdersByPincode()                             │   │
│  │  - _onStatusFilterChanged()                            │   │
│  │  - _buildStatusButton()                                │   │
│  │  - _buildOrderCard()                                   │   │
│  └────────┬────────────────────────────────┬──────────────┘   │
│           │                                │                  │
│           │ Calls Provider Methods         │ Listens to       │
│           │                                │ Changes         │
│           │                                │                  │
│  ┌────────▼────────────────────────────────▼──────────────┐   │
│  │              CartProvider (Provider)                   │   │
│  │  (Business Logic: Fetch & Filter)                     │   │
│  │                                                         │   │
│  │  Properties:                                           │   │
│  │  - _ordersByPincode: List<Myorders>                   │   │
│  │  - _filteredOrdersByStatus: List<Myorders>            │   │
│  │  - _selectedStatusFilter: String                       │   │
│  │                                                         │   │
│  │  Methods:                                              │   │
│  │  - fetchOrdersByPincode(pincode)  ─────┐              │   │
│  │  - filterOrdersByStatus(status)    ─┐   │              │   │
│  │  - getters: ordersByPincode()  ─┐  │   │              │   │
│  │           filteredOrdersByStatus() ─┼─┐ │              │   │
│  └──────────────────┬────────────────┼─┼─┼──────────────┘   │
│                     │                │ │ │                  │
│                     │                │ │ │                  │
│           Calls API │    Accesses    │ │ │ Returns          │
│                     │    Data from   │ │ │ Filtered List    │
│           ┌─────────▼─────┐          │ │ │                  │
│           │  api_service  │          │ │ │                  │
│           │               │◄─────────┘ │ │                  │
│           │ getOrdersByPi-│            │ │                  │
│           │   ncode()     │            │ │                  │
│           │               │            │ │                  │
│           │ - Status P    │            │ │                  │
│           │ - Status D    │            │ │                  │
│           │ - Status C    │            │ │                  │
│           └────────┬──────┘            │ │                  │
│                    │                   │ │                  │
└────────────────────┼───────────────────┼─┼──────────────────┘
                     │                   │ │
                     │ HTTP Requests     │ │
                     │ (with Dio)        │ │
                     │                   │ │
┌────────────────────▼───────────────────▼─▼──────────────────┐
│                      BACKEND LAYER                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  API Endpoint:                                             │
│  /samarpanaService/Order/v1/getOrdersByuser                │
│                                                             │
│  Query Parameters:                                         │
│  ?status=P&pincode=560035&userRole=CUSTOMER               │
│                                                             │
│  Returns: JSON Array of Orders                            │
│  [                                                         │
│    {orderId, orderNumber, orderStatus, orderUserId, ...}  │
│  ]                                                         │
│                                                             │
│  Database Query:                                           │
│  SELECT * FROM sabji_order                                │
│  WHERE order_status = 'P'                                 │
│  AND pinCode = '560035'                                   │
│  AND user_role = 'CUSTOMER'                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## DETAILED DATA FLOW

### Flow 1: Initial Pincode Search

```
User Input: "560035" + Click Search
    │
    ▼
OrdersByStatusPage._fetchOrdersByPincode()
    │
    ├─ setState(_isLoading = true)
    │
    ▼
Provider.fetchOrdersByPincode(pincode: "560035")
    │
    ├─ Get user token & mobile from database
    │
    ├─ Print debug info
    │
    ▼ Call API
ApiService.getOrdersByPincode(
    pincode: "560035",
    token: "eyJ...",
    mobileNumber: "9908722443"
)
    │
    ├─ Loop through statuses: ['P', 'D', 'C']
    │
    ├─ For each status:
    │  ├─ Build URL: ".../getOrdersByuser?status=P&pincode=560035&userRole=CUSTOMER"
    │  ├─ Send GET request with Bearer token
    │  ├─ Receive JSON array of orders
    │  └─ Parse to Myorders objects
    │
    ├─ Combine all 3 status results
    │
    ▼ Return to Provider
_ordersByPincode = [
    {orderId: 2686, orderStatus: 'P', orderUserId: '9908722443'},
    {orderId: 2683, orderStatus: 'P', orderUserId: '9908722443'},
    {orderId: 2679, orderStatus: 'P', orderUserId: '9193847590'},
    {orderId: 2680, orderStatus: 'D', orderUserId: '9908722443'},
    {orderId: 2681, orderStatus: 'D', orderUserId: '9193847590'},
    {orderId: 2684, orderStatus: 'C', orderUserId: '9908722443'},
    // ... more orders
]
    │
    ▼
notifyListeners()
    │
    ▼ UI rebuilds
Display Order Count Buttons:
[🔔 Pending: 5] [🚚 Delivery: 2] [❌ Cancelled: 1]
Display 5 pending orders by default
```

---

### Flow 2: Status Filter Button Click

```
User Clicks [🚚 Delivery Button]
    │
    ▼
OrdersByStatusPage._onStatusFilterChanged('delivery')
    │
    ├─ setState(_selectedStatus = 'delivery')
    │
    ▼
Provider.filterOrdersByStatus(status: 'delivery')
    │
    ├─ Map 'delivery' → Status Code 'D'
    │
    ├─ Loop through _ordersByPincode:
    │
    │  For each order:
    │  ├─ if (orderStatus == 'D') → INCLUDE
    │  │  │
    │  │  └─ Can be from any user (both YOUR and OTHER)
    │  │
    │  └─ if (orderStatus != 'D') → EXCLUDE
    │
    ▼
_filteredOrdersByStatus = [
    {orderId: 2680, orderStatus: 'D', orderUserId: '9908722443'},  // YOUR
    {orderId: 2681, orderStatus: 'D', orderUserId: '9193847590'},  // OTHER
]
    │
    ▼
notifyListeners()
    │
    ▼ UI rebuilds
ListView shows only 2 delivery orders
├─ Order 2680 (White BG - Your order)
└─ Order 2681 (Blue BG - Other user, mobile badge: 9193847590)
```

---

### Flow 3: Status Filter for Cancelled

```
User Clicks [❌ Cancelled Button]
    │
    ▼
OrdersByStatusPage._onStatusFilterChanged('cancel')
    │
    ▼
Provider.filterOrdersByStatus(status: 'cancel')
    │
    ├─ Map 'cancel' → Status Code 'C'
    │
    ├─ Loop through _ordersByPincode:
    │
    │  For each order:
    │  ├─ if (orderStatus == 'C' && orderUserId == currentUser) → INCLUDE
    │  │  (This is MY cancelled order, show it)
    │  │
    │  └─ if (orderStatus == 'C' && orderUserId != currentUser) → EXCLUDE
    │     (This is OTHER user's cancelled order, hide it - privacy)
    │
    ▼
_filteredOrdersByStatus = [
    {orderId: 2684, orderStatus: 'C', orderUserId: '9908722443'},  // YOUR ONLY
]
    │
    ▼
notifyListeners()
    │
    ▼ UI rebuilds
ListView shows only 1 cancelled order
├─ Order 2684 (White BG - Your order, NO mobile badge)
```

---

## STATUS FILTERING LOGIC

### Current User (mobNum = "9908722443")

```
When user clicks PENDING:
  Show all where: orderStatus == 'P'
  ├─ Your pending: 9908722443 (white bg)
  ├─ Other pending: 9193847590 (blue bg)
  └─ Total: 5 orders

When user clicks DELIVERY:
  Show all where: orderStatus == 'D'
  ├─ Your delivery: 9908722443 (white bg)
  ├─ Other delivery: 9193847590 (blue bg)
  └─ Total: 2 orders

When user clicks CANCELLED:
  Show only where: orderStatus == 'C' && orderUserId == "9908722443"
  ├─ Your cancelled: 9908722443 (white bg)
  ├─ Other cancelled: HIDDEN (privacy)
  └─ Total: 1 order (yours only)
```

---

## DATA MODEL STRUCTURE

```
Myorders {
  int? orderId              // Unique order ID
  String? orderNumber       // Display number (SUG26041301)
  String? orderStatus       // 'P' | 'D' | 'C' | 'R' | 'RT'
  String? orderUserId       // Mobile number (9908722443)
  double? orderFullPrice    // Amount (₹155.0)
  String? orderDate         // Date (13/04/2026)
  String? timeslot          // Delivery slot
  String? address           // Delivery address
  List<ProductItem>? productList  // Items in order
}
```

---

## PROVIDER PROPERTIES & GETTERS

```dart
class CartProvider extends ChangeNotifier {
  
  // Private Variables
  List<Myorders> _ordersByPincode = [];           // All orders from API
  List<Myorders> _filteredOrdersByStatus = [];    // Filtered by status
  String _selectedStatusFilter = '';              // Current status filter
  String mobNum = '';                             // Current user mobile
  
  // Public Getters
  List<Myorders> get ordersByPincode => _ordersByPincode;
  List<Myorders> get filteredOrdersByStatus => _filteredOrdersByStatus;
  String get selectedStatusFilter => _selectedStatusFilter;
}
```

---

## API RESPONSE FLOW

```
Frontend Request:
GET http://43.205.203.15:8084/samarpanaService/Order/v1/getOrdersByuser
    ?status=P
    &pincode=560035
    &userRole=CUSTOMER
Header: Authorization: Bearer eyJ...

Backend Processing:
├─ Parse query parameters
├─ Query database
│  SELECT * FROM sabji_order 
│  WHERE order_status = 'P' 
│  AND pin_code = '560035'
│  AND (any user)
├─ Convert results to JSON
└─ Send response

Frontend Response:
HTTP 200 OK
[
  {
    "orderId": 2686,
    "orderNumber": "SUG26041301",
    "orderStatus": "P",
    "orderUserId": "9908722443",
    "orderFullPrice": 155.0,
    "orderDate": "13/04/2026",
    "timeslot": "Thu, 16 Apr 2026 @ 4 PM - 8 PM",
    "address": "sarjapur road,Bangalore,",
    "productList": [...]
  },
  ...
]
```

---

## STATE MANAGEMENT FLOW

```
Initial State:
├─ _ordersByPincode = []
├─ _filteredOrdersByStatus = []
└─ _selectedStatusFilter = ''

After Fetching Pincode:
├─ _ordersByPincode = [8 orders]
├─ _filteredOrdersByStatus = [5 orders]  ← Filtered to "P" by default
└─ _selectedStatusFilter = 'pending'

After Clicking Delivery:
├─ _ordersByPincode = [8 orders]  ← UNCHANGED
├─ _filteredOrdersByStatus = [2 orders]  ← Re-filtered to "D"
└─ _selectedStatusFilter = 'delivery'

After Clicking Cancelled:
├─ _ordersByPincode = [8 orders]  ← UNCHANGED
├─ _filteredOrdersByStatus = [1 order]  ← Filtered to "C" (only yours)
└─ _selectedStatusFilter = 'cancel'
```

---

## CONVERSION MAPPING

```
Display Name  →  Status Code  →  Database Value
─────────────    ────────────    ─────────────
Pending          P              'P'
Delivery         D              'D'
Delivered        D              'D'
Cancel           C              'C'
Cancelled        C              'C'
```

---

## UI RENDERING LOGIC

```
Consumer<CartProvider>(
  builder: (context, provider, child) {
    final allOrders = provider.ordersByPincode;      // All 8 orders
    final filteredOrders = provider.filteredOrdersByStatus;  // 5, 2, or 1
    
    // Show button counts based on ALL orders
    pendingCount = allOrders.where((o) => o.orderStatus == 'P').length;  // 5
    deliveryCount = allOrders.where((o) => o.orderStatus == 'D').length; // 2
    cancelCount = allOrders.where((o) => o.orderStatus == 'C').length;   // 1
    
    // Show list based on FILTERED orders only
    return ListView.builder(
      itemCount: filteredOrders.length,  // 5, 2, or 1 depending on filter
      itemBuilder: (context, index) {
        return OrderCard(filteredOrders[index]);
      }
    );
  }
)
```

---

## COMPLETE REQUEST/RESPONSE EXAMPLE

### Request 1: Fetch Pending Orders (P)

```http
GET /samarpanaService/Order/v1/getOrdersByuser?status=P&pincode=560035&userRole=CUSTOMER HTTP/1.1
Host: 43.205.203.15:8084
Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI5OTA4NzIyNDQzIiwiZXhwIjoxNzgwNTY0OTA4LCJpYXQiOjE3NzY2NzY5MDh9...
Content-Type: application/json
```

### Response 1:

```json
[
  {
    "orderId": 2686,
    "orderNumber": "SUG26041301",
    "orderStatus": "P",
    "orderUserId": "9908722443",
    "orderFullPrice": 155.0,
    "orderDate": "13/04/2026",
    "timeslot": "Thu, 16 Apr 2026 @ 4 PM - 8 PM",
    "address": "sarjapur road,Bangalore,",
    "productList": [
      {
        "productId": 270,
        "productName": "Sweet Lime (Mosambi)",
        "price": 50.00,
        "numOfItems": "500 gm"
      }
    ]
  },
  {
    "orderId": 2679,
    "orderNumber": "SUG26041401",
    "orderStatus": "P",
    "orderUserId": "9193847590",
    "orderFullPrice": 200.0,
    ...
  }
]
```

---

## SUMMARY

| Component | Purpose | Input | Output |
|-----------|---------|-------|--------|
| **UI Page** | Display search box, buttons, orders | User actions | Updated screen |
| **Provider Fetch** | Get all orders from API | Pincode | 8 orders in memory |
| **Provider Filter** | Filter by status | Status name | 5/2/1 orders |
| **API Service** | Make HTTP requests | Status + Pincode | JSON response |
| **Backend API** | Query database | Query params | Order list |

All components work together seamlessly to provide real-time status filtering! ✅

