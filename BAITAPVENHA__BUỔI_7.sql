--Bài tập 1:
--Thực hiện gộp dữ liệu từ DimCustomer và DimEmployee để tạo một danh bạ tổng
--hợp gồm: FullName, EmailAddress, Phone, Gender.
--● Yêu cầu: Kết quả trả về phải được sắp xếp theo FullName tăng dần.
--● Giải thích điều gì sẽ xảy ra nếu một người vừa là nhân viên vừa là khách hàng
--(có cùng thông tin) khi bạn dùng UNION so với khi dùng UNION ALL

SELECT CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS FullName,
		EmailAddress,
		Phone,
		Gender
		FROM DimCustomer 
UNION ALL

SELECT CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS FullName,
		EmailAddress,
		Phone,
		Gender
		FROM DimEmployee 

ORDER BY FullName ASC

--NẾU DÙNG UNION THÌ SẼ CHỈ LẤY 1 THÔNG TIN LÀM ĐẠI DIỆN CÒN ALL THÌ LẤY TẤT CẢ 


--Window Function
--Bài tập 1:
--Nêu sự khác nhau giữa 3 hàm: RANK(), DENSE_RANK() và ROW_NUMBER().
--Giải thích sự khác biệt về cách đánh số thứ hạng khi có các giá trị trùng nhau.

SELECT SalesOrderNumber,RANK() OVER(ORDER BY  SalesAmount DESC) FROM FactInternetSales
--Nếu có 2 dòng có giá trị bằng nhau, chúng sẽ có cùng một hạng, 
--và số hạng tiếp theo sẽ bị ngắt quãng (nhảy cóc)

SELECT SalesOrderNumber,DENSE_RANK() OVER(ORDER BY  SalesAmount DESC) FROM FactInternetSales
--xếp hạng các giá trị bằng nhau vào cùng một thứ hạng

SELECT SalesOrderNumber,ROW_NUMBER() OVER(ORDER BY  SalesAmount DESC) FROM FactInternetSales
--tách chúng ra bằng hai số thứ tự khác nhau

--Giá sản phẩm,
--		ROW_NUMBER(),RANK(),DENSE_RANK()
--	100$,	1,			1,		1
--	100$,	2,			1,		1
--	100$,	3,			1,		1
--	90$,	4,			4,		2
-- NHƯ VÍ DỤ TRÊN 


--Bài tập 2:
--Viết truy vấn xếp hạng giá trị EndOfDayRate theo từng CurrencyKey trong bảng
--FactCurrencyRate.
SELECT  EndOfDayRate, 
		CurrencyKey,
		RANK() OVER(PARTITION BY CurrencyKey ORDER BY EndOfDayRate ) AS RANK 
FROM 
	FactCurrencyRate


--Bài tập 3:
--Viết truy vấn xếp hạng ServiceGrade theo từng WageType và Shift trong bảng
--FactCallCenter.

SELECT ServiceGrade,
	   WageType,
	   Shift,
	   RANK() OVER (PARTITION BY WageType,Shift ORDER BY ServiceGrade) AS RANK
FROM 
	FactCallCenter


--Bài tập 4:
--Viết truy vấn xếp hạng ListPrice trong bảng DimProduct theo từng
--EnglishProductSubcategoryName trong bảng DimProductSubcategory

SELECT  ListPrice,
		EnglishProductSubcategoryName,
		RANK() OVER(PARTITION BY EnglishProductSubcategoryName ORDER BY ListPrice) AS RANK
FROM 
	DimProduct
INNER JOIN DimProductSubcategory 
	ON DimProductSubcategory.ProductSubcategoryKey=DimProduct.ProductSubcategoryKey
	WHERE ListPrice IS NOT NULL




--Bài tập 5: (Nâng cao)
--Viết truy vấn trả về TOP 3 EmployeeKey có chỉ tiêu cao nhất theo từng năm trong
--bảng FactSalesQuota.

