# Orders by Status Implementation Guide

## Overview
This implementation allows users to view orders by pincode and filter them by status (Pending, Delivery, Cancelled). The solution consists of three main components:

1. **API Service Method** - Fetches orders from backend
2. **Provider Updates** - Manages state and filtering logic
3. **UI Page** - Displays and filters orders

---

## Files Modified/Created

### 1. `lib/api_service.dart` ✅ MODIFIED
**Added Method**: `getOrdersByPincode()`

```dart
Future<List<Myorders>> getOrdersByPincode({
  required String pincode,
  required String token,
}) async
```

**Endpoint**: `Order/v1/getOrdersByPincode?pincode=560035`

**Features**:
- Validates token before API call
- Handles network errors gracefully
- Returns List<Myorders> with complete order details
- Includes detailed debug logging

---

### 2. `lib/components/cart_provider.dart` ✅ MODIFIED
**Added Properties**:
```dart
List<Myorders> _ordersByPincode = [];           // All orders for pincode
List<Myorders> _filteredOrdersByStatus = [];    // Filtered orders
String _selectedStatusFilter = '';              // Current filter
```

**Added Getter Methods**:
```dart
List<Myorders> get ordersByPincode => _ordersByPincode;
List<Myorders> get filteredOrdersByStatus => _filteredOrdersByStatus;
String get selectedStatusFilter => _selectedStatusFilter;
```

**Added Main Methods**:

#### `fetchOrdersByPincode({required String pincode})`
- Fetches all orders for a specific pincode from API
- Stores in `_ordersByPincode`
- Initializes filters with all orders
- Handles loading and error states

#### `filterOrdersByStatus({required String status})`
- Filters orders by status code
- Status values: `"pending"`, `"delivery"`, `"cancel"`
- Updates `_filteredOrdersByStatus`
- Internally maps to API codes: P, D, C

#### `clearOrdersData()`
- Clears all cached order data
- Call when exiting the page

---

### 3. `lib/pages/OrdersByStatusPage.dart` ✅ CREATED
**New UI Page** - Complete order filtering interface

**Features**:
- ✅ Pincode input with validation (digits only, max 6)
- ✅ Search button with loading state
- ✅ Three status filter buttons (Pending, Delivery, Cancelled)
- ✅ Order list with:
  - Order number and date
  - Status indicator with color coding
  - Total price
  - "View Details" button
- ✅ Empty state messages
- ✅ Error handling with SnackBars
- ✅ Integration with OrderDetails page

**Status Color Coding**:
- 🟠 Pending (Orange)
- 🟢 Delivery (Green)
- 🔴 Cancelled (Red)

---

## How to Integrate

### Option 1: Add Navigation Menu Item
In your drawer or main menu:

```dart
ListTile(
  leading: Icon(Icons.shopping_cart),
  title: Text('Orders by Status'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrdersByStatusPage(),
      ),
    );
  },
),
```

### Option 2: Add Tab in Dashboard
```dart
TabView(
  children: [
    YourExistingOrdersPage(),
    OrdersByStatusPage(),  // Add as second tab
  ],
)
```

### Option 3: Direct Navigation
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => OrdersByStatusPage(),
  ),
);
```

---

## Usage Flow

### User Journey:
1. User navigates to "Orders by Status" page
2. User enters pincode (e.g., `560035`)
3. User clicks "Search" button
4. App fetches all orders for that pincode
5. User sees list of orders filtered by default status (Pending)
6. User can click status buttons to switch between:
   - **Pending** - Orders waiting to be processed
   - **Delivery** - Orders in transit
   - **Cancelled** - Orders cancelled by user/admin
7. User taps "View Details" on any order to see full details

---

## Status Codes Reference

| Display Status | API Code | Icon | Color |
|---|---|---|---|
| Pending | P | ⏱ | Orange |
| Delivery | D | 🚚 | Green |
| Cancelled | C | ✗ | Red |

---

## State Management

### How Provider Updates Work:
```dart
// User enters pincode and searches
orderProvider.fetchOrdersByPincode(pincode: "560035");
// ↓ API call fetches all orders
// ↓ Stored in _ordersByPincode
// ↓ _filteredOrdersByStatus populated with all orders

