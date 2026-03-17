## Anomaly Analysis

### Insert Anomaly

If a new product needs to be added to the database but no customer has ordered it yet, the product cannot be inserted into the table because the order information is missing. For example, if a new product with product_id P105 is introduced but no order has been placed yet, there is no way to store this product without creating a fake order row.

### Update Anomaly

Customer information such as customer_city is repeated across multiple rows. If a customer moves to another city, the change must be updated in multiple rows. If one row is missed, inconsistent data will exist.

### Delete Anomaly

If the only order containing a particular product is deleted, the information about that product will also be lost. For example, deleting the only order containing product_id P101 removes the product information from the database completely.


NORMALIZATION JUSTIFICATION
While a single flat table may initially appear simpler for small-scale data entry, the orders_flat.csv dataset provides clear evidence that this approach is not scalable and leads to significant data integrity risks. Normalization to Third Normal Form (3NF) is a necessary safeguard rather than over-engineering.

One primary reason to refute the manager's position is the presence of redundancy and update anomalies. In the dataset, Sales Representative Deepak Joshi’s office address is repeated across multiple rows. In row 2, it is listed as "Nariman Point," while in row 183, it is abbreviated to "Nariman Pt." In a flat table, if a representative's office location changes, every single historical order row must be updated perfectly. Failure to do so results in inconsistent data where the system cannot provide a single, reliable "source of truth."

Furthermore, a flat structure creates insertion and deletion anomalies. We cannot add a new product or a new sales representative to our system until they are linked to an actual order, as the order_id (a primary key) cannot be null. Conversely, if we delete the only order placed by customer Amit Verma (C003) to clean up our transaction logs, we inadvertently lose all his contact information, including his email and city.

By normalizing the data into separate entities—Customers, Products, SalesReps, and Orders—we decouple transactions from master data. This ensures that a customer's profile or a product's price exists independently of an order. For a growing retail company, this structural integrity is vital for accurate reporting, professional data management, and long-term operational efficiency.
