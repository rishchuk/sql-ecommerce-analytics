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

generate_categories()