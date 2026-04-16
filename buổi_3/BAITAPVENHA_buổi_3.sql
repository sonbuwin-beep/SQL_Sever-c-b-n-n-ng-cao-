-- tải dữ liệu ở link sau : https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17&tabs=ssms
-- CHAR(13) LÀ ĐƯA CON TRỎ VỀ ĐẦU DÒNG 
-- CHAR(10) LÀ XUỐNG DÒNG 
-- KẾT HỢP CHUỖI DÙNG DẤU '+'

-- kiểm tra dữ liệu trước :
USE [AdventureWorksDW2022]
GO 

-- xem các dữ liệu trong bảng 
SELECT * FROM [dbo].[DimProduct] --bảng sản phẩm 

-- bài 1: xem các bảng chi tiết có nhiệm vụ,chức năng gì :
CREATE DATABASE THONGTIN_AdventureWorksDW2022
GO

USE [AdventureWorksDW2022] 
GO


CREATE TABLE THONGTIN (
    DU_LIEU NVARCHAR(100), 
    CHUC_NANG NVARCHAR(MAX) 
);
GO

-- NHÓM BẢNG DIMENSION (DANH_MỤC)
INSERT INTO THONGTIN VALUES (N'dbo.DimAccount', N'Lưu_trữ: Danh_mục các tài_khoản kế_toán và phân_cấp quản_lý tài_chính.' + CHAR(13)+CHAR(10) + N'Đại_diện: Một tài_khoản hoặc một phân_loại tài_khoản kế_toán cụ_thể.');
INSERT INTO THONGTIN VALUES (N'dbo.DimCurrency', N'Lưu_trữ: Danh_sách các loại tiền_tệ lưu_hành toàn_cầu.' + CHAR(13)+CHAR(10) + N'Đại_diện: Một đơn_vị tiền_tệ duy_nhất (Ví_dụ: VND, USD, EUR).');
INSERT INTO THONGTIN VALUES (N'dbo.DimCustomer', N'Lưu_trữ: Thông_tin chi_tiết, nhân_khẩu_học và liên_lạc của khách_hàng cá_nhân.' + CHAR(13)+CHAR(10) + N'Đại_diện: Một khách_hàng mua_lẻ duy_nhất của công_ty.');
INSERT INTO THONGTIN VALUES (N'dbo.DimDate', N'Lưu_trữ: Dữ_liệu thời_gian chi_tiết (Thứ, Ngày, Tháng, Quý, Năm, Năm tài_chính).' + CHAR(13)+CHAR(10) + N'Đại_diện: Một ngày cụ_thể duy_nhất trong hệ_thống lịch.');
INSERT INTO THONGTIN VALUES (N'dbo.DimDepartmentGroup', N'Lưu_trữ: Cơ_cấu tổ_chức và các nhóm phòng_ban trong doanh_nghiệp.' + CHAR(13)+CHAR(10) + N'Đại_diện: Một bộ_phận hoặc nhóm phòng_ban chuyên_trách.');
INSERT INTO THONGTIN VALUES (N'dbo.DimEmployee', N'Lưu_trữ: Hồ_sơ nhân_sự, chức_vụ, mức lương và thông_tin quản_lý trực_tiếp.' + CHAR(13)+CHAR(10) + N'Đại_diện: Một nhân_viên cụ_thể trong tổ_chức.');
INSERT INTO THONGTIN VALUES (N'dbo.DimGeography', N'Lưu_trữ: Thông_tin vị_trí địa_lý, địa_chỉ hành_chính và vùng_miền.' + CHAR(13)+CHAR(10) + N'Đại_diện: Một địa_danh hoặc một đơn_vị hành_chính (Thành_phố/Quốc_gia).');
INSERT INTO THONGTIN VALUES (N'dbo.DimOrganization', N'Lưu_trữ: Cấu_trúc_tổ_chức, các chi_nhánh và đơn_vi_thành_viên.' + CHAR(13)+CHAR(10) + N'Đại_diện: Một đơn_vị hoặc một chi_nhánh trong hệ_thống_công_ty.');
INSERT INTO THONGTIN VALUES (N'dbo.DimProduct', N'Lưu_trữ: Thông_tin kỹ_thuật, mô_tả và phân_loại các mặt_hàng kinh_doanh.' + CHAR(13)+CHAR(10) + N'Đại_diện: Một sản_phẩm hoặc mặt_hàng cụ_thể trong kho hàng.');
INSERT INTO THONGTIN VALUES (N'dbo.DimProductCategory', N'Lưu_trữ: Các danh_mục sản_phẩm cấp cao_nhất (VD: Xe_đạp, Quần_áo).' + CHAR(13)+CHAR(10) + N'Đại_diện: Một nhóm_ngành_hàng chính.');
INSERT INTO THONGTIN VALUES (N'dbo.DimProductSubcategory', N'Lưu_trữ: Các danh_mục sản_phẩm cấp con (VD: Xe_đạp_địa_hình, Phụ_tùng).' + CHAR(13)+CHAR(10) + N'Đại_diện: Một nhóm sản_phẩm chi_tiết thuộc danh_mục_chính.');
INSERT INTO THONGTIN VALUES (N'dbo.DimPromotion', N'Lưu_trữ: Các chương_trình ưu_đãi, giảm_giá và chiến_dịch tiếp_thị.' + CHAR(13)+CHAR(10) + N'Đại_diện: Một hình_thức hoặc đợt khuyến_mãi cụ_thể.');
INSERT INTO THONGTIN VALUES (N'dbo.DimReseller', N'Lưu_trữ: Thông_tin các đại_lý, nhà_bán_lẻ nhập hàng từ công_ty.' + CHAR(13)+CHAR(10) + N'Đại_diện: Một đối_tác_kinh_doanh (đại_lý).');
INSERT INTO THONGTIN VALUES (N'dbo.DimSalesReason', N'Lưu_trữ: Các lý_do khách_hàng mua hàng (VD: Giá_tốt, Quảng_cáo).' + CHAR(13)+CHAR(10) + N'Đại_diện: Một nguyên_nhân dẫn đến hành_vi mua_hàng.');
INSERT INTO THONGTIN VALUES (N'dbo.DimSalesTerritory', N'Lưu_trữ: Phân_vùng quản_lý kinh_doanh theo các vùng lãnh_thổ.' + CHAR(13)+CHAR(10) + N'Đại_diện: Một vùng lãnh_thổ bán_hàng được phân_cấp quản_lý.');
INSERT INTO THONGTIN VALUES (N'dbo.DimScenario', N'Lưu_trữ: Các kịch_bản giả_định tài_chính (VD: Thực_tế, Ngân_sách, Dự_báo).' + CHAR(13)+CHAR(10) + N'Đại_diện: Một loại kịch_bản báo_cáo tài_chính.');

