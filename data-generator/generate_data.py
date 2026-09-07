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


def generate_products(categories):
    rows = []

    category_names = list(categories.keys())

    for i in range(1, PRODUCTS_COUNT + 1):
        category_name = random.choice(category_names)

        minimum, maximum = PRICE_RANGES[category_name]

        rows.append({
            "category_id": categories[category_name],
            "name": fake.word().capitalize() + " Pro",
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


generate_categories()

categories = get_categories()

generate_customers()
generate_products(categories)