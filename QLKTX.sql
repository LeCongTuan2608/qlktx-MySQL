CREATE SCHEMA `qlktx` ;

-- -------------------------- phân quyền --------------------------
-- @ localhost: dùng trên máy mình
-- @ %: dùng kết nối từ xa

-- tao role super admin
CREATE ROLE role_admin;
CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY '1'; -- tạo người dùng
GRANT ALL PRIVILEGES ON qlktx.* TO role_admin; -- cấp quyền cho role trong phạm vi db:qlktx
GRANT role_admin TO 'admin'@'localhost'; -- gán cho user với role là "role_admin"
FLUSH PRIVILEGES; -- lưu

-- tao quyen cho truong phong
CREATE ROLE role_truong_phong;
CREATE USER IF NOT EXISTS 'truong_phong'@'localhost' IDENTIFIED BY '1'; -- tạo người dùng
GRANT  ALL PRIVILEGES ON qlktx.sinh_vien TO role_truong_phong;    -- cấp cho tất cả quyền của bảng "sinh_vien"                 
GRANT  ALL PRIVILEGES ON qlktx.khen_ky_luat TO role_truong_phong; -- cấp cho tất cả quyền của bảng "khen_ky_luat" 
GRANT  ALL PRIVILEGES ON qlktx.phong TO role_truong_phong; 			-- cấp cho tất cả quyền của bảng "phong" 
GRANT  ALL PRIVILEGES ON qlktx.hop_dong_sv TO role_truong_phong;	-- cấp cho tất cả quyền của bảng "hop_dong_sv" 

GRANT  SELECT ON qlktx.chuc_vu TO role_truong_phong; -- cấp cho quyền xem thông tin của bảng "chuc_vu" 
GRANT  SELECT ON qlktx.loai_phong TO role_truong_phong; -- cấp cho quyền xem thông tin của bảng "loai_phong" 
GRANT  SELECT ON qlktx.hop_dong_nv TO role_truong_phong; -- cấp cho quyền xem thông tin của bảng "hop_dong_nv" 
GRANT  SELECT ON qlktx.toa TO role_truong_phong; 	-- cấp cho quyền xem thông tin của bảng "toa" 
GRANT role_truong_phong TO 'truong_phong'@'localhost'; -- gán cho user với role là "role_truong_phong"
FLUSH PRIVILEGES;


-- tao quyen cho ke toan
CREATE ROLE role_ke_toan;
CREATE USER IF NOT EXISTS 'ketoan1'@'localhost' IDENTIFIED BY '1';
GRANT  ALL PRIVILEGES ON qlktx.hoa_don_dien_nuoc TO role_ke_toan;                        

GRANT  SELECT ON qlktx.chuc_vu TO role_ke_toan;
GRANT  SELECT ON qlktx.loai_phong TO role_ke_toan;
GRANT  SELECT ON qlktx.hop_dong_nv TO role_ke_toan;
GRANT  SELECT ON qlktx.phong TO role_ke_toan;
GRANT  SELECT ON qlktx.toa TO role_ke_toan;
GRANT  SELECT ON qlktx.khen_ky_luat TO role_ke_toan;

GRANT role_ke_toan TO 'ketoan1'@'localhost';
FLUSH PRIVILEGES;


-- tao quyen cho sinh vien
CREATE ROLE role_sinh_vien;
CREATE USER IF NOT EXISTS 'sinhvien1'@'localhost' IDENTIFIED BY '1'; -- tạo ng dùng
GRANT  SELECT, UPDATE ON qlktx.than_nhan TO role_sinh_vien;                     

GRANT  SELECT, UPDATE (cmnd, ho_ten, gioi_tinh, ngay_sinh, dia_chi, sdt) ON qlktx.sinh_vien TO role_sinh_vien;
GRANT  SELECT, UPDATE (trang_thai) ON qlktx.hoa_don_dien_nuoc TO role_sinh_vien;
GRANT  SELECT ON qlktx.phong TO role_sinh_vien;
GRANT  SELECT ON qlktx.toa TO role_sinh_vien;
GRANT  SELECT ON qlktx.loai_phong TO role_sinh_vien;

GRANT role_sinh_vien TO 'ketoan1'@'localhost';
FLUSH PRIVILEGES;


-- xóa role
DROP ROLE role_admin;


show grants;
-- xóa phân quyền
DROP USER 'tuanpro'@'localhost'; -- xóa quyền ng dùng
DELETE FROM `mysql`.`user` WHERE (`Host` = 'localhost') and (`User` = 'tuanpro');
                      

