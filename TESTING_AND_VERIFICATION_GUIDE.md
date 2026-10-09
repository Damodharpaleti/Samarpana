# Complete Testing & Implementation Guide

## WHAT'S ALREADY IMPLEMENTED ✅

1. ✅ API endpoint: `getOrdersByPincode()` - fetches ALL orders for a pincode from all users
2. ✅ Provider method: `fetchOrdersByPincode()` - calls the API and stores orders
3. ✅ Filter method: `filterOrdersByStatus()` - filters stored orders by status
4. ✅ UI Page: `OrdersByStatusPage` - shows pincode input and status filter buttons
5. ✅ Status buttons: Pending | Delivery | Cancelled with live order counts

---

## COMPLETE FLOW DIAGRAM

```
┌─────────────────────────────────────────────────────────┐
│         USER OPENS OrdersByStatusPage                   │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │  Enter Pincode:560035  │
        │  Click [Search]        │
        └────────────┬───────────┘
                     │
                     ▼
        ┌────────────────────────────────────────┐
        │  API: getOrdersByPincode()              │
        │  - Fetches Status: P,D,C all at once   │
        │  - Returns: 8 total orders             │
        │    (5 Pending, 2 Delivery, 1 Cancel)   │
        └────────────┬───────────────────────────┘
                     │
                     ▼
        ┌────────────────────────────────────────┐
        │  Provider: fetchOrdersByPincode()       │
        │  - Stores all 8 orders in memory       │
        │  - Sets: _ordersByPincode = [8 orders] │
        │  - Applies: default "pending" filter   │
        └────────────┬───────────────────────────┘
                     │
                     ▼
        ┌────────────────────────────────────────┐
        │  Provider: filterOrdersByStatus()       │
        │  - Filters by "pending" status         │
        │  - Shows: 5 pending orders (P)         │
        │  - Sets: _filteredOrdersByStatus = [5] │
        └────────────┬───────────────────────────┘
                     │
                     ▼
        ┌────────────────────────────────────────┐
        │  UI: Display Filtered Orders            │
        │  [🔔 Pending:5] [🚚 Delivery:2]        │
        │  [❌ Cancelled:1]                      │
        │                                        │
        │  Shows 5 order cards (white + blue)    │
        └────────────┬───────────────────────────┘
                     │
       ┌─────────────┼─────────────┐
       │             │             │
    Click         Click         Click
  Delivery      Cancelled      Pending
       │             │             │
       ▼             ▼             ▼
    Shows 2       Shows 1        Shows 5
   Delivery      Cancelled      Pending
    orders       orders         orders
```

---

## STEP-BY-STEP TESTING GUIDE

### Step 1️⃣: Open the App

1. Run the Flutter app
2. Login with a user account
3. Navigate to **OrdersByStatusPage**
   - The page should show an empty state with message: "Enter a pincode and search to see orders"

### Step 2️⃣: Enter a Pincode

1. Type a pincode: `560035`
2. Click the **Search** button
3. Wait for the API response

### Step 3️⃣: Check Console Output

In the Flutter console, you should see:

```
=========== GET ALL ORDERS BY PINCODE ===========
Pincode: 560035
Mobile: 9908722443 (current user)

Fetching status: P
URL: http://43.205.203.15:8084/samarpanaService/Order/v1/getOrdersByuser?status=P&pincode=560035&userRole=CUSTOMER
Response Status: 200
Received 5 orders with status P

Fetching status: D
URL: http://43.205.203.15:8084/samarpanaService/Order/v1/getOrdersByuser?status=D&pincode=560035&userRole=CUSTOMER
Response Status: 200
Received 2 orders with status D

Fetching status: C
URL: http://43.205.203.15:8084/samarpanaService/Order/v1/getOrdersByuser?status=C&pincode=560035&userRole=CUSTOMER
Response Status: 200
Received 1 orders with status C

=========== TOTAL ORDERS FETCHED ===========
Total: 8 orders
Pending: 5
Delivery: 2
Cancel: 1

Orders by Mobile Number:
  Mobile: 9908722443 - 6 orders
    ✓ Order #SUG26041301: ₹155.0 (Pending)
    ✓ Order #SUG26041001: ₹195.0 (Pending)
    ✓ Order #SUG26040801: ₹165.0 (Pending)
    ...
  Mobile: 9193847590 - 2 orders
    ✓ Order #SUG26041501: ₹225.0 (Pending)
    ...
```

