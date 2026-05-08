--Truy vấn lồng với CTE
--Bài tập 1:
--Viết truy vấn trả về bảng kết quả trả lời các câu hỏi sau:
--● Trung bình một Reseller chi tiêu bao nhiêu tiền?
--● Trung bình một Reseller mua bao nhiêu đơn hàng?
--● Trung bình một khách hàng online chi tiêu bao nhiêu tiền?
--● Trung bình một khách hàng online mua bao nhiêu đơn?
--(Nâng cao) Thể hiện các kết quả trên thành một bảng duy nhất với cấu trúc như dưới
--đây (tham khảo UNION và UNION ALL)
--Phân loại Trung bình chi tiêu, Trung bình số lượng đơn
--Reseller
--Online

WITH A AS (
SELECT ResellerKey,
		COUNT(DISTINCT SalesOrderNumber) AS COUNT_SO_DON,
		SUM(SalesAmount) AS SUM_TONG_CHI_TIEU
FROM FactResellerSales
		GROUP BY ResellerKey
		),
	 B AS (
SELECT  SUM(SalesAmount) AS SUM_TONG_CHI,
		FactInternetSales.CustomerKey,
		COUNT(DISTINCT SalesOrderNumber) AS COUNT_DON_HANG
FROM FactInternetSales 
INNER JOIN DimCustomer
	    ON FactInternetSales.CustomerKey=DimCustomer.CustomerKey
GROUP BY FactInternetSales.CustomerKey
	   )
	  SELECT 'Reseller' AS [Phân loại],
			 AVG(COUNT_SO_DON) AS AVG_SO_DON,
			 AVG(SUM_TONG_CHI_TIEU) AS AVG_TONG_CHI_TIE 
	  FROM A
	  UNION 
	  SELECT 'ONLINE' AS [Phân loại],
			  AVG(COUNT_DON_HANG) AS AVG_DON_HANG,
			  AVG(SUM_TONG_CHI) AS AVG_TONG_CHI 
	  FROM B;



 --Bài tập 2:
--Tạo một View tên là vw_SalesPerformanceByYear để phục vụ báo cáo cuối năm.
--View bao gồm các thông tin:
--● CalendarYear: Năm (lấy từ bảng DimDate).
--● InternetSales: Tổng doanh số từ bảng FactInternetSales.
--● ResellerSales: Tổng doanh số từ bảng FactResellerSales.
--● Sử dụng COALESCE để đảm bảo nếu một năm không có doanh số ở một
--mảng thì hiện thị giá trị 0 thay vì NULL. 

WITH A AS (
    SELECT DISTINCT 
        CalendarYear AS YEAR,
        DateKey 
    FROM DimDate
),
B AS (
    SELECT 
        SUM(COALESCE(SalesAmount, 0)) AS InternetSales,
        OrderDateKey 
    FROM FactInternetSales
    GROUP BY OrderDateKey
),
C AS (
    SELECT 
        SUM(COALESCE(SalesAmount, 0)) AS ResellerSales,
        OrderDateKey   
    FROM FactResellerSales
    GROUP BY OrderDateKey
)

SELECT 
    A.YEAR,
    SUM(B.InternetSales) AS InternetSales,
    SUM(C.ResellerSales) AS ResellerSales
FROM A 
INNER JOIN B ON A.DateKey = B.OrderDateKey
INNER JOIN C ON C.OrderDateKey = B.OrderDateKey
GROUP BY A.YEAR;



--Viết truy vấn trả về TOP 3 Reseller có tổng doanh số (SalesAmount) cao nhất với
--từng SalesTerritoryRegion (trong bảng DimSalesTerritory).
WITH A AS (
SELECT TOP 3
	   A.ResellerKey,
	   SUM(SalesAmount) AS SUM_DOANH_SO
	   
FROM 
	DimReseller AS A 
	INNER JOIN FactResellerSales AS B
		ON B.ResellerKey=A.ResellerKey
GROUP BY A.ResellerKey
ORDER BY SUM(SalesAmount) DESC),



    B AS (
	SELECT DISTINCT SalesTerritoryRegion,
		   ResellerKey FROM DimSalesTerritory
	INNER JOIN FactResellerSales 
			ON DimSalesTerritory.SalesTerritoryKey=FactResellerSales.SalesTerritoryKey
	)

	SELECT B.SalesTerritoryRegion ,
		   A.SUM_DOANH_SO 
	FROM A INNER JOIN B 
			ON A.ResellerKey=B.ResellerKey
	WHERE A.ResellerKey IN (
					SELECT ResellerKey FROM B 
					)

			
--Biến (Variables)
--Bài tập 1:
--Khai báo một biến @TotalCustomers để lưu tổng số lượng khách hàng. Sau đó, truy
--vấn danh sách các nghề nghiệp (EnglishOccupation) cùng số lượng khách hàng và tỷ
--lệ phần trăm của từng nghề nghiệp đó trên tổng số


DECLARE @TotalCustomers FLOAT
SELECT @TotalCustomers=COUNT(*) 
FROM DimCustomer

SELECT @TotalCustomers AS TONG
SELECT	EnglishOccupation,
		COUNT(EnglishOccupation) AS KHACH_HANG,
	    (COUNT(EnglishOccupation)/@TotalCustomers)*100 AS PHAN_TRAM
FROM
	DimCustomer
GROUP BY EnglishOccupation;

--Bài tập 2:
--Sử dụng biến để tính và lưu các giá trị tứ phân vị Q1, Q2, và Q3 của cột SalesAmount
--trong bảng .
--● Tính toán giá trị IQR = Q3 - Q1.
--● Lọc ra các đơn hàng được coi là "ngoại lai" (nằm ngoài khoảng [Q1 - 1.5*IQR,
--Q3 + 1.5*IQR]).

DECLARE @IQR FLOAT
DECLARE @Q1 FLOAT
DECLARE @Q3 FLOAT


SELECT @Q1 = MAX(SalesAmount) FROM (
    SELECT TOP 25 PERCENT SalesAmount 
    FROM FactResellerSales 
    ORDER BY SalesAmount ASC
) AS A;


SELECT @Q3 = MAX(SalesAmount) FROM (
    SELECT TOP 75 PERCENT SalesAmount 
    FROM FactResellerSales 
    ORDER BY SalesAmount ASC
) AS B;


SELECT @IQR = @Q3 - @Q1;
SELECT SalesAmount FROM FactResellerSales 
WHERE SalesAmount < (@Q1 - 1.5*@IQR)  
   OR  SalesAmount > (@Q3 + 1.5*@IQR);


	


--Khai báo một biến @MinRevenue kiểu dữ liệu MONEY. Gán cho biến này giá trị bằng
--10% tổng doanh thu của toàn bộ hệ thống. Sau đó, xuất danh sách các sản phẩm
--(EnglishProductName) có tổng doanh thu lớn hơn giá trị của biến @MinRevenue.



DECLARE @MinRevenue MONEY
SELECT @MinRevenue= SUM*0.1 FROM
(
SELECT A.ProductKey,SUM(SalesAmount) AS SUM FROM DimProduct AS A
INNER JOIN FactInternetSales AS B 
ON A.ProductKey=B.ProductKey
GROUP BY A.ProductKey ) AS A
SELECT @MinRevenue AS PHAN_TRAM_HE_THONG

SELECT SUM(SalesAmount) AS PHAN_TRAM,EnglishProductName FROM FactResellerSales AS D INNER JOIN DIMProduct AS E 
ON D.ProductKey=E.ProductKey
GROUP BY D.ProductKey,EnglishProductName
HAVING SUM(SalesAmount) > @MinRevenue



	




	



	
