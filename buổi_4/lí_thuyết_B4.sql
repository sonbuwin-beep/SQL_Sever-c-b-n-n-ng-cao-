--Buổi 4 : Thực hành 
-- CÁC HÀM LỆNH CẦN NHỚ : CREATE :TẠO BẢNG
						  -- ALTER : THAY THẾ
						  -- DROP : XÓA 
						  -- TRUNCATE : XÓA HẾT NỘI DUNG Ở CỘT (VẪN DƯ NGUYÊN CÁC THUỘC TÍNH CỦA BẢNG )
						  -- SELECT : LẤY DỮ LIỆU 
						  -- BETWEN :LẤY KHOẢN CÁCH (NOT BETWÊN THÌ NGUOƠCJ LẠI 
						  -- CÁC DẤU TOÁN TƯR : >,<,<>,= VÀ DẤU ! ĐỂ PHỦ ĐỊNH NẾU GHÉP THÊM 1 DẤU 
--1. ORDER BY ( DESC,ASC )
USE [AdventureWorksDW2022]
SELECT TOP 5  StartDate,LastName FROM DimEmployee
WHERE EndDate IS NULL
ORDER BY HireDate ASC



--BAIF 2 :50% KHACH HANG CO THU NHAP LON NHAT 
SELECT * FROM DimCustomer 
SELECT TOP 50 PERCENT  LASTNAME,Gender FROM DimCustomer
ORDER BY YearlyIncome ASC

-- BAI 3: 20 DON VI BAN LE CO DOAN THU NHO NHAT LA WAREHOUSE
SELECT top 20 
	ResellerAlternateKey,
	BusinessType,
	AnnualRevenue
FROM DimReseller
WHERE BusinessType='Warehouse' 
Order by AnnualRevenue 
 

 -- BAI 5:
 --DESC:GIẢM DẦN VÀ ASC NGƯỢC LẠI 
 SELECT * FROM FactInternetSales 
 WHERE SalesAmount BETWEEN 1000 AND 3000
 ORDER BY CustomerKey DESC

 -- BAI 6:
select 
firstname,
lastname 
from dimemployee 
where firstname <> 'kevin' and lastname <> 'kevin'

--BAI 7
select * from FactResellerSales
SELECT (SalesAmount+TaxAmt+Freight) as thanh_toan FROM FactResellerSales

--bai 8:
select * from DimProduct
select FrenchProductName , (SafetyStockLevel*ListPrice) as safetystock   from DimProduct
where  ListPrice is not null and SafetyStockLevel is not null



--BAI9:

SELECT * FROM DimProduct
SELECT SIZE,Color,ProductLine FROM DimProduct
WHERE Size IS NOT NULL AND Color LIKE '%BLACK%' OR Color LIKE  '%RED%'


--TOAN TU IN
SELECT * FROM DimCustomer
WHERE EnglishOccupation IN ('PROFESSIONAL','MANAGEMENT','SKILLED MANUAL')

--BAI11:ĐƠN HÀNG ONLINE CỦA KHÁCH CÓ GIƠI TÍNH LÀ NAM 



-- TRUY VAN LONG IN <>>>>
---Don hang online cua khach hang co gioi tinh la nam
----Ngoai: tra ve don hang online
SELECT * FROM FactInternetSales
----Trong: loc khach hang gioi tinh la nam
SELECT * FROM DimCustomer
WHERE Gender = 'M'
----Gop hai cau truy van thong toan tu IN
SELECT * FROM FactInternetSales
WHERE CustomerKey IN (
	SELECT CustomerKey FROM DimCustomer
	WHERE Gender = 'M'
)
--Ngoai: Don hang online
SELECT * FROM FactInternetSales
--Trong: San pham mau den, status la current, ...
SELECT * FROM DimProduct
WHERE Color = 'Black'
AND Status = 'Current'
AND (ListPrice - StandardCost) > 200
--Gop:
SELECT * FROM FactInternetSales
WHERE ProductKey IN (
	SELECT ProductKey FROM DimProduct
	WHERE Color = 'Black'
	AND Status = 'Current'
	AND (ListPrice - StandardCost) > 200
)