SELECT * FROM mysql.user; -- xem các user đã tạo

-- --------------------------------Tạo bảng-----------------------------------------



CREATE TABLE `qlktx`.`chuc_vu` (
  `ma_chuc_vu` varchar(50) NOT NULL PRIMARY KEY,
  `ten_chuc_vu` NVARCHAR(200) NOT NULL
);
CREATE TABLE `qlktx`.`loai_quyen` (
  `id_loai_quyen` INT NOT NULL PRIMARY KEY,
  `ten_quyen` NVARCHAR(50) NOT NULL,
  `mo_ta` NVARCHAR(100) NOT NULL
);

CREATE TABLE `qlktx`.`toa` (
  `ma_toa` VARCHAR(20) NOT NULL PRIMARY KEY,
  `sl_phong` INT NOT NULL,
  `ma_nv` VARCHAR(45) 
);


CREATE TABLE `qlktx`.`loai_phong` (
  `ma_loai` VARCHAR(20) NOT NULL PRIMARY KEY,
  `ten_loai` NVARCHAR(50) NOT NULL,
  `gia_tien` FLOAT NOT NULL
  );


CREATE TABLE `qlktx`.`phong` (
  `ma_phong` VARCHAR(15) NOT NULL PRIMARY KEY,
  `suc_chua_sv` INT NOT NULL,
  `sl_dang_o` INT NOT NULL,
  `ma_loai` VARCHAR(45) NOT NULL ,
  `ma_toa` VARCHAR(45) NOT NULL
  );

CREATE TABLE `qlktx`.`nhan_vien` (
  `ma_nv` varchar(45) NOT NULL PRIMARY KEY,
  `ho_ten` NVARCHAR(100) NOT NULL,
  `ngay_sinh` DATE NOT NULL,
  `gioi_tinh` NVARCHAR(100) NOT NULL,
  `dia_chi` NVARCHAR(200) NOT NULL,
  `sdt_nv` VARCHAR(45) NOT NULL,
  
  `ma_chuc_vu` VARCHAR(50) NOT NULL,
  `ma_toa` VARCHAR(20),
  `id_loai_quyen` INT NOT NULL
);


CREATE TABLE `qlktx`.`sinh_vien` (
  `ma_sv` VARCHAR(45) NOT NULL PRIMARY KEY,
  `cmnd` VARCHAR(45) NOT NULL,
  `ho_ten` NVARCHAR(100) NOT NULL,
  `gioi_tinh` NVARCHAR(40) NOT NULL,
  `ngay_sinh` DATE NOT NULL,
  `dia_chi` NVARCHAR(200) NOT NULL,
  `sdt` VARCHAR(45) NOT NULL,
  `ma_phong` VARCHAR(45) NOT NULL,
  `id_loai_quyen` int NOT NULL
 );


CREATE TABLE `qlktx`.`khen_ky_luat` (
  `ma_kt_kl` VARCHAR(10) NOT NULL PRIMARY KEY,
  `hinh_thuc` NVARCHAR(50) NOT NULL,
  `mo_ta` NVARCHAR(200) NOT NULL,
  `ngay_tao` DATE NOT NULL,
  `ma_sv` VARCHAR(45) NOT NULL
  );



CREATE TABLE `qlktx`.`than_nhan` (
  `cmnd` VARCHAR(40) NOT NULL PRIMARY KEY,
  `ho_ten` NVARCHAR(50) NOT NULL,
  `gioi_tinh` NVARCHAR(45) NOT NULL,
  `quan_he_vs_sv` NVARCHAR(100) NOT NULL,
  `dia_chi` NVARCHAR(200) NOT NULL,
  `sdt` VARCHAR(45) NOT NULL,
  `ma_sv` VARCHAR(45) NOT NULL
);
  
CREATE TABLE `qlktx`.`hop_dong_nv` (
  `ma_hd` VARCHAR(30) NOT NULL PRIMARY KEY,
  `ngay_bat_dau` DATE NOT NULL,
  `ngay_ket_thuc` DATE NOT NULL,
  `ngay_lap` DATE NOT NULL,
  `luong_thang` FLOAT NOT NULL,
  `ma_nv` VARCHAR(45) NOT NULL
);

CREATE TABLE `qlktx`.`hop_dong_sv` (
  `ma_hd` VARCHAR(20) NOT NULL PRIMARY KEY,
  `ngay_bat_dau` DATE NOT NULL,
  `ngay_ket_thuc` DATE NOT NULL,
  `ngay_lap` DATE NOT NULL,
  `thanh_tien` FLOAT,
  `ma_sv` VARCHAR(45) NOT NULL
);