// User clicks "Delivery" button
orderProvider.filterOrdersByStatus(status: "delivery");
// ↓ Filters _ordersByPincode where orderStatus == "D"
// ↓ Updates _filteredOrdersByStatus
// ↓ notifyListeners() triggers UI rebuild
```

---

## Testing Checklist

- [ ] Navigate to Orders by Status page
- [ ] Enter valid pincode (e.g., 560035)
- [ ] Click Search button
- [ ] Verify orders load successfully
- [ ] Click "Pending" tab - should show pending orders
- [ ] Click "Delivery" tab - should show delivery orders
- [ ] Click "Cancelled" tab - should show cancelled orders
- [ ] Click "View Details" - should open order details page
- [ ] Go back and clear data properly
- [ ] Test with empty pincode - should show validation error
- [ ] Test with invalid pincode - should handle gracefully

---

## Error Handling

### Handled Scenarios:
✅ Empty pincode input - Shows SnackBar message
✅ Network errors - Displays error message
✅ No orders found - Shows "No X orders found" message
✅ Invalid pincode - Handled by backend API
✅ Empty token - Validation check before API call
✅ Null safety - All nullable fields handled

---

## API Response Format

Expected API response structure:
```json
[
  {
    "orderId": 1,
    "orderNumber": "ORD001",
    "orderStatus": "P",
    "orderFullPrice": 299.99,
    "orderDate": "2024-04-22",
    "address": "123 Main St",
    "timeslot": "9 AM - 10 AM",
    "productList": [...]
  }
]
```

---

## Customization Options

### Change Status Codes
Edit in `OrdersByStatusPage.dart` `_getStatusCode()` method:
```dart
String _getStatusCode(String displayStatus) {
  switch (displayStatus.toLowerCase()) {
    case 'pending': return 'P';
    case 'delivery': return 'D';
    case 'cancel': return 'C';
    default: return '';
  }
}
```

### Change Colors
Update color values in `_buildStatusButton()` and `_buildOrderCard()`:
```dart
Color.fromRGBO(123, 212, 165, 1)  // Green theme
```

### Change Filter Button Layout
Modify `_buildStatusButton()` widget to add more/fewer buttons or change appearance.

---

## Troubleshooting

### Orders Not Showing?
- [ ] Verify pincode is correct
- [ ] Check API endpoint is accessible
- [ ] Ensure user is logged in (token is valid)
- [ ] Check backend logs for errors

### Status Filter Not Working?
- [ ] Verify status codes match API response (P, D, C)
- [ ] Check provider initialization
- [ ] Clear app cache and restart

### Navigation Issues?
- [ ] Verify OrderDetails page path is correct
- [ ] Ensure all imports are properly added
- [ ] Check build method returns correct widget

---

## Dependencies Required

All dependencies should already be in your `pubspec.yaml`:
- ✅ flutter
- ✅ provider
- ✅ dio
- ✅ shared_preferences

No new dependencies needed!

---

## Performance Notes

- Orders are fetched once per pincode search
- Filtering happens in-memory (no additional API calls)
- ListView uses builder pattern for efficient rendering
- Disposal of TextEditingController prevents memory leaks

---

## Future Enhancements

Potential improvements:
- [ ] Add date range filtering
- [ ] Sort orders by date/price
- [ ] Add order search within results
- [ ] Implement pagination for large result sets
- [ ] Add export/print order functionality
- [ ] Implement real-time status updates

---

## Support

For issues or questions:
1. Check error messages in console logs
2. Verify all files are properly saved
3. Run `flutter clean` and rebuild
4. Check API endpoint configuration in `config.dart`

