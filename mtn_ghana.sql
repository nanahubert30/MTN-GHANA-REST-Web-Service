-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 14, 2026 at 05:17 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mtn_ghana`
--

-- --------------------------------------------------------

-- Table structure for table `company_profile`
--

CREATE TABLE `company_profile` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `company_name` varchar(150) NOT NULL,
  `founded` varchar(10) NOT NULL,
  `headquarters` varchar(150) NOT NULL,
  `ceo` varchar(120) NOT NULL,
  `subscribers` varchar(50) NOT NULL,
  `network_type` varchar(80) NOT NULL,
  `momo_service` varchar(120) NOT NULL,
  `stock_exchange` varchar(80) NOT NULL,
  `parent_company` varchar(150) NOT NULL,
  `website` varchar(255) NOT NULL,
  `short_codes_json` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `company_profile`
--

INSERT INTO `company_profile` (`id`, `company_name`, `founded`, `headquarters`, `ceo`, `subscribers`, `network_type`, `momo_service`, `stock_exchange`, `parent_company`, `website`, `short_codes_json`) VALUES
(1, 'MTN Ghana Limited', '1994', 'Accra, Greater Accra Region, Ghana', 'Selorm Adadevoh', '28+ million', '4G LTE / 5G (pilot)', 'MTN Mobile Money (MoMo)', 'Ghana Stock Exchange (MTNGH)', 'MTN Group (South Africa)', 'https://www.mtn.com.gh', '{\"check_balance\":\"*556#\",\"data_bundle\":\"*138#\",\"momo\":\"*170#\",\"customer_care\":\"100\"}');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `id` int(10) UNSIGNED NOT NULL,
  `staff_id` varchar(15) NOT NULL COMMENT 'e.g. MTN-GH-0001',
  `full_name` varchar(120) NOT NULL,
  `department` varchar(80) NOT NULL,
  `job_title` varchar(80) NOT NULL,
  `email` varchar(120) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `salary_ghs` decimal(10,2) NOT NULL DEFAULT 0.00,
  `hire_date` date NOT NULL,
  `status` enum('active','inactive','on_leave') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`id`, `staff_id`, `full_name`, `department`, `job_title`, `email`, `phone`, `salary_ghs`, `hire_date`, `status`) VALUES
(1, 'MTN-GH-0001', 'Kwame Mensah', 'Technology', 'Senior Software Engineer', 'k.mensah@mtn.com.gh', '0244001001', 8500.00, '2019-03-15', 'active'),
(2, 'MTN-GH-0002', 'Abena Osei', 'Marketing', 'Marketing Manager', 'a.osei@mtn.com.gh', '0244001002', 7200.00, '2018-07-01', 'active'),
(3, 'MTN-GH-0003', 'Kofi Agyeman', 'Finance', 'Finance Analyst', 'k.agyeman@mtn.com.gh', '0244001003', 6800.00, '2020-01-10', 'active'),
(4, 'MTN-GH-0004', 'Ama Asante', 'Human Resources', 'HR Business Partner', 'a.asante@mtn.com.gh', '0244001004', 6500.00, '2021-05-20', 'active'),
(5, 'MTN-GH-0005', 'Yaw Boateng', 'Technology', 'Network Engineer', 'y.boateng@mtn.com.gh', '0244001005', 7800.00, '2017-11-03', 'active'),
(6, 'MTN-GH-0006', 'Akosua Darko', 'Customer Care', 'Customer Experience Lead', 'a.darko@mtn.com.gh', '0244001006', 5900.00, '2022-02-14', 'active'),
(7, 'MTN-GH-0007', 'Nana Amponsah', 'Legal', 'Corporate Counsel', 'n.amponsah@mtn.com.gh', '0244001007', 9200.00, '2016-08-22', 'active'),
(8, 'MTN-GH-0008', 'Efua Quaye', 'Technology', 'Data Scientist', 'e.quaye@mtn.com.gh', '0244001008', 8100.00, '2020-09-07', 'active'),
(9, 'MTN-GH-0009', 'Kofi Boateng', 'Technology', 'DevOps Engineer', 'k.boateng@mtn.com.gh', '0244001009', 7500.00, '2024-01-15', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(10) UNSIGNED NOT NULL,
  `product_code` varchar(30) NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `category` enum('voice','data','momo','roaming','device') NOT NULL,
  `price_ghs` decimal(8,2) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `product_code`, `product_name`, `category`, `price_ghs`, `description`, `is_active`) VALUES
(1, 'MTN-VOICE-01', 'MTN All Network Bundle', 'voice', 15.00, 'Talk to all networks – 30 days', 1),
(2, 'MTN-DATA-01', 'MTN Daily 1GB', 'data', 3.00, '1 GB data – valid 24 hours', 1),
(3, 'MTN-DATA-02', 'MTN Weekly 5GB', 'data', 20.00, '5 GB data – valid 7 days', 1),
(4, 'MTN-DATA-03', 'MTN Monthly 15GB', 'data', 70.00, '15 GB data – valid 30 days', 1),
(5, 'MTN-MOMO-01', 'MoMo Premium Wallet', 'momo', 0.00, 'Free premium mobile money wallet', 1),
(6, 'MTN-ROAM-01', 'Africa Roaming Pack', 'roaming', 50.00, 'Roam across 15 African countries', 1),
(7, 'MTN-DEV-01', '4G LTE Wi-Fi Router', 'device', 350.00, 'MTN branded 4G Wi-Fi router', 1);

-- --------------------------------------------------------

--
-- Table structure for table `subscribers`
--

CREATE TABLE `subscribers` (
  `id` int(10) UNSIGNED NOT NULL,
  `msisdn` varchar(15) NOT NULL COMMENT 'MTN GH: 024/054/055/059',
  `full_name` varchar(120) NOT NULL,
  `region` varchar(60) NOT NULL,
  `id_type` varchar(30) NOT NULL DEFAULT 'Ghana Card',
  `status` enum('active','suspended','deactivated') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subscribers`
