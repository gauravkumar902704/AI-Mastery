-- Creating the Database
CREATE DATABASE Amazon_db;

-- Droping any table

-- Check table which are present in database
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
ORDER BY table_name;


-- Defining the tables..
CREATE TABLE IF NOT EXISTS customers (
    customer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(10),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    city VARCHAR(50),
    state VARCHAR(50)
)

-- Inserting Values..
INSERT INTO customers 
(full_name, email, phone_number, registration_date, city, state)
VALUES
( 'Aman Sharma', 'aman@gmail.com', '9876543210', '2026-01-10', 'Delhi', 'Delhi'),
( 'Riya Singh', 'riya@gmail.com', '9876543211', '2026-01-15', 'Agra', 'Uttar Pradesh'),
( 'Rahul Verma', 'rahul@gmail.com', '9876543212', '2026-02-01', 'Lucknow', 'Uttar Pradesh'),
( 'Priya Gupta', 'priya@gmail.com', '9876543213', '2026-02-10', 'Jaipur', 'Rajasthan'),
( 'Arjun Mehta', 'arjun@gmail.com', '9876543214', '2026-02-20', 'Noida', 'Uttar Pradesh'),
( 'Neha Kapoor', 'neha@gmail.com', '9876543215', '2026-03-05', 'Delhi', 'Delhi')
ON CONFLICT(email)
DO NOTHING;

-- Quering the data 
SELECT * FROM customers;

-- Creating the categories table
CREATE TABLE IF NOT EXISTS categories(
    category_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
)

-- Inserting the values of categories table
INSERT INTO categories 
(category_name)
VALUES
('Electronics'),
('Computers'),
('Accessories'),
('Home Appliances')
ON CONFLICT(category_name)
DO NOTHING;

SELECT * FROM categories;

-- Creating the products table


CREATE TABLE IF NOT EXISTS products (
    product_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category INT NOT NULL,
    brand VARCHAR(50),
    price NUMERIC(8,2) CHECK(price >= 0),
    cost_price NUMERIC(8,2) CHECK(cost_price >= 0),
    is_active VARCHAR(20) DEFAULT 'active',
    product_creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(category) REFERENCES categories(category_id)
)

-- Inserting the data of products table
INSERT INTO products 
(product_name, category, brand, price, cost_price, is_active, product_creation_date)
VALUES
( 'Laptop Pro 15', 2, 'TechBrand', 75000, 60000, 'active', '2026-01-01'),
( 'Wireless Mouse', 3, 'LogiTech', 1500, 900, 'active', '2026-01-05'),
( 'Mechanical Keyboard', 3, 'KeyMaster', 4500, 2800, 'active', '2026-01-08'),
( 'Smartphone X', 1, 'TechBrand', 45000, 36000, 'active', '2026-01-12'),
( 'Air Purifier', 4, 'CleanAir', 12000, 8500, 'active', '2026-02-01'),
( 'USB-C Hub', 3, 'ConnectPro', 2500, 1400, 'active', '2026-02-05'),
( 'Gaming Monitor', 2, 'ViewMax', 28000, 21000, 'active', '2026-02-15'),
( 'Bluetooth Speaker', 1, 'SoundMax', 5000, 3000, 'active', '2026-03-01')
ON CONFLICT(product_id)
DO NOTHING;

SELECT * FROM products;

-- Now Creating warehouse table
CREATE TABLE IF NOT EXISTS warehouses (
    warehouse_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL
)

-- Insreting data in warehouse table
INSERT INTO warehouses 
(warehouse_name, city, state)
VALUES
('Delhi Central Warehouse', 'Delhi', 'Delhi'),
('Agra Distribution Center', 'Agra', 'Uttar Pradesh'),
('Lucknow Warehouse', 'Lucknow', 'Uttar Pradesh')
ON CONFLICT(warehouse_id)
DO NOTHING;

-- Creating new inventory table
CREATE TABLE IF NOT EXISTS inventory(
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    available_quantity INTEGER CHECK(available_quantity >= 0),
    reserved_quantity INTEGER CHECK(reserved_quantity >= 0),
    reorder_level INTEGER,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(product_id, warehouse_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id),
    FOREIGN KEY(warehouse_id) REFERENCES warehouses(warehouse_id)
)

