-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 20, 2023 at 08:22 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hostel`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `role` tinyint(2) NOT NULL DEFAULT 0,
  `password` varchar(255) NOT NULL,
  `picture` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `name`, `email`, `role`, `password`, `picture`, `created_at`, `updated_at`) VALUES
(1, 'Beno Mwampamba', 'bennomwampamba@gmail.com', 1, '$2y$10$.8WDAPHJb6SS9cAyo9Y2fOuvXT5MAj.qr825HsOd9asvgGM8VNsg2', '1676564752.jpg', '2023-02-16 12:25:08', '2023-03-20 01:06:53'),
(3, 'Pascal Machibya', 'paschalmachibya@yahoo.com', 0, '$2y$10$CWiJQ4GWJ6BW2VtrVIlcSe5SNeOzIJQpm89oI2oX9RY3v.rZJDgJO', '1676621136.jpeg', '2023-02-17 05:05:41', '2023-02-17 05:05:41');

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `student_id` bigint(20) UNSIGNED NOT NULL,
  `room_id` bigint(20) UNSIGNED NOT NULL,
  `check_in` date NOT NULL,
  `check_out` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `student_id`, `room_id`, `check_in`, `check_out`, `created_at`, `updated_at`) VALUES
(1, 1, 14, '2023-03-13', '2023-07-14', '2023-03-19 06:14:07', '2023-03-19 06:14:07'),
(2, 6, 15, '2023-03-13', '2023-07-28', '2023-03-19 10:18:00', '2023-03-19 10:18:00'),
(3, 7, 16, '2023-03-13', '2023-07-20', '2023-03-19 10:30:20', '2023-03-19 10:30:20'),
(4, 3, 17, '2023-03-20', '2023-07-19', '2023-03-20 04:16:59', '2023-03-20 04:16:59'),
(5, 8, 18, '2023-03-20', '2023-07-19', '2023-03-20 04:20:49', '2023-03-20 04:20:49');

-- --------------------------------------------------------

--
-- Table structure for table `dormitories`
--

CREATE TABLE `dormitories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` mediumtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `dormitories`
--

INSERT INTO `dormitories` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Dormitory 1 - Male', 'Dormitory 1 - Male', '2023-03-19 01:40:14', '2023-03-19 01:42:54'),
(2, 'Dormitory 2 - Female', 'Dormitory 2 - Female', '2023-03-19 01:41:02', '2023-03-19 01:41:02'),
(3, 'Dormitory 3 - Female', 'Dormitory 3 - Female', '2023-03-19 01:42:24', '2023-03-19 01:42:24');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(3, '2023_02_15_185525_create_domitories_table', 1),
(4, '2023_02_15_222915_create_rooms_table', 2),
(5, '2023_02_16_175947_create_room_images_table', 3),
(6, '2023_02_17_143937_create_students_table', 4),
(7, '2023_02_17_144556_create_bookings_table', 4),
(8, '2023_02_19_115426_create_payments_table', 5),
(9, '2014_10_12_100000_create_password_reset_tokens_table', 6),
(10, '2019_08_19_000000_create_failed_jobs_table', 6),
(11, '2023_03_12_062005_create_vendors_table', 6),
(12, '2023_03_18_053152_create_student_profiles_table', 7);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `student_id` bigint(20) UNSIGNED NOT NULL,
  `transaction_number` varchar(255) NOT NULL,
  `amount` varchar(255) NOT NULL,
  `payment_mode` varchar(255) NOT NULL,
  `is_paid` tinyint(2) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `student_id`, `transaction_number`, `amount`, `payment_mode`, `is_paid`, `created_at`, `updated_at`) VALUES
(18, 1, 'LA27PyYjo0', '72.65', 'PayPal', 1, '2023-03-19 06:14:50', '2023-03-19 06:14:50'),
(19, 6, 'eALd1DaHap-2023-03-19 13:20:05', '72.65', 'PayPal', 1, '2023-03-19 10:20:05', '2023-03-19 10:20:05'),
(20, 7, 'hMbSQW2IHi-2023-03-19 13:31:22', '72.65', 'PayPal', 1, '2023-03-19 10:31:22', '2023-03-19 10:31:22'),
(21, 3, 'dtrjCVSQqG-2023-03-20 07:17:19', '72.65', 'PayPal', 1, '2023-03-20 04:17:19', '2023-03-20 04:17:19'),
(22, 8, 'MZogMkbNtQ-2023-03-20 07:21:32', '72.65', 'PayPal', 1, '2023-03-20 04:21:32', '2023-03-20 04:21:32');

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `dormitory_id` bigint(20) UNSIGNED NOT NULL,
  `price` float NOT NULL DEFAULT 170000,
  `description` mediumtext DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '0==taken, 1==not taken',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`id`, `name`, `dormitory_id`, `price`, `description`, `status`, `created_at`, `updated_at`) VALUES
(14, 'Room 1', 1, 170000, 'This is the Room 1 located at Dormitory 1 - Male', 0, '2023-03-19 01:44:41', '2023-03-19 06:14:07'),
(15, 'Room 2', 1, 170000, 'Room 2', 0, '2023-03-19 03:35:43', '2023-03-19 10:18:00'),
(16, 'Room 3', 1, 170000, 'Room 3', 0, '2023-03-19 03:37:47', '2023-03-19 10:30:20'),
(17, 'Room 4', 2, 170000, 'Room 4', 0, '2023-03-19 03:43:20', '2023-03-20 04:16:59'),
(18, 'Room 5', 2, 170000, 'Room 5', 0, '2023-03-19 03:47:44', '2023-03-20 04:20:49'),
(19, 'Room 6', 2, 170000, 'Room 6', 1, '2023-03-19 03:48:53', '2023-03-19 03:49:45');

-- --------------------------------------------------------

--
-- Table structure for table `room_images`
--

CREATE TABLE `room_images` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `room_id` bigint(20) UNSIGNED NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `room_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `room_images`
--

