-- Customer summary view
CREATE OR REPLACE VIEW analytics.customer_summary AS
SELECT
    full_name_cleaned AS customer_name,
    email_cleaned,
    phone_cleaned,
    signup_date_cleaned
FROM cleaned.customers_deduped;

-- Monthly signup trend view
CREATE OR REPLACE VIEW analytics.signup_trend AS
SELECT
    DATE_TRUNC('month', signup_date_cleaned) AS signup_month,
    COUNT(*) AS new_customers
FROM cleaned.customers_deduped
WHERE signup_date_cleaned IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- Domain breakdown view
CREATE OR REPLACE VIEW analytics.email_domain_stats AS
SELECT
    SPLIT_PART(email_cleaned, '@', 2) AS email_domain,
    COUNT(*) AS total_customers
FROM cleaned.customers_deduped
GROUP BY 1
ORDER BY total_customers DESC;
