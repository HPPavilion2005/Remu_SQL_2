# Remu_SQL_2

Bài tập hệ quản trị cơ sở dữ liệu số 2 | Sinh viên: Chu Trọng Tấn - MSSV: K235480106063

## Phần 1: Thiết kế và khởi tạo cấu trúc dữ liệu:

Database: Quanlyphonggame_K235480106063

![1](images/1.png)

*Database và code của 3 bảng*

### Khoá chính (PK): 

[MaThanhVien] trong bảng [ThanhVien]: định danh duy nhất cho mỗi thành viên

![2](images/2.png)

*Bảng thành viên*

[MaMayTinh] trong bảng [MayTinh]: Định danh duy nhất cho mỗi máy tính

![3](images/3.png)

*Bảng máy tính*

[MaHoaDon] trong bảng [HoaDon]: Định danh duy nhất cho mỗi hoá đơn

![4](images/4.png)

*Bảng hoá đơn*

### Khoá ngoại (FK):

[MaThanhVien] trong bảng [HoaDon] → Tham chiếu đến [ThanhVien]

[MaMayTinh] trong bảng [HoaDon] → Tham chiếu đến [MayTinh]

*ON DELETE CASCADE: Nếu xóa thành viên, xóa luôn các hoá đơn của thành viên đó

### CHECK CONSTRAINT (CK) - Ràng buộc kiểm tra:

[TrangThaiTaiKhoan]: Chỉ chấp nhận: 'Hoat_Dong', 'Binh_Ngo', hoặc 'Khoai_Hoan'

[GiaThueGioTinh]: Phải > 0 (không thể có giá âm)

[NamPhatHanhMay]: Phải nằm trong khoảng 2010-2030

[TrangThaiMay]: Chỉ chấp nhận: 'San_Sang', 'Dang_Su_Dung', 'Bao_Tri', 'Hoi_Hang'

[TrangThaiThanhToan]: Chỉ chấp nhận: 'Chua_Thanh_Toan', 'Da_Thanh_Toan', 'Hoan_Tien'

----------------------------------

## Phần 2: Xây dựng Function:

### 1. Các loại Built-in Functions trong SQL Server

SQL Server có các nhóm hàm chính:

  a) String Functions - Xử lý chuỗi

  **LEN: Đếm độ dài chuỗi**

  SELECT LEN(N'Xin chào') AS [ĐộDài];

  **UPPER/LOWER: Chuyển hoa/thường**

  SELECT UPPER(N'Remu') AS [InHoa], LOWER(N'REMU') AS [InThường];

  **SUBSTRING: Cắt chuỗi**

  SELECT SUBSTRING(N'SQL Server', 1, 3) AS [KếtQuả];

  **CONCAT: Nối chuỗi**

  SELECT CONCAT(N'Họ: ', N'Nguyễn', N' Tên: ', N'Văn A') AS [HọTên];

  b) Date Functions - Xử lý ngày tháng

  **GETDATE: Lấy ngày giờ hiện tại**

  SELECT GETDATE() AS [NgàyGiờHiệnTại];

  **DATEADD: Cộng thêm ngày/tháng/năm**

  SELECT DATEADD(DAY, 7, GETDATE()) AS [Sau7Ngày];

  **DATEDIFF: Tính khoảng cách giữa 2 ngày**

  SELECT DATEDIFF(YEAR, '2000-01-01', GETDATE()) AS [SốTuổi];

  **FORMAT: Định dạng ngày**

  SELECT FORMAT(GETDATE(), 'dd/MM/yyyy') AS [NgàyViệtNam];

  c) Math Functions - Toán học

  **ROUND: Làm tròn**

  SELECT ROUND(8.567, 2) AS [LàmTròn];

  **CEILING/FLOOR: Làm tròn lên/xuống**

  SELECT CEILING(8.1) AS [LàmTrònLên], FLOOR(8.9) AS [LàmTrònXuống];

  **ABS: Giá trị tuyệt đối**

  SELECT ABS(-100) AS [GiáTrịTuyệtĐối];

  d) Aggregate Functions - Tổng hợp

  **COUNT, SUM, AVG, MIN, MAX**

  SELECT
      COUNT(*) AS [TổngSốBảnGhi],
      AVG([Điểm]) AS [ĐiểmTrungBình],
      MAX([Điểm]) AS [ĐiểmCaoNhất]
  FROM [BảngĐiểm];

  ### 2. Tại sao cần User-Defined Functions?

  Mục đích:
  - Tái sử dụng logic phức tạp
  - Đóng gói business rules
  - Làm code dễ đọc, dễ bảo trì

  3 loại chính:

  a) Scalar Function - Trả về 1 giá trị đơn
  - Dùng khi: Tính toán 1 giá trị từ nhiều tham số (tính tuổi, tính điểm trung bình có trọng số,
  format dữ liệu đặc biệt)

  b) Inline Table-Valued Function - Trả về bảng (1 câu SELECT)
  - Dùng khi: Lọc dữ liệu theo điều kiện phức tạp, có thể JOIN với bảng khác
  - Performance tốt nhất trong 3 loại

  c) Multi-statement Table-Valued Function - Trả về bảng (có logic phức tạp)
  - Dùng khi: Cần xử lý nhiều bước, dùng biến, vòng lặp trước khi trả kết quả

  Tại sao cần tự viết?
  - System functions chỉ xử lý logic chung chung
  - Business logic của mỗi dự án khác nhau (VD: Cách tính lương, cách tính điểm, quy tắc giảm giá
  riêng)

### 3. SCALAR FUNCTION (Hàm trả về một giá trị đơn)

  **Tính tổng tiền đã chi của một thành viên**

![5](images/5.png)

*Code scalar function*

Ta có:

    Input: @MaThanhVien INT →  Mã của thành viên cần tra cứu

    Đây là khóa chính của bảng [ThanhVien]

    Dùng để lọc đúng hóa đơn thuộc về thành viên đó trong bảng [HoaDon]

    Output:  RETURNS DECIMAL(12,2) →  Một con số tiền duy nhất

    Trả về tổng số tiền mà thành viên đó đã thanh toán thành công

    Kiểu DECIMAL(12,2) → tối đa 9,999,999,999.99 (đủ cho phòng game)

Logic xử lý bên trong

  Bảng [HoaDon]

  ├── Cột [MaThanhVien]          →  FK liên kết tới bảng [ThanhVien]
  ├── Cột [TongTienCanThanhToan] →  Số tiền của mỗi hóa đơn
  └── Cột [TrangThaiThanhToan]   →  'Chua_Thanh_Toan' | 'Da_Thanh_Toan' | 'Hoan_Tien'
  
## 2. INLINE TABLE-VALUED FUNCTION (Hàm bảng nội tuyến)