-- NHÓM BẢNG FACT (GIAO_DỊCH / SỐ_LIỆU)
INSERT INTO THONGTIN VALUES (N'dbo.FactCallCenter', N'Lưu_trữ: Dữ_liệu vận_hành của trung_tâm cuộc_gọi (thời_gian chờ, số cuộc_gọi).' + CHAR(13)+CHAR(10) + N'Đại_diện: Chỉ_số vận_hành của một ca làm_việc tại tổng_đài.');
INSERT INTO THONGTIN VALUES (N'dbo.FactCurrencyRate', N'Lưu_trữ: Tỷ_giá hối_đoái giữa các loại tiền_tệ theo từng ngày.' + CHAR(13)+CHAR(10) + N'Đại_diện: Tỷ_giá của một đơn_vị tiền_tệ so với đồng USD trong một ngày.');
INSERT INTO THONGTIN VALUES (N'dbo.FactFinance', N'Lưu_trữ: Các số_liệu tài_chính như doanh_thu, chi_phí và ngân_sách.' + CHAR(13)+CHAR(10) + N'Đại_diện: Một bản_ghi giao_dịch tài_chính tại một thời_điểm.');
INSERT INTO THONGTIN VALUES (N'dbo.FactInternetSales', N'Lưu_trữ: Doanh_số_bán_hàng và các chỉ_số giao_dịch trực_tuyến (Online).' + CHAR(13)+CHAR(10) + N'Đại_diện: Một dòng_hàng trong một đơn_hàng từ khách_lẻ.');
INSERT INTO THONGTIN VALUES (N'dbo.FactInternetSalesReason', N'Lưu_trữ: Mối liên_kết giữa đơn_hàng Online và lý_do mua_hàng.' + CHAR(13)+CHAR(10) + N'Đại_diện: Một lý_do cụ_thể áp_dụng cho một đơn_hàng trực_tuyến.');
INSERT INTO THONGTIN VALUES (N'dbo.FactProductInventory', N'Lưu_trữ: Số_lượng hàng_tồn_kho và các chỉ_số nhập_xuất_kho.' + CHAR(13)+CHAR(10) + N'Đại_diện: Tình_trạng tồn_kho của một sản_phẩm tại một ngày nhất_định.');
INSERT INTO THONGTIN VALUES (N'dbo.FactResellerSales', N'Lưu_trữ: Dữ_liệu bán_hàng thông_qua các đại_lý và nhà_bán_lẻ.' + CHAR(13)+CHAR(10) + N'Đại_diện: Một dòng_hàng trong hóa_đơn xuất cho đối_tác đại_lý.');
INSERT INTO THONGTIN VALUES (N'dbo.FactSalesQuota', N'Lưu_trữ: Chỉ_tiêu doanh_số (Kpi) được giao cho nhân_viên kinh_doanh.' + CHAR(13)+CHAR(10) + N'Đại_diện: Mức doanh_số mục_tiêu của một nhân_viên trong một quý.');
INSERT INTO THONGTIN VALUES (N'dbo.FactAdditionalInternationalProductDescription', N'Lưu_trữ: Mô_tả bổ_sung sản_phẩm bằng nhiều ngôn_ngữ quốc_tế.' + CHAR(13)+CHAR(10) + N'Đại_diện: Một bản dịch mô_tả cho một sản_phẩm cụ_thể.');
GO

