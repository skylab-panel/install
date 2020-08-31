-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 27, 2020 at 02:08 PM
-- Server version: 10.3.22-MariaDB-1ubuntu1
-- PHP Version: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `skylabpanel`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_packages`
--

CREATE TABLE `tbl_packages` (
  `package_id` int(6) UNSIGNED NOT NULL,
  `package_name` varchar(30) NOT NULL,
  `package_cost` decimal(6,2) UNSIGNED NOT NULL,
  `max_domains` smallint(5) UNSIGNED NOT NULL,
  `max_sub_domains` smallint(5) UNSIGNED NOT NULL,
  `max_storage` smallint(5) UNSIGNED NOT NULL,
  `max_ftp_accounts` smallint(5) UNSIGNED NOT NULL,
  `max_databases` smallint(5) UNSIGNED NOT NULL,
  `max_email_accounts` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_usage`
--

CREATE TABLE `tbl_usage` (
  `user_id` int(6) UNSIGNED NOT NULL,
  `domain` varchar(253) NOT NULL,
  `package_name` varchar(30) NOT NULL,
  `used_domains` smallint(5) UNSIGNED NOT NULL,
  `used_sub_domains` smallint(5) UNSIGNED NOT NULL,
  `used_storage` smallint(5) UNSIGNED NOT NULL,
  `used_ftp_accounts` smallint(5) UNSIGNED NOT NULL,
  `used_databases` smallint(5) UNSIGNED NOT NULL,
  `used_email_accounts` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(6) UNSIGNED NOT NULL,
  `firstname` varchar(30) NOT NULL,
  `lastname` varchar(30) NOT NULL,
  `username` varchar(30) NOT NULL,
  `email` varchar(320) NOT NULL,
  `password` varchar(100) NOT NULL,
  `account_type` varchar(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_websites`
--

CREATE TABLE `tbl_websites` (
  `user_id` int(6) UNSIGNED NOT NULL,
  `domain` varchar(253) NOT NULL,
  `package_name` varchar(253) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_packages`
--
ALTER TABLE `tbl_packages`
  ADD PRIMARY KEY (`package_id`),
  ADD UNIQUE KEY `package_name` (`package_name`) USING BTREE;

--
-- Indexes for table `tbl_usage`
--
ALTER TABLE `tbl_usage`
  ADD PRIMARY KEY (`domain`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `package_name` (`package_name`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `tbl_websites`
--
ALTER TABLE `tbl_websites`
  ADD PRIMARY KEY (`domain`),
  ADD KEY `package_name` (`package_name`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_packages`
--
ALTER TABLE `tbl_packages`
  MODIFY `package_id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_usage`
--
ALTER TABLE `tbl_usage`
  ADD CONSTRAINT `tbl_usage_ibfk_3` FOREIGN KEY (`package_name`) REFERENCES `tbl_packages` (`package_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_usage_ibfk_4` FOREIGN KEY (`domain`) REFERENCES `tbl_websites` (`domain`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_usage_ibfk_5` FOREIGN KEY (`user_id`) REFERENCES `tbl_websites` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_websites`
--
ALTER TABLE `tbl_websites`
  ADD CONSTRAINT `tbl_websites_ibfk_3` FOREIGN KEY (`package_name`) REFERENCES `tbl_packages` (`package_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_websites_ibfk_4` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
