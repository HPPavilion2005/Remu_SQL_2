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

*Code Scalar Function*
  
### 4. INLINE TABLE-VALUED FUNCTION (Hàm bảng nội tuyến)

  **Lấy danh sách máy tính theo vị trí phòng**

![6](images/6.png)

*Code Inline Table-Value Function*

### 5. MULTI-STATEMENT TABLE-VALUED FUNCTION (Hàm bảng nhiều câu lệnh)

  **Báo cáo tình trạng máy tính theo phòng**

![7](images/7.png)

*Code Multi-Statement Table-Valued Function*

### 6. Khai thác 3 hàm trên:

![8](images/8.png)

*Dữ liệu của 3 bảng*

**Scalar Function**

![9](images/9.png)

*Tổng chi của từng thành viên*

**Inline Table-Valued Function**

![10](images/10.png)

*Danh sách máy Phòng VIP*

**Multi-Statement Table-Valued Function**

![11](images/11.png)

*Phòng cần xử lý gấp (tỷ lệ sẵn sàng < 50%)*

------------------------------------------------

## Phần 3: Xây dựng Store Procedure:

### 1. Stored Procedure là gì?

Stored Procedure (SP) là một khối lệnh SQL được lưu sẵn trong database, đặt tên và có thể gọi lại nhiều lần. Giống như viết sẵn một "công thức nấu ăn" — mỗi lần cần chỉ việc gọi tên, không phải viết lại từ đầu.

    ┌──────────────────────────────────────┐
    │         STORED PROCEDURE             │
    │                                      │
    │  Input (@tham_số) ──► Xử lý logic    │
    │                        │             │
    │                  ┌─────┴──────┐      │
    │                  ▼            ▼      │
    │            OUTPUT trả    Result Set  │
    │            về giá trị    (bảng KQ)   │
    └──────────────────────────────────────┘

### Các System Store Procedure có sẵn:

    ┌──────────────────┬─────────────────────────┬─────────────────────────────────────┐
    │   SP hệ thống    │        Chức năng        │                Ví dụ                │
    ├──────────────────┼─────────────────────────┼─────────────────────────────────────┤
    │ sp_help          │ Xem thông tin đối tượng │ EXEC sp_help 'ThanhVien'            │
    ├──────────────────┼─────────────────────────┼─────────────────────────────────────┤
    │ sp_helptext      │ Xem mã nguồn            │ EXEC sp_helptext 'fn_TongTienDaChi' │
    ├──────────────────┼─────────────────────────┼─────────────────────────────────────┤
    │ sp_columns       │ Xem cột của bảng        │ EXEC sp_columns 'HoaDon'            │
    ├──────────────────┼─────────────────────────┼─────────────────────────────────────┤
    │ sp_tables        │ Liệt kê bảng            │ EXEC sp_tables                      │
    ├──────────────────┼─────────────────────────┼─────────────────────────────────────┤
    │ sp_databases     │ Liệt kê database        │ EXEC sp_databases                   │
    ├──────────────────┼─────────────────────────┼─────────────────────────────────────┤
    │ sp_who / sp_who2 │ Xem phiên kết nối       │ EXEC sp_who2                        │
    ├──────────────────┼─────────────────────────┼─────────────────────────────────────┤
    │ sp_rename        │ Đổi tên đối tượng       │ EXEC sp_rename 'A', 'B'             │
    ├──────────────────┼─────────────────────────┼─────────────────────────────────────┤
    │ sp_helpindex     │ Xem index               │ EXEC sp_helpindex 'HoaDon'          │
    └──────────────────┴─────────────────────────┴─────────────────────────────────────┘

### 2. SP - Insert/Update có kiểm tra điều kiện logic:

Bài toán

    Nạp tiền vào tài khoản thành viên. Cần kiểm tra:
    - Thành viên có tồn tại không?
    - Tài khoản có đang hoạt động không?
    - Số tiền nạp có hợp lệ không (> 0)?

![12](images/12.png)

*Code Insert/Update*

Khai thác:

**Trường hợp thành công**

![16](images/16.png)

**Trường hợp lỗi 1: Số tiền âm**

