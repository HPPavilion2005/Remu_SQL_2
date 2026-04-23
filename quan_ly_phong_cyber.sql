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
      -- Bước 1: Thống kê theo từng phòng
      INSERT INTO @KetQua (ViTriPhong, TongSoMay, MaySanSang, MayDangDung, MayBaoTri, MayHoiHang,
  TyLeSanSang)
      SELECT
          ViTriPhong,
          COUNT(*),
          SUM(CASE WHEN TrangThaiMay = N'San_Sang'      THEN 1 ELSE 0 END),
          SUM(CASE WHEN TrangThaiMay = N'Dang_Su_Dung'  THEN 1 ELSE 0 END),
          SUM(CASE WHEN TrangThaiMay = N'Bao_Tri'       THEN 1 ELSE 0 END),
          SUM(CASE WHEN TrangThaiMay = N'Hoi_Hang'      THEN 1 ELSE 0 END),
          0  -- Tạm thời
      FROM [MayTinh]
      GROUP BY ViTriPhong;

      -- Bước 2: Tính tỷ lệ sẵn sàng (%)
      UPDATE @KetQua
      SET TyLeSanSang = CASE
          WHEN TongSoMay > 0
          THEN CAST(MaySanSang AS DECIMAL(5,2)) / TongSoMay * 100
          ELSE 0
      END;

      RETURN;
  END;
  GO