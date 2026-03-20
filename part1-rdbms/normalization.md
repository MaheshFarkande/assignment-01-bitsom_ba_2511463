
## Anaomaly Analysis
1) Insert Anomaly (can’t insert a fact about one entity without another)  - Row identified by order_id = ORD1185 , the product Webcam exists only because there is an order row for it
2) Update Anaomaly(same fact stored multiple times → must update in many places, risk inconsistency) -Row identified by order_id = ORD1114 shows SR01 address as Nariman Point. But in other rows for the same SR01, the address is stored differently - Row identified by order_id = ORD1180 shows Nariman Pt
3) Delete Anomaly (deleting one row unintentionally deletes other facts) -The Webcam product (P008) appears (in the provided data) in the order row identifier id: order_id = ORD1185, deletion of this row will delete Webcam product details.