CREATE TABLE `qlktx`.`hoa_don_dien_nuoc` (
  `ma_hoa_don` varchar(10) NOT NULL PRIMARY KEY,
  `ngay_lap` DATE NOT NULL,
  `so_dien_dau` FLOAT NOT NULL,
  `so_dien_cuoi` FLOAT NOT NULL,
  `so_nuoc_dau` FLOAT NOT NULL,
  `so_nuoc_cuoi` FLOAT NOT NULL,
  
  `don_gia_dien` FLOAT NULL DEFAULT 1900,
  `don_gia_nuoc` FLOAT NULL DEFAULT 1900,
  `thanh_tien` FLOAT,
  `trang_thai` NVARCHAR(45) NULL DEFAULT 'Chưa thanh toán',
  
  `ma_nv` VARCHAR(45),
  `ma_phong` VARCHAR(45) NOT NULL
 );

CREATE TABLE `qlktx`.`tai_khoan_sv` (
  `ma_sv` VARCHAR(45) NOT NULL,
  `mat_khau` VARCHAR(200) NOT NULL
  );

CREATE TABLE `qlktx`.`tai_khoan_nv` (
  `ma_nv` VARCHAR(45) NOT NULL,
  `mat_khau` VARCHAR(200) NOT NULL
  );






-- --------------------------------------------INSERT DATA-------------------------------------------------
INSERT INTO `qlktx`.`chuc_vu` (`ma_chuc_vu`, `ten_chuc_vu`) VALUES ('BanQuanLy', 'Ban quản lý');
INSERT INTO `qlktx`.`chuc_vu` (`ma_chuc_vu`, `ten_chuc_vu`) VALUES ('TruongPhong', 'Trưởng phòng');
INSERT INTO `qlktx`.`chuc_vu` (`ma_chuc_vu`, `ten_chuc_vu`) VALUES ('KeToan', 'Kế toán');

INSERT INTO `qlktx`.`loai_quyen` (`id_loai_quyen`, `ten_quyen`, `mo_ta`) 
	VALUES ('0', 'BanQuanLy', 'quản lý tất cả kí túc xá ..');
INSERT INTO `qlktx`.`loai_quyen` (`id_loai_quyen`, `ten_quyen`, `mo_ta`) 
	VALUES ('1', 'TruongPhong', 'quản lý tòa nhà và sv nv ..');
INSERT INTO `qlktx`.`loai_quyen` (`id_loai_quyen`, `ten_quyen`, `mo_ta`) 
	VALUES ('2', 'KeToan', 'quản lý hóa đơn điện nước');
INSERT INTO `qlktx`.`loai_quyen` (`id_loai_quyen`, `ten_quyen`, `mo_ta`) 
	VALUES ('3', 'SinhVien', 'xem và cập nhật thông tin cá nhân và hóa đơn điện nước');

INSERT INTO `qlktx`.`toa` (`ma_toa`, `sl_phong`) VALUES ('C1', '15');
INSERT INTO `qlktx`.`toa` (`ma_toa`, `sl_phong`) VALUES ('E2', '15');
INSERT INTO `qlktx`.`toa` (`ma_toa`, `sl_phong`) VALUES ('E3', '15');

INSERT INTO `qlktx`.`loai_phong` (`ma_loai`, `ten_loai`,`gia_tien`) VALUES ('PT', 'Phòng thường','210000');
INSERT INTO `qlktx`.`loai_phong` (`ma_loai`, `ten_loai`,`gia_tien`) VALUES ('PV', 'Phòng vip','350000');

INSERT INTO `qlktx`.`phong` (`ma_phong`, `suc_chua_sv`, `sl_dang_o`, `ma_loai`, `ma_toa`) 
	VALUES ('C101', '4', '0', 'PT', 'C1');
INSERT INTO `qlktx`.`phong` (`ma_phong`, `suc_chua_sv`, `sl_dang_o`, `ma_loai`, `ma_toa`) 
	VALUES ('C102', '2', '0', 'PV', 'C1');
INSERT INTO `qlktx`.`phong` (`ma_phong`, `suc_chua_sv`, `sl_dang_o`, `ma_loai`, `ma_toa`) 
	VALUES ('E201', '4', '0', 'PT', 'E2');
INSERT INTO `qlktx`.`phong` (`ma_phong`, `suc_chua_sv`, `sl_dang_o`, `ma_loai`, `ma_toa`) 
	VALUES ('E202', '2', '0', 'PV', 'E2');
