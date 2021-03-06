﻿/*
Deployment script for master

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar LoadTestData "True"
:setvar DatabaseName "master"
:setvar DefaultFilePrefix "master"
:setvar DefaultDataPath "C:\Users\STUDENT\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB"
:setvar DefaultLogPath "C:\Users\STUDENT\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Dropping [dbo].[FK_Book_ToTable_Student]...';


GO
ALTER TABLE [dbo].[Book] DROP CONSTRAINT [FK_Book_ToTable_Student];


GO
PRINT N'Dropping [dbo].[FK_Book_ToTable]...';


GO
ALTER TABLE [dbo].[Book] DROP CONSTRAINT [FK_Book_ToTable];


GO
PRINT N'Starting rebuilding table [dbo].[Book]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Book] (
    [BookISBN]      VARCHAR (100) NOT NULL,
    [BookCard]      VARCHAR (100) NULL,
    [AuthorID]      INT           NOT NULL,
    [BookTitle]     VARCHAR (100) NOT NULL,
    [YearPublished] INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([BookISBN] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Book])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Book] ([BookISBN], [BookCard], [AuthorID], [BookTitle], [YearPublished])
        SELECT   [BookISBN],
                 [BookCard],
                 [AuthorID],
                 [BookTitle],
                 [YearPublished]
        FROM     [dbo].[Book]
        ORDER BY [BookISBN] ASC;
    END

DROP TABLE [dbo].[Book];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Book]', N'Book';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[FK_Book_ToTable_Student]...';


GO
ALTER TABLE [dbo].[Book] WITH NOCHECK
    ADD CONSTRAINT [FK_Book_ToTable_Student] FOREIGN KEY ([BookCard]) REFERENCES [dbo].[Student] ([StudentId]);


GO
PRINT N'Creating [dbo].[FK_Book_ToTable]...';


GO
ALTER TABLE [dbo].[Book] WITH NOCHECK
    ADD CONSTRAINT [FK_Book_ToTable] FOREIGN KEY ([AuthorID]) REFERENCES [dbo].[Author] ([AuthorID]);


GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/


IF '$(LoadTestData)' = 'true'

BEGIN

DELETE FROM AUthor;
DELETE FROM Book;
DELETE FROM Student;

INSERT INTO Student (StudentID, FirstName, LastName, Email, Mobile) VALUES
('s12345678', 'Fred', 'Flintstone', '12345678@student.swin.edu.au', '0400 555 111'),
('s23456789', 'Barney', 'Rubble', '23456789@student.swin.edu.au', '0400 555 222'),
('s34567890', 'Bam-Bam', 'Rubble', '34567890@student.swin.edu.au', '0400 555 333');

INSERT INTO Author (AuthorID, AuthorTFN, FirstName, LastName) VALUES
('32567', '150 111 222', 'Edgar', 'Codd'),
('76543', '150 222 333', 'Vinton', 'Cerf'),
('12345', '150 333 444', 'Alan', 'Turing');

INSERT INTO Book (BookISBN, AuthorID, BookTitle, YearPublished) VALUES
('978-3-16-148410-0', '32567', 'Relationships with Databases, the ins and outs', '1970'),
('978-3-16-148410-1', '32567', 'Normalisation, how to makea database geek fit in.', '1973'),
('978-3-16-148410-2', '76543', 'TCP/IP, the protocol for themasses.', '1983'),
('978-3-16-148410-3', '12345', 'The Man, the Bombe, and theEnigma.', '1940');

END;
GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Book] WITH CHECK CHECK CONSTRAINT [FK_Book_ToTable_Student];

ALTER TABLE [dbo].[Book] WITH CHECK CHECK CONSTRAINT [FK_Book_ToTable];


GO
PRINT N'Update complete.';


GO
