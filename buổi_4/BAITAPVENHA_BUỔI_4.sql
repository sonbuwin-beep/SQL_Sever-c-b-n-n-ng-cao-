USE [AdventureWorksDW2022]
GO
--Bài tập 1:
--Viết truy vấn để trả về bảng kết quả bao gồm các cột sau từ bảng DimAccount:
--AccountKey, AccountDescription, AccountType.

SELECT AccountKey,AccountDescription,AccountType
	FROM 
		DimAccount

--Bài tập 2:
--Viết truy vấn trả về bảng kết quả bao gồm các cột sau từ bảng DimCustomer:
--CustomerKey, FirstName, MiddleName, LastName, BirthDate, MaritalStatus, Gender,
--EmailAddress.
--(Nâng cao) Thêm một cột FullName, là kết hợp của các cột FirstName, MiddleName
--và LastName.
--Gợi ý: Sử dụng toán tử cộng chuỗi + và xử lý khoảng trắng giữa các tên.
SELECT 
	CustomerKey,FirstName,MiddleName,LastName,BirthDate,BirthDate,MaritalStatus,Gender,EmailAddress,FullName=(FirstName+MiddleName+LastName)
		FROM
			DimCustomer
			WHERE MiddleName IS NOT NULL

--Bài tập 3:
--Truy vấn bảng FactInternetSales trả về các cột OrderDate, ProductKey, CustomerKey,
--SalesAmount, OrderQuantity, UnitPrice. Sắp xếp cột OrderDate theo thứ tự tăng dần 
SELECT 
	OrderDate,ProductKey,CustomerKey,SalesAmount,OrderQuantity,UnitPrice
		FROM 
			FactInternetSales
			ORDER BY OrderDate ASC
			
--Bài tập 4:
--Truy vấn bảng FactResellerSales trả về các cột OrderDate, ProductKey,
--CustomerPONumber, SalesAmount, OrderQuantity, UnitPrice. Sắp xếp cột OrderDate
--theo thứ tự tăng dần và cột ProductKey theo thứ tự tăng dần và SalesAmount theo
--thứ tự giảm dần.
SELECT 
	OrderDate,ProductKey,CustomerPONumber,SalesAmount,OrderQuantity,UnitPrice
		FROM
			FactResellerSales
			
			ORDER BY OrderDate,ProductKey ASC  , SalesAmount DESC


--Truy vấn WHERE cơ bản
--Bài tập 1:
--Viết truy vấn để lấy thông tin khách hàng có tên đầy đủ là Hannah E Long, Mason D
--Roberts, Jennifer S Cooper.
SELECT *
	FROM
	(SELECT *,
		FullName=(FirstName+MiddleName+LastName) 
	FROM 
		DimCustomer) AS NAME
		WHERE FullName IN ('HannahELong', 'MasonDRoberts', 'JenniferSCooper') 
		ORDER BY BirthDate ASC


--Bài tập 2:
--Viết truy vấn thống tin về OrderDate, SalesOrderNumber, ProductKey, UnitPrice,
--OrderQuantity của bản ghi có ResellerKey = 322 trong bảng FactResellerSales.
SELECT 
	OrderDate,SalesOrderNumber,ProductKey,UnitPrice,OrderQuantity
		FROM
		FactResellerSales
WHERE ResellerKey=322


--Bài tập 3:
--Viết truy vấn để lấy thông tin về chỉ số tài chính doanh nghiệp (bảng FactFinance) mà
--có AccountKey = 61.
SELECT 
	*
	FROM
		FactFinance
	WHERE 
		AccountKey=61


--Bài tập 4:
--Hãy truy vấn ra những shift buổi sáng mà nhận nhiều hơn hoặc bằng 400 cuộc gọi
--trong bảng FactCallCenter. Sắp xếp cột Calls từ lớn xuống bé.
SELECT * 
	FROM 
		FactCallCenter
	WHERE 
		Calls >=400 
	ORDER BY 
		Calls DESC


--Bài tập 5:
--Truy vấn trả về duy nhất cột những ngày mà nhận được IssuesRaised lớn hơn 2 và
--AverageTimePerIssue lớn hơn 60 trong bảng FactCallCenter
SELECT 
	*
	FROM 
		FactCallCenter
	WHERE 
		IssuesRaised>2 AND AverageTimePerIssue >60

--Bài tập 6:
--Viết truy vấn trả về EnglishProductName, ProductKey, ListPrice và StandardCost của
--sản phẩm đáp ứng đủ các tiêu chí sau trong bảng DimProduct:
--ListPrice bé hơn 50
--● Màu khác màu đen
SELECT 
	EnglishProductName,ProductKey,ListPrice,StandardCost,Color
	FROM
		DimProduct
	WHERE 
		ListPrice <50 AND Color != 'BLACK'

--Bài tập 7:
--Viết truy vấn trả về thông tin của nhân viên đáp ứng đầy đủ các tiêu chí sau trong
--bảng DimEmployee:
--● Nhân viên có title là Sales Representative
--● Có SalesTerritoryKey bằng 10 hoặc 1
SELECT 
	* 
	FROM
		DimEmployee
	WHERE 
		Title='Sales Representative' AND SalesTerritoryKey IN (10,1)

