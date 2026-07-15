import os
from faker import Faker
import mysql.connector
import random
from dotenv import load_dotenv

load_dotenv()


fake = Faker()

random.seed(42)
Faker.seed(42)



CUSTOMERS_COUNT = 5000
PRODUCTS_COUNT = 500
ORDERS_COUNT = 50000



connection = mysql.connector.connect(
    host=os.getenv("DB_HOST"),
    port=os.getenv("DB_PORT"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    database=os.getenv("DB_NAME")
)

cursor = connection.cursor()



print("Cleaning database...")


cursor.execute("SET FOREIGN_KEY_CHECKS = 0")

tables = [
    "Payments",
    "Order_Items",
    "Orders",
    "Products",
    "Customers",
    "Categories"
]


for table in tables:
    cursor.execute(
        f"TRUNCATE TABLE {table}"
    )


cursor.execute("SET FOREIGN_KEY_CHECKS = 1")

connection.commit()



print("Generating categories...")


categories = [
    "Laptops",
    "Smartphones",
    "Tablets",
    "Monitors",
    "Accessories",
    "Gaming",
    "Networking",
    "Storage",
    "Audio",
    "Office"
]


category_rows = [
    (name,)
    for name in categories
]


cursor.executemany(
    """
    INSERT INTO categories(name)
    VALUES (%s)
    """,
    category_rows
)


connection.commit()


category_ids = list(range(1, 11))



print("Generating customers...")


customer_rows = []


for _ in range(CUSTOMERS_COUNT):

    customer_rows.append(
        (
            fake.first_name(),
            fake.last_name(),
            fake.unique.email(),
            fake.city()
        )
    )


cursor.executemany(
    """
    INSERT INTO customers
    (
        first_name,
        last_name,
        email,
        city
    )
    VALUES (%s,%s,%s,%s)
    """,
    customer_rows
)


connection.commit()


customer_ids = list(range(1, CUSTOMERS_COUNT + 1))



print("Generating products...")


product_rows = []


price_ranges = {
    1: (700, 3000),
    2: (300, 1500),
    3: (200, 1000),
    4: (100, 1200),
    5: (10, 300),
    6: (50, 1000),
    7: (30, 500),
    8: (20, 700),
    9: (30, 800),
    10: (50, 1000)
}


for i in range(1, PRODUCTS_COUNT + 1):

    category_id = random.choice(category_ids)

    minimum, maximum = price_ranges[category_id]


    product_rows.append(
        (
            category_id,
            fake.word().capitalize()
            + " "
            + random.choice(
                [
                    "Pro",
                    "Ultra",
                    "Max",
                    "Air",
                    "Elite"
                ]
            ),

            f"SKU-{i:06}",

            round(
                random.uniform(
                    minimum,
                    maximum
                ),
                2
            ),

            fake.text(
                max_nb_chars=100
            ),

            random.randint(
                0,
                500
            )
        )
    )


cursor.executemany(
    """
    INSERT INTO products
    (
        category_id,
        name,
        sku,
        price,
        description,
        stock_quantity
    )
    VALUES
    (%s,%s,%s,%s,%s,%s)
    """,
    product_rows
)


connection.commit()


cursor.execute(
    """
    SELECT id, price
    FROM products
    """
)


products = dict(
    cursor.fetchall()
)


product_ids = list(products.keys())



print("Generating orders...")


statuses = [
    "NEW",
    "PAID",
    "SHIPPED",
    "DELIVERED",
    "CANCELLED"
]


order_rows = []


for _ in range(ORDERS_COUNT):

    order_rows.append(
        (
            random.choice(customer_ids),

            fake.date_time_between(
                start_date="-2y",
                end_date="now"
            ),

            random.choice(statuses),

            0,

            fake.address()
        )
    )


cursor.executemany(
    """
    INSERT INTO orders
    (
        customer_id,
        order_date,
        status,
        total_amount,
        shipping_address
    )
    VALUES
    (%s,%s,%s,%s,%s)
    """,
    order_rows
)


connection.commit()


cursor.execute(
    """
    SELECT id
    FROM orders
    """
)


orders = [
    row[0] for row in cursor.fetchall()
]



print("Generating order items...")


order_item_rows = []


order_totals = {}


for order_id in orders:


    total = 0


    for product_id in random.sample(
        product_ids,
        random.randint(1,5)
    ):


        quantity = random.randint(
            1,
            5
        )


        price = float(
            products[product_id]
        )


        total += quantity * price


        order_item_rows.append(
            (
                order_id,
                product_id,
                quantity,
                price
            )
        )


    order_totals[order_id] = round(
        total,
        2
    )



cursor.executemany(
    """
    INSERT INTO order_items
    (
        order_id,
        product_id,
        quantity,
        unit_price
    )
    VALUES
    (%s,%s,%s,%s)
    """,
    order_item_rows
)


connection.commit()


for order_id, total in order_totals.items():

    cursor.execute(
        """
        UPDATE orders
        SET total_amount=%s
        WHERE id=%s
        """,
        (
            total,
            order_id
        )
    )


connection.commit()



print("Generating payments...")


payments = []


methods = [
    "CARD",
    "PAYPAL",
    "BANK_TRANSFER",
    "APPLE_PAY",
    "GOOGLE_PAY"
]


payment_status = [
    "PENDING",
    "COMPLETED",
    "FAILED",
    "REFUNDED"
]


for order_id, amount in order_totals.items():

    payments.append(
        (
            order_id,
            amount,
            random.choice(methods),
            random.choice(payment_status)
        )
    )


cursor.executemany(
    """
    INSERT INTO payments
    (
        order_id,
        amount,
        payment_method,
        status
    )
    VALUES
    (%s,%s,%s,%s)
    """,
    payments
)


connection.commit()


cursor.close()
connection.close()


print("DONE!")