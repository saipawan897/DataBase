USE [master]
GO
/****** Object:  Database [MyGuitarShop]    Script Date: 6/4/2020 9:05:47 AM ******/
CREATE DATABASE [MyGuitarShop]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MyGuitarShop', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESSS\MSSQL\DATA\MyGuitarShop.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MyGuitarShop_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESSS\MSSQL\DATA\MyGuitarShop_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [MyGuitarShop] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MyGuitarShop].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MyGuitarShop] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MyGuitarShop] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MyGuitarShop] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MyGuitarShop] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MyGuitarShop] SET ARITHABORT OFF 
GO
ALTER DATABASE [MyGuitarShop] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [MyGuitarShop] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MyGuitarShop] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MyGuitarShop] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MyGuitarShop] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MyGuitarShop] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MyGuitarShop] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MyGuitarShop] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MyGuitarShop] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MyGuitarShop] SET  ENABLE_BROKER 
GO
ALTER DATABASE [MyGuitarShop] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MyGuitarShop] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MyGuitarShop] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MyGuitarShop] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MyGuitarShop] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MyGuitarShop] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MyGuitarShop] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MyGuitarShop] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MyGuitarShop] SET  MULTI_USER 
GO
ALTER DATABASE [MyGuitarShop] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MyGuitarShop] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MyGuitarShop] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MyGuitarShop] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MyGuitarShop] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MyGuitarShop] SET QUERY_STORE = OFF
GO
USE [MyGuitarShop]
GO
/****** Object:  UserDefinedFunction [dbo].[fnDiscountPrice]    Script Date: 6/4/2020 9:05:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnDiscountPrice] (@ItemID INT)
RETURNS INT
BEGIN
RETURN (SELECT (ItemPrice - DiscountAmount) AS Discount_Price
FROM MyGuitarShop.dbo.OrderItems
WHERE ItemID = @ItemID);
END;
GO
/****** Object:  UserDefinedFunction [dbo].[ItemTotal]    Script Date: 6/4/2020 9:05:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ItemTotal](@ItemID INT)
RETURNS MONEY
BEGIN
RETURN ( SELECT SUM(dbo.fnDiscountPrice(ItemID) * Quantity)
FROM OrderItems
WHERE ItemID = @ItemID);
END;
GO
/****** Object:  Table [dbo].[Products]    Script Date: 6/4/2020 9:05:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryID] [int] NULL,
	[ProductCode] [varchar](10) NOT NULL,
	[ProductName] [varchar](255) NOT NULL,
	[Description] [text] NOT NULL,
	[ListPrice] [money] NOT NULL,
	[DiscountPercent] [money] NOT NULL,
	[DateAdded] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ProductCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 6/4/2020 9:05:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[OrderDate] [datetime] NOT NULL,
	[ShipAmount] [money] NOT NULL,
	[TaxAmount] [money] NOT NULL,
	[ShipDate] [datetime] NULL,
	[ShipAddressID] [int] NOT NULL,
	[CardType] [varchar](50) NOT NULL,
	[CardNumber] [char](16) NOT NULL,
	[CardExpires] [char](7) NOT NULL,
	[BillingAddressID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItems]    Script Date: 6/4/2020 9:05:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItems](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NULL,
	[ProductID] [int] NULL,
	[ItemPrice] [money] NOT NULL,
	[DiscountAmount] [money] NOT NULL,
	[Quantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[OrderItemProducts]    Script Date: 6/4/2020 9:05:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[OrderItemProducts] AS
SELECT x.OrderID, x.OrderDate, x.TaxAmount, x.ShipDate,y.ItemPrice, y.DiscountAmount,
(y.ItemPrice-y.DiscountAmount) AS FinalPrice, y.Quantity,
((y.ItemPrice-y.DiscountAmount) * y.Quantity) AS ItemTotal, z.ProductName
FROM MyGuitarShop.dbo.Orders x JOIN MyGuitarShop.dbo.OrderItems y
ON x.OrderID = y.OrderID JOIN MyGuitarShop.dbo.Products z
ON y.ProductID = z.ProductID;

--Venkata Sai Pawan Komaravolu
GO
/****** Object:  View [dbo].[Top5LeastSelling]    Script Date: 6/4/2020 9:05:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Top5LeastSelling] AS
SELECT TOP 5 ProductName, COUNT(Quantity) OrderCount,
SUM(Quantity* ItemPrice) AS OrderTotal
FROM OrderitemProducts
GROUP BY ProductName
ORDER BY OrderCount ;

--Venkata Sai Pawan Komaravolu
GO
/****** Object:  Table [dbo].[Addresses]    Script Date: 6/4/2020 9:05:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Addresses](
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[Line1] [varchar](60) NOT NULL,
	[Line2] [varchar](60) NULL,
	[City] [varchar](40) NOT NULL,
	[State] [varchar](2) NOT NULL,
	[ZipCode] [varchar](10) NOT NULL,
	[Phone] [varchar](12) NOT NULL,
	[Disabled] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Administrators]    Script Date: 6/4/2020 9:05:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Administrators](
	[AdminID] [int] IDENTITY(1,1) NOT NULL,
	[EmailAddress] [varchar](255) NOT NULL,
	[Password] [varchar](255) NOT NULL,
	[FirstName] [varchar](255) NOT NULL,
	[LastName] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AdminID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 6/4/2020 9:05:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[CategoryName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 6/4/2020 9:05:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[EmailAddress] [varchar](255) NOT NULL,
	[Password] [varchar](60) NOT NULL,
	[FirstName] [varchar](60) NOT NULL,
	[LastName] [varchar](60) NOT NULL,
	[ShippingAddressID] [int] NULL,
	[BillingAddressID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[EmailAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Addresses] ADD  DEFAULT (NULL) FOR [Line2]
GO
ALTER TABLE [dbo].[Addresses] ADD  DEFAULT ((0)) FOR [Disabled]
GO
ALTER TABLE [dbo].[Customers] ADD  DEFAULT (NULL) FOR [ShippingAddressID]
GO
ALTER TABLE [dbo].[Customers] ADD  DEFAULT (NULL) FOR [BillingAddressID]
GO
ALTER TABLE [dbo].[Orders] ADD  DEFAULT (NULL) FOR [ShipDate]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT ((0.00)) FOR [DiscountPercent]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT (NULL) FOR [DateAdded]
GO
ALTER TABLE [dbo].[Addresses]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Categories] ([CategoryID])
GO
/****** Object:  StoredProcedure [dbo].[spUpdateProductDiscount]    Script Date: 6/4/2020 9:05:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateProductDiscount]
(
@ProductID int,
@DiscountPercent int
)
AS
BEGIN
BEGIN TRY
BEGIN TRANSACTION;
UPDATE Products set DiscountPercent = @DiscountPercent where ProductID = @ProductID;
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
IF @DiscountPercent < 0
ROLLBACK TRANSACTION;
PRINT 'DiscountPercent must be positive';
END CATCH
END
GO
USE [master]
GO
ALTER DATABASE [MyGuitarShop] SET  READ_WRITE 
GO