-- Inserting data of inventory
INSERT INTO inventory VALUES
(1, 1, 25, 3, 10, '2026-09-01'),
(2, 2, 10, 2, 8, '2026-09-01'),
(3, 1, 100, 10, 30, '2026-09-01'),
(4, 2, 40, 5, 20, '2026-09-01'),
(5, 1, 35, 5, 15, '2026-09-01'),
(6, 1, 20, 4, 10, '2026-09-01'),
(7, 3, 15, 2, 8, '2026-09-01'),
(8, 2, 8, 1, 10, '2026-09-01'),
(1, 1, 50, 5, 20, '2026-09-01'),
(2, 3, 6, 1, 8, '2026-09-01'),
(8, 2, 25, 3, 10, '2026-09-01')
ON CONFLICT(product_id, warehouse_id)
DO NOTHING;

SELECT * FROM inventory;

-- Creating Orders table
CREATE TABLE IF NOT EXISTS Orders(
    order_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    order_status VARCHAR(50) CHECK(order_status IN('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled')),
    shipping_address TEXT NOT NULL,
    total_amount NUMERIC(10,2) CHECK(total_amount >=0),

    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
)

-- Inserting the data into Orders table
INSERT INTO orders 
(customer_id, order_date, order_status, shipping_address, total_amount)
VALUES
( 1, '2026-08-01', 'delivered', 'Delhi, Delhi', 76500),
( 2, '2026-08-05', 'delivered', 'Agra, Uttar Pradesh', 49500),
( 3, '2026-08-10', 'shipped', 'Lucknow, Uttar Pradesh', 33000),
( 1, '2026-08-15', 'cancelled', 'Delhi, Delhi', 45000),
( 4, '2026-08-20', 'delivered', 'Jaipur, Rajasthan', 16500),
( 5, '2026-08-25', 'processing', 'Noida, Uttar Pradesh', 77500),
( 6, '2026-09-01', 'confirmed', 'Delhi, Delhi', 5000),
( 2, '2026-09-05', 'delivered', 'Agra, Uttar Pradesh', 30000)
ON CONFLICT(order_id)
DO NOTHING;

SELECT * FROM orders;

-- Creating table order_items
CREATE TABLE IF NOT EXISTS order_items(
    order_item_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INTEGER CHECK(quantity >= 0),
    purchase_price NUMERIC(10,2) CHECK(purchase_price >= 0),
    discount NUMERIC(8,2) CHECK(discount >= 0),

    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id)
)

-- inserting the data into order_items table
INSERT INTO order_items 
(order_id, product_id, quantity, purchase_price, discount)
VALUES
(1, 1, 1, 75000, 0),
(1, 2, 1, 1500, 0),

( 2, 4, 1, 45000, 0),
(2, 2, 3, 1500, 500),

(3, 7, 1, 28000, 0),
(3, 6, 2, 2500, 0),

(4, 4, 1, 45000, 0),

(5, 5, 1, 12000, 0),
(5, 3, 1, 4500, 0),

(6, 1, 1, 75000, 0),
(6, 6, 1, 2500, 0),

(7, 8, 1, 5000, 0),

(8, 7, 1, 28000, 0),
(8, 2, 2, 1500, 1000)
ON CONFLICT(order_item_id)
DO NOTHING;

SELECT * FROM order_items;

-- Creating table payments
CREATE TABLE IF NOT EXISTS payments(
    payment_id INTEGER GERERATED ALWAYS AS INTEGER,
    transaction_reference_id VARCHAR(100) NOT NULL,
    order_id INT NOT NULL,
    payment_method VARCHAR(30) CHECK(payment_method IN('UPI', 'Credit Card', 'Debit Card', 'Net Banking', 'Cash on Delivery')),
    payment_amount NUMERIC(10,2) CHECK(payment_amount >= 0),
    payment_date DATE DEFAULT CURRENT_DATE,
    payment_status VARCHAR(30) CHECK(payment_status IN('pending', 'successful', 'failed', 'refunded')),

    PRIMARY KEY(payment_id, order_id),
    FOREIGN KEY(order_id) REFERENCES orders(order_id)
)
-- Inserting data into the table
INSERT INTO payments VALUES
(501, 1001, 'Credit Card', 76500, '2026-08-01', 'successful', 'TXN1001'),
(502, 1002, 'UPI', 49500, '2026-08-05', 'successful', 'TXN1002'),
(503, 1003, 'Debit Card', 33000, '2026-08-10', 'successful', 'TXN1003'),
(504, 1004, 'UPI', 45000, '2026-08-15', 'refunded', 'TXN1004'),
(505, 1005, 'Net Banking', 16500, '2026-08-20', 'successful', 'TXN1005'),
(506, 1006, 'Credit Card', 77500, '2026-08-25', 'successful', 'TXN1006'),
(507, 1007, 'UPI', 5000, '2026-09-01', 'successful', 'TXN1007'),
(508, 1008, 'Cash on Delivery', 30000, '2026-09-05', 'successful', 'TXN1008');