INSERT INTO `qlktx`.`phong` (`ma_phong`, `suc_chua_sv`, `sl_dang_o`, `ma_loai`, `ma_toa`) 
	VALUES ('E301', '4', '0', 'PT', 'E3');
INSERT INTO `qlktx`.`phong` (`ma_phong`, `suc_chua_sv`, `sl_dang_o`, `ma_loai`, `ma_toa`) 
	VALUES ('E302', '2', '0', 'PV', 'E3');


INSERT INTO `qlktx`.`nhan_vien` 
	(`ma_nv`, `ho_ten`, `ngay_sinh`, `gioi_tinh`, `dia_chi`, `sdt_nv`, `ma_chuc_vu`, `id_loai_quyen`) 
VALUES ('admin', 'Võ Thị Ban Quản Lý', '1987-03-12', 'Nam', 'Thành phố HCM', '12345678', 'BanQuanLy', '0');

INSERT INTO `qlktx`.`nhan_vien` 
	(`ma_nv`, `ho_ten`, `ngay_sinh`, `gioi_tinh`, `dia_chi`, `sdt_nv`, `ma_chuc_vu`,`ma_toa`, `id_loai_quyen`) 
VALUES ('1151071001', 'Trần Tiến Dũng', '1990-03-12', 'Nam', 'Thành phố HCM', '12345678', 'TruongPhong','C1', '1');

INSERT INTO `qlktx`.`nhan_vien` 
	(`ma_nv`, `ho_ten`, `ngay_sinh`, `gioi_tinh`, `dia_chi`, `sdt_nv`, `ma_chuc_vu`, `ma_toa`, `id_loai_quyen`)
VALUES ('2151071001', 'Võ Tố Như', '1992-05-23', 'Nữ', 'Bình Định', '12345678', 'KeToan', 'C1', '2');
INSERT INTO `qlktx`.`nhan_vien` 
	(`ma_nv`, `ho_ten`, `ngay_sinh`, `gioi_tinh`, `dia_chi`, `sdt_nv`, `ma_chuc_vu`, `ma_toa`, `id_loai_quyen`) 
VALUES ('2151071002', 'Lượng Bùi Trọng Hiếu', '1998-10-04', 'Nam', 'Cà Mau', '123456789', 'KeToan', 'E1', '2');

-- INSERT INTO `qlktx`.`nhan_vien` 
-- 	(`ma_nv`, `ho_ten`, `ngay_sinh`, `gioi_tinh`, `dia_chi`, `sdt_nv`, `ma_chuc_vu`, `ma_toa`, `id_loai_quyen`) 
-- VALUES ('0151071002', 'Nam Hoài Bão', '1994-03-12', 'Nam', 'Thành phố HCM', '12345678', 'TruongPhong', 'E2', '0');


INSERT INTO `qlktx`.`hop_dong_nv` (`ma_hd`, `ngay_bat_dau`, `ngay_ket_thuc`, `ngay_lap`, `luong_thang`, `ma_nv`) 
	VALUES ('A01', '2018-01-01', '2024-01-01', '2017-12-25', '20000000', '0151071001');
INSERT INTO `qlktx`.`hop_dong_nv` (`ma_hd`, `ngay_bat_dau`, `ngay_ket_thuc`, `ngay_lap`, `luong_thang`, `ma_nv`) 
	VALUES ('A02', '2018-01-01', '2023-01-01', '2017-12-25', '12000000', '1151071001');
INSERT INTO `qlktx`.`hop_dong_nv` (`ma_hd`, `ngay_bat_dau`, `ngay_ket_thuc`, `ngay_lap`, `luong_thang`, `ma_nv`) 
	VALUES ('A03', '2019-01-01', '2022-12-31', '2018-12-27', '8000000', '2151071001');

INSERT INTO `qlktx`.`sinh_vien` (`ma_sv`, `cmnd`, `ho_ten`, `gioi_tinh`, `ngay_sinh`, `dia_chi`, `sdt`, `ma_phong`, `id_loai_quyen`) 
	VALUES ('6151071028', '077202005527', 'Lê Công Tuấn', 'Nam', '2002-08-26', 'Vũng Tàu', '0377969735', 'C101', '3');
INSERT INTO `qlktx`.`sinh_vien` (`ma_sv`, `cmnd`, `ho_ten`, `gioi_tinh`, `ngay_sinh`, `dia_chi`, `sdt`, `ma_phong`, `id_loai_quyen`) 
	VALUES ('6151071030', '073452234365', 'Chế Phan Hoàng Việt', 'Nam', '2002-05-12', 'Bình Định', '0323453454', 'C102', '3');


