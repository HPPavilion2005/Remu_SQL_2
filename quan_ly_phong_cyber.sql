CREATE TABLE [ThanhVien] (
    [MaThanhVien] INT PRIMARY KEY IDENTITY(1,1),           
    [TenDangNhap] NVARCHAR(50) NOT NULL UNIQUE,           
    [MatKhau] NVARCHAR(100) NOT NULL,                    
    [HoTen] NVARCHAR(100) NOT NULL,                       
    [EmailLienHe] VARCHAR(100) UNIQUE,                    
    [SoDienThoai] VARCHAR(15),                            
    [NgayThamGia] DATE NOT NULL DEFAULT GETDATE(),      
    [NgayThangNamSinh] DATE,                            
    [SoDuTaiKhoan] DECIMAL(10,2) NOT NULL DEFAULT 0,    
    [TrangThaiTaiKhoan] NVARCHAR(20) NOT NULL DEFAULT 'Hoat_Dong'
        CHECK ([TrangThaiTaiKhoan] IN ('Hoat_Dong', 'Binh_Ngo', 'Khoai_Hoan')), 
    [GhiChu] NVARCHAR(500)                              
);

CREATE TABLE [MayTinh] (
    [MaMayTinh] INT PRIMARY KEY IDENTITY(101,1),        
    [TenMayTinh] NVARCHAR(50) NOT NULL,                  
    [DiaChi_IP] VARCHAR(15) UNIQUE NOT NULL,             
    [ViTriPhong] NVARCHAR(50) NOT NULL,                   
    [LouHuaGiaBan] DECIMAL(8,3) NOT NULL,                 
    [GiaThueGioTinh] DECIMAL(7,2) NOT NULL CHECK ([GiaThueGioTinh] > 0), 
    [NamPhatHanhMay] INT NOT NULL CHECK ([NamPhatHanhMay] BETWEEN 2010 AND 2030),
    [TrangThaiMay] NVARCHAR(20) NOT NULL DEFAULT 'San_Sang'
        CHECK ([TrangThaiMay] IN ('San_Sang', 'Dang_Su_Dung', 'Bao_Tri', 'Hoi_Hang')),
    [LanBaoTriGanNhat] DATETIME DEFAULT GETDATE(),       
    [GhiChu] NVARCHAR(300)                               
);

CREATE TABLE [HoaDon] (
    [MaHoaDon] INT PRIMARY KEY IDENTITY(1001,1),         
    [MaThanhVien] INT NOT NULL,                           
    [MaMayTinh] INT NOT NULL,                           
    [ThoiGianBatDau] DATETIME NOT NULL,                   
    [ThoiGianKetThuc] DATETIME,                         
    [SoGioSuDung] DECIMAL(6,2),                        
    [GiaThueThucTe] DECIMAL(8,2),                         
    [ThanhTienDichVu] DECIMAL(10,2),                      
    [SoTienDichVuThem] DECIMAL(10,2) DEFAULT 0,           
    [TongTienCanThanhToan] DECIMAL(10,2),                 
    [TrangThaiThanhToan] NVARCHAR(20) NOT NULL DEFAULT 'Chua_Thanh_Toan'
        CHECK ([TrangThaiThanhToan] IN ('Chua_Thanh_Toan', 'Da_Thanh_Toan', 'Hoan_Tien')), 
    [NguoiThanhToan] NVARCHAR(100),                       
    [NgayThanhToan] DATETIME,                            
    [PhuongThucThanhToan] NVARCHAR(50),                  
    [GhiChu] NVARCHAR(300),                             

    CONSTRAINT [FK_HoaDon_ThanhVien] FOREIGN KEY ([MaThanhVien])
        REFERENCES [ThanhVien]([MaThanhVien]) ON DELETE CASCADE,
    CONSTRAINT [FK_HoaDon_MayTinh] FOREIGN KEY ([MaMayTinh])
        REFERENCES [MayTinh]([MaMayTinh]) ON DELETE CASCADE
);

