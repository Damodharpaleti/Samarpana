# Backend Update Required: Order Pincode Filtering

## Current Issue
The Orders By Pincode feature is requesting orders from all mobile numbers in a given pincode, but the backend endpoint `Order/v1/getOrdersByuser` only returns orders for the authenticated user (filtered by mobile number).

## Solution Required

### Endpoint: `Order/v1/getOrdersByuser`

**Current Behavior:**
- Returns only the orders of the authenticated user (mobile number from token)

**New Behavior:**
- Add support for optional `pincode` query parameter
- When `pincode` parameter is provided: Return ALL orders for that pincode from ALL users
- When `pincode` parameter is NOT provided: Keep existing behavior (return only current user's orders)

### Query Parameters
```
GET /Order/v1/getOrdersByuser?status=P&pincode=560035&userRole=CUSTOMER
```

- `status`: P (Pending) | D (Delivery) | C (Cancel)
- `pincode`: (Optional) Pincode to filter orders by location
- `userRole`: CUSTOMER or ADMIN

### SQL Implementation Example

```sql
-- When pincode is provided - Get all orders for that pincode
SELECT so.* FROM sabji_order so
JOIN sabjorder_Address soa ON so.orderUserId = soa.userId
WHERE soa.post_code = @pincode 
  AND so.orderStatus = @status
  AND so.orderDate >= DATE_SUB(NOW(), INTERVAL 30 DAY)
ORDER BY so.orderDate DESC;

-- When pincode is NOT provided - Get only current user's orders (existing behavior)
SELECT * FROM sabji_order 
WHERE orderUserId = @userMobileNumber 
  AND orderStatus = @status
ORDER BY orderDate DESC;
```

### Database Structure Reference
- **Orders Table:** `sabji_order`
  - `id` (orderId)
  - `orderUserId` (mobile number)
  - `orderStatus` (P, D, C)
  - `orderDate`
  
- **Address Table:** `sabjorder_Address`
  - `order_id` (links to sabji_order.id)
  - `userId` (mobile number)
  - `post_code` (pincode)

### Response Format
Continue returning the same JSON structure:
```json
[
  {
    "orderId": 2686,
    "orderUserId": "9908722443",
    "orderNumber": "SUG26041301",
    "orderStatus": "P",
    "orderFullPrice": 155.0,
    "address": "sarjapur road,Bangalore,",
    ...
  }
]
```

## Frontend Implementation
- Pincode parameter is already being sent in the API request
- Debug logs will show if multiple mobile numbers are returned
- UI already displays mobile numbers for other users' orders
- Orders are filtered as:
  - Show ALL orders from logged-in user (regardless of status)
  - Show other users' P and D orders only (not Cancel)

## Testing
1. Enter a pincode with orders from multiple mobile numbers (e.g., 560035)
2. Check debug logs to verify multiple mobile numbers in the response
3. Verify all pending/delivery orders are displayed with their mobile numbers

## Debug Output
Check console logs for:
```
=========== GET ALL ORDERS BY PINCODE ===========
Pincode: 560035
Mobile: 9908722443 (current user)
...
Orders by Mobile Number:
  Mobile: 9908722443 - X orders
  Mobile: 9913459940 - Y orders
  ...
```