![17](images/17.png)

**Trường hợp lỗi 2: Thành viên không tồn tại**

![18](images/18.png)

**Trường hợp lỗi 3: TK bị khóa (TV mã 4 — Binh_Ngo)**

![19](images/19.png)

**Kiểm tra lại số dư sau khi nạp**

![20](images/20.png)

### 3. SP - Tham số Output

Bài toán

    Tính tiền cho một phiên sử dụng máy khi khách rời đi. SP cần:
    - Cập nhật thời gian kết thúc, số giờ, thành tiền vào bảng HoaDon
    - Trả ra ngoài (OUTPUT) tổng tiền phải thanh toán để hiển thị cho nhân viên

![13](images/13.png)

*Code có tham số output*

Khai thác:

![21](images/21.png)

*Trường hợp thành công*

**Trường hợp lỗi: hóa đơn không tồn tại**

![22](images/22.png)

### 4. SP trả về Result set - Join nhiều bảng

Bài toán

    Xem lịch sử sử dụng chi tiết: thông tin thành viên + máy đã dùng + hóa đơn. Lọc theo khoảng thời gian và tùy chọn theo phòng.

![14](images/14.png)

![15](images/15.png)

*Code Result set*

Khai thác:

**Xem tất cả phiên trong tháng 1/2026**

![23](images/23.png)

**Ngày không hợp lệ**

![24](images/24.png)

----------------------------------------------

## Phần 4: Trigger và Xử lý logic nghiệp vụ

Bài toán nghiệp vụ:

    Thực tế phòng game: Khi nhân viên tạo hóa đơn mới (INSERT vào HoaDon) nghĩa là khách bắt đầu ngồi máy → máy đó phải tự động chuyển sang trạng thái Dang_Su_Dung trong bảng MayTinh.
    Ngược lại, khi hóa đơn được cập nhật ThoiGianKetThuc (UPDATE HoaDon) nghĩa là khách rời máy → máy đó phải tự động chuyển về San_Sang.
    Nếu không có trigger, nhân viên phải nhớ cập nhật tay → dễ quên → dữ liệu sai.

Sơ đồ nghiệp vụ:

    Khách vào ngồi máy              Khách rời máy
        │                               │
        ▼                               ▼
    INSERT [HoaDon]                 UPDATE [HoaDon]
    (tạo hóa đơn mới)              (ghi ThoiGianKetThuc)
        │                               │
        ▼                               ▼
    ┌─ TRIGGER tự động ──┐         ┌─ TRIGGER tự động ──┐
    │ UPDATE [MayTinh]   │         │ UPDATE [MayTinh]   │
    │ SET Dang_Su_Dung   │         │ SET San_Sang       │
    └────────────────────┘         └────────────────────┘

### Trigger 1: Khi INSERT hóa đơn → Máy chuyển sang Dang_Su_Dung

![25](images/25.png)

*Code Trigger 1*

### Trigger 2: Khi UPDATE hóa đơn (ghi giờ kết thúc) → Máy chuyển về San_Sang

![26](images/26.png)

*Code Trigger 2*

### Khai thác:

**Xem trạng thái máy trước khi test**

![27](images/27.png)

**INSERT hóa đơn → Trigger tự chuyển máy**

![28](images/28.png)

**UPDATE hóa đơn (khách rời) → Trigger tự trả máy**

![29](images/29.png)

**Trường hợp bị từ chối**

![30](images/30.png)

### THÍ NGHIỆM TRIGGER VÒNG LẶP — BẢNG A ↔ BẢNG B

Bài toán

    Thử viết:
    - Trigger trên HoaDon (Bảng A): Khi INSERT → UPDATE MayTinh (Bảng B)
    - Trigger trên MayTinh (Bảng B): Khi UPDATE → UPDATE ngược HoaDon (Bảng A)
    Mục đích: Quan sát chuyện gì xảy ra khi 2 trigger "gọi nhau".

Trigger trên Bảng A (HoaDon) — đã có ở trên

Trigger trên Bảng B (MayTinh) — trigger ngược

![31](images/31.png)

*Code vòng lặp*

**Thực hiện thử nghiệm**