-- XEM KẾT_QUẢ : Nhấn Ctrl + T ĐỂ XEM TEXT 
SELECT DU_LIEU, CHUC_NANG FROM THONGTIN;
GO

SELECT DU_LIEU FROM THONGTIN


--- BÀI 2 : Thực hiện một số truy vấn cơ bản để trả lời một số câu hỏi dưới đây:
--Truy vấn trả về bảng kết quả danh sách nhân viên có giới tính Nam và thuộc phòng ban Engineering được hưởng BASE RATE từ 30 đến 40
---Truy vấn trả về danh sách khách hàng là doanh nghiệp ( nằm trong bảng DimReseller) đáp ứng một trong các điều kiện sau đây:
--- Được thành lập vào thế kỉ 21, và có doanh số hàng năm lớn hơn hoặc bằng 3000000
--  Được thành lập trước thế kỉ 21, và có doanh số bé hơn hoặc bằng 800000
--  (Nâng cao) Truy vấn ra danh sách tất cả các sản phẩm có tên bắt đầu bằng chữ HL



SELECT BaseRate,Gender,Title FROM DimEmployee
WHERE BaseRate BETWEEN 30 AND 40  -- HƯỞNG LƯƠNG
AND Gender='M' -- LỌC ĐÀN ÔNG
AND Title LIKE '%Engineering%' --LỌC NGHỀ 


SELECT ResellerName FROM DimReseller 
WHERE AnnualSales >=3000000 AND YearOpened <2001 

SELECT ResellerName FROM DimReseller 
WHERE AnnualSales >=800000 AND YearOpened <2001 

SELECT ProductLine FROM DimReseller
WHERE ProductLine LIKE 'HL%'



SELECT * FROM DimProduct
WHERE EnglishProductName LIKE 'HL%'
