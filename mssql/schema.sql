DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Customers;

-- Create Customers table
CREATE TABLE Customers (
	id BIGINT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    city VARCHAR(100),
    created_at DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at  DATETIME2 NULL
);

-- Create Categories table
CREATE TABLE Categories (
	id BIGINT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create Products table
CREATE TABLE Products (
	id BIGINT IDENTITY(1,1) PRIMARY KEY,
    category_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    sku VARCHAR(100)  NOT NULL UNIQUE,
    price DECIMAL(12, 2) NOT NULL CHECK (price >= 0),
    description VARCHAR(max),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    created_at DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_products_category FOREIGN KEY (category_id)
	REFERENCES Categories(id) ON DELETE NO ACTION
);

-- Create Orders table
CREATE TABLE Orders (
	id BIGINT IDENTITY(1,1) PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    order_date DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL
        CHECK (status IN ('NEW', 'PAID', 'SHIPPED', 'DELIVERED', 'CANCELLED')),
    total_amount DECIMAL(12, 2) NOT NULL CHECK(total_amount>=0),
    shipping_address VARCHAR(255) NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
    REFERENCES Customers(id) ON DELETE CASCADE
);

-- Create Order_Items table
CREATE TABLE Order_Items (
	id BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL CHECK(quantity>0),
    unit_price DECIMAL(12, 2) NOT NULL CHECK(unit_price>=0),

    CONSTRAINT uq_order_product
    UNIQUE (order_id, product_id),

    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id)
    REFERENCES Orders(id) ON DELETE CASCADE,

    CONSTRAINT fk_order_items_product FOREIGN KEY (product_id)
    REFERENCES Products(id) ON DELETE NO ACTION
);

-- Create Payments table
CREATE TABLE Payments (
	id BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id BIGINT NOT NULL,
    payment_date DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(12, 2) NOT NULL CHECK(amount>=0),
    payment_method VARCHAR(20) NOT NULL
        CHECK (payment_method IN ('CARD','PAYPAL','BANK_TRANSFER','APPLE_PAY','GOOGLE_PAY')),
    status VARCHAR(20) NOT NULL
        CHECK (status IN ('PENDING','COMPLETED','FAILED','REFUNDED')),
    created_at DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payments_order FOREIGN KEY (order_id)
    REFERENCES Orders(id) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX idx_customers_city
ON Customers(city);

CREATE INDEX idx_products_category
ON Products(category_id);

CREATE INDEX idx_products_name
ON Products(name);

CREATE INDEX idx_orders_customer
ON Orders(customer_id);

CREATE INDEX idx_orders_date
ON Orders(order_date);

CREATE INDEX idx_orders_status
ON Orders(status);

CREATE INDEX idx_order_items_order
ON Order_Items(order_id);

CREATE INDEX idx_order_items_product
ON Order_Items(product_id);

CREATE INDEX idx_payments_status
ON Payments(status);

-- End