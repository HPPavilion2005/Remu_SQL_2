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
