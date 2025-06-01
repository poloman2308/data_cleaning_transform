CREATE TABLE cleaned.customers_deduped AS
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY full_name_cleaned, email_cleaned
               ORDER BY signup_date_cleaned DESC NULLS LAST
           ) AS rn
    FROM cleaned.customers_cleaned
) sub
WHERE rn = 1;
