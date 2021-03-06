-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 21 Mar 2019 pada 03.30
-- Versi server: 10.1.38-MariaDB
-- Versi PHP: 7.3.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `prima`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getbarang` (IN `stk` INT(20), IN `hrgb` INT(20))  NO SQL
BEGIN
	SELECT * FROM barang
    WHERE stok=stk
    AND hargab=hrgb;
END$$

--
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getAvg` (`ket` INT(10)) RETURNS INT(11) NO SQL
RETURN (SELECT AVG(barang.hargab) FROM barang WHERE barang.idkat=ket)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getKategori` () RETURNS INT(10) NO SQL
RETURN (SELECT COUNT(harga) FROM barangmasuk, supplier WHERE barangmasuk.id_supplier=supplier.id_supplier AND harga<200000 )$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `barang`
--

CREATE TABLE `barang` (
  `id_barang` int(10) NOT NULL,
  `namabarang` text NOT NULL,
  `idkat` int(10) NOT NULL,
  `stok` int(20) NOT NULL,
  `ids` int(10) NOT NULL,
  `hargab` int(20) NOT NULL,
  `hargaj` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `barang`
--

INSERT INTO `barang` (`id_barang`, `namabarang`, `idkat`, `stok`, `ids`, `hargab`, `hargaj`) VALUES
(2, '124p', 1, 2, 2, 370000, 380000),
(5, 'premix', 2, 45, 3, 12500, 15000),
(6, '511b', 1, 15, 2, 120000, 150000),
(7, 'parli', 1, 12, 2, 80000, 100000);

-- --------------------------------------------------------

--
-- Struktur dari tabel `barangmasuk`
--

CREATE TABLE `barangmasuk` (
  `nofaktur` varchar(10) DEFAULT NULL,
  `tgl` date NOT NULL,
  `id_barang` int(10) NOT NULL,
  `id_supplier` int(10) NOT NULL,
  `jumlah` int(10) NOT NULL,
  `harga` int(20) NOT NULL,
  `jual` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `barangmasuk`
--

INSERT INTO `barangmasuk` (`nofaktur`, `tgl`, `id_barang`, `id_supplier`, `jumlah`, `harga`, `jual`) VALUES
('1234', '2018-12-12', 2, 4, 5, 300000, 300000),
('1234', '2018-12-12', 5, 4, 5, 100000, 100000);

--
-- Trigger `barangmasuk`
--
DELIMITER $$
CREATE TRIGGER `barangmamsukadd` AFTER INSERT ON `barangmasuk` FOR EACH ROW BEGIN
	UPDATE barang SET stok=stok+NEW.jumlah
    WHERE id_barang=NEW.id_barang;
    UPDATE barang SET hargaj=NEW.jual
    WHERE id_barang=NEW.id_barang;
    UPDATE barang SET hargab=NEW.harga
    WHERE id_barang=NEW.id_barang;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `barangmasuk_tmp`
--

CREATE TABLE `barangmasuk_tmp` (
  `id_barang` int(10) NOT NULL,
  `jumlah` int(10) NOT NULL,
  `harga` int(20) NOT NULL,
  `jual` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `barangmasuk_tmp`
--

INSERT INTO `barangmasuk_tmp` (`id_barang`, `jumlah`, `harga`, `jual`) VALUES
(2, 2, 300000, 300000),
(5, 2, 100000, 100000);

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail`
--