INSERT INTO `room_images` (`id`, `room_id`, `image_path`, `room_name`, `created_at`, `updated_at`) VALUES
(56, 14, 'uploads/rooms/16792061251.jpeg', 'Room 1', '2023-03-19 03:08:45', '2023-03-19 03:08:45'),
(57, 14, 'uploads/rooms/16792061252.jpeg', 'Room 1', '2023-03-19 03:08:45', '2023-03-19 03:08:45'),
(58, 14, 'uploads/rooms/16792061253.jpeg', 'Room 1', '2023-03-19 03:08:45', '2023-03-19 03:08:45'),
(59, 15, 'uploads/rooms/16792077431.jpg', 'Room 2', '2023-03-19 03:35:43', '2023-03-19 03:35:43'),
(60, 15, 'uploads/rooms/16792077432.jpeg', 'Room 2', '2023-03-19 03:35:43', '2023-03-19 03:35:43'),
(61, 15, 'uploads/rooms/16792077433.png', 'Room 2', '2023-03-19 03:35:43', '2023-03-19 03:35:43'),
(68, 16, 'uploads/rooms/16792079981.png', 'Room 3', '2023-03-19 03:39:58', '2023-03-19 03:39:58'),
(69, 16, 'uploads/rooms/16792079982.jpeg', 'Room 3', '2023-03-19 03:39:58', '2023-03-19 03:39:58'),
(70, 16, 'uploads/rooms/16792080511.jpg', 'Room 3', '2023-03-19 03:40:51', '2023-03-19 03:40:51'),
(73, 17, 'uploads/rooms/16792082013.jpeg', 'Room 4', '2023-03-19 03:43:21', '2023-03-19 03:43:21'),
(75, 17, 'uploads/rooms/16792083551.png', 'Room 4', '2023-03-19 03:45:55', '2023-03-19 03:45:55'),
(76, 17, 'uploads/rooms/16792083552.png', 'Room 4', '2023-03-19 03:45:55', '2023-03-19 03:45:55'),
(80, 19, 'uploads/rooms/16792085331.png', 'Room 7', '2023-03-19 03:48:53', '2023-03-19 03:48:53'),
(81, 19, 'uploads/rooms/16792085332.png', 'Room 7', '2023-03-19 03:48:53', '2023-03-19 03:48:53'),
(82, 19, 'uploads/rooms/16792085343.png', 'Room 7', '2023-03-19 03:48:54', '2023-03-19 03:48:54'),
(84, 18, 'uploads/rooms/16792086392.jpeg', 'Room 5', '2023-03-19 03:50:39', '2023-03-19 03:50:39'),
(85, 18, 'uploads/rooms/16792086403.jpg', 'Room 5', '2023-03-19 03:50:40', '2023-03-19 03:50:40'),
(86, 18, 'uploads/rooms/16792086841.jpeg', 'Room 5', '2023-03-19 03:51:24', '2023-03-19 03:51:24');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `name`, `email`, `password`, `created_at`, `updated_at`) VALUES
(1, 'Nehemiah Balozi', 'nehemiahbalozi@uaut.ac.tz', '$2y$10$qa8EgaCdifEhXCP5BgF0AOehLXNEGIrUkbBltN3CSlFQjobXVVUK6', '2023-03-19 01:20:31', '2023-03-19 04:31:30'),
(2, 'Peter Mkomange', 'petermkomange@uaut.ac.tz', '$2y$10$SVlcDt9ulECv.VLEtqqueuSqRnj6969xxXnwdPNg3uCqe4OejN6TG', '2023-03-19 01:35:04', '2023-03-19 01:35:04'),
(3, 'Redemptor Peter', 'redemptor@uaut.ac.tz', '$2y$10$aRE1KkLW8B6PmcLkW.JdsOPxrj/gFg.QO0VtscZ4pD6wlQkWGu27i', '2023-03-19 02:24:25', '2023-03-19 02:24:25'),
(4, 'Abdulazack Ismail', 'abdulazackismail@uaut.ac.tz', '$2y$10$NLYM/28rTgLclEI16JtLCOC/rSj8Q5YDn2KddZgv8Ki5ubBz2dJcW', '2023-03-19 03:19:17', '2023-03-19 03:19:17'),
(5, 'Rojaz Ngauza', 'ngaiza@uaut.ac.tz', '$2y$10$/peNp4jmvG1MXOaZLyVimepSAZw/Jl1x6F2na67BxxgDIeBdx.B46', '2023-03-19 03:22:10', '2023-03-19 03:22:10'),
(6, 'Beno Mwampamba', 'bennomwampamba@gmail.com', '$2y$10$KjUiFyw3ZdwOglcBqE0hOOj.YaJH7BSB2jsNfV4Ig4PFSXn/gsnDK', '2023-03-19 10:10:19', '2023-03-20 01:08:12'),
(7, 'Pascal Machibya', 'paschalmachibya@yahoo.com', '$2y$10$uYdQw6h2lx1ICa2rGPT5f.6veMhPIh3wvu/gotcochflgxMP76CMe', '2023-03-19 10:28:51', '2023-03-19 10:28:51'),
(8, 'Jenipher Siriwa', 'jenifersiriwa@uaut.ac.tz', '$2y$10$WqmfZhRF8hybIuCTMggQZudchLp3H.wQW5xCiFWCnynPlf2NNDmT6', '2023-03-19 11:58:09', '2023-03-19 11:58:09');

