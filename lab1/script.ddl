#@(#) script.ddl

DROP TABLE IF EXISTS FACTORY_SUPPORTS_PROCESSES;
DROP TABLE IF EXISTS RECIPE_NEEDS_PROCESSES;
DROP TABLE IF EXISTS INGREDIENT_PROVIDER;
DROP TABLE IF EXISTS ICE_CREAM_RECIPE_INSTRUCTION;
DROP TABLE IF EXISTS ICE_CREAM_RECIPE_INGREDIENT;
DROP TABLE IF EXISTS ICE_CREAM_PRODUCT;
DROP TABLE IF EXISTS INGREDIENT;
DROP TABLE IF EXISTS ICE_CREAM_RECIPE;
DROP TABLE IF EXISTS FACTORY;
DROP TABLE IF EXISTS PROVIDER;
DROP TABLE IF EXISTS PROCESS;
DROP TABLE IF EXISTS NUTRIENT;
DROP TABLE IF EXISTS MANAGER;
CREATE TABLE MANAGER
(
	ID int NOT NULL,
	FIRST_NAME varchar (255) NOT NULL,
	SURNAME varchar (255) NOT NULL,
	PHONE_NUMBER varchar (255) NULL,
	TITLE varchar (255) NOT NULL,
	EMAIL varchar (255) NULL,
	PRIMARY KEY(ID)
);

CREATE TABLE NUTRIENT
(
	ID int NOT NULL,
	FAT float NOT NULL,
	CHOLESTEROL float NOT NULL,
	SODIUM float NOT NULL,
	CARBOHYDRATES float NOT NULL,
	PROTEIN float NOT NULL,
	CALORIES float NOT NULL,
	SERVING_SIZE float NOT NULL,
	PRIMARY KEY(ID)
);

CREATE TABLE PROCESS
(
	ID int NOT NULL,
	NAME varchar (255) NOT NULL,
	SIZE float NOT NULL,
	PRIMARY KEY(ID)
);

CREATE TABLE PROVIDER
(
	ID int NOT NULL,
	NAME varchar (255) NOT NULL,
	EMAIL varchar (255) NULL,
	PHONE_NUMBER varchar (255) NULL,
	HOMEPAGE varchar (255) NULL,
	PRIMARY KEY(ID)
);

CREATE TABLE FACTORY
(
	ID int NOT NULL,
	NAME varchar (255) NOT NULL,
	LOCATION varchar (255) NOT NULL,
	FLOOR_SIZE float NOT NULL,
	FK_MANAGER_ID int NOT NULL,
	PRIMARY KEY(ID),
	UNIQUE(FK_MANAGER_ID),
	FOREIGN KEY(FK_MANAGER_ID) REFERENCES MANAGER (ID)
);

CREATE TABLE ICE_CREAM_RECIPE
(
	ID int NOT NULL,
	PRICE decimal NOT NULL,
	FLAVOUR_NAME varchar (255) NOT NULL,
	DESCRIPTION varchar (255) NOT NULL,
	FK_NUTRIENT_ID int NOT NULL,
	PRIMARY KEY(ID),
	UNIQUE(FK_NUTRIENT_ID),
	FOREIGN KEY(FK_NUTRIENT_ID) REFERENCES NUTRIENT (ID),
    TYPE char (11) CHECK(TYPE in ('DESSERT_ICE', 'ICE_CREAM', 'MILK_ICE', 'SHERBET', 'WATER_ICE', 'SORBET'))
);

CREATE TABLE INGREDIENT
(
	ID int NOT NULL,
	NAME varchar (255) NOT NULL,
	MEASUREMENT_UNITS char (8) NOT NULL,
	FK_NUTRIENT_ID int NOT NULL,
	PRIMARY KEY(ID),
	UNIQUE(FK_NUTRIENT_ID),
	FOREIGN KEY(FK_NUTRIENT_ID) REFERENCES NUTRIENT (ID)
);

CREATE TABLE ICE_CREAM_PRODUCT
(
	ID int NOT NULL,
	PRICE decimal NOT NULL,
	NAME varchar (255) NOT NULL,
	DESCRIPTION varchar (255) NOT NULL,
	ICECREAM_AMOUNT float NOT NULL,
	FK_FACTORY_ID int NOT NULL,
	FK_ICE_CREAM_RECIPE_ID int NOT NULL,
	PRIMARY KEY(ID),
	FOREIGN KEY(FK_FACTORY_ID) REFERENCES FACTORY (ID),
	FOREIGN KEY(FK_ICE_CREAM_RECIPE_ID) REFERENCES ICE_CREAM_RECIPE (ID),
    PACKAGING_TYPE char (8) CHECK(PACKAGING_TYPE in ('CONE', 'BOX', 'CUP', 'ON_STICK'))
);

CREATE TABLE ICE_CREAM_RECIPE_INGREDIENT
(
	AMOUNT float NOT NULL,
	FK_INGREDIENT_ID int NOT NULL,
	FK_ICE_CREAM_RECIPE_ID int NOT NULL,
    PRIMARY KEY(FK_INGREDIENT_ID, FK_ICE_CREAM_RECIPE_ID),
	FOREIGN KEY(FK_INGREDIENT_ID) REFERENCES INGREDIENT (ID),
	FOREIGN KEY(FK_ICE_CREAM_RECIPE_ID) REFERENCES ICE_CREAM_RECIPE (ID)
);

CREATE TABLE ICE_CREAM_RECIPE_INSTRUCTION
(
	ORDERING int NOT NULL,
	CONTENT varchar (255) NOT NULL,
	FK_ICE_CREAM_RECIPE_ID int NOT NULL,
    PRIMARY KEY(ORDERING, FK_ICE_CREAM_RECIPE_ID),
	FOREIGN KEY(FK_ICE_CREAM_RECIPE_ID) REFERENCES ICE_CREAM_RECIPE (ID)
);

CREATE TABLE INGREDIENT_PROVIDER
(
	MONTHLY_PRICE decimal NOT NULL,
	MONTHLY_SUPPLY float NOT NULL,
	FK_INGREDIENT_ID int NOT NULL,
	FK_PROVIDER_ID int NOT NULL,
    PRIMARY KEY(FK_INGREDIENT_ID, FK_PROVIDER_ID),
	FOREIGN KEY(FK_INGREDIENT_ID) REFERENCES INGREDIENT (ID),
	FOREIGN KEY(FK_PROVIDER_ID) REFERENCES PROVIDER (ID)
);

CREATE TABLE RECIPE_NEEDS_PROCESSES
(
	FK_PROCESS_ID int NOT NULL,
	FK_ICE_CREAM_RECIPE_ID int NOT NULL,
    PRIMARY KEY(FK_PROCESS_ID, FK_ICE_CREAM_RECIPE_ID),
	FOREIGN KEY(FK_PROCESS_ID) REFERENCES PROCESS (ID),
	FOREIGN KEY(FK_ICE_CREAM_RECIPE_ID) REFERENCES ICE_CREAM_RECIPE (ID)
);

CREATE TABLE FACTORY_SUPPORTS_PROCESSES
(
	FK_PROCESS_ID int NOT NULL,
	FK_FACTORY_ID int NOT NULL,
	PRIMARY KEY(FK_PROCESS_ID, FK_FACTORY_ID),
	FOREIGN KEY(FK_PROCESS_ID) REFERENCES PROCESS (ID),
	FOREIGN KEY(FK_FACTORY_ID) REFERENCES FACTORY (ID)
);
