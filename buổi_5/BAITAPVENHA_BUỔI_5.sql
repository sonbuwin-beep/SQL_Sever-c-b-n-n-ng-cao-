USE [AdventureWorksDW2022]
GO 

--[Bài tập] Các câu lệnh truy vấn dữ liệu với SQL (Phần 2)
--Bài tập 1:
--Tính tổng doanh thu hàng năm (AnnualRevenue) theo từng loại hình kinh doanh
--(BusinessType) và dòng sản phẩm (ProductLine) trong bảng DimReseller. Viết truy
--vấn để kết quả chỉ hiện thị những nhóm có tổng doanh thu lớn hơn 10 triệu.

SELECT SUM(AnnualRevenue) AS SUM,ProductLine,BusinessType FROM DimReseller
GROUP BY ProductLine,BusinessType
HAVING SUM(AnnualRevenue) >10000000


--Bài tập 2:
--Dựa vào bảng FactInternetSales, hãy viết truy vấn trả về bảng gồm 3 cột:
--● Mã khách hàng
--● Ngày gần nhất mà khách hàng thực hiện mua hàng
--● Số lượng đơn khách hàng đã mua (lưu ý phân biệt giữa COUNT và COUNT
--DISTINCT)
--Chỉ hiển thị những khách hàng có ngày mua hàng gần nhất nằm trong khoảng từ
--năm 2012 trở về sau.

SELECT 
    CustomerKey,
    DAY(MAX(OrderDate)) AS NGAY, 
    COUNT(DISTINCT SalesOrderNumber) AS SO_DON_MUA
FROM FactInternetSales
GROUP BY CustomerKey
HAVING YEAR(MAX(OrderDate)) >= 2012


--Bài tập 3:
--Viết truy vấn tính tổng doanh số bán hàng online theo từng năm.

SELECT YEAR(DUEDATE) AS YEAR ,SUM(SalesAmount) AS SUM FROM FactInternetSales
GROUP BY YEAR(DUEDATE);



--Bài tập 4:
--(Nâng cao) Liệt kê các sản phẩm (ProductKey, EnglishProductName) trong
--DimProduct không có Size, và ListPrice cao hơn giá trung bình của tất cả sản phẩm
--có Color giống nhau.

WITH A1 AS (
        SELECT ProductKey,ListPrice,SIZE,COLOR,EnglishProductName FROM DimProduct
        WHERE SIZE IS NULL
             ),
     A2 AS (
        SELECT  COLOR,AVG(ListPrice) AS AVG FROM DimProduct 
        GROUP BY COLOR
        )
        SELECT AA.ProductKey,AA.EnglishProductName,BB.AVG FROM A1 AS AA INNER JOIN 
        A2 AS BB ON AA.Color=BB.Color
        WHERE AA.ListPrice>BB.AVG
     

--Bài tập xử lý dạng ngày tháng
--Bài tập 1:
--Viết truy vấn liệt kê thông tin các nhân viên đã nghỉ việc, kèm theo một cột tính số
--tháng họ đã làm việc tại công ty.



SELECT 
    AVG(DATEDIFF(MONTH, StartDate, ISNULL(EndDate, '2026-04-20'))) AS AvgMonths
FROM 
    DimEmployee
WHERE 
    StartDate IS NOT NULL;



--Bài tập 2:
--● Viết truy vấn lấy thông tin các đơn hàng (bảng FactResellerSales) được đặt
--trong tháng 11 năm 2013, từ các khách hàng doanh nghiệp.
--● Thêm một cột mới có tên PlanShipDate, là ngày giao hàng dự kiến, được tính
--bằng OrderDate cộng thêm 15 ngày.
SELECT 
        * ,
        DATEADD (DAY,15,ORDERDATE) AS PlanShipDate  
FROM FactResellerSales
WHERE 
        YEAR(SHIPDATE) = 2013 AND MONTH(SHIPDATE) = 11

