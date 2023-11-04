-- 생성자 Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   위치:        2023-09-15 19:58:20 KST
--   사이트:      Oracle Database 12c
--   유형:      Oracle Database 12c



DROP TABLE addresses CASCADE CONSTRAINTS;

DROP TABLE board_type CASCADE CONSTRAINTS;

DROP TABLE boards CASCADE CONSTRAINTS;

DROP TABLE employee CASCADE CONSTRAINTS;

DROP TABLE made_by CASCADE CONSTRAINTS;

DROP TABLE manufacturer CASCADE CONSTRAINTS;

DROP TABLE member CASCADE CONSTRAINTS;

DROP TABLE "Order" CASCADE CONSTRAINTS;

DROP TABLE order_products CASCADE CONSTRAINTS;

DROP TABLE products CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE addresses (
    address VARCHAR2(50) NOT NULL
);

ALTER TABLE addresses ADD CONSTRAINT addresses_pk PRIMARY KEY ( address );

CREATE TABLE board_type (
    board_type VARCHAR2(20) NOT NULL,
    certno     NUMBER(20) NOT NULL
);

CREATE UNIQUE INDEX board_type__idx ON
    board_type (
        certno
    ASC );

ALTER TABLE board_type ADD CONSTRAINT delivery_board_pk PRIMARY KEY ( board_type );

CREATE TABLE boards (
    board_id    NUMBER(20) NOT NULL,
    title       VARCHAR2(20) NOT NULL,
    body        CLOB NOT NULL,
    upload_date DATE NOT NULL,
    type_board  VARCHAR2(20) NOT NULL,
    writer_id   VARCHAR2(30) NOT NULL
);

ALTER TABLE boards
    ADD CHECK ( upload_date >= DATE '1910-01-01'
                AND upload_date < DATE '2030-01-01' );

ALTER TABLE boards ADD CONSTRAINT products_board_pk PRIMARY KEY ( board_id );

CREATE TABLE employee (
    certno           NUMBER(20) NOT NULL,
    loginid          VARCHAR2(30),
    name             VARCHAR2(20),
    phoneno          NUMBER(11),
    department       VARCHAR2(20),
    email            VARCHAR2(30),
    address_employee VARCHAR2(50) NOT NULL
);

ALTER TABLE employee ADD CHECK ( phoneno BETWEEN 0100000000 AND 01099999999 );

ALTER TABLE employee ADD CONSTRAINT employee_pk PRIMARY KEY ( certno );

CREATE TABLE made_by (
    company_name VARCHAR2(20) NOT NULL,
    productno    NUMBER(20) NOT NULL
);

ALTER TABLE made_by ADD CONSTRAINT made_by_pk PRIMARY KEY ( company_name,
                                                            productno );

CREATE TABLE manufacturer (
    name            VARCHAR2(20) NOT NULL,
    phoneno         NUMBER(11),
    address_company VARCHAR2(50) NOT NULL
);

ALTER TABLE manufacturer ADD CHECK ( phoneno BETWEEN 0100000000 AND 01099999999 );

ALTER TABLE manufacturer ADD CONSTRAINT manufacturer_pk PRIMARY KEY ( name );

CREATE TABLE member (
    login_id     VARCHAR2(30) NOT NULL,
    name         VARCHAR2(20) NOT NULL,
    phoneno_home NUMBER(11) NOT NULL,
    phoneno_work NUMBER(11),
    address_home VARCHAR2(50) NOT NULL,
    address_work VARCHAR2(50),
    email        VARCHAR2(30) NOT NULL
);

ALTER TABLE member ADD CHECK ( phoneno_home BETWEEN 0100000000 AND 01099999999 );

ALTER TABLE member ADD CHECK ( phoneno_work BETWEEN 0100000000 AND 01099999999 );

ALTER TABLE member ADD CONSTRAINT member_pk PRIMARY KEY ( login_id );

CREATE TABLE "Order" (
    order_id     NUMBER(20) NOT NULL,
    login_id     VARCHAR2(30) NOT NULL,
    address_togo VARCHAR2(50) NOT NULL,
    order_date   DATE NOT NULL
);

ALTER TABLE "Order"
    ADD CHECK ( order_date >= DATE '1910-01-01'
                AND order_date < DATE '2030-01-01' );

ALTER TABLE "Order" ADD CONSTRAINT order_pk PRIMARY KEY ( order_id );

CREATE TABLE order_products (
    productno NUMBER(20) NOT NULL,
    order_id  NUMBER(20) NOT NULL
);

ALTER TABLE order_products ADD CONSTRAINT order_products_pk PRIMARY KEY ( productno,
                                                                          order_id );

CREATE TABLE products (
    prodno             NUMBER(20) NOT NULL,
    product_name       VARCHAR2(20) NOT NULL,
    price              NUMBER(8) NOT NULL,
    inventory_quantity NUMBER(6)
);

ALTER TABLE products
    ADD CHECK ( price >= 1000
                AND price < 99999999
                OR price BETWEEN 500 AND 99999999 );

ALTER TABLE products ADD CONSTRAINT products_pk PRIMARY KEY ( prodno );

ALTER TABLE board_type
    ADD CONSTRAINT board_management FOREIGN KEY ( certno )
        REFERENCES employee ( certno );

ALTER TABLE boards
    ADD CONSTRAINT board_write FOREIGN KEY ( writer_id )
        REFERENCES member ( login_id );

ALTER TABLE manufacturer
    ADD CONSTRAINT company_address FOREIGN KEY ( address_company )
        REFERENCES addresses ( address );

ALTER TABLE employee
    ADD CONSTRAINT employee_address FOREIGN KEY ( address_employee )
        REFERENCES addresses ( address );

ALTER TABLE member
    ADD CONSTRAINT homeaddress_member FOREIGN KEY ( address_home )
        REFERENCES addresses ( address );

ALTER TABLE made_by
    ADD CONSTRAINT made_by_manufacturer_fk FOREIGN KEY ( company_name )
        REFERENCES manufacturer ( name );

ALTER TABLE made_by
    ADD CONSTRAINT made_by_products_fk FOREIGN KEY ( productno )
        REFERENCES products ( prodno );

ALTER TABLE "Order"
    ADD CONSTRAINT order_member FOREIGN KEY ( login_id )
        REFERENCES member ( login_id );

ALTER TABLE order_products
    ADD CONSTRAINT order_products_order_fk FOREIGN KEY ( order_id )
        REFERENCES "Order" ( order_id );

ALTER TABLE order_products
    ADD CONSTRAINT order_products_products_fk FOREIGN KEY ( productno )
        REFERENCES products ( prodno );

ALTER TABLE boards
    ADD CONSTRAINT set_type_board FOREIGN KEY ( type_board )
        REFERENCES board_type ( board_type );

ALTER TABLE "Order"
    ADD CONSTRAINT togoaddress_order FOREIGN KEY ( address_togo )
        REFERENCES addresses ( address );

ALTER TABLE member
    ADD CONSTRAINT workaddress_member FOREIGN KEY ( address_work )
        REFERENCES addresses ( address );



-- Oracle SQL Developer Data Modeler 요약 보고서: 
-- 
-- CREATE TABLE                            10
-- CREATE INDEX                             1
-- ALTER TABLE                             30
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