INSERT INTO `qlktx`.`hop_dong_sv` (`ma_hd`, `ngay_bat_dau`, `ngay_ket_thuc`, `ngay_lap`, `ma_sv`) 
	VALUES ('B01', '2020-02-01', '2020-04-01', '2020-01-25', '6151071028');
INSERT INTO `qlktx`.`hop_dong_sv` (`ma_hd`, `ngay_bat_dau`, `ngay_ket_thuc`, `ngay_lap`, `ma_sv`) 
	VALUES ('B02', '2020-02-01', '2022-06-01', '2020-01-25', '6151071030');
    
    
INSERT INTO `qlktx`.`than_nhan` (`cmnd`, `ho_ten`, `gioi_tinh`, `quan_he_vs_sv`, `dia_chi`, `sdt`, `ma_sv`) 
	VALUES ('123', 'Lê Công Tuấn', 'Nam', 'Bố', 'sdfsdf', '123123', '6151071028');


-- --------------------------------------------TRIGGER-------------------------------------------------
-- 1 khi thêm nhân viên có chức vụ là trường phòng thì ở bảng tòa sẽ thêm mã nv quản lí của tòa đó
-- + tạo tài khoản cho nv
DELIMITER $$
USE `qlktx`$$
DROP TRIGGER IF EXISTS `qlktx`.`add_nv` $$
CREATE DEFINER=`root`@`localhost` TRIGGER `add_nv` AFTER INSERT ON `nhan_vien` FOR EACH ROW BEGIN
	
    DECLARE NameRole varchar(50);
    DECLARE UserName varchar(45);
    SET NameRole = NEW.`ma_chuc_vu`;
    SET UserName = NEW.`ma_nv`;
    
    IF ((NEW.`ma_toa` IS NOT NULL)) 
    then
		UPDATE `toa` SET `ma_nv` = (SELECT `ma_nv` FROM `nhan_vien`
		WHERE `nhan_vien`.`ma_toa` = `toa`.`ma_toa`)
		WHERE `toa`.`ma_toa` = NEW.`ma_toa` AND NEW.`ma_chuc_vu` = 'TruongPhong' 
        AND NEW.`id_loai_quyen` = '1';
	END IF;

END$$
DELIMITER ;



-- 2 khi tạo hợp đồng cho sinh viên, tính tiền kể từ ngày đăng kí đến hết hạn hợp đồng
DELIMITER $$
USE `qlktx`$$
DROP TRIGGER IF EXISTS `qlktx`.`add_hd` $$
CREATE DEFINER=`root`@`localhost` TRIGGER `add_hd` BEFORE INSERT ON `hop_dong_sv` FOR EACH ROW BEGIN

	DECLARE gia_tien_phong FLOAT;
        
	SET gia_tien_phong = (SELECT gia_tien FROM `loai_phong`,`sinh_vien`,`phong`
		WHERE `sinh_vien`.`ma_sv` = NEW.`ma_sv`
		AND `phong`.`ma_phong` = `sinh_vien`.`ma_phong` 
		AND  `loai_phong`.`ma_loai` = `phong`.`ma_loai`);
        
	SET NEW.`thanh_tien` = ((DATEDIFF(NEW.`ngay_ket_thuc`, NEW.`ngay_bat_dau`)/30)*gia_tien_phong);
END$$
DELIMITER ;

-- 3 thêm hóa đơn điện cho phòng thì tính tiền
DELIMITER $$
USE `qlktx`$$
DROP TRIGGER IF EXISTS `qlktx`.`add_hoa_don` $$
CREATE DEFINER=`root`@`localhost` TRIGGER `add_hoa_don` BEFORE INSERT ON `hoa_don_dien_nuoc` FOR EACH ROW BEGIN

	DECLARE tong_tien FLOAT;
	DECLARE tien_dien FLOAT;
	DECLARE tien_nuoc FLOAT;
	
    SET tien_dien = (NEW.`so_dien_cuoi` - NEW.`so_dien_dau`)*NEW.`don_gia_dien`;
	SET tien_nuoc = (NEW.`so_nuoc_cuoi` - NEW.`so_nuoc_dau`)*NEW.`don_gia_nuoc`;
	SET tong_tien = (tien_dien +  tien_nuoc);
    
    SET NEW.`thanh_tien` = (SELECT tong_tien);
        
END$$
DELIMITER ;

