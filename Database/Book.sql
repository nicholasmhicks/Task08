CREATE TABLE [dbo].[Book]
(
	[BookISBN] VARCHAR(100) NOT NULL PRIMARY KEY,
	[BookCard] varchar(100) NULL,
	[AuthorID] INT NOT NULL,
	[BookTitle] VARCHAR(100) NOT NULL,
	[YearPublished] INT NOT NULL, 
    CONSTRAINT [FK_Book_ToTable_Student] FOREIGN KEY ([BookCard]) REFERENCES Student([StudentId]), 
    CONSTRAINT [FK_Book_ToTable] FOREIGN KEY ([AuthorID]) REFERENCES Author([AuthorID])
)
