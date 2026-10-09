# Orders by Status - Architecture & Flow Diagram

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     SAMARPANA APP                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │         OrdersByStatusPage (UI Layer)                    │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │ • Pincode Input Field                              │  │  │
│  │  │ • Search Button                                    │  │  │
│  │  │ • Status Filter Buttons (P|D|C)                    │  │  │
│  │  │ • Order List with Details                          │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └────────────────┬─────────────────────────────────────────┘  │
│                   │ Uses                                        │
│  ┌────────────────▼──────────────────────────────────────────┐  │
│  │  CartProvider (State Management)                          │  │
│  │  ┌──────────────────────────────────────────────────────┐ │  │
│  │  │ Properties:                                          │ │  │
│  │  │  • _ordersByPincode: List<Myorders>                │ │  │
│  │  │  • _filteredOrdersByStatus: List<Myorders>         │ │  │
│  │  │  • _selectedStatusFilter: String                   │ │  │
│  │  │                                                      │ │  │
│  │  │ Methods:                                             │ │  │
│  │  │  • fetchOrdersByPincode(pincode)                   │ │  │
│  │  │  • filterOrdersByStatus(status)                    │ │  │
│  │  │  • clearOrdersData()                               │ │  │
│  │  └──────────────────────────────────────────────────────┘ │  │
│  └────────────────┬─────────────────────────────────────────┘  │
│                   │ Calls                                       │
│  ┌────────────────▼──────────────────────────────────────────┐  │
│  │  APIService (API Layer)                                   │  │
│  │  ┌──────────────────────────────────────────────────────┐ │  │
│  │  │ Method: getOrdersByPincode()                         │ │  │
│  │  │  URL: /Order/v1/getOrdersByPincode?pincode=560035   │ │  │
│  │  │  Returns: List<Myorders>                             │ │  │
│  │  └──────────────────────────────────────────────────────┘ │  │
│  └────────────────┬─────────────────────────────────────────┘  │
│                   │ HTTP GET                                    │
│  └────────────────▼─────────────────────────────────────────┐  │
│                BACKEND API                                   │  │
│           (Samarpana Service)                                │  │
│  ┌──────────────────────────────────────────────────────────┐ │  │
│  │ Endpoint: /Order/v1/getOrdersByPincode                  │ │  │
│  │ Database: Fetches from sabji_order table                │ │  │
│  │ Returns: JSON array of orders with status              │ │  │
│  └──────────────────────────────────────────────────────────┘ │  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Data Flow Diagram

```
USER ACTIONS                    STATE UPDATES                    UI RENDERING
─────────────────────────────────────────────────────────────────────────────

User enters pincode
    │                                                           
    ▼                                                           
[Click Search] ──────▶ _pincodeController ──────▶ _fetchOrdersByPincode()
                         has text                        │
                                                         │
                      API Call                           ▼
                      ──────────▶ Backend API ──────▶ Returns Orders Array
                                                         │
                                                         ▼
                      Store in                    _ordersByPincode = orders
                      Provider
                                                         ▼
                                                  _filteredOrdersByStatus 
                                                  = _ordersByPincode
                                                         │
                                                         ▼
                                                  notifyListeners()
                                                         │
                                                         ▼
                                              ┌──────────────────────┐
                                              │ UI Rebuilds          │
                                              │ Shows Order List     │
                                              └──────────────────────┘

User clicks Status Tab
    │                                                           
    ▼                                                           
[Click "Pending"] ────▶ _selectedStatusFilter = "pending"
                                │
                                ▼
                        filterOrdersByStatus("pending")
                                │
                                ├──▶ Get status code: "P"
                                │
                                ├──▶ Filter _ordersByPincode
                                │    where orderStatus == "P"
                                │
                                ├──▶ Store in _filteredOrdersByStatus
                                │
                                ▼
                        notifyListeners()
                                │
                                ▼
                        ┌──────────────────────┐
                        │ UI Rebuilds          │
                        │ Shows Pending Orders │
                        └──────────────────────┘

User clicks View Details
    │                                                           
    ▼                                                           
[Click Button] ───────▶ Navigate to OrderDetails page
                       Pass: Myorders object
                              Status string
```