INSERT INTO `qlktx`.`hoa_don_dien_nuoc` (`ma_hoa_don`, `ngay_lap`, `so_dien_dau`, 
	`so_dien_cuoi`, `so_nuoc_dau`, `so_nuoc_cuoi`, `ma_phong`, `ma_nv`) 
VALUES ('HD01', '2020-03-01', '0', '123', '0', '30', 'C101', '1151071001');



-- 4 them sinh vien và cập nhật số lượng đang ở 'phong';
DELIMITER $$
USE `qlktx`$$
DROP TRIGGER IF EXISTS `qlktx`.`add_sv` $$
CREATE DEFINER=`root`@`localhost` TRIGGER `add_sv` AFTER INSERT ON `sinh_vien` FOR EACH ROW BEGIN
	
    UPDATE `phong` SET `sl_dang_o` = (SELECT COUNT(`ma_sv`) FROM `sinh_vien`
	WHERE `sinh_vien`.`ma_phong` = `phong`.`ma_phong`)
	WHERE `phong`.`ma_phong` = NEW.`ma_phong`;
    INSERT INTO tai_khoan_sv (ma_sv, mat_khau) VALUES (NEW.ma_sv, '1');

END$$
DELIMITER ;


INSERT INTO `qlktx`.`sinh_vien` (`ma_sv`, `cmnd`, `ho_ten`, `gioi_tinh`, `ngay_sinh`, `dia_chi`, `sdt`, `ma_phong`, `id_loai_quyen`) 
	VALUES ('6151071021', '077202006328', 'Nguyễn Nhật Trường', 'Nam', '2002-07-20', 'Cao Bằng', '0377969651', 'E201', '3');



-- 5 cập nhật sinh vien và cập nhật số lượng đang ở 'phong' nếu sv chuyển phòng;
DELIMITER $$
USE `qlktx`$$
DROP TRIGGER IF EXISTS `qlktx`.`update_sv` $$
CREATE DEFINER=`root`@`localhost` TRIGGER `update_sv` AFTER UPDATE ON `sinh_vien` 
	FOR EACH ROW 
BEGIN
	UPDATE `phong`
		SET `sl_dang_o` =
		(SELECT COUNT(`ma_sv`) FROM `sinh_vien`
		WHERE`sinh_vien`.`ma_phong` = `phong`.`ma_phong`)
		WHERE `phong`.`ma_phong` = OLD.`ma_phong` OR
        `phong`.`ma_phong` = NEW.`ma_phong`;
END$$
DELIMITER ;

-- UPDATE sinh_vien
-- SET ma_phong = 'B102'
-- WHERE ma_sv = '6151071029';



-- 6 xóa sinh vien và cập nhật số lượng đang ở 'phong';
DELIMITER $$
USE `qlktx`$$
DROP TRIGGER IF EXISTS `qlktx`.`delete_sv` $$
CREATE DEFINER=`root`@`localhost` TRIGGER `delete_sv` AFTER DELETE ON `sinh_vien` 
	FOR EACH ROW 
BEGIN
	UPDATE phong SET sl_dang_o = (SELECT COUNT(ma_sv) FROM sinh_vien
	WHERE sinh_vien.ma_phong = phong.ma_phong)
	WHERE phong.ma_phong = OLD.ma_phong;
    
END$$
DELIMITER ;


-- delete from sinh_vien
-- WHERE ma_sv = '6151071032';


-- 7 xóa phong-----------------;
-- cái này check trước khi xóa phòng không được, bởi vì nếu có sv đang ở thì nó đã 
-- check khóa ngoại trước rồi nên không thể check được nữa
DELIMITER $$
USE `qlktx`$$
DROP TRIGGER IF EXISTS `qlktx`.`delete_phong` $$
CREATE DEFINER=`root`@`localhost` TRIGGER `delete_phong` AFTER DELETE ON `phong` 
	FOR EACH ROW 
BEGIN
	DECLARE ma_phong_delete varchar(20);
    DECLARE t int;
	SELECT ma_phong_delete = ma_phong FROM deleted;
    SELECT t = sl_dang_o from phong where phong.ma_phong = ma_phong_delete;
    IF (t > 0) then
		DELETE ma_phong FROM phong WHERE ma_phong=ma_phong_delete;
        DELETE ma_hoa_don FROM hoa_don_dien_nuoc WHERE ma_phong = ma_phong_delete;
	ELSE
		ROLLBACK;
END
DELIMITER ;

-- delete from phong
-- WHERE ma_phong = 'C101';




-- update mat khau

-- UPDATE tai_khoan_sv
-- SET mat_khau = '2'
-- WHERE ma_sv = '6151071022';

