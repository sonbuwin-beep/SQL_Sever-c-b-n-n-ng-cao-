	USE [AdventureWorksDW2022]
	GO

	--   CHƯƠNG 3 (TIẾP THEO) THỰC HÀNH SQL: CÁC KỸ THUẬT PHỔ BIẾN (PHẦN 1)
	--Các hàm tinh toan : SUM, MIN, MAX, AVG 
	--Các hàm thống kê cơ bản : Mean - Mode - Median
	
	--VIDU: Tính mode, mean, và median với cột SalesAmount trong bảng FactInternetSales
	SELECT 
		COUNT(SalesAmount) AS COUNT,MAX(SalesAmount)AS MAX,MIN(SalesAmount) AS MIN,AVG(SalesAmount) AS AVG
	FROM 
		FactInternetSales


		--Thống kê cơ bản
--Bài tập 1: Tính tổng AnnualRevenue theo BusinessType. Chọn ra những BusinessType có trên 15.000.000

SELECT 
	BusinessType,SUM(AnnualRevenue) AS SUM
FROM 
	DimReseller
WHERE AnnualRevenue > 15.000000
GROUP BY BusinessType


--Bài tập 2: Thống kê tổng doanh số (SalesAmount) theo từng khách hàng trong 
--bảng FactResellerSales? TOP 10 khách hàng chi tiêu nhiều nhất trong năm 2012?


-- CACH1:
SELECT 
	TOP 10 SUM(SalesAmount),DueDate,EmployeeKey
FROM 
	FactResellerSales
WHERE YEAR(DUEDATE) IN (2012)
GROUP BY DueDate,EmployeeKey



--CACH2:
SELECT 
	TOP 10 A.LastName,SUM(B.SalesAmount)AS SUM 
FROM 
	DimEmployee AS A INNER JOIN FactResellerSales AS B 
	ON A.EmployeeKey=B.EmployeeKey
WHERE 
	YEAR(B.DueDate) IN (2012) 
GROUP BY 
	A.LastName
ORDER BY 
	SUM(B.SalesAmount) DESC



--Bài tập 3: Thống kê các nhân viên (EmployeeKey) có tổng doanh số lớn hơn 3tr 
--trong bảng FactResellerSales để trao thưởng
SELECT 
	A.LastName,SUM(B.SalesAmount) 
FROM 
	DimEmployee AS A INNER JOIN  FactResellerSales AS B 
ON A.EmployeeKey=B.EmployeeKey
WHERE 
	B.SalesAmount > 3000.000
GROUP BY 
	A.LastName




--Bài tập 4: Tổng doanh số theo nhân viên và theo năm
SELECT 
	A.LastName,SUM(B.SalesAmount) ,YEAR(B.DueDate) AS YEAR
FROM 
	DimEmployee AS A INNER JOIN  FactResellerSales AS B 
ON A.EmployeeKey=B.EmployeeKey
GROUP BY 
	A.LastName,YEAR(B.DueDate)


--Toán tử logic - Xử lý giá trị NULL
--Bài tập 1: Lọc tất cả các sản phẩm có số Size
SELECT 
	ProductAlternateKey,Size 
FROM 
	DimProduct
WHERE Size IS NOT NULL


--ài tập 2: Lọc ra tất cả các sản phẩm có màu sắc

SELECT 
	ProductAlternateKey,Color
FROM 
	DimProduct
WHERE Color IS NOT NULL



--Bài tập 3: Lọc ra tất cả các sản phẩm có số Size và có màu thuộc Red, Black, 
--Silver, Yellow
SELECT 
	ProductAlternateKey,Color,SIZE
FROM 
	DimProduct
WHERE 
	Color IS NOT NULL AND ProductAlternateKey IS NOT NULL AND COLOR IN ('Red', 'Black', 'Silver', 'Yellow') AND SIZE IS NOT NULL


----Date function
--1. DATEADD: cộng hoặc trừ ngày, tháng, năm
--DATEADD(interval, number, date)
--2. DATEDIFF: trả về sự khác biệt giữa hai date
--DATEDIFF(interval, date1, date2)
--3. DAY, MONTH, YEAR: trích ngày, tháng, năm trong date
--DAY(date), MONTH(date), YEAR(date)