![32](images/32.png)

*Đảm bảo máy 103 (VIP-03) đang San_Sang*

![33](images/33.png)

*Tắt tạm trigger MayTinh để UPDATE trên không kích hoạt vòng lặp*

![34](images/34.png)

*Bật lại trigger*

![35](images/35.png)

*INSERT hóa đơn*

**Code trigger không kiểm tra điều kiện (chỉ cho vào file sql chứ không cho chạy)**

![36](images/36.png)

Giả sử nếu chạy thì thông báo lỗi của hệ thống như sau:

    Msg 217, Level 16, State 1, Procedure trg_VONG_LAP_A, Line X
    Maximum stored procedure, function, trigger, or view nesting level exceeded (limit 32).

Giải thích thông báo:

    ┌────────────────────────┬──────────────────────────────────────────────────────────┐
    │       Thành phần       │                         Ý nghĩa                          │
    ├────────────────────────┼──────────────────────────────────────────────────────────┤
    │ Msg 217                │ Mã lỗi: vượt quá giới hạn lồng nhau (nesting)            │
    ├────────────────────────┼──────────────────────────────────────────────────────────┤
    │ Level 16               │ Mức nghiêm trọng: lỗi do người dùng gây ra               │
    ├────────────────────────┼──────────────────────────────────────────────────────────┤
    │ State 1                │ Trạng thái lỗi cụ thể                                    │
    ├────────────────────────┼──────────────────────────────────────────────────────────┤
    │ Nesting level exceeded │ Trigger gọi nhau vượt quá 32 tầng                        │
    ├────────────────────────┼──────────────────────────────────────────────────────────┤
    │ (limit 32)             │ SQL Server cho phép tối đa 32 lần lồng trigger/procedure │
    └────────────────────────┴──────────────────────────────────────────────────────────┘

### NHẬN XÉT CUỐI CÙNG VỀ TÌNH TRẠNG TRIGGER VÒNG LẶP

| Tình huống | Kết quả | Nguyên nhân |
| :--- | :--- | :--- |
| Trigger A → B (1 chiều) | ✅ An toàn | Không có vòng lặp |
| Trigger A → B → A (có điều kiện dừng) | ✅ An toàn | Chuỗi tự dừng khi điều kiện không khớp |
| Trigger A ↔ B (không điều kiện dừng) | ❌ **Lỗi Msg 217** | Vòng lặp vượt 32 tầng → ROLLBACK |
| Trigger A → A (recursive, OFF) | ✅ Không chạy lại | `RECURSIVE_TRIGGERS` mặc định OFF |
| Trigger A → A (recursive, ON) | ⚠️ Nguy hiểm | Tự gọi chính mình → có thể vượt 32 tầng |

## Phần 5: Cursor và Duyệt dữ liệu

### 1. Cursor là gì?

Cursor là cơ chế cho phép duyệt từng dòng một trong tập kết quả SELECT, thay vì xử lý cả bảng cùng lúc.

  SQL thông thường (Set-based):          CURSOR (Row-by-row):

    ┌──────────────────────┐              ┌──────────────────────┐
    │  Dòng 1              │              │► Dòng 1 ← xử lý      │
    │  Dòng 2              │  Xử lý       │  Dòng 2              │
    │  Dòng 3              │  CÙNG LÚC    │  Dòng 3              │
    │  Dòng 4              │  ══════►     │  Dòng 4              │
    │  Dòng 5              │  Kết quả     │  Dòng 5              │
    └──────────────────────┘              └──────────────────────┘
                                                    │
                                                    ▼
                                        ┌──────────────────────┐
                                        │  Dòng 1              │
                                        │► Dòng 2 ← xử lý      │
                                        │  Dòng 3              │
                                        │  ...lặp lại...       │
                                        └──────────────────────┘

Vòng đời của CURSOR

    DECLARE  →  OPEN  →  FETCH NEXT  →  WHILE  →  CLOSE  →  DEALLOCATE
    (khai       (mở      (lấy dòng     (lặp      (đóng     (giải phóng
    báo)       cursor)   đầu tiên)     xử lý)    cursor)    bộ nhớ)