-- ------------------------------- thu tuc ------------------------
-- kiem tra có sinh vien trong ktx hay không, nếu có thì in ra, không thì show message
DELIMITER $$ 
DROP PROCEDURE IF EXISTS `getSinhVien`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSinhVien`(in param_maSV varchar(45))
BEGIN
	DECLARE message NVARCHAR(300);
	IF(NOT EXISTS (SELECT * FROM sinh_vien WHERE ma_sv = param_maSV)) then
		SET message = 'Sinh viên này không ở trong ký túc xá';
        SELECT message;
	ELSE 
		(SELECT * FROM sinh_vien WHERE ma_sv =  param_maSV);
	END IF;
END$$
DELIMITER ;

CALL getSinhVien(6151071028);

-- in ds các sinh vien theo 1 ma phong(toa)
DELIMITER $$
DROP PROCEDURE IF EXISTS `get_list_sv_by_maToa`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_sv_by_maToa`(in param_MaToa varchar(45))
BEGIN

	DECLARE message NVARCHAR(300);
    DECLARE sl_sv int;
    IF(NOT EXISTS( SELECT ma_toa FROM  phong, sinh_vien WHERE sinh_vien.ma_phong = phong.ma_phong 
        AND phong.ma_toa = param_MaToa)) then
        SET message = 'Không có sinh viên nào ở trong tòa này!';
        SELECT message;
    ELSE 
        SELECT * FROM  sinh_vien , phong  WHERE sinh_vien.ma_phong = phong.ma_phong 
        AND phong.ma_toa = param_MaToa;
		SET sl_sv = (SELECT COUNT(ma_sv) FROM sinh_vien, phong WHERE sinh_vien.ma_phong = phong.ma_phong 
        AND phong.ma_toa = param_MaToa);
        SELECT sl_sv as 'Số lượng sinh viên trong tòa';

    END IF;
end$$
DELIMITER ;

call get_list_sv_by_maToa ('C1');