CREATE TABLE `detail` (
  `kode_transaksi` varchar(100) NOT NULL,
  `id_barang` int(11) NOT NULL,
  `jumlah_beli` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `detail`
--

INSERT INTO `detail` (`kode_transaksi`, `id_barang`, `jumlah_beli`) VALUES
('TRS000051', 5, 1),
('TRS0001', 2, 1),
('TRS000002', 2, 1),
('TRS000003', 2, 1),
('TRS000004', 6, 1),
('TRS000004', 2, 1),
('TRS000005', 5, 1),
('TRS000006', 2, 1),
('TRS000007', 2, 1),
('TRS000008', 2, 1),
('TRS000009', 5, 1),
('TRS000010', 5, 1),
('TRS000011', 2, 1),
('TRS000018', 2, 1),
('TRS000018', 6, 2),
('TRS000019', 2, 2),
('TRS000020', 5, 1);

--
-- Trigger `detail`
--
DELIMITER $$
CREATE TRIGGER `kurangistok` AFTER INSERT ON `detail` FOR EACH ROW BEGIN
	UPDATE barang SET stok=stok - NEW.jumlah_beli
    WHERE id_barang=NEW.id_barang;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_pemesanan`
--

CREATE TABLE `detail_pemesanan` (
  `kode_pemesanan` varchar(100) NOT NULL,
  `id_po` int(10) NOT NULL,
  `jumlah` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `detail_pemesanan`
--

INSERT INTO `detail_pemesanan` (`kode_pemesanan`, `id_po`, `jumlah`) VALUES
('PSN000001', 1, 1),
('PSN000002', 2, 1),
('PSN000003', 2, 1),
('PSN000004', 1, 1),
('PSN000005', 1, 1),
('PSN000006', 1, 1),
('PSN000007', 1, 2),
('PSN000008', 1, 2),
('PSN000009', 1, 1),
('PSN000010', 1, 8),
('PSN000011', 1, 1),
('PSN000012', 2, 1),
('PSN000015', 1, 1),
('PSN000015', 0, 0),
('PSN000016', 1, 1),
('PSN000017', 2, 1),
('PSN000018', 1, 3);

-- --------------------------------------------------------

--
-- Struktur dari tabel `kategori`
--

CREATE TABLE `kategori` (
  `idkat` int(10) NOT NULL,
  `kategori` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `kategori`
--

INSERT INTO `kategori` (`idkat`, `kategori`) VALUES
(1, 'pakan'),
(2, 'obat');

-- --------------------------------------------------------

--
-- Struktur dari tabel `login`
--

CREATE TABLE `login` (
  `id_user` varchar(5) NOT NULL,
  `username` varchar(25) NOT NULL,
  `password` varchar(25) NOT NULL,
  `level` enum('admin','karyawan','','') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `login`
--

INSERT INTO `login` (`id_user`, `username`, `password`, `level`) VALUES
('1', 'admin', 'admin', 'admin'),
('2', 'safina', 'safii', 'karyawan'),
('80', 'yusuf', 'yusuf', 'karyawan'),
('89', 'khizam', 'asdfjisdfjis', 'admin');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pegawai`
--

CREATE TABLE `pegawai` (
  `id_pegawai` int(11) NOT NULL,
  `namapegawai` text NOT NULL,
  `alamat` text NOT NULL,
  `jenkel` enum('pria','wanita') NOT NULL,
  `tlp` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pemesanan`
--

CREATE TABLE `pemesanan` (
  `kode_pemesanan` varchar(100) NOT NULL,
  `tanggal` date NOT NULL,
  `namapemesan` text NOT NULL,
  `telepon` varchar(15) NOT NULL,
  `alamat` text NOT NULL,
  `total` int(20) NOT NULL,
  `bayar` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `pemesanan`
--

INSERT INTO `pemesanan` (`kode_pemesanan`, `tanggal`, `namapemesan`, `telepon`, `alamat`, `total`, `bayar`) VALUES
('PSN000001', '0000-00-00', 'anisetya', '089633150084', 'sukowono', 56000, 50000),
('PSN000002', '0000-00-00', 'pak pit', '082234657123', 'kokertah', 500000, 450000),
('PSN000003', '0000-00-00', 'vivi', '45678', 'pasuruan', 500000, 0),
('PSN000004', '0000-00-00', 'as', '12', 'sda', 56000, 0),
('PSN000005', '0000-00-00', 'ads', '12', 'asd', 56000, 0),
('PSN000006', '0000-00-00', 'asd', 'asd', '', 56000, 0),
('PSN000007', '0000-00-00', 'cxz', 'cZX', '', 112000, 0),
('PSN000008', '0000-00-00', 'asd', 'asd', '', 112000, 0),
('PSN000009', '0000-00-00', 'ad', '12', 'ds', 56000, 122),
('PSN000010', '1970-01-01', '', '', '', 448000, 448000),
('PSN000011', '2018-12-14', 'sad', '567i', '', 56000, 56000),
('PSN000012', '1970-01-01', 'ui', '3467', '', 500000, 500000),
('PSN000013', '1970-01-01', '', '', '', 0, 0),
('PSN000014', '2018-12-14', '', '', '', 0, 0),
('PSN000015', '2018-12-14', '', '', '', 56000, 9000),
('PSN000016', '2018-12-14', '', '', '', 56000, 0),
('PSN000017', '2018-12-14', '', '', '', 500000, 0),
('PSN000018', '2018-12-14', 'asas', '9809', '', 168000, 77);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pemesanan_tmp`
--

CREATE TABLE `pemesanan_tmp` (
  `id_po` int(10) NOT NULL,
  `jumlah` int(20) NOT NULL,
  `sid` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `po`
--

CREATE TABLE `po` (
  `id_po` int(10) NOT NULL,
  `nama` text NOT NULL,
  `harga` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `po`
--

INSERT INTO `po` (`id_po`, `nama`, `harga`) VALUES
(1, 'pullet isa brown', 56000),
(2, 'doc wonokoyo', 500000);

-- --------------------------------------------------------

--
-- Struktur dari tabel `satuan`
--

CREATE TABLE `satuan` (
  `ids` int(10) NOT NULL,
  `namasatuan` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `satuan`
--

INSERT INTO `satuan` (`ids`, `namasatuan`) VALUES
(2, 'sak'),
(3, 'kilo'),
(4, '12');

-- --------------------------------------------------------

--
-- Struktur dari tabel `supplier`
--

CREATE TABLE `supplier` (
  `id_supplier` int(10) NOT NULL,
  `namasupplier` text NOT NULL,
  `alamat` text NOT NULL,
  `telefon` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `supplier`
--

INSERT INTO `supplier` (`id_supplier`, `namasupplier`, `alamat`, `telefon`) VALUES
(4, 'pokphan', 'surabaya arjasa', '089633150044'),
(5, 'tahu', 'jakarta', '56789');

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi`
--

CREATE TABLE `transaksi` (
  `kode_transaksi` varchar(100) NOT NULL,
  `tanggal` date NOT NULL,
  `total` int(20) NOT NULL,
  `potongan` int(20) NOT NULL,
  `bayar` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `transaksi`
--

INSERT INTO `transaksi` (`kode_transaksi`, `tanggal`, `total`, `potongan`, `bayar`) VALUES
('T2345678', '0000-00-00', 0, 0, 9999),
('TRS000002', '0000-00-00', 380000, 0, 400000),
('TRS000003', '0000-00-00', 380000, 0, 400000),
('TRS000004', '0000-00-00', 380000, 0, 400000),
('TRS000005', '0000-00-00', 15000, 0, 15000),
('TRS000006', '0000-00-00', 380000, 0, 400000),
('TRS000007', '0000-00-00', 380000, 0, 500000),
('TRS000008', '0000-00-00', 380000, 0, 450000),
('TRS000009', '0000-00-00', 15000, 0, 15000),
('TRS000010', '0000-00-00', 15000, 0, 15000),
('TRS000011', '0000-00-00', 380000, 0, 400000),
('TRS000012', '0000-00-00', 0, 0, 90),
('TRS000013', '0000-00-00', 0, 0, 99999),
('TRS000015', '2018-12-14', 0, 0, 800),
('TRS000016', '2018-12-14', 0, 0, 900),
('TRS000017', '2018-12-14', 0, 0, 0),
('TRS000018', '2018-12-14', 380000, 0, 400000),
('TRS000019', '1970-01-01', 760000, 0, 760000),
('TRS000020', '2018-12-16', 15000, 0, 15000),
('TRS0001', '0000-00-00', 380000, 0, 400000);

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi_tmp`
--

CREATE TABLE `transaksi_tmp` (
  `id_barang` int(10) NOT NULL,
  `jumlah` int(10) NOT NULL,
  `sid` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `transaksi_tmp`
--

INSERT INTO `transaksi_tmp` (`id_barang`, `jumlah`, `sid`) VALUES
(0, 0, 'rm9l8tr1961auomi1npoc955k6'),
(2, 5, 'u8b4jc5vamt10de3lobqnrv145'),
(0, 0, 'u8b4jc5vamt10de3lobqnrv145'),
(2, 1, '5fbgg1uqls86423n8tes9q8jt5'),
(2, 1, '70a8vlvsr92dv5t3l9o3h5fi32');

--
-- Trigger `transaksi_tmp`
--
DELIMITER $$
CREATE TRIGGER `tmp` AFTER INSERT ON `transaksi_tmp` FOR EACH ROW BEGIN
	UPDATE barang SET stok=stok - NEW.jumlah
    WHERE id_barang=NEW.id_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tmpdel` AFTER DELETE ON `transaksi_tmp` FOR EACH ROW BEGIN
	UPDATE barang SET stok=stok + OLD.jumlah
    WHERE id_barang=OLD.id_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updatetmp` AFTER UPDATE ON `transaksi_tmp` FOR EACH ROW BEGIN
	IF NEW.jumlah <> OLD.jumlah THEN
    	UPDATE barang SET stok=stok+OLD.jumlah
        WHERE id_barang=NEW.id_barang;
        
        
        UPDATE barang SET stok=stok-NEW.jumlah
        WHERE id_barang=NEW.id_barang;
        END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id_barang`),
  ADD KEY `ids` (`ids`,`idkat`),
  ADD KEY `idkat` (`idkat`);

--
-- Indeks untuk tabel `barangmasuk`
--
ALTER TABLE `barangmasuk`
  ADD UNIQUE KEY `id_barang` (`id_barang`),
  ADD KEY `id_supplier` (`id_supplier`);

--
-- Indeks untuk tabel `detail`
--
ALTER TABLE `detail`
  ADD KEY `kode_transaksi` (`kode_transaksi`),
  ADD KEY `id_barang` (`id_barang`);

--
-- Indeks untuk tabel `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`idkat`);

--
-- Indeks untuk tabel `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`id_user`);

--
-- Indeks untuk tabel `pegawai`
--
ALTER TABLE `pegawai`
  ADD PRIMARY KEY (`id_pegawai`);

--
-- Indeks untuk tabel `pemesanan`
--
ALTER TABLE `pemesanan`
  ADD PRIMARY KEY (`kode_pemesanan`);

--
-- Indeks untuk tabel `po`
--
ALTER TABLE `po`
  ADD PRIMARY KEY (`id_po`);

--
-- Indeks untuk tabel `satuan`
--
ALTER TABLE `satuan`
  ADD PRIMARY KEY (`ids`);

--
-- Indeks untuk tabel `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id_supplier`);

--
-- Indeks untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`kode_transaksi`);

--
-- Indeks untuk tabel `transaksi_tmp`
--
ALTER TABLE `transaksi_tmp`
  ADD KEY `id_barang` (`id_barang`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `barang`
--
ALTER TABLE `barang`
  MODIFY `id_barang` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `kategori`
--
ALTER TABLE `kategori`
  MODIFY `idkat` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `pegawai`
--
ALTER TABLE `pegawai`
  MODIFY `id_pegawai` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `po`
--
ALTER TABLE `po`
  MODIFY `id_po` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `satuan`
--
ALTER TABLE `satuan`
  MODIFY `ids` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `supplier`
--
ALTER TABLE `supplier`
  MODIFY `id_supplier` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `barang`
--
ALTER TABLE `barang`
  ADD CONSTRAINT `barang_ibfk_1` FOREIGN KEY (`ids`) REFERENCES `satuan` (`ids`) ON UPDATE CASCADE,
  ADD CONSTRAINT `barang_ibfk_2` FOREIGN KEY (`idkat`) REFERENCES `kategori` (`idkat`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `barangmasuk`
--
ALTER TABLE `barangmasuk`
  ADD CONSTRAINT `barangmasuk_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`) ON UPDATE CASCADE,
  ADD CONSTRAINT `barangmasuk_ibfk_2` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id_supplier`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `detail`
--
ALTER TABLE `detail`
  ADD CONSTRAINT `detail_ibfk_2` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
