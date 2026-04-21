--© 2024 By BK Fintech - Rikkei Education - All rights reserved. 17
--Thực hành JOIN bảng
--Bài tập 1: Công ty muốn gửi quà tri ân đến các khách hàng VIP. Trả về MỘT
--bảng kết quả có các cột sau SalesOrderNumber, ProductKey,
--OrderQuantity, SalesAmount (FactInternetSales), Email, Phone
--(DimCustomer), Size (DimProduct). Chỉ lấy các bản ghi có Class của
--product là H


--HE SO BIEN THIEN CUA BANG SALES  TINH AVG - TINH STDEV ->STDEV/AVG
SELECT AVG(SalesAmount),STDEV(SalesAmount), STDEV(SalesAmount)/AVG(SalesAmount) AS CV FROM FactInternetSales

SELECT (STDEV(SalesAmount)/AVG(SalesAmount)) AS CV FROM FactResellerSales


-- LÍ THUYẾT 
--Sử dụng các phép JOIN để trả về bảng sau đây biết đây là sự kết hợp giữa hai
--bảng DimEmployee và FactResellerSales theo cột Employeekey

SELECT 
	* 
FROM 
	DimEmployee AS A INNER JOIN FactResellerSales AS B 
		ON A.EmployeeKey=B.EmployeeKey


--© 2024 By BK Fintech - Rikkei Education - All rights reserved. 17
--Thực hành JOIN bảng
--bài tập 1: Công ty muốn gửi quà tri ân đến các khách hàng VIP. Trả về MỘT
--bảng kết quả có các cột sau SalesOrderNumber, ProductKey,
--OrderQuantity, SalesAmount (FactInternetSales), Email, Phone
--(DimCustomer), Size (DimProduct). Chỉ lấy các bản ghi có Class của
--product là H
SELECT 
		OrderQuantity,
		SalesAmount,
		EmailAddress,
		Phone,
		Size,
		Class
FROM 
	DimProduct AS A
	INNER JOIN FactInternetSales AS B ON A.ProductKey=B.ProductKey
	INNER JOIN DimCustomer AS C ON B.CustomerKey=C.CustomerKey
	WHERE Class ='H'

	SELECT EmailAddress FROM DimCustomer


--Bài tập 2: Xét trong năm 2013, có đúng là nghề nghiệp bậc càng cao thì
--càng chi nhiều tiền (SalesAmount) vào sản phẩm có Class cao ? (L: Low,
--M:Medium, H:High
SELECT 
	EnglishOccupation,

	Class,
	
	SUM(SalesAmount)
	


	
FROM 
	DimEmployee AS A 
	INNER JOIN FactInternetSales AS B ON A.SalesTerritoryKey=B.SalesTerritoryKey
	INNER JOIN DimProduct AS C ON B.ProductKey=C.ProductKey
	INNER JOIN DimCustomer AS D ON D.CustomerKey=B.CustomerKey

	WHERE YEAR(DUEDATE)=2013 AND CLASS IS NOT NULL
	GROUP BY Class,EnglishOccupation
	ORDER BY Class DESC
	
	
	

	

	--© 2024 By BK Fintech - Rikkei Education - All rights reserved. 19
--Thực hành JOIN bảng
--Bài tập 5: Chọn ra các mặt hàng được mua online (trong bảng
--FactInternetSales) có độ dài tên trên 5 ký tự và ký tự cuối là một số bất kỳ
--từ 0 đến 9. Sắp xếp kết quả trả về tổng (SalesAmount + TaxAmount +
--Freight) giảm dần
SELECT 
	EnglishProductName,
	TaxAmt,Freight,
	(SalesAmount + TaxAmt +Freight) AS TONG
FROM FactInternetSales AS A
INNER JOIN DimProduct AS B 
ON A.ProductKey=B.ProductKey
WHERE EnglishProductName LIKE '_____%[0-9]' 
ORDER BY (SalesAmount + TaxAmt +Freight) DESC