--Bài tập 8:
--Viết truy vấn trả về TOP 9 sản phẩm hiện tại vẫn đang bán mà có ListPrice lớn nhất
--thỏa mãn một trong các điều kiện sau trong bảng DimProduct:
--● Reorder point > 300 và Safety Stock > 400.
--● ListPrice nằm trong khoảng từ 100 - 300.
SELECT 
		TOP 9 EnglishProductName, ListPrice 
	FROM
		DimProduct
	WHERE 
		ListPrice IS NOT NULL  AND Reorderpoint >300 AND SafetyStockLevel >400 AND ListPrice BETWEEN 100 AND 300
	



--Bài tập về toán tử
--Bài tập 1:
--Viết truy vấn trả về bảng kết quả có mẫu như dưới đây. Biết rằng, Gap Price được tính
--theo công thức: Gap Price = (ListPrice – DealerPrice) * 1.1. Bảng kết quả thỏa mãn
--các yêu cầu sau:
--● Chỉ tính GapPrice cho những sản phẩm có thông tin màu sắc trong bảng
--DimProduct.
--● Sắp xếp kết quả theo GapPrice từ cao đến thấp.
SELECT 
	* 
	FROM (
		
		SELECT
			ProductKey,GAPPRICE=(ListPrice-DealerPrice)*1.1
		FROM
			DimProduct
				) AS NAME1
WHERE 
	 GAPPRICE IS NOT NULL  
ORDER BY GAPPRICE DESC


--Bài tập 2:
--Đối với các đơn hàng giao đúng hạn được đặt vào năm 2012, 2013 của khách hàng
--doanh nghiệp, thực hiện tính toán các chỉ số sau:
--● Chi phí vận chuyển trên một đơn vị sản phẩm, biết chi phí vận chuyển là
--Freight
--● Tổng số tiền khách phải trả (SalesAmount + TaxAmt + Freight)
--● % thuế trên tổng số tiền khách phải trả, biết tiền thuế là TaxAmt
--● Lợi nhuận (SalesAmount - TotalProductCost)
--SELECT * FROM FactInternetSales --Khách hàng cá nhân

SELECT 
	TaxAmt,Freight,SalesAmount,TotalProductCost,ORDERDATE,DueDate,
	(SalesAmount + TaxAmt + Freight) AS TONG,(TaxAmt*100/((SalesAmount + TaxAmt + Freight)))  AS THUE, (SalesAmount - TotalProductCost) AS LOINHUAN
	FROM
		FactResellerSales --DOANH SO BAN LAI
	WHERE
		YEAR(OrderDate) IN (2012,2013) AND DueDate>=OrderDate
		


--Bài tập về IN
--Bài tập 1:
--Truy vấn ra bảng kết quả bao gồm những khách hàng có học vấn (EnglishEducation)
--là Partial High School hoặc High School hoặc Graduate Degree trong bảng
--DimCustomer

SELECT 
	* 
	FROM
		DimCustomer
	WHERE EnglishEducation IN ('Partial High School','High School','Graduate Degree') 



--Bài tập 2:
--Truy vấn ra bảng kết quả bao gồm những khách hàng có học vấn là Partial High
--School hoặc High School hoặc Graduate Degree và đáp ứng một trong các điều kiện
--sau ở trong bảng DimCustomer
--● Có nghề (EnglishOccupation) là Professional và khoảng cách là 10+ Miles
--● Có nghề là Clerical và khoảng cách là 0-1 Miles

SELECT 
	CustomerKey,FirstName
	FROM
		DimCustomer
	WHERE EnglishEducation IN ('Partial High School','High School','Graduate Degree') 
	AND EnglishOccupation IN ('Professional','10+ Miles') OR EnglishOccupation IN ('Clerical','0-1 Miles')



	--Truy vấn lồng với IN
--Bài tập 1: Tìm các khách hàng sống cùng khu vực địa lý (GeographyKey) với những
--khách hàng đã từng có đơn hàng Internet trị giá hơn 2000.

	
SELECT FirstName, LastName, GeographyKey FROM DimCustomer
WHERE GeographyKey IN (SELECT A.GeographyKey FROM FactInternetSales AS B INNER JOIN DimCustomer AS A
						ON A.CustomerKey=B.CustomerKey 
						WHERE B.SalesAmount>2000)
ORDER BY GeographyKey



--Bài tập 2: Lấy ra thông tin của các sản phẩm (DimProduct) có màu đỏ ('Red') và giá
--niêm yết (ListPrice) > 500, mà các sản phẩm này đã từng xuất hiện trong Top 5 đơn
--hàng có doanh số (SalesAmount) cao nhất từ bảng FactInternetSales.
SELECT * FROM DimProduct
WHERE Color='RED' AND ListPrice > 500 
AND ProductKey IN (

SELECT TOP 5 ProductKey FROM FactInternetSales
ORDER BY SalesAmount DESC)
