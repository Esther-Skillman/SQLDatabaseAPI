IF OBJECT_ID('CW2.[Favourite_Activities]', 'V') IS NOT NULL
    DROP VIEW CW2.[Favourite_Activities];
GO

-- Drop the UsersData table if it exists
IF OBJECT_ID(N'CW2.UserData', N'U') IS NOT NULL 
BEGIN
    DROP TABLE CW2.UserData; 
END

-- Drop the FavouriteActivities table if it exists
IF OBJECT_ID(N'CW2.FavouriteActivities', N'U') IS NOT NULL 
BEGIN
    DROP TABLE CW2.FavouriteActivities; 
END

-- Drop the Users table if it exists
IF OBJECT_ID(N'CW2.Users', N'U') IS NOT NULL 
BEGIN
    DROP TABLE CW2.Users; 
END

-- Drop the _EFMigrationsHistory table if it exists
IF OBJECT_ID(N'dbo.__EFMigrationsHistory', N'U') IS NOT NULL 
BEGIN
    DROP TABLE dbo.__EFMigrationsHistory;
END

-- Drop the UsersData table if it exists
IF OBJECT_ID(N'dbo.UserData', N'U') IS NOT NULL 
BEGIN
    DROP TABLE dbo.UserData; 
END

-- Drop the FavouriteActivities table if it exists
IF OBJECT_ID(N'dbo.FavouriteActivities', N'U') IS NOT NULL 
BEGIN
    DROP TABLE dbo.FavouriteActivities; 
END

-- Drop the Users table if it exists
IF OBJECT_ID(N'dbo.Users', N'U') IS NOT NULL 
BEGIN
    DROP TABLE dbo.Users; 
END

-- Create Users table
CREATE TABLE CW2.Users
(
    UserNo INT NOT NULL IDENTITY(1,1),
    userStatus CHAR(255) NOT NULL,
    Username CHAR(81) NOT NULL,
    Email VARCHAR(320) NOT NULL,
    userPassword VARCHAR(Max) NOT NULL, 

    CONSTRAINT pk_Users PRIMARY KEY (UserNo),
    CONSTRAINT UQ_Email UNIQUE (Email) -- Assuming Email is unique for each user
);
SET IDENTITY_INSERT CW2.Users ON;

-- Insert into Users table sample data
INSERT INTO CW2.Users (UserNo, userStatus, Username, Email, userPassword)
VALUES (1, 'Admin', 'Grace Hopper', 'grace@plymouth.ac.uk', 'ISAD123!');
INSERT INTO CW2.Users (UserNo, userStatus, Username, Email, userPassword)
VALUES (2, 'Admin', 'Tim Berners-Lee', 'tim@plymouth.ac.uk', 'COMP2000!');
INSERT INTO CW2.Users (UserNo, userStatus, Username, Email, userPassword)
VALUES (3, 'Admin', 'Ada Lovelace', 'ada@plymouth.ac.uk', 'insecurePassword');

-- Create UserData table
CREATE TABLE CW2.UserData 
( 
    Email VARCHAR(320) NOT NULL,   
    AboutMe VARCHAR(720) DEFAULT NULL,
    MemberLocation VARCHAR(Max)  DEFAULT 'Plymouth, Devon, England', 
    Units CHAR(255) DEFAULT 'Metric'
        CHECK (Units IN('Imperial', 'Metric')),
    ActivityTimePreference CHAR(255) DEFAULT 'Pace'
        CHECK (ActivityTimePreference IN('Speed', 'Pace')),
    userHeight DECIMAL(5, 1)  DEFAULT NULL,
    userWeight INT  DEFAULT NULL,
    Birthday DATE DEFAULT NULL,
    MarketingLanguage CHAR(255) DEFAULT 'English(UK)'
        CHECK (MarketingLanguage IN('English (US)', 'English(UK)', 'Dansk (Danmark)','Deutsch (Deutschland)', 'Español (España)', 'Español (Latinoamérica)', 'Français (France)', 'Italiano (Italia)', 'Nederlands (Nederland)', 'Norsk bokmål (Norge)', 'Polski (Polska)', 'Português (Brasil)', 'Português (Portugal)', 'Svenska (Sverige)' )),  

    CONSTRAINT PK_UserData PRIMARY KEY (Email),
    CONSTRAINT FK_UserData_Users FOREIGN KEY (Email) REFERENCES CW2.Users (Email)
); 

-- Insert into UserData table sample data
INSERT INTO CW2.UserData(Email)
VALUES('grace@plymouth.ac.uk');
INSERT INTO CW2.UserData(Email)
VALUES('tim@plymouth.ac.uk');
INSERT INTO CW2.UserData(Email)
VALUES('ada@plymouth.ac.uk');