CREATE INDEX [IX_ThanhVien_TenDangNhap] ON [ThanhVien]([TenDangNhap]);
CREATE INDEX [IX_MayTinh_TrangThaiMay] ON [MayTinh]([TrangThaiMay]);
CREATE INDEX [IX_HoaDon_MaThanhVien] ON [HoaDon]([MaThanhVien]);
CREATE INDEX [IX_HoaDon_MaMayTinh] ON [HoaDon]([MaMayTinh]);
CREATE INDEX [IX_HoaDon_TrangThaiThanhToan] ON [HoaDon]([TrangThaiThanhToan]);
GO

CREATE FUNCTION fn_TongTienDaChi (@MaThanhVien INT)
  RETURNS DECIMAL(12,2)
  AS
  BEGIN
      DECLARE @TongTien DECIMAL(12,2);

      SELECT @TongTien = ISNULL(SUM(TongTienCanThanhToan), 0)
      FROM [HoaDon]
      WHERE [MaThanhVien] = @MaThanhVien
        AND [TrangThaiThanhToan] = 'Da_Thanh_Toan';

      RETURN @TongTien;
  END;
  GO

  CREATE FUNCTION fn_MayTinhTheoPhong (@ViTriPhong NVARCHAR(50))
  RETURNS TABLE
  AS
  RETURN
  (
      SELECT
          MaMayTinh,
          TenMayTinh,
          DiaChi_IP,
          GiaThueGioTinh,
          TrangThaiMay,
          NamPhatHanhMay,
          LanBaoTriGanNhat
      FROM [MayTinh]
      WHERE [ViTriPhong] = @ViTriPhong
  );
  GO

  CREATE FUNCTION fn_TinhTrangMayTheoPhong ()
  RETURNS @KetQua TABLE
  (
      ViTriPhong       NVARCHAR(50),
      TongSoMay        INT,
      MaySanSang       INT,
      MayDangDung      INT,
      MayBaoTri        INT,
      MayHoiHang       INT,
      TyLeSanSang      DECIMAL(5,2)
  )
  AS
  BEGIN
      INSERT INTO @KetQua (ViTriPhong, TongSoMay, MaySanSang, MayDangDung, MayBaoTri, MayHoiHang,
  TyLeSanSang)
      SELECT
          ViTriPhong,
          COUNT(*),
          SUM(CASE WHEN TrangThaiMay = N'San_Sang'      THEN 1 ELSE 0 END),
          SUM(CASE WHEN TrangThaiMay = N'Dang_Su_Dung'  THEN 1 ELSE 0 END),
          SUM(CASE WHEN TrangThaiMay = N'Bao_Tri'       THEN 1 ELSE 0 END),
          SUM(CASE WHEN TrangThaiMay = N'Hoi_Hang'      THEN 1 ELSE 0 END),
          0 
      FROM [MayTinh]
      GROUP BY ViTriPhong;

      UPDATE @KetQua
      SET TyLeSanSang = CASE
          WHEN TongSoMay > 0
          THEN CAST(MaySanSang AS DECIMAL(5,2)) / TongSoMay * 100
          ELSE 0
      END;

      RETURN;
  END;
  GO