SELECT * FROM (
	SELECT  EmployeeKey,
			YEAR(DATE) AS YEAR, 
			RANK() OVER (PARTITION BY YEAR(DATE)  ORDER BY SalesAmountQuota DESC) AS RANK1 
	FROM 
		FactSalesQuota) AS A
		WHERE RANK1<=3




--Bài tập luyện tập hàm Logic
--Bài tập 1:
--Lấy thông tin các sản phẩm có mặt trong 20 đơn hàng có tổng SalesAmount lớn
--nhất, và phân loại sản phẩm:
--• 'Expensive' nếu ListPrice > 2000
--• 'Affordable' nếu từ 1000–2000
--• 'Cheap' nếu dưới 1000

SELECT 
    A.ProductKey,
    A.EnglishProductName,
    A.ProductAlternateKey,
    CASE 
        WHEN A.ListPrice > 2000 THEN 'Expensive'
        WHEN A.ListPrice BETWEEN 1000 AND 2000 THEN 'Affordable'
        WHEN A.ListPrice < 1000 THEN 'Cheap'
    END AS CASE_WHEN
FROM DimProduct AS A
INNER JOIN (
    
    SELECT TOP 20 
        ProductKey, 
        SUM(SalesAmount) AS TotalSales
    FROM FactInternetSales
    GROUP BY ProductKey
    ORDER BY TotalSales DESC
) AS B ON A.ProductKey = B.ProductKey

		
	

--Bài tập 2:
--Lấy danh sách khách hàng có ID xuất hiện trong Top 20 đơn hàng có doanh số cao
--nhất, và phân loại theo năm sinh như sau:
--• 'Gen Z' nếu sinh sau 1997
--• 'Millennial' nếu sinh từ 1981 đến 1997
--• 'Older' nếu sinh trước 1981

SELECT TOP 20 A.CustomerKey,
			  A.LastName,
			  A.Gender,
			  A.PHAN_LOAI 
FROM FactInternetSales AS B
INNER JOIN (
	SELECT LastName,
		   YEAR(BirthDate) AS YEAR,
		   GENDER,
		   CustomerKey,
	CASE 
		WHEN YEAR(BirthDate) > 1997 THEN 'Gen Z'
		WHEN YEAR(BirthDate) BETWEEN 1981 AND 1997 THEN 'Millennial'
		WHEN YEAR(BirthDate) < 1981 THEN 'Older'
	END AS PHAN_LOAI
	FROM 
		DimCustomer ) AS A 
	ON A.CustomerKey= B.CustomerKey
	ORDER BY B.SalesAmount DESC


--Bài tập 3:
--Viết truy vấn tính tổng số lượng mua các đơn hàng online theo từng phân loại màu
--sắc:
--● Màu Black, Blue, Grey, Red được phân loại là DarkColor
--● Silver, Silver/Black, White, Yellow được phân loại là BrightColor
--● Các màu khác giữ nguyên
--Biết rằng các đơn hàng này được mua năm 2011 được mua bởi khách hàng nữ sinh
--sau 1980.

SELECT Gender FROM DimCustomer


SELECT SalesOrderLineNumber,
	   Color,
	   Gender,
	   YEAR(BirthDate) AS YEAR,
CASE 
 WHEN Color IN ('Black', 'Blue', 'Grey', 'Red') THEN 'DarkColor'
 WHEN Color IN ('Silver', 'Silver/Black', 'White', 'Yellow') THEN 'BrightColor'
 ELSE  Color
 END AS PHAN_LOAI

FROM 
		FactInternetSales 
INNER JOIN DimProduct 
ON FactInternetSales.ProductKey=DimProduct.ProductKey
INNER JOIN DimCustomer ON DimCustomer.CustomerKey=FactInternetSales.CustomerKey
WHERE YEAR(BirthDate) >1980  AND Gender='F'


