DROP TABLE IF EXISTS cleaned.customers_cleaned;

CREATE TABLE cleaned.customers_cleaned AS
SELECT
    INITCAP(REGEXP_REPLACE(full_name, '[^a-zA-Z\s]', '', 'g')) AS full_name_cleaned,
    REGEXP_REPLACE(phone, '[^0-9]', '', 'g') AS phone_cleaned,

    CASE
        -- First: Ensure it fully matches M/D/YYYY or D/M/YYYY
        WHEN signup_date ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN
            CASE
                -- Now it's safe to cast — if first part ≤ 12, assume MM/DD/YYYY
                WHEN SUBSTRING(signup_date FROM '^\d{1,2}')::INT <= 12 THEN TO_DATE(signup_date, 'MM/DD/YYYY')
                ELSE TO_DATE(signup_date, 'DD/MM/YYYY')
            END
        WHEN signup_date ~ '^\d{1,2}-[A-Za-z]{3}-\d{2}$'
            THEN TO_DATE(signup_date, 'DD-Mon-YY')
        ELSE NULL
    END AS signup_date_cleaned,

    LOWER(TRIM(email_address)) AS email_cleaned

FROM staging.customers_raw
WHERE signup_date IS NOT NULL AND signup_date <> '';
