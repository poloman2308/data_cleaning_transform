import csv
import random
from faker import Faker
from datetime import datetime
import os

# Set output path
output_path = r"C:\Users\Owner\data_cleaning_transform\data\customers_raw.csv"

# Make sure the folder exists
os.makedirs(os.path.dirname(output_path), exist_ok=True)

fake = Faker()
Faker.seed(42)

phone_formats = [
    "({}){}-{}",
    "{}.{}.{}",
    "{}-{}-{}",
    "+1 {} {} {}",
    "{}{}{}",
]

date_formats = [
    "%m-%d-%Y",
    "%d/%m/%Y",
    "%Y/%m/%d",
    "%b %d, %Y",
    "%m/%d/%y"
]

def messify_name(name):
    name = name.lower() if random.random() < 0.5 else name.upper()
    name = ''.join(random.choice([c, c.upper(), c.lower(), '@', '*']) if c.isalpha() else c for c in name)
    return ' '.join(name.split())

with open(output_path, 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['Full Name', ' Phone ', 'signup_date ', 'email_address'])

    for _ in range(100):
        name = fake.name()
        messy_name = messify_name(name)
        phone = ''.join([str(random.randint(0, 9)) for _ in range(10)])
        phone_fmt = random.choice(phone_formats).format(phone[:3], phone[3:6], phone[6:])
        date_fmt = random.choice(date_formats)
        signup_date = datetime.strptime(fake.date_between(start_date='-2y', end_date='today').strftime("%Y-%m-%d"), "%Y-%m-%d").strftime(date_fmt)
        email = fake.email()
        # Write duplicate occasionally
        if random.random() < 0.1:
            writer.writerow([messy_name, phone_fmt, signup_date, email])
        writer.writerow([messy_name, phone_fmt, signup_date, email])

print(f"✔️ File saved to: {output_path}")