INSERT INTO [ThanhVien]
      ([TenDangNhap], [MatKhau], [HoTen], [EmailLienHe], [SoDienThoai],
       [NgayThamGia], [NgayThangNamSinh], [SoDuTaiKhoan], [TrangThaiTaiKhoan], [GhiChu])
  VALUES
      (N'remu_01',    N'Mk@12345',  N'Nguyễn Văn An',    'an.nguyen@gmail.com',    '0901000001',
       '2024-01-15', '2000-05-20', 1500000, N'Hoat_Dong',  N'Khách quen'),

      (N'sakura_02',  N'Sk@67890',  N'Trần Thị Bích',    'bich.tran@gmail.com',    '0901000002',
       '2024-02-10', '1999-08-14', 350000,  N'Hoat_Dong',  NULL),

      (N'miku_03',    N'Mk@11111',  N'Lê Hoàng Cường',   'cuong.le@yahoo.com',     '0901000003',
       '2024-03-05', '2001-12-01', 5200000, N'Hoat_Dong',  N'Thành viên VIP'),

      (N'emilia_04',  N'Em@22222',  N'Phạm Minh Dũng',   'dung.pham@outlook.com',  '0901000004',
       '2024-04-20', '1998-03-30', 120000,  N'Binh_Ngo',   N'Tài khoản tạm khóa'),

      (N'natsuki_05', N'Nt@33333',  N'Hoàng Thị Lan',    'lan.hoang@gmail.com',    '0901000005',
       '2024-05-12', '2002-07-25', 800000,  N'Hoat_Dong',  NULL),

      (N'subaru_06',  N'Sb@44444',  N'Võ Đức Mạnh',      'manh.vo@gmail.com',      '0901000006',
       '2024-06-01', '2000-11-11', 2200000, N'Hoat_Dong',  N'Hay chơi đêm'),

      (N'rem_07',     N'Rm@55555',  N'Đặng Thùy Ngọc',   'ngoc.dang@gmail.com',    '0901000007',
       '2024-07-18', '2003-01-09', 60000,   N'Hoat_Dong',  NULL),

      (N'felix_08',   N'Fx@66666',  N'Bùi Quốc Phong',   'phong.bui@yahoo.com',    '0901000008',
       '2025-01-10', '1997-09-05', 3100000, N'Hoat_Dong',  N'Thành viên lâu năm'),

      (N'beatrice_09',N'Bt@77777',  N'Trương Thị Quỳnh',  'quynh.truong@gmail.com', '0901000009',
       '2025-03-22', '2001-06-17', 450000,  N'Khoai_Hoan', N'Đã rời'),

      (N'otto_10',    N'Ot@88888',  N'Ngô Thanh Sơn',    'son.ngo@outlook.com',    '0901000010',
       '2025-06-05', '2004-02-28', 200000,  N'Hoat_Dong',  N'Thành viên mới');

INSERT INTO [MayTinh]
      ([TenMayTinh], [DiaChi_IP], [ViTriPhong], [LouHuaGiaBan], [GiaThueGioTinh],
       [NamPhatHanhMay], [TrangThaiMay], [LanBaoTriGanNhat], [GhiChu])
VALUES
      -- ═══════ Phòng VIP (4 máy) ═══════
      (N'VIP-01', '192.168.1.1',  N'Phong VIP', 25000.000, 35000, 2024, N'Dang_Su_Dung', '2026-04-01',
  N'Máy cấu hình cao'),
      (N'VIP-02', '192.168.1.2',  N'Phong VIP', 25000.000, 35000, 2024, N'San_Sang',     '2026-04-01',
  NULL),
      (N'VIP-03', '192.168.1.3',  N'Phong VIP', 28000.000, 40000, 2025, N'San_Sang',     '2026-03-15',
  N'Máy mới nhất'),
      (N'VIP-04', '192.168.1.4',  N'Phong VIP', 28000.000, 40000, 2025, N'Bao_Tri',      '2026-04-20',
  N'Đang nâng cấp RAM'),

      -- ═══════ Phòng 1 (4 máy) ═══════
      (N'P1-01',  '192.168.2.1',  N'Phong 1',   15000.000, 15000, 2022, N'San_Sang',     '2026-03-10',
  NULL),
      (N'P1-02',  '192.168.2.2',  N'Phong 1',   15000.000, 15000, 2022, N'Dang_Su_Dung', '2026-03-10',
  NULL),
      (N'P1-03',  '192.168.2.3',  N'Phong 1',   15000.000, 15000, 2021, N'Hoi_Hang',     '2026-01-05',
  N'Hỏng nguồn'),
      (N'P1-04',  '192.168.2.4',  N'Phong 1',   16000.000, 18000, 2023, N'San_Sang',     '2026-04-10',
  NULL),

      -- ═══════ Phòng 2 (4 máy) ═══════
      (N'P2-01',  '192.168.3.1',  N'Phong 2',   18000.000, 20000, 2023, N'San_Sang',     '2026-04-05',
  NULL),
      (N'P2-02',  '192.168.3.2',  N'Phong 2',   18000.000, 20000, 2023, N'Dang_Su_Dung', '2026-04-05',
  NULL),
      (N'P2-03',  '192.168.3.3',  N'Phong 2',   18000.000, 20000, 2022, N'Hoi_Hang',     '2025-12-20',
  N'Hỏng mainboard'),
      (N'P2-04',  '192.168.3.4',  N'Phong 2',   19000.000, 22000, 2024, N'Hoi_Hang',     '2025-11-15',
  N'Chờ thay linh kiện');

