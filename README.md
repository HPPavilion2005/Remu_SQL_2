# Remu_SQL_2

Bài tập hệ quản trị cơ sở dữ liệu số 2 | Sinh viên: Chu Trọng Tấn - MSSV: K235480106063

## Phần 1: Thiết kế và khởi tạo cấu trúc dữ liệu:

Database: Quanlyphonggame_K235480106063

![1](images/1.png)

### Khoá chính (PK): 

[MaThanhVien] trong bảng [ThanhVien]: định danh duy nhất cho mỗi thành viên

![2](images/2.png)

[MaMayTinh] trong bảng [MayTinh]: Định danh duy nhất cho mỗi máy tính

![3](images/3.png)

[MaHoaDon] trong bảng [HoaDon]: Định danh duy nhất cho mỗi hoá đơn

![4](images/4.png)

### Khoá ngoại (FK):

[MaThanhVien] trong bảng [HoaDon] → Tham chiếu đến [ThanhVien]([MaThanhVien])

[MaMayTinh] trong bảng [HoaDon] → Tham chiếu đến [MayTinh]([MaMayTinh])

*ON DELETE CASCADE: Nếu xóa thành viên, xóa luôn các hoá đơn của thành viên đó

### CHECK CONSTRAINT (CK) - Ràng buộc kiểm tra:

[TrangThaiTaiKhoan]: Chỉ chấp nhận: 'Hoat_Dong', 'Binh_Ngo', hoặc 'Khoai_Hoan'

[GiaThueGioTinh]: Phải > 0 (không thể có giá âm)

[NamPhatHanhMay]: Phải nằm trong khoảng 2010-2030

[TrangThaiMay]: Chỉ chấp nhận: 'San_Sang', 'Dang_Su_Dung', 'Bao_Tri', 'Hoi_Hang'

[TrangThaiThanhToan]: Chỉ chấp nhận: 'Chua_Thanh_Toan', 'Da_Thanh_Toan', 'Hoan_Tien'