---

## Status Filtering Logic

```
ALL ORDERS (from API)
    │
    ├─ Order #2565 → Status: "P" (Pending)
    ├─ Order #2566 → Status: "D" (Delivery)
    ├─ Order #2567 → Status: "C" (Cancelled)
    ├─ Order #2568 → Status: "P" (Pending)
    ├─ Order #2569 → Status: "D" (Delivery)
    └─ Order #2570 → Status: "P" (Pending)

        │
        ▼

User selects: "Pending" filter
        │
        ▼

FILTERED RESULTS
    │
    ├─ Order #2565 → Status: "P" ✓ SHOW
    ├─ Order #2566 → Status: "D" ✗ HIDE
    ├─ Order #2567 → Status: "C" ✗ HIDE
    ├─ Order #2568 → Status: "P" ✓ SHOW
    ├─ Order #2569 → Status: "D" ✗ HIDE
    └─ Order #2570 → Status: "P" ✓ SHOW

        │
        ▼

DISPLAY TO USER
    ├─ Order #2565 (Pending) - ₹265.00
    ├─ Order #2568 (Pending) - ₹299.99
    └─ Order #2570 (Pending) - ₹180.50
```

---

## Status Code Mapping

```
┌──────────────────────────────────────────────────────┐
│          STATUS CODES & DISPLAY                      │
├──────────────────────────────────────────────────────┤
│                                                      │
│  PENDING                                             │
│  ├─ API Code: "P"                                    │
│  ├─ Display: "Pending"                              │
│  ├─ Icon: ⏱                                          │
│  ├─ Color: 🟠 Orange (RGB: 255, 165, 0)            │
│  └─ Meaning: Waiting to be processed                │
│                                                      │
│  DELIVERY                                            │
│  ├─ API Code: "D"                                    │
│  ├─ Display: "In Delivery" or "Delivered"           │
│  ├─ Icon: 🚚                                         │
│  ├─ Color: 🟢 Green (RGB: 76, 175, 80)             │
│  └─ Meaning: Order in transit or delivered          │
│                                                      │
│  CANCELLED                                           │
│  ├─ API Code: "C"                                    │
│  ├─ Display: "Cancelled"                            │
│  ├─ Icon: ✗                                          │
│  ├─ Color: 🔴 Red (RGB: 244, 67, 54)               │
│  └─ Meaning: Order has been cancelled               │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Provider State Updates

```
Initial State:
{
  _ordersByPincode: []
  _filteredOrdersByStatus: []
  _selectedStatusFilter: ""
}

After fetchOrdersByPincode("560035"):
{
  _ordersByPincode: [Order1, Order2, Order3, ...]  ◄── API response stored
  _filteredOrdersByStatus: [Order1, Order2, Order3, ...]  ◄── All orders shown
  _selectedStatusFilter: ""
}

After filterOrdersByStatus("pending"):
{
  _ordersByPincode: [Order1, Order2, Order3, ...]  ◄── Unchanged
  _filteredOrdersByStatus: [Order1, Order3, ...]  ◄── Only "P" orders
  _selectedStatusFilter: "pending"  ◄── Track current filter
}

After filterOrdersByStatus("delivery"):
{
  _ordersByPincode: [Order1, Order2, Order3, ...]  ◄── Unchanged
  _filteredOrdersByStatus: [Order2, ...]  ◄── Only "D" orders
  _selectedStatusFilter: "delivery"  ◄── Filter changed
}

