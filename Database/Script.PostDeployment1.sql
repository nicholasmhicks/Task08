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