--Toán tử logic - LIKE statement
--Bài tập 1:
--Từ bảng Dim product, hãy trả về bảng kết quả có các cột ProductKey,
--EnglishProductName, ListPrice, StandardCost.
--Lọc ra các sản phẩm có chữ d ở kí tự thứ 4 và đồng thời cũng có chữ t ở kí tự thứ 7

SELECT  ProductKey,
        EnglishProductName,
        ListPrice,
        StandardCost
FROM
        DimProduct
WHERE 
        EnglishProductName LIKE ('___D__T%')


--Bài tập 2:
--Danh sách các sản phẩm áo dài tay để bán cho mùa lạnh, biết mã thay thế các sản
--phẩm này (ProductAlternateKey) bắt đầu bằng chữ LJ trong bảng DimProduct

SELECT 
    * 
FROM 
    DimProduct
WHERE 
    ProductAlternateKey LIKE 'LJ%'


--Bài tập 3:
--Sử dụng LIKE tìm các sản phẩm có ProductAlternateKey có kí tự đầu là chữ F, kí tự
--thứ 7 là chữ S và kí tự cuối cùng là số 6 trong bảng DimProduct

SELECT 
    *
FROM 
    DimProduct
WHERE 
    ProductAlternateKey LIKE 'F_____S%6'

--Bài tập 4:
--Trong DimProduct, tìm sản phẩm có EnglishProductName bắt đầu bằng "Mountain"
--và có chứa "Bike".
SELECT 
    * 
FROM
    DimProduct
WHERE 
    EnglishProductName LIKE 'Mountain%BIKE%'


--Bài tập 5:
--Trong bảng DimCustomer, tìm danh sách khách hàng có EmailAddress bắt đầu bằng
--chữ s, ký tự thứ hai không phải là a hoặc e.
SELECT 
    EmailAddress 
FROM
    DimCustomer
WHERE EmailAddress  LIKE 'S[^AE]%'
    


--Bài tập 6:
--Trong bảng DimCustomer, tìm tất cả khách hàng có EmailAddress bắt đầu bằng chữ
--"a", ký tự thứ hai không phải là "b" hoặc "c", và tiếp theo có ít nhất một ký tự bất kỳ.
SELECT 
    EmailAddress 
FROM 
    DimCustomer
WHERE
    EmailAddress LIKE 'A[^BC][A-Z]%'



--Bài tập 7:
--Trong bảng DimEmployee, lấy danh sách nhân viên có LoginID bắt đầu bằng
--"adventure-", ký tự tiếp theo không phải là số.
SELECT 
    LOGINID
FROM
    DimEmployee
WHERE LOGINID LIKE 'adventure[^0-9]%'

--Bài tập 8:
--Trong DimProduct, lọc sản phẩm có ProductAlternateKey:
--● Bắt đầu bằng "B".
--● Ký tự thứ ba không nằm trong khoảng 0–9 và a–f (tức là không phải số và
--không phải a–f).
--● Ký tự thứ tư không phải chữ cái
--● Tổng độ dài ProductAlternateKey đúng 7 ký tự.

SELECT 
    ProductAlternateKey
FROM 
    DimProduct
WHERE 
    ProductAlternateKey LIKE 'B_[^0-9 , ^A-F][^A-Z]___'

--Bài tập xử lý chuỗi
--Bài tập 1:
--Lấy ra tên miền email của từng nhân viên phòng marketing trong bảng DimEmployee
SELECT 
    SUBSTRING(EmailAddress,(CHARINDEX('@',EmailAddress)),LEN(EmailAddress))
FROM 
    DimEmployee
    

--Bài tập 2:
--Thay thế tên miền email của từng nhân viên phòng production thành production.com
--trong bảng DimEmployee
SELECT 
   REPLACE (EmailAddress,SUBSTRING(EmailAddress,(CHARINDEX('@',EmailAddress)),LEN(EmailAddress)),'production.com'),TITLE
FROM
    DimEmployee
WHERE 
    TITLE LIKE '%production%'




    
     
    