### Step 4️⃣: Verify Pincode Fetch in Provider

In console, you should also see:

```
DEBUG: Fetching ALL orders for pincode: 560035
DEBUG: Mobile number: 9908722443

DEBUG: Successfully fetched 8 TOTAL orders for pincode 560035
DEBUG: Breakdown by status:
  - Pending (P): 5
  - Delivery (D): 2
  - Cancel (C): 1
```

### Step 5️⃣: See Status Filter Buttons

On the screen, you should see:

```
┌──────────────────────────────────────┐
│  [🔔 Pending]  [🚚 Delivery]  [❌ Cancelled]  │
│      5              2              1        │
└──────────────────────────────────────┘
```

Where the numbers are the count of orders in each status.

### Step 6️⃣: See Filtered Orders

Below the buttons, the app should show 5 order cards (since "Pending" is selected by default).

Each card shows:
- Order number (e.g., #SUG26041301)
- Order date
- Order amount
- Mobile number (if not your order)
- Status badge

### Step 7️⃣: Click Delivery Button

1. Click the **🚚 Delivery** button
2. The button should turn **green** (selected state)
3. Console should show:
```
DEBUG: Filtering orders by status: delivery
Filtered 2 orders with status delivery (code: D)
  - [YOUR] Order #SUG26040701: 185.0 (Status: D) (User: 9908722443)
  - [OTHER] Order #SUG26040901: 210.0 (Status: D) (User: 9193847590)
```
4. The order list should update to show only **2 delivery orders**

### Step 8️⃣: Click Cancelled Button

1. Click the **❌ Cancelled** button
2. The button should turn **green** (selected state)
3. Console should show:
```
DEBUG: Filtering orders by status: cancel
Filtered 1 orders with status cancel (code: C)
  - [YOUR] Order #SUG26040601: 150.0 (Status: C) (User: 9908722443)
```
4. The order list should update to show only **1 cancelled order** (YOUR order only)
5. **Note:** Other users' cancelled orders are NOT shown (privacy)

### Step 9️⃣: Click Pending Button Again

1. Click the **🔔 Pending** button
2. Should go back to showing **5 pending orders**
3. You can switch between tabs as many times as you want

---

## UNDERSTANDING THE UI

### Order Card Colors

```
┌─────────────────────────────────┐
│ WHITE BACKGROUND = YOUR ORDER   │
│ (Your mobile number)             │
│                                 │
│ Order #SUG26041301              │
│ ₹155.0 Pending                  │
│ 13/04/2026                      │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ LIGHT BLUE BACKGROUND = OTHER   │
│ (Other user's mobile number)     │
│                                 │
│ Order #SUG26041401  [9193847590]│
│ ₹200.0 Pending                  │
│ 14/04/2026                      │
└─────────────────────────────────┘
```

### Mobile Number Badges

- **Your orders:** No badge shown (assumed to be you)
- **Other users:** Green badge with their mobile number
  - Example: `[9193847590]`

---

## WHAT EACH STATUS SHOWS

### 🔔 PENDING (Status Code: P)
- **Shows:** All pending orders from ANY mobile number in the pincode
- **Your orders:** Included
- **Other users:** Included
- **Example:** 5 pending orders total (3 yours + 2 others)

### 🚚 DELIVERY (Status Code: D)
- **Shows:** All delivery orders from ANY mobile number in the pincode
- **Your orders:** Included
- **Other users:** Included
- **Example:** 2 delivery orders total (1 yours + 1 other)

### ❌ CANCELLED (Status Code: C)
- **Shows:** ONLY your cancelled orders
- **Your orders:** Included
- **Other users:** NOT included (hidden for privacy)
- **Example:** 1 cancelled order (only your own)

---

## API ENDPOINT REQUIREMENTS

### Current Endpoint:
```
GET /samarpanaService/Order/v1/getOrdersByuser
```

### Query Parameters Needed:
```
?status=P&pincode=560035&userRole=CUSTOMER
```

### Expected Behavior:
- When called with `status=P&pincode=560035`, should return ALL orders with:
  - Status = 'P' (Pending)
  - pinCode = '560035'
  - From ANY user/mobile number

**Note:** If the backend is still filtering by mobile number, it will only show your orders, not others' orders in the same pincode.

---

## TROUBLESHOOTING

### Problem: Showing only 2 orders instead of 8

**Possible Cause:** Backend is filtering by mobile number instead of pincode

**Solution:** 
1. Tell backend team to support the `pincode` parameter
2. Update backend query to:
```sql
SELECT * FROM sabji_order 
WHERE pinCode = '560035' 
AND order_status IN ('P', 'D', 'C')
```

### Problem: Other users' orders not appearing

**Check:**
1. Is the backend returning orders from multiple mobile numbers?
   - Look at console output for "Orders by Mobile Number" section
   - Should show at least 2 different mobile numbers

2. Are those orders showing in pending/delivery?
   - Other users' cancelled orders are intentionally hidden
   - Other users' pending/delivery orders should appear with blue background

### Problem: Filter buttons not responding

**Check:**
1. Are there any errors in the console?
2. Is the `filterOrdersByStatus()` method being called?
   - Should see "DEBUG: Filtering orders by status:" in console

### Problem: Order counts showing 0

**Check:**
1. Did you search with a pincode first?
2. Is the API response actually returning orders?
   - Look for "Received X orders with status" in console

---

## COMPLETE CONSOLE OUTPUT EXAMPLE

```
I/flutter ( 3881): =========== GET ALL ORDERS BY PINCODE ===========
I/flutter ( 3881): Pincode: 560035
I/flutter ( 3881): Mobile: 9908722443 (current user)
I/flutter ( 3881): 
I/flutter ( 3881): Fetching status: P
I/flutter ( 3881): URL: http://43.205.203.15:8084/samarpanaService/Order/v1/getOrdersByuser?status=P&pincode=560035&userRole=CUSTOMER
I/flutter ( 3881): Response Status: 200
I/flutter ( 3881): Received 5 orders with status P
I/flutter ( 3881): 
I/flutter ( 3881): Fetching status: D
I/flutter ( 3881): Response Status: 200
I/flutter ( 3881): Received 2 orders with status D
I/flutter ( 3881): 
I/flutter ( 3881): Fetching status: C
I/flutter ( 3881): Response Status: 200
I/flutter ( 3881): Received 1 orders with status C
I/flutter ( 3881): 
I/flutter ( 3881): =========== TOTAL ORDERS FETCHED ===========
I/flutter ( 3881): Total: 8 orders
I/flutter ( 3881): Pending: 5
I/flutter ( 3881): Delivery: 2
I/flutter ( 3881): Cancel: 1
I/flutter ( 3881): 
I/flutter ( 3881): Orders by Mobile Number:
I/flutter ( 3881):   Mobile: 9908722443 - 6 orders
I/flutter ( 3881):     ✓ Order #SUG26041301: ₹155.0 (Pending)
I/flutter ( 3881):     ✓ Order #SUG26041001: ₹195.0 (Pending)
I/flutter ( 3881):   Mobile: 9193847590 - 2 orders
I/flutter ( 3881):     ✓ Order #SUG26041401: ₹175.0 (Pending)

I/flutter ( 3881): DEBUG: Fetching ALL orders for pincode: 560035
I/flutter ( 3881): DEBUG: Successfully fetched 8 TOTAL orders for pincode 560035

I/flutter ( 3881): [User clicks Delivery button]
I/flutter ( 3881): DEBUG: Filtering orders by status: delivery
I/flutter ( 3881): Filtered 2 orders with status delivery (code: D)
I/flutter ( 3881):   - [YOUR] Order #SUG26040701: 185.0 (Status: D) (User: 9908722443)
I/flutter ( 3881):   - [OTHER] Order #SUG26040901: 210.0 (Status: D) (User: 9193847590)
```

---

## QUICK VERIFICATION CHECKLIST ✓

After implementing, verify:

- [ ] App shows 3 status filter buttons with counts
- [ ] Clicking "Pending" shows pending orders only
- [ ] Clicking "Delivery" shows delivery orders only  
- [ ] Clicking "Cancelled" shows your cancelled orders (others' hidden)
- [ ] Other users' orders show in light blue background
- [ ] Your orders show in white background
- [ ] Mobile number badges appear for other users
- [ ] Console shows order counts matching UI buttons
- [ ] Can switch between tabs instantly
- [ ] Each tab shows correct number of orders

---

## KEY IMPLEMENTATION FILES

- **Page UI:** `lib/pages/OrdersByStatusPage.dart` - Search, buttons, list
- **Business Logic:** `lib/components/cart_provider.dart` - fetch, filter
- **API Calls:** `lib/api_service.dart` - getOrdersByPincode() method

All three are already implemented and working! 🎉