-- liệt kê ds các phòng đã đóng tiền và chưa đóng tiền 
DELIMITER $$
DROP PROCEDURE IF EXISTS `get_list_payment_status`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_payment_status`(in statuss nvarchar(45))
BEGIN

DECLARE message NVARCHAR(300);
    IF(NOT EXISTS( SELECT * FROM  phong , hoa_don_dien_nuoc 
			WHERE  phong.ma_phong = hoa_don_dien_nuoc.ma_phong 
			AND hoa_don_dien_nuoc.trang_thai = statuss )) 
		then
        SET message = 'Nhập sai dữ liệu . Vui lòng nhập lại.!';
        SELECT message;
    ELSE 
        SELECT * FROM  phong ,hoa_don_dien_nuoc  
			WHERE phong.ma_phong = hoa_don_dien_nuoc.ma_phong 
            AND hoa_don_dien_nuoc.trang_thai = statuss;
    END IF;
END$$
DELIMITER ;

call get_list_payment_status('Chưa thanh toán');




-- ------------------------------- hàm ------------------------
-- tính thời hạn hợp đồng nv và sv
DELIMITER $$ 
DROP FUNCTION IF EXISTS `contract_period_sv`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `contract_period_sv`(id varchar(45))
	RETURNS NVARCHAR(40)
DETERMINISTIC
BEGIN
    
	DECLARE contract_period NVARCHAR(40);
    SET contract_period = 
		CONCAT(YEAR((SELECT ngay_ket_thuc FROM hop_dong_sv WHERE ma_sv = id)) - 
			YEAR((SELECT ngay_bat_dau FROM hop_dong_sv WHERE ma_sv = id)), ' Năm ',
			
			MONTH((SELECT ngay_ket_thuc FROM hop_dong_sv WHERE ma_sv = id)) - 
			MONTH((SELECT ngay_bat_dau FROM hop_dong_sv WHERE ma_sv = id)),' Tháng ',
			
			DAY((SELECT ngay_ket_thuc FROM hop_dong_sv WHERE ma_sv = id)) - 
			DAY((SELECT ngay_bat_dau FROM hop_dong_sv WHERE ma_sv = id)), ' Ngày')  ;
	RETURN contract_period ;
END$$
DELIMITER ;

SELECT contract_period_sv('6151071030') as 'Thời hạn hợp đồng' ;

-- ---------------view ---------------
-- select phong.ma_phong,phong.ma_toa,hoa_don_dien_nuoc.thanh_tien  
-- from phong,hoa_don_dien_nuoc 
-- where phong.ma_phong = hoa_don_dien_nuoc.ma_phong
-- and hoa_don_dien_nuoc.thanh_tien > 200000;


CREATE VIEW qlktx.danh_sanh_hoa_don AS 
	SELECT phong.ma_phong, phong.ma_toa, hoa_don_dien_nuoc.ma_hoa_don, hoa_don_dien_nuoc.thanh_tien
	FROM phong,hoa_don_dien_nuoc 
	WHERE phong.ma_phong = hoa_don_dien_nuoc.ma_phong
	AND hoa_don_dien_nuoc.thanh_tien > 200000;
    
SELECT * FROM danh_sanh_hoa_don;





-- -----------------------------------------ADD KHÓA NGOẠI---------------------------------------------
-- 3 bảng không có khóa ngoại : chuc_vu, loai_phong, loai_quyen
ALTER TABLE `qlktx`.`toa` 
ADD CONSTRAINT `fk_ma_nv`
  FOREIGN KEY (`ma_nv`)
  REFERENCES `qlktx`.`nhan_vien` (`ma_nv`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION;


ALTER TABLE `qlktx`.`phong` 
ADD CONSTRAINT `fk_phong_ma_loai`
  FOREIGN KEY (`ma_loai`)
  REFERENCES `qlktx`.`loai_phong` (`ma_loai`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_phong_ma_toa`
  FOREIGN KEY (`ma_toa`)
  REFERENCES `qlktx`.`toa` (`ma_toa`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


ALTER TABLE `qlktx`.`nhan_vien` 
ADD CONSTRAINT `fk_id_loai_quyen`
  FOREIGN KEY (`id_loai_quyen`)
  REFERENCES `qlktx`.`loai_quyen` (`id_loai_quyen`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_ma_chuc_vu`
  FOREIGN KEY (`ma_chuc_vu`)
  REFERENCES `qlktx`.`chuc_vu` (`ma_chuc_vu`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_nv_ma_toa`
  FOREIGN KEY (`ma_toa`)
  REFERENCES `qlktx`.`toa` (`ma_toa`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;




ALTER TABLE `qlktx`.`sinh_vien` 
ADD CONSTRAINT `fk_sinh_vien_ma_phong`
  FOREIGN KEY (`ma_phong`)
  REFERENCES `qlktx`.`phong` (`ma_phong`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_sinh_vien_id_loai_quyen`
  FOREIGN KEY (`id_loai_quyen`)
  REFERENCES `qlktx`.`loai_quyen` (`id_loai_quyen`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  
  
  
ALTER TABLE `qlktx`.`khen_ky_luat` 
ADD CONSTRAINT `fk_ktkl_masv`
  FOREIGN KEY (`ma_sv`)
  REFERENCES `qlktx`.`sinh_vien` (`ma_sv`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION;




ALTER TABLE `qlktx`.`than_nhan` 
ADD CONSTRAINT `fk_than_nhan_masv`
  FOREIGN KEY (`ma_sv`)
  REFERENCES `qlktx`.`sinh_vien` (`ma_sv`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION;



ALTER TABLE `qlktx`.`hop_dong_nv` 
ADD CONSTRAINT `fk_hop_dong_ma_nv`
  FOREIGN KEY (`ma_nv`)
  REFERENCES `qlktx`.`nhan_vien` (`ma_nv`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION;




ALTER TABLE `qlktx`.`hop_dong_sv` 
ADD CONSTRAINT `fk_hop_dong_ma_sv`
  FOREIGN KEY (`ma_sv`)
  REFERENCES `qlktx`.`sinh_vien` (`ma_sv`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION;
  
  

ALTER TABLE `qlktx`.`hoa_don_dien_nuoc` 
ADD CONSTRAINT `fk_hddn_ma_nv`
  FOREIGN KEY (`ma_nv`)
  REFERENCES `qlktx`.`nhan_vien` (`ma_nv`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_hddn_ma_phong`
  FOREIGN KEY (`ma_phong`)
  REFERENCES `qlktx`.`phong` (`ma_phong`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;



ALTER TABLE `qlktx`.`tai_khoan_sv` 
ADD CONSTRAINT `fk_tk_ma_sv`
  FOREIGN KEY (`ma_sv`)
  REFERENCES `qlktx`.`sinh_vien` (`ma_sv`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION;



ALTER TABLE `qlktx`.`tai_khoan_nv` 
ADD CONSTRAINT `fk_tk_ma_nv`
  FOREIGN KEY (`ma_nv`)
  REFERENCES `qlktx`.`nhan_vien` (`ma_nv`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION;






