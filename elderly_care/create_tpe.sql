CREATE TABLE elderly_care_tpe (
    id SERIAL PRIMARY KEY,
    institution_type VARCHAR(10),       -- 屬性 (私立、公立)
    institution_name TEXT,               -- 機構名稱
    district VARCHAR(20),                -- 區域別
    address TEXT,                       -- 地址
    phone VARCHAR(30),                  -- 電話
    care_target VARCHAR(50),            -- 收容對象
    total_beds INTEGER,                 -- 核定總床位數量
    long_term_care_beds INTEGER,        -- 長照床位數量
    nursing_beds INTEGER,                -- 養護床位數量
    dementia_beds INTEGER,               -- 失智床位數量
    care_beds INTEGER                   -- 安養床位數量
);