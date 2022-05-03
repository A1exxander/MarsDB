CREATE TABLE CUSTOMERS(

    EmailAddress  CHAR(64)  NOT NULL  UNIQUE,
    FirstName CHAR(16),
    LastName  CHAR(16) NULL,
    
    CONSTRAINT  PK  Primary Key(EmailAddress)
  
);

CREATE TABLE ROVER_MODELS(

    ModelName CHAR(16)  NOT NULL  UNIQUE,
    Color  CHAR(8) NOT NULL,
    EngineType  INTEGER NOT NULL,
    TopSpeed  NUMERIC(3) NOT NULL, -- Probably better to make a seperate table

    CONSTRAINT  PK  Primary Key(ModelName)
        
);

CREATE TABLE MROVER_STORES(

    StoreNumber  INTEGER  NOT NULL  UNIQUE,
    StoreAddress TEXT  NOT NULL  UNIQUE,
    StorePhoneNumber  NUMERIC(9)  NOT NULL,

    CONSTRAINT  PK Primary Key(StoreNumber AUTOINCREMENT),
    CONSTRAINT  AK UNIQUE (StoreNumber, StoreAddress) -- Not needed
  
);

CREATE TABLE STORE_ROVERS(

    RoverNumber  INTEGER  NOT NULL UNIQUE,
    StoreNumber  INTEGER  NOT NULL,
    RoverModel   CHAR(16)  NOT NULL,
    RoverMiles   INTEGER  NULL,
    CostPerDay   INTEGER  NOT NULL,
    Availible    BOOLEAN  DEFAULT 'TRUE', -- Status will be modified by a program, we could have our DB update it but probably not                                           as good
  
    CONSTRAINT  PK Primary Key(RoverNumber AUTOINCREMENT),
    CONSTRAINT  SNFK Foreign Key(StoreNumber)
    REFERENCES  MROVER_STORES(StoreNumber)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,  
    CONSTRAINT  RMFK Foreign Key(RoverModel)
    REFERENCES  ROVER_MODELS(ModelName)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
  
);

CREATE TABLE ROVER_RENTALS(

    Customer  CHAR(64)  NOT NULL,
    RoverModel CHAR(16)  NOT NULL,
    MilesDriven INT NULL,
    DayRented   DATE  NOT NULL,
    DayReturned DATE  NOT NULL,
    DaysRented  INTEGER NOT NULL, -- Use datediff function of dayRented and DayReturned OR program
    TotalCost   CURRENCY NOT NULL, -- Can be calced on DB or by our program, probably by our program is better, to do on DB do Days                                   * CostPerDat from Rover Mode 
    CONSTRAINT  CFK Primary Key(Customer, DayRented)
    CONSTRAINT  CFK Foreign Key(Customer)
    REFERENCES  CUSTOMERS(EmailAddress)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,
    CONSTRAINT  RMFK Foreign Key(RoverModel)
    REFERENCES  ROVER_MODELS(ModelName)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

INSERT INTO CUSTOMERS
VALUES('raposoalexander@gmail.com','Alexander','Raposo'), ('jose.rodriges@yahoo.com','Jose','Rodriges');

INSERT INTO MROVER_STORES(StoreAddress, StorePhoneNumber)
VALUES(
  
  "1st Main Road", 212888713
  
);

INSERT INTO ROVER_MODELS
VALUES("T90", "Red",1,90),("T90A", "Black",1,90);

INSERT INTO STORE_ROVERS(StoreNumber,RoverModel,RoverMiles,CostPerDay)
VALUES(1,"T90",0,20),(1,"T90A",0,20);

INSERT INTO ROVER_RENTALS
VALUES("raposoalexander@gmail.com", "T90",5,"2222-12-08","2222-12-09", 1,50), ("raposoalexander@gmail.com", "T90",5,"2222-12-10","2222-12-11", 2,100), ("jose.rodriges@yahoo.com", "T90A",10,"2222-12-10","2222-12-11", 2,100); -- Would like to use datediff

SELECT C.FirstName|| ' ' || C.LastName AS Name, SUM(R.MilesDriven) AS TotalMiles -- Cant use concat
FROM CUSTOMERS AS C
INNER JOIN ROVER_RENTALS AS R 
ON C.EmailAddress = R.Customer
GROUP BY C.EmailAddress
ORDER BY TotalMiles ASC



