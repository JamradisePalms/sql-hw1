
/*
Кораблев Денис Андреевич
Вариант 4 — хранение товаров на складе.

Условие задания
База данных должна содержать сведения о помещениях, стеллажах,
клиентах и товарах, хранящихся на стеллажах.

Принято, что номера стеллажей уникальны внутри помещения, а одно место
занимает один товар. Если дата поступления пропущена, используется
текущая дата.
*/

-- Для помещения указываются название, полезный объём, температурные
-- и влажностные условия.
CREATE TABLE rooms (
    room_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL CHECK (name <> ''),
    usable_volume_m3 NUMERIC(12, 3) NOT NULL CHECK (usable_volume_m3 > 0),
    min_temperature_c NUMERIC(5, 2) NOT NULL,
    max_temperature_c NUMERIC(5, 2) NOT NULL,
    min_wet_pct NUMERIC(5, 2) NOT NULL,
    max_wet_pct NUMERIC(5, 2) NOT NULL,

    CHECK (min_temperature_c <= max_temperature_c),
    CHECK (
        0 <= min_wet_pct
        AND min_wet_pct <= max_wet_pct
        AND max_wet_pct <= 100
    )
);


-- Для стеллажа указываются номер, помещение,
-- количество мест, высота, ширина и длина одного места, а также
-- максимальная суммарная нагрузка.
CREATE TABLE racks (
    rack_id INTEGER PRIMARY KEY,
    room_id INTEGER NOT NULL REFERENCES rooms (room_id),
    rack_number INTEGER NOT NULL CHECK (rack_number > 0),
    slot_count INTEGER NOT NULL CHECK (slot_count > 0),
    slot_height_cm NUMERIC(12, 3) NOT NULL CHECK (slot_height_cm > 0),
    slot_width_cm NUMERIC(12, 3) NOT NULL CHECK (slot_width_cm > 0),
    slot_length_cm NUMERIC(12, 3) NOT NULL CHECK (slot_length_cm > 0),
    max_load_kg NUMERIC(12, 3) NOT NULL CHECK (max_load_kg > 0),

    UNIQUE (room_id, rack_number)
);


-- Для клиента указываются название юридического лица и банковские
-- реквизиты в виде текста.
CREATE TABLE clients (
    client_id INTEGER PRIMARY KEY,
    legal_name TEXT NOT NULL,
    bank_details TEXT NOT NULL
);

-- Для товара указываются высота, ширина,
-- длина, вес, дата поступления, номер договора, клиент, дата окончания
-- договора, температурные и влажностные условия хранения, стеллаж
-- и целочисленная позиция на нём. На одном стеллаже могут храниться
-- товары разных клиентов.
CREATE TABLE goods (
    goods_id INTEGER PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES clients (client_id),
    rack_id INTEGER NOT NULL REFERENCES racks (rack_id),
    rack_position INTEGER NOT NULL CHECK (rack_position > 0),
    height_cm NUMERIC(12, 3) NOT NULL CHECK (height_cm > 0),
    width_cm NUMERIC(12, 3) NOT NULL CHECK (width_cm > 0),
    length_cm NUMERIC(12, 3) NOT NULL CHECK (length_cm > 0),
    weight_kg NUMERIC(12, 3) NOT NULL CHECK (weight_kg > 0),
    received_on DATE NOT NULL DEFAULT CURRENT_DATE,
    contract_number TEXT NOT NULL,
    contract_expires_on DATE NOT NULL,
    min_temperature_c NUMERIC(5, 2) NOT NULL,
    max_temperature_c NUMERIC(5, 2) NOT NULL,
    min_wet_pct NUMERIC(5, 2) NOT NULL,
    max_wet_pct NUMERIC(5, 2) NOT NULL,

    UNIQUE (rack_id, rack_position),
    CHECK (received_on <= contract_expires_on),
    CHECK (min_temperature_c <= max_temperature_c),
    CHECK (
        0 <= min_wet_pct
        AND min_wet_pct <= max_wet_pct
        AND max_wet_pct <= 100
    )
);