INSERT INTO [HoaDon]
      ([MaThanhVien], [MaMayTinh], [ThoiGianBatDau], [ThoiGianKetThuc],
       [SoGioSuDung], [GiaThueThucTe], [ThanhTienDichVu], [SoTienDichVuThem],
       [TongTienCanThanhToan], [TrangThaiThanhToan], [NguoiThanhToan],
       [NgayThanhToan], [PhuongThucThanhToan], [GhiChu])
VALUES
      -- ══ Thành viên 1 (Nguyễn Văn An) — 3 hóa đơn ══
      (1, 101, '2026-01-10 08:00', '2026-01-10 13:00',
       5.00, 35000, 175000, 25000,
       200000, N'Da_Thanh_Toan', N'Nguyễn Văn An',
       '2026-01-10 13:05', N'Tien_Mat', NULL),

      (1, 103, '2026-02-14 09:00', '2026-02-14 15:00',
       6.00, 40000, 240000, 0,
       240000, N'Da_Thanh_Toan', N'Nguyễn Văn An',
       '2026-02-14 15:10', N'Chuyen_Khoan', NULL),

      (1, 105, '2026-04-20 19:00', '2026-04-20 23:00',
       4.00, 15000, 60000, 30000,
       90000, N'Chua_Thanh_Toan', NULL,
       NULL, NULL, N'Chưa thanh toán'),

      -- ══ Thành viên 2 (Trần Thị Bích) — 2 hóa đơn ══
      (2, 106, '2026-01-20 10:00', '2026-01-20 12:00',
       2.00, 15000, 30000, 10000,
       40000, N'Da_Thanh_Toan', N'Trần Thị Bích',
       '2026-01-20 12:05', N'Tien_Mat', NULL),

      (2, 109, '2026-03-08 14:00', '2026-03-08 18:00',
       4.00, 20000, 80000, 0,
       80000, N'Da_Thanh_Toan', N'Trần Thị Bích',
       '2026-03-08 18:10', N'Vi_Dien_Tu', NULL),

      -- ══ Thành viên 3 (Lê Hoàng Cường) — 4 hóa đơn ══
      (3, 101, '2026-01-05 20:00', '2026-01-06 02:00',
       6.00, 35000, 210000, 50000,
       260000, N'Da_Thanh_Toan', N'Lê Hoàng Cường',
       '2026-01-06 02:10', N'Chuyen_Khoan', N'Chơi đêm'),

      (3, 103, '2026-02-20 15:00', '2026-02-20 21:00',
       6.00, 40000, 240000, 80000,
       320000, N'Da_Thanh_Toan', N'Lê Hoàng Cường',
       '2026-02-20 21:15', N'Chuyen_Khoan', NULL),

      (3, 101, '2026-03-15 09:00', '2026-03-15 17:00',
       8.00, 35000, 280000, 45000,
       325000, N'Da_Thanh_Toan', N'Lê Hoàng Cường',
       '2026-03-15 17:05', N'Tien_Mat', NULL),

      (3, 103, '2026-04-10 10:00', '2026-04-10 20:00',
       10.00, 40000, 400000, 100000,
       500000, N'Da_Thanh_Toan', N'Lê Hoàng Cường',
       '2026-04-10 20:20', N'Chuyen_Khoan', N'Giải đấu'),

      -- ══ Thành viên 5 (Hoàng Thị Lan) — 2 hóa đơn ══
      (5, 102, '2026-02-05 13:00', '2026-02-05 16:00',
       3.00, 35000, 105000, 0,
       105000, N'Da_Thanh_Toan', N'Hoàng Thị Lan',
       '2026-02-05 16:05', N'Tien_Mat', NULL),

      (5, 108, '2026-03-25 10:00', '2026-03-25 14:00',
       4.00, 18000, 72000, 15000,
       87000, N'Da_Thanh_Toan', N'Hoàng Thị Lan',
       '2026-03-25 14:10', N'Vi_Dien_Tu', NULL),

      -- ══ Thành viên 6 (Võ Đức Mạnh) — 3 hóa đơn ══
      (6, 101, '2026-01-18 22:00', '2026-01-19 04:00',
       6.00, 35000, 210000, 60000,
       270000, N'Da_Thanh_Toan', N'Võ Đức Mạnh',
       '2026-01-19 04:10', N'Tien_Mat', N'Chơi đêm'),

      (6, 103, '2026-03-01 20:00', '2026-03-02 03:00',
       7.00, 40000, 280000, 40000,
       320000, N'Da_Thanh_Toan', N'Võ Đức Mạnh',
       '2026-03-02 03:15', N'Chuyen_Khoan', N'Chơi đêm'),

      (6, 109, '2026-04-15 14:00', '2026-04-15 19:00',
       5.00, 20000, 100000, 20000,
       120000, N'Hoan_Tien', N'Võ Đức Mạnh',
       '2026-04-15 19:30', N'Chuyen_Khoan', N'Máy lỗi hoàn tiền'),

      -- ══ Thành viên 7 (Đặng Thùy Ngọc) — 1 hóa đơn ══
      (7, 105, '2026-04-01 08:00', '2026-04-01 10:00',
       2.00, 15000, 30000, 0,
       30000, N'Da_Thanh_Toan', N'Đặng Thùy Ngọc',
       '2026-04-01 10:05', N'Tien_Mat', NULL),

      -- ══ Thành viên 8 (Bùi Quốc Phong) — 3 hóa đơn ══
      (8, 103, '2026-01-25 09:00', '2026-01-25 18:00',
       9.00, 40000, 360000, 70000,
       430000, N'Da_Thanh_Toan', N'Bùi Quốc Phong',
       '2026-01-25 18:10', N'Chuyen_Khoan', NULL),

      (8, 101, '2026-02-28 10:00', '2026-02-28 16:00',
       6.00, 35000, 210000, 30000,
       240000, N'Da_Thanh_Toan', N'Bùi Quốc Phong',
       '2026-02-28 16:05', N'Tien_Mat', NULL),

      (8, 110, '2026-04-05 15:00', '2026-04-05 20:00',
       5.00, 20000, 100000, 25000,
       125000, N'Da_Thanh_Toan', N'Bùi Quốc Phong',
       '2026-04-05 20:10', N'Vi_Dien_Tu', NULL),

      -- ══ Thành viên 10 (Ngô Thanh Sơn) — 1 hóa đơn ══
      (10, 108, '2026-04-18 16:00', '2026-04-18 19:00',
       3.00, 18000, 54000, 0,
       54000, N'Chua_Thanh_Toan', NULL,
       NULL, NULL, N'Thành viên mới'),

      -- ══ Thành viên 3 — đang dùng máy (chưa kết thúc) ══
      (3, 101, '2026-04-23 08:00', NULL,
       NULL, 35000, NULL, NULL,
       NULL, N'Chua_Thanh_Toan', NULL,
       NULL, NULL, N'Đang sử dụng'),

      -- ══ Thành viên 6 — đang dùng máy (chưa kết thúc) ══
      (6, 110, '2026-04-23 09:30', NULL,
       NULL, 20000, NULL, NULL,
       NULL, N'Chua_Thanh_Toan', NULL,
       NULL, NULL, N'Đang sử dụng');