After clearOrdersData():
{
  _ordersByPincode: []  ◄── Cleared
  _filteredOrdersByStatus: []  ◄── Cleared
  _selectedStatusFilter: ""  ◄── Reset
}
```

---

## User Interface Layout

```
╔══════════════════════════════════════════════════════════╗
║  ◀ Orders by Status                              🔔 🛒  ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║  Enter Pincode                                           ║
║  ┌────────────────────────────────┬──────────────────┐  ║
║  │ e.g., 560035                   │ 🔍 Search       │  ║
║  └────────────────────────────────┴──────────────────┘  ║
║                                                          ║
║  ┌──────────────────────────────────────────────────┐   ║
║  │  ⏱ PENDING  │  🚚 DELIVERY  │  ✗ CANCELLED       │   ║
║  │             │                │                   │   ║
║  │  [Selected] │  [Inactive]    │  [Inactive]       │   ║
║  └──────────────────────────────────────────────────┘   ║
║                                                          ║
║  ORDERS LIST:                                            ║
║  ┌──────────────────────────────────────────────────┐   ║
║  │ ┌─────────────────────────────────────────────┐  │   ║
║  │ │ ⏱  Order #2565                   ₹265.00   │  │   ║
║  │ │     21/05/2022                              │  │   ║
║  │ │     Status: Pending (Orange)                │  │   ║
║  │ │                      View Details ▶         │  │   ║
║  │ └─────────────────────────────────────────────┘  │   ║
║  │                                                  │   ║
║  │ ┌─────────────────────────────────────────────┐  │   ║
║  │ │ ⏱  Order #2568                   ₹299.99   │  │   ║
║  │ │     22/05/2022                              │  │   ║
║  │ │     Status: Pending (Orange)                │  │   ║
║  │ │                      View Details ▶         │  │   ║
║  │ └─────────────────────────────────────────────┘  │   ║
║  │                                                  │   ║
║  │ ┌─────────────────────────────────────────────┐  │   ║
║  │ │ ⏱  Order #2570                   ₹180.50   │  │   ║
║  │ │     23/05/2022                              │  │   ║
║  │ │     Status: Pending (Orange)                │  │   ║
║  │ │                      View Details ▶         │  │   ║
║  │ └─────────────────────────────────────────────┘  │   ║
║  └──────────────────────────────────────────────────┘   ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
```

---

## Integration Points

```
Your App Navigation Structure:

Home Page / Drawer
    │
    ├─ My Orders (existing)
    │   └─ OrderStatus page
    │
    ├─ [NEW] Filter Orders by Status  ◄───── NEW FEATURE
    │   └─ OrdersByStatusPage
    │       ├─ Input pincode
    │       ├─ Select status
    │       └─ View details
    │
    ├─ Wallet
    ├─ Settings
    └─ Logout
```

---

## Method Call Sequence

```
User Action → Method Call → State Change → UI Update

1. User enters pincode & clicks Search:
   _fetchOrdersByPincode()
   ├─ Get user token from DB
   ├─ Call apiService.getOrdersByPincode()
   ├─ Store result in _ordersByPincode
   ├─ Initialize _filteredOrdersByStatus
   └─ Call notifyListeners() ──▶ UI Rebuilds

2. User clicks Status Button:
   filterOrdersByStatus("pending")
   ├─ Map "pending" → "P"
   ├─ Filter _ordersByPincode by status code
   ├─ Store filtered results in _filteredOrdersByStatus
   ├─ Update _selectedStatusFilter
   └─ Call notifyListeners() ──▶ UI Rebuilds

3. User leaves page:
   clearOrdersData()
   ├─ Clear _ordersByPincode
   ├─ Clear _filteredOrdersByStatus
   ├─ Reset _selectedStatusFilter
   └─ Call notifyListeners()
```

---

## Error Handling Flow

```
User Action
    │
    ▼
Input Validation
    ├─ Empty pincode? ──▶ Show SnackBar Error ──▶ Stop
    │
    ▼ (Valid)
API Call
    ├─ No internet? ──▶ Show Error Message ──▶ Stop
    │
    ├─ 401 Unauthorized? ──▶ Token invalid ──▶ Stop
    │
    ├─ 404 Not Found? ──▶ Endpoint issue ──▶ Stop
    │
    ├─ 200 OK ──▶ Parse Response
    │   │
    │   ├─ Parse Error? ──▶ Show Error ──▶ Stop
    │   │
    │   ▼ (Success)
    │   Store & Notify
    │
    ▼
Display Orders
```

This completes your Orders by Status implementation! 🎉