-- --------------------------------------------------------

--
-- Table structure for table `student_profiles`
--

CREATE TABLE `student_profiles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `student_id` bigint(20) UNSIGNED NOT NULL,
  `programme` varchar(255) NOT NULL,
  `class` varchar(255) NOT NULL,
  `academic_year` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `emergency_number` varchar(255) NOT NULL,
  `sex` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `student_profiles`
--

INSERT INTO `student_profiles` (`id`, `student_id`, `programme`, `class`, `academic_year`, `phone`, `emergency_number`, `sex`, `created_at`, `updated_at`) VALUES
(1, 1, 'BCEIT', 'Fourth year', '2022/ 2023', '0789486789', '0786543245', 'Male', '2023-03-19 01:33:31', '2023-03-19 01:33:31'),
(2, 2, 'BCEIT', 'Third year', '2022/ 2023', '0786456789', '0765432567', 'Male', '2023-03-19 02:07:38', '2023-03-19 02:07:38'),
(3, 3, 'BCEIT', 'Fourth year', '2022/ 2023', '0756077828', '0765464748', 'Female', '2023-03-19 02:57:43', '2023-03-19 02:57:43'),
(5, 5, 'BCEIT', 'Fourth year', '2022/ 2023', '0777486789', '0765345789', 'Male', '2023-03-19 03:26:28', '2023-03-19 03:26:28'),
(8, 6, 'BCEIT', 'Fourth year', '2022/ 2023', '0656077828', '0684710771', 'Male', '2023-03-19 10:16:59', '2023-03-19 10:16:59'),
(9, 7, 'BCEIT', 'Fourth year', '2022/ 2023', '0789657874', '0745678980', 'Male', '2023-03-19 10:29:43', '2023-03-19 10:29:43'),
(10, 8, 'BCEIT', 'Fourth year', '2022/ 2023', '076534554460', '07654454444', 'Female', '2023-03-19 12:12:32', '2023-03-19 12:12:32');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bookings_student_id_foreign` (`student_id`),
  ADD KEY `bookings_room_id_foreign` (`room_id`);

--
-- Indexes for table `dormitories`
--
ALTER TABLE `dormitories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payments_student_id_foreign` (`student_id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rooms_dormitory_id_foreign` (`dormitory_id`);

--
-- Indexes for table `room_images`
--
ALTER TABLE `room_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `room_images_room_id_foreign` (`room_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `student_profiles`
--
ALTER TABLE `student_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_profiles_phone_unique` (`phone`),
  ADD UNIQUE KEY `student_profiles_emergency_number_unique` (`emergency_number`),
  ADD KEY `student_profiles_student_id_foreign` (`student_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `dormitories`
--
ALTER TABLE `dormitories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `room_images`
--
ALTER TABLE `room_images`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `student_profiles`
--
ALTER TABLE `student_profiles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_room_id_foreign` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookings_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `rooms`
--
ALTER TABLE `rooms`
  ADD CONSTRAINT `rooms_dormitory_id_foreign` FOREIGN KEY (`dormitory_id`) REFERENCES `dormitories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `room_images`
--
ALTER TABLE `room_images`
  ADD CONSTRAINT `room_images_room_id_foreign` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_profiles`
--
ALTER TABLE `student_profiles`
  ADD CONSTRAINT `student_profiles_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