--

INSERT INTO `subscribers` (`id`, `msisdn`, `full_name`, `region`, `id_type`, `status`, `created_at`) VALUES
(1, '0244100001', 'Esi Nyarko', 'Greater Accra', 'Ghana Card', 'active', '2026-03-11 12:23:39'),
(2, '0554200002', 'Kwabena Frimpong', 'Ashanti', 'Voter ID', 'active', '2026-03-11 12:23:39'),
(3, '0244300003', 'Maame Sarpong', 'Western', 'Ghana Card', 'active', '2026-03-11 12:23:39'),
(4, '0594400004', 'Fiifi Mensah', 'Central', 'Passport', 'active', '2026-03-11 12:23:39'),
(5, '0244500005', 'Adwoa Asamoah', 'Eastern', 'Ghana Card', 'active', '2026-03-11 12:23:39'),
(6, '0244600006', 'Kweku Asare', 'Volta', 'Ghana Card', 'active', '2026-03-14 16:00:39');

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_active_products`
-- (See below for the actual view)
--
CREATE TABLE `vw_active_products` (
`product_code` varchar(30)
,`product_name` varchar(100)
,`category` enum('voice','data','momo','roaming','device')
,`price_ghs` decimal(8,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_tech_employees`
-- (See below for the actual view)
--
CREATE TABLE `vw_tech_employees` (
`staff_id` varchar(15)
,`full_name` varchar(120)
,`job_title` varchar(80)
,`email` varchar(120)
,`salary_ghs` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Structure for view `vw_active_products`
--
DROP TABLE IF EXISTS `vw_active_products`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_active_products`  AS SELECT `products`.`product_code` AS `product_code`, `products`.`product_name` AS `product_name`, `products`.`category` AS `category`, `products`.`price_ghs` AS `price_ghs` FROM `products` WHERE `products`.`is_active` = 1 ;

-- --------------------------------------------------------

--
-- Structure for view `vw_tech_employees`
--
DROP TABLE IF EXISTS `vw_tech_employees`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_tech_employees`  AS SELECT `employees`.`staff_id` AS `staff_id`, `employees`.`full_name` AS `full_name`, `employees`.`job_title` AS `job_title`, `employees`.`email` AS `email`, `employees`.`salary_ghs` AS `salary_ghs` FROM `employees` WHERE `employees`.`department` = 'Technology' ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `company_profile`
--
ALTER TABLE `company_profile`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_staff_id` (`staff_id`),
  ADD UNIQUE KEY `uq_email` (`email`),
  ADD KEY `idx_dept` (`department`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_code` (`product_code`),
  ADD KEY `idx_cat` (`category`);

--
-- Indexes for table `subscribers`
--
ALTER TABLE `subscribers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_msisdn` (`msisdn`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `company_profile`
--
ALTER TABLE `company_profile`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `subscribers`
--
ALTER TABLE `subscribers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