-- Create FavouriteActivities table
CREATE TABLE CW2.FavouriteActivities
(
    UserNo INT NOT NULL,
    Activities CHAR(255) DEFAULT 'Backpacking',
    CHECK (Activities IN('Backpacking', 'Bike Touring', 'Bird Watching','Camping', 'Cross-country Skiing', 'Fishing', 'Hiking', 'Horse Riding', 'Mountain Biking', 'OHV/Off-road Driving', 'Paddle Sports', 'Road Biking', 'Rock Climbing', 'Running', 'Scenic Driving', 'Skiing', 'Snowshoeing', 'Via Ferrata', 'Walking')),  
    FavouriteActivities BIT DEFAULT 0,
    CHECK (FavouriteActivities IN (0, 1)),
    CONSTRAINT PK_FavouriteActivities PRIMARY KEY (UserNo, Activities),
    CONSTRAINT FK_FavouriteActivities_Users FOREIGN KEY (UserNo) REFERENCES CW2.Users (UserNo)
);

-- Insert into FavouriteActivities table sample data
INSERT INTO CW2.FavouriteActivities(UserNo, Activities, FavouriteActivities)
VALUES
(1,'Backpacking', 0),
(1,'Bike Touring', 1),
(1,'Bird Watching', 0),
(1,'Camping', 0),
(1,'Cross-country Skiing', 0),
(1,'Fishing', 0),
(1,'Hiking', 0),
(1,'Horse Riding', 0),
(1,'Mountain Biking', 0),
(1,'OHV/Off-road Driving', 0),
(1,'Paddle Sports', 0),
(1,'Road Biking', 0),
(1,'Running', 0),
(1,'Scenic Driving', 0),
(1,'Skiing', 0),
(1,'Snowshoeing', 0),
(1,'Via Ferrata', 0),
(1,'Walking', 0),

(2,'Backpacking', 0),
(2,'Bike Touring', 1),
(2,'Bird Watching', 0),
(2,'Camping', 0),
(2,'Cross-country Skiing', 1),
(2,'Fishing', 1),
(2,'Hiking', 0),
(2,'Horse Riding', 0),
(2,'Mountain Biking', 0),
(2,'OHV/Off-road Driving', 0),
(2,'Paddle Sports', 0),
(2,'Road Biking', 0),
(2,'Running', 0),
(2,'Scenic Driving', 0),
(2,'Skiing', 0),
(2,'Snowshoeing', 1),
(2,'Via Ferrata', 0),
(2,'Walking', 0),

(3,'Backpacking', 0),
(3,'Bike Touring', 0),
(3,'Bird Watching', 0),
(3,'Camping', 0),
(3,'Cross-country Skiing', 1),
(3,'Fishing', 0),
(3,'Hiking', 0),
(3,'Horse Riding', 0),
(3,'Mountain Biking', 0),
(3,'OHV/Off-road Driving', 0),
(3,'Paddle Sports', 0),
(3,'Road Biking', 0),
(3,'Running', 0),
(3,'Scenic Driving', 0),
(3,'Skiing', 0),
(3,'Snowshoeing', 1),
(3,'Via Ferrata', 0),
(3,'Walking', 0);

-- View

IF OBJECT_ID('CW2.[FavouriteActivitiesView]', 'V') IS NOT NULL
    DROP VIEW CW2.[FavouriteActivitiesView];
GO

CREATE VIEW CW2.[FavouriteActivitiesView] AS
SELECT u.UserNo, u.Username, fa.Activities
FROM CW2.Users u
JOIN CW2.FavouriteActivities fa ON u.UserNo = fa.UserNo
WHERE fa.FavouriteActivities = 1;
GO

--Delete Stored Procedures & Trigger --

IF OBJECT_ID('CW2.InsertUser', 'P') IS NOT NULL
    DROP PROCEDURE CW2.InsertUser;
GO

IF OBJECT_ID('CW2.UpdateUser', 'P') IS NOT NULL
    DROP PROCEDURE CW2.UpdateUser;
GO

IF OBJECT_ID('CW2.DeleteUser', 'P') IS NOT NULL
    DROP PROCEDURE CW2.DeleteUser;
GO

IF OBJECT_ID('CW2.updateUnit', 'P') IS NOT NULL
    DROP PROCEDURE CW2.updateUnit;
GO

IF OBJECT_ID('CW2.convertUnit', 'TR') IS NOT NULL
    DROP TRIGGER CW2.convertUnit;
GO

--Create Stored Procedures--

-- InsertUser Stored Procedure