--Lưu ý: interval có thể là Year, Quarter, Month, Day, Week, Hour, Minute, Second, DayOfYear, WeekDay


--Bài tập 1: Tách cột OrderDate trong bảng FactInternetSales thành ba cột Year, 
--Month, Day tương ứng. Lọc ra những đơn hàng được đặt vào tháng 5 năm 2012.

SELECT
		B.SpanishProductName,
		DAY(A.OrderDate) AS DAY ,
		MONTH(A.OrderDate) AS MONTH,
		YEAR(A.OrderDate) AS YEAR
FROM
	FactInternetSales AS A
INNER JOIN DimProduct AS B 
ON 
	A.ProductKey=B.ProductKey
WHERE YEAR(OrderDate) IN (2012) AND MONTH(OrderDate) IN (5)


---Toán tử logic - LIKE statement
--Bài tập 1: Trả về khách hàng có địa chỉ email bắt đầu bằng chữ s, theo sau 
--là 4 ký tự bất kỳ, và nối tiếp là ký tự “on”
SELECT * FROM DimCustomer
WHERE EmailAddress LIKE 's____ON%'

--Bài tập 2: Trả về các khách hàng Reseller (trong bảng DimReseller) có địa 
--chỉ ở Free Street
SELECT 
	* 
FROM
	DimReseller
WHERE AddressLine1 like'%Free Street%'


--Bài tập 3: Trả về danh sách các sản phẩm (trong bảng DimProduct) áo dài tay 
--để bán cho mùa lạnh, biết mã các sản phẩm này (ProductAlternateKey) bắt đầu bằng chữ LJ


SELECT 
		A.EnglishProductName,
		B.ProductAlternateKey 
FROM 
	DimProduct AS A
INNER JOIN DimProduct AS B 
ON 
	A.ProductKey=B.ProductKey
WHERE 
	B.ProductAlternateKey LIKE 'LJ%'


--Các hàm xử lý chuỗI
--Bài tập: Từ bản DimEmployee trả về các kết quả sau của từng nhân viên:
--• Độ dài email
--• Ký tự thứ 2 từ trái qua trong email
--• Ký tự thứ 3 từ phải qua trong email
--• Trả về vị trí của ký tự ‘@’ trong email
--• Thêm 1 cột có giá trị các dòng là email tuy nhiên ký tự @ được thay bằng ký tự ‘-’
--• Trả về 6 ký tự bắt đầu từ vị trí thứ 3 trong email
SELECT 
	EMAILADDRESS,
	LEN(EMAILADDRESS) AS LEN,
	LEFT(EMAILADDRESS,2) AS TRAI,
	RIGHT(EMAILADDRESS,3) AS PHAI,
	CHARINDEX('@',EMAILADDRESS) AS VITRI,
	REPLACE(EMAILADDRESS,'@','-') AS THAYDOI,
	SUBSTRING(EMAILADDRESS,3,6) AS VITRI3
FROM 
	DimEmployee



--Hàm lồng nhau (Nesting function)
--Bài tập 1: Trích username (phần trước dấu @) trong email của nhân viên
SELECT 
	EmailAddress,
	REPLACE(LEFT(EmailAddress,CHARINDEX('@',EmailAddress)),'@','')
FROM 
	DimCustomer



--Bài tập thực hành (1/3)

--Bài tập 1: Chọn top 10 nhân viên có full name dài nhất
SELECT 
	TOP 10 FULLNAME,LEN(FULLNAME) AS LEN
FROM 
	(SELECT 
		FULLNAME=FirstName+MiddleName+LastName,EmailAddress
	 FROM
		DimEmployee) AS NAME1
WHERE 
	FULLNAME IS NOT NULL 
ORDER BY LEN(FULLNAME) DESC


