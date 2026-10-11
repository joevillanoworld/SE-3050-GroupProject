CREATE TABLE market (
    market_id INT          NOT NULL AUTO_INCREMENT,
    name      VARCHAR(150) NOT NULL,
    address   VARCHAR(255) NOT NULL,
    PRIMARY KEY (market_id)
);

CREATE TABLE vendor (
    vendor_id INT          NOT NULL AUTO_INCREMENT,
    name      VARCHAR(150) NOT NULL,
    email     VARCHAR(255) NULL,
    PRIMARY KEY (vendor_id)
);

CREATE TABLE product (
    product_id INT          NOT NULL AUTO_INCREMENT,
    name       VARCHAR(150) NOT NULL,
    category   VARCHAR(100) NULL,
    PRIMARY KEY (product_id)
);

CREATE TABLE market_vendor (
    market_id INT NOT NULL,
    vendor_id INT NOT NULL,
    PRIMARY KEY (market_id, vendor_id),
    INDEX idx_market_vendor_vendor (vendor_id),

    CONSTRAINT fk_market_vendor_market_id
        FOREIGN KEY (market_id) REFERENCES market (market_id),
    CONSTRAINT fk_market_vendor_vendor_id
        FOREIGN KEY (vendor_id) REFERENCES vendor (vendor_id)
);

CREATE TABLE market_product (
    market_id          INT           NOT NULL,
    product_id         INT           NOT NULL,
    price              DECIMAL(10,2) NOT NULL,
    available_quantity INT           NOT NULL,
    PRIMARY KEY (market_id, product_id),
    CONSTRAINT chk_market_product_price CHECK (price >= 0),
    CONSTRAINT chk_market_product_qty   CHECK (available_quantity >= 0),

    CONSTRAINT fk_market_product_market_id
        FOREIGN KEY (market_id) REFERENCES market (market_id),
    CONSTRAINT fk_market_product_product_id
        FOREIGN KEY (product_id) REFERENCES product (product_id)

);

CREATE TABLE customer (
    customer_id INT          NOT NULL AUTO_INCREMENT,
    name        VARCHAR(150) NOT NULL,
    email       VARCHAR(255) NOT NULL,
    PRIMARY KEY (customer_id),
    CONSTRAINT uq_customer_email UNIQUE (email)
);

CREATE TABLE preorder (
    preorder_id INT         NOT NULL AUTO_INCREMENT,
    customer_id INT         NOT NULL,
    market_id   INT         NOT NULL,
    status      VARCHAR(30) NOT NULL DEFAULT 'pending',
    placed_at   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (preorder_id),
    CONSTRAINT chk_preorder_status
        CHECK (status IN ('pending', 'confirmed', 'ready', 'picked_up', 'cancelled')),

    CONSTRAINT fk_preorder_id_customer_id
        FOREIGN KEY (customer_id) REFERENCES customer (customer_id),
    CONSTRAINT fk_preorder_id_market_id
        FOREIGN KEY (market_id) REFERENCES market (market_id)
);

CREATE TABLE preorder_item (
    preorder_id INT           NOT NULL,
    product_id  INT           NOT NULL,
    quantity    INT           NOT NULL,
    unit_price  DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (preorder_id, product_id),
    CONSTRAINT chk_preorder_item_qty   CHECK (quantity > 0),
    CONSTRAINT chk_preorder_item_price CHECK (unit_price >= 0),

    CONSTRAINT fk_preorder_item_preorder_id
        FOREIGN KEY (preorder_id) REFERENCES preorder (preorder_id),
    CONSTRAINT fk_preorder_item_product_id
        FOREIGN KEY (product_id) REFERENCES product (product_id)
);