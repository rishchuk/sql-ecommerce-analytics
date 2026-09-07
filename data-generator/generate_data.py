import os

import random
from faker import Faker
from dotenv import load_dotenv
from sqlalchemy import create_engine, text


load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL environment variable is not set!")

engine = create_engine(DATABASE_URL)

CUSTOMERS_COUNT = 5_000
PRODUCTS_COUNT = 500
ORDERS_COUNT = 50_000
RANDOM_SEED = 42


fake = Faker()

random.seed(RANDOM_SEED)
Faker.seed(RANDOM_SEED)


CATEGORIES = [
    "Laptops",
    "Smartphones",
    "Tablets",
    "Monitors",
    "Accessories",
    "Gaming",
    "Networking",
    "Storage",
    "Audio",
    "Office",
]

PRICE_RANGES = {
    "Laptops": (700, 3000),
    "Smartphones": (300, 1500),
    "Tablets": (200, 1000),
    "Monitors": (100, 1200),
    "Accessories": (10, 300),
    "Gaming": (50, 1000),
    "Networking": (30, 500),
    "Storage": (20, 700),
    "Audio": (30, 800),
    "Office": (50, 1000),
}

ORDER_STATUSES = [
    "NEW",
    "PAID",
    "SHIPPED",
    "DELIVERED",
    "CANCELLED",
]


def generate_categories():
    rows = []

    for name in CATEGORIES:
        rows.append({
            "name": name
        })

    with engine.begin() as connection:
        connection.execute(
            text("""
                INSERT INTO Categories (name)
                VALUES (:name)
            """),
            rows
        )


def get_categories():
    with engine.connect() as connection:
        result = connection.execute(
            text("""
                SELECT id, name
                FROM Categories
                ORDER BY id
            """)
        )

        categories = {}

        for row in result:
            categories[row.name] = row.id

        return categories


def generate_customers():
    rows = []

    for _ in range(CUSTOMERS_COUNT):
        rows.append({
            "first_name": fake.first_name(),
            "last_name": fake.last_name(),
            "email": fake.unique.email(),
            "city": fake.city(),
        })

    with engine.begin() as connection:
        connection.execute(
            text("""
                INSERT INTO Customers
                (
                    first_name,
                    last_name,
                    email,
                    city
                )
                VALUES
                (
                    :first_name,
                    :last_name,
                    :email,
                    :city
                )
            """),
            rows
        )


def get_customer_ids():
    with engine.connect() as connection:
        result = connection.execute(
            text("""
                SELECT id
                FROM Customers
                ORDER BY id
            """)
        )

        return [row.id for row in result]


def generate_products(categories):
    rows = []

    category_names = list(categories.keys())

    for i in range(1, PRODUCTS_COUNT + 1):
        category_name = random.choice(category_names)

        minimum, maximum = PRICE_RANGES[category_name]

        rows.append({
            "category_id": categories[category_name],
            "name": fake.word().capitalize() + " " + random.choice(
                [
                    "Pro",
                    "Ultra",
                    "Max",
                    "Air",
                    "Elite"
                ]
            ),
            "sku": f"SKU-{i:06d}",
            "price": round(random.uniform(minimum, maximum), 2),
            "description": fake.text(max_nb_chars=100),
            "stock_quantity": random.randint(0, 500),
        })

    with engine.begin() as connection:
        connection.execute(
            text("""
                INSERT INTO Products
                (
                    category_id,
                    name,
                    sku,
                    price,
                    description,
                    stock_quantity
                )
                VALUES
                (
                    :category_id,
                    :name,
                    :sku,
                    :price,
                    :description,
                    :stock_quantity
                )
            """),
            rows
        )


def get_products():
    with engine.connect() as connection:
        result = connection.execute(
            text("""
                SELECT id, price
                FROM Products
                ORDER BY id
            """)
        )

        products = {}

        for row in result:
            products[row.id] = row.price

        return products


def generate_orders(customer_ids):
    rows = []

    for _ in range(ORDERS_COUNT):
        rows.append({
            "customer_id": random.choice(customer_ids),
            "order_date": fake.date_time_between(
                start_date="-2y",
                end_date="now",
            ),
            "status": random.choice(ORDER_STATUSES),
            "total_amount": 0,
            "shipping_address": fake.address(),
        })

    with engine.begin() as connection:
        connection.execute(
            text("""
                INSERT INTO Orders
                (
                    customer_id,
                    order_date,
                    status,
                    total_amount,
                    shipping_address
                )
                VALUES
                (
                    :customer_id,
                    :order_date,
                    :status,
                    :total_amount,
                    :shipping_address
                )
            """),
            rows
        )


def get_order_ids():
    with engine.connect() as connection:
        result = connection.execute(
            text("""
                SELECT id
                FROM Orders
                ORDER BY id
            """)
        )

        return [row.id for row in result]


def generate_order_items(order_ids, products):
    rows = []
    order_totals = {}

    product_ids = list(products.keys())

    for order_id in order_ids:
        total = 0

        selected_products = random.sample(
            product_ids,
            random.randint(1, 5)
        )

        for product_id in selected_products:
            quantity = random.randint(1, 5)
            unit_price = products[product_id]

            total += quantity * unit_price

            rows.append({
                "order_id": order_id,
                "product_id": product_id,
                "quantity": quantity,
                "unit_price": unit_price,
            })

        order_totals[order_id] = total

    with engine.begin() as connection:
        connection.execute(
            text("""
                INSERT INTO Order_Items
                (
                    order_id,
                    product_id,
                    quantity,
                    unit_price
                )
                VALUES
                (
                    :order_id,
                    :product_id,
                    :quantity,
                    :unit_price
                )
            """),
            rows
        )

    return order_totals


def main():
    generate_categories()

    categories = get_categories()

    generate_customers()

    generate_products(categories)

    customer_ids = get_customer_ids()

    generate_orders(customer_ids)
    
    order_ids = get_order_ids()
    products = get_products()

    order_totals = generate_order_items(order_ids, products)

    print(len(order_totals))
    

if __name__ == "__main__":
    main()