CREATE PROCEDURE CW2.InsertUser
@Username CHAR(81), 
@Email VARCHAR(320), 
@Password VARCHAR(Max)
AS
BEGIN
    SET IDENTITY_INSERT CW2.Users OFF;

    INSERT INTO CW2.Users (userStatus, Username, Email, userPassword)
    VALUES ('Active', @Username, @Email, @Password);

    DECLARE @UserNo INT;
    SET @UserNo = SCOPE_IDENTITY();

    INSERT INTO CW2.UserData (Email)
    VALUES (@Email);

    INSERT INTO CW2.FavouriteActivities (UserNo, Activities)
    VALUES 
    (@UserNo,'Backpacking'),
    (@UserNo,'Bike Touring'),
    (@UserNo,'Bird Watching'),
    (@UserNo,'Camping'),
    (@UserNo,'Cross-country Skiing'),
    (@UserNo,'Fishing'),
    (@UserNo,'Hiking'),
    (@UserNo,'Horse Riding'),
    (@UserNo,'Mountain Biking'),
    (@UserNo,'OHV/Off-road Driving'),
    (@UserNo,'Paddle Sports'),
    (@UserNo,'Road Biking'),
    (@UserNo,'Running'),
    (@UserNo,'Scenic Driving'),
    (@UserNo,'Skiing'),
    (@UserNo,'Snowshoeing'),
    (@UserNo,'Via Ferrata'),
    (@UserNo,'Walking');
END;
GO


CREATE PROCEDURE CW2.UpdateUser
@Email VARCHAR(320),
@Password VARCHAR(MAX),
@newEmail VARCHAR(320),
@newUsername CHAR(81) = NULL, 
@newPassword VARCHAR(MAX) = NULL,
@newAboutMe VARCHAR(720) = NULL,
@newMemberLocation VARCHAR(MAX) = NULL,
@newUnits CHAR(255) = NULL,
@newActivityTimePreference CHAR(255) = NULL,
@newUserHeight DECIMAL(5, 1)  = NULL,
@newUserWeight INT  = NULL,
@newBirthday DATE = NULL,
@newMarketingLanguage CHAR(255) = NULL
AS
BEGIN
        -- Check if the email and password are correct
        IF EXISTS (
            SELECT 1
            FROM CW2.Users
            WHERE Email = @Email AND userPassword = @Password
        )
        -- Disable the foreign key constraint
        ALTER TABLE CW2.UserData NOCHECK CONSTRAINT FK_UserData_Users;

        -- Update UserData table
        UPDATE CW2.UserData
        SET Email = ISNULL(@newEmail, Email), -- Sets the not-null value
            AboutMe = ISNULL(@newAboutMe, AboutMe),
            MemberLocation = ISNULL(@newMemberLocation, MemberLocation),
            Units = ISNULL(@newUnits, Units),
            ActivityTimePreference = ISNULL(@newActivityTimePreference, ActivityTimePreference),
            userWeight = ISNULL(@newUserWeight, userWeight),
            userHeight = ISNULL(@newUserHeight, userHeight),
            Birthday = ISNULL(@newBirthday, Birthday),
            MarketingLanguage = ISNULL(@newMarketingLanguage, MarketingLanguage)
        WHERE Email = @Email;
        
        -- Update Users table
        UPDATE CW2.Users
        SET Username = ISNULL(@newUsername, Username),
            userPassword = ISNULL(@newPassword, userPassword),
            Email = ISNULL(@newEmail, Email)
        WHERE Email = @Email;

        -- Re-enable the foreign key constraint
        ALTER TABLE CW2.UserData WITH CHECK CHECK CONSTRAINT FK_UserData_Users;

END;
GO

--DeleteUser Stored Procedure (for admin)

CREATE PROCEDURE CW2.DeleteUser
    @Email VARCHAR(320)-- Changed from @UserNo
AS
BEGIN
    UPDATE CW2.Users
    SET userStatus = 'Archived'
    WHERE Email = @Email;
END;
GO

--Trigger--

CREATE TRIGGER CW2.convertUnit
ON CW2.UserData
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Units) -- Checks if the Units column was updated
    BEGIN
        DECLARE @newUnits CHAR(255);
        SELECT @newUnits = Units FROM INSERTED;

        IF @newUnits = 'Metric'
        BEGIN
            UPDATE CW2.UserData
            SET userHeight = ROUND(userHeight * 0.3048, 0),
            userWeight = ROUND(userWeight / 2.205, 0);
        END

        IF @newUnits = 'Imperial'
        BEGIN
            UPDATE CW2.UserData
            SET userHeight = ROUND(userHeight / 30.48, 1),
            userWeight = ROUND(userWeight * 2.205, 0);
        END
    END
END;
GO

