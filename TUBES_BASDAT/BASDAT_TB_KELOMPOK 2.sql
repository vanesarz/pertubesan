-- NOTE: Run per comment ya.

-- DDL

CREATE DATABASE Klinik;
USE Klinik;

CREATE TABLE Dokter (
    ID_Dokter VARCHAR(5) PRIMARY KEY NOT NULL,
    Nama_Dokter VARCHAR(50) NOT NULL,
    Spesialisasi VARCHAR(50),
    No_Telepon_Dokter VARCHAR(15)
);

CREATE TABLE Administrasi (
    ID_Administrasi VARCHAR(5) PRIMARY KEY NOT NULL,
    Nama_Administrasi VARCHAR(50) NOT NULL,
    No_Telepon_Administrasi VARCHAR(15)
);

CREATE TABLE Pasien (
    ID_Pasien VARCHAR(5) PRIMARY KEY NOT NULL,
    Nama_Pasien VARCHAR(50) NOT NULL,
    Tanggal_Lahir DATE,
    Jenis_Kelamin VARCHAR(10),
    No_Telepon_Pasien VARCHAR(15),
    Alamat VARCHAR(100)
);

CREATE TABLE Apoteker (
    ID_Apoteker VARCHAR(5) PRIMARY KEY NOT NULL,
    Nama_Apoteker VARCHAR(50) NOT NULL,
    No_Telepon_Apoteker VARCHAR(15)
);

CREATE TABLE Kasir (
    ID_Kasir VARCHAR(5) PRIMARY KEY NOT NULL,
    Nama_Kasir VARCHAR(50) NOT NULL,
    No_Telepon_Kasir VARCHAR(15)
);

CREATE TABLE Kepala_Klinik (
    ID_Kepala_Klinik VARCHAR(5) PRIMARY KEY NOT NULL,
    Nama_Kepala_Klinik VARCHAR(50) NOT NULL,
    No_Telepon_Kepala_Klinik VARCHAR(15)
);

CREATE TABLE Obat (
    ID_Obat VARCHAR(5) PRIMARY KEY NOT NULL,
    Nama_Obat VARCHAR(50),
    Harga DECIMAL(10, 2),
    Stok INT
);

CREATE TABLE Resep (
    ID_Resep VARCHAR(5) PRIMARY KEY NOT NULL,
    ID_Pasien VARCHAR(5),
    ID_Dokter VARCHAR(5),
    Tanggal_Resep DATE,
    FOREIGN KEY (ID_Pasien) REFERENCES Pasien(ID_Pasien),
    FOREIGN KEY (ID_Dokter) REFERENCES Dokter(ID_Dokter)
);

CREATE TABLE Resep_Obat (
    ID_Resep VARCHAR(5),
    ID_Obat VARCHAR(5),
    PRIMARY KEY (ID_Resep, ID_Obat),
    FOREIGN KEY (ID_Resep) REFERENCES Resep(ID_Resep),
    FOREIGN KEY (ID_Obat) REFERENCES Obat(ID_Obat)
);

CREATE TABLE Pembayaran (
    ID_Pembayaran VARCHAR(5) PRIMARY KEY NOT NULL,
    ID_Pasien VARCHAR(5),
    ID_Kasir VARCHAR(5),
    Tanggal_Pembayaran DATE,
    Jumlah DECIMAL(10, 2),
    FOREIGN KEY (ID_Pasien) REFERENCES Pasien(ID_Pasien),
    FOREIGN KEY (ID_Kasir) REFERENCES Kasir(ID_Kasir)
);