--Bài tập 2: Trong bảng DimEmployee, trả về cột ID bao gồm những ký tự 
--sau ‘\’ trong cột LoginID. Đưa ra top 10 nhân viên có ID dài nhất	

	SELECT TOP 10 
		LOGINID, 
		RIGHT(LOGINID,LEN(LOGINID)-LEN(LEFT(LOGINID, CHARINDEX('\',LOGINID)))) AS PHANCAT,
		LEN(RIGHT(LOGINID,LEN(LOGINID)-LEN(LEFT(LOGINID, CHARINDEX('\',LOGINID))))) AS LEN_PHANCAT

	FROM DimEmployee
	ORDER BY LEN(RIGHT(LOGINID,LEN(LOGINID)-LEN(LEFT(LOGINID, CHARINDEX('\',LOGINID))))) DESC
	

--Bài tập 3: Trả về các sản phẩm có 2 chữ cái đầu trong tên tiếng anh 
--giống với 2 chữ cái cuối trong tên tiếng pháp. Sắp xếp kết quả trả về theo 
--thứ tự tỷ lệ ListPrice và StandardCost giảm dần


SELECT 
	FrenchProductName,
	RIGHT(FrenchProductName,2) AS PHAP ,
	EnglishProductName,
	LEFT(EnglishProductName,2) AS ANH ,
	ListPrice,
	StandardCost
FROM 
	DimProduct
WHERE 
	FrenchProductName IS NOT NULL AND EnglishProductName IS NOT NULL
	AND RIGHT(FrenchProductName,2)IN (LEFT(EnglishProductName,2))
ORDER BY ListPrice,StandardCost DESC




--Bài tập 4: Tìm sản phẩm có tên không chứa màu sắc và size tương ứng trong bảng DimProduc

SELECT 
	EnglishProductName,
	SIZE,
	COLOR 
FROM DimProduct
WHERE  CHARINDEX(ISNULL(SIZE,''),EnglishProductName) =0 
   AND CHARINDEX(ISNULL(COLOR,''),EnglishProductName)=0


--Bài tập 5: Chọn ra các mặt hàng được mua online (trong bảng 
--FactInternetSales) có độ dài tên trên 5 ký tự và ký tự cuối là một số bất kỳ 
--từ 0 đến 9. Sắp xếp kết quả trả về tổng (SalesAmount + TaxAmount + 
--Freight) giảm dần

SELECT 
	A.SalesAmount,
	A.TaxAmt,A.Freight,
	B.EnglishProductName,
	TONG=(A.SalesAmount+A.TaxAmt+A.Freight) 
FROM FactInternetSales AS A
INNER JOIN DimProduct AS B 
ON 
	A.ProductKey=B.ProductKey
WHERE B.EnglishProductName LIKE '%_____%[0-9]'
ORDER BY TONG DESC


--
--Bài tập 6: Viết một câu truy vấn để tìm tất cả các khách hàng (DimCustomer) có 
--tên bắt đầu với "A" hoặc "B", và có tổng doanh thu từ các đơn hàng trong bảng 
--FactInternetSales lớn hơn 10.000 USD.

SELECT 
	A.FirstName,
	B.UnitPrice 
FROM 
	DimCustomer AS A INNER JOIN FactInternetSales AS B
ON 
	A.CustomerKey=B.CustomerKey
WHERE A.FirstName LIKE '[a,B]%' AND B.UnitPrice >10.000
			
--Bài tập 2: Viết câu truy vấn để tìm các đơn hàng online có ngày bán trong năm 
--2013. Hiển thị tháng và tổng doanh thu của mỗi tháng. Chỉ lọc các tháng có tổng 
--doanh thu trên 10,000 USD.
SELECT 
	B.FirstName,
	MONTH(A.DueDate) AS MONTH,
	YEAR(A.DueDate) ,
	COUNT(A.SalesAmount)
FROM
	FactInternetSales AS A INNER JOIN DimCustomer AS B 
	ON
		A.CustomerKey=B.CustomerKey
WHERE YEAR(A.DueDate) IN (2013) AND A.SalesAmount > 10.000


--Bài tập 3: Viết câu truy vấn để tìm các sản phẩm có doanh thu vượt quá 10.000 
--USD trong năm 2013. Hiển thị ProductKey, tổng doanh thu và phân loại sản phẩm 
--là "Top Seller" nếu doanh thu vượt quá 50.000 USD, và "Regular Seller" nếu không. 
--Cho biết các sản phẩm áo dài tay có thuộc top seller không?
SELECT 
	YEAR(A.DueDate) AS YEAR,
	SUM(A.SalesAmount) AS SUM ,
	B.ProductKey,
	B.EnglishProductName,
CASE 
	WHEN A.SalesAmount < 50.000
	THEN 'Regular Seller' 
	WHEN A.SalesAmount >50.000 
	THEN 'Top Seller'
END AS KET_QUA


FROM
	FactInternetSales AS A INNER JOIN DimProduct AS B
	ON
		A.ProductKey=B.ProductKey
WHERE YEAR(A.DueDate) IN (2013) AND A.SalesAmount > 10.000 AND B.EnglishProductName LIKE '%Long-Sleeve Logo Jersey%'
GROUP BY YEAR(A.DueDate) ,
	A.SalesAmount,
	B.ProductKey,
	B.EnglishProductName
HAVING A.SalesAmount >10.000
ORDER BY COUNT(A.SalesAmount) 

--Bài tập 4: Viết một câu truy vấn để tìm danh sách khách hàng có đơn hàng 
--online trong năm 2012. Hiển thị CustomerKey, FullName, tổng doanh thu 
--(TotalSalesAmount), và phân loại theo mùa (Winter, Spring, Summer, Fall) dựa 
--trên tháng đơn hàng được tạo ra


--Tháng 12, 1, 2: Winter

--Tháng 3, 4, 5: Spring

--Tháng 6, 7, 8: Summer

--Tháng 9, 10, 11: Fall

SELECT
	B.CustomerKey,
	FULLNAME=ISNULL((B.LASTNAME+B.MIDDLENAME+B.FIRSTNAME),''),
	MONTH(DUEDATE) AS MONTH,
	YEAR(DUEDATE) AS YEAR ,
CASE 
	WHEN MONTH(DUEDATE) IN  (12,1,2) THEN 'Winter'
	WHEN MONTH(DUEDATE) IN  (3,4,5) THEN 'Spring'
	WHEN MONTH(DUEDATE) IN  (6,7,8) THEN 'Summer'
	WHEN MONTH(DUEDATE) IN  (9,10,11) THEN 'Fall'
END 
	MUA

FROM FactInternetSales AS A
 INNER JOIN DimCustomer AS B
 ON A.CustomerKey=B.CustomerKey
 WHERE YEAR(DUEDATE) IN (2012)
 ORDER BY MONTH(DUEDATE)


 --Bài tập 5: Tìm khách hàng có tổng doanh thu lớn hơn doanh thu trung bình của 
--các khách hàng có tổng doanh thu lớn hơn doanh thu trung bình của tất cả 
--khách hàng trong năm 2012. Những khách hàng này đến từ khu vực địa lý nào?

--KH>KV>2012

WITH 
	Fact AS (
		SELECT 
			B1.CustomerKey,
			B1.ProductKey 
		FROM FactInternetSales AS B1
	),

	CUSTEMER AS (
		SELECT 
			B2.CustomerKey,
			B2.FirstName,
			B2.GeographyKey 
		FROM DimCustomer AS B2
	),

	GEO AS (
		SELECT 
			B3.GeographyKey,
			B3.CountryRegionCode,
			B3.City 
		FROM DimGeography AS B3
	),

	FACT_1 AS (
		SELECT 
			CustomerKey, 
			SUM(B11.SalesAmount) AS SUM 
		FROM FactInternetSales AS B11
		GROUP BY B11.CustomerKey 
	),

	FACT_2 AS (
		SELECT 
			CustomerKey,
			AVG(B22.SalesAmount) AS AVG 
		FROM FactInternetSales AS B22
		WHERE YEAR(B22.DueDate) = 2012
		GROUP BY B22.CustomerKey
	),

	SOSANH AS (
		SELECT 
			B12.SUM,
			B21.AVG,
			B12.CustomerKey 
		FROM FACT_1 AS B12 
		INNER JOIN FACT_2 AS B21 ON B12.CustomerKey = B21.CustomerKey
		WHERE B12.SUM > B21.AVG 
	),

	TEN AS (
		SELECT 
			City,
			CountryRegionCode,
			CustomerKey,
			B333.FirstName 
		FROM GEO AS B222 
		INNER JOIN CUSTEMER AS B333 ON B222.GeographyKey = B333.GeographyKey
	),

	HOANTHANH AS (
		SELECT  
			HT1.FirstName,
			HT1.City,
			HT1.CountryRegionCode,
			HT2.SUM,
			HT2.AVG 
		FROM TEN AS HT1 
		INNER JOIN SOSANH AS HT2 ON HT1.CustomerKey = HT2.CustomerKey
	)
			
SELECT * FROM HOANTHANH