SELECT * FROM ThanhVien;
SELECT * FROM MayTinh;
SELECT * FROM HoaDon;

SELECT
      MaThanhVien,
      HoTen,
      dbo.fn_TongTienDaChi(MaThanhVien) AS TongTienDaChi
FROM [ThanhVien]
ORDER BY TongTienDaChi DESC;

SELECT *
    FROM dbo.fn_MayTinhTheoPhong(N'Phong VIP')
    ORDER BY GiaThueGioTinh ASC;

SELECT
      ViTriPhong,
      TongSoMay,
      MayHoiHang,
      TyLeSanSang,
      CASE
          WHEN TyLeSanSang >= 80 THEN N'Tốt'
          WHEN TyLeSanSang >= 50 THEN N'Trung bình'
          ELSE N'Cần xử lý gấp'
      END AS DanhGia
  FROM dbo.fn_TinhTrangMayTheoPhong()
  ORDER BY TyLeSanSang ASC;
GO

CREATE PROCEDURE sp_NapTienTaiKhoan
      @MaThanhVien INT,
      @SoTienNap   DECIMAL(10,2)
  AS
  BEGIN
      IF @SoTienNap <= 0
      BEGIN
          PRINT N'Lỗi: Số tiền nạp phải lớn hơn 0.';
          RETURN;
      END;

      IF NOT EXISTS (SELECT 1 FROM [ThanhVien] WHERE [MaThanhVien] = @MaThanhVien)
      BEGIN
          PRINT N'Lỗi: Không tìm thấy thành viên có mã ' + CAST(@MaThanhVien AS NVARCHAR);
          RETURN;
      END;

      DECLARE @TrangThai NVARCHAR(20);
      SELECT @TrangThai = [TrangThaiTaiKhoan]
      FROM [ThanhVien]
      WHERE [MaThanhVien] = @MaThanhVien;

      IF @TrangThai != N'Hoat_Dong'
      BEGIN
          PRINT N'Lỗi: Tài khoản đang ở trạng thái "' + @TrangThai
              + N'" — chỉ tài khoản "Hoat_Dong" mới được nạp tiền.';
          RETURN;
      END;

      UPDATE [ThanhVien]
      SET [SoDuTaiKhoan] = [SoDuTaiKhoan] + @SoTienNap
      WHERE [MaThanhVien] = @MaThanhVien;

      DECLARE @SoDuMoi DECIMAL(10,2);
      SELECT @SoDuMoi = [SoDuTaiKhoan]
      FROM [ThanhVien]
      WHERE [MaThanhVien] = @MaThanhVien;

      PRINT N'Nạp thành công '
          + CAST(@SoTienNap AS NVARCHAR)
          + N' cho thành viên mã '
          + CAST(@MaThanhVien AS NVARCHAR)
          + N'. Số dư mới: '
          + CAST(@SoDuMoi AS NVARCHAR);
  END;
  GO

  CREATE PROCEDURE sp_TinhTienPhien
      @MaHoaDon           INT,
      @TongTienThanhToan   DECIMAL(10,2) OUTPUT 
  AS
  BEGIN

      IF NOT EXISTS (SELECT 1 FROM [HoaDon] WHERE [MaHoaDon] = @MaHoaDon)
      BEGIN
          PRINT N'Không tìm thấy hóa đơn mã ' + CAST(@MaHoaDon AS NVARCHAR);
          SET @TongTienThanhToan = 0;
          RETURN;
      END;

      DECLARE @ThoiGianKetThuc DATETIME;
      SELECT @ThoiGianKetThuc = [ThoiGianKetThuc]
      FROM [HoaDon]
      WHERE [MaHoaDon] = @MaHoaDon;

      IF @ThoiGianKetThuc IS NOT NULL
      BEGIN
          PRINT N'Hóa đơn này đã được tính tiền trước đó.';
          SELECT @TongTienThanhToan = [TongTienCanThanhToan]
          FROM [HoaDon]
          WHERE [MaHoaDon] = @MaHoaDon;
          RETURN;
      END;

      DECLARE @ThoiGianBatDau   DATETIME;
      DECLARE @GiaThue          DECIMAL(8,2);
      DECLARE @DichVuThem       DECIMAL(10,2);
      DECLARE @SoGio            DECIMAL(6,2);
      DECLARE @ThanhTienMay     DECIMAL(10,2);

      SELECT
          @ThoiGianBatDau = hd.[ThoiGianBatDau],
          @GiaThue        = hd.[GiaThueThucTe],
          @DichVuThem     = ISNULL(hd.[SoTienDichVuThem], 0)
      FROM [HoaDon] hd
      WHERE hd.[MaHoaDon] = @MaHoaDon;

      SET @SoGio = CEILING(DATEDIFF(MINUTE, @ThoiGianBatDau, GETDATE()) / 30.0) * 0.5;

      IF @SoGio < 1
          SET @SoGio = 1;

      SET @ThanhTienMay = @SoGio * @GiaThue;
      SET @TongTienThanhToan = @ThanhTienMay + @DichVuThem;    -- ← Gán vào OUTPUT

      UPDATE [HoaDon]
      SET
          [ThoiGianKetThuc]     = GETDATE(),
          [SoGioSuDung]         = @SoGio,
          [ThanhTienDichVu]     = @ThanhTienMay,
          [TongTienCanThanhToan] = @TongTienThanhToan
      WHERE [MaHoaDon] = @MaHoaDon;

      PRINT N'Đã tính tiền hóa đơn ' + CAST(@MaHoaDon AS NVARCHAR);
      PRINT N'   Số giờ: '         + CAST(@SoGio AS NVARCHAR);
      PRINT N'   Tiền máy: '       + CAST(@ThanhTienMay AS NVARCHAR);
      PRINT N'   Dịch vụ thêm: '   + CAST(@DichVuThem AS NVARCHAR);
      PRINT N'   ► TỔNG CỘNG: '    + CAST(@TongTienThanhToan AS NVARCHAR);
  END;
  GO