CREATE TABLE Log (
    Log_Num INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    ID_Log VARCHAR(8),
    Kejadian VARCHAR(255),
    Waktu_Log TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ID_Tracker (
    Entitas VARCHAR(2) PRIMARY KEY NOT NULL,
    Nomor_Terakhir INT NOT NULL
);

-- Stored Procedure untuk Generate Custom ID
DELIMITER //

CREATE PROCEDURE Generate_ID(
    IN Kode_Entitas VARCHAR(2),
    OUT ID_Baru VARCHAR(5)
)
BEGIN
    DECLARE P_Nomor_Terakhir INT;
    DECLARE P_Nomor_Baru INT;

    SELECT Nomor_Terakhir INTO P_Nomor_Terakhir
    FROM ID_Tracker
    WHERE Entitas = Kode_Entitas
    FOR UPDATE;

    SET P_Nomor_Baru = P_Nomor_Terakhir + 1;

    UPDATE ID_Tracker
    SET Nomor_Terakhir = P_Nomor_Baru
    WHERE Entitas = Kode_Entitas;

    SET ID_Baru = CONCAT(Kode_Entitas, LPAD(P_Nomor_Baru, 3, '0'));
END //

DELIMITER ;

-- Trigger untuk Generate Custom ID
DELIMITER //

CREATE TRIGGER Before_Insert_DR
BEFORE INSERT ON Dokter
FOR EACH ROW
BEGIN
    DECLARE ID_Baru VARCHAR(5);

    CALL Generate_ID('DR', ID_Baru);

    SET NEW.ID_Dokter = ID_Baru;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER Before_Insert_AD
BEFORE INSERT ON Administrasi
FOR EACH ROW
BEGIN
    DECLARE ID_Baru VARCHAR(5);

    CALL Generate_ID('AD', ID_Baru);

    SET NEW.ID_Administrasi = ID_Baru;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER Before_Insert_PS
BEFORE INSERT ON Pasien
FOR EACH ROW
BEGIN
    DECLARE ID_Baru VARCHAR(5);

    CALL Generate_ID('PS', ID_Baru);

    SET NEW.ID_Pasien  = ID_Baru;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER Before_Insert_AP
BEFORE INSERT ON Apoteker
FOR EACH ROW
BEGIN
    DECLARE ID_Baru VARCHAR(5);

    CALL Generate_ID('AP', ID_Baru);

    SET NEW.ID_Apoteker = ID_Baru;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER Before_Insert_KK
BEFORE INSERT ON Kepala_Klinik
FOR EACH ROW
BEGIN
    DECLARE ID_Baru VARCHAR(5);

    CALL Generate_ID('KK', ID_Baru);

    SET NEW.ID_Kepala_Klinik = ID_Baru;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER Before_Insert_KS
BEFORE INSERT ON Kasir
FOR EACH ROW
BEGIN
    DECLARE ID_Baru VARCHAR(5);

    CALL Generate_ID('KS', ID_Baru);

    SET NEW.ID_Kasir = ID_Baru;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER Before_Insert_OB
BEFORE INSERT ON Obat
FOR EACH ROW
BEGIN
    DECLARE ID_Baru VARCHAR(5);

    CALL Generate_ID('OB', ID_Baru);

    SET NEW.ID_Obat = ID_Baru;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER Before_Insert_RE
BEFORE INSERT ON Resep
FOR EACH ROW
BEGIN
    DECLARE ID_Baru VARCHAR(5);

    CALL Generate_ID('RE', ID_Baru);

    SET NEW.ID_Resep = ID_Baru;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER Before_Insert_PM
BEFORE INSERT ON Pembayaran
FOR EACH ROW
BEGIN
    DECLARE ID_Baru VARCHAR(5);

    CALL Generate_ID('PM', ID_Baru);

    SET NEW.ID_Pembayaran = ID_Baru;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER Before_Insert_LG
BEFORE INSERT ON Log
FOR EACH ROW
BEGIN
    DECLARE ID_Baru VARCHAR(5);

    CALL Generate_ID('LG', ID_Baru);

    SET NEW.ID_Log = ID_Baru;
END //

DELIMITER ;

-- Trigger untuk Log setiap Kejadian
CREATE TRIGGER Tambah_Dokter_Log
AFTER INSERT ON Dokter
FOR EACH ROW
INSERT INTO Log(Kejadian) VALUES ('Tambah dokter baru');

CREATE TRIGGER Tambah_Administrasi_Log
AFTER INSERT ON Administrasi
FOR EACH ROW
INSERT INTO Log(Kejadian) VALUES ('Tambah administrasi baru');

CREATE TRIGGER Tambah_Pasien_Log
AFTER INSERT ON Pasien
FOR EACH ROW
INSERT INTO Log(Kejadian) VALUES ('Tambah pasien baru');

CREATE TRIGGER Tambah_Apoteker_Log
AFTER INSERT ON Apoteker
FOR EACH ROW
INSERT INTO Log(Kejadian) VALUES ('Tambah apoteker baru');

CREATE TRIGGER Tambah_Kasir_Log
AFTER INSERT ON Kasir
FOR EACH ROW
INSERT INTO Log(Kejadian) VALUES ('Tambah kasir baru');

CREATE TRIGGER Tambah_Obat_Log
AFTER INSERT ON Obat
FOR EACH ROW
INSERT INTO Log(Kejadian) VALUES ('Tambah obat baru');

CREATE TRIGGER Ubah_Obat_Log
AFTER UPDATE ON Obat
FOR EACH ROW
INSERT INTO Log(Kejadian) VALUES ('Ubah data obat');

CREATE TRIGGER Buat_Resep_Log
AFTER INSERT ON Resep
FOR EACH ROW
INSERT INTO Log(Kejadian) VALUES ('Tambah resep baru');

CREATE TRIGGER Resep_Obat_Log
AFTER INSERT ON Resep_Obat
FOR EACH ROW
INSERT INTO Log(Kejadian) VALUES ('Tambah resep obat');

-- Stored Procedure terkait Obat
DELIMITER //

CREATE PROCEDURE Tambah_Obat_Baru (
    IN P_ID_Obat VARCHAR(5),
    IN P_Nama_Obat VARCHAR(50),
    IN P_Harga DECIMAL(10, 2),
    IN P_Stok INT
)
BEGIN
    DECLARE Obat_ada INT;
    
    SELECT COUNT(*) INTO Obat_ada
    FROM Obat
    WHERE ID_Obat = P_ID_Obat;
    
    IF Obat_ada = 0 THEN
    	INSERT INTO Obat (ID_Obat, Nama_Obat, Harga, Stok)
    	VALUES (P_ID_Obat, P_Nama_Obat, P_Harga, P_Stok);

        SET @status = 'Obat baru berhasil ditambahkan.';
    ELSE
        SET @status = 'Obat dengan ID tersebut sudah ada.';
    END IF;
    
    SELECT @status;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Tambah_Stok_Obat (
    IN P_ID_Obat VARCHAR(5),
    IN P_Stok INT
)
BEGIN
    DECLARE Obat_ada INT;
    
    SELECT COUNT(*) INTO Obat_ada
    FROM Obat
    WHERE ID_Obat = P_ID_Obat;
    
    IF Obat_ada > 0 THEN
        UPDATE Obat 
        SET Stok = Stok + P_Stok
        WHERE ID_Obat = P_ID_Obat;

        SET @status = 'Stok obat berhasil ditambahkan.';
    ELSE
        SET @status = 'Obat tidak ditemukan.';
    END IF;
    
    SELECT @status;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Kurangi_Stok_Obat (
    IN P_ID_Obat VARCHAR(5),
    IN P_Stok INT
)
BEGIN
    DECLARE Obat_ada INT;
    DECLARE Stok_cukup INT;
    
    SELECT COUNT(*) INTO Obat_ada
    FROM Obat
    WHERE ID_Obat = P_ID_Obat;
	
    SELECT Stok INTO Stok_cukup
    FROM Obat
    WHERE ID_Obat = P_ID_Obat;
    
    IF Obat_ada > 0 THEN
    	IF Stok_cukup >= P_Stok THEN
            UPDATE Obat 
            SET Stok = Stok - P_Stok
            WHERE ID_Obat = P_ID_Obat;

            SET @status = 'Stok obat berhasil dikurangi.';
        ELSE
        	SET @status = 'Stok obat tidak cukup.';
        END IF;
    ELSE
        SET @status = 'Obat tidak ditemukan.';
    END IF;
    
    SELECT @status;
END //

DELIMITER ;

-- Stored Procedure untuk Lihat Resep Obat Pasien
DELIMITER //

CREATE PROCEDURE Lihat_RO_by_ID (
    IN P_ID_Pasien VARCHAR(5)
)
BEGIN
	DECLARE Pasien_ada INT;
    
    SELECT COUNT(*) INTO Pasien_ada
    FROM Pasien
    WHERE ID_Pasien = P_ID_Pasien;
    
    IF Pasien_ada > 0 THEN
        SELECT R.ID_Resep, R.Tanggal_Resep, D.Nama_Dokter, GROUP_CONCAT(O.Nama_Obat SEPARATOR ', ') AS Daftar_Obat
        FROM Resep R
        JOIN Dokter D ON R.ID_Dokter = D.ID_Dokter
        JOIN Resep_Obat RO ON R.ID_Resep = RO.ID_Resep
        JOIN Obat O ON RO.ID_Obat = O.ID_Obat
        WHERE R.ID_Pasien = P_ID_Pasien
        GROUP BY R.ID_Resep;
	ELSE
    	SET @status = 'Pasien dengan ID tersebut tidak terdaftar.';
        SELECT @status;
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE Lihat_RO_by_Nama (
    IN P_Nama_Pasien VARCHAR(50)
)
BEGIN
	DECLARE Pasien_ada INT;
    
    SELECT COUNT(*) INTO Pasien_ada
    FROM Pasien
    WHERE Nama_Pasien = P_Nama_Pasien;
    
    IF Pasien_ada > 0 THEN
        SELECT R.ID_Resep, R.Tanggal_Resep, D.Nama_Dokter
        FROM Resep R
        JOIN Dokter D ON R.ID_Dokter = D.ID_Dokter
        WHERE R.ID_Pasien = (
            SELECT ID_Pasien 
            FROM Pasien 
            WHERE Nama_Pasien = P_Nama_Pasien
        );
    ELSE
    	SET @status = 'Pasien dengan nama tersebut tidak terdaftar.';
        SELECT @status;
    END IF;
END //

DELIMITER ;

-- DML (insert record)

INSERT INTO ID_Tracker (Entitas, Nomor_Terakhir) 
VALUES  ('DR', 0), ('AD', 0), ('PS', 0), ('AP', 0), ('KS', 0), 
        ('KK', 0), ('RE', 0), ('OB', 0), ('PM', 0), ('LG', 0);

INSERT INTO Dokter (Nama_Dokter, Spesialisasi, No_Telepon_Dokter) 
VALUES
('Dr. Asep', 'Kardiologi', '081234567890'),
('Dr. Budi', 'Pediatri', '081234567891'),
('Dr. Chandra', 'Bedah', '081234567892'),
('Dr. Darwin', 'Kulit', '081234567893'),
('Dr. Erni', 'THT', '081234567894'),
('Dr. Fatih', 'Mata', '081234567895'),
('Dr. Gita', 'Saraf', '081234567896'),
('Dr. Handani', 'Gigi', '081234567897'),
('Dr. Intan', 'Umum', '081234567898'),
('Dr. Joko', 'Psikiatri', '081234567899');

INSERT INTO Administrasi (Nama_Administrasi, No_Telepon_Administrasi) 
VALUES
('Andi', '081234567800'),
('Burhan', '081234567801'),
('Citra', '081234567802'),
('Dewi', '081234567803'),
('Eka', '081234567804'),
('Fajar', '081234567805'),
('Gina', '081234567806'),
('Heri', '081234567807'),
('Indah', '081234567808'),
('Joni', '081234567809');

INSERT INTO Pasien (Nama_Pasien, Tanggal_Lahir, Jenis_Kelamin, No_Telepon_Pasien, Alamat) 
VALUES
('Ali', '1990-01-01', 'Laki-laki', '081234567810', 'Jl. Cimindi'),
('Berry', '1985-02-02', 'Laki-laki', '081234567811', 'Jl. Nasional 3'),
('Cinta', '1995-03-03', 'Perempuan', '081234567812', 'Jl. semoga'),
('Diwanto', '2000-04-04', 'Perempuan', '081234567813', 'Jl. sukabrius'),
('Emma', '1975-05-05', 'Laki-laki', '081234567814', 'Jl. BKT'),
('Fajar', '1992-06-06', 'Laki-laki', '081234567815', 'Jl. cibiru'),
('Gery', '1998-07-07', 'Perempuan', '081234567816', 'Jl. jalan'),
('Hilmi', '1980-08-08', 'Laki-laki', '081234567817', 'Jl. Moh. Toha'),
('Ira', '1994-09-09', 'Perempuan', '081234567818', 'Jl. Rahmat'),
('Juandi', '1991-10-10', 'Laki-laki', '081234567819', 'Jl. sukapura');

INSERT INTO Apoteker (Nama_Apoteker, No_Telepon_Apoteker) 
VALUES
('Amir', '081234567820'),
('Buston', '081234567821'),
('Carista', '081234567822'),
('Darti', '081234567823'),
('Ena', '081234567824'),
('Fajar', '081234567825'),
('Gitawa', '081234567826'),
('Hafid', '081234567827'),
('Ilham', '081234567828'),
('Jarfis', '081234567829');

INSERT INTO Kasir (Nama_Kasir, No_Telepon_Kasir) 
VALUES
('Ahmad', '081234567830'),
('Basuki', '081234567831'),
('Calvin', '081234567832'),
('Desti', '081234567833'),
('Edo', '081234567834'),
('Farhan', '081234567835'),
('Genos', '081234567836'),
('Hesti', '081234567837'),
('Iki', '081234567838'),
('Jarip', '081234567839');

INSERT INTO Kepala_Klinik (Nama_Kepala_Klinik, No_Telepon_Kepala_Klinik) 
VALUES
('Arif', '081234567840'),
('Ben', '081234567841'),
('Cici', '081234567842'),
('Delima', '081234567843'),
('Eko', '081234567844'),
('Faisal', '081234567845'),
('Gianis', '081234567846'),
('Heru', '081234567847'),
('Ivan', '081234567848'),
('Justin', '081234567849');

INSERT INTO Obat (Nama_Obat, Harga, Stok) 
VALUES
('Paracetamol', 5000, 100),
('Amoxicillin', 10000, 200),
('Ibuprofen', 7500, 150),
('Vitamin C', 3000, 250),
('Cetirizine', 5000, 100),
('Antasida', 2000, 300),
('Loratadine', 6000, 180),
('Omeprazole', 8000, 120),
('Metformin', 10000, 100),
('Amlodipine', 9000, 140);

INSERT INTO Resep (ID_Pasien, ID_Dokter, Tanggal_Resep) 
VALUES
('PS001', 'DR001', '2023-02-03'),
('PS002', 'DR002', '2023-03-28'),
('PS003', 'DR003', '2023-04-10'),
('PS004', 'DR004', '2023-05-30'),
('PS005', 'DR005', '2023-06-06'),
('PS006', 'DR006', '2023-06-08'),
('PS007', 'DR007', '2023-07-19'),
('PS008', 'DR008', '2023-08-25'),
('PS009', 'DR009', '2022-10-23'),
('PS010', 'DR010', '2022-12-02');

INSERT INTO Resep_Obat (ID_Resep, ID_Obat) 
VALUES
('RE001', 'OB001'),
('RE001', 'OB002'),
('RE002', 'OB003'),
('RE002', 'OB004'),
('RE003', 'OB005'),
('RE003', 'OB006'),
('RE004', 'OB007'),
('RE004', 'OB008'),
('RE004', 'OB009'),
('RE005', 'OB010'),
('RE006', 'OB001'),
('RE006', 'OB002'),
('RE007', 'OB003'),
('RE007', 'OB004'),
('RE008', 'OB005'),
('RE008', 'OB006'),
('RE009', 'OB007'),
('RE009', 'OB008'),
('RE010', 'OB009'),
('RE010', 'OB010');

INSERT INTO Pembayaran (ID_Pasien, ID_Kasir, Tanggal_Pembayaran, Jumlah) 
VALUES
('PS001', 'KS001', '2023-02-03', 50000),
('PS002', 'KS002', '2023-03-28', 75000),
('PS003', 'KS003', '2023-04-10', 60000),
('PS004', 'KS004', '2023-05-30', 85000),
('PS005', 'KS005', '2023-06-06', 90000),
('PS006', 'KS006', '2023-06-08', 55000),
('PS007', 'KS007', '2023-07-19', 70000),
('PS008', 'KS008', '2023-08-25', 65000),
('PS009', 'KS009', '2022-10-23', 80000),
('PS010', 'KS010', '2022-12-02', 95000);

-- Tes Call Procedure
SELECT * FROM Obat;

CALL Tambah_Obat_Baru('OB010', 'Promaag', 10000, 120);
CALL Tambah_Obat_Baru('OB011', 'Promaag', 10000, 120);

CALL Tambah_Stok_Obat('OB012', 75);
CALL Tambah_Stok_Obat('OB011', 75);

CALL Kurangi_Stok_Obat('OB012', 25);
CALL Kurangi_Stok_Obat('OB011', 25);

SELECT * FROM Obat;

CALL Lihat_RO_by_ID('PS001');
CALL Lihat_RO_by_ID('PS011');
CALL Lihat_RO_by_Nama('Ali');
CALL Lihat_RO_by_Nama('Kiara');

-- DCL

mysql -u root -P 3308 -p

show databases;

use klinik;

show tables;

create user 'Arif'@'localhost' IDENTIFIED BY 'kepala';
GRANT SELECT, INSERT, UPDATE, DELETE ON klinik.* TO 'Arif'@'localhost';

create user 'Burhan'@'localhost' IDENTIFIED BY 'admin';
GRANT SELECT, INSERT, UPDATE, DELETE ON klinik.* TO 'Burhan'@'localhost';

create user 'Chandra'@'localhost' IDENTIFIED BY 'dokter';
GRANT SELECT, INSERT ON klinik.* TO 'Chandra'@'localhost';

create user 'Darti'@'localhost' IDENTIFIED BY 'apoteker';
GRANT SELECT, INSERT ON klinik.* TO 'Darti'@'localhost';

mysql -u Arif -P 3308 -p
Enter password: dokter

show databases;

use klinik;

show tables;

SELECT * FROM obat;
INSERT INTO obat (ID_Obat, Nama_Obat, Harga, Stok) VALUES ('OB012', 'Vitamin D', 5000, 200);
SELECT * FROM obat;
UPDATE obat SET Nama_Obat = 'Vitamin E' WHERE ID_Obat = 'OB012';
SELECT * FROM obat;
DELETE FROM obat WHERE ID_Obat = 'OB012';
SELECT * FROM obat;
exit;

mysql -u Chandra -P 3308 -p
Enter password: dokter

show databases;

use klinik;

show tables;

select * from obat;
INSERT INTO obat (ID_Obat, Nama_Obat, Harga, Stok) VALUES ('OB012', 'Vitamin D', 5000, 200);
DELETE FROM obat WHERE ID_Obat = 'OB013';
UPDATE obat SET Nama_Obat = 'Vitamin E' WHERE ID_Obat = 'OB013';
exit;