CREATE PROCEDURE sp_LichSuSuDungChiTiet
      @TuNgay     DATE,
      @DenNgay    DATE,
      @ViTriPhong NVARCHAR(50) = NULL  
  AS
  BEGIN
      IF @TuNgay > @DenNgay
      BEGIN
          PRINT N'Lỗi: Ngày bắt đầu không được lớn hơn ngày kết thúc.';
          RETURN;
      END;

      SELECT
          tv.MaThanhVien,
          tv.HoTen,
          tv.TenDangNhap,
          tv.SoDienThoai,

          mt.TenMayTinh,
          mt.ViTriPhong,
          mt.GiaThueGioTinh           AS GiaNiemYet,

          hd.MaHoaDon,
          hd.ThoiGianBatDau,
          hd.ThoiGianKetThuc,
          hd.SoGioSuDung,
          hd.GiaThueThucTe,
          hd.ThanhTienDichVu          AS TienMay,
          hd.SoTienDichVuThem         AS TienDichVu,
          hd.TongTienCanThanhToan     AS TongTien,
          hd.TrangThaiThanhToan,
          hd.PhuongThucThanhToan

      FROM [HoaDon] hd
      INNER JOIN [ThanhVien] tv
          ON hd.MaThanhVien = tv.MaThanhVien
      INNER JOIN [MayTinh] mt
          ON hd.MaMayTinh = mt.MaMayTinh

      WHERE
          CAST(hd.ThoiGianBatDau AS DATE) BETWEEN @TuNgay AND @DenNgay
          AND (@ViTriPhong IS NULL OR mt.ViTriPhong = @ViTriPhong)

      ORDER BY hd.ThoiGianBatDau DESC;

      SELECT
          COUNT(*)                                    AS TongSoPhien,
          ISNULL(SUM(hd.SoGioSuDung), 0)              AS TongSoGio,
          ISNULL(SUM(CASE
              WHEN hd.TrangThaiThanhToan = 'Da_Thanh_Toan'
              THEN hd.TongTienCanThanhToan ELSE 0
          END), 0)                                     AS TongDoanhThu,
          COUNT(DISTINCT hd.MaThanhVien)               AS SoThanhVienKhacNhau,
          COUNT(DISTINCT hd.MaMayTinh)                 AS SoMayDuocDung

      FROM [HoaDon] hd
      INNER JOIN [MayTinh] mt ON hd.MaMayTinh = mt.MaMayTinh
      WHERE
          CAST(hd.ThoiGianBatDau AS DATE) BETWEEN @TuNgay AND @DenNgay
          AND (@ViTriPhong IS NULL OR mt.ViTriPhong = @ViTriPhong);

      PRINT N'Truy vấn hoàn tất: từ '
          + CAST(@TuNgay AS NVARCHAR) + N' đến ' + CAST(@DenNgay AS NVARCHAR)
          + CASE
              WHEN @ViTriPhong IS NOT NULL THEN N' — Phòng: ' + @ViTriPhong
              ELSE N' — Tất cả phòng'
            END;
  END;
  GO

  EXEC sp_NapTienTaiKhoan @MaThanhVien = 1, @SoTienNap = 500000;
  EXEC sp_NapTienTaiKhoan @MaThanhVien = 1, @SoTienNap = -100;
  EXEC sp_NapTienTaiKhoan @MaThanhVien = 999, @SoTienNap = 100000;
  EXEC sp_NapTienTaiKhoan @MaThanhVien = 4, @SoTienNap = 200000;
  SELECT MaThanhVien, HoTen, SoDuTaiKhoan FROM [ThanhVien] WHERE MaThanhVien = 1;