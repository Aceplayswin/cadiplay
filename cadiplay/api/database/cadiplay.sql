/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.0.2-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: cadiplay
-- ------------------------------------------------------
-- Server version	8.4.11-0ubuntu0.26.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `admin_audit_logs`
--

DROP TABLE IF EXISTS `admin_audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_audit_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `admin_id` bigint unsigned NOT NULL,
  `action` varchar(100) NOT NULL,
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` bigint unsigned DEFAULT NULL,
  `before_value` json DEFAULT NULL,
  `after_value` json DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `admin_id` (`admin_id`),
  CONSTRAINT `admin_audit_logs_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_audit_logs`
--

LOCK TABLES `admin_audit_logs` WRITE;
/*!40000 ALTER TABLE `admin_audit_logs` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `admin_audit_logs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `admin_manager_notes`
--

DROP TABLE IF EXISTS `admin_manager_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_manager_notes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `note` text NOT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_amn_user` (`user_id`),
  CONSTRAINT `admin_manager_notes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_manager_notes`
--

LOCK TABLES `admin_manager_notes` WRITE;
/*!40000 ALTER TABLE `admin_manager_notes` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `admin_manager_notes` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_api_keys`
--

DROP TABLE IF EXISTS `affiliate_api_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_api_keys` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `affiliate_id` bigint unsigned NOT NULL,
  `key_id` varchar(64) NOT NULL,
  `public_pem` text NOT NULL,
  `fingerprint` varchar(64) DEFAULT NULL,
  `status` enum('active','rotating','revoked') DEFAULT 'active',
  `last_used_at` datetime DEFAULT NULL,
  `grace_until` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `revoked_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_aak_key` (`key_id`),
  KEY `idx_aak_aff` (`affiliate_id`),
  CONSTRAINT `affiliate_api_keys_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `affiliates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_api_keys`
--

LOCK TABLES `affiliate_api_keys` WRITE;
/*!40000 ALTER TABLE `affiliate_api_keys` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_api_keys` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_api_logs`
--

DROP TABLE IF EXISTS `affiliate_api_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_api_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `affiliate_id` bigint unsigned DEFAULT NULL,
  `key_id` varchar(64) DEFAULT NULL,
  `direction` enum('inbound','outbound') DEFAULT 'inbound',
  `endpoint` varchar(255) DEFAULT NULL,
  `method` varchar(10) DEFAULT NULL,
  `status_code` int DEFAULT NULL,
  `signature_result` enum('valid','invalid','missing','replay','expired','revoked') DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_aal_aff_created` (`affiliate_id`,`created_at`),
  CONSTRAINT `affiliate_api_logs_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `affiliates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_api_logs`
--

LOCK TABLES `affiliate_api_logs` WRITE;
/*!40000 ALTER TABLE `affiliate_api_logs` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_api_logs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_api_nonces`
--

DROP TABLE IF EXISTS `affiliate_api_nonces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_api_nonces` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `key_id` varchar(64) NOT NULL,
  `nonce` varchar(96) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_aan_key_nonce` (`key_id`,`nonce`),
  KEY `idx_aan_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_api_nonces`
--

LOCK TABLES `affiliate_api_nonces` WRITE;
/*!40000 ALTER TABLE `affiliate_api_nonces` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_api_nonces` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_audit_logs`
--

DROP TABLE IF EXISTS `affiliate_audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_audit_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `affiliate_id` bigint unsigned DEFAULT NULL,
  `actor_type` enum('affiliate','staff','system') NOT NULL,
  `actor_id` bigint unsigned DEFAULT NULL,
  `actor_label` varchar(80) DEFAULT NULL,
  `action` varchar(120) NOT NULL,
  `target` varchar(160) DEFAULT NULL,
  `before_value` json DEFAULT NULL,
  `after_value` json DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_aal_aff_created` (`affiliate_id`,`created_at`),
  KEY `idx_aal_created` (`created_at`),
  CONSTRAINT `affiliate_audit_logs_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `affiliates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_audit_logs`
--

LOCK TABLES `affiliate_audit_logs` WRITE;
/*!40000 ALTER TABLE `affiliate_audit_logs` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_audit_logs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_clicks`
--

DROP TABLE IF EXISTS `affiliate_clicks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_clicks` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `affiliate_id` bigint unsigned NOT NULL,
  `link_id` bigint unsigned DEFAULT NULL,
  `sub_id` varchar(60) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `referrer_url` varchar(500) DEFAULT NULL,
  `country_code` char(2) DEFAULT NULL,
  `converted` tinyint(1) DEFAULT '0',
  `converted_user_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_afc_aff_created` (`affiliate_id`,`created_at`),
  KEY `idx_afc_link_created` (`link_id`,`created_at`),
  KEY `idx_afc_ip_created` (`ip_address`,`created_at`),
  CONSTRAINT `affiliate_clicks_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `affiliates` (`id`) ON DELETE CASCADE,
  CONSTRAINT `affiliate_clicks_ibfk_2` FOREIGN KEY (`link_id`) REFERENCES `affiliate_links` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_clicks`
--

LOCK TABLES `affiliate_clicks` WRITE;
/*!40000 ALTER TABLE `affiliate_clicks` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_clicks` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_commission_ledger`
--

DROP TABLE IF EXISTS `affiliate_commission_ledger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_commission_ledger` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `affiliate_id` bigint unsigned NOT NULL,
  `referral_id` bigint unsigned DEFAULT NULL,
  `source_affiliate_id` bigint unsigned DEFAULT NULL,
  `entry_type` enum('revenue_share','cpa','override','adjustment','clawback') NOT NULL,
  `base_kind` enum('ngr','ftd','network_commission','manual') NOT NULL,
  `base_amount` decimal(18,2) DEFAULT '0.00',
  `rate` decimal(6,2) DEFAULT '0.00',
  `amount` decimal(18,2) NOT NULL,
  `currency` varchar(10) DEFAULT 'USD',
  `status` enum('pending','approved','paid','rejected','clawed_back') DEFAULT 'pending',
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `payout_id` bigint unsigned DEFAULT NULL,
  `run_id` bigint unsigned DEFAULT NULL,
  `dedupe_key` varchar(120) NOT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_alg_dedupe` (`affiliate_id`,`dedupe_key`),
  KEY `idx_alg_aff_status` (`affiliate_id`,`status`),
  KEY `idx_alg_payout` (`payout_id`),
  KEY `idx_alg_period` (`period_start`),
  CONSTRAINT `affiliate_commission_ledger_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `affiliates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_commission_ledger`
--

LOCK TABLES `affiliate_commission_ledger` WRITE;
/*!40000 ALTER TABLE `affiliate_commission_ledger` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_commission_ledger` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_commission_runs`
--

DROP TABLE IF EXISTS `affiliate_commission_runs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_commission_runs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `period_start` date DEFAULT NULL,
  `period_end` date DEFAULT NULL,
  `status` enum('running','completed','failed') DEFAULT 'running',
  `trigger_source` enum('cron','admin') DEFAULT 'cron',
  `triggered_by` bigint unsigned DEFAULT NULL,
  `entries_written` int DEFAULT '0',
  `entries_skipped` int DEFAULT '0',
  `entries_approved` int DEFAULT '0',
  `total_amount` decimal(18,2) DEFAULT '0.00',
  `error` text,
  `started_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `finished_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_acr_started` (`started_at`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_commission_runs`
--

LOCK TABLES `affiliate_commission_runs` WRITE;
/*!40000 ALTER TABLE `affiliate_commission_runs` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_commission_runs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_creatives`
--

DROP TABLE IF EXISTS `affiliate_creatives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_creatives` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `asset_type` enum('banner','logo','video') DEFAULT 'banner',
  `file_url` varchar(500) NOT NULL,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `dimensions` varchar(20) DEFAULT NULL,
  `size_label` varchar(40) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `sort_order` int DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_creatives`
--

LOCK TABLES `affiliate_creatives` WRITE;
/*!40000 ALTER TABLE `affiliate_creatives` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_creatives` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_fraud_flags`
--

DROP TABLE IF EXISTS `affiliate_fraud_flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_fraud_flags` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `affiliate_id` bigint unsigned NOT NULL,
  `referral_id` bigint unsigned DEFAULT NULL,
  `reason` varchar(255) NOT NULL,
  `rule_key` varchar(60) DEFAULT NULL,
  `risk_level` enum('low','medium','high','critical') DEFAULT 'medium',
  `status` enum('open','dismissed','actioned') DEFAULT 'open',
  `metadata` json DEFAULT NULL,
  `resolved_by` bigint unsigned DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_aff_flag_aff` (`affiliate_id`),
  KEY `idx_aff_flag_status` (`status`),
  CONSTRAINT `affiliate_fraud_flags_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `affiliates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_fraud_flags`
--

LOCK TABLES `affiliate_fraud_flags` WRITE;
/*!40000 ALTER TABLE `affiliate_fraud_flags` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_fraud_flags` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_kyc_docs`
--

DROP TABLE IF EXISTS `affiliate_kyc_docs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_kyc_docs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `affiliate_id` bigint unsigned NOT NULL,
  `document_type` varchar(40) NOT NULL,
  `file_url` varchar(500) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_affiliate_kyc_affiliate` (`affiliate_id`),
  CONSTRAINT `affiliate_kyc_docs_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `affiliates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_kyc_docs`
--

LOCK TABLES `affiliate_kyc_docs` WRITE;
/*!40000 ALTER TABLE `affiliate_kyc_docs` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_kyc_docs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_kyc_documents`
--

DROP TABLE IF EXISTS `affiliate_kyc_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_kyc_documents` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `affiliate_id` bigint unsigned NOT NULL,
  `document_type` enum('id_proof','address_proof','company_registration','tax_certificate','bank_proof','selfie') NOT NULL,
  `file_url` varchar(500) DEFAULT NULL,
  `original_name` varchar(255) DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `rejection_reason` text,
  `reviewed_by` bigint unsigned DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_akd_aff` (`affiliate_id`),
  CONSTRAINT `affiliate_kyc_documents_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `affiliates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_kyc_documents`
--

LOCK TABLES `affiliate_kyc_documents` WRITE;
/*!40000 ALTER TABLE `affiliate_kyc_documents` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_kyc_documents` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_links`
--

DROP TABLE IF EXISTS `affiliate_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_links` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `affiliate_id` bigint unsigned NOT NULL,
  `code` varchar(32) NOT NULL,
  `name` varchar(150) NOT NULL,
  `sub_id` varchar(80) DEFAULT NULL,
  `target_path` varchar(255) DEFAULT '/',
  `is_active` tinyint(1) DEFAULT '1',
  `clicks_count` int DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `clicks` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_afl_code` (`code`),
  KEY `idx_afl_aff` (`affiliate_id`),
  KEY `idx_afl_aff_active` (`affiliate_id`,`is_active`),
  CONSTRAINT `affiliate_links_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `affiliates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_links`
--

LOCK TABLES `affiliate_links` WRITE;
/*!40000 ALTER TABLE `affiliate_links` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_links` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_login_challenges`
--

DROP TABLE IF EXISTS `affiliate_login_challenges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_login_challenges` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `affiliate_id` bigint unsigned NOT NULL,
  `challenge_token` varchar(64) NOT NULL,
  `purpose` enum('2fa','reset') NOT NULL,
  `attempts` int DEFAULT '0',
  `expires_at` datetime NOT NULL,
  `consumed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_alc_token` (`challenge_token`),
  KEY `idx_alc_aff` (`affiliate_id`),
  CONSTRAINT `affiliate_login_challenges_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `affiliates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_login_challenges`
--

LOCK TABLES `affiliate_login_challenges` WRITE;
/*!40000 ALTER TABLE `affiliate_login_challenges` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_login_challenges` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_notifications`
--

DROP TABLE IF EXISTS `affiliate_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_notifications` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `affiliate_id` bigint unsigned NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_affiliate_notifs_affiliate` (`affiliate_id`,`is_read`),
  CONSTRAINT `affiliate_notifications_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `affiliates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_notifications`
--

LOCK TABLES `affiliate_notifications` WRITE;
/*!40000 ALTER TABLE `affiliate_notifications` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_notifications` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_payout_methods`
--

DROP TABLE IF EXISTS `affiliate_payout_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_payout_methods` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `affiliate_id` bigint unsigned NOT NULL,
  `method_type` enum('bank','upi','crypto') NOT NULL,
  `label` varchar(100) DEFAULT NULL,
  `details` json DEFAULT NULL,
  `masked_details` varchar(120) DEFAULT NULL,
  `is_primary` tinyint(1) DEFAULT '0',
  `is_verified` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_apm_aff` (`affiliate_id`),
  CONSTRAINT `affiliate_payout_methods_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `affiliates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_payout_methods`
--

LOCK TABLES `affiliate_payout_methods` WRITE;
/*!40000 ALTER TABLE `affiliate_payout_methods` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_payout_methods` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_payouts`
--

DROP TABLE IF EXISTS `affiliate_payouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_payouts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `affiliate_id` bigint unsigned NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `currency` varchar(10) DEFAULT 'USD',
  `method_id` bigint unsigned DEFAULT NULL,
  `method_label` varchar(120) DEFAULT NULL,
  `method_details` varchar(255) DEFAULT NULL,
  `status` enum('requested','pending','approved','paid','rejected') NOT NULL DEFAULT 'pending',
  `reference` varchar(120) DEFAULT NULL,
  `rejection_reason` varchar(500) DEFAULT NULL,
  `requested_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `processed_at` datetime DEFAULT NULL,
  `processed_by` bigint unsigned DEFAULT NULL,
  `notes` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `payout_method_id` bigint unsigned DEFAULT NULL,
  `method` varchar(120) DEFAULT NULL,
  `note` text,
  `reviewed_by` bigint unsigned DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_afp_aff` (`affiliate_id`),
  KEY `idx_afp_status` (`status`),
  CONSTRAINT `affiliate_payouts_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `affiliates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_payouts`
--

LOCK TABLES `affiliate_payouts` WRITE;
/*!40000 ALTER TABLE `affiliate_payouts` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_payouts` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_referrals`
--

DROP TABLE IF EXISTS `affiliate_referrals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_referrals` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `affiliate_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `link_id` bigint unsigned DEFAULT NULL,
  `click_id` bigint unsigned DEFAULT NULL,
  `sub_id` varchar(60) DEFAULT NULL,
  `attributed_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `first_deposit_at` datetime DEFAULT NULL,
  `first_deposit_amount` decimal(18,2) DEFAULT '0.00',
  `first_deposit_tx_id` bigint unsigned DEFAULT NULL,
  `deposit_count` int DEFAULT '0',
  `lifetime_deposits` decimal(18,2) DEFAULT '0.00',
  `lifetime_ngr` decimal(18,2) DEFAULT '0.00',
  `lifetime_commission` decimal(18,2) DEFAULT '0.00',
  `cpa_paid` tinyint(1) DEFAULT '0',
  `status` enum('active','dormant','blocked') DEFAULT 'active',
  `last_active_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_afr_user` (`user_id`),
  KEY `idx_afr_aff` (`affiliate_id`),
  KEY `idx_afr_aff_ftd` (`affiliate_id`,`first_deposit_at`),
  CONSTRAINT `affiliate_referrals_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `affiliates` (`id`) ON DELETE CASCADE,
  CONSTRAINT `affiliate_referrals_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_referrals`
--

LOCK TABLES `affiliate_referrals` WRITE;
/*!40000 ALTER TABLE `affiliate_referrals` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_referrals` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_support_tickets`
--

DROP TABLE IF EXISTS `affiliate_support_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_support_tickets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `affiliate_id` bigint unsigned NOT NULL,
  `subject` varchar(255) NOT NULL,
  `category` enum('payout','commission','tracking','account','api','other') DEFAULT 'other',
  `priority` enum('low','normal','high') DEFAULT 'normal',
  `status` enum('open','in_progress','pending_affiliate','resolved','closed') DEFAULT 'open',
  `assigned_to` bigint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `message` text,
  `message_count` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_ast_aff` (`affiliate_id`),
  KEY `idx_ast_status` (`status`),
  CONSTRAINT `affiliate_support_tickets_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `affiliates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_support_tickets`
--

LOCK TABLES `affiliate_support_tickets` WRITE;
/*!40000 ALTER TABLE `affiliate_support_tickets` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_support_tickets` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliate_ticket_messages`
--

DROP TABLE IF EXISTS `affiliate_ticket_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate_ticket_messages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` bigint unsigned NOT NULL,
  `sender_type` enum('affiliate','staff','system') NOT NULL,
  `sender_id` bigint unsigned DEFAULT NULL,
  `message` text NOT NULL,
  `is_internal` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_atm_ticket` (`ticket_id`),
  CONSTRAINT `affiliate_ticket_messages_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `affiliate_support_tickets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliate_ticket_messages`
--

LOCK TABLES `affiliate_ticket_messages` WRITE;
/*!40000 ALTER TABLE `affiliate_ticket_messages` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliate_ticket_messages` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `affiliates`
--

DROP TABLE IF EXISTS `affiliates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliates` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `company_name` varchar(150) DEFAULT NULL,
  `commission_tier` int DEFAULT '1',
  `tier_label` varchar(20) DEFAULT 'Bronze',
  `commission_type` enum('revenue_share','cpa','hybrid') DEFAULT 'revenue_share',
  `commission_rate` decimal(5,2) DEFAULT '0.00',
  `cpa_amount` decimal(18,2) DEFAULT '0.00',
  `hybrid_cpa_days` int DEFAULT '0',
  `override_rate` decimal(5,2) DEFAULT '0.00',
  `parent_affiliate_id` bigint unsigned DEFAULT NULL,
  `total_referrals` int DEFAULT '0',
  `total_commission` decimal(18,2) DEFAULT '0.00',
  `payout_threshold` decimal(18,2) DEFAULT '0.00',
  `pending_commission` decimal(18,2) DEFAULT '0.00',
  `approved_commission` decimal(18,2) DEFAULT '0.00',
  `paid_commission` decimal(18,2) DEFAULT '0.00',
  `ngr_carry_forward` decimal(18,2) DEFAULT '0.00',
  `is_active` tinyint(1) DEFAULT '1',
  `status` enum('pending','info_requested','approved','rejected','suspended') DEFAULT 'pending',
  `two_factor_enabled` tinyint(1) DEFAULT '0',
  `two_factor_secret` varchar(255) DEFAULT NULL,
  `two_factor_confirmed_at` datetime DEFAULT NULL,
  `kyc_status` enum('none','pending','verified','rejected') DEFAULT 'none',
  `onboarding_complete` tinyint(1) DEFAULT '0',
  `terms_accepted_at` datetime DEFAULT NULL,
  `timezone` varchar(64) DEFAULT 'Asia/Kolkata',
  `currency` varchar(10) DEFAULT 'USD',
  `notification_prefs` json DEFAULT NULL,
  `webhook_url` varchar(500) DEFAULT NULL,
  `traffic_source` varchar(60) DEFAULT NULL,
  `expected_volume` varchar(40) DEFAULT NULL,
  `payment_preference` varchar(40) DEFAULT NULL,
  `application_notes` text,
  `rejection_reason` varchar(500) DEFAULT NULL,
  `applied_at` datetime DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `approved_by` bigint unsigned DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  -- Most recently issued login token id; a newer login invalidates older sessions.
  `active_session_id` varchar(64) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `website` varchar(255) DEFAULT NULL,
  `notes` text,
  `total_payout` decimal(18,2) NOT NULL DEFAULT '0.00',
  `reviewed_by` bigint unsigned DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `onboarding_terms_at` datetime DEFAULT NULL,
  `onboarding_payout_at` datetime DEFAULT NULL,
  `onboarding_kyc_at` datetime DEFAULT NULL,
  `onboarding_complete_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_aff_status` (`status`),
  KEY `idx_aff_parent` (`parent_affiliate_id`),
  KEY `idx_aff_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliates`
--

LOCK TABLES `affiliates` WRITE;
/*!40000 ALTER TABLE `affiliates` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `affiliates` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `agent_audit_logs`
--

DROP TABLE IF EXISTS `agent_audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_audit_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `agent_id` bigint unsigned DEFAULT NULL,
  `actor_id` bigint unsigned DEFAULT NULL,
  `actor_label` varchar(100) DEFAULT NULL,
  `action` varchar(60) NOT NULL,
  `target_type` enum('agent','player','market','settlement','session') DEFAULT NULL,
  `target_id` bigint unsigned DEFAULT NULL,
  `metadata` json DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_aal_agent` (`agent_id`,`created_at`),
  KEY `idx_aal_action` (`action`),
  CONSTRAINT `fk_aal_agent` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_audit_logs`
--

LOCK TABLES `agent_audit_logs` WRITE;
/*!40000 ALTER TABLE `agent_audit_logs` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `agent_audit_logs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `agent_credit_entries`
--

DROP TABLE IF EXISTS `agent_credit_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_credit_entries` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `agent_id` bigint unsigned NOT NULL,
  `kind` enum('credit','debit','settlement') NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `balance_after` decimal(18,2) DEFAULT NULL,
  `note` text,
  `created_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_agent_credit_agent` (`agent_id`),
  KEY `idx_agent_credit_created` (`created_at`),
  CONSTRAINT `agent_credit_entries_ibfk_1` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_credit_entries`
--

LOCK TABLES `agent_credit_entries` WRITE;
/*!40000 ALTER TABLE `agent_credit_entries` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `agent_credit_entries` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `agent_settlements`
--

DROP TABLE IF EXISTS `agent_settlements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_settlements` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `agent_id` bigint unsigned NOT NULL,
  `counterparty_type` enum('agent','player') NOT NULL,
  `counterparty_id` bigint unsigned NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `pl_before` decimal(18,2) DEFAULT '0.00',
  `pl_after` decimal(18,2) DEFAULT '0.00',
  `period_start` date DEFAULT NULL,
  `period_end` date DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `settled_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_as_agent` (`agent_id`,`created_at`),
  KEY `idx_as_counterparty` (`counterparty_type`,`counterparty_id`),
  CONSTRAINT `agent_settlements_ibfk_1` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_settlements`
--

LOCK TABLES `agent_settlements` WRITE;
/*!40000 ALTER TABLE `agent_settlements` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `agent_settlements` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `agent_transfers`
--

DROP TABLE IF EXISTS `agent_transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_transfers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `agent_id` bigint unsigned NOT NULL,
  `counterparty_type` enum('agent','player') NOT NULL,
  `counterparty_id` bigint unsigned NOT NULL,
  `direction` enum('down','up') NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `agent_balance_after` decimal(18,2) DEFAULT NULL,
  `counterparty_balance_after` decimal(18,2) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `performed_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_at_agent` (`agent_id`,`created_at`),
  KEY `idx_at_counterparty` (`counterparty_type`,`counterparty_id`,`created_at`),
  CONSTRAINT `agent_transfers_ibfk_1` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_transfers`
--

LOCK TABLES `agent_transfers` WRITE;
/*!40000 ALTER TABLE `agent_transfers` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `agent_transfers` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `agents`
--

DROP TABLE IF EXISTS `agents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `agents` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `code` varchar(20) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `parent_agent_id` bigint unsigned DEFAULT NULL,
  `level` enum('super_admin','admin','super_master','master','agent') NOT NULL DEFAULT 'agent',
  `depth` int NOT NULL DEFAULT '1',
  `tree_path` varchar(255) DEFAULT NULL,
  `commission_rate` decimal(5,2) DEFAULT '10.00',
  `commission_type` enum('revenue_share','cpa','hybrid') DEFAULT 'revenue_share',
  `credit_reference` decimal(18,2) DEFAULT '0.00',
  `balance` decimal(18,2) DEFAULT '0.00',
  `exposure` decimal(18,2) DEFAULT '0.00',
  `partnership` decimal(5,2) DEFAULT '0.00',
  `total_players` int DEFAULT '0',
  `total_commission` decimal(18,2) DEFAULT '0.00',
  `settled_pl` decimal(18,2) DEFAULT '0.00',
  `unsettled_pl` decimal(18,2) DEFAULT '0.00',
  `pending_commission` decimal(18,2) DEFAULT '0.00',
  `is_active` tinyint(1) DEFAULT '1',
  `status` enum('pending','info_requested','active','approved','rejected','suspended','locked','closed') NOT NULL DEFAULT 'approved',
  `bet_locked` tinyint(1) DEFAULT '0',
  `user_locked` tinyint(1) DEFAULT '0',
  `must_change_password` tinyint(1) DEFAULT '0',
  `timezone` varchar(64) DEFAULT 'Asia/Kolkata',
  `currency` varchar(10) DEFAULT 'USD',
  `contact_email` varchar(255) DEFAULT NULL,
  `contact_phone` varchar(20) DEFAULT NULL,
  `company_name` varchar(150) DEFAULT NULL,
  `market_region` varchar(80) DEFAULT NULL,
  `expected_volume` varchar(40) DEFAULT NULL,
  `experience` varchar(40) DEFAULT NULL,
  `application_notes` text,
  `requested_parent_code` varchar(20) DEFAULT NULL,
  `rejection_reason` varchar(500) DEFAULT NULL,
  `applied_at` datetime DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `approved_by` bigint unsigned DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `last_login_ip` varchar(45) DEFAULT NULL,
  -- Most recently issued login token id; a newer login invalidates older sessions.
  `active_session_id` varchar(64) DEFAULT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `credit_limit` decimal(18,2) NOT NULL DEFAULT '0.00',
  `credit_balance` decimal(18,2) NOT NULL DEFAULT '0.00',
  `notes` text,
  `reviewed_by` bigint unsigned DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_agents_parent` (`parent_agent_id`),
  KEY `idx_agents_path` (`tree_path`),
  KEY `idx_agents_status` (`status`),
  KEY `idx_agents_email` (`contact_email`),
  KEY `idx_agents_requested_parent` (`requested_parent_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agents`
--

LOCK TABLES `agents` WRITE;
/*!40000 ALTER TABLE `agents` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `agents` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ai_call_logs`
--

DROP TABLE IF EXISTS `ai_call_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_call_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `voice_executive_id` varchar(50) DEFAULT NULL,
  `duration_seconds` int DEFAULT NULL,
  `recording_url` varchar(500) DEFAULT NULL,
  `transcript` text,
  `deposit_intent` tinyint(1) DEFAULT '0',
  `deposit_amount` decimal(18,2) DEFAULT NULL,
  `status` enum('completed','failed','escalated') DEFAULT 'completed',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `ai_call_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_call_logs`
--

LOCK TABLES `ai_call_logs` WRITE;
/*!40000 ALTER TABLE `ai_call_logs` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ai_call_logs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `backoffice_group_members`
--

DROP TABLE IF EXISTS `backoffice_group_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `backoffice_group_members` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `group_id` bigint unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_bgm` (`user_id`),
  KEY `fk_bgm_group` (`group_id`),
  CONSTRAINT `fk_bgm_group` FOREIGN KEY (`group_id`) REFERENCES `backoffice_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_bgm_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backoffice_group_members`
--

LOCK TABLES `backoffice_group_members` WRITE;
/*!40000 ALTER TABLE `backoffice_group_members` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `backoffice_group_members` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `backoffice_groups`
--

DROP TABLE IF EXISTS `backoffice_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `backoffice_groups` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `access_level` enum('full','elevated','standard','readonly') NOT NULL DEFAULT 'standard',
  `description` text,
  `permissions` json DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backoffice_groups`
--

LOCK TABLES `backoffice_groups` WRITE;
/*!40000 ALTER TABLE `backoffice_groups` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `backoffice_groups` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `bank_accounts`
--

DROP TABLE IF EXISTS `bank_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_accounts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `account_holder_name` varchar(100) NOT NULL,
  `account_number` varchar(50) NOT NULL,
  `ifsc_code` varchar(20) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `account_type` enum('savings','current') DEFAULT 'savings',
  `upi_id` varchar(100) DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT '0',
  `is_primary` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `bank_accounts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank_accounts`
--

LOCK TABLES `bank_accounts` WRITE;
/*!40000 ALTER TABLE `bank_accounts` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `bank_accounts` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `banners`
--

DROP TABLE IF EXISTS `banners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `banners` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(150) DEFAULT NULL,
  `image_url` varchar(500) NOT NULL,
  `link_url` varchar(500) DEFAULT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `status` enum('draft','active') DEFAULT 'draft',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banners`
--

LOCK TABLES `banners` WRITE;
/*!40000 ALTER TABLE `banners` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `banners` VALUES
(4,'Banner 2','http://api.cadiplay.com/media/uploads/1/e5c0bc8908b845cdb4cc849cc71045d7.jpeg',NULL,0,'active','2026-09-23 18:26:10','2026-09-23 19:00:26'),
(5,NULL,'http://api.cadiplay.com/media/uploads/1/1d2f1a5d85da4c99b32bc1095adb367b.jpeg',NULL,0,'active','2026-09-23 19:00:40','2026-09-23 19:00:40');

/*!40000 ALTER TABLE `banners` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `bets`
--

DROP TABLE IF EXISTS `bets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `game_id` bigint unsigned DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `bet_amount` decimal(18,2) NOT NULL,
  `odds` decimal(10,4) DEFAULT NULL,
  `multiplier` decimal(10,4) DEFAULT NULL,
  `payout` decimal(18,2) DEFAULT '0.00',
  `profit_loss` decimal(18,2) DEFAULT '0.00',
  `status` enum('open','won','lost','void','cancelled','cashout') DEFAULT 'open',
  `round_id` varchar(100) DEFAULT NULL,
  `provably_fair_seed` varchar(255) DEFAULT NULL,
  `provably_fair_hash` varchar(255) DEFAULT NULL,
  `metadata` json DEFAULT NULL,
  `settled_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `game_id` (`game_id`),
  KEY `idx_bets_user` (`user_id`),
  KEY `idx_bets_status` (`status`),
  CONSTRAINT `bets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `bets_ibfk_2` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bets`
--

LOCK TABLES `bets` WRITE;
/*!40000 ALTER TABLE `bets` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `bets` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `blocked_cards`
--

DROP TABLE IF EXISTS `blocked_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `blocked_cards` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `card_mask` varchar(30) NOT NULL,
  `card_holder` varchar(100) DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `reason` varchar(150) DEFAULT NULL,
  `attempts` int NOT NULL DEFAULT '0',
  `blocked_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_bc_user` (`user_id`),
  KEY `idx_bc_mask` (`card_mask`),
  CONSTRAINT `fk_bc_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blocked_cards`
--

LOCK TABLES `blocked_cards` WRITE;
/*!40000 ALTER TABLE `blocked_cards` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `blocked_cards` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `blocked_ips`
--

DROP TABLE IF EXISTS `blocked_ips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `blocked_ips` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(45) NOT NULL,
  `status` enum('block','allow') NOT NULL DEFAULT 'block',
  `reason` varchar(100) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `blocked_by` bigint unsigned DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `is_permanent` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_blocked_ip` (`ip_address`),
  KEY `idx_blocked_ips_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blocked_ips`
--

LOCK TABLES `blocked_ips` WRITE;
/*!40000 ALTER TABLE `blocked_ips` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `blocked_ips` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `bonus_excluded_affiliates`
--

DROP TABLE IF EXISTS `bonus_excluded_affiliates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bonus_excluded_affiliates` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `bonus_id` bigint unsigned NOT NULL,
  `affiliate_id` bigint unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_bea` (`bonus_id`,`affiliate_id`),
  KEY `idx_bea_affiliate` (`affiliate_id`),
  CONSTRAINT `bonus_excluded_affiliates_ibfk_1` FOREIGN KEY (`bonus_id`) REFERENCES `bonuses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bonus_excluded_affiliates`
--

LOCK TABLES `bonus_excluded_affiliates` WRITE;
/*!40000 ALTER TABLE `bonus_excluded_affiliates` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `bonus_excluded_affiliates` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `bonus_providers`
--

DROP TABLE IF EXISTS `bonus_providers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bonus_providers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `bonus_id` bigint unsigned NOT NULL,
  `provider_id` bigint unsigned NOT NULL,
  `wagering_multiplier` decimal(6,2) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_bonus_providers` (`bonus_id`,`provider_id`),
  KEY `provider_id` (`provider_id`),
  CONSTRAINT `bonus_providers_ibfk_1` FOREIGN KEY (`bonus_id`) REFERENCES `bonuses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `bonus_providers_ibfk_2` FOREIGN KEY (`provider_id`) REFERENCES `game_providers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bonus_providers`
--

LOCK TABLES `bonus_providers` WRITE;
/*!40000 ALTER TABLE `bonus_providers` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `bonus_providers` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `bonus_translations`
--

DROP TABLE IF EXISTS `bonus_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bonus_translations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `bonus_id` bigint unsigned NOT NULL,
  `language` varchar(10) NOT NULL DEFAULT 'en',
  `title` varchar(150) DEFAULT NULL,
  `description` text,
  `image_url` varchar(500) DEFAULT NULL,
  `terms_conditions` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_bt` (`bonus_id`,`language`),
  CONSTRAINT `bonus_translations_ibfk_1` FOREIGN KEY (`bonus_id`) REFERENCES `bonuses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bonus_translations`
--

LOCK TABLES `bonus_translations` WRITE;
/*!40000 ALTER TABLE `bonus_translations` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `bonus_translations` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `bonuses`
--

DROP TABLE IF EXISTS `bonuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bonuses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `display_title` varchar(150) DEFAULT NULL,
  `description` text,
  `bonus_type` enum('joining','deposit','referral','game','cashback','no_deposit','free_spins','loyalty','reload','manual') NOT NULL,
  `priority` int DEFAULT '0',
  `value_type` enum('percentage','fixed') NOT NULL,
  `value_amount` decimal(18,2) NOT NULL,
  `redemption_type` varchar(40) DEFAULT NULL,
  `redemption_amount` decimal(18,2) DEFAULT NULL,
  `max_redeemable_value` decimal(18,2) DEFAULT NULL,
  `payment_methods` varchar(255) DEFAULT NULL,
  `min_deposit` decimal(18,2) DEFAULT '0.00',
  `is_first_deposit` tinyint(1) DEFAULT '0',
  `is_second_deposit` tinyint(1) DEFAULT '0',
  `is_third_deposit` tinyint(1) DEFAULT '0',
  `is_new_player_only` tinyint(1) DEFAULT '0',
  `new_player_days` int DEFAULT '7',
  `max_bonus_cap` decimal(18,2) DEFAULT NULL,
  `referrer_reward` decimal(18,2) DEFAULT '0.00',
  `wagering_multiplier` decimal(5,2) DEFAULT '35.00',
  `credit_target` enum('bonus','main') DEFAULT 'bonus',
  `status` enum('draft','active','paused','expired') DEFAULT 'draft',
  `is_published` tinyint(1) DEFAULT '0',
  `is_public` tinyint(1) DEFAULT '0',
  `affiliate_id` bigint unsigned DEFAULT NULL,
  `parent_bonus_id` bigint unsigned DEFAULT NULL,
  `comment` text,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `claim_method` enum('auto','manual','code','opt_in') DEFAULT 'auto',
  `scope` enum('mass','targeted') DEFAULT 'mass',
  `target_user_id` bigint unsigned DEFAULT NULL,
  `promo_code` varchar(40) DEFAULT NULL,
  `coupon_length` int DEFAULT NULL,
  `per_user_limit` int DEFAULT NULL,
  `total_budget` decimal(18,2) DEFAULT NULL,
  `total_awarded` decimal(18,2) DEFAULT '0.00',
  `total_claims` int DEFAULT '0',
  `bonus_validity_days` int DEFAULT '30',
  `claim_min_balance` decimal(18,2) DEFAULT NULL,
  `claim_min_wagering` decimal(18,2) DEFAULT NULL,
  `claim_min_deposit_total` decimal(18,2) DEFAULT NULL,
  `abuse_similarity_percent` int DEFAULT NULL,
  `abuse_deposited_days` int DEFAULT NULL,
  `abuse_played_days` int DEFAULT NULL,
  `allowed_countries` json DEFAULT NULL,
  `excluded_countries` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_bonuses_promo_code` (`promo_code`),
  KEY `idx_bonuses_type_status` (`bonus_type`,`status`),
  KEY `idx_bonuses_affiliate` (`affiliate_id`),
  KEY `idx_bonuses_parent` (`parent_bonus_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bonuses`
--

LOCK TABLES `bonuses` WRITE;
/*!40000 ALTER TABLE `bonuses` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `bonuses` VALUES
(2,'welcome100_copy','Welcome Bonus USDT 100',NULL,'no_deposit',0,'fixed',100.00,NULL,NULL,NULL,NULL,0.00,0,0,0,0,7,100.00,0.00,35.00,'bonus','paused',0,0,NULL,NULL,NULL,'2026-06-26 06:58:40','2027-06-26 06:58:40','auto','mass',NULL,NULL,NULL,NULL,NULL,0.00,0,30,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-16 12:19:18','2026-07-18 09:47:14');

/*!40000 ALTER TABLE `bonuses` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `cashier_queue_items`
--

DROP TABLE IF EXISTS `cashier_queue_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cashier_queue_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue_type` enum('decline','profile_upgrade') NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `transaction_id` bigint unsigned DEFAULT NULL,
  `amount` decimal(18,2) DEFAULT NULL,
  `currency` varchar(10) DEFAULT 'USD',
  `reason` varchar(255) DEFAULT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `assigned_to` bigint unsigned DEFAULT NULL,
  `resolved_by` bigint unsigned DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `notes` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_cqi_type_status` (`queue_type`,`status`),
  KEY `idx_cqi_user` (`user_id`),
  CONSTRAINT `cashier_queue_items_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cashier_queue_items`
--

LOCK TABLES `cashier_queue_items` WRITE;
/*!40000 ALTER TABLE `cashier_queue_items` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `cashier_queue_items` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `decline_queue`
--

DROP TABLE IF EXISTS `decline_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `decline_queue` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `transaction_id` bigint unsigned DEFAULT NULL,
  `user_id` bigint unsigned NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `method_id` bigint unsigned DEFAULT NULL,
  `provider_id` bigint unsigned DEFAULT NULL,
  `decline_reason` varchar(255) DEFAULT NULL,
  `attempts` int NOT NULL DEFAULT '1',
  `status` enum('pending','retried','approved','rejected') NOT NULL DEFAULT 'pending',
  `reviewed_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_dq_user` (`user_id`),
  KEY `idx_dq_status` (`status`),
  CONSTRAINT `fk_dq_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `decline_queue`
--

LOCK TABLES `decline_queue` WRITE;
/*!40000 ALTER TABLE `decline_queue` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `decline_queue` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `faqs`
--

DROP TABLE IF EXISTS `faqs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `faqs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `question` varchar(300) NOT NULL,
  `answer` text NOT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `status` enum('draft','active') DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faqs`
--

LOCK TABLES `faqs` WRITE;
/*!40000 ALTER TABLE `faqs` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `faqs` VALUES
(1,'Why is this one of the best betting sites in India?','A trusted, licensed platform built around fast payouts, fair games and 24/7 human support — without the clutter of typical betting sites.',0,'active','2026-09-04 15:02:40','2026-09-04 15:02:40'),
(2,'Is online betting legal in India?','There are no federal laws explicitly prohibiting online betting across most of India. We recommend checking your local state regulations.',1,'active','2026-09-04 15:02:40','2026-09-04 15:02:40'),
(3,'How do I withdraw my winnings?','Withdraw instantly to UPI or your bank account. Most cash-outs complete in under five minutes after a quick verification.',2,'active','2026-09-04 15:02:40','2026-09-04 15:02:40'),
(4,'Can I actually win in an online casino?','Yes. Every game uses certified RNG and published RTP so outcomes are genuinely random and verifiable.',3,'active','2026-09-04 15:02:40','2026-09-04 15:02:40'),
(5,'Are casino games skill or luck?','It depends. Slots and crash games are luck-based, while Poker and Blackjack reward skill and strategy.',4,'active','2026-09-04 15:02:40','2026-09-04 15:02:40');

/*!40000 ALTER TABLE `faqs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `frontend_config_rules`
--

DROP TABLE IF EXISTS `frontend_config_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `frontend_config_rules` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `country_code` char(2) DEFAULT NULL,
  `currency_code` varchar(10) DEFAULT NULL,
  `player_group` varchar(50) DEFAULT 'all',
  `method_ids` json DEFAULT NULL,
  `priority` int NOT NULL DEFAULT '100',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `frontend_config_rules`
--

LOCK TABLES `frontend_config_rules` WRITE;
/*!40000 ALTER TABLE `frontend_config_rules` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `frontend_config_rules` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `frontend_payment_methods`
--

DROP TABLE IF EXISTS `frontend_payment_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `frontend_payment_methods` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `method_id` bigint unsigned DEFAULT NULL,
  `display_name` varchar(100) NOT NULL,
  `country_code` char(2) DEFAULT NULL,
  `currency_code` varchar(10) DEFAULT NULL,
  `player_group` varchar(50) DEFAULT 'all',
  `sort_order` int NOT NULL DEFAULT '0',
  `icon_url` varchar(500) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_fpm_method` (`method_id`),
  CONSTRAINT `fk_fpm_method` FOREIGN KEY (`method_id`) REFERENCES `payment_methods` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `frontend_payment_methods`
--

LOCK TABLES `frontend_payment_methods` WRITE;
/*!40000 ALTER TABLE `frontend_payment_methods` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `frontend_payment_methods` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `game_callback_logs`
--

DROP TABLE IF EXISTS `game_callback_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_callback_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `serial_number` varchar(100) DEFAULT NULL,
  `member_account` varchar(100) DEFAULT NULL,
  `game_uid` varchar(64) DEFAULT NULL,
  `raw_payload` text,
  `decrypted_payload` json DEFAULT NULL,
  `result` enum('settled','duplicate','heartbeat','error','rejected') NOT NULL,
  `message` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_gcl_serial` (`serial_number`),
  KEY `idx_gcl_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_callback_logs`
--

LOCK TABLES `game_callback_logs` WRITE;
/*!40000 ALTER TABLE `game_callback_logs` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `game_callback_logs` VALUES
(1,'1c9619c6-d3e1-3245-ac36-f354900c02cb','h72add7','92b24e4c25107367a80e0fe1a97c24e4','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"d2GLi8JB4LlCcrv8/BNvBgJ3+eQGPWqaJOp1lNtpIXbU9Wk1VoU9F4UnsCRgo1nGEG3/xPKQ9K+gxhgd4MzH9bxxcxKLDtHzgV5HSijmYHMQBev19HQHHXVDP+8T0W97/1v0YkOsm5uptBjXty4ezV2ICmRQ+M1MYGYa56w81oIyd0MY7zLBTeBzpZhdqSUYwWWxNrePvXefnhZWcYnzB4N0asa8jHt3hPHeU4mjKdqtvlcyg86i4xx4e5wzXP6/JLfwkej7wjywoiEV3LahdFK6ZZ+Y79P/hzVyeGUt0oKwH16TNyE3pg9Xwk8g+Nto+SOe75NK56CcDZYCw2xlOcBAPbZFdSzIjkI7d/fyUw2J5sodDXg584mesWNUAg1bKahLhuIM5bJJevFd3f/XRwrCggHKQoddxoooVgocOanaFaY20LXwWzuMHU8XfB6qREZlXrrjFUJ/M1MIhYzNTyQY0u1dFEdl5rw7fey5Tqa2tlcM5CekrG1G5dP6w2WhbpL39QQ6jTd93+GIwF+ekKjbh++Bmv/l+RbtUZtL94LQGUXUTTKWTHcRNOnkDmUCcUKhmdkiivGRT4Z+nqZG/xwr4RAxOJlw985u4LH+G62slP1MHp+AkC1qedPjQcwfrNT1+dftBER43ludZPU6yrFNXnVq3SFN5wKX0heQG8wEbD98sWYbRQZJl8WOj2QpuCi56QgjJTzvk98x55H83w+4RGrR0bDOq1El1lF3EP1ljfiIKedfXzXAEm/qqL4w2xRVVSoCbIgJRoKtwrAOsu0t6ciCb6BZhk3XqAK+AFRsZQMW6Lo5VvM9H4d3Gdg8Ew0USciL1JFDmk46QH8wKqon2Pbqfk6aTDzm6Sw8dOqQu0IXl/c0qYZ5JUTV/e45x1eMua/rNiCvTnzOZf2PFWhrM51W75OzpaUEpjoLMQXCudflnRzzTIuoWKW0F6IL5K3u/Q+35RKVrx3oZVbjGwcUCbiJ0Xd2PaquA2QKcGV/u4Ca4DIOoBRAvs2o8xpjIksxiYoYvih3Cfk+zypLOrmkGt/XoVtKtukQd7uyfhy4/EI9nmmcQHbeie4iHraEWgas+cCYzPOZciMSv4XVS5rk9na9fREncCYKvZaemhsy9+wyf4V9fXqMRKGWTXYfLAyjWjfXKfcmUNo4WEmfz4ANz4IPkt378qZ18c0pSprmPvuWPPidmVJ1Svd1ZVwbDKKjhbzAwvL46jr+dpByTpJ1u2TOWi/VszNfSZXC7dYK/eo2U9ih6fAAT28JOawUNrtPGe+D9hjNEWadVd5sQPuFxOL/s7iLHVaGv1SBaW2qXUeHF2WMg6++xw4QjdcGZ3mDzna2dSKsNxa2128HArRvByVjwYiHrOl6DTlwpRxJUFXEc8QqBR2buKI6gm3h4+wmUHHfO22k60SExjH5LU4FiFsnNIwnn8xesHkdEIc0aiPgcq3oqVke21zjvUl439Huei+zfKWuzwQzIGPOU1XBigLOQjwdX0h55YkWpOFtSJqNR1jDbuUkHs3bAf4fr6AuPxp1M36sFTpjP5s3odw1LuBnbsOUnP3NyPyifjIgIIA6zN+zEyIYAyxyhBtIdx4/xZkzot05LFRp7p5Dj3UTK+i3VN3SAXVKX4H+xhn5iQ7BYhs86zGLlALDjt6iVl0lM47pWxCc44nG1W2Geg1jr4aw+wWvDgtVK+77MXuo01gGG4uaKxjCoDyH+dUPFY5WoJ6yIaLFfsnhKMDuW5F6ECYJ+spsvlas8QvANIe+c14G4jUWK+zv8s93ID+fAKHyX3Z3qpxI5hakH8QyMfvotfVGnC7CUD0Qy3s5+KUV0TwNZS9OPnnbZ+8EF7jeb/JpFi+3SWerpQMZCzxTdN4VQW7wGCzpJLhQbiYNaq/n8+UXwzbFAKgICA5pkCBhWSUrWqGvubcSTkuK1kHwyta4uBYd6KzrAWdK2X/bGKh/pdw3jIphGEGALHfciqYj4fkYuJ4tnWTFPjawZMzcNCyISM9vb4JYYJwlMTBuR4vgetG6OjweAy9ogsN+k0rS4Se8GWcXQhX2Qwqih5Wy6p85qpld+NQ7qsR9L0ppPzA5ZMeBUdtjzZN/kIlMO5PdQx9WR6McyPdZ7rxXBkYMCvhCiCr3SbPYGUTk+1KTFEQxv6ZxpNKJjRt/dazWENOvo/dT3Qz3sdY0buzvECyJrvxgiDUc0/GF7hSQfUTcx10Ippm8Ygb28kJMcF06xCVYQqeu3Ny+mAD0tamWOgfEydyQ7XKI+dHpVnY76EFKf0A=\",\"timestamp\":\"1790081318496\"}','{\"data\": \"{\\\"betslip\\\":{\\\"bets\\\":[{\\\"backlay\\\":\\\"l\\\",\\\"category_id\\\":\\\"sr:category:105\\\",\\\"category_name\\\":\\\"International\\\",\\\"competitor_name\\\":[\\\"India A\\\",\\\"Australia A\\\"],\\\"event_id\\\":\\\"74559842-e\\\",\\\"id\\\":\\\"f24168173\\\",\\\"line\\\":2,\\\"live\\\":true,\\\"market_id\\\":\\\"356_202764401_f\\\",\\\"market_name\\\":\\\"1st inn 90 over INA run(INA vs AUS)adv\\\",\\\"odds\\\":\\\"110\\\",\\\"outcome_name\\\":\\\"\\\",\\\"scheduled\\\":\\\"2026-09-22T04:00:00Z\\\",\\\"sport_id\\\":\\\"4\\\",\\\"sport_name\\\":\\\"Cricket\\\",\\\"tournament_id\\\":\\\"sr:tournament:47980\\\",\\\"tournament_name\\\":\\\"First Class Series India A vs Australia A\\\"}],\\\"currency\\\":\\\"INR\\\",\\\"ext_player_id\\\":\\\"h72add7\\\",\\\"id\\\":\\\"74559842-e@356_202764401_f@1c2e9637-27e3-4923-81ef-22f4b3a186eb\\\",\\\"is_quick_bet\\\":false,\\\"k\\\":\\\"110\\\",\\\"operator_brand_id\\\":\\\"cmt-hd-sub-91r2c4\\\",\\\"operator_id\\\":\\\"cmt-hd-sub-91r2c4\\\",\\\"player_id\\\":\\\"1c2e9637-27e3-4923-81ef-22f4b3a186eb\\\",\\\"sum\\\":1000,\\\"timestamp\\\":0,\\\"type\\\":\\\"[1]\\\"},\\\"bonus_id\\\":\\\"\\\",\\\"bonus_type\\\":\\\"\\\",\\\"potential_win\\\":0,\\\"token\\\":\\\"testToken\\\",\\\"transaction\\\":{\\\"amount\\\":110000,\\\"betslip_id\\\":\\\"74559842-e@356_202764401_f@1c2e9637-27e3-4923-81ef-22f4b3a186eb\\\",\\\"bonus_id\\\":\\\"\\\",\\\"currency\\\":\\\"INR\\\",\\\"ext_player_id\\\":\\\"h72add7\\\",\\\"id\\\":\\\"0ce6d148-59c9-4bfc-b565-4d46b84da898\\\",\\\"operation\\\":\\\"place_exchange_order\\\",\\\"operator_brand_id\\\":\\\"cmt-hd-sub-91r2c4\\\",\\\"operator_id\\\":\\\"cmt-hd-sub-91r2c4\\\",\\\"player_id\\\":\\\"1c2e9637-27e3-4923-81ef-22f4b3a186eb\\\",\\\"timestamp\\\":1790081318426}}\", \"game_uid\": \"92b24e4c25107367a80e0fe1a97c24e4\", \"timestamp\": \"2026-09-22 12:48:38\", \"bet_amount\": \"1100\", \"game_round\": \"7638492209151163792\", \"win_amount\": \"0\", \"currency_code\": \"INR\", \"serial_number\": \"1c9619c6-d3e1-3245-ac36-f354900c02cb\", \"member_account\": \"h72add7\"}','settled','bet=1100 win=0 bal=48900.00','2026-09-22 12:48:39'),
(2,'2fbdf3fb-9b21-3bde-9bd8-38b5e8516356','h72add7','92b24e4c25107367a80e0fe1a97c24e4','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"d2GLi8JB4LlCcrv8/BNvBgJ3+eQGPWqaJOp1lNtpIXbU9Wk1VoU9F4UnsCRgo1nGa7jj5lSJ12OzTYgTpv9l6U7jioTXgDQvVDkecJHLtUANZvfVyS8rVzwKa+rtALTzna61wwJzRa/GS6XPRcjsBNJd8riaGdJiupHBKWENg3nkcR4gBMRY7mddRm33FawnuIzvkJKhwMIqlBwnlo14ZxT0tYQRXgOR3uTtRvUGp1zgTdpEJBtmT28ZmwqrfINhl8QU+g8/1vTU2SbLSJqT494S5kXLIJDnwMhkGikdmzYI3BggWoGHxYPVyVP3I0dbjdT2VPA4SnGQ2pMgVZDUj3FB3aUCcjkv0qjfK0LWBxAGl+SCnetYav6kTU/sjltyUwUgeVJVIJq5N7Uva/geAP05yui0aonSzFoQIx/VvP0BbcZ8nt+gdR8tHPxh6Wu61M5wRSsgG4Lgu/lKbg0RfqvIc8n55uW8Znbtq7fSYvj2/u5pOxHzhHMaMNMsunJaf0n7Bw9rFC0xMzjc80Ts/bzGdixsHFL9Gb+ir2YXzITrqkdP6hLbkSeSJWyRWZpRyqZGLgi+2JsxbHvk4MpqcFvzNR0Xv+6y27OlB8ucJ2ViwwSCjGvYdGTUOzm99yP52JbvKkRcfyL5K/GnXZCRAlSIfbRNeNsilO58IdzSSPE83LR71HqldfVjPRWsCdbtAc8G6XYD+4GbyUs1su65oaWrGJc8GZOYBOAoeST2jsHB2vt2/1cH0wdOENzLYzfgd3AZIHGHkYwNrcOUBh/83CDOOhT2SlkKIi95BOJKFDeYnVa7MsrkoMXvixLUf/51UESHzIPB1dL8QAM0BmHD+eHMxhaRqE74H1JM4+rImri8RdzbKeWbyOIg5ae2QnC/PZUz5baFhve6GKT2aDQ9zc9OmirN50DAMsbbponmG/srsI1KA3c6AQdY9+EIWnsC1tObKHQdo2rbMY3OhxMV78+BJpUw6UchYIg98+uXNZe8EhqyUCSa82Qk7Gw8R9ym2JbvKkRcfyL5K/GnXZCRAlSIfbRNeNsilO58IdzSSPHk4XGp4gjwhGa8CEp4ay3KAELkTbDtlo5M68s7HGARi5TEk5NPKWbq00A2/cGZvn3vD6XAAR7fcBwNo/Ir/qry9Ma0d7yDAIFh4tMHN1H1F217wtOxx/8Yuz3VwymGGiop6/8DvWFVgD0PR9HzyPLMeisErXJdEYpWj/DpIdN4BHNDuGXEjojdzgd6kDdx6X1+gnFb6Y7EDOzfvx6zOBmflOc5MxWxcbYVvBU1lwYMPPlHXBfhSwXq660i/YnZBORFN6qKlX/IkZeeTJKN7NtrSaB/m3PngxZVtAtKUi/XkPQwSYBCe7IDcXO2veONNAjk8M683yK+3WElZP/xXha0\",\"timestamp\":\"1790136632372\"}','{\"data\": \"{\\\"bet_slip_settle\\\":{\\\"bet_slip_id\\\":\\\"74559842-e@356_202764401_f@1c2e9637-27e3-4923-81ef-22f4b3a186eb\\\",\\\"commission\\\":\\\"0\\\",\\\"trade_profit\\\":\\\"1000\\\"},\\\"selections\\\":[{\\\"bet_id\\\":\\\"f24168173\\\",\\\"betslip_id\\\":\\\"74559842-e@356_202764401_f@1c2e9637-27e3-4923-81ef-22f4b3a186eb\\\",\\\"profit\\\":\\\"1000\\\",\\\"status\\\":\\\"win\\\"}],\\\"token\\\":\\\"testToken\\\",\\\"transaction\\\":{\\\"amount\\\":-210000,\\\"betslip_id\\\":\\\"74559842-e@356_202764401_f@1c2e9637-27e3-4923-81ef-22f4b3a186eb\\\",\\\"bonus_id\\\":\\\"\\\",\\\"currency\\\":\\\"INR\\\",\\\"ext_player_id\\\":\\\"h72add7\\\",\\\"id\\\":\\\"a66689d0-2bcb-4a9b-b500-34187358fac1\\\",\\\"operation\\\":\\\"exchange_payout\\\",\\\"operator_brand_id\\\":\\\"cmt-hd-sub-91r2c4\\\",\\\"operator_id\\\":\\\"cmt-hd-sub-91r2c4\\\",\\\"player_id\\\":\\\"1c2e9637-27e3-4923-81ef-22f4b3a186eb\\\",\\\"timestamp\\\":1790136632093}}\", \"game_uid\": \"92b24e4c25107367a80e0fe1a97c24e4\", \"timestamp\": \"2026-09-23 04:10:32\", \"bet_amount\": \"0\", \"game_round\": \"7638492209151163792\", \"win_amount\": \"2100\", \"currency_code\": \"INR\", \"serial_number\": \"2fbdf3fb-9b21-3bde-9bd8-38b5e8516356\", \"member_account\": \"h72add7\"}','settled','bet=0 win=2100 bal=51000.00','2026-09-23 04:10:34'),
(3,'834d664c-69f7-3bad-ac23-46451103a79a','h72add9','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78IOB4/bSM8r93ls0CNi3WcL4neTX8gysY0SW3OdyO/YwnRNVHJA3KtuC0AFiftEUOAC3AtqgRLWkl58LSJa77ba2VeZtvRqMoe14oQQh8Px4Vxj46z84zAaNxpv9DyXWwdCrF4jHgZaRqWW+HFJedaeE2iqcw253KRv/6t88acIm3+zGhODMQottmSPB+HJeXywyzBjRTjQNXi+mUNkBfuLVVWcyd/w68P7dX0sYx7EYYh0Qv2HYbIYlNxjQJbOalM2sjU4aqrRd1hDMCUDBA2IW5Z4dswvcehG62AjSuEsPQfzOFzB16EkfSOs1iS+v/+Xlis+DEX/ftDdDgUDDOl8kwOTvqhvN95BVjG2C8YEiB2ZBfdxJFwq1f0KvXH1yiJndp8bVlmIln7AFqzUmWuJlML8qEj4oVACLEY6sNriAwRtUp9GLI0PgPmrTMfL+YqoDBNf2ipW+4z4bwFflj5gsdh/PcA76a+PqRSqJMogqVWccP6vq8dQvjvHspMvVsKaF0F8e7yYKpLHwMy21qg+OgZh/IhvzVciUg5LqUJT7pV+UyGTVJQS8p9oiboZ+UQmzTSQr7dls1KJmV8eS/89YXiOudBGztKi1GW2NRCC7qcPW8zf2iKr2derCluOmCFg/FdHCFLvMG4QpeEN5+3NkkGgqT9mJ7DbizGj7vXe0YnjKmTp6cxtdtloMbr+5nxq/VrcZO2LXDYbW49geBzUSdrVqoBEVZu7SzEWQ6wOJutMZJh6Mlz8a6sUdfFuGXrgQAJ4Dt6mCMzTioBz8vEjS7zH0uCq+Mz3QCXtsaVjbArWjQ83Qpto/IKuTsfGiIMsllKFexvsr67ZRiTfxdt3cNRxwOjV6c/dtc6lt5IVTGfrtHo02+z4PEB9sDHLNcH7071b0hXfnjy0eQbkZQGtESMrkmw4PczzvoscJf+quz3KY+eGoQLav2QVPcuTrGNe0oYrb1f2wI9QpR9o7Q8OSIRfYNRwhNNw+S8y6Bbk+C6SwWNaOTthLEXXoEtU5DzEA0ObF+cvzoGDjeycu2dBBBabSQt/N3+FyZQNhluxlpvABQeZme4ZRd+VzEXkI8MbPhtA3nrY0tyFkhjvgKYsU8lKOWkOfvY8cfqHAPIPelv7QUKP0QOY8yNZvN7y/BNGQEvm4CsdjFfoedtsRX2g6gAIGNxPgHuNr2boRTYHC46DWtO3Qx8h1zkRhhqt9mdUHYB+VQoTY1PJ2PB+Tt1DdvDRdzylpQCfyToPusLRU0vF+DQCLf30NbPueGkYO/zcQDDKK9S1/se/OeGPC2Hjcv4y8BfZGVigWGLNcxKLEMmTlpy1ARVA/2XiAWqHzM6Im6bSfEmhI92fsVRS2es/Raf5iaX29BWK7tobrWajY5PP4lPb0+aNDQjWgkY7ALBdjyIGE870L5n6xB/2vmiLxPOyTo8CH0GRc8iZcT0P7cI004Dv5NrB/acLWhBOaTVMpsn5l+eMAQhsxSsoRuo5XGMJ7N/eGXRcN+Fp7TBjzCcGYu0lE8ffHfrNuUhlEucZOv4439XHty6oFXnpdkK8s8yuXkb7dcrwOeXNxL0QCmIocKD2SRYSUb912QD4H3e6lNrzbF84D4CyBJpqy99adakmZDSR+MlahUg4FoGiqgeOJseV2vPLk6hLGDGIhzSIc7Sn5SUPXIKDiQr1wh4hQ+ZN/Gnbqoyq2jJ78Bjpxf4ULxrL2AxXY0PAnIY1DAwXd2YWYDspMLkQjR2OWhkgqucccZQzhybu8RyNfcomGAo2/Dj3QluSOfREy8ywmHOzpBs/+x/VN9SDB25oKj77dyU7lt2WaQJx6hZPEC82B3oP3JD/yIWVv1SSdZvpA0O+63b1SHpoOTONzkCoaKkq9+z7kuHKVnvQU92gNcWNulC52NZLrBD+Pav00y7/w1\",\"timestamp\":\"1790408694156\"}','{\"data\": \"{\\\"sportTypeName_en\\\":\\\"Soccer\\\",\\\"sportTypeName\\\":\\\"Soccer\\\",\\\"oddsId\\\":1072669235,\\\"betTypeName\\\":\\\"Over/Under\\\",\\\"homeName\\\":\\\"Nara Club \\\",\\\"betTeam\\\":\\\"h\\\",\\\"betTypeName_en\\\":\\\"Over/Under\\\",\\\"oddsType\\\":2,\\\"betChoice\\\":\\\"Over\\\",\\\"awayName_en\\\":\\\"Reilac Shiga FC\\\",\\\"tsId\\\":\\\"\\\",\\\"point\\\":\\\"4.50\\\",\\\"point2\\\":\\\"\\\",\\\"leagueName\\\":\\\"JAPAN J-LEAGUE DIVISION 3\\\",\\\"isLive\\\":true,\\\"awayScore\\\":0,\\\"leagueId\\\":36041,\\\"odds\\\":1.66,\\\"excluding\\\":\\\"\\\",\\\"action\\\":\\\"PlaceBet\\\",\\\"operationId\\\":\\\"4247600_1_81511831\\\",\\\"currency\\\":61,\\\"betFrom\\\":\\\"W001\\\",\\\"kickOffTime\\\":\\\"2026-09-26T01:59:00.000-04:00\\\",\\\"homeId\\\":68314,\\\"matchId\\\":134430001,\\\"oddsInfo\\\":\\\"\\\",\\\"homeScore\\\":4,\\\"matchDateTime\\\":\\\"2026-09-26T02:00:00.000-04:00\\\",\\\"leagueName_en\\\":\\\"JAPAN J-LEAGUE DIVISION 3\\\",\\\"sportType\\\":1,\\\"actualAmount\\\":100.0,\\\"IP\\\":\\\"86.96.106.82\\\",\\\"homeName_en\\\":\\\"Nara Club \\\",\\\"awayId\\\":957834,\\\"updateTime\\\":\\\"2026-09-26T03:44:53.664-04:00\\\",\\\"debitAmount\\\":100.0,\\\"userId\\\":\\\"huidubet_h72add9\\\",\\\"betType\\\":3,\\\"awayName\\\":\\\"Reilac Shiga FC\\\",\\\"betAmount\\\":100.0,\\\"baStatus\\\":false,\\\"betTime\\\":\\\"2026-09-26T03:44:53.664-04:00\\\",\\\"betRemark\\\":\\\"\\\",\\\"refId\\\":\\\"4247600_27403383\\\",\\\"creditAmount\\\":0.0,\\\"betChoice_en\\\":\\\"Over\\\"}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-09-26 07:44:54\", \"bet_amount\": \"100.0\", \"game_round\": \"12289102292563017319\", \"win_amount\": \"0\", \"currency_code\": \"INR\", \"serial_number\": \"834d664c-69f7-3bad-ac23-46451103a79a\", \"member_account\": \"h72add9\"}','settled','bet=100.0 win=0 bal=49900.00','2026-09-26 07:44:54'),
(4,'c9196129-2be7-3b2b-a4f9-5e6c8e71a06d','h72add9','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78Z54l2le1+4xossJ8ftsMpTFTBM/Blzi55cHhiCzbzMjiQOwucaSd9GVqTvxm6uUcP0L5QKeaSCRoilalVwv+fbmhahY1WQ0n+wrbNOSl60u46DWtO3Qx8h1zkRhhqt9m6I7kMLjkuEqCg5AYHBNuHRqj8ANbDqauTE38/RblQ+VEvO4J9TeELnbBiw9jC6xNBxfVdBQDoYnRXAKZki0y4nG4jMq8y7XufrHmawfB3SDNxAMMor1LX+x7854Y8LYeNy/jLwF9kZWKBYYs1zEosZPoQuyRAwgrmEBQ+0Gse9jStDCEUEq18rLpW40lWqir4NyKkB8GjNfR2lDRT/8IwkysT3xify5YT06l+6JkVhf0tDmuwWXWphL0FnlfHJuBHqazl2X7K5q/FIHh5HM5lBh/egp0XmZoJzlbk4HAru1QhJeJaAzv9KgOKn7KKxLJdD5cpokerEeDCJOIC3OqfdwjTTgO/k2sH9pwtaEE5pOfjjVYx/ohnPoUubXQ4FcwjnnOVBDVvKlS120XwYOS895JkAl5cyKFKiD6YYBltSbBXouJFDmCMCp1nZwwXC67CeNq3hJTLlKUQlIetUEto8ZA8QfrisNPPr3STM+Ku2Wt5/7O5icmZzM680rnHDFbjxZlzXfoDcjq9tTIWDvtlt00TACe+k39DslIZ+h3eXmg79/s0yIngnoPg7L1teCkxsZqeuH4EJAwyW9LPwDu363NYPc4kNGIAE4/CJuM9lpf4ULxrL2AxXY0PAnIY1DA9K7a1OiIfe/oruEeNZmiigU34sKG2Pin5HPQdBkb9NKnLRXe70HtJ8cJITXcypYZOzpBs/+x/VN9SDB25oKj77dyU7lt2WaQJx6hZPEC82B3oP3JD/yIWVv1SSdZvpA0O+63b1SHpoOTONzkCoaKkq9+z7kuHKVnvQU92gNcWNtsld2/xVYy3MurjLCW8pAc\",\"timestamp\":\"1790408695053\"}','{\"data\": \"{\\\"action\\\":\\\"ConfirmBet\\\",\\\"operationId\\\":\\\"4247600_2_81511832\\\",\\\"updateTime\\\":\\\"2026-09-26T03:44:54.550-04:00\\\",\\\"transactionTime\\\":\\\"2026-09-26T03:44:54.000-04:00\\\",\\\"userId\\\":\\\"huidubet_h72add9\\\",\\\"txns\\\":[{\\\"isOddsChanged\\\":false,\\\"licenseeTxId\\\":\\\"710810a0-22b3-4794-a144-c26826de6f05\\\",\\\"odds\\\":1.66,\\\"actualAmount\\\":100.0,\\\"winlostDate\\\":\\\"2026-09-26T00:00:00.000-04:00\\\",\\\"txId\\\":574559653753520177,\\\"refId\\\":\\\"4247600_27403383\\\",\\\"debitAmount\\\":0.0,\\\"oddsType\\\":2,\\\"creditAmount\\\":0.0}]}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-09-26 07:44:55\", \"bet_amount\": \"0\", \"game_round\": \"12289102292563017319\", \"win_amount\": \"0\", \"currency_code\": \"INR\", \"serial_number\": \"c9196129-2be7-3b2b-a4f9-5e6c8e71a06d\", \"member_account\": \"h72add9\"}','settled','Resolved 1 pending stake(s) as lost','2026-09-26 07:44:55'),
(5,'22414963-a15c-39f5-a5b1-ebe7972a12c6','h72add16','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78IOB4/bSM8r93ls0CNi3WcL4neTX8gysY0SW3OdyO/YwnRNVHJA3KtuC0AFiftEUOAC3AtqgRLWkl58LSJa77ba2VeZtvRqMoe14oQQh8Px72PnVJz4VshwaKXkw8NCV1dCrF4jHgZaRqWW+HFJedaeE2iqcw253KRv/6t88acInou0DQF6lSEFReRlgdbEteRk3OWfRwW9c5It0w058a6+XJT184etdyqFzk57U+GN51V49j2UHBX40TnefoB+0J2P3qii6cPRlOTGASIKwkGy0Cd3RWP9oLkMVZjeeDnsX5T70UWB5DJph9ynMDUlwB5KAFBJaRDuGnAZN1NzSC1aqpoFiRz8TgmDXoSiK1Wa3fWQmqo/pIw5K3N2f1MtYkOqwfmUJrX9GRVmGorfD2xwAFyJfLQEZXnRawb0+WXBmBS6ZGHuMWwfVx+csrgvGNxfFZeqlDcfVTeGfYh5CQSwYvTbrHP2crarK23NzPL5+Q9Iej+6cutVyssK09z+cPjNBhjwhbFcJsDpZ76lPPc0CNweDMHh42bL72FWcdmFOEPs2JzFZLl5h20zuZjJNwqsac0u/3woYq92uFIPkJlzZGwm6Adlak5//wuj9hmXJJA4mSKRhtea9OR+Ydsx+qveYp4dNBeHikEyArr084yh3lQuXTV+SpYYWQl025kc4p6m+z/BUlrLbwqJgnmJ7gr+IBj+eysAt4yizkQh7X8Y9WKLXr0C5nUYsfu2aPoPWt1VyCnHoareDkJt2j6OQa0PKuw15GyhOQkYoKunKzmeNDD/e2ddYMFv4J3KsArrvMRAmDBes+pllHO0A9i8I0nhmNmSCplEWyMXaiC06iuq4A4BFqZeeOi1z9aQYYf1MEQ+H+1hItCTUFBDkqGe2lkSSuAw/T8fjE2pmBxppK88FwlXuY6/5ZbdzFchubeuNBwbirb73eMRqH0r/nIiYuvmlTLzO/6uhMs6ZffhjRg0Db0yS3cee+FrW6E9R5Fi/YhU17lKRxsm4NepHln2AvoHxvrHwug77MTEHwp1Ec8cdgAK+JSD/PDm/LdtMYdNfkZ4jLvZd1ZaBe4xT1GtsRuT8Lqd/lG0OphJgWDf9UcZ6q+EVs+25gDGbVIg/1apUsl8Dj6YbkODtzzlTpjt11Rk3OWfRwW9c5It0w058a681aGxpRLlkarXgHU2XkQTQErCjAHF0Q2eOeXAyyLw0Rb4+JOBODi9YhuezX5vaEpSGBk83d1J7jjBIR8ifeOfr4maOERi+tln5Xwt5kpPg61HjfrgDz+gv7eLbi4ujjLmwvtAcmfyFtZ7yzm6/7x5KaTQww/sHWBoqUfL5uXpPcw55kI8FVz7OaoeUwZ+pPqZjQOiKd2Nzlb5lVeWmVxix/mEPfOSrGdE4j2jaBGG7hPwyJlOapCd2WbefacIm85yW8XCLbfw1vG/TMqM6l6CoBD+E/f/PgH3K15OOgN6QP9FvparitndOq+79OdpoaV8oSSh8aN8Zohh7benVU+KDczo2dQTlYH/kysJeSNIGPAS8lP2HiJIR7o8UYMr2iwhCtO6So15DfLHmLRH09uDH5Ez5cKEhkS/49bjrYgTju7nlT9Ab5zxa6Jwqbi6LG8sjRPjQ2ABqvSVfwG2cDUVH0jfxt1cpAZpoy5CPCjelEWHlcsgIYFBCWbi/CxymlgamWLpSiljGIM21o42RSGvelZDZfmiaNXiIApT/JEzWApE5zFatJWMD5jdm3diOGlTvTF7Pp/CV4C2yjLKjuWtsnVBCqUdI7/BeyRukXi8YpPjFmU5p0/w2oRerlf3UrLRRBm8HnXk7c/6v3VanL/9NtEyQDfB2NqGv8aAG9nd9/YkrMH83jNWdlsM96L2torMyrHTbWYwjOKEVJW/do6TpHEt7Tg4DUWolsc9EMA/jnK7+AR3xxusBqV2MxM5JYWA==\",\"timestamp\":\"1790409061867\"}','{\"data\": \"{\\\"sportTypeName_en\\\":\\\"Soccer\\\",\\\"sportTypeName\\\":\\\"Soccer\\\",\\\"oddsId\\\":1072703999,\\\"betTypeName\\\":\\\"Over/Under\\\",\\\"homeName\\\":\\\"Minebea Mitsumi FC\\\",\\\"betTeam\\\":\\\"h\\\",\\\"betTypeName_en\\\":\\\"Over/Under\\\",\\\"oddsType\\\":2,\\\"betChoice\\\":\\\"Over\\\",\\\"awayName_en\\\":\\\"Veertien Mie FC\\\",\\\"tsId\\\":\\\"\\\",\\\"point\\\":\\\"1.50\\\",\\\"point2\\\":\\\"\\\",\\\"leagueName\\\":\\\"JAPAN FOOTBALL LEAGUE\\\",\\\"isLive\\\":true,\\\"awayScore\\\":1,\\\"leagueId\\\":673,\\\"odds\\\":5.55,\\\"excluding\\\":\\\"\\\",\\\"action\\\":\\\"PlaceBet\\\",\\\"operationId\\\":\\\"4247600_1_81512189\\\",\\\"currency\\\":61,\\\"betFrom\\\":\\\"W001\\\",\\\"kickOffTime\\\":\\\"2026-09-26T01:59:00.000-04:00\\\",\\\"homeId\\\":957836,\\\"matchId\\\":134994201,\\\"oddsInfo\\\":\\\"\\\",\\\"homeScore\\\":0,\\\"matchDateTime\\\":\\\"2026-09-26T02:00:00.000-04:00\\\",\\\"leagueName_en\\\":\\\"JAPAN FOOTBALL LEAGUE\\\",\\\"sportType\\\":1,\\\"actualAmount\\\":100.0,\\\"IP\\\":\\\"86.96.106.82\\\",\\\"homeName_en\\\":\\\"Minebea Mitsumi FC\\\",\\\"awayId\\\":373025,\\\"updateTime\\\":\\\"2026-09-26T03:51:01.371-04:00\\\",\\\"debitAmount\\\":100.0,\\\"userId\\\":\\\"huidubet_h72add16\\\",\\\"betType\\\":3,\\\"awayName\\\":\\\"Veertien Mie FC\\\",\\\"betAmount\\\":100.0,\\\"baStatus\\\":false,\\\"betTime\\\":\\\"2026-09-26T03:51:01.371-04:00\\\",\\\"betRemark\\\":\\\"\\\",\\\"refId\\\":\\\"4247600_27403489\\\",\\\"creditAmount\\\":0.0,\\\"betChoice_en\\\":\\\"Over\\\"}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-09-26 07:51:01\", \"bet_amount\": \"100.0\", \"game_round\": \"9498915378785173438\", \"win_amount\": \"0\", \"currency_code\": \"INR\", \"serial_number\": \"22414963-a15c-39f5-a5b1-ebe7972a12c6\", \"member_account\": \"h72add16\"}','settled','bet=100.0 win=0 bal=900.00','2026-09-26 07:51:02'),
(6,'6edc4b7f-d468-3b77-8dec-b0feb879da47','h72add16','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78Z54l2le1+4xossJ8ftsMpTFTBM/Blzi55cHhiCzbzMjiQOwucaSd9GVqTvxm6uUcP0L5QKeaSCRoilalVwv+fQY7Txb3OeLybnsMOArebby46DWtO3Qx8h1zkRhhqt9mftyoJXLpJnlu8ZpftJk/0hqj8ANbDqauTE38/RblQ+VEvO4J9TeELnbBiw9jC6xNeD1CG6nlv0yi3hhCMG0tfSB1WOMgGDOXwUhmsCIZBWvNxAMMor1LX+x7854Y8LYeNAUS/R0Zm51yD66aHZq0DQbCpwHwcboWcxAiLlhQa8Qpr9hLWFPMPykhEvcTbMu6jTD4LvCEH8wAyLiqvqfKOj4hxjGP6tNsj0RHQtrCLLd95y/ePUXAwAmVHYwkHeeL+DhoL7J4SzJrYjDVVh4G0zgFg7O+GMqH9b75jSFKSK3rGk3UgI4Afu2gPbYvQ9yjh3OoBznaDD332h/f2iy59ZM6HIMF/vU4lsZfU93K/INvoVsis83l8iGgmdri1d9ob7nMxd+qNgg5zIEqAjIV61C/cls2M1wAm6sjkrN5nCnGpbZv3mknhqs05cRUdonLNeEyqT1PnrhJVhIs6RUx5Ew7H1A12eVyuQzDY+Y4vqJ2NTZbi1yHElBP43ozI5fS2HhmWBHTotnQkcH7Jx3tXk3U9hkIheXPVlw9ALmN8eObYvDuS6c0jSKanQGwwqEWwpcNUexnQl9Rb0W2G4Uooa3NYPc4kNGIAE4/CJuM9lpf4ULxrL2AxXY0PAnIY1DAySoXQz7r4vL9pj05EmGK1bSFyNiS5PX8JEolSbs/157cbAdHxNZD68GVVfe8lPTHOzpBs/+x/VN9SDB25oKj77dyU7lt2WaQJx6hZPEC82AafSrw6tS9spd5PCAlMyrJadtvoxRlxvgm9yrOrupH1O4suBVzopB/DhyekcJHveDtXwXrbPctdxmV+ET9sKtE\",\"timestamp\":\"1790409062281\"}','{\"data\": \"{\\\"action\\\":\\\"ConfirmBet\\\",\\\"operationId\\\":\\\"4247600_2_81512193\\\",\\\"updateTime\\\":\\\"2026-09-26T03:51:02.200-04:00\\\",\\\"transactionTime\\\":\\\"2026-09-26T03:51:02.000-04:00\\\",\\\"userId\\\":\\\"huidubet_h72add16\\\",\\\"txns\\\":[{\\\"isOddsChanged\\\":false,\\\"licenseeTxId\\\":\\\"381b487b-12ce-46f4-b0f4-e837f2fc60da\\\",\\\"odds\\\":5.55,\\\"actualAmount\\\":100.0,\\\"winlostDate\\\":\\\"2026-09-26T00:00:00.000-04:00\\\",\\\"txId\\\":574561234301485065,\\\"refId\\\":\\\"4247600_27403489\\\",\\\"debitAmount\\\":0.0,\\\"oddsType\\\":2,\\\"creditAmount\\\":0.0}]}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-09-26 07:51:02\", \"bet_amount\": \"0\", \"game_round\": \"9498915378785173438\", \"win_amount\": \"0\", \"currency_code\": \"INR\", \"serial_number\": \"6edc4b7f-d468-3b77-8dec-b0feb879da47\", \"member_account\": \"h72add16\"}','settled','Resolved 1 pending stake(s) as lost','2026-09-26 07:51:02'),
(7,'f8691b6e-e059-30cc-a93b-d1535b999e16','h72add9','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78Z54l2le1+4xossJ8ftsMpabehKixK+1t0sp3eaaKB4YWD8V0cIUu8wbhCl4Q3n7cvpyW35JBrOojZtU/uqG34ryE7BhZHoYIwSkxk5wRqQdVo9eAwqCPWBFz42efs4/nkzocgwX+9TiWxl9T3cr8g7mbVEdx5U91nHkHTEieEFikGKKWd+aaYN7dAt4MwgO+Grz1UXqZfTcDggIQXmsLfg/SXikjngktkIbynVvKy9NZRGnxuKg/caAUDhg3eE6mQ9vH3qjIViyi2eCWrdgTxd5JkAl5cyKFKiD6YYBltSYErCjAHF0Q2eOeXAyyLw0Rb4+JOBODi9YhuezX5vaEpeT1rjcDJWmbMEu3drKpyW3GpbZv3mknhqs05cRUdonLnoN/aSlomu5p7u+v2hkALUw7H1A12eVyuQzDY+Y4vqJ7jA5u7Dfv9SFlcesalzKepoc03xIO+F0bHODmw7e595xSZv3G9Gma/TE1cfeKSYerVEf/XbGLfDTPSpBmsgWJTY7mq/NenZPdIILZ6cwT000RPXyig86+3jfdyoZMdSHSIcv5u6jyIaWa3wMpzMBh0e9GgsnLgda2uG8QT/1eMoh4iAH97MeD6vygsJ9qOY5Wf/DDGU+eopZokfvTmjTc2lHBpCZDv9d1IGs+NAY3x41yzWnbswrRa5ANc+xuYjHtCKgRGfYL23SuJ6vu4JpYl3ztYun1hQSu2RFxTrhMk1ul02plxqA/84Oz/MHvWABSMrCm3SszVVBQTrikC6AUMsMXAZB5xNmnkRVPb6OgF2JKzB/N4zVnZbDPei9raKzMqx021mMIzihFSVv3aOk6sYEMhN2Y5u3M8gsZBLh0keDaCfI35XgJxFiyf4qfW5E=\",\"timestamp\":\"1790409367115\"}','{\"data\": \"{\\\"action\\\":\\\"Settle\\\",\\\"operationId\\\":\\\"4247600_4_81513031\\\",\\\"txns\\\":[{\\\"settlementTime\\\":\\\"2026-09-26T03:56:00.05\\\",\\\"winlostDate\\\":\\\"2026-09-26T00:00:00.000-04:00\\\",\\\"payout\\\":266.0000,\\\"txId\\\":574559653753520177,\\\"updateTime\\\":\\\"2026-09-26T03:56:03.805-04:00\\\",\\\"refId\\\":\\\"4247600_27403383\\\",\\\"debitAmount\\\":0.0,\\\"creditAmount\\\":266.0000,\\\"userId\\\":\\\"huidubet_h72add9\\\",\\\"extraStatus\\\":\\\"\\\",\\\"status\\\":\\\"won\\\"}]}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-09-26 07:56:07\", \"bet_amount\": \"0.0\", \"game_round\": \"12289102292563017319\", \"win_amount\": \"266.0000\", \"currency_code\": \"INR\", \"serial_number\": \"f8691b6e-e059-30cc-a93b-d1535b999e16\", \"member_account\": \"h72add9\"}','settled','bet=0.0 win=266.0000 bal=50166.0000','2026-09-26 07:56:07'),
(8,'0123a6e0-99b6-38b2-96eb-4f5a8e982fec','h72add16','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78Z54l2le1+4xossJ8ftsMpabehKixK+1t0sp3eaaKB4YWD8V0cIUu8wbhCl4Q3n7co42+yLvFcZWMDbGaikavPe0YWFKSFnW9lsNJGb1JUTlVo9eAwqCPWBFz42efs4/nkzocgwX+9TiWxl9T3cr8g3oeqvNCRJ3WaBC3vpZAv/fJhTYLTxeCOYVVri+jDP/4c673P8O55AKK7IUAQSKRqR8wnKz4XiQP+qwiNtpBGwnUVQUfFYuO0GIOHRSph4IIlF1WoyFC9W8m3rT4JLRspv5oMsYoXUVqha0pA8RJ7Mp+gzK6YeTMmm0Cqa9MqFsS1oUeWBvO7zLYf28yXrBwkGSsmlkhnKbuDGEKae0DwdnBXouJFDmCMCp1nZwwXC67kWM4AANqnSEg5HY+8/nYK8ZA8QfrisNPPr3STM+Ku2Vw0e9nxzDczRuEiq1sky5lq5rnD5uzPqrwFzyFWAJ/6pxSZv3G9Gma/TE1cfeKSYc/XiwHxuM5+p9B0+rLkWy6fCJRRdU6pMr7H6ZZS3WAcSbK8yT3Fqm3VgmyHxfxcbUwpELN+Z020ik4W01D3vjhm2Lw7kunNI0imp0BsMKhFsKXDVHsZ0JfUW9FthuFKKHLzL69tUmaGl/6o/MDWw3yVSNl9pxoSc85Bhstzi7DzYdk/+XMQFXBYymtTUb2mLwZmNM5Y1gUlqG4+3nGi/H9Mbp6tSpGYdU42wjZyw18ovcOSLCEqF8UHvSpfnmF7NK/xiZwlEV3XeuL4xX786cXvZitnJv1cHCcQMfYh7+zN/xgiDUc0/GF7hSQfUTcx10Ippm8Ygb28kJMcF06xCVY+C10XPYuspOcTu43ctF/7nVbJb5v6GU4lr+JA7jJzYA=\",\"timestamp\":\"1790410006821\"}','{\"data\": \"{\\\"action\\\":\\\"Settle\\\",\\\"operationId\\\":\\\"4247600_4_81513709\\\",\\\"txns\\\":[{\\\"settlementTime\\\":\\\"2026-09-26T04:06:42.347\\\",\\\"winlostDate\\\":\\\"2026-09-26T00:00:00.000-04:00\\\",\\\"payout\\\":0.0000,\\\"txId\\\":574561234301485065,\\\"updateTime\\\":\\\"2026-09-26T04:06:45.272-04:00\\\",\\\"refId\\\":\\\"4247600_27403489\\\",\\\"debitAmount\\\":0.0000,\\\"creditAmount\\\":0.0000,\\\"userId\\\":\\\"huidubet_h72add16\\\",\\\"extraStatus\\\":\\\"\\\",\\\"status\\\":\\\"lose\\\"}]}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-09-26 08:06:46\", \"bet_amount\": \"0.0000\", \"game_round\": \"9498915378785173438\", \"win_amount\": \"0.0000\", \"currency_code\": \"INR\", \"serial_number\": \"0123a6e0-99b6-38b2-96eb-4f5a8e982fec\", \"member_account\": \"h72add16\"}','heartbeat','Balance sync','2026-09-26 08:06:47'),
(9,'a557d5ae-84ff-32c3-a772-df87d13a99cf','h72add5','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78IOB4/bSM8r93ls0CNi3WcL4neTX8gysY0SW3OdyO/YwnRNVHJA3KtuC0AFiftEUOAC3AtqgRLWkl58LSJa77ba2VeZtvRqMoe14oQQh8Px4YNT2+NaDcgPTPp2hOGO78dCrF4jHgZaRqWW+HFJedaeE2iqcw253KRv/6t88acInrdJeDcLcGaLupQbPJEUinuXGq7PhDyxOIX8eUqVNg3BlrzhH1E+Wc1vXBHTb5ItTGSyo1YtfZmxJA7a5x/IMwf2lLnHhxyKg+7OSZC4stfFY6W9FgKDFQ0TXQTP3vKJ/5U0i7nGg+lwHE6ItuvRu2nLUTQ7+U3DaGNhUPVRT8t5urpqoBEgmUhCXNnz1qHNAZfcYzLK3+Rlce3bXozWqRG1h2AfCbSb0F2nbWdEI5SZhur+5QlyEv8/Ya4JxgcVKkY4Up/lAI8rxSi9yRhRX7/wJCsSTxzNsQSCAwr68S1K7bnSbPqpCsuTOCtKYlcBYIcc0fAq0OLktQTqGR6RfGlVnHD+r6vHUL47x7KTL1bCmhdBfHu8mCqSx8DMttaoMShgjo0qN3XQY6PVXMoS54HJ4GN9po7iwYlnIWhEi8uCJENujxQfawRwtNXmBN7ocB1vkkOvqtEmE4Yo0gVxl/M2S6aFfP2K3ioKRYa2yDVIpLiTS6OgQJrb/sckNXOzE1LfIxHfAV+LSI9XnhaESZPhR4RaMBYIjg2BuJL2CTKtLmpkaR9xOGwR2Vzz9cY2oEGrip+aE7apZOhioGLNNrlp8m2bgD9Rn1Mn7WQyc79SNgioQggKc1fuz3NgYG+NvPqSjfjx1XVk1xUAl7XcnbIe2htYqNuoZK+i8AgJRfA1cmVZtnvxcGZ7wa8dm0dTn8SMk2unyiVtuZk50eG1bLxn67R6NNvs+DxAfbAxyzXGJyvJYVlMEuDbuKPigO8UXREjK5JsOD3M876LHCX/qrPICNUc1bRrX617RHPiol4zXtKGK29X9sCPUKUfaO0PCVQlIKPSIgA/jA+pMZtNifJJtj8nh+z4ZXCEZWUfFs2S30m1YVffZ89sqmcDaBbjRQTQmLeuIfFe3WsTilPYlZpperV48m/vdN4rOSut8oNRH9xbbUnyykl/4pQcJtcpHJDUfzy3v4vBxUO33usxkzuK0hsPMzToNXPl5sERGw8JVhQjiIR83H2LLCay6ZuRd8LRiIelFd8/JISEM12fA2pDOlgJ0lMAg5YUCabxsik/ah9x4uF2pusHIwYX8PsVtOvxmKEqpu2O2dvCZF0odoLv73Y5dBYTHHTPfvkZcyQ0z+ksWABphTH0VqlkZvqi1MV8b1lO+2ZUIMij3B686jAfc/FlaaR1E+7iI7+kVYw2T5ZCVDUq5OGFvDBqLuCFlSBxs69MkgfGe0+0YNJbFIP4BujvWHmUwtZjjXvBJ//Vbhg2Uvmiin6UEQui3hMnkMAXYb6GWpi/x80hMZzNsorcSKpmvLTtfgCCgkF89ovS7biDh8zIUn5zxN7mzLrdQFs5uwwZluI0u+yjzyarXkUpMOQAN3gxn7YmCQdR9J17ZvT/x9MvE2Yw8Am8g9MaX6QzOKHOUusXyJqWywxty2HKNfzSS21y9SVZ/8rafDhSVoF1bNNZU5IyuAPllv0d4H/OeFiJMvHV+C2Yd2mBy9rk9B35qgMWmca02nV5JmZAho8eFQkynO/30scsjelrK0ODXD7LJQRtjH+Oeb8U5vY/Cqa7TUFbmnEChgNko6k0WAMxHMXgncJjpjrp/kGFI4OTUtGEYTJa3WK48+jJapZ1Q1So7BjRWExt7nrn6mIoVqY1TulaMgCVy3k8HTVDPK+HCAOpTvlnfUO4z49jxKWIT+0ZHh/dfdLSuTXFXyoiS3i6RuWrjkiibyoXr8hZ3UEE0Cyqd+zyCV+qhgiPb1kJeSrOBgJYrezfL/FuPa/1BgAqI+6Was/Hb4JO+ZFiE=\",\"timestamp\":\"1790445552527\"}','{\"data\": \"{\\\"sportTypeName_en\\\":\\\"Soccer\\\",\\\"sportTypeName\\\":\\\"Soccer\\\",\\\"oddsId\\\":1072755403,\\\"betTypeName\\\":\\\"Over/Under\\\",\\\"homeName\\\":\\\"Malta U21\\\",\\\"betTeam\\\":\\\"h\\\",\\\"betTypeName_en\\\":\\\"Over/Under\\\",\\\"oddsType\\\":2,\\\"betChoice\\\":\\\"Over\\\",\\\"awayName_en\\\":\\\"Northern Ireland U21\\\",\\\"tsId\\\":\\\"\\\",\\\"point\\\":\\\"3.25\\\",\\\"point2\\\":\\\"\\\",\\\"leagueName\\\":\\\"UEFA U21 CHAMPIONSHIP 2027 QUALIFIERS\\\",\\\"isLive\\\":true,\\\"awayScore\\\":2,\\\"leagueId\\\":166177,\\\"odds\\\":0.48,\\\"excluding\\\":\\\"\\\",\\\"action\\\":\\\"PlaceBet\\\",\\\"operationId\\\":\\\"4247600_1_81574338\\\",\\\"currency\\\":61,\\\"betFrom\\\":\\\"W001\\\",\\\"kickOffTime\\\":\\\"2026-09-26T12:59:00.000-04:00\\\",\\\"homeId\\\":1126,\\\"matchId\\\":134564954,\\\"oddsInfo\\\":\\\"\\\",\\\"homeScore\\\":0,\\\"matchDateTime\\\":\\\"2026-09-26T13:00:00.000-04:00\\\",\\\"leagueName_en\\\":\\\"UEFA U21 CHAMPIONSHIP 2027 QUALIFIERS\\\",\\\"sportType\\\":1,\\\"actualAmount\\\":100.0,\\\"IP\\\":\\\"194.61.40.202\\\",\\\"homeName_en\\\":\\\"Malta U21\\\",\\\"awayId\\\":1122,\\\"updateTime\\\":\\\"2026-09-26T13:59:12.045-04:00\\\",\\\"debitAmount\\\":100.0,\\\"userId\\\":\\\"huidubet_h72add5\\\",\\\"betType\\\":3,\\\"awayName\\\":\\\"Northern Ireland U21\\\",\\\"betAmount\\\":100.0,\\\"baStatus\\\":false,\\\"betTime\\\":\\\"2026-09-26T13:59:12.045-04:00\\\",\\\"betRemark\\\":\\\"\\\",\\\"refId\\\":\\\"4247600_27424675\\\",\\\"creditAmount\\\":0.0,\\\"betChoice_en\\\":\\\"Over\\\"}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-09-26 17:59:12\", \"bet_amount\": \"100.0\", \"game_round\": \"8333090203229434728\", \"win_amount\": \"0\", \"currency_code\": \"INR\", \"serial_number\": \"a557d5ae-84ff-32c3-a772-df87d13a99cf\", \"member_account\": \"h72add5\"}','settled','bet=100.0 win=0 bal=0.00','2026-09-26 17:59:13'),
(10,'f8c0ea33-a8e7-3bab-9b79-0968ab871d06','h72add5','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78Z54l2le1+4xossJ8ftsMpTFTBM/Blzi55cHhiCzbzMjiQOwucaSd9GVqTvxm6uUcP0L5QKeaSCRoilalVwv+fa0ZrrHl+Uiin7pRU7cVrAi46DWtO3Qx8h1zkRhhqt9mxWM/5xobqGtyX0jjnBIOGxqj8ANbDqauTE38/RblQ+VEvO4J9TeELnbBiw9jC6xNyEA5Vmb1o+R7W5W7r6KTsv43A+UFj8lk93DwibhhmY3NxAMMor1LX+x7854Y8LYeA/0dzEcsG1SYXU4E2VqOTJPoQuyRAwgrmEBQ+0Gse9jStDCEUEq18rLpW40lWqir4NyKkB8GjNfR2lDRT/8IwqoXgPW1VhGzEYSqByNm/kgETKoqctjjYLRSJ5eIw/vnOM2Ex65fr88080URLrg6H494FjjutYd558/jZSyG4x5QhJeJaAzv9KgOKn7KKxLJdD5cpokerEeDCJOIC3OqfdwjTTgO/k2sH9pwtaEE5pOfjjVYx/ohnPoUubXQ4FcwjnnOVBDVvKlS120XwYOS87CnyXx1qBO3R97J9u1TF8PBXouJFDmCMCp1nZwwXC67KaFSOc5Ghec9Lt8tpSP/N8ZA8QfrisNPPr3STM+Ku2Wt5/7O5icmZzM680rnHDFbjxZlzXfoDcjq9tTIWDvtlt00TACe+k39DslIZ+h3eXnH1fR7AALpak7Zx0O7cA6DHUJYBcFqqnZhYt4B6t4+RGj/9vUZhzRdg1chfSgizM85Emu7S6LaaF1DIQsnMbjc2CaKv4xXq6hQLUKxTCpt3SQhTALMCv7+XiAi6tWwdYs4YVWX1mlfa2BJ/gFmtPdLF0qbHJMsc8Ycxs5kVlPvvz5RCbFwdrAk5ZhssKEOnqLsy1m2yeSYTdIo8v6bdFUi+zYzpfyAJNaxayoyj+zkdoVr6wdo4lUKLtLmp9vr+AjmEh7pCn2ByPaihee2aQZG\",\"timestamp\":\"1790445553312\"}','{\"data\": \"{\\\"action\\\":\\\"ConfirmBet\\\",\\\"operationId\\\":\\\"4247600_2_81574339\\\",\\\"updateTime\\\":\\\"2026-09-26T13:59:12.840-04:00\\\",\\\"transactionTime\\\":\\\"2026-09-26T13:59:12.000-04:00\\\",\\\"userId\\\":\\\"huidubet_h72add5\\\",\\\"txns\\\":[{\\\"isOddsChanged\\\":false,\\\"licenseeTxId\\\":\\\"9c59c2b6-88ba-47b7-b59d-3abcad64033a\\\",\\\"odds\\\":0.48,\\\"actualAmount\\\":100.0,\\\"winlostDate\\\":\\\"2026-09-26T00:00:00.000-04:00\\\",\\\"txId\\\":574717957658116169,\\\"refId\\\":\\\"4247600_27424675\\\",\\\"debitAmount\\\":0.0,\\\"oddsType\\\":2,\\\"creditAmount\\\":0.0}]}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-09-26 17:59:13\", \"bet_amount\": \"0\", \"game_round\": \"8333090203229434728\", \"win_amount\": \"0\", \"currency_code\": \"INR\", \"serial_number\": \"f8c0ea33-a8e7-3bab-9b79-0968ab871d06\", \"member_account\": \"h72add5\"}','settled','Resolved 1 pending stake(s) as lost','2026-09-26 17:59:13'),
(11,'9b1793de-e8dd-3e8f-b780-58e66f2f8eaf','h72add5','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78Z54l2le1+4xossJ8ftsMpabehKixK+1t0sp3eaaKB4YWD8V0cIUu8wbhCl4Q3n7cNPxUMfWfhPXsrS57m7m48aJy03tuA7/SUK53kGFv065Vo9eAwqCPWBFz42efs4/nkzocgwX+9TiWxl9T3cr8gwyb06T5tDQL0UeYdGpftO6kGKKWd+aaYN7dAt4MwgO+Grz1UXqZfTcDggIQXmsLfg/SXikjngktkIbynVvKy9MPwrpfXmlipvc8YdCTVnErQ9vH3qjIViyi2eCWrdgTxbCnyXx1qBO3R97J9u1TF8MErCjAHF0Q2eOeXAyyLw0RAc9tJkLj0Zy1H+eop8yp8rnAmvcAIQh9p2x9M97CpsjGpbZv3mknhqs05cRUdonLDbEfTG98Xph6UWUgwrImq0w7H1A12eVyuQzDY+Y4vqJ7jA5u7Dfv9SFlcesalzKef6jOsmoUCuNy2hTS6UpAt5xSZv3G9Gma/TE1cfeKSYdCtd/NN8LfEPB4Yq2Yg4PnTY7mq/NenZPdIILZ6cwT000RPXyig86+3jfdyoZMdSHSIcv5u6jyIaWa3wMpzMBhsJWTjPG8ch69AmWwntQv0ih31PCS4nGzHGHzAzMXQfukJ0J36ojjOM6F117AqwLFX+FC8ay9gMV2NDwJyGNQwIKQmvVVvGhpNUt0BZ3SIM4f5WIk4csRD9blyZIUYbGBB++i35OMQ6ERsqQpQsumW6e0TLxP3HQtl7wZ7fduv4IUQZvB515O3P+r91Wpy//TmwyiVzoNyXsRUrYi9cqHvdbSFgMS+0hDu4rab6AuZ7nONYko2kJLckiFKT0hz8XtXohDENkR6M/3WaPcbAk4UOBpANWs1+eTHF1fZQ+9RvU=\",\"timestamp\":\"1790447690654\"}','{\"data\": \"{\\\"action\\\":\\\"Settle\\\",\\\"operationId\\\":\\\"4247600_4_81577311\\\",\\\"txns\\\":[{\\\"settlementTime\\\":\\\"2026-09-26T14:34:48.03\\\",\\\"winlostDate\\\":\\\"2026-09-26T00:00:00.000-04:00\\\",\\\"payout\\\":148.0000,\\\"txId\\\":574717957658116169,\\\"updateTime\\\":\\\"2026-09-26T14:34:49.570-04:00\\\",\\\"refId\\\":\\\"4247600_27424675\\\",\\\"debitAmount\\\":0.0,\\\"creditAmount\\\":148.0000,\\\"userId\\\":\\\"huidubet_h72add5\\\",\\\"extraStatus\\\":\\\"\\\",\\\"status\\\":\\\"won\\\"}]}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-09-26 18:34:50\", \"bet_amount\": \"0.0\", \"game_round\": \"8333090203229434728\", \"win_amount\": \"148.0000\", \"currency_code\": \"INR\", \"serial_number\": \"9b1793de-e8dd-3e8f-b780-58e66f2f8eaf\", \"member_account\": \"h72add5\"}','settled','bet=0.0 win=148.0000 bal=148.0000','2026-09-26 18:34:51'),
(12,'4753242e-4c8a-3835-a848-83fc5dc00abd','h72add20','88317b0c9ebdb820791b9a04f7f4cb53','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"ptAs4vt4vXLo1U/3jpEgYHgfhcyN6JD54Fxpv46PzYlS64pPeeNQ+JYKidwpLFb8amUNSFQyrLHjvT8Z0WgSX5nHuZwwiPWZm5k93/nwRM4Xi8zQGpc2ZZn6+q9wxseuWZKJNO5lP2n0hcQ5e0jPhKTqPX+pP4z3gR3ONTq/gThup7ar0Ph8eQnNGqaZxbYCiIDlETdujap88lXmgOCIHz4xZlOadP8NqEXq5X91Ky0UQZvB515O3P+r91Wpy//TC3SSBq3ywiaAs7CZRhtZR2JKzB/N4zVnZbDPei9raKzMqx021mMIzihFSVv3aOk6j8ZtVLrFUgcn53g8QTqUe2LmCXMmLmkZY/hrwZGfIT4=\",\"timestamp\":\"1790970500556\"}','{\"game_uid\": \"88317b0c9ebdb820791b9a04f7f4cb53\", \"timestamp\": \"2026-10-02 19:48:20\", \"bet_amount\": \"20.0\", \"game_round\": \"10332843678789745070\", \"win_amount\": \"0\", \"currency_code\": \"INR\", \"serial_number\": \"4753242e-4c8a-3835-a848-83fc5dc00abd\", \"member_account\": \"h72add20\"}','settled','bet=20.0 win=0 bal=80.00','2026-10-02 19:48:21'),
(13,'0879f04e-0813-39c1-bbd9-1079f10c05a0','h72add20','88317b0c9ebdb820791b9a04f7f4cb53','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"ptAs4vt4vXLo1U/3jpEgYHgfhcyN6JD54Fxpv46PzYlS64pPeeNQ+JYKidwpLFb8amUNSFQyrLHjvT8Z0WgSX5nHuZwwiPWZm5k93/nwRM4Xi8zQGpc2ZZn6+q9wxseue48ogda952Ub7WteweUqEjqJHYN60u2Ab/Jtc3hpPB09JGtf8GfO/n4w63dYKi1TGUY9HoOMH+b0R+FxyCCQ7rjXoOK1t8GW6fn96JbY7q8UQZvB515O3P+r91Wpy//TC3SSBq3ywiaAs7CZRhtZR2JKzB/N4zVnZbDPei9raKzMqx021mMIzihFSVv3aOk6Yakk2Dmih/T0d87V49Mgng9g+/TymwgDDyE91RMpIfo=\",\"timestamp\":\"1790970518845\"}','{\"game_uid\": \"88317b0c9ebdb820791b9a04f7f4cb53\", \"timestamp\": \"2026-10-02 19:48:38\", \"bet_amount\": \"0\", \"game_round\": \"10332843678789745070\", \"win_amount\": \"30.0\", \"currency_code\": \"INR\", \"serial_number\": \"0879f04e-0813-39c1-bbd9-1079f10c05a0\", \"member_account\": \"h72add20\"}','settled','bet=0 win=30.0 bal=110.00','2026-10-02 19:48:39'),
(14,'212a8daa-70ce-36f1-b289-77dd2fbabe4a','h72add19','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78IOB4/bSM8r93ls0CNi3WcL4neTX8gysY0SW3OdyO/YwnRNVHJA3KtuC0AFiftEUOAC3AtqgRLWkl58LSJa77ba2VeZtvRqMoe14oQQh8Px7LRciLEgYO46jh4CxboH1qdCrF4jHgZaRqWW+HFJedaeE2iqcw253KRv/6t88acInpeFaoxMjWh84ZLFj9je+8SOmoIsNPFds+n+lM87HQR9WFZnINfeBXTlNX5ix+5MeJeeL5kXH397ZX5SIgC1EWPhVePBKa0d/Zz/Q4qeCTOMPBwnkdbkoxeS4yWsPwXSOVYTZTi2d9FaAx70oAN3oDE10lHKAzYofsoQveMlq9wStIAZfecew3A8TuQtoFUvYx551+f20kQ8jTbzJJrcZ175xCZalnY7PNksBN4z0us9IoAY3SHAC7pKVanpLQxUuowpH5QyMgCOL0nlgt1NJskRF8qesK4HIYaBIaeL+L0uDs4a4mP3MwGUlkYOrAyjzDfrRW1lf9DQHwFU4PPoaaKb52EB0WTFE/a/3yKfGsRkISxbe0LtqmUMfN3ws5ko5AXjA3SsTYkFKlEcRnrLgbx+JOD6/TpgDRfOgEUyEIh9JA5HB3c967G5oNjjuaCKUfOaBDx46XKu1TYJH6imZOuP27xm5M1AQkJSbL4GifAKOyxp5jNM+qeQ857Ek4No7m6cYzZ1AIpnW9kTh8W4Yk+Wekq4G3xa7y+MzrMCk3/8gL/ezC2oZyBZyPIPcSkD0cxB9YVVvY/Y9hOytspEbuc/Hnk7cKOyfFz/eOyf0qPrKrCjWD7oeD/m2zO+cJTPHSsppu4XSMu1uDz0TCdVIFFOGBtQvppux0WVDmjvv0XvsYlPZ4zzEfGwzyi3zAKXq9WitB8fAKqA5ns5VM4if0Pp1F5TYOd+kFYmLlsMoXKTzw5mSvtneVmUCY0nZ5QihAwCG0Mry0xuLq6wklSAFM+hnS05a4w5VlgEwOLr160lB5b5FI7+OJenvoU+J+N1r9RpxkRwLbszV7QQLvYKpK6xpN1ICOAH7toD22L0Pco7ZdeognubL0lXCmG9y72AL1K7sxrcYZvHl3cXHIC8TgJajhW6Obn8qMVy/zXY1LXZRw8chQmvOTUOso+erJGnyzKkWSRuntHY748ch0UM4u0wT8etfflk9c8RFgNdkljx4p0jtKGfvIz+hV8Qx+GLNpvF4OC+u3srs6upiefkjVxlOeuJZx4zy21YCK/ZW6Bp7qRUDIHCoyhWahqpNzCTqo9jaVx41r4oQcvppoTeu1U2PEH4oSkp6OJwex46nV94WcsvV9B3+GlpxwCyIw7aSGS/y0DWF02iA0Hiivfq/WCZWKfa61jMlFBQUBeaMaGKirJXOaanoDODPf7fBlM3ELQ94OwAMkAXVgOsxl66l7ccczwoKiDUdt7fETlbB19fzqHkXGcXnTulfkwa21H5QBMbxe2sONwh5dCUJiQkAzguX+8j287nD1nas7twZHiOh645CfLkSTOt2FU674NdW/uLAmch5zqXdKMT7aO+ZyiA4dqejYtkw/WXGoritJjkburZb3yPmerTtkFrBCzAXcWjCl/t2+O3yrHh9sYHHBWZd+1HJrhcRTbJLqHJLcg5txydKECy0sHFeQlvOJ/MLL2JaigCS78UHB0PP8QUquNLXPh+AONdQgBC2oSOkzjr08JcgEgFL71y9Ot3wj2NRfLvFt3Z54KX4PL/Zb2l6KlYYxcl87+Z4r5ZCx5R+d6Vyux+VK1ThrrpFIHwp6WK9GajImm+Oxayz8nu/L+bW3xQfJGK6pxfTDhMVdTBT7YRm9buQyp0twbCK4bK5IttKANv9k8ecOX/3UAyn18I5Varc/HlfWc6vGd953QMO7PQ==\",\"timestamp\":\"1791042175304\"}','{\"data\": \"{\\\"sportTypeName_en\\\":\\\"Soccer\\\",\\\"sportTypeName\\\":\\\"Soccer\\\",\\\"oddsId\\\":1076995073,\\\"betTypeName\\\":\\\"Over/Under\\\",\\\"homeName\\\":\\\"Hodd\\\",\\\"betTeam\\\":\\\"h\\\",\\\"betTypeName_en\\\":\\\"Over/Under\\\",\\\"oddsType\\\":2,\\\"betChoice\\\":\\\"Over\\\",\\\"awayName_en\\\":\\\"Odd BK\\\",\\\"tsId\\\":\\\"\\\",\\\"point\\\":\\\"5.50\\\",\\\"point2\\\":\\\"\\\",\\\"leagueName\\\":\\\"NORWAY 1ST DIVISION\\\",\\\"isLive\\\":true,\\\"awayScore\\\":3,\\\"leagueId\\\":124,\\\"odds\\\":1.21,\\\"excluding\\\":\\\"\\\",\\\"action\\\":\\\"PlaceBet\\\",\\\"operationId\\\":\\\"4247600_1_82297972\\\",\\\"currency\\\":61,\\\"betFrom\\\":\\\"W001\\\",\\\"kickOffTime\\\":\\\"2026-10-03T09:59:00.000-04:00\\\",\\\"homeId\\\":24558,\\\"matchId\\\":134834526,\\\"oddsInfo\\\":\\\"\\\",\\\"homeScore\\\":2,\\\"matchDateTime\\\":\\\"2026-10-03T10:00:00.000-04:00\\\",\\\"leagueName_en\\\":\\\"NORWAY 1ST DIVISION\\\",\\\"sportType\\\":1,\\\"actualAmount\\\":100.0,\\\"IP\\\":\\\"86.96.106.82\\\",\\\"homeName_en\\\":\\\"Hodd\\\",\\\"awayId\\\":242578,\\\"updateTime\\\":\\\"2026-10-03T11:42:55.219-04:00\\\",\\\"debitAmount\\\":100.0,\\\"userId\\\":\\\"huidubet_h72add19\\\",\\\"betType\\\":3,\\\"awayName\\\":\\\"Odd BK\\\",\\\"betAmount\\\":100.0,\\\"baStatus\\\":false,\\\"betTime\\\":\\\"2026-10-03T11:42:55.219-04:00\\\",\\\"betRemark\\\":\\\"\\\",\\\"refId\\\":\\\"4247600_27671483\\\",\\\"creditAmount\\\":0.0,\\\"betChoice_en\\\":\\\"Over\\\"}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-10-03 15:42:55\", \"bet_amount\": \"100.0\", \"game_round\": \"17179854086231438714\", \"win_amount\": \"0\", \"currency_code\": \"INR\", \"serial_number\": \"212a8daa-70ce-36f1-b289-77dd2fbabe4a\", \"member_account\": \"h72add19\"}','settled','bet=100.0 win=0 bal=900.00','2026-10-03 15:42:55'),
(15,'d0eb4f19-7738-307f-820f-8338b8eaac38','h72add19','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78eNIMcK04MWy4Vt2NuKEov4S5I4RQWStcarlIWdjJ/k/jVoZ/V+odOZiqneHWf8KYYKsrEAxQB/a0oj1N9UEiiuJA7C5xpJ30ZWpO/Gbq5RyStmQKtL91fA198Q0lUWGNcW8hs+pvaqimS9+EDh9UI0LELLY89VgYN0KfIl6RhGcJ+sjc1BXRYL7JhPFWF3HSgX7OxPs/0zIHjoUy09NiPkxXxvWU77ZlQgyKPcHrzqMDcn9LZC/lkEWvkmd2+FoFFTgot/c38wlropbkRRnsPWM0PuvQS7Yw3BExATeh7TGeKwV/X7Z3pb+4OFuYnwKgX2+XJWrCMa+t0O+4401dZSkS+XAskhuG4Gfs3xBzvcicxvAorvzW7whBFAjDPpEN5n5FB3mYsHZTp0YqB1ol2agZ1y1Y9wgLnRIet+7ikA9te8LTscf/GLs91cMphhoqcICMEJPd/tmxVWRAxM81xbOGlP84pYslOuAUhl3jNGR53Eh1dOgR0wNP1ELHWhdnQt7MLjmod8y/md2lYx4p60wU1gB7j20Mviq/rf74srdDeFxS6VfBhAtSCRrAAm61JLeLpG5auOSKJvKhevyFndQQTQLKp37PIJX6qGCI9vVAkxZXLn2ndOY3+AfK2iRTVDrwnHYSRgv/PoTsD2RayQ==\",\"timestamp\":\"1791042176035\"}','{\"data\": \"{\\\"errorMessage\\\":\\\"OddsChanged\\\",\\\"action\\\":\\\"CancelBet\\\",\\\"operationId\\\":\\\"4247600_3_82297973\\\",\\\"updateTime\\\":\\\"2026-10-03T11:42:55.586-04:00\\\",\\\"userId\\\":\\\"huidubet_h72add19\\\",\\\"txns\\\":[{\\\"refId\\\":\\\"4247600_27671483\\\",\\\"debitAmount\\\":0.0,\\\"creditAmount\\\":100.0}]}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-10-03 15:42:56\", \"bet_amount\": \"0\", \"game_round\": \"17179854086231438714\", \"win_amount\": \"100.0\", \"currency_code\": \"INR\", \"serial_number\": \"d0eb4f19-7738-307f-820f-8338b8eaac38\", \"member_account\": \"h72add19\"}','settled','bet=0 win=100.0 bal=1000.00','2026-10-03 15:42:56'),
(16,'84295924-9b42-37f9-a56e-ee4f4e81da97','h72add19','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78IOB4/bSM8r93ls0CNi3WcL4neTX8gysY0SW3OdyO/YwnRNVHJA3KtuC0AFiftEUOAC3AtqgRLWkl58LSJa77ba2VeZtvRqMoe14oQQh8Px7LRciLEgYO46jh4CxboH1qdCrF4jHgZaRqWW+HFJedaeE2iqcw253KRv/6t88acInpeFaoxMjWh84ZLFj9je+8SOmoIsNPFds+n+lM87HQR9WFZnINfeBXTlNX5ix+5MeJeeL5kXH397ZX5SIgC1EWPhVePBKa0d/Zz/Q4qeCTOMPBwnkdbkoxeS4yWsPwXSOVYTZTi2d9FaAx70oAN3oDE10lHKAzYofsoQveMlq9wStIAZfecew3A8TuQtoFUvYx551+f20kQ8jTbzJJrcZ175xCZalnY7PNksBN4z0us9IoAY3SHAC7pKVanpLQxUuowpH5QyMgCOL0nlgt1NJskRF8qesK4HIYaBIaeL+L0uDs4a4mP3MwGUlkYOrAyjzDfrRW1lf9DQHwFU4PPoaaKb52EB0WTFE/a/3yKfGsRpKxMtXbgb6LVykZrVMNBKVAXjA3SsTYkFKlEcRnrLgbx+JOD6/TpgDRfOgEUyEIh9JA5HB3c967G5oNjjuaCKUfOaBDx46XKu1TYJH6imZO1sqrm4QIjj04zZwCRahWq6Oyxp5jNM+qeQ857Ek4No7m6cYzZ1AIpnW9kTh8W4Yk+Wekq4G3xa7y+MzrMCk3/8gL/ezC2oZyBZyPIPcSkD0cxB9YVVvY/Y9hOytspEbuc/Hnk7cKOyfFz/eOyf0qPrKrCjWD7oeD/m2zO+cJTPHSsppu4XSMu1uDz0TCdVIFFOGBtQvppux0WVDmjvv0XvsYlPZ4zzEfGwzyi3zAKXq9WitB8fAKqA5ns5VM4if0Pp1F5TYOd+kFYmLlsMoXKTzw5mSvtneVmUCY0nZ5QihAwCG0Mry0xuLq6wklSAFM+hnS05a4w5VlgEwOLr160lB5b5FI7+OJenvoU+J+N1r9RpxkRwLbszV7QQLvYKpK6xpN1ICOAH7toD22L0Pco7ZdeognubL0lXCmG9y72AL1K7sxrcYZvHl3cXHIC8TgJajhW6Obn8qMVy/zXY1LXZRw8chQmvOTUOso+erJGnyzKkWSRuntHY748ch0UM4u0wT8etfflk9c8RFgNdkljzmmcOtQJArkf9VQ7xo7AKNpvF4OC+u3srs6upiefkjVxlOeuJZx4zy21YCK/ZW6Bp7qRUDIHCoyhWahqpNzCTqo9jaVx41r4oQcvppoTeu1U2PEH4oSkp6OJwex46nV94WcsvV9B3+GlpxwCyIw7aSGS/y0DWF02iA0Hiivfq/WCZWKfa61jMlFBQUBeaMaGKirJXOaanoDODPf7fBlM3ELQ94OwAMkAXVgOsxl66l7+1NDDf9qDBJRqyKeeZCn0PzqHkXGcXnTulfkwa21H5QBMbxe2sONwh5dCUJiQkAzguX+8j287nD1nas7twZHiN38lvYyWr4ITkQNTJBf4SG/uLAmch5zqXdKMT7aO+ZyiA4dqejYtkw/WXGoritJjkburZb3yPmerTtkFrBCzAUrSaQqoNhNs7WuBIPhkxuB4vvhpqloROGPuRDfQd+4vliD9lwhlFZDzbYlcLCUSoyBiKyF5jqZ7Opb+vDUcxUADUZp5NYY61Q4CJYuT0UpXiC8ceY9E9huw2vXl+z6mSsinHA9XhdJDKTHbtOzPvQ1+LD6mJFloeM7NEPwo/DPtYrcTKX+o4JGK1YDHLI26fc6ybSw9fxEtbSzNEITvVquEbXcG7oYANpqrj7Jpug43gF4EXupBYA1E7mSpt5P+ydQaxd1uhxofHavXx7QnD3Rr9R6kO7/eTro8qeOwcCV0w==\",\"timestamp\":\"1791042310692\"}','{\"data\": \"{\\\"sportTypeName_en\\\":\\\"Soccer\\\",\\\"sportTypeName\\\":\\\"Soccer\\\",\\\"oddsId\\\":1076995073,\\\"betTypeName\\\":\\\"Over/Under\\\",\\\"homeName\\\":\\\"Hodd\\\",\\\"betTeam\\\":\\\"h\\\",\\\"betTypeName_en\\\":\\\"Over/Under\\\",\\\"oddsType\\\":2,\\\"betChoice\\\":\\\"Over\\\",\\\"awayName_en\\\":\\\"Odd BK\\\",\\\"tsId\\\":\\\"\\\",\\\"point\\\":\\\"5.50\\\",\\\"point2\\\":\\\"\\\",\\\"leagueName\\\":\\\"NORWAY 1ST DIVISION\\\",\\\"isLive\\\":true,\\\"awayScore\\\":3,\\\"leagueId\\\":124,\\\"odds\\\":1.72,\\\"excluding\\\":\\\"\\\",\\\"action\\\":\\\"PlaceBet\\\",\\\"operationId\\\":\\\"4247600_1_82298146\\\",\\\"currency\\\":61,\\\"betFrom\\\":\\\"W001\\\",\\\"kickOffTime\\\":\\\"2026-10-03T09:59:00.000-04:00\\\",\\\"homeId\\\":24558,\\\"matchId\\\":134834526,\\\"oddsInfo\\\":\\\"\\\",\\\"homeScore\\\":2,\\\"matchDateTime\\\":\\\"2026-10-03T10:00:00.000-04:00\\\",\\\"leagueName_en\\\":\\\"NORWAY 1ST DIVISION\\\",\\\"sportType\\\":1,\\\"actualAmount\\\":100.0,\\\"IP\\\":\\\"86.96.106.82\\\",\\\"homeName_en\\\":\\\"Hodd\\\",\\\"awayId\\\":242578,\\\"updateTime\\\":\\\"2026-10-03T11:45:10.242-04:00\\\",\\\"debitAmount\\\":100.0,\\\"userId\\\":\\\"huidubet_h72add19\\\",\\\"betType\\\":3,\\\"awayName\\\":\\\"Odd BK\\\",\\\"betAmount\\\":100.0,\\\"baStatus\\\":false,\\\"betTime\\\":\\\"2026-10-03T11:45:10.242-04:00\\\",\\\"betRemark\\\":\\\"\\\",\\\"refId\\\":\\\"4247600_27671562\\\",\\\"creditAmount\\\":0.0,\\\"betChoice_en\\\":\\\"Over\\\"}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-10-03 15:45:10\", \"bet_amount\": \"100.0\", \"game_round\": \"1950058286659155471\", \"win_amount\": \"0\", \"currency_code\": \"INR\", \"serial_number\": \"84295924-9b42-37f9-a56e-ee4f4e81da97\", \"member_account\": \"h72add19\"}','settled','bet=100.0 win=0 bal=900.00','2026-10-03 15:45:11'),
(17,'ae54b5ea-8e61-39ae-b9a2-d3bb333bd92d','h72add19','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78Z54l2le1+4xossJ8ftsMpTFTBM/Blzi55cHhiCzbzMjiQOwucaSd9GVqTvxm6uUc0hc7UunJuaZE/C6WvyPw/f4M0drEDAxEPBbZKojDriZCxCy2PPVYGDdCnyJekYRnc+ozeQYbJAplKQ+sa3NwF/nk45UMSL2J9gYy3HWhJpxEvO4J9TeELnbBiw9jC6xNXFIKYweETD+izQzaD/5gfDyqZHJ59teY3+zR3JMpCL3NxAMMor1LX+x7854Y8LYehWAhRIoBDcmKVtbYzwG9SQbCpwHwcboWcxAiLlhQa8Qpr9hLWFPMPykhEvcTbMu6jTD4LvCEH8wAyLiqvqfKOvZ/mkTzqzou6U+OX2VuwFez7xfSpxHWeh9po5DrBqvMHSvUjRFmX0pQ1x+ULc8vl7pN9IOWktqyEsXnDmOTRaLrGk3UgI4Afu2gPbYvQ9yjh3OoBznaDD332h/f2iy59cgL/ezC2oZyBZyPIPcSkD1voVsis83l8iGgmdri1d9ob7nMxd+qNgg5zIEqAjIV697JHYKSaFQY6hZDWQz2i+nGpbZv3mknhqs05cRUdonLMOXfHPeNZuaAchplidl/40w7H1A12eVyuQzDY+Y4vqJ2NTZbi1yHElBP43ozI5fS2HhmWBHTotnQkcH7Jx3tXk3U9hkIheXPVlw9ALmN8eMrSaQqoNhNs7WuBIPhkxuB4vvhpqloROGPuRDfQd+4vq3NYPc4kNGIAE4/CJuM9lpf4ULxrL2AxXY0PAnIY1DAGK46ans+lUSP5EshW6hrHMNhXZ+MItMSOJMa2GxuProxhPZ770oU9bYFrYOqQHakOzpBs/+x/VN9SDB25oKj77dyU7lt2WaQJx6hZPEC82Cl0SQ6jta5QHcSwrutvjAUadtvoxRlxvgm9yrOrupH1C8KxNp6f4HI36OkJx9AKZACteGAsGyVF3M58I8maS8z\",\"timestamp\":\"1791042311340\"}','{\"data\": \"{\\\"action\\\":\\\"ConfirmBet\\\",\\\"operationId\\\":\\\"4247600_2_82298148\\\",\\\"updateTime\\\":\\\"2026-10-03T11:45:10.901-04:00\\\",\\\"transactionTime\\\":\\\"2026-10-03T11:45:10.000-04:00\\\",\\\"userId\\\":\\\"huidubet_h72add19\\\",\\\"txns\\\":[{\\\"isOddsChanged\\\":false,\\\"licenseeTxId\\\":\\\"c58cd53a-7ec2-47f9-87de-a733c8738236\\\",\\\"odds\\\":1.72,\\\"actualAmount\\\":100.0,\\\"winlostDate\\\":\\\"2026-10-03T00:00:00.000-04:00\\\",\\\"txId\\\":577281013751742556,\\\"refId\\\":\\\"4247600_27671562\\\",\\\"debitAmount\\\":0.0,\\\"oddsType\\\":2,\\\"creditAmount\\\":0.0}]}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-10-03 15:45:11\", \"bet_amount\": \"0\", \"game_round\": \"1950058286659155471\", \"win_amount\": \"0\", \"currency_code\": \"INR\", \"serial_number\": \"ae54b5ea-8e61-39ae-b9a2-d3bb333bd92d\", \"member_account\": \"h72add19\"}','settled','Resolved 1 pending stake(s) as lost','2026-10-03 15:45:11'),
(18,'db99fa32-e9ca-3e2a-b04d-c1bbe567ff5c','h72add19','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78IOB4/bSM8r93ls0CNi3WcL4neTX8gysY0SW3OdyO/YwnRNVHJA3KtuC0AFiftEUOAC3AtqgRLWkl58LSJa77ba2VeZtvRqMoe14oQQh8Px4MItu6SVlofFmDYIHNl2gQdCrF4jHgZaRqWW+HFJedaeE2iqcw253KRv/6t88acInpeFaoxMjWh84ZLFj9je+8SOmoIsNPFds+n+lM87HQR9WFZnINfeBXTlNX5ix+5MeJeeL5kXH397ZX5SIgC1EWPhVePBKa0d/Zz/Q4qeCTOMPBwnkdbkoxeS4yWsPwXSOVYTZTi2d9FaAx70oAN3oDE10lHKAzYofsoQveMlq9wStIAZfecew3A8TuQtoFUvYx551+f20kQ8jTbzJJrcZ1zviSsdUQe1UxYj83az3S1tIoAY3SHAC7pKVanpLQxUuowpH5QyMgCOL0nlgt1NJskRF8qesK4HIYaBIaeL+L0uDs4a4mP3MwGUlkYOrAyjzDfrRW1lf9DQHwFU4PPoaaKb52EB0WTFE/a/3yKfGsRq+0oH53z7g/7WOC9yQCZapAXjA3SsTYkFKlEcRnrLgbx+JOD6/TpgDRfOgEUyEIh9JA5HB3c967G5oNjjuaCKUfOaBDx46XKu1TYJH6imZO/4m8G5XxLzA9fxcUFdb2HKOyxp5jNM+qeQ857Ek4No7m6cYzZ1AIpnW9kTh8W4Yk+Wekq4G3xa7y+MzrMCk3/8gL/ezC2oZyBZyPIPcSkD0cxB9YVVvY/Y9hOytspEbuc/Hnk7cKOyfFz/eOyf0qPrKrCjWD7oeD/m2zO+cJTPHSsppu4XSMu1uDz0TCdVIFFOGBtQvppux0WVDmjvv0XvsYlPZ4zzEfGwzyi3zAKXq9WitB8fAKqA5ns5VM4if0Pp1F5TYOd+kFYmLlsMoXKTzw5mSvtneVmUCY0nZ5QihAwCG0Mry0xuLq6wklSAFM+hnS05a4w5VlgEwOLr160lB5b5FI7+OJenvoU+J+N1r9RpxkRwLbszV7QQLvYKpK6xpN1ICOAH7toD22L0Pco7ZdeognubL0lXCmG9y72AL1K7sxrcYZvHl3cXHIC8TgJajhW6Obn8qMVy/zXY1LXZRw8chQmvOTUOso+erJGnyzKkWSRuntHY748ch0UM4u0wT8etfflk9c8RFgNdklj71lRZzUjLMuZn1DcfTi7lNpvF4OC+u3srs6upiefkjVxlOeuJZx4zy21YCK/ZW6Bp7qRUDIHCoyhWahqpNzCTqo9jaVx41r4oQcvppoTeu1U2PEH4oSkp6OJwex46nV94WcsvV9B3+GlpxwCyIw7aSGS/y0DWF02iA0Hiivfq/WCZWKfa61jMlFBQUBeaMaGKirJXOaanoDODPf7fBlM3ELQ94OwAMkAXVgOsxl66l7Ir1hbVRUXkL1t1BbCbixFfzqHkXGcXnTulfkwa21H5QBMbxe2sONwh5dCUJiQkAzguX+8j287nD1nas7twZHiMIyeeE8CgGJ7xCphozWLwu/uLAmch5zqXdKMT7aO+ZyiA4dqejYtkw/WXGoritJjkburZb3yPmerTtkFrBCzAVASeJci3llfwR1rVqFElC7TvMc9/hNVNgNn4mwazVaH5txydKECy0sHFeQlvOJ/MLL2JaigCS78UHB0PP8QUquzI0DP2uRKXHz86Gv2eBHZVVHGUH3c72Da+Fc6op6tIdfPbO6p2QLf6ISeBNPowzllYYxcl87+Z4r5ZCx5R+d6Vyux+VK1ThrrpFIHwp6WK9GajImm+Oxayz8nu/L+bW3xQfJGK6pxfTDhMVdTBT7YRm9buQyp0twbCK4bK5IttK5p3uH/XjxNis7jER3g7k4arc/HlfWc6vGd953QMO7PQ==\",\"timestamp\":\"1791042311614\"}','{\"data\": \"{\\\"sportTypeName_en\\\":\\\"Soccer\\\",\\\"sportTypeName\\\":\\\"Soccer\\\",\\\"oddsId\\\":1070183555,\\\"betTypeName\\\":\\\"Over/Under\\\",\\\"homeName\\\":\\\"Hodd\\\",\\\"betTeam\\\":\\\"h\\\",\\\"betTypeName_en\\\":\\\"Over/Under\\\",\\\"oddsType\\\":2,\\\"betChoice\\\":\\\"Over\\\",\\\"awayName_en\\\":\\\"Odd BK\\\",\\\"tsId\\\":\\\"\\\",\\\"point\\\":\\\"5.75\\\",\\\"point2\\\":\\\"\\\",\\\"leagueName\\\":\\\"NORWAY 1ST DIVISION\\\",\\\"isLive\\\":true,\\\"awayScore\\\":3,\\\"leagueId\\\":124,\\\"odds\\\":2.94,\\\"excluding\\\":\\\"\\\",\\\"action\\\":\\\"PlaceBet\\\",\\\"operationId\\\":\\\"4247600_1_82298152\\\",\\\"currency\\\":61,\\\"betFrom\\\":\\\"W001\\\",\\\"kickOffTime\\\":\\\"2026-10-03T09:59:00.000-04:00\\\",\\\"homeId\\\":24558,\\\"matchId\\\":134834526,\\\"oddsInfo\\\":\\\"\\\",\\\"homeScore\\\":2,\\\"matchDateTime\\\":\\\"2026-10-03T10:00:00.000-04:00\\\",\\\"leagueName_en\\\":\\\"NORWAY 1ST DIVISION\\\",\\\"sportType\\\":1,\\\"actualAmount\\\":100.0,\\\"IP\\\":\\\"86.96.106.82\\\",\\\"homeName_en\\\":\\\"Hodd\\\",\\\"awayId\\\":242578,\\\"updateTime\\\":\\\"2026-10-03T11:45:11.529-04:00\\\",\\\"debitAmount\\\":100.0,\\\"userId\\\":\\\"huidubet_h72add19\\\",\\\"betType\\\":3,\\\"awayName\\\":\\\"Odd BK\\\",\\\"betAmount\\\":100.0,\\\"baStatus\\\":false,\\\"betTime\\\":\\\"2026-10-03T11:45:11.528-04:00\\\",\\\"betRemark\\\":\\\"\\\",\\\"refId\\\":\\\"4247600_27671565\\\",\\\"creditAmount\\\":0.0,\\\"betChoice_en\\\":\\\"Over\\\"}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-10-03 15:45:11\", \"bet_amount\": \"100.0\", \"game_round\": \"16945997411165354418\", \"win_amount\": \"0\", \"currency_code\": \"INR\", \"serial_number\": \"db99fa32-e9ca-3e2a-b04d-c1bbe567ff5c\", \"member_account\": \"h72add19\"}','settled','bet=100.0 win=0 bal=800.00','2026-10-03 15:45:12'),
(19,'8cde5155-cb83-30f1-be7c-4fd46d21e22f','h72add19','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78Z54l2le1+4xossJ8ftsMpTFTBM/Blzi55cHhiCzbzMjiQOwucaSd9GVqTvxm6uUc0hc7UunJuaZE/C6WvyPw/b5x9kEZNMg31GZ+6OfeJlRCxCy2PPVYGDdCnyJekYRnGW2O8D4naRJCgpYBvte3MiYQR8KJ51kNo3UgMC9BQ+xEvO4J9TeELnbBiw9jC6xNXFIKYweETD+izQzaD/5gfMiqcUpx17CXPRMHZvGKwSXNxAMMor1LX+x7854Y8LYehWAhRIoBDcmKVtbYzwG9SQbCpwHwcboWcxAiLlhQa8Qpr9hLWFPMPykhEvcTbMu6jTD4LvCEH8wAyLiqvqfKOm75LItzMfdPcLSBFrtLVUX0mHdWkGOySt6VTsS14yva08sqAKTWBDs7/ASX0cegqicddoOtCRgQWSO6DNUV6EDrGk3UgI4Afu2gPbYvQ9yjh3OoBznaDD332h/f2iy59cgL/ezC2oZyBZyPIPcSkD1voVsis83l8iGgmdri1d9ob7nMxd+qNgg5zIEqAjIV69QkyY1npcHaJaw0E0Hfa0XGpbZv3mknhqs05cRUdonLQcCrJlUYOoEatllAYCnq1kw7H1A12eVyuQzDY+Y4vqJ2NTZbi1yHElBP43ozI5fS2HhmWBHTotnQkcH7Jx3tXk3U9hkIheXPVlw9ALmN8eNASeJci3llfwR1rVqFElC7TvMc9/hNVNgNn4mwazVaHwhiKIwLYOKoMnrlzGYfd3faUcGkJkO/13Ugaz40BjfHXCWHq6m2lnUMy50RHBF847HzYdDM4LPMinRk6stCq9gRO1a4DQ1tAsZxgqmfLhF2iThwnCUi1WsYdQ1H/3RQigg/rOJmiMTVKG4nayiIZaAGJWsZo5CmsIIu8K+3DHjctOaG6CSsQLb8DuozeBz0zHIHsS7SWl+x3uVRm7JoroCLkA7VJCvWosZSxFWGq7+8\",\"timestamp\":\"1791042311972\"}','{\"data\": \"{\\\"action\\\":\\\"ConfirmBet\\\",\\\"operationId\\\":\\\"4247600_2_82298154\\\",\\\"updateTime\\\":\\\"2026-10-03T11:45:11.887-04:00\\\",\\\"transactionTime\\\":\\\"2026-10-03T11:45:11.000-04:00\\\",\\\"userId\\\":\\\"huidubet_h72add19\\\",\\\"txns\\\":[{\\\"isOddsChanged\\\":false,\\\"licenseeTxId\\\":\\\"7eb43406-17dc-4e8a-96b4-c3dbaa1108e8\\\",\\\"odds\\\":2.94,\\\"actualAmount\\\":100.0,\\\"winlostDate\\\":\\\"2026-10-03T00:00:00.000-04:00\\\",\\\"txId\\\":577281018046709857,\\\"refId\\\":\\\"4247600_27671565\\\",\\\"debitAmount\\\":0.0,\\\"oddsType\\\":2,\\\"creditAmount\\\":0.0}]}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-10-03 15:45:11\", \"bet_amount\": \"0\", \"game_round\": \"16945997411165354418\", \"win_amount\": \"0\", \"currency_code\": \"INR\", \"serial_number\": \"8cde5155-cb83-30f1-be7c-4fd46d21e22f\", \"member_account\": \"h72add19\"}','settled','Resolved 1 pending stake(s) as lost','2026-10-03 15:45:12'),
(20,'0b241ed0-d4d1-3fb2-aacb-827023634870','h72add19','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78IOB4/bSM8r93ls0CNi3WcL4neTX8gysY0SW3OdyO/YwnRNVHJA3KtuC0AFiftEUOAC3AtqgRLWkl58LSJa77ba2VeZtvRqMoe14oQQh8Px4pxQNOEZPCzqpupcvtPil0iy1vsqG2JpkdNeCFfjffhzIpNsfSJ6xNNa1yX9JS3WeNXYtmoU0pKHzxM5SUF0HXE/CXJaFoJbIAw2TtjslhxYdlPrZ0+BHTnHnAZd9MWg1D4ZdhcsVdLWCBL3EPNTLN8eFB53JoeWe/MQM97Wke2PZDrHJGgg7nT2I9peqUM/vbjbCt8+PbR67qG8+CQffL3933tXGvZ6ThAAo2TO9a5866Jis9DjgMF4YGzOQ6V3TUMKcr1uUurG0MhOlaR5NaLpLN3CCRCWjDVgFmK1TclFOSGDmrf/pdeaZmSt4yQMwaq3LAVTpGvsEyTZ8tFcBQyXEkoUvDJuY7Xz7R0gYd2SrMOJK7Z3lDbnFowLv4v8WT7KEn5yIM2hz7aDiKdsVMmqxyVoKwf1CrlA7SP1xr8PrBNsLZu8BrpSR0HYolKnNeDDUkCXGVpWxV+53g4PKQ0vlWz4d1JQtKaakkmOsKG6WLPRfWkkLY+ylXi997opsLqagC/pxSc8UU6YYMFIVVHpmAGJE2GADQzKW/6aHl8KXxC8rID1Fi3lD4YgKIQAJjAniQkWjq0iPjxJEku4rGC0PeDsADJAF1YDrMZeupe2eHBHRgaECyu0uLbs/hvCvldwAq0EbueYZhehLSyht5mgE8gMjBzGi9U44c+ApYPS5+J8WNuTv3OBrIJCfJK4m3Beyx5IjoJLhpKIO6i2HWHeiurC6wHHzlb6hkl1gTVhJM1xUrpKMqe+j8HCqfZzYbwPx32ly0PDOZk/yEkozgUMX4OKQTKRuSmHstkeLNT88cOxcKAhrKC/+VmM2znGqfeAkcY3Yy+z1oY/V20uV2EA3mHtRqgEuo0CHABSGwnC8btixelxUcVCasTnDjgVnl+yYmnvkaL0+xunk+XY9O6XBVzTq+lNfx1AvOyyccmJxD72zPIdwqQ7st30dAH2o78lx74s+/fCabCBtoCQ6ZOnEp9RYfP8F1jk05zpEj5Zj5yFNX0KxqMwPOFDlM/WdWLyh2wn+z1ZLrUaGJC0e4c8z1Mt4L1WSUAXo1S5HzqqN0EPTkfPzoVJmQnwMYYNepbizjYeWP/07IUnUS79lkImzeNOb9UOaKjR7LDVzuFGRLTDcmuYeIflk7lv95Yk+v9H4dAbhz/oK9vnAU75Obz20UdOBxxumvsGk/UTqefmLOFOUuWkJwKIofhQztHqmrTfv3f3lQuc2Q0cjjN2IZJix3tVBCUvnZoX3huJrcFAnxe15xPZgZW+QtdnxUzKkqmIbqdHNKwOaGuJG8e7kCYkvhS7dN5MyFhf3tNI/8P82N8CcVCS4ieHjs2nZpySHBXouJFDmCMCp1nZwwXC670fyuNRaRzr1TJHCUV+8Aac+a2NTK0QpA3wo+DCnARyOlFPhsg47mKuy2SgNZjZy020JTEOSQOck3Tvcp1+it9yYW9q+N54bVnk9z+Mw3c6ARPuylZX9XxHRIXyCg1k63//wnlbSHozuQTReRFv235Xj5LZUi9+xRgKSvSm6bf7eLZQWg+fDpq2OQkqdtUzB62MjeujR0sHN6IJoH/PRTA5TbMcS1LuEkgG/bqesRGk+f0VKJLCp7ZIRgjg8ygP9oUjKwpt0rM1VQUE64pAugFMDvscMGOjf3+6XSXd1Z+rI03ZdH5yutEUjZ8fWGAbr4yubCw0I/qMQGYr2wqprRlXFW4kswVB8OxVZ0sj+cqz3jVWvyXH7K3jk+yHF0nhrt\",\"timestamp\":\"1791042312719\"}','{\"data\": \"{\\\"sportTypeName_en\\\":\\\"Soccer\\\",\\\"sportTypeName\\\":\\\"Soccer\\\",\\\"oddsId\\\":1070183553,\\\"betTypeName\\\":\\\"FT.1X2\\\",\\\"homeName\\\":\\\"Hodd\\\",\\\"betTeam\\\":\\\"1\\\",\\\"betTypeName_en\\\":\\\"FT.1X2\\\",\\\"oddsType\\\":3,\\\"betChoice\\\":\\\"Hodd\\\",\\\"awayName_en\\\":\\\"Odd BK\\\",\\\"tsId\\\":\\\"\\\",\\\"point\\\":\\\"\\\",\\\"point2\\\":\\\"\\\",\\\"leagueName\\\":\\\"NORWAY 1ST DIVISION\\\",\\\"isLive\\\":true,\\\"awayScore\\\":3,\\\"leagueId\\\":124,\\\"odds\\\":80.0,\\\"excluding\\\":\\\"\\\",\\\"action\\\":\\\"PlaceBet\\\",\\\"operationId\\\":\\\"4247600_1_82298155\\\",\\\"currency\\\":61,\\\"betFrom\\\":\\\"W001\\\",\\\"kickOffTime\\\":\\\"2026-10-03T09:59:00.000-04:00\\\",\\\"homeId\\\":24558,\\\"matchId\\\":134834526,\\\"oddsInfo\\\":\\\"\\\",\\\"homeScore\\\":2,\\\"matchDateTime\\\":\\\"2026-10-03T10:00:00.000-04:00\\\",\\\"leagueName_en\\\":\\\"NORWAY 1ST DIVISION\\\",\\\"sportType\\\":1,\\\"actualAmount\\\":100.0,\\\"IP\\\":\\\"86.96.106.82\\\",\\\"homeName_en\\\":\\\"Hodd\\\",\\\"awayId\\\":242578,\\\"updateTime\\\":\\\"2026-10-03T11:45:12.280-04:00\\\",\\\"debitAmount\\\":100.0,\\\"userId\\\":\\\"huidubet_h72add19\\\",\\\"betType\\\":5,\\\"awayName\\\":\\\"Odd BK\\\",\\\"betAmount\\\":100.0,\\\"baStatus\\\":false,\\\"betTime\\\":\\\"2026-10-03T11:45:12.280-04:00\\\",\\\"betRemark\\\":\\\"\\\",\\\"refId\\\":\\\"4247600_27671566\\\",\\\"creditAmount\\\":0.0,\\\"betChoice_en\\\":\\\"Hodd\\\"}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-10-03 15:45:12\", \"bet_amount\": \"100.0\", \"game_round\": \"7710953213843223559\", \"win_amount\": \"0\", \"currency_code\": \"INR\", \"serial_number\": \"0b241ed0-d4d1-3fb2-aacb-827023634870\", \"member_account\": \"h72add19\"}','settled','bet=100.0 win=0 bal=700.00','2026-10-03 15:45:13'),
(21,'974947c8-7003-37ec-b71c-b06658125812','h72add19','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78Z54l2le1+4xossJ8ftsMpTFTBM/Blzi55cHhiCzbzMjiQOwucaSd9GVqTvxm6uUc0hc7UunJuaZE/C6WvyPw/ZQ9w0XVB5imVIKbac9UmyBCxCy2PPVYGDdCnyJekYRnT8hZpFLX6RbLkCT8hrcdtII46hf4EXAbphfvEX46s4NEvO4J9TeELnbBiw9jC6xNXFIKYweETD+izQzaD/5gfP43A+UFj8lk93DwibhhmY3NxAMMor1LX+x7854Y8LYehWAhRIoBDcmKVtbYzwG9SQbCpwHwcboWcxAiLlhQa8Qpr9hLWFPMPykhEvcTbMu6jTD4LvCEH8wAyLiqvqfKOrcTq5yYQh4rYJPFdWS03TlSMNC4L6RzAF1z5mZyUtQnXCeydH+Ig5kA/BsTfdOcekQMJ+QxvBT/xxYP6HKs0uDrGk3UgI4Afu2gPbYvQ9yjh3OoBznaDD332h/f2iy59cgL/ezC2oZyBZyPIPcSkD1voVsis83l8iGgmdri1d9ob7nMxd+qNgg5zIEqAjIV6y/6hLVuJdb63xjpwp8jp/nGpbZv3mknhqs05cRUdonLrF8kEWo1FiE8m4HlW2Z9Wkw7H1A12eVyuQzDY+Y4vqJ2NTZbi1yHElBP43ozI5fS6xLliov3U/ogvnGzm1zQOU3U9hkIheXPVlw9ALmN8ePN0rL1dw8zxOQWVT7XVYENmdX/SN54rogGXKWkupF23a3NYPc4kNGIAE4/CJuM9lpf4ULxrL2AxXY0PAnIY1DAxFZxc+4nzYp/5uG0BKesCOyFeTtw0Cwroiu1pUbOE8xTH9qjH380l59OFLC+I913OzpBs/+x/VN9SDB25oKj77dyU7lt2WaQJx6hZPEC82Cl0SQ6jta5QHcSwrutvjAUadtvoxRlxvgm9yrOrupH1C8KxNp6f4HI36OkJx9AKZAKQ6u5h5Rp9SmDsLU8ufze\",\"timestamp\":\"1791042313325\"}','{\"data\": \"{\\\"action\\\":\\\"ConfirmBet\\\",\\\"operationId\\\":\\\"4247600_2_82298181\\\",\\\"updateTime\\\":\\\"2026-10-03T11:45:12.884-04:00\\\",\\\"transactionTime\\\":\\\"2026-10-03T11:45:12.000-04:00\\\",\\\"userId\\\":\\\"huidubet_h72add19\\\",\\\"txns\\\":[{\\\"isOddsChanged\\\":false,\\\"licenseeTxId\\\":\\\"f943b2fe-10af-423c-a379-b07ee76d76d6\\\",\\\"odds\\\":80.0,\\\"actualAmount\\\":100.0,\\\"winlostDate\\\":\\\"2026-10-03T00:00:00.000-04:00\\\",\\\"txId\\\":577281022341677146,\\\"refId\\\":\\\"4247600_27671566\\\",\\\"debitAmount\\\":0.0,\\\"oddsType\\\":3,\\\"creditAmount\\\":0.0}]}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-10-03 15:45:13\", \"bet_amount\": \"0\", \"game_round\": \"7710953213843223559\", \"win_amount\": \"0\", \"currency_code\": \"INR\", \"serial_number\": \"974947c8-7003-37ec-b71c-b06658125812\", \"member_account\": \"h72add19\"}','settled','Resolved 1 pending stake(s) as lost','2026-10-03 15:45:13'),
(22,'f0ac4757-cc67-3b26-b94a-879d6d935c1d','h72add19','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78Z54l2le1+4xossJ8ftsMpabehKixK+1t0sp3eaaKB4YWD8V0cIUu8wbhCl4Q3n7cC+v+uXIuP9EwQOgrcS6g/Cy9QbbZ6910YFx9VpP/Y0pVo9eAwqCPWBFz42efs4/nyAv97MLahnIFnI8g9xKQPTOJC70YDNLKWYxPc3C8rB7JhTYLTxeCOYVVri+jDP/4Qbo8zT8+K2cKeqyfuQHkEh8wnKz4XiQP+qwiNtpBGwnUVQUfFYuO0GIOHRSph4II4Fawvz5uFYW+1MBd39zqqV6d0jzw9zpaLcFSjOMHmfF+gzK6YeTMmm0Cqa9MqFsSXcJDpbWV7pDp5ouqjnWul8eaVn+Y1wJlQ3e1vrmrJ+HBXouJFDmCMCp1nZwwXC677UBJjmESMgsZGlaV5R9YIsZA8QfrisNPPr3STM+Ku2Vw0e9nxzDczRuEiq1sky5lq5rnD5uzPqrwFzyFWAJ/6pxSZv3G9Gma/TE1cfeKSYfQ/gdrYSmOla5B2r5q8m88fCJRRdU6pMr7H6ZZS3WAcSbK8yT3Fqm3VgmyHxfxcbUwpELN+Z020ik4W01D3vjhK0mkKqDYTbO1rgSD4ZMbgeL74aapaEThj7kQ30HfuL7LzL69tUmaGl/6o/MDWw3yVSNl9pxoSc85Bhstzi7DzU5IzaOwvipSTtx059sMAe2WKAQ5EgTU8fnzwEqXVcC3K1AtWh1q50zu1fzhz0KAKfcOSLCEqF8UHvSpfnmF7NK/xiZwlEV3XeuL4xX786cXjvtFiFDgaRgKWrsGtKh/UfxgiDUc0/GF7hSQfUTcx10Ippm8Ygb28kJMcF06xCVYzrLbuL8FFwqer0kA76/CTN2FYnSUFEUSUatnF10qCQg=\",\"timestamp\":\"1791042991399\"}','{\"data\": \"{\\\"action\\\":\\\"Settle\\\",\\\"operationId\\\":\\\"4247600_4_82299742\\\",\\\"txns\\\":[{\\\"settlementTime\\\":\\\"2026-10-03T11:56:24.403\\\",\\\"winlostDate\\\":\\\"2026-10-03T00:00:00.000-04:00\\\",\\\"payout\\\":0.0000,\\\"txId\\\":577281013751742556,\\\"updateTime\\\":\\\"2026-10-03T11:56:28.835-04:00\\\",\\\"refId\\\":\\\"4247600_27671562\\\",\\\"debitAmount\\\":0.0000,\\\"creditAmount\\\":0.0000,\\\"userId\\\":\\\"huidubet_h72add19\\\",\\\"extraStatus\\\":\\\"\\\",\\\"status\\\":\\\"lose\\\"}]}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-10-03 15:56:31\", \"bet_amount\": \"0.0000\", \"game_round\": \"1950058286659155471\", \"win_amount\": \"0.0000\", \"currency_code\": \"INR\", \"serial_number\": \"f0ac4757-cc67-3b26-b94a-879d6d935c1d\", \"member_account\": \"h72add19\"}','heartbeat','Balance sync','2026-10-03 15:56:32'),
(23,'9a9589fe-455f-30be-828b-5e1a9cd2a8a8','h72add19','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78Z54l2le1+4xossJ8ftsMpabehKixK+1t0sp3eaaKB4YWD8V0cIUu8wbhCl4Q3n7cC+v+uXIuP9EwQOgrcS6g/Cy9QbbZ6910YFx9VpP/Y0pVo9eAwqCPWBFz42efs4/nyAv97MLahnIFnI8g9xKQPTOJC70YDNLKWYxPc3C8rB7JhTYLTxeCOYVVri+jDP/4Qbo8zT8+K2cKeqyfuQHkEh8wnKz4XiQP+qwiNtpBGwnUVQUfFYuO0GIOHRSph4II4Fawvz5uFYW+1MBd39zqqZcXWboGqItMArSltC0LWX9+gzK6YeTMmm0Cqa9MqFsSXcJDpbWV7pDp5ouqjnWul8eaVn+Y1wJlQ3e1vrmrJ+HBXouJFDmCMCp1nZwwXC67FCJsgSiuAbuF6yJ9zP9oh8ZA8QfrisNPPr3STM+Ku2Vw0e9nxzDczRuEiq1sky5lq5rnD5uzPqrwFzyFWAJ/6pxSZv3G9Gma/TE1cfeKSYfQ/gdrYSmOla5B2r5q8m88fCJRRdU6pMr7H6ZZS3WAcSbK8yT3Fqm3VgmyHxfxcbUwpELN+Z020ik4W01D3vjhQEniXIt5ZX8Eda1ahRJQu07zHPf4TVTYDZ+JsGs1Wh+ghosQkkRDodC2lCemYx7TtGzUVAJ5mqP3ouDydTgWgjP7xnIwbadvD+nuubZSjHtFWYHhhh/KNFlEg6Zv3dETYceTz9IDeIZf0ZbqH8XETuOtiH9xM3kEFDbFyZEAIXoxv6ZxpNKJjRt/dazWENOvnglRn3wpCtYDRteHR7SSRUU3qoqVf8iRl55Mko3s22tJoH+bc+eDFlW0C0pSL9eQWdUNlXoj+VM08P3PNeuGRT38w/P/sxqLfDrsQku9fN4=\",\"timestamp\":\"1791042991581\"}','{\"data\": \"{\\\"action\\\":\\\"Settle\\\",\\\"operationId\\\":\\\"4247600_4_82299742\\\",\\\"txns\\\":[{\\\"settlementTime\\\":\\\"2026-10-03T11:56:24.403\\\",\\\"winlostDate\\\":\\\"2026-10-03T00:00:00.000-04:00\\\",\\\"payout\\\":0.0000,\\\"txId\\\":577281018046709857,\\\"updateTime\\\":\\\"2026-10-03T11:56:28.835-04:00\\\",\\\"refId\\\":\\\"4247600_27671565\\\",\\\"debitAmount\\\":0.0000,\\\"creditAmount\\\":0.0000,\\\"userId\\\":\\\"huidubet_h72add19\\\",\\\"extraStatus\\\":\\\"\\\",\\\"status\\\":\\\"lose\\\"}]}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-10-03 15:56:31\", \"bet_amount\": \"0.0000\", \"game_round\": \"16945997411165354418\", \"win_amount\": \"0.0000\", \"currency_code\": \"INR\", \"serial_number\": \"9a9589fe-455f-30be-828b-5e1a9cd2a8a8\", \"member_account\": \"h72add19\"}','heartbeat','Balance sync','2026-10-03 15:56:32'),
(24,'41d15972-67b4-3ad3-b379-b7b01bd2ef37','h72add19','08ced9dd788aed11ff3c7f387ae0f063','{\"agency_uid\":\"d28a8d5f4fa53910826caa6640925239\",\"payload\":\"doaoCKAhtUjI0SIKxfD4GPG5EQk+FYe9KWxOKodv+8ADuwrc+Mdf3SlT0nSkDo78Z54l2le1+4xossJ8ftsMpabehKixK+1t0sp3eaaKB4YWD8V0cIUu8wbhCl4Q3n7cC+v+uXIuP9EwQOgrcS6g/Cy9QbbZ6910YFx9VpP/Y0pVo9eAwqCPWBFz42efs4/nyAv97MLahnIFnI8g9xKQPT/77/bNvpaO+wZPVHpUYYWkGKKWd+aaYN7dAt4MwgO+jhBOEk+1WUKt+TXtrBdtFw/SXikjngktkIbynVvKy9P7WYSwnctxu65oTKxga8VerE98kKoRCqdI/qzueTu7uVXbc2YuxoPslkfRGv/qSxOCiqq2OwKGQn0TWuyj5hHsBIrI67uElhoWdxXW4CG+swSy74QV8jXh5DazssORSLEBLyU/YeIkhHujxRgyvaLCTwvfWdQTGdJL56TFsjI/puVt5BgOwz0EVIds3z0niwC2VGZ72yYYswZqzgk6HU+Bdmgez1AZbFAnOAw19FVn9Z7qRUDIHCoyhWahqpNzCTqo9jaVx41r4oQcvppoTeu1TY7mq/NenZPdIILZ6cwT000RPXyig86+3jfdyoZMdSFLfNfJ8RjN9kgD/SJl8qqcmsLB2xQPu/9NHgLwvT5FWdIyCnM5MpDY4aZTrUMiWmmjmd8CvBYWLIwq81c51DC46bRFGOsw+cDNKQtgrV/KTuRpHZVJrzHTlK2L9y9xelbq2FNfNl1EMgxUq9vwOhF+ivWBJtC37Sv07hVv5+RIXDG7KUcAFQ30GVvCei0B7029cy3lbBGXTn9syXRipfwY+lBX5wWAqOjRAIxF36r9JbjZNsWcNXV3EkoeDYFk2HRFG1j7v1GopR9y6Pw5fyu+PJjFp40NFwYlN2cOJrBl04UpMn80wwBndFSgKDMm5Os=\",\"timestamp\":\"1791042991623\"}','{\"data\": \"{\\\"action\\\":\\\"Settle\\\",\\\"operationId\\\":\\\"4247600_4_82299742\\\",\\\"txns\\\":[{\\\"settlementTime\\\":\\\"2026-10-03T11:56:24.36\\\",\\\"winlostDate\\\":\\\"2026-10-03T00:00:00.000-04:00\\\",\\\"payout\\\":0.0000,\\\"txId\\\":577281022341677146,\\\"updateTime\\\":\\\"2026-10-03T11:56:28.836-04:00\\\",\\\"refId\\\":\\\"4247600_27671566\\\",\\\"debitAmount\\\":0.0000,\\\"creditAmount\\\":0.0000,\\\"userId\\\":\\\"huidubet_h72add19\\\",\\\"extraStatus\\\":\\\"\\\",\\\"status\\\":\\\"lose\\\"}]}\", \"game_uid\": \"08ced9dd788aed11ff3c7f387ae0f063\", \"timestamp\": \"2026-10-03 15:56:31\", \"bet_amount\": \"0.0000\", \"game_round\": \"7710953213843223559\", \"win_amount\": \"0.0000\", \"currency_code\": \"INR\", \"serial_number\": \"41d15972-67b4-3ad3-b379-b7b01bd2ef37\", \"member_account\": \"h72add19\"}','heartbeat','Balance sync','2026-10-03 15:56:32');

/*!40000 ALTER TABLE `game_callback_logs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `game_categories`
--

DROP TABLE IF EXISTS `game_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `slug` varchar(50) NOT NULL,
  `icon_url` varchar(500) DEFAULT NULL,
  `is_sports` tinyint(1) NOT NULL DEFAULT '0',
  `is_delayed_settlement` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `idx_game_categories_active` (`is_active`),
  KEY `idx_game_categories_sort` (`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_categories`
--

LOCK TABLES `game_categories` WRITE;
/*!40000 ALTER TABLE `game_categories` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `game_categories` VALUES
(1,'All Games','all_games',NULL,0,0,1,1,'2026-09-14 18:05:02','2026-09-14 18:05:02'),
(2,'Slots','slots',NULL,0,0,1,2,'2026-09-14 18:05:02','2026-09-14 18:05:02'),
(3,'Live Casino','live_casino',NULL,0,0,1,3,'2026-09-14 18:05:02','2026-09-14 18:05:02'),
(4,'Sports','sports',NULL,1,1,1,4,'2026-09-14 18:05:02','2026-09-14 18:05:02'),
(5,'Lottery','lottery',NULL,0,1,1,5,'2026-09-14 18:05:02','2026-09-14 18:05:02'),
(6,'AI Games','ai_games',NULL,0,0,1,6,'2026-09-14 18:05:02','2026-09-14 18:05:02'),
(7,'Fantasy','fantasy',NULL,0,1,1,7,'2026-09-14 18:05:02','2026-09-14 18:05:02'),
(8,'Virtual Sports','virtual_sports',NULL,1,1,1,8,'2026-09-14 18:05:02','2026-09-14 18:05:02');

/*!40000 ALTER TABLE `game_categories` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `game_providers`
--

DROP TABLE IF EXISTS `game_providers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_providers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(50) NOT NULL,
  `logo_url` varchar(500) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `agency_uid` varchar(100) DEFAULT NULL,
  `aes_secret_key` varchar(128) DEFAULT NULL,
  `server_url` varchar(255) DEFAULT NULL,
  `launch_path` varchar(100) DEFAULT NULL,
  `player_prefix` varchar(40) DEFAULT NULL,
  `callback_path` varchar(100) DEFAULT NULL,
  `currency_code` varchar(10) DEFAULT NULL,
  `delayed_settlement` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_providers`
--

LOCK TABLES `game_providers` WRITE;
/*!40000 ALTER TABLE `game_providers` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `game_providers` VALUES
(1,'Arcade','arcade','',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-06-26 06:58:40'),
(2,'Esports','esports','',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-06-26 06:58:40'),
(3,'Instant Games','instant','',1,NULL,NULL,NULL,NULL,NULL,NULL,'USD',0,'2026-06-26 06:58:40'),
(4,'Live Casino','live','',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-06-26 06:58:40'),
(5,'Poker','poker','',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-06-26 06:58:40'),
(6,'Slots','slots','',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-06-26 06:58:40'),
(7,'Sportsbook','sports','',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-06-26 06:58:40'),
(8,'India Lotto','India-lotto','',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-07-15 11:02:55'),
(9,'Odin Cockfighting','odin-cockfighting','',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-07-15 11:35:01'),
(10,'Smartsoft','smartsoft',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(11,'Spribe','spribe',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(12,'PG Soft','pg-soft',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(13,'Galaxsys','galaxsys',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(14,'MAC88','mac88',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(15,'Veliplay','veliplay',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(16,'turbogamesasia','turbo-games',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(17,'18 Peaches','18-peaches',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(18,'Aura Gaming','aura-gaming',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(19,'CasinoLive','casinolive',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(20,'Evolution Live','evolution-live',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(21,'TADAgaming','tada-gaming',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(22,'GILIgaming','gili-gaming',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(23,'India Poker Game','india-poker',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(24,'IN OUT MINI GAMES','in-out-games',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(25,'Fish Game','fish-game',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(26,'iDeal','ideal',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(27,'PgsGaming','pgs-gaming',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(28,'LuckSportsGame','luck-sports',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(29,'Slot Game','slot-game',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:23:22'),
(30,'SportsGame','sportsgame',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:36:53'),
(31,'aviatrix','aviatrix',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:36:53'),
(32,'jilli','jilli',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-09-11 14:36:53');

/*!40000 ALTER TABLE `game_providers` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `game_rounds`
--

DROP TABLE IF EXISTS `game_rounds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_rounds` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `session_id` bigint unsigned DEFAULT NULL,
  `user_id` bigint unsigned NOT NULL,
  `game_id` bigint unsigned DEFAULT NULL,
  `game_uid` varchar(64) NOT NULL,
  `game_name` varchar(150) DEFAULT NULL,
  `serial_number` varchar(100) NOT NULL,
  `stake_serial` varchar(100) DEFAULT NULL,
  `game_round` varchar(100) DEFAULT NULL,
  `settle_status` enum('pending','settled') NOT NULL DEFAULT 'settled',
  `settled_at` datetime DEFAULT NULL,
  `bet_amount` decimal(20,2) DEFAULT '0.00',
  `win_amount` decimal(20,2) DEFAULT '0.00',
  `balance_before` decimal(20,2) DEFAULT NULL,
  `balance_after` decimal(20,2) DEFAULT NULL,
  `currency` varchar(10) DEFAULT 'USD',
  `provider_timestamp` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `serial_number` (`serial_number`),
  UNIQUE KEY `stake_serial` (`stake_serial`),
  KEY `session_id` (`session_id`),
  KEY `game_id` (`game_id`),
  KEY `idx_gr_user` (`user_id`),
  KEY `idx_gr_game_uid` (`game_uid`),
  KEY `idx_gr_created` (`created_at`),
  KEY `idx_gr_settle` (`settle_status`),
  KEY `idx_gr_round` (`user_id`,`game_round`),
  KEY `idx_gr_win` (`win_amount`,`created_at`),
  CONSTRAINT `game_rounds_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `game_sessions` (`id`) ON DELETE SET NULL,
  CONSTRAINT `game_rounds_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `game_rounds_ibfk_3` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_rounds`
--

LOCK TABLES `game_rounds` WRITE;
/*!40000 ALTER TABLE `game_rounds` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `game_rounds` VALUES
(1,3,7,269,'92b24e4c25107367a80e0fe1a97c24e4','Luck Sports','1c9619c6-d3e1-3245-ac36-f354900c02cb',NULL,'7638492209151163792','settled','2026-09-23 04:10:34',1100.00,0.00,50000.00,48900.00,'USD','2026-09-22 12:48:38','2026-09-22 12:48:39'),
(2,4,7,269,'92b24e4c25107367a80e0fe1a97c24e4','Luck Sports','2fbdf3fb-9b21-3bde-9bd8-38b5e8516356',NULL,'7638492209151163792','settled','2026-09-23 04:10:34',0.00,2100.00,48900.00,51000.00,'USD','2026-09-23 04:10:32','2026-09-23 04:10:34'),
(3,5,9,262,'08ced9dd788aed11ff3c7f387ae0f063','SABA Sports','834d664c-69f7-3bad-ac23-46451103a79a',NULL,'12289102292563017319','settled','2026-09-26 07:44:55',100.00,0.00,50000.00,49900.00,'USD','2026-09-26 07:44:54','2026-09-26 07:44:54'),
(4,6,16,262,'08ced9dd788aed11ff3c7f387ae0f063','SABA Sports','22414963-a15c-39f5-a5b1-ebe7972a12c6',NULL,'9498915378785173438','settled','2026-09-26 07:51:02',100.00,0.00,1000.00,900.00,'USD','2026-09-26 07:51:01','2026-09-26 07:51:02'),
(5,5,9,262,'08ced9dd788aed11ff3c7f387ae0f063','SABA Sports','f8691b6e-e059-30cc-a93b-d1535b999e16',NULL,'12289102292563017319','settled','2026-09-26 07:56:07',0.00,266.00,49900.00,50166.00,'USD','2026-09-26 07:56:07','2026-09-26 07:56:07'),
(6,7,5,262,'08ced9dd788aed11ff3c7f387ae0f063','SABA Sports','a557d5ae-84ff-32c3-a772-df87d13a99cf',NULL,'8333090203229434728','settled','2026-09-26 17:59:13',100.00,0.00,100.00,0.00,'USD','2026-09-26 17:59:12','2026-09-26 17:59:13'),
(7,7,5,262,'08ced9dd788aed11ff3c7f387ae0f063','SABA Sports','9b1793de-e8dd-3e8f-b780-58e66f2f8eaf',NULL,'8333090203229434728','settled','2026-09-26 18:34:51',0.00,148.00,0.00,148.00,'USD','2026-09-26 18:34:50','2026-09-26 18:34:51'),
(8,15,20,NULL,'88317b0c9ebdb820791b9a04f7f4cb53',NULL,'4753242e-4c8a-3835-a848-83fc5dc00abd',NULL,'10332843678789745070','settled','2026-10-02 19:48:21',20.00,0.00,100.00,80.00,'USD','2026-10-02 19:48:20','2026-10-02 19:48:21'),
(9,15,20,NULL,'88317b0c9ebdb820791b9a04f7f4cb53',NULL,'0879f04e-0813-39c1-bbd9-1079f10c05a0',NULL,'10332843678789745070','settled','2026-10-02 19:48:39',0.00,30.00,80.00,110.00,'USD','2026-10-02 19:48:38','2026-10-02 19:48:39'),
(10,16,19,262,'08ced9dd788aed11ff3c7f387ae0f063','SABA Sports','212a8daa-70ce-36f1-b289-77dd2fbabe4a',NULL,'17179854086231438714','settled','2026-10-03 15:42:56',100.00,0.00,1000.00,900.00,'USD','2026-10-03 15:42:55','2026-10-03 15:42:55'),
(11,16,19,262,'08ced9dd788aed11ff3c7f387ae0f063','SABA Sports','d0eb4f19-7738-307f-820f-8338b8eaac38',NULL,'17179854086231438714','settled','2026-10-03 15:42:56',0.00,100.00,900.00,1000.00,'USD','2026-10-03 15:42:56','2026-10-03 15:42:56'),
(12,16,19,262,'08ced9dd788aed11ff3c7f387ae0f063','SABA Sports','84295924-9b42-37f9-a56e-ee4f4e81da97',NULL,'1950058286659155471','settled','2026-10-03 15:45:11',100.00,0.00,1000.00,900.00,'USD','2026-10-03 15:45:10','2026-10-03 15:45:11'),
(13,16,19,262,'08ced9dd788aed11ff3c7f387ae0f063','SABA Sports','db99fa32-e9ca-3e2a-b04d-c1bbe567ff5c',NULL,'16945997411165354418','settled','2026-10-03 15:45:12',100.00,0.00,900.00,800.00,'USD','2026-10-03 15:45:11','2026-10-03 15:45:12'),
(14,16,19,262,'08ced9dd788aed11ff3c7f387ae0f063','SABA Sports','0b241ed0-d4d1-3fb2-aacb-827023634870',NULL,'7710953213843223559','settled','2026-10-03 15:45:13',100.00,0.00,800.00,700.00,'USD','2026-10-03 15:45:12','2026-10-03 15:45:13');

/*!40000 ALTER TABLE `game_rounds` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `game_sessions`
--

DROP TABLE IF EXISTS `game_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_sessions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `session_uid` varchar(64) NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `game_id` bigint unsigned DEFAULT NULL,
  `game_uid` varchar(64) NOT NULL,
  `game_name` varchar(150) NOT NULL,
  `member_account` varchar(100) NOT NULL,
  `launch_url` text,
  `currency` varchar(10) DEFAULT 'USD',
  `total_bet` decimal(20,2) DEFAULT '0.00',
  `total_win` decimal(20,2) DEFAULT '0.00',
  `profit_loss` decimal(20,2) DEFAULT '0.00',
  `rounds_count` int DEFAULT '0',
  `pending_rounds` int NOT NULL DEFAULT '0',
  `last_balance` decimal(20,2) DEFAULT NULL,
  `status` enum('wait','profit','loss') DEFAULT 'wait',
  `last_played_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_uid` (`session_uid`),
  KEY `game_id` (`game_id`),
  KEY `idx_gs_user` (`user_id`),
  KEY `idx_gs_member` (`member_account`),
  KEY `idx_gs_game_uid` (`game_uid`),
  KEY `idx_gs_user_game` (`user_id`,`game_uid`),
  CONSTRAINT `game_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `game_sessions_ibfk_2` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_sessions`
--

LOCK TABLES `game_sessions` WRITE;
/*!40000 ALTER TABLE `game_sessions` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `game_sessions` VALUES
(1,'GS06318b60d56c4ea7b4cf8327',6,17,'a04d1f3eb8ccec8a4823bdf18e3f0e84','Aviator','h72add6','https://launch.spribegaming.com/aviator?user=110967610&token=03acbbcda00e4da78a200d3d2db11900&lang=en&currency=INR&operator=tigergamesvtwo&return_url=https%3A%2F%2Fcadiplay.com','USDT',0.00,0.00,0.00,0,0,NULL,'wait',NULL,'2026-09-19 19:57:45','2026-09-21 07:01:01'),
(2,'GS1bbd8c946f43487bac6955aa',6,266,'8cc99bed98c7adbe84bdaf7a8ad0c084','Cockfight','h72add6','https://jump.qwe3c4d.xyz?hash=eyJwbGF5ZXJfdG9rZW4iOiJleUpoYkdjaU9pSklVekkxTmlKOS5leUpwWkNJNk56UTJPRFEzTURnc0ltVnRZV2xzSWpvaUlpd2laWGh3SWpveE56ZzVPVE0wTmpZeGZRLmI2SkY3TERnRnplYzJPR0lYMkM2b3ZzU2VZdUEyYkN3bGdDaEFfMG5UdkEiLCJsYW5nIjoiZW4iLCJlbnRyeSI6IjEiLCJ2YWxpZGF0aW9uIjoiMjg5YmU2N2Q2YzQ3ZjE1OTZmMWU2ZGMwYzlkYmMwNTQiLCJ1cmxzIjpbImh0dHBzOi8vd3d3Lm9kaW5hMC5saXZlIl0sImN1cnJlbmN5IjoiSU5SIiwiY3VzdG9tX2xvZ28iOiJvZGluIiwidGhlbWUiOiJUaGVtZV8yMDI0XzMiLCJ0aGVtZV9jb2xvciI6ImJyb3duIn0=','USDT',0.00,0.00,0.00,0,0,NULL,'wait',NULL,'2026-09-19 20:04:22','2026-09-19 20:04:22'),
(3,'GS39dde56a218a47edb34dabe4',7,269,'92b24e4c25107367a80e0fe1a97c24e4','Luck Sports','h72add7','https://sprodm.uni247.xyz?access_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMWMyZTk2MzctMjdlMy00OTIzLTgxZWYtMjJmNGIzYTE4NmViIiwicGxheWVyX2lkIjoiaDcyYWRkNyIsIm1lcmNoYW50X2NvZGUiOiJjbXQtaGQtc3ViLTkxcjJjNCIsImlzc3VlZF9hdCI6IjIwMjYtMDktMjJUMTI6NDg6MTYuMDI4OTU0MzYxWiIsImV4cGlyZXNfYXQiOiIyMDI2LTA5LTIyVDE1OjQ4OjE2LjAyODk1NDQyMVoiLCJsYW5ndWFnZSI6ImVuIn0.Xu7WGb7xwSv995ZWyoyEC4KEKbTI9kj5NMHXugdq3EA','USDT',1100.00,0.00,-1100.00,1,0,48900.00,'loss','2026-09-22 12:48:39','2026-09-22 12:48:16','2026-09-23 04:10:34'),
(4,'GSb69cab9ba4044c4fb27d6d68',7,269,'92b24e4c25107367a80e0fe1a97c24e4','Luck Sports','h72add7','https://sprodm.uni247.xyz?access_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMWMyZTk2MzctMjdlMy00OTIzLTgxZWYtMjJmNGIzYTE4NmViIiwicGxheWVyX2lkIjoiaDcyYWRkNyIsIm1lcmNoYW50X2NvZGUiOiJjbXQtaGQtc3ViLTkxcjJjNCIsImlzc3VlZF9hdCI6IjIwMjYtMDktMjJUMTI6NDg6NTEuNTM5NTc3ODQzWiIsImV4cGlyZXNfYXQiOiIyMDI2LTA5LTIyVDE1OjQ4OjUxLjUzOTU3Nzg5M1oiLCJsYW5ndWFnZSI6ImVuIn0.qyYQEqhoKXJv1T82kTxY8L5NcTLXaDJ7NVRr1a_W_04','USDT',0.00,2100.00,2100.00,1,0,51000.00,'profit','2026-09-23 04:10:34','2026-09-22 12:48:52','2026-09-23 04:10:34'),
(5,'GSe39d946b6a9e4c95888705a8',9,262,'08ced9dd788aed11ff3c7f387ae0f063','SABA Sports','h72add9','https://r9p2ob.lcje6yh7.com/DepositProcessLogin?token=ZeGkMlqRZEmL8S2TmKKrew&lang=en&WebSkinType=7','USDT',100.00,266.00,166.00,2,0,50166.00,'profit','2026-09-26 07:56:07','2026-09-26 07:44:21','2026-09-26 07:56:07'),
(6,'GS393e853292944ea38c9190a6',16,262,'08ced9dd788aed11ff3c7f387ae0f063','SABA Sports','h72add16','https://r9p2ob.lckvgy9a.com/DepositProcessLogin?token=UQD0RpHT6EWTxNKLaoKj8g&lang=en&WebSkinType=7','USDT',100.00,0.00,-100.00,1,0,900.00,'loss','2026-09-26 07:51:02','2026-09-26 07:50:18','2026-09-26 07:51:02'),
(7,'GSb77f760435d247ce81464b38',5,262,'08ced9dd788aed11ff3c7f387ae0f063','SABA Sports','h72add5','https://r9p2ob.lcdqhjqk.com/DepositProcessLogin?token=ZVNQTIUBT02aanTx10KK9Q&lang=en&WebSkinType=7','USDT',100.00,148.00,48.00,2,0,148.00,'profit','2026-09-26 18:34:51','2026-09-26 07:57:47','2026-09-26 18:34:51'),
(8,'GSc478e334e30d4d3f93114b04',5,262,'08ced9dd788aed11ff3c7f387ae0f063','SABA Sports','h72add5','https://r9p2ob.lcdqhjqk.com/DepositProcessLogin?token=1Zv9G1FL/0OIbTp0zwYnqw&lang=en&WebSkinType=7','USDT',0.00,0.00,0.00,0,0,NULL,'wait',NULL,'2026-09-26 20:13:12','2026-09-26 20:13:50'),
(9,'GSbe7bff5c321d46068fac8bcc',5,17,'a04d1f3eb8ccec8a4823bdf18e3f0e84','Aviator','h72add5','https://launch.spribegaming.com/aviator?user=111361624&token=25fb54b2914644a393cde3d57b4f2f0c&lang=en&currency=INR&operator=tigergamesvtwo&return_url=https%3A%2F%2Fcadiplay.com','USDT',0.00,0.00,0.00,0,0,NULL,'wait',NULL,'2026-09-26 20:14:03','2026-09-26 20:14:03'),
(10,'GS698504f98a16405187261f30',18,280,'1d1c0d3ec98deb128bdd5acdef0f157e','Power Blackjack','h72add18','https://skylinev88asia.evo-games.com/entry?params=Y2FzaW5vX2lkPXN1YmFzaWE3MzdsdWNreTEKZ2FtZT1wb3dlcnNjYWxhYmxlYmxhY2tqYWNrCmp3c2g9ZXlKcmFXUWlPaUl4TnpNNU5EUTROREF4TnprMUlpd2lZV3huSWpvaVJWTXlOVFlpZlEKcGxheV9tb2RlPXJlYWxfbW9uZXkKc2lnbmF0dXJlPUllTHR6a1hOMDlUZzBBZ2szUk5yWmRqUFVrVnZxTzViXzNJd19ONWloUXpjLUJ6ZkxhN1hURWp0SEZkOUl2YTBfLTNKR2lLRkRFTklfYWpvalFqOUdRCnNpdGU9MTAKdGFibGVfaWQ9UG93ZXJJbmZpbml0ZUJKMQp1YV9sYXVuY2hfaWQ9MThkYTBlMDg5NTE4YTY2N2FhN2EyYTIxCnZ0X2lkPXRpaHZmZDNyaHR1YWNxM2QK&JSESSIONID=t74zr7yydjhacl55udyzcyl4dekt6j7ffefbf21f','USDT',0.00,0.00,0.00,0,0,NULL,'wait',NULL,'2026-09-30 09:04:49','2026-09-30 09:07:12'),
(11,'GSb01ef04cbf29450b8a3764aa',18,17,'a04d1f3eb8ccec8a4823bdf18e3f0e84','Aviator','h72add18','https://launch.spribegaming.com/aviator?user=110445236&token=165e2222b7854b1bb2bd4ac72c96f66c&lang=en&currency=INR&operator=tigergamesvtwo&return_url=https%3A%2F%2Fcadiplay.com','USDT',0.00,0.00,0.00,0,0,NULL,'wait',NULL,'2026-09-30 09:05:09','2026-10-04 19:21:40'),
(12,'GS8593e711a2d040739cc7deb0',18,266,'8cc99bed98c7adbe84bdaf7a8ad0c084','Cockfight','h72add18','https://jump.qwe3c4d.xyz?hash=eyJwbGF5ZXJfdG9rZW4iOiJleUpoYkdjaU9pSklVekkxTmlKOS5leUpwWkNJNk56UTVORGcwT1RJc0ltVnRZV2xzSWpvaUlpd2laWGh3SWpveE56a3hNakk0TVRJemZRLi1waGJuU1VTWk05ZjJKZ3JoYnN4bnZ3cU5RSU1MVE1Sam9fV0k2UnhyREUiLCJsYW5nIjoiZW4iLCJlbnRyeSI6IjEiLCJ2YWxpZGF0aW9uIjoiZDRjYTUwZWQyMzI4YTVkM2VmZmUxMTQ0ZTA3ZDU5YmMiLCJ1cmxzIjpbImh0dHBzOi8vd3d3Lm9kaW5hMC5saXZlIl0sImN1cnJlbmN5IjoiSU5SIiwiY3VzdG9tX2xvZ28iOiJvZGluIiwidGhlbWUiOiJUaGVtZV8yMDI0XzMiLCJ0aGVtZV9jb2xvciI6ImJyb3duIn0=','USDT',0.00,0.00,0.00,0,0,NULL,'wait',NULL,'2026-09-30 09:16:49','2026-10-04 19:22:04'),
(13,'GSc341aa79259e4b53bac39b0e',20,17,'a04d1f3eb8ccec8a4823bdf18e3f0e84','Aviator','h72add20','https://launch.spribegaming.com/aviator?user=111500496&token=b1858d72feb04ac3aa3b981d5d660404&lang=en&currency=INR&operator=tigergamesvtwo&return_url=https%3A%2F%2Fcadiplay.com','USDT',0.00,0.00,0.00,0,0,NULL,'wait',NULL,'2026-10-02 19:45:48','2026-10-02 19:46:01'),
(14,'GSa77bc3639a33419e9437d622',20,8,'d496ac5fd91702331133e44b6bd12b26','MONOPOLY Live','h72add20','https://skylinev88asia.evo-games.com/entry?params=Y2FzaW5vX2lkPXN1YmFzaWE3MzdsdWNreTEKZ2FtZT1tb25vcG9seQpqd3NoPWV5SnJhV1FpT2lJeE56TTVORFE0TkRBeE56azFJaXdpWVd4bklqb2lSVk15TlRZaWZRCnBsYXlfbW9kZT1yZWFsX21vbmV5CnNpZ25hdHVyZT1pT1FTN2dIUW1mWUJjeVVkQXZ4UjBKR3NGbVBFLWwxVmlBd05oTmFYVXp3a1ZQYmRUcWpoRWprcmo1OG9GZVNGbEFvbEt6ZmdEZnRaaGRMRGFIRWtsUQpzaXRlPTEwCnRhYmxlX2lkPU1vbm9wb2x5MDAwMDAwMDEKdWFfbGF1bmNoX2lkPTE4ZGFjZTEyMjI1NjhiNTA0Mjg3ZGNmZQp2dF9pZD10aWh2ZmZ4c2h0dWFjdXR5Cg&JSESSIONID=udrfoqwuj4ab2nhfud7coo4wa5fhrutm696aecce','USDT',0.00,0.00,0.00,0,0,NULL,'wait',NULL,'2026-10-02 19:46:20','2026-10-02 19:46:20'),
(15,'GS67651c75e12042acb0062d7d',20,2,'d0e052b031dfcdb08d1803f4bcc618ef','Ezugi Lobby','h72add20','https://play.livetables.io/auth/?cashierUrl=https%3A%2F%2Fcadiplay.com&clientType=html5&homeUrl=https%3A%2F%2Fcadiplay.com&language=en&operatorId=11058001&selectGame=roulette&token=7ab8a4c6-7b32-4303-83af-87467eed0ada','USDT',20.00,30.00,10.00,2,0,110.00,'profit','2026-10-02 19:48:39','2026-10-02 19:47:17','2026-10-02 19:48:39'),
(16,'GS13e4f4aa77dd49b99a08bc88',19,262,'08ced9dd788aed11ff3c7f387ae0f063','SABA Sports','h72add19','https://r9p2ob.lcqychz4.com/DepositProcessLogin?token=EcVax7t6P0a3NlLjEWp2fA&lang=en&WebSkinType=7','USDT',400.00,100.00,-300.00,5,0,700.00,'loss','2026-10-03 15:45:13','2026-10-03 15:41:17','2026-10-03 15:45:13'),
(17,'GS27719f7040d2421a86e04278',18,282,'8de1993b371ce298b85584d21e5d2106','Blackjack Silver','h72add18','https://skylinev88asia.evo-games.com/entry?params=Y2FzaW5vX2lkPXN1YmFzaWE3MzdsdWNreTEKZ2FtZT1ibGFja2phY2sKandzaD1leUpyYVdRaU9pSXhOek01TkRRNE5EQXhOemsxSWl3aVlXeG5Jam9pUlZNeU5UWWlmUQpwbGF5X21vZGU9cmVhbF9tb25leQpzaWduYXR1cmU9b2dUTktqZ2xKdGlST0p2S2tTZ21yNW1VWEtRZnZteHNxRkl3UWJWblBsUGFrS2xLeW9yaWdpSVNQamxsMkNmNVJ6ajEwdEVWOHpJdzUtTEE0bHRXcHcKc2l0ZT0xMAp0YWJsZV9pZD05ZjR4aHVoZGQwMDV4bGJsCnVhX2xhdW5jaF9pZD0xOGRiNjllZTUyZGExZTlhZWJkODdhNzYKdnRfaWQ9dGlodmZndTNodHVhY3dxYwo&JSESSIONID=t74zr7yydjhacl55ueef4ioydekw6nu79f1ad963','USDT',0.00,0.00,0.00,0,0,NULL,'wait',NULL,'2026-10-04 19:22:30','2026-10-04 19:22:30'),
(18,'GSbd8343d265f34ae0a2070a49',23,17,'a04d1f3eb8ccec8a4823bdf18e3f0e84','Aviator','h72add23','https://launch.spribegaming.com/aviator?user=110454694&token=0aa53370e5864635bc70e11a02e640e1&lang=en&currency=INR&operator=tigergamesvtwo&return_url=https%3A%2F%2Fcadiplay.com','USD',0.00,0.00,0.00,0,0,NULL,'wait',NULL,'2026-10-04 22:05:53','2026-10-04 22:05:53'),
(19,'GSe84444c98a8c42f0986d9a79',25,17,'a04d1f3eb8ccec8a4823bdf18e3f0e84','Aviator','h72add25','https://launch.spribegaming.com/aviator?user=111555337&token=e532da05834f402189097332b0409ffc&lang=en&currency=INR&operator=tigergamesvtwo&return_url=https%3A%2F%2Fcadiplay.com','USD',0.00,0.00,0.00,0,0,NULL,'wait',NULL,'2026-10-04 22:07:47','2026-10-04 22:14:24'),
(20,'GSa216a1d6154e480d97d35b24',26,17,'a04d1f3eb8ccec8a4823bdf18e3f0e84','Aviator','h72add26','https://launch.spribegaming.com/aviator?user=111555369&token=2490ee8b932f445c9ed8e6d56171cd4c&lang=en&currency=INR&operator=tigergamesvtwo&return_url=https%3A%2F%2Fcadiplay.com','USD',0.00,0.00,0.00,0,0,NULL,'wait',NULL,'2026-10-04 22:18:21','2026-10-04 22:19:49');

/*!40000 ALTER TABLE `game_sessions` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `games`
--

DROP TABLE IF EXISTS `games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `games` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `provider_id` bigint unsigned DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `category` varchar(50) NOT NULL,
  `category_id` bigint unsigned DEFAULT NULL,
  `game_uid` varchar(64) DEFAULT NULL,
  `game_type` varchar(40) DEFAULT NULL,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `rtp` decimal(5,2) DEFAULT NULL,
  `min_bet` decimal(18,2) DEFAULT '10.00',
  `max_bet` decimal(18,2) DEFAULT '100000.00',
  `is_featured` tinyint(1) DEFAULT '0',
  `is_active_web` tinyint(1) DEFAULT '1',
  `is_active_mobile` tinyint(1) DEFAULT '1',
  `is_active` tinyint(1) DEFAULT '1',
  `is_provably_fair` tinyint(1) DEFAULT '0',
  `sort_order` int DEFAULT '0',
  `play_count` int DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `provider_id` (`provider_id`),
  KEY `idx_games_category` (`category`),
  KEY `idx_games_featured` (`is_featured`),
  KEY `idx_games_uid` (`game_uid`),
  KEY `idx_games_active` (`is_active`),
  KEY `idx_games_sort` (`sort_order`),
  KEY `idx_games_category_id` (`category_id`),
  CONSTRAINT `fk_games_category` FOREIGN KEY (`category_id`) REFERENCES `game_categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `games_ibfk_1` FOREIGN KEY (`provider_id`) REFERENCES `game_providers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=286 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `games`
--

LOCK TABLES `games` WRITE;
/*!40000 ALTER TABLE `games` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `games` VALUES
(1,4,'Microgaming Lobby','microgaming-lobby-4e58131a','live_casino',3,'4e58131adb95bb061a40e6e309116c19','CasinoLive','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1BrpDj_tYZ2FysnP4-K6_cs9E5JdFBQWzleThcK4o1L2BPOzzFGSlq78&s=10',NULL,10.00,100000.00,0,1,1,1,0,0,3,'2026-06-26 06:58:40','2026-07-18 07:58:59'),
(2,4,'Ezugi Lobby','ezugi-lobby-d0e052b0','live_casino',3,'d0e052b031dfcdb08d1803f4bcc618ef','CasinoLive','https://www.livecasinocomparer.com/wp-content/uploads/2026/04/ezugi-live-casino.webp',NULL,10.00,100000.00,0,1,1,1,0,1,14,'2026-06-26 06:58:40','2026-10-02 19:47:16'),
(3,4,'Evolution Lobby','evolution-lobby-8ef39602','live_casino',3,'8ef39602e589bf9f32fc351b1cbb338b','CasinoLive','https://delivery2.objectic.io/Jd8DtRve6A7M91Dp6stxDe/jIWXpQOLRVBo/JpY1srhK0mprif3Erg9u8hhorJWy0N00QMMBQ9X6.jpg?w=1536&q=75&fm=auto',NULL,10.00,100000.00,0,1,1,1,0,2,4,'2026-06-26 06:58:40','2026-07-16 14:10:35'),
(4,4,'Super Andar Bahar','super-andar-bahar-f7b98e89','live_casino',3,'f7b98e899461bdd49f92afc36b4c0db5','CasinoLive','https://i.postimg.cc/nzJXysKD/Screenshot-2025-03-21-153431.png',NULL,10.00,100000.00,0,1,1,1,0,3,7,'2026-06-26 06:58:40','2026-07-16 14:02:50'),
(5,4,'XXXtreme Lightning Roulette','xxxtreme-lightning-roulette-394fe6a2','live_casino',3,'394fe6a2cde24bc487767236cc6eccd6','CasinoLive','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzVO-S7RaA_LKkxsZA_uko3yFvK4tN_ywLVdRscfc4WQ&s=10',NULL,10.00,100000.00,0,1,1,1,0,4,1,'2026-06-26 06:58:40','2026-07-16 14:43:20'),
(6,4,'Crazy Time','crazy-time-917c0c51','live_casino',3,'917c0c51d248c33eb058e3210a2e7371','CasinoLive','https://i.postimg.cc/tJ9Vx1Yj/Screenshot-2025-03-21-153400.png',NULL,10.00,100000.00,0,1,1,1,0,5,1,'2026-06-26 06:58:40','2026-07-16 14:00:37'),
(7,4,'Lightning Roulette','lightning-roulette-4a858d6b','live_casino',3,'4a858d6b74c05260d3ea2762838798c7','CasinoLive','https://egw.news/_next/image?url=https%3A%2F%2Fegw.news%2Fuploads%2Fnews%2F1%2F17%2F1755104641788_1755104641791.webp&w=1920&q=75',NULL,10.00,100000.00,0,1,1,1,0,6,4,'2026-06-26 06:58:40','2026-07-16 14:13:12'),
(8,4,'MONOPOLY Live','monopoly-live-d496ac5f','live_casino',3,'d496ac5fd91702331133e44b6bd12b26','CasinoLive','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPSJn1LFVhHz91ek4yaUukVv7h4vtLMs8bEijt60nVAAnPC4W-V9ZQMVcR&s=10',NULL,10.00,100000.00,0,1,1,1,0,7,2,'2026-06-26 06:58:40','2026-10-02 19:46:19'),
(9,4,'Playtech Lobby','playtech-lobby-c38efc51','live_casino',3,'c38efc51028bd65f42396fa079c125d6','CasinoLive','https://www.primeapi.com/cdn/gameRes/sq/350/PlaytechGameShowsLobby.jpg',NULL,10.00,100000.00,0,1,1,1,0,8,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(10,4,'DreamGaming','dreamgaming-8737e1ef','live_casino',3,'8737e1ef982bd7ba41ec02c1823626f9','CasinoLive','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStNfAHfOSIAtMdyIl4WUifqAGzGvU4MYm4-JnUt2eQoa9-PzdGJABs-5AT&s=10',NULL,10.00,100000.00,0,1,1,1,0,9,0,'2026-06-26 06:58:40','2026-07-03 13:26:56'),
(11,4,'Mines','mines-72ce7e04','live_casino',3,'72ce7e04ce95ee94eef172c0dfd6dc17','CasinoLive','https://ossimg.tirangaagent.com/Tiranga/gamelogo/JILI/232.png',NULL,10.00,100000.00,0,1,1,1,0,10,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(12,4,'Tower','tower-8e939551','live_casino',3,'8e939551b9e785001fcb5b0a32f88aba','CasinoLive','https://ossimg.tirangaagent.com/Tiranga/gamelogo/JILI/233.png',NULL,10.00,100000.00,0,1,1,1,0,11,1,'2026-06-26 06:58:40','2026-07-14 16:08:17'),
(13,4,'HILO','hilo-bd8a2bb2','live_casino',3,'bd8a2bb2dd63503b93cf6ac9492786ce','CasinoLive','https://ossimg.tirangaagent.com/Tiranga/gamelogo/JILI/235.png',NULL,10.00,100000.00,0,1,1,1,0,12,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(14,4,'Limbo','limbo-eabf0825','live_casino',3,'eabf08253165b6bb2646e403de625d1a','CasinoLive','https://ossimg.tirangaagent.com/Tiranga/gamelogo/JILI/236.png',NULL,10.00,100000.00,0,1,1,1,0,13,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(15,4,'Trump Card','trump-card-96c010fc','live_casino',3,'96c010fc4a95792401e903213d7add44','CasinoLive','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Trump-Card.png',NULL,10.00,100000.00,0,1,1,1,0,14,1,'2026-06-26 06:58:40','2026-07-18 07:52:57'),
(16,4,'Wheel','wheel-6e19e03c','live_casino',3,'6e19e03c50f035ddd9ffd804c30f8c80','CasinoLive','https://ossimg.tirangaagent.com/Tiranga/gamelogo/JILI/229.png',NULL,10.00,100000.00,0,1,1,1,0,15,3,'2026-06-26 06:58:40','2026-07-16 14:41:59'),
(17,3,'Aviator','aviator-a04d1f3e','ai_games',6,'a04d1f3eb8ccec8a4823bdf18e3f0e84','CasinoTable','https://ossimg.tirangaagent.com/Tiranga/gamelogo/TB_Chess/800.png',NULL,10.00,100000.00,0,1,1,1,0,16,51,'2026-06-26 06:58:40','2026-10-04 22:19:48'),
(18,3,'Mines','mines-5c4a12fb','ai_games',6,'5c4a12fb0a9b296d9b0d5f9e1cd41d65','CasinoTable','https://ossimg.tirangaagent.com/Tiranga/gamelogo/SPRIBE/22005.png',NULL,10.00,100000.00,0,1,1,1,0,17,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(19,3,'Plinko','plinko-6ab7a4fe','ai_games',6,'6ab7a4fe5161936012d6b06143918223','CasinoTable','https://ossimg.tirangaagent.com/Tiranga/gamelogo/SPRIBE/22004.png',NULL,10.00,100000.00,0,1,1,1,0,18,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(20,3,'Dice','dice-8a87aae7','ai_games',6,'8a87aae7a3624d284306e9c6fe1b3e9c','CasinoTable','https://ossimg.tirangaagent.com/Tiranga/gamelogo/TB_Chess/102.png',NULL,10.00,100000.00,0,1,1,1,0,19,1,'2026-06-26 06:58:40','2026-07-13 12:19:13'),
(21,3,'Goal','goal-c68a515f','ai_games',6,'c68a515f0b3b10eec96cf6d33299f4e2','CasinoTable','https://ossimg.tirangaagent.com/Tiranga/gamelogo/TB_Chess/105.png',NULL,10.00,100000.00,0,1,1,1,0,20,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(22,3,'Hi Lo','hi-lo-a669c993','ai_games',6,'a669c993b0e1f1b7da100fcf95516bdf','CasinoTable','https://ossimg.tirangaagent.com/Tiranga/gamelogo/TB_Chess/101.png',NULL,10.00,100000.00,0,1,1,1,0,21,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(23,3,'Hotline','hotline-b31720b3','ai_games',6,'b31720b3cd65d917a1a96ef61a72b672','CasinoTable','https://ossimg.tirangaagent.com/Tiranga/gamelogo/TB_Chess/107.png',NULL,10.00,100000.00,0,1,1,1,0,22,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(24,3,'Keno','keno-c311eb4b','ai_games',6,'c311eb4bbba03b105d150504931f2479','CasinoTable','https://ossimg.tirangaagent.com/Tiranga/gamelogo/TB_Chess/106.png',NULL,10.00,100000.00,0,1,1,1,0,23,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(25,3,'Mini Roulette','mini-roulette-9dc7ac61','ai_games',6,'9dc7ac6155c5a19c1cc204853e426367','CasinoTable','https://ossimg.tirangaagent.com/Tiranga/gamelogo/TB_Chess/104.png',NULL,10.00,100000.00,0,1,1,1,0,24,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(26,1,'Ocean King Jackpot','ocean-king-jackpot-564c48d5','ai_games',6,'564c48d53fcddd2bcf0bf3602d86c958','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Ocean-King-Jackpot.png',NULL,10.00,100000.00,0,1,1,1,0,25,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(27,1,'Royal Fishing','royal-fishing-e794bf57','ai_games',6,'e794bf5717aca371152df192341fe68b','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Royal-Fishing.png',NULL,10.00,100000.00,0,1,1,1,0,26,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(28,1,'Bombing Fishing','bombing-fishing-e333695b','ai_games',6,'e333695bcff28acdbecc641ae6ee2b23','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Bombing-Fishing.png',NULL,10.00,100000.00,0,1,1,1,0,27,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(29,1,'Dinosaur Tycoon','dinosaur-tycoon-eef3e28f','ai_games',6,'eef3e28f0e3e7b72cbca61e7924d00f1','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Dinosaur-Tycoon.png',NULL,10.00,100000.00,0,1,1,1,0,28,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(30,1,'Jackpot Fishing','jackpot-fishing-3cf4a85c','ai_games',6,'3cf4a85cb6dcf4d8836c982c359cd72d','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Jackpot-Fishing.png',NULL,10.00,100000.00,0,1,1,1,0,29,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(31,1,'Dragon Fortune','dragon-fortune-1200b824','ai_games',6,'1200b82493e4788d038849bca884d773','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Dragon-Fortune.png',NULL,10.00,100000.00,0,1,1,1,0,30,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(32,1,'Mega Fishing','mega-fishing-caacafe3','ai_games',6,'caacafe3f64a6279e10a378ede09ff38','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Mega-Fishing.png',NULL,10.00,100000.00,0,1,1,1,0,31,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(33,1,'Boom Legend','boom-legend-f02ede19','ai_games',6,'f02ede19c5953fce22c6098d860dadf4','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Boom-Legend.png',NULL,10.00,100000.00,0,1,1,1,0,32,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(34,1,'Happy Fishing','happy-fishing-71c68a4d','ai_games',6,'71c68a4ddb63bdc8488114a08e603f1c','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Happy-Fishing.png',NULL,10.00,100000.00,0,1,1,1,0,33,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(35,1,'All-star Fishing','all-star-fishing-9ec2a187','ai_games',6,'9ec2a18752f83e45ccedde8dfeb0f6a7','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/All-star-Fishing.png',NULL,10.00,100000.00,0,1,1,1,0,34,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(36,1,'Dinosaur Tycoon II','dinosaur-tycoon-ii-bbae6016','ai_games',6,'bbae6016f79f3df74e453eda164c08a4','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Dinosaur-Tycoon-II.png',NULL,10.00,100000.00,0,1,1,1,0,35,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(37,1,'Fishing Disco','fishing-disco-e453b811','ai_games',6,'e453b811fd1782fd2ade1f93ee0dee32','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Fishing-Disco.png',NULL,10.00,100000.00,0,1,1,1,0,36,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(38,1,'Dragon Master','dragon-master-f691d904','ai_games',6,'f691d904ea681ce449263f7e9cc47c35','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Dragon-Master.png',NULL,10.00,100000.00,0,1,1,1,0,37,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(39,1,'Fishing Yilufa','fishing-yilufa-877c9736','ai_games',6,'877c97367d24925a11d342726eb0320f','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Fishing-Yilufa.png',NULL,10.00,100000.00,0,1,1,1,0,38,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(40,1,'Shade Dragons Fishing','shade-dragons-fishing-89e967a8','ai_games',6,'89e967a8336fb8caad2c1b6d735588fe','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Shade-Dragons-Fishing.png',NULL,10.00,100000.00,0,1,1,1,0,39,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(41,1,'Cai Shen Fishing','cai-shen-fishing-6df463ea','ai_games',6,'6df463eabe5fcdaa033e1c89b9ffd162','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Cai-Shen-Fishing.png',NULL,10.00,100000.00,0,1,1,1,0,40,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(42,1,'Dragon Fishing II','dragon-fishing-ii-6cef8d8e','ai_games',6,'6cef8d8ea517d86602db60fe9781b01b','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Dragon-Fishing-Ii.png',NULL,10.00,100000.00,0,1,1,1,0,41,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(43,1,'Dragon Fishing','dragon-fishing-1145d7cd','ai_games',6,'1145d7cd96518a5ba2f77cb14cb363c4','Fish Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Dragon-Fishing.png',NULL,10.00,100000.00,0,1,1,1,0,42,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(44,5,'TeenPatti','teenpatti-f743cb55','live_casino',3,'f743cb55c2c4b737727ef144413937f4','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/TeenPatti.png',NULL,10.00,100000.00,0,1,1,1,0,43,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(45,5,'AK47','ak47-488c3776','live_casino',3,'488c377662cad37a551bde18e2fbe785','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/AK47.png',NULL,10.00,100000.00,0,1,1,1,0,44,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(46,5,'Andar Bahar','andar-bahar-6f48b3aa','live_casino',3,'6f48b3aa0b64c79a2dc320ea021148b5','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Andar-Bahar.png',NULL,10.00,100000.00,0,1,1,1,0,45,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(47,5,'Rummy','rummy-ae632f32','live_casino',3,'ae632f32c3a1e6803f9a6fbec16be28e','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Rummy.png',NULL,10.00,100000.00,0,1,1,1,0,46,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(48,5,'Callbreak','callbreak-9092b5a5','live_casino',3,'9092b5a56e001c60850c4c1184c53e07','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Callbreak.png',NULL,10.00,100000.00,0,1,1,1,0,47,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(49,5,'TeenPatti Joker','teenpatti-joker-1a4eaca6','live_casino',3,'1a4eaca67612e65fdcae43f4c8a667a4','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/TeenPatti-Joker.png',NULL,10.00,100000.00,0,1,1,1,0,48,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(50,5,'Callbreak Quick','callbreak-quick-aa9a9916','live_casino',3,'aa9a9916d6e48ba50afa3c2246b6dacb','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Callbreak-Quick.png',NULL,10.00,100000.00,0,1,1,1,0,49,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(51,5,'TeenPatti 20-20','teenpatti-20-20-1afa7db5','live_casino',3,'1afa7db588d05de7b9abca4664542765','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/TeenPatti-20-20.png',NULL,10.00,100000.00,0,1,1,1,0,50,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(52,5,'Ludo Quick','ludo-quick-bb1f14d7','live_casino',3,'bb1f14d788d37b06dc8f6701ed57ed0d','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Ludo-Quick.png',NULL,10.00,100000.00,0,1,1,1,0,51,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(53,5,'Tongits Go','tongits-go-26fbfab9','live_casino',3,'26fbfab92a3837b7dbf767e783b173af','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Tongits-Go.png',NULL,10.00,100000.00,0,1,1,1,0,52,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(54,5,'Pusoy Go','pusoy-go-f2879a3f','live_casino',3,'f2879a3f20f305eadad13448e11c052e','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Pusoy-Go.png',NULL,10.00,100000.00,0,1,1,1,0,53,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(55,5,'Blackjack','blackjack-3b502aee','live_casino',3,'3b502aee6c9e1ef0f698332ee1b76634','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Blackjack.png',NULL,10.00,100000.00,0,1,1,1,0,54,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(56,5,'Blackjack Lucky Ladies','blackjack-lucky-ladies-d0d1c200','live_casino',3,'d0d1c20062e28493e1750f27a1730c48','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Blackjack-Lucky-Ladies.png',NULL,10.00,100000.00,0,1,1,1,0,55,4,'2026-06-26 06:58:40','2026-07-18 07:57:56'),
(57,5,'MINI FLUSH','mini-flush-07afefc3','live_casino',3,'07afefc388ab6af8cf26f85286f83fae','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/MINI-FLUSH.png',NULL,10.00,100000.00,0,1,1,1,0,56,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(58,5,'Pool Rummy','pool-rummy-43e7df81','live_casino',3,'43e7df819bf57722a8917bb328640b30','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Pool-Rummy.png',NULL,10.00,100000.00,0,1,1,1,0,57,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(59,5,'Caribbean Stud Poker','caribbean-stud-poker-04c9784b','live_casino',3,'04c9784b0b1b162b2c86f9ce353da8b7','India Poker Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Caribbean-Stud-Poker.png',NULL,10.00,100000.00,0,1,1,1,0,58,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(60,6,'Le Pharaoh','le-pharaoh-fd4d50fd','slots',2,'fd4d50fd42d7453c20776398269ee6c5','Slot','https://mediumrare.imgix.net/293b2337d4d5cfda999ca423e34518a1a6682062340f1f1c5a669a26e7927c79?w=180&h=236&fit=min&auto=format',NULL,10.00,100000.00,0,1,1,1,0,59,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(61,6,'Phoenix DuelReels','phoenix-duelreels-32776cbf','slots',2,'32776cbf601015f626a96ccecb1137d9','Slot','https://mediumrare.imgix.net/7ac7169ca980177d2f7843face3046fb42c001bf4dd7356becb037e92fc07ff1?w=180&h=236&fit=min&auto=format',NULL,10.00,100000.00,0,1,1,1,0,60,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(62,6,'Fortune Dragon','fortune-dragon-c5435a8a','slots',2,'c5435a8a73707a3a8bb4fe8baaaef3d2','Slot','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Fortune-Dragon_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,61,2,'2026-06-26 06:58:40','2026-07-13 12:30:41'),
(63,6,'Fortune Rabbit','fortune-rabbit-e175cdd3','slots',2,'e175cdd3215a02f5539cc8354a149b75','Slot','https://mediumrare.imgix.net/8f495d55e1cdbef9a5995b7133d6f4ad1b9a332493ade8b29a82f048ecda7388?w=180&h=236&fit=min&auto=format',NULL,10.00,100000.00,0,1,1,1,0,62,1,'2026-06-26 06:58:40','2026-07-13 12:20:16'),
(64,6,'Fortune Tiger','fortune-tiger-9a848256','slots',2,'9a8482565ce343ad3ea7fc4bc42cb043','Slot','https://mediumrare.imgix.net/38cdf7e275e87c2530ee926bb2f5c811d9cb6ffccdad7717bed7ca43aa88eb38?w=180&h=236&fit=min&auto=format',NULL,10.00,100000.00,0,1,1,1,0,63,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(65,6,'SixSixSix','sixsixsix-37524900','slots',2,'3752490080e5e310b5a3f823de33deed','Slot','https://mediumrare.imgix.net/30be38fdc2b4d9a6c76194314dfb7814a66d6905287ade354a0e5f2a79b1ab27?w=180&h=236&fit=min&auto=format',NULL,10.00,100000.00,0,1,1,1,0,64,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(66,6,'Le Bandit','le-bandit-2fbd2533','slots',2,'2fbd2533b1bb03d5e03bfa80dd5da0bf','Slot','https://mediumrare.imgix.net/8ade942d35d2cdbddf7888f303be4cf4bda8c650a112b3c53f7c6f3ccad81254?w=180&h=236&fit=min&auto=format',NULL,10.00,100000.00,0,1,1,1,0,65,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(67,6,'Donny Dough','donny-dough-173c3e7c','slots',2,'173c3e7cb587af08a8aa2026e490b832','Slot','https://mediumrare.imgix.net/d0da486c2ef84196c52198fce55b4566303ef3d73d94c675179a8f6c4c5a3781?w=180&h=236&fit=min&auto=format',NULL,10.00,100000.00,0,1,1,1,0,66,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(68,6,'Magic Piggy','magic-piggy-a1686de7','slots',2,'a1686de737ae9cd841d500c825720778','Slot','https://mediumrare.imgix.net/b18560b8631fc3b27c06d41e9729f7774048864ad7c4a16d1a20b1a953883943?w=180&h=236&fit=min&auto=format',NULL,10.00,100000.00,0,1,1,1,0,67,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(69,6,'Wild Bandito','wild-bandito-95fc290b','slots',2,'95fc290bb05c07b5aad1a054eba4dcc4','Slot','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Wild-Bandito_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,68,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(70,6,'Aviamasters','aviamasters-d3c79852','slots',2,'d3c7985229b2e4651fa7889445a5bfd8','Slot','https://mediumrare.imgix.net/202834625f09f92dc0213a6f046d5111bcbba4aec9abf2d1b896839b592c657d?w=180&h=236&fit=min&auto=format',NULL,10.00,100000.00,0,0,1,1,0,69,0,'2026-06-26 06:58:40','2026-06-30 18:06:43'),
(71,6,'RIP City','rip-city-784f4587','slots',2,'784f4587c36ec560939eef1b85c639e4','Slot','https://mediumrare.imgix.net/c55c2ec37c310140617b75c9e490faca98090292991840dce959d93649efbfa5?w=180&h=236&fit=min&auto=format',NULL,10.00,100000.00,0,1,1,1,0,70,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(72,6,'FRKN Bananas','frkn-bananas-7e6130a7','slots',2,'7e6130a781f047045e7b92638d8e3fca','Slot','https://mediumrare.imgix.net/d4c903b8aa3bcbcd3e7cfdd46e14fa5ff3f056922cd470a109438ee41184990e?w=180&h=236&fit=min&auto=format',NULL,10.00,100000.00,0,1,1,1,0,71,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(73,6,'Mahjong Ways','mahjong-ways-1189baca','slots',2,'1189baca156e1bbbecc3b26651a63565','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Mahjong-Ways_rounded_1024.png',NULL,10.00,100000.00,0,1,1,1,0,72,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(74,6,'Mahjong Ways 2','mahjong-ways-2-ba2adf72','slots',2,'ba2adf72179e1ead9e3dae8f0a7d4c07','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Mahjong-Ways2_rounded_1024.png',NULL,10.00,100000.00,0,1,1,1,0,73,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(75,6,'Treasures of Aztec','treasures-of-aztec-2fa9a84d','slots',2,'2fa9a84d096d6ff0bab53f81b79876c8','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Treasures-of-Aztec_rounded_1024.png',NULL,10.00,100000.00,0,1,1,1,0,74,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(76,6,'Leprechaun Riches','leprechaun-riches-fb2a2ac5','slots',2,'fb2a2ac51303c0a0801dbe6a72d936f7','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Leprechaun-Riches_rounded_1024.png',NULL,10.00,100000.00,0,1,1,1,0,75,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(77,6,'Lucky Neko','lucky-neko-e1b4c6b9','slots',2,'e1b4c6b95746d519228744771f15fe4b','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Lucky-Neko_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,76,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(78,6,'Captain\'s Bounty','captain-s-bounty-cd29b990','slots',2,'cd29b9906a852ce26b53b6d6d81037d4','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Captains-Bounty_Icon_Rounded_1024.png',NULL,10.00,100000.00,0,1,1,1,0,77,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(79,6,'Queen of Bounty','queen-of-bounty-83a6890c','slots',2,'83a6890cf84e4c5a6bacf96d5355d472','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Queen-of-Bounty_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,78,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(80,6,'Ways of the Qilin','ways-of-the-qilin-fedfca55','slots',2,'fedfca553a97a791a3a41c4f1e3bff58','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Ways-of-the-Qilin_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,79,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(81,6,'Dragon Hatch','dragon-hatch-4afef91d','slots',2,'4afef91d3addb9ce5107abaf3342b9a5','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Dragon-Hatch_rounded_1024.png',NULL,10.00,100000.00,0,1,1,1,0,80,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(82,6,'Chin Shi Huang','chin-shi-huang-24da72b4','slots',2,'24da72b49b0dd0e5cbef9579d09d8981','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Chin-Shi-Huang.png',NULL,10.00,100000.00,0,1,1,1,0,81,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(83,6,'God Of Martial','god-of-martial-21ef8a7d','slots',2,'21ef8a7ddd39836979170a2e7584e333','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/God-Of-Martial.png',NULL,10.00,100000.00,0,1,1,1,0,82,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(84,6,'Hot Chilli','hot-chilli-c845960c','slots',2,'c845960c81d27d7880a636424e53964d','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Hot-Chilli.png',NULL,10.00,100000.00,0,1,1,1,0,83,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(85,6,'Fortune Tree','fortune-tree-6a7e156c','slots',2,'6a7e156ceec5c581cd6b9251854fe504','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Fortune-Tree.png',NULL,10.00,100000.00,0,1,1,1,0,84,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(86,6,'War Of Dragons','war-of-dragons-4b1d7ffa','slots',2,'4b1d7ffaf9f66e6152ea93a6d0e4215b','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/War-Of-Dragons.png',NULL,10.00,100000.00,0,1,1,1,0,85,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(87,6,'Gem Party','gem-party-756cf3c7','slots',2,'756cf3c73a323b4bfec8d14864e3fada','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Gem-Party.png',NULL,10.00,100000.00,0,1,1,1,0,86,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(88,6,'Lucky Ball','lucky-ball-89366989','slots',2,'893669898cd25d9da589a384f1d004df','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Lucky-Ball.png',NULL,10.00,100000.00,0,1,1,1,0,87,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(89,6,'Mafia Mayhem','mafia-mayhem-c7b3016c','slots',2,'c7b3016c70a06ddbb2355a3aee4179d0','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Mafia-Mayhem_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,88,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(90,6,'Werewolf Hunt','werewolf-hunt-2ac70bee','slots',2,'2ac70bee7b47c172381e55f7e644d92e','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Werewolfs-Hunt_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,89,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(91,6,'Tsar Treasures','tsar-treasures-1eb6a959','slots',2,'1eb6a959aadf0491f4a648762d8d262a','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Tsar-Treasures_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,90,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(92,6,'Dragon Hatch 2','dragon-hatch-2-910f2568','slots',2,'910f25689073d17680be453d7ed90ce2','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Dragon-Hatch2_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,91,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(93,6,'Gemstones Gold','gemstones-gold-877c9b2e','slots',2,'877c9b2ec1c5e0505129315948f9bbfa','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Gemstones-Gold_appicon_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,92,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(94,6,'Cash Maniac','cash-maniac-8bbb4136','slots',2,'8bbb41367b3971ed3467c2f0c2627a4','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Cash-Mania_appicon_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,93,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(95,6,'Wild Ape #','wild-ape-2589b93c','slots',2,'2589b93cb0dc46d847864c87ed42a3428bb','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Wild-Ape_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,94,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(96,6,'Pinata Wins','pinata-wins-f08cc025','slots',2,'f08cc025e23ee049b570517867c74be0','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Pinata-Wins_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,95,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(97,6,'Mystic Potion','mystic-potion-e61bde75','slots',2,'e61bde75d590e943d2c5c6d432b29b46','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Mystic-Potion.png',NULL,10.00,100000.00,0,1,1,1,0,96,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(98,6,'Hawaiian Tiki','hawaiian-tiki-35d6743a','slots',2,'35d6743ae5d73a3359f143cbb44ede09','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Hawaiian-Tiki_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,97,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(99,6,'Bakery Bonanza','bakery-bonanza-d0fe7aa2','slots',2,'d0fe7aa2f7ed5778190b1e60d94e6773','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Bakery-Bonanza_app-Icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,98,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(100,6,'Songkran Splash','songkran-splash-894b1c76','slots',2,'894b1c7609629cf9b3d127d9dbaa372c','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Songkran-Splash_appicon_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,99,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(101,6,'Mystical Spirits','mystical-spirits-3b2d4d1a','slots',2,'3b2d4d1ae24b1c3ad29556a6cf875f11','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Mystical-Spirits_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,100,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(102,6,'Super Golf Drive','super-golf-drive-d37dde2a','slots',2,'d37dde2adb52e0ea708c0ccd6877b1b3','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Super-Golf-Drive_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,101,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(103,6,'Lucky Clover Lady','lucky-clover-lady-288f2905','slots',2,'288f290554746bb32322a79b96ecdcbb','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Lucky-Clover-Lady_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,102,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(104,6,'Fruity Candy','fruity-candy-9f2c89ae','slots',2,'9f2c89ae5b7c0894c9ee9e223e3fd9d8','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Fruity-Candy_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,103,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(105,6,'Cruise Royale','cruise-royale-8489d662','slots',2,'8489d662ccc07a2e9677729f76e26ae8','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Cruise-Royale_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,104,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(106,6,'Safari Wilds','safari-wilds-97c6f05e','slots',2,'97c6f05ef6a0a34cad10d5e00edc909c','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Safari-Wilds_appicon_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,105,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(107,6,'Gladiator\'s Glory','gladiator-s-glory-2454dc7c','slots',2,'2454dc7cfdc651b7318950453bc3f617','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Gladiators-Glory_appicon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,106,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(108,6,'Ninja Racoon Frenzy','ninja-racoon-frenzy-6d1937d2','slots',2,'6d1937d2e7f87306333443c99ac2c03f','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Ninja-Racoon-Frenzy_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,107,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(109,6,'Ultimate Striker','ultimate-striker-4415d83c','slots',2,'4415d83cd9c74299814c1473db83bf7f','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Ultimate-Striker_appicon_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,108,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(110,6,'Mermaid Riches','mermaid-riches-a9d7a5af','slots',2,'a9d7a5af417a94caf554170e6b345e57','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Mermaid-Riches-icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,109,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(111,6,'Raider Jane\'s Crypt of Fortune','raider-jane-s-crypt-of-fortune-24d8e1db','slots',2,'24d8e1dbc5cface0907f5a21ecd56753','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Raider-Janes-Crypt-of-Fortune_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,110,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(112,6,'Supermarket Spree','supermarket-spree-7ef03497','slots',2,'7ef03497fc0b21c34b137e85b1e409cd','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Supermarket-Spree_rounded_1024.png',NULL,10.00,100000.00,0,1,1,1,0,111,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(113,6,'Buffalo Win','buffalo-win-818a7add','slots',2,'818a7add6e10b2ec5f938d7ae0efb04','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Buffalo-Win_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,112,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(114,6,'Legendary Monkey King','legendary-monkey-king-5cdeba2a','slots',2,'5cdeba2ab48d6ba345b1a4de8e2776b5','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Legendary-Monkey-King_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,113,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(115,6,'Spirited Wonders','spirited-wonders-87a05c81','slots',2,'87a05c81af5635bed41765bfd076ee15','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Spirited-Wonders_app-icon_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,114,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(116,6,'Emoji Riches','emoji-riches-101ca3ff','slots',2,'101ca3ff83b149dcf3439309e9b32142','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Emoji-Riches_app-Icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,115,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(117,6,'Mask Carnival','mask-carnival-adf297c2','slots',2,'adf297c2666c69b3abc3b61618d593b8','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Mask-Carnival_app-icon_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,116,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(118,6,'Oriental Prosperity','oriental-prosperity-23b43b58','slots',2,'23b43b58e11aadb1f27fd05ba41e9819','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Oriental-Prosperity_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,117,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(119,6,'Garuda Gems','garuda-gems-aa609892','slots',2,'aa609892f551de2053e92427dc4ae17f','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Garuda-Gems_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,118,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(120,6,'Destiny of Sun & Moon','destiny-of-sun-moon-617ca04f','slots',2,'617ca04ffcffbc543a1a30cacdac98fa','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Destiny-of-Sun-and-Moon_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,119,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(121,6,'Butterfly Blossom','butterfly-blossom-116989bb','slots',2,'116989bb267a72035bd01818c5496126','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Butterfly-Blossom_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,120,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(122,6,'Rooster Rumble','rooster-rumble-5c371d9f','slots',2,'5c371d9fca6109c954de93ac7986c5db','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Rooster-Rumble_app-icon_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,121,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(123,6,'The Queen\'s Banquet','the-queen-s-banquet-1b317b5f','slots',2,'1b317b5f8bf2ca0cc609307810407426','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/The-Queens-Banquet_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,122,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(124,6,'Battleground Royale','battleground-royale-e9f92f6e','slots',2,'e9f92f6edc2dac2d08bc345ee036260c','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Battleground-Royale_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,123,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(125,6,'Win Win Fish Prawn Crab','win-win-fish-prawn-crab-9b344f0b','slots',2,'9b344f0b2a9bda427684be60597d2fc6','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Win-Win-Fish-Prawn-Crab_rounded_1024.png',NULL,10.00,100000.00,0,1,1,1,0,124,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(126,6,'Lucky Piggy','lucky-piggy-66fadac6','slots',2,'66fadac68ed45e23def86c06cc811820','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Lucky-Piggy_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,125,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(127,6,'Wild Coaster','wild-coaster-a06f1a15','slots',2,'a06f1a154698243bf2484853d38e5fbb','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Wild-Coaster_app-icon_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,126,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(128,6,'Totem Wonders','totem-wonders-a03c6e7a','slots',2,'a03c6e7a918132b50f9caa297df1752d','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Totem-Wonders_icon_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,127,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(129,6,'Alchemy Gold','alchemy-gold-9860c865','slots',2,'9860c865264dcacad1ef37176cdefc1a','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Alchemy-Gold_1024_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,128,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(130,6,'Asgardian Rising','asgardian-rising-08d92dc2','slots',2,'08d92dc2ca14f42c681b44297386d600','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Asgardian-Rising_appicon_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,129,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(131,6,'Midas Fortune','midas-fortune-a2fd6b0c','slots',2,'a2fd6b0cadc8fefccfb0d063b1f81d85','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/pg/Midas-Fortune_appicon_rounded.png',NULL,10.00,100000.00,0,1,1,1,0,130,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(132,6,'Hyper Burst','hyper-burst-a47b1797','slots',2,'a47b17970036b37c1347484cf6956920','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Hyper-Burst.png',NULL,10.00,100000.00,0,1,1,1,0,131,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(133,6,'Shanghai Beauty','shanghai-beauty-795d0cae','slots',2,'795d0cae623cbf34d7f1aa93bbcded28','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Shanghai-Beauty.png',NULL,10.00,100000.00,0,1,1,1,0,132,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(134,6,'Fa Fa Fa','fa-fa-fa-54c41adc','slots',2,'54c41adcf43fdb6d385e38bc09cd77ca','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Fa-Fa-Fa.png',NULL,10.00,100000.00,0,1,1,1,0,133,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(135,6,'Dragon Soar','dragon-soar-9341a18d','slots',2,'9341a18d096ad901ef77338998f29098','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Dragon-Soar.png',NULL,10.00,100000.00,0,1,1,1,0,134,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(136,6,'Pop Pop Candy','pop-pop-candy-fde142e6','slots',2,'fde142e65f14da39f784e9e5325e0a77','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Pop-Pop-Candy.png',NULL,10.00,100000.00,0,1,1,1,0,135,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(137,6,'Open Sesame Mega','open-sesame-mega-cb5e57be','slots',2,'cb5e57be0354264c6c7ea0cdf4eb18b3','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Open-Sesame-Mega.png',NULL,10.00,100000.00,0,1,1,1,0,136,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(138,6,'Fruity Bonanza','fruity-bonanza-f5d6b418','slots',2,'f5d6b418b755f3aefe3b9828f3112c9c','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Fruity-Bonanza.png',NULL,10.00,100000.00,0,1,1,1,0,137,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(139,6,'Caishen Coming','caishen-coming-45ecec5d','slots',2,'45ecec5dd5077785e7a09988b95bbd24','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Caishen-Coming.png',NULL,10.00,100000.00,0,1,1,1,0,138,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(140,6,'Coocoo Farm','coocoo-farm-d1f17fd5','slots',2,'d1f17fd51e474b0e72892332ea551ba1','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Coocoo-Farm.png',NULL,10.00,100000.00,0,1,1,1,0,139,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(141,6,'Elemental Link Water','elemental-link-water-b84274cd','slots',2,'b84274cdfa5731945a34bfd0db1ddeea','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Elemental-Link-Water.png',NULL,10.00,100000.00,0,1,1,1,0,140,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(142,6,'Elemental Link Fire','elemental-link-fire-46016a77','slots',2,'46016a772b92c7f47dfdc5873f184ef1','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Elemental-Link-Fire.png',NULL,10.00,100000.00,0,1,1,1,0,141,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(143,6,'Birdsparty Deluxe','birdsparty-deluxe-786d1cd7','slots',2,'786d1cd7f4fa9905c825378292f1204c','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Birdsparty-Deluxe.png',NULL,10.00,100000.00,0,1,1,1,0,142,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(144,6,'Moneybags Man 2','moneybags-man-2-33c862e7','slots',2,'33c862e7db9e0e59ab3f8fe770f797da','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Moneybags-Man-2.png',NULL,10.00,100000.00,0,1,1,1,0,143,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(145,6,'JumpHigh','jumphigh-630a841b','slots',2,'630a841b4cf75a38e2e657040f785e63','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/cq9/JumpHigh.png',NULL,10.00,100000.00,0,1,1,1,0,144,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(146,6,'Rave Jump','rave-jump-b602205d','slots',2,'b602205d6a56d999df188e17ecc2bc91','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/cq9/Rave-Jump.png',NULL,10.00,100000.00,0,0,1,1,0,145,0,'2026-06-26 06:58:40','2026-06-30 18:06:51'),
(147,6,'Jump High 2','jump-high-2-8d57ec62','slots',2,'8d57ec6274960fe2f2c252f4a49adf7f','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/cq9/Jump-High-2.png',NULL,10.00,100000.00,0,1,1,1,0,146,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(148,6,'Jumping Mobile','jumping-mobile-1282953e','slots',2,'1282953e9452fe2852cb1724b4b9d617','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/cq9/Jumping-mobile.png',NULL,10.00,100000.00,0,1,1,1,0,147,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(149,6,'Good Fortune M','good-fortune-m-50568ba2','slots',2,'50568ba2a8da9f30dded83dbbd3655d6','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/cq9/Good-Fortune-M.png',NULL,10.00,100000.00,0,1,1,1,0,148,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(150,6,'God of War','god-of-war-f4b6484d','slots',2,'f4b6484dc2b96fc339604446cd042534','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/cq9/God-of-War.png',NULL,10.00,100000.00,0,1,1,1,0,149,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(151,6,'FlyOut','flyout-afddbebb','slots',2,'afddbebb27c4b7408bda624aa9354aa7','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/cq9/FlyOut.png',NULL,10.00,100000.00,0,1,1,1,0,150,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(152,6,'Emperor Qin','emperor-qin-d58b1c2d','slots',2,'d58b1c2dd6456da42b2c1a33c70c1630','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/yesgaming/ht-emperorqin.png',NULL,10.00,100000.00,0,1,1,1,0,151,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(153,6,'Cracker','cracker-b6668f2a','slots',2,'b6668f2abcfff3f7f78ae92fe908f99f','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/yesgaming/ht-cracker.png',NULL,10.00,100000.00,0,1,1,1,0,152,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(154,6,'FaFaFa','fafafa-017c1ede','slots',2,'017c1edeaf54d4684d675055c44a6f7e','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/yesgaming/ht-fafafa.png',NULL,10.00,100000.00,0,1,1,1,0,153,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(155,6,'Gold Toad','gold-toad-65415580','slots',2,'654155802c34cee717e943c4e2bb6bfe','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/yesgaming/ht-goldtoad.png',NULL,10.00,100000.00,0,1,1,1,0,154,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(156,6,'Lion Legend','lion-legend-eb8dd621','slots',2,'eb8dd621ea38d742ff846362a9b1085d','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/yesgaming/ht-lionlegend.png',NULL,10.00,100000.00,0,1,1,1,0,155,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(157,6,'Goblin\'s Gold','goblin-s-gold-69799380','slots',2,'697993800419bf160901aa9133cde524','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/yesgaming/ht-goblingold.png',NULL,10.00,100000.00,0,1,1,1,0,156,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(158,6,'The Unsurpassed Grace','the-unsurpassed-grace-bf0ae3c4','slots',2,'bf0ae3c404807429451d088725ae5377','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/yesgaming/ht-theunsurpassedgrace.png',NULL,10.00,100000.00,0,1,1,1,0,157,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(159,6,'Arctic King','arctic-king-8249b0e7','slots',2,'8249b0e703ceb0816f3645dbac0a83ce','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/yesgaming/ht-arcticking.png',NULL,10.00,100000.00,0,1,1,1,0,158,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(160,6,'Jalapeno','jalapeno-f23ad5ac','slots',2,'f23ad5acc6c690a45f1280ba49d28266','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/yesgaming/ht-jalapeno.png',NULL,10.00,100000.00,0,1,1,1,0,159,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(161,6,'Ice Age Mammoths','ice-age-mammoths-484025f2','slots',2,'484025f23c821e32fc6ac31ff75613d6','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/yesgaming/ht-iceagemammoths.png',NULL,10.00,100000.00,0,1,1,1,0,160,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(162,6,'Cracker','cracker-4415afc3','slots',2,'4415afc357ffd90adfae34b7fc3217d0','Slot Game','https://dl.kz344.net/game-icon/agg_ht-cracker.png',NULL,10.00,100000.00,0,1,1,1,0,161,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(163,6,'EstateRichman','estaterichman-99aa4072','slots',2,'99aa40727eebf03285f0b41492ad3200','Slot Game','https://dl.kz344.net/game-icon/agg_ht-estaterichman.png',NULL,10.00,100000.00,0,1,1,1,0,162,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(164,6,'CaribbeanTreasure','caribbeantreasure-186ceb14','slots',2,'186ceb140e9248012244381fc169640b','Slot Game','https://dl.kz344.net/game-icon/agg_ht-caribbeantreasure.png',NULL,10.00,100000.00,0,1,1,1,0,163,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(165,6,'LittleWitch','littlewitch-f41dd1fa','slots',2,'f41dd1fabc4700025036ffd090358402','Slot Game','https://dl.kz344.net/game-icon/agg_ht-thelittlewitch.png',NULL,10.00,100000.00,0,1,1,1,0,164,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(166,6,'FlameWolves','flamewolves-6ed7442a','slots',2,'6ed7442a8144c29321d95168ef6cb3de','Slot Game','https://dl.kz344.net/game-icon/agg_ht-flamewolves.png',NULL,10.00,100000.00,0,1,1,1,0,165,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(167,6,'PersianEmpire','persianempire-b4a0d38b','slots',2,'b4a0d38bac2760d3b2539430b3d65c6b','Slot Game','https://dl.kz344.net/game-icon/agg_ht-persianempire.png',NULL,10.00,100000.00,0,1,1,1,0,166,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(168,6,'Heracles','heracles-3be4c3ab','slots',2,'3be4c3abed248df43bee04af55c7894e','Slot Game','https://dl.kz344.net/game-icon/agg_ht-heracles.png',NULL,10.00,100000.00,0,1,1,1,0,167,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(169,6,'Poseidon','poseidon-7b5698f1','slots',2,'7b5698f1ab2aef819bea060ae5836c6d','Slot Game','https://dl.kz344.net/game-icon/agg_ht-poseidon.png',NULL,10.00,100000.00,0,1,1,1,0,168,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(170,6,'GoldenMaitreya','goldenmaitreya-19565e4f','slots',2,'19565e4f0152c29bc3c05d44ffe316d2','Slot Game','https://dl.kz344.net/game-icon/agg_ht-goldenmaitreya.png',NULL,10.00,100000.00,0,1,1,1,0,169,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(171,6,'GoldenWuZeTian','goldenwuzetian-e5e9c0ea','slots',2,'e5e9c0eae20cdecc45c9287b93e00d4d','Slot Game','https://dl.kz344.net/game-icon/agg_ht-goldenwuzetian.png',NULL,10.00,100000.00,0,1,1,1,0,170,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(172,6,'Sweet Land','sweet-land-91250a55','slots',2,'91250a55f75a3c67ed134b99bf587225','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Sweet-Land.png',NULL,10.00,100000.00,0,1,1,1,0,171,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(173,6,'Cricket King 18','cricket-king-18-dcf220f4','slots',2,'dcf220f4e3ecca0278911a55e6f11c77','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Cricket-King-18.png',NULL,10.00,100000.00,0,1,1,1,0,172,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(174,6,'Elf Bingo','elf-bingo-5cec2b30','slots',2,'5cec2b309a8845b38f8e9b4e6d649ea2','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Elf-Bingo.png',NULL,10.00,100000.00,0,1,1,1,0,173,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(175,6,'Cricket Sah 75','cricket-sah-75-6720a0ce','slots',2,'6720a0ce1d06648ff390fbea832798a9','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Cricket-Sah-75.png',NULL,10.00,100000.00,0,1,1,1,0,174,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(176,6,'Golden Temple','golden-temple-976c5497','slots',2,'976c5497256c020ac012005f6bb166ad','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Golden-Temple.png',NULL,10.00,100000.00,0,1,1,1,0,175,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(177,6,'Devil Fire','devil-fire-1b4c5865','slots',2,'1b4c5865131b4967513c1ee90cba4472','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Devil-Fire.png',NULL,10.00,100000.00,0,1,1,1,0,176,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(178,6,'Bangla Beauty','bangla-beauty-6b60d159','slots',2,'6b60d159f0939a45f7b4c88a9b57499a','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Bangla-Beauty.png',NULL,10.00,100000.00,0,1,1,1,0,177,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(179,6,'Aztec Priestess','aztec-priestess-6acff19b','slots',2,'6acff19b2d911a8c695ba24371964807','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Aztec-Priestess.png',NULL,10.00,100000.00,0,1,1,1,0,178,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(180,6,'Fortune Monkey','fortune-monkey-add95fc4','slots',2,'add95fc40f1ef0d56f5716ce45a56946','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Fortune-Monkey.png',NULL,10.00,100000.00,0,1,1,1,0,179,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(181,6,'Dabanggg','dabanggg-5404a45b','slots',2,'5404a45b06826911c3537fdf935c281f','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Dabanggg.png',NULL,10.00,100000.00,0,1,1,1,0,180,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(182,6,'Sin City','sin-city-830cac2f','slots',2,'830cac2f5da6cc1fb91cfae04b85b1e2','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Sin-City.png',NULL,10.00,100000.00,0,1,1,1,0,181,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(183,6,'King Arthur','king-arthur-fafab1a1','slots',2,'fafab1a17a237d0fc0e50c20d2c2bf4c','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/King-Arthur.png',NULL,10.00,100000.00,0,1,1,1,0,182,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(184,6,'Charge Buffalo Ascent','charge-buffalo-ascent-28bc4a33','slots',2,'28bc4a33c985ddce6acd92422626b76f','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Charge-Buffalo-Ascent.png',NULL,10.00,100000.00,0,1,1,1,0,183,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(185,6,'Witches Night','witches-night-82c5c404','slots',2,'82c5c404cf4c0790deb42a2b5653533c','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Witches-Night.png',NULL,10.00,100000.00,0,1,1,1,0,184,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(186,6,'Mega Ace','mega-ace-eba92b1d','slots',2,'eba92b1d3abd5f0d37dfbe112abdf0e2','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Mega-Ace.png',NULL,10.00,100000.00,0,0,1,1,0,185,0,'2026-06-26 06:58:40','2026-07-03 13:39:56'),
(187,6,'Medusa','medusa-2c17b7c4','slots',2,'2c17b7c4e2ce5b8bebf4bd10e3e958d7','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Medusa.png',NULL,10.00,100000.00,0,1,1,1,0,186,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(188,6,'Book of Gold','book-of-gold-6b283c43','slots',2,'6b283c434fd44250d83b7c2420f164f9','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Book-of-Gold.png',NULL,10.00,100000.00,0,1,1,1,0,187,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(189,6,'Thor X','thor-x-7e6aa773','slots',2,'7e6aa773fa802aaa9cb1f2fac464736e','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Thor-X.png',NULL,10.00,100000.00,0,1,1,1,0,188,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(190,6,'Happy Taxi','happy-taxi-1ed896aa','slots',2,'1ed896aae4bdc78c984021307b1dd177','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Happy-Taxi.png',NULL,10.00,100000.00,0,1,1,1,0,189,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(191,6,'Gold Rush','gold-rush-2a5d731e','slots',2,'2a5d731e0fd60f52873a24ece11f2c0b','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Gold-Rush.png',NULL,10.00,100000.00,0,1,1,1,0,190,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(192,6,'Mayan Empire','mayan-empire-5c2383ef','slots',2,'5c2383ef253f9c36dacec4b463d61622','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Mayan-Empire.png',NULL,10.00,100000.00,0,1,1,1,0,191,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(193,6,'Crazy Pusher','crazy-pusher-00d92d5c','slots',2,'00d92d5cec10cf85623938222a6c2bb6','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Crazy-Pusher.png',NULL,10.00,100000.00,0,1,1,1,0,192,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(194,6,'Bone Fortune','bone-fortune-aab3048a','slots',2,'aab3048abc6a88e0759679fbe26e6a8d','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Bone-Fortune.png',NULL,10.00,100000.00,0,1,1,1,0,193,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(195,6,'JILI CAISHEN','jili-caishen-11e330c2','slots',2,'11e330c2b23f106815f3b726d04e4316','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/JILI-CAISHEN.png',NULL,10.00,100000.00,0,1,1,1,0,194,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(196,6,'Bonus Hunter','bonus-hunter-39775cdc','slots',2,'39775cdc4170e56c5f768bdee8b4fa00','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Bonus-Hunter.png',NULL,10.00,100000.00,0,1,1,1,0,195,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(197,6,'World Cup','world-cup-28374b7a','slots',2,'28374b7ad7c91838a46404f1df046e5a','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/World-Cup.png',NULL,10.00,100000.00,0,1,1,1,0,196,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(198,6,'Samba','samba-6d35789b','slots',2,'6d35789b2f419c1db3926350d57c58d8','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Samba.png',NULL,10.00,100000.00,0,1,1,1,0,197,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(199,6,'Neko Fortune','neko-fortune-9a391758','slots',2,'9a391758f755cb30ff973e08b2df6089','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Neko-Fortune.png',NULL,10.00,100000.00,0,1,1,1,0,198,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(200,6,'Wild Racer','wild-racer-2f0c5f96','slots',2,'2f0c5f96cda3c6e16b3929dd6103df8e','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Wild-Racer.png',NULL,10.00,100000.00,0,1,1,1,0,199,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(201,6,'Pirate Queen','pirate-queen-70999d5b','slots',2,'70999d5bcf2a1d1f1fb8c82e357317f4','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Pirate-Queen.png',NULL,10.00,100000.00,0,1,1,1,0,200,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(202,6,'Golden Joker','golden-joker-f301fe0b','slots',2,'f301fe0b22d1540b1f215d282b20c642','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Golden-Joker.png',NULL,10.00,100000.00,0,1,1,1,0,201,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(203,6,'Wild Ace','wild-ace-9a3b65e2','slots',2,'9a3b65e2ae5343df349356d548f3fc4b','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Wild-Ace.png',NULL,10.00,100000.00,0,1,1,1,0,202,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(204,6,'Master Tiger','master-tiger-d2b48fe9','slots',2,'d2b48fe98ac2956eeefd2bc4f7e0335a','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Master-Tiger.png',NULL,10.00,100000.00,0,1,1,1,0,203,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(205,6,'Fortune Gems 2','fortune-gems-2-664fba4d','slots',2,'664fba4da609ee82b78820b1f570f4ad','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Fortune-Gems-2.png',NULL,10.00,100000.00,0,1,1,1,0,204,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(206,6,'Fortune Gems','fortune-gems-a990de17','slots',2,'a990de177577a2e6a889aaac5f57b429','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Fortune-Gems.png',NULL,10.00,100000.00,0,1,1,1,0,205,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(207,6,'Crazy Hunter','crazy-hunter-69082f28','slots',2,'69082f28fcd46cbfd10ce7a0051f24b6','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Crazy-Hunter.png',NULL,10.00,100000.00,0,1,1,1,0,206,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(208,6,'Party Night','party-night-d505541d','slots',2,'d505541d522aa5ca01fc5e97cfcf2116','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Party-Night.png',NULL,10.00,100000.00,0,1,1,1,0,207,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(209,6,'Magic Lamp','magic-lamp-582a5879','slots',2,'582a58791928760c28ec4cef3392a49f','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Magic-Lamp.png',NULL,10.00,100000.00,0,1,1,1,0,208,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(210,6,'Agent Ace','agent-ace-8a4b4929','slots',2,'8a4b4929e796fda657a2d38264346509','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Agent-Ace.png',NULL,10.00,100000.00,0,1,1,1,0,209,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(211,6,'TWIN WINS','twin-wins-c74b3cbd','slots',2,'c74b3cbda5d16f77523e41c25104e602','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/TWIN-WINS.png',NULL,10.00,100000.00,0,1,1,1,0,210,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(212,6,'Ali Baba','ali-baba-cc686634','slots',2,'cc686634b4f953754b306317799f1f39','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Ali-Baba.png',NULL,10.00,100000.00,0,1,1,1,0,211,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(213,6,'SevenSevenSeven','sevensevenseven-61d46add','slots',2,'61d46add6841aad4758288d68015eca6','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/SevenSevenSeven.png',NULL,10.00,100000.00,0,1,1,1,0,212,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(214,6,'Bubble Beauty','bubble-beauty-a78d2ed9','slots',2,'a78d2ed972aab8ba06181cc43c54a425','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Bubble-Beauty.png',NULL,10.00,100000.00,0,1,1,1,0,213,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(215,6,'FortunePig','fortunepig-8488c76e','slots',2,'8488c76ee2afb8077fbd7eec62721215','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/FortunePig.png',NULL,10.00,100000.00,0,1,1,1,0,214,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(216,6,'Crazy777','crazy777-8c62471f','slots',2,'8c62471fd4e28c084a61811a3958f7a1','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Crazy777.png',NULL,10.00,100000.00,0,1,1,1,0,215,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(217,6,'Bao boon chin','bao-boon-chin-8c4ebb3d','slots',2,'8c4ebb3dc5dcf7b7fe6a26d5aadd2c3d','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Bao-boon-chin.png',NULL,10.00,100000.00,0,1,1,1,0,216,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(218,6,'Night City','night-city-78e29705','slots',2,'78e29705f7c6084114f46a0aeeea1372','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Night-City.png',NULL,10.00,100000.00,0,1,1,1,0,217,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(219,6,'Fengshen','fengshen-09699fd0','slots',2,'09699fd0de13edbb6c4a194d7494640b','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Fengshen.png',NULL,10.00,100000.00,0,1,1,1,0,218,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(220,6,'Crazy FaFaFa','crazy-fafafa-a57a8d51','slots',2,'a57a8d5176b54d4c825bd1eee8ab34df','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Crazy-FaFaFa.png',NULL,10.00,100000.00,0,1,1,1,0,219,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(221,6,'XiYangYang','xiyangyang-5a962d0e','slots',2,'5a962d0e31e0d4c0798db5f331327e4f','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/XiYangYang.png',NULL,10.00,100000.00,0,1,1,1,0,220,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(222,6,'DiamondParty','diamondparty-48d598e9','slots',2,'48d598e922e8c60643218ccda302af08','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/DiamondParty.png',NULL,10.00,100000.00,0,1,1,1,0,221,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(223,6,'Golden Bank','golden-bank-c3f86b78','slots',2,'c3f86b78938eab1b7f34159d98796e88','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Golden-Bank.png',NULL,10.00,100000.00,0,1,1,1,0,222,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(224,6,'Dragon Treasure','dragon-treasure-c6955c14','slots',2,'c6955c14f6c28a6c2a0c28274fec7520','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Dragon-Treasure.png',NULL,10.00,100000.00,0,1,1,1,0,223,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(225,6,'Charge Buffalo','charge-buffalo-984615c9','slots',2,'984615c9385c42b3dad0db4a9ef89070','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Charge-Buffalo.png',NULL,10.00,100000.00,0,1,1,1,0,224,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(226,6,'Lucky Goldbricks','lucky-goldbricks-d84ef530','slots',2,'d84ef530121953240116e3b2e93f6af4','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Lucky-Goldbricks.png',NULL,10.00,100000.00,0,1,1,1,0,225,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(227,6,'Super Ace','super-ace-bdfb23c9','slots',2,'bdfb23c974a2517198c5443adeea77a8','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Super-Ace.png',NULL,10.00,100000.00,0,1,1,1,0,226,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(228,6,'Money Coming','money-coming-db249def','slots',2,'db249defce63610fccabfa829a405232','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Money-Coming.png',NULL,10.00,100000.00,0,1,1,1,0,227,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(229,6,'Golden Queen','golden-queen-8de99455','slots',2,'8de99455c2f23f6827666fd798eb80ef','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Golden-Queen.png',NULL,10.00,100000.00,0,1,1,1,0,228,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(230,6,'Jungle King','jungle-king-4db0ec24','slots',2,'4db0ec24ff55a685573c888efed47d7f','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Jungle-King.png',NULL,10.00,100000.00,0,1,1,1,0,229,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(231,6,'Monkey Party','monkey-party-fd369a4a','slots',2,'fd369a4a7486ff303beea267ec5c8eff','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Monkey-Party.png',NULL,10.00,100000.00,0,1,1,1,0,230,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(232,6,'Fortune Neko','fortune-neko-49b706cc','slots',2,'49b706ccfe7c53727ee6760cd9a8721a','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Fortune-Neko.png',NULL,10.00,100000.00,0,1,1,1,0,231,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(233,6,'Book Of Mystery','book-of-mystery-13072a6e','slots',2,'13072a6eb2111c1b5202fe6155227e94','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Book-Of-Mystery.png',NULL,10.00,100000.00,0,1,1,1,0,232,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(234,6,'Prosperitytiger','prosperitytiger-1d704bbb','slots',2,'1d704bbb187a113229f3fdaa3b5406fe','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Prosperitytiger.png',NULL,10.00,100000.00,0,1,1,1,0,233,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(235,6,'Glamorous Girl','glamorous-girl-2663e14e','slots',2,'2663e14e5b455525252a25d9bd99e840','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Glamorous-Girl.png',NULL,10.00,100000.00,0,1,1,1,0,234,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(236,6,'Blossom Of Wealth','blossom-of-wealth-ed6fbaeb','slots',2,'ed6fbaeb7a104dd7ed96fa1683a48669','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Blossom-Of-Wealth.png',NULL,10.00,100000.00,0,1,1,1,0,235,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(237,6,'Boom Fiesta','boom-fiesta-1ffb31ff','slots',2,'1ffb31ff605f1a7862a138f5cd712056','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Boom-Fiesta.png',NULL,10.00,100000.00,0,1,1,1,0,236,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(238,6,'Big Three Dragons','big-three-dragons-600c338d','slots',2,'600c338d3fca2da208f1bba2c9d29059','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Big-Three-Dragons.png',NULL,10.00,100000.00,0,1,1,1,0,237,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(239,6,'Mayagoldcrazy','mayagoldcrazy-6c8009d1','slots',2,'6c8009d165293759bb218b72ba3c380f','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Mayagoldcrazy.png',NULL,10.00,100000.00,0,1,1,1,0,238,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(240,6,'Lantern Wealth','lantern-wealth-f2f2eae3','slots',2,'f2f2eae301311f0320ef669b68935546','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Lantern-Wealth.png',NULL,10.00,100000.00,0,1,1,1,0,239,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(241,6,'Marvelous Iv','marvelous-iv-126cf2bf','slots',2,'126cf2bfe8a8e606b362d23de02c0d5e','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Marvelous-Iv.png',NULL,10.00,100000.00,0,1,1,1,0,240,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(242,6,'Wonder Elephant','wonder-elephant-540da2ba','slots',2,'540da2ba4c849fc1c315f43ae74df220','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Wonder-Elephant.png',NULL,10.00,100000.00,0,1,1,1,0,241,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(243,6,'Lucky Diamond','lucky-diamond-6f6867ad','slots',2,'6f6867ad1956a04b174c92629cab7f54','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Lucky-Diamond.png',NULL,10.00,100000.00,0,1,1,1,0,242,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(244,6,'Spindrift 2','spindrift-2-5dc8c7a4','slots',2,'5dc8c7a43305c3fcb43574c570d6378','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Spindrift-2.png',NULL,10.00,100000.00,0,1,1,1,0,243,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(245,6,'Jungle Jungle','jungle-jungle-6c5fe548','slots',2,'6c5fe548bd6e09b683566298b29510ea','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Jungle-Jungle.png',NULL,10.00,100000.00,0,1,1,1,0,244,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(246,6,'Dragons Gate','dragons-gate-feaba603','slots',2,'feaba603992f26633116fb54562e3693','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Dragons-Gate.png',NULL,10.00,100000.00,0,1,1,1,0,245,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(247,6,'Spindrift','spindrift-b624d191','slots',2,'b624d1917ef5a740c151e4904a7cf0dd','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Spindrift.png',NULL,10.00,100000.00,0,1,1,1,0,246,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(248,6,'Double Wilds','double-wilds-7bd5233c','slots',2,'7bd5233c83de0669336ee649e6c8d2b5','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Double-Wilds.png',NULL,10.00,100000.00,0,1,1,1,0,247,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(249,6,'Moneybags Man','moneybags-man-c4fdebb2','slots',2,'c4fdebb24ff26fffb3a65d018da8ae92','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Moneybags-Man.png',NULL,10.00,100000.00,0,1,1,1,0,248,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(250,6,'Miner Babe','miner-babe-e705514f','slots',2,'e705514fdd4f9bea5f82bbd0b2c0a353','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Miner-Babe.png',NULL,10.00,100000.00,0,1,1,1,0,249,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(251,6,'Super Niubi Deluxe','super-niubi-deluxe-5d940d11','slots',2,'5d940d11c48b64ec1e6a3c8be5228250','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Super-Niubi-Deluxe.png',NULL,10.00,100000.00,0,1,1,1,0,250,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(252,6,'Funky King Kong','funky-king-kong-cdea2d06','slots',2,'cdea2d0670bc40309b4a9b6f942a218a','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Funky-King-Kong.png',NULL,10.00,100000.00,0,1,1,1,0,251,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(253,6,'Golden Disco','golden-disco-dfb8a198','slots',2,'dfb8a198ce0e821560cf543387a2acc2','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Golden-Disco.png',NULL,10.00,100000.00,0,1,1,1,0,252,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(254,6,'Treasure Bowl','treasure-bowl-0651af3e','slots',2,'0651af3e73c7600633522ffe15cc175b','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Treasure-Bowl.png',NULL,10.00,100000.00,0,1,1,1,0,253,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(255,6,'Mjolnir','mjolnir-e270f067','slots',2,'e270f0674dff538b181499d18ab47845','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Mjolnir.png',NULL,10.00,100000.00,0,1,1,1,0,254,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(256,6,'Pirate Treasure','pirate-treasure-bfb3241e','slots',2,'bfb3241e64953f731e72bc833f2fa79a','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Pirate-Treasure.png',NULL,10.00,100000.00,0,1,1,1,0,255,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(257,6,'Fortune Treasure','fortune-treasure-5a55a19d','slots',2,'5a55a19d9cfbead5e64b8169e96bd27a','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Fortune-Treasure.png',NULL,10.00,100000.00,0,1,1,1,0,256,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(258,6,'Egypt Treasure','egypt-treasure-b7f39e86','slots',2,'b7f39e861e2e02633cb5cb08958f1041','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Egypt-Treasure.png',NULL,10.00,100000.00,0,1,1,1,0,257,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(259,6,'Super Niubi','super-niubi-4042e5d0','slots',2,'4042e5d0c777e1d3c3bd481dac0a867e','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Super-Niubi.png',NULL,10.00,100000.00,0,1,1,1,0,258,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(260,6,'Dragons World','dragons-world-00b88680','slots',2,'00b886803f3d067f7028872468e84745','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Dragons-World.png',NULL,10.00,100000.00,0,1,1,1,0,259,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(261,6,'Go Lai Fu','go-lai-fu-a3584394','slots',2,'a3584394182e8abce362d90c2f048c75','Slot Game','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jdb/Go-Lai-Fu.png',NULL,10.00,100000.00,0,1,1,1,0,260,0,'2026-06-26 06:58:40','2026-06-26 06:58:40'),
(262,7,'SABA Sports','saba-sports-08ced9dd','sports',4,'08ced9dd788aed11ff3c7f387ae0f063','Sport','https://ossimg.tirangaagent.com/Tiranga/vendorlogo/vendorlogo_20240814202959vsy1.png',NULL,10.00,100000.00,0,1,1,1,0,261,19,'2026-06-26 06:58:40','2026-10-03 15:41:17'),
(263,2,'Esports','esports-4ee8e005','virtual_sports',8,'4ee8e0051a035b463b47c3c473ce317d','SportsGame','https://i.postimg.cc/FHHg66F4/Screenshot-2025-03-21-153241.png',NULL,10.00,100000.00,0,1,1,1,0,262,1,'2026-06-26 06:58:40','2026-06-26 08:37:01'),
(264,8,'Bhagyathara','bhagyathara-1','slots',2,'1','lottery','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3QD-Oy8_XcjfMm_D6--_kQ0gXCzDSZxjEEw&s',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-15 11:09:42','2026-07-15 11:30:50'),
(265,8,'Sthree Sakthi','sthreep-sakthi','slots',2,'2','lottery','https://img.mathrubhumi.com/view/acePublic/alias/contentid/1omugj5ir8q4ogz5xyo/0/sthree-sakthi-lottery.webp?f=3%3A2&q=0.75&w=900',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-15 11:30:29','2026-07-15 11:30:29'),
(266,9,'Cockfight','cockfight-c084','slots',2,'8cc99bed98c7adbe84bdaf7a8ad0c084','cockfighting','https://store-images.s-microsoft.com/image/apps.441.13510798887503449.ea1c2ebf-90f3-409c-901c-2b814aeecb2f.4e0134f0-c35b-4920-a0d0-9b2397d59b2f',96.50,10.00,100000.00,0,1,1,1,0,0,5,'2026-07-15 11:41:26','2026-10-04 19:22:03'),
(267,9,'WCC','wcc-358a','slots',2,'475a85119e0133e7b790be265fa9358a',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTo1zKMuhtsXWdj2IP2oxmQ6BHvTX3ZgYo9Ew&s',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-15 11:43:53','2026-07-15 11:43:53'),
(268,9,'WGC','wgc-78ee','slots',2,'304947ef77b76b16f2064932d72c78ee',NULL,'https://play-lh.googleusercontent.com/XUD4scTtRUfJc8JpS0dazSKsf4Y4jAMlvfhzA4X0ASD5oUTbnj9IFot7RzmDP8oyXA',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-15 11:45:26','2026-07-15 11:45:26'),
(269,7,'Luck Sports','luck-sports-c24e4','sports',4,'92b24e4c25107367a80e0fe1a97c24e4',NULL,'https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/LuckySports/Lucky Sports_Logo 01.jpg',96.50,10.00,100000.00,0,1,1,1,0,0,11,'2026-07-15 12:08:53','2026-09-22 12:48:51'),
(270,8,'Dhanalekshmi','dhanalekshmi','lottery',5,'3','lottery','https://images.etnownews.com/thumb/msid-153261580,updatedat-1765363887142,width-1280,height-720,resizemode-75/153261580.jpg',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-15 12:11:39','2026-07-15 12:11:39'),
(271,8,'Karunya Plus','karunya-plus','lottery',5,'4',NULL,'https://images.goodreturns.in/img/2025/07/keralalotterykarunyaplus600-1752142970.jpg',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-15 13:14:33','2026-07-15 13:14:33'),
(272,8,'Suvarana Keralam','suvarana-keralam-5','slots',2,'5',NULL,'https://www.thestatesman.com/wp-content/uploads/2026/04/Kerala-lottery-Suvarna-Keralam-SK-50-result-today-April-24-2026-Check-complete-list-of-winners-1024x576.webp',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-15 13:20:49','2026-07-15 13:21:23'),
(273,8,'Karunya','Karunya-6','lottery',5,'6',NULL,'https://img.etimg.com/thumb/width-1200,height-1200,imgsize-622196,resizemode-75,msid-130974147/news/new-updates/kerala-lottery-result-today-karunya-kr-753-may-9-2026-rs-1-crore-first-prize-rs-25-lakh-and-rs-10-lakh-winners-check-full-list.jpg',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-15 13:31:33','2026-07-15 13:31:33'),
(274,8,'Samrudhi','samrudhi-7','lottery',5,'7',NULL,'https://i.ytimg.com/vi/2LKuwIwZMyk/sddefault.jpg',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-15 13:33:17','2026-07-15 13:33:17'),
(275,5,'Aero','aero-98bd','fantasy',7,'cccdf7fc199f5c5b917a741c828398bd',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWi9lhzmHHuvCenzA7b_1AF_2NuVXHZKPnEA&s',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-16 08:52:17','2026-07-16 08:52:17'),
(276,6,'Wheel','wheel-8c80','slots',2,'6e19e03c50f035ddd9ffd804c30f8c80',NULL,'https://ossimg.tirangaagent.com/Tiranga/gamelogo/JILI/229.png',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-16 08:55:17','2026-07-16 08:55:17'),
(277,5,' Pool Rummy',' pool-rummy-0b30','live_casino',3,'43e7df819bf57722a8917bb328640b30','poker','https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/jili/Pool-Rummy.png',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-16 11:47:47','2026-07-16 11:47:47'),
(278,4,'Lightning Roulette','lightning-roulete-98c7','slots',2,'4a858d6b74c05260d3ea2762838798c7',NULL,'https://i.postimg.cc/HLRHXq7m/7611-lightning-roulette.webp',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-17 13:44:20','2026-07-17 13:44:20'),
(279,4,'Speed Roulette','speed-roulette-8ff6','slots',2,'b4af506243cafae52908e8fa266f8ff6',NULL,'https://i.postimg.cc/4yfmVQbc/speed-roulette.jpg',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-17 13:52:57','2026-07-17 13:52:57'),
(280,4,'Power Blackjack','power-blackjack','live_casino',3,'1d1c0d3ec98deb128bdd5acdef0f157e','blackjack','https://i.postimg.cc/VNM9VrFD/power-blackjack-pid-11.jpg',96.50,10.00,100000.00,0,1,1,1,0,0,8,'2026-07-17 13:55:55','2026-09-30 09:07:12'),
(281,NULL,'Infinite blackjack ','infinite-blackjack-88f4','slots',2,'58d7089aa20bce7f70e0e2ce81e888f4',NULL,'https://i.postimg.cc/26YBzZyd/infinite-blackjack-poster-600x840.jpg',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-17 14:00:43','2026-07-17 14:00:43'),
(282,4,'Blackjack Silver ','blackjack-silver','live_casino',3,'8de1993b371ce298b85584d21e5d2106','casino','https://i.postimg.cc/MHmyVYM6/blackjack-silver-b.webp',96.50,10.00,100000.00,0,1,1,1,0,0,2,'2026-07-17 14:02:03','2026-10-04 19:22:29'),
(283,4,'Immersive Roulette','immersive-roulette','live_casino',3,'3b43390eebe1f1a84b15f1251a253b24',NULL,'https://i.postimg.cc/G2nmFn1L/immersive-roulette-poster-600x840.jpg',96.50,10.00,100000.00,0,1,1,1,0,0,1,'2026-07-17 14:19:20','2026-07-18 07:44:26'),
(284,4,'Baccarat B','baccarat-b-ca33e1d','live_casino',3,'0ea8519b837ebd62f5a8978acca33e1d',NULL,'https://i.postimg.cc/k4tt9PxR/baccat-b.jpg',96.50,10.00,100000.00,0,1,1,1,0,0,0,'2026-07-17 14:20:40','2026-07-17 14:20:40'),
(285,4,'First Person Lightning Baccarat','first-person-lightning-baccarat','live_casino',3,'fec1b730e804bf14bd471a1e9b82bf44',NULL,'https://huidu-bucket.s3.ap-southeast-1.amazonaws.com/api/evoplay/First%20Person%20Lightning%20Baccarat.png',96.50,10.00,100000.00,0,1,1,1,0,0,1,'2026-07-17 14:22:18','2026-07-18 07:45:34');

/*!40000 ALTER TABLE `games` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `login_history`
--

DROP TABLE IF EXISTS `login_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_history` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `admin_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `device_type` varchar(50) DEFAULT NULL,
  `country_code` char(2) DEFAULT NULL,
  `session_id` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_login_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_history`
--

LOCK TABLES `login_history` WRITE;
/*!40000 ALTER TABLE `login_history` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `login_history` VALUES
(1,17,NULL,'194.61.40.181','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36',NULL,NULL,NULL,'2026-10-04 21:50:49'),
(2,17,NULL,'194.61.40.13','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36',NULL,NULL,NULL,'2026-10-04 21:52:06'),
(3,5,NULL,'194.61.40.184','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36',NULL,NULL,NULL,'2026-10-04 22:01:08'),
(4,5,NULL,'212.83.148.205','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36',NULL,NULL,NULL,'2026-10-04 22:55:15'),
(5,5,NULL,'194.61.40.150','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6.1 Mobile/15E148 Safari/604.1',NULL,NULL,NULL,'2026-10-04 22:59:24'),
(6,5,NULL,'51.159.125.189','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36',NULL,NULL,NULL,'2026-10-04 23:10:35'),
(7,27,NULL,'194.61.40.73','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6.1 Mobile/15E148 Safari/604.1',NULL,NULL,NULL,'2026-10-04 23:15:44');

/*!40000 ALTER TABLE `login_history` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `mail_configurations`
--

DROP TABLE IF EXISTS `mail_configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `mail_configurations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `scope` enum('casino','email_sms') NOT NULL,
  `config_key` varchar(80) NOT NULL,
  `config_value` text,
  `updated_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_mc` (`scope`,`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_configurations`
--

LOCK TABLES `mail_configurations` WRITE;
/*!40000 ALTER TABLE `mail_configurations` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `mail_configurations` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `mail_templates`
--

DROP TABLE IF EXISTS `mail_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `mail_templates` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `template_type` enum('email','sms','push') NOT NULL DEFAULT 'email',
  `language` varchar(30) DEFAULT 'English',
  `trigger_event` varchar(50) DEFAULT 'manual',
  `sender_name` varchar(100) DEFAULT NULL,
  `reply_to` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `body` text,
  `sent_count` int NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `track_opens` tinyint(1) NOT NULL DEFAULT '0',
  `track_clicks` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_templates`
--

LOCK TABLES `mail_templates` WRITE;
/*!40000 ALTER TABLE `mail_templates` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `mail_templates` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `monitoring_notes`
--

DROP TABLE IF EXISTS `monitoring_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `monitoring_notes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `admin_id` bigint unsigned DEFAULT NULL,
  `admin_name` varchar(120) DEFAULT NULL,
  `player_status` varchar(30) DEFAULT NULL,
  `note` text NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_mn_user` (`user_id`),
  CONSTRAINT `monitoring_notes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `monitoring_notes`
--

LOCK TABLES `monitoring_notes` WRITE;
/*!40000 ALTER TABLE `monitoring_notes` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `monitoring_notes` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `admin_id` bigint unsigned DEFAULT NULL,
  `affiliate_id` bigint unsigned DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `message` text,
  `is_read` tinyint(1) DEFAULT '0',
  `metadata` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_notif_user` (`user_id`),
  KEY `idx_notif_admin` (`admin_id`),
  KEY `idx_notif_affiliate` (`affiliate_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `partner_settings`
--

DROP TABLE IF EXISTS `partner_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `partner_settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `scope` enum('affiliate','agent') NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text,
  `updated_by` bigint unsigned DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_partner_setting` (`scope`,`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partner_settings`
--

LOCK TABLES `partner_settings` WRITE;
/*!40000 ALTER TABLE `partner_settings` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `partner_settings` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `payment_bin_rules`
--

DROP TABLE IF EXISTS `payment_bin_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_bin_rules` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `provider_id` bigint unsigned DEFAULT NULL,
  `bin_from` varchar(8) NOT NULL,
  `bin_to` varchar(8) DEFAULT NULL,
  `card_brand` varchar(40) DEFAULT NULL,
  `country_code` char(2) DEFAULT NULL,
  `action` enum('allow','deny','route') NOT NULL DEFAULT 'allow',
  `priority` int DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pbr_bin` (`bin_from`),
  KEY `provider_id` (`provider_id`),
  CONSTRAINT `payment_bin_rules_ibfk_1` FOREIGN KEY (`provider_id`) REFERENCES `payment_providers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_bin_rules`
--

LOCK TABLES `payment_bin_rules` WRITE;
/*!40000 ALTER TABLE `payment_bin_rules` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `payment_bin_rules` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `payment_frontend_rules`
--

DROP TABLE IF EXISTS `payment_frontend_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_frontend_rules` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `method_id` bigint unsigned DEFAULT NULL,
  `country_code` char(2) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `min_amount` decimal(18,2) DEFAULT '0.00',
  `max_amount` decimal(18,2) DEFAULT NULL,
  `display_order` int DEFAULT '0',
  `is_visible` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pfr_country` (`country_code`),
  KEY `method_id` (`method_id`),
  CONSTRAINT `payment_frontend_rules_ibfk_1` FOREIGN KEY (`method_id`) REFERENCES `payment_methods` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_frontend_rules`
--

LOCK TABLES `payment_frontend_rules` WRITE;
/*!40000 ALTER TABLE `payment_frontend_rules` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `payment_frontend_rules` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `payment_methods`
--

DROP TABLE IF EXISTS `payment_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_methods` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `code` varchar(40) NOT NULL,
  `method_type` enum('card','wallet','bank','crypto','upi','other') DEFAULT 'other',
  `logo_url` varchar(500) DEFAULT NULL,
  `supports_deposit` tinyint(1) DEFAULT '1',
  `supports_withdrawal` tinyint(1) DEFAULT '0',
  `min_amount` decimal(18,2) DEFAULT '0.00',
  `max_amount` decimal(18,2) DEFAULT NULL,
  `currencies` varchar(255) DEFAULT NULL,
  `countries` text,
  -- Where the PLAYER SENDS money for a manual deposit. The deposit page has to
  -- show these, or the player is asked to pay with no account to pay into.
  `account_name` varchar(120) DEFAULT NULL,
  `account_number` varchar(64) DEFAULT NULL,
  `ifsc_code` varchar(20) DEFAULT NULL,
  `bank_name` varchar(120) DEFAULT NULL,
  `branch_name` varchar(120) DEFAULT NULL,
  `upi_id` varchar(120) DEFAULT NULL,
  `qr_image_url` varchar(500) DEFAULT NULL,
  -- Crypto methods: the chain/token label and the receiving wallet address.
  `crypto_network` varchar(40) DEFAULT NULL,
  `wallet_address` varchar(191) DEFAULT NULL,
  `instructions` text,
  `is_active` tinyint(1) DEFAULT '1',
  `sort_order` int DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pm_code` (`code`),
  KEY `idx_pm_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_methods`
--

LOCK TABLES `payment_methods` WRITE;
/*!40000 ALTER TABLE `payment_methods` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `payment_methods` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `payment_provider_methods`
--

DROP TABLE IF EXISTS `payment_provider_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_provider_methods` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `provider_id` bigint unsigned NOT NULL,
  `method_id` bigint unsigned NOT NULL,
  `fee_percent` decimal(6,3) DEFAULT '0.000',
  `fee_fixed` decimal(18,2) DEFAULT '0.00',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ppm` (`provider_id`,`method_id`),
  KEY `method_id` (`method_id`),
  CONSTRAINT `payment_provider_methods_ibfk_1` FOREIGN KEY (`provider_id`) REFERENCES `payment_providers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `payment_provider_methods_ibfk_2` FOREIGN KEY (`method_id`) REFERENCES `payment_methods` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_provider_methods`
--

LOCK TABLES `payment_provider_methods` WRITE;
/*!40000 ALTER TABLE `payment_provider_methods` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `payment_provider_methods` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `payment_providers`
--

DROP TABLE IF EXISTS `payment_providers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_providers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `code` varchar(40) NOT NULL,
  `api_endpoint` varchar(500) DEFAULT NULL,
  `credentials` json DEFAULT NULL,
  `supports_deposit` tinyint(1) DEFAULT '1',
  `supports_withdrawal` tinyint(1) DEFAULT '0',
  `deposit_countries` text,
  `withdrawal_countries` text,
  `currencies` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pp_code` (`code`),
  KEY `idx_pp_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_providers`
--

LOCK TABLES `payment_providers` WRITE;
/*!40000 ALTER TABLE `payment_providers` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `payment_providers` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `platform_settings`
--

DROP TABLE IF EXISTS `platform_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `platform_settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` json NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `platform_settings`
--

LOCK TABLES `platform_settings` WRITE;
/*!40000 ALTER TABLE `platform_settings` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `platform_settings` VALUES
(1,'site_name','\"CADIPLAY\"','2026-06-26 06:58:40'),
(2,'supported_languages','[\"en\", \"hi\", \"ta\", \"te\", \"ml\"]','2026-06-26 06:58:40'),
(3,'min_deposit','100','2026-06-26 06:58:40'),
(4,'min_withdrawal','500','2026-06-26 06:58:40'),
(5,'auto_approve_withdrawal_limit','10000','2026-06-26 06:58:40'),
(6,'game_status','{\"enabled\": true}','2026-06-26 06:58:40'),
(7,'affiliate_program','{\"currency\": \"INR\", \"payout_cycle\": \"monthly\", \"cpa_min_deposit\": 500, \"attribution_model\": \"last_click\", \"auto_approve_days\": 7, \"cookie_window_days\": 30, \"default_cpa_amount\": 500, \"max_override_depth\": 3, \"click_retention_days\": 180, \"min_payout_threshold\": 5000, \"deduct_bonus_from_ngr\": true, \"default_override_rate\": 5, \"default_commission_rate\": 30, \"default_commission_type\": \"revenue_share\", \"default_hybrid_cpa_days\": 30, \"fraud_flag_self_referral\": true, \"fraud_max_referrals_per_ip\": 5, \"negative_ngr_carry_forward\": true, \"fraud_block_disposable_emails\": true}','2026-08-12 00:00:00'),
(8,'agent_program','{\"currency\": \"INR\", \"review_hours\": 24, \"default_level\": \"agent\", \"max_partnership\": 100, \"min_partnership\": 0, \"default_partnership\": 25, \"default_opening_credit\": 0, \"default_commission_rate\": 2}','2026-08-19 00:00:00');

/*!40000 ALTER TABLE `platform_settings` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `player_tasks`
--

DROP TABLE IF EXISTS `player_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `player_tasks` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `task_type` varchar(60) DEFAULT NULL,
  `title` varchar(160) NOT NULL,
  `description` text,
  `status` enum('pending','in_progress','completed','cancelled') NOT NULL DEFAULT 'pending',
  `assigned_to` bigint unsigned DEFAULT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pt_status` (`status`),
  KEY `idx_pt_assigned` (`assigned_to`),
  KEY `idx_pt_user` (`user_id`),
  CONSTRAINT `player_tasks_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_tasks`
--

LOCK TABLES `player_tasks` WRITE;
/*!40000 ALTER TABLE `player_tasks` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `player_tasks` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `profile_upgrade_queue`
--

DROP TABLE IF EXISTS `profile_upgrade_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `profile_upgrade_queue` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `current_level` varchar(30) DEFAULT 'basic',
  `requested_level` varchar(30) NOT NULL,
  `document_count` int NOT NULL DEFAULT '0',
  `status` enum('pending','approved','declined') NOT NULL DEFAULT 'pending',
  `reviewer_id` bigint unsigned DEFAULT NULL,
  `note` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_puq_user` (`user_id`),
  KEY `idx_puq_status` (`status`),
  CONSTRAINT `fk_puq_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile_upgrade_queue`
--

LOCK TABLES `profile_upgrade_queue` WRITE;
/*!40000 ALTER TABLE `profile_upgrade_queue` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `profile_upgrade_queue` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `promotion_posters`
--

DROP TABLE IF EXISTS `promotion_posters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotion_posters` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(150) DEFAULT NULL,
  `image_url` varchar(500) NOT NULL,
  `link_url` varchar(500) DEFAULT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `status` enum('draft','active') DEFAULT 'draft',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotion_posters`
--

LOCK TABLES `promotion_posters` WRITE;
/*!40000 ALTER TABLE `promotion_posters` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `promotion_posters` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sport_bets`
--

DROP TABLE IF EXISTS `sport_bets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sport_bets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `agent_id` bigint unsigned DEFAULT NULL,
  `event_id` bigint unsigned NOT NULL,
  `market_id` bigint unsigned NOT NULL,
  `selection_name` varchar(150) DEFAULT NULL,
  `side` enum('back','lay') NOT NULL DEFAULT 'back',
  `odds` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `run_line` decimal(10,2) DEFAULT NULL,
  `stake` decimal(18,2) NOT NULL,
  `liability` decimal(18,2) NOT NULL DEFAULT '0.00',
  `potential_win` decimal(18,2) NOT NULL DEFAULT '0.00',
  `exposure` decimal(18,2) NOT NULL DEFAULT '0.00',
  `profit_loss` decimal(18,2) NOT NULL DEFAULT '0.00',
  `commission` decimal(18,2) NOT NULL DEFAULT '0.00',
  `status` enum('open','won','lost','void','cancelled') NOT NULL DEFAULT 'open',
  `ip_address` varchar(45) DEFAULT NULL,
  `placed_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `settled_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_sb_user` (`user_id`,`placed_at`),
  KEY `idx_sb_agent` (`agent_id`,`placed_at`),
  KEY `idx_sb_event` (`event_id`),
  KEY `idx_sb_market` (`market_id`),
  KEY `idx_sb_status` (`status`),
  CONSTRAINT `sport_bets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sport_bets_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `sport_events` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sport_bets_ibfk_3` FOREIGN KEY (`market_id`) REFERENCES `sport_markets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sport_bets`
--

LOCK TABLES `sport_bets` WRITE;
/*!40000 ALTER TABLE `sport_bets` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `sport_bets` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sport_configurations`
--

DROP TABLE IF EXISTS `sport_configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sport_configurations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `config_key` varchar(80) NOT NULL,
  `config_value` text,
  `updated_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sc_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sport_configurations`
--

LOCK TABLES `sport_configurations` WRITE;
/*!40000 ALTER TABLE `sport_configurations` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `sport_configurations` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sport_event_settings`
--

DROP TABLE IF EXISTS `sport_event_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sport_event_settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `event_id` bigint unsigned NOT NULL,
  `max_stake` decimal(18,2) DEFAULT '0.00',
  `min_stake` decimal(18,2) DEFAULT '0.00',
  `volume_limit` decimal(18,2) DEFAULT '1.00',
  `odds_limit` decimal(10,2) DEFAULT '0.00',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ses_event` (`event_id`),
  CONSTRAINT `sport_event_settings_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `sport_events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sport_event_settings`
--

LOCK TABLES `sport_event_settings` WRITE;
/*!40000 ALTER TABLE `sport_event_settings` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `sport_event_settings` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sport_events`
--

DROP TABLE IF EXISTS `sport_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sport_events` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sport` varchar(40) NOT NULL,
  `event_key` varchar(64) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `competition` varchar(150) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `status` enum('upcoming','in_play','closed','settled','abandoned') NOT NULL DEFAULT 'upcoming',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `event_key` (`event_key`),
  KEY `idx_se_sport` (`sport`,`start_time`),
  KEY `idx_se_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sport_events`
--

LOCK TABLES `sport_events` WRITE;
/*!40000 ALTER TABLE `sport_events` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `sport_events` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sport_fancy`
--

DROP TABLE IF EXISTS `sport_fancy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sport_fancy` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `event_id` bigint unsigned NOT NULL,
  `name` varchar(150) NOT NULL,
  `yes_value` int DEFAULT NULL,
  `no_value` int DEFAULT NULL,
  `min_bet` decimal(18,2) DEFAULT NULL,
  `max_bet` decimal(18,2) DEFAULT NULL,
  `exposure` decimal(18,2) NOT NULL DEFAULT '0.00',
  `status` enum('active','suspended','settled') NOT NULL DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_fancy_event` (`event_id`),
  KEY `idx_fancy_status` (`status`),
  CONSTRAINT `fk_fancy_event` FOREIGN KEY (`event_id`) REFERENCES `sport_events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sport_fancy`
--

LOCK TABLES `sport_fancy` WRITE;
/*!40000 ALTER TABLE `sport_fancy` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `sport_fancy` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sport_markets`
--

DROP TABLE IF EXISTS `sport_markets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sport_markets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `event_id` bigint unsigned NOT NULL,
  `market_key` varchar(64) DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `market_type` enum('match_odds','bookmaker','fancy','toss','tied_match','other') NOT NULL DEFAULT 'match_odds',
  `status` enum('open','suspended','closed','settled') NOT NULL DEFAULT 'open',
  `winning_selection` varchar(150) DEFAULT NULL,
  `settled_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_favourite` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sm_event_key` (`event_id`,`market_key`),
  KEY `idx_sm_event` (`event_id`),
  KEY `idx_sm_type` (`market_type`),
  KEY `idx_sm_favourite` (`is_favourite`),
  CONSTRAINT `sport_markets_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `sport_events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sport_markets`
--

LOCK TABLES `sport_markets` WRITE;
/*!40000 ALTER TABLE `sport_markets` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `sport_markets` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sport_series`
--

DROP TABLE IF EXISTS `sport_series`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sport_series` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sport_id` bigint unsigned NOT NULL,
  `name` varchar(150) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `max_bet` decimal(18,2) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_series_sport` (`sport_id`),
  CONSTRAINT `fk_series_sport` FOREIGN KEY (`sport_id`) REFERENCES `sports` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sport_series`
--

LOCK TABLES `sport_series` WRITE;
/*!40000 ALTER TABLE `sport_series` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `sport_series` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sports`
--

DROP TABLE IF EXISTS `sports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sports` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `code` varchar(20) DEFAULT NULL,
  `min_bet` decimal(18,2) DEFAULT '100.00',
  `max_bet` decimal(18,2) DEFAULT '100000.00',
  `max_profit` decimal(18,2) DEFAULT '1000000.00',
  `commission_percent` decimal(6,3) DEFAULT '0.000',
  `bet_delay_seconds` int NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sports`
--

LOCK TABLES `sports` WRITE;
/*!40000 ALTER TABLE `sports` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `sports` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `staff_group_permissions`
--

DROP TABLE IF EXISTS `staff_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_group_permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `group_id` bigint unsigned NOT NULL,
  `module` varchar(60) NOT NULL,
  `permission` varchar(60) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sgp` (`group_id`,`module`,`permission`),
  CONSTRAINT `staff_group_permissions_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `staff_groups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_group_permissions`
--

LOCK TABLES `staff_group_permissions` WRITE;
/*!40000 ALTER TABLE `staff_group_permissions` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `staff_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `staff_groups`
--

DROP TABLE IF EXISTS `staff_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_groups` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_by` bigint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_staff_groups_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_groups`
--

LOCK TABLES `staff_groups` WRITE;
/*!40000 ALTER TABLE `staff_groups` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `staff_groups` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `support_tickets`
--

DROP TABLE IF EXISTS `support_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `support_tickets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `subject` varchar(255) NOT NULL,
  `category` enum('deposit','withdrawal','game','account','bonus','other') DEFAULT 'other',
  `priority` enum('low','medium','high') DEFAULT 'medium',
  `status` enum('open','in_progress','pending_user','resolved','closed') DEFAULT 'open',
  `importance` enum('low','medium','high','urgent') NOT NULL DEFAULT 'medium',
  `assigned_to` bigint unsigned DEFAULT NULL,
  `last_activity_at` datetime DEFAULT NULL,
  `source` enum('web','email','whatsapp','phone','app') DEFAULT 'web',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `idx_tickets_status` (`status`),
  KEY `idx_st_assigned` (`assigned_to`),
  CONSTRAINT `support_tickets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `support_tickets`
--

LOCK TABLES `support_tickets` WRITE;
/*!40000 ALTER TABLE `support_tickets` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `support_tickets` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ticket_messages`
--

DROP TABLE IF EXISTS `ticket_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket_messages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` bigint unsigned NOT NULL,
  `sender_type` enum('user','agent','system') NOT NULL,
  `sender_id` bigint unsigned DEFAULT NULL,
  `message` text NOT NULL,
  `is_internal` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ticket_id` (`ticket_id`),
  CONSTRAINT `ticket_messages_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `support_tickets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_messages`
--

LOCK TABLES `ticket_messages` WRITE;
/*!40000 ALTER TABLE `ticket_messages` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ticket_messages` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `type` enum('deposit','withdrawal','bonus_credit','bet_settlement','refund','adjustment') NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `currency` varchar(10) DEFAULT 'USD',
  `status` enum('pending','processing','completed','failed','rejected','cancelled') DEFAULT 'pending',
  `payment_method` varchar(50) DEFAULT NULL,
  `provider_id` bigint unsigned DEFAULT NULL,
  `provider_payment_id` varchar(120) DEFAULT NULL,
  `payment_provider` varchar(50) DEFAULT NULL,
  `reference_number` varchar(255) DEFAULT NULL,
  `payment_proof_url` varchar(500) DEFAULT NULL,
  `bonus_id` bigint unsigned DEFAULT NULL,
  `fraud_score` int DEFAULT '0',
  `metadata` json DEFAULT NULL,
  `notes` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `error_message` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tx_user` (`user_id`),
  KEY `idx_tx_type_status` (`type`,`status`),
  KEY `idx_tx_created` (`created_at`),
  KEY `idx_tx_provider_payment` (`provider_payment_id`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `transactions` VALUES
(1,2,'deposit',500.00,'USDT','rejected','upi',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-09-05 14:00:44','2026-09-30 09:15:04',NULL),
(2,3,'deposit',1000.00,'USDT','rejected','crypto',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-09-05 14:03:11','2026-09-30 09:15:07',NULL),
(3,4,'deposit',100.00,'USDT','rejected','crypto',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-09-06 08:42:33','2026-09-30 09:15:10',NULL),
(4,4,'deposit',100.00,'USDT','rejected','crypto',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-09-06 08:42:55','2026-09-30 09:15:14',NULL),
(5,4,'deposit',100.00,'USDT','rejected','upi',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-09-06 08:43:18','2026-09-30 09:15:17',NULL),
(6,7,'bet_settlement',1100.00,'USD','completed',NULL,NULL,NULL,NULL,'1c9619c6-d3e1-3245-ac36-f354900c02cb',NULL,NULL,0,NULL,'Loss on 92b24e4c25107367a80e0fe1a97c24e4 (bet=1100, win=0)','2026-09-22 12:48:39','2026-09-22 12:48:39',NULL),
(7,8,'deposit',100.00,'USDT','rejected','upi',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-09-22 13:08:05','2026-09-30 09:15:23',NULL),
(8,7,'bet_settlement',2100.00,'USD','completed',NULL,NULL,NULL,NULL,'2fbdf3fb-9b21-3bde-9bd8-38b5e8516356',NULL,NULL,0,NULL,'Win on 92b24e4c25107367a80e0fe1a97c24e4 (bet=0, win=2100)','2026-09-23 04:10:34','2026-09-23 04:10:34',NULL),
(9,11,'deposit',500.00,'USDT','rejected','upi',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-09-24 07:53:37','2026-09-30 09:15:26',NULL),
(10,11,'deposit',500.00,'USDT','rejected','card',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-09-24 07:53:55','2026-09-30 09:15:29',NULL),
(11,11,'deposit',1000.00,'USDT','rejected','upi',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-09-24 08:21:03','2026-09-30 09:15:35',NULL),
(12,13,'deposit',500.00,'USDT','rejected','crypto',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-09-26 07:20:52','2026-09-30 09:14:54',NULL),
(13,9,'bet_settlement',100.00,'USD','completed',NULL,NULL,NULL,NULL,'834d664c-69f7-3bad-ac23-46451103a79a',NULL,NULL,0,NULL,'Loss on 08ced9dd788aed11ff3c7f387ae0f063 (bet=100.0, win=0)','2026-09-26 07:44:54','2026-09-26 07:44:54',NULL),
(14,16,'bet_settlement',100.00,'USD','completed',NULL,NULL,NULL,NULL,'22414963-a15c-39f5-a5b1-ebe7972a12c6',NULL,NULL,0,NULL,'Loss on 08ced9dd788aed11ff3c7f387ae0f063 (bet=100.0, win=0)','2026-09-26 07:51:02','2026-09-26 07:51:02',NULL),
(15,9,'bet_settlement',266.00,'USD','completed',NULL,NULL,NULL,NULL,'f8691b6e-e059-30cc-a93b-d1535b999e16',NULL,NULL,0,NULL,'Win on 08ced9dd788aed11ff3c7f387ae0f063 (bet=0.0, win=266.0000)','2026-09-26 07:56:07','2026-09-26 07:56:07',NULL),
(16,5,'adjustment',100.00,'USDT','completed',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'Admin adjustment: +100.0','2026-09-26 07:56:57','2026-09-26 07:56:57',NULL),
(17,5,'bet_settlement',100.00,'USD','completed',NULL,NULL,NULL,NULL,'a557d5ae-84ff-32c3-a772-df87d13a99cf',NULL,NULL,0,NULL,'Loss on 08ced9dd788aed11ff3c7f387ae0f063 (bet=100.0, win=0)','2026-09-26 17:59:13','2026-09-26 17:59:13',NULL),
(18,5,'bet_settlement',148.00,'USD','completed',NULL,NULL,NULL,NULL,'9b1793de-e8dd-3e8f-b780-58e66f2f8eaf',NULL,NULL,0,NULL,'Win on 08ced9dd788aed11ff3c7f387ae0f063 (bet=0.0, win=148.0000)','2026-09-26 18:34:51','2026-09-26 18:34:51',NULL),
(19,17,'deposit',100.00,'USDT','rejected','crypto',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-09-28 13:39:56','2026-09-30 09:14:48',NULL),
(20,18,'deposit',100.00,'USDT','completed','crypto',NULL,NULL,NULL,'ADMIN-1790759072483',NULL,NULL,0,NULL,NULL,'2026-09-30 09:00:22','2026-09-30 09:04:33',NULL),
(21,19,'deposit',500.00,'USDT','completed','upi',NULL,NULL,NULL,'ADMIN-1790759638453',NULL,NULL,0,NULL,NULL,'2026-09-30 09:13:00','2026-09-30 09:13:59',NULL),
(22,19,'adjustment',500.00,'USDT','completed',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'testing','2026-09-30 09:15:51','2026-09-30 09:15:51',NULL),
(23,18,'deposit',500.00,'USDT','pending','crypto',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-10-01 10:54:20','2026-10-01 10:54:20',NULL),
(24,20,'adjustment',100.00,'USDT','completed',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'Testing','2026-10-02 19:45:33','2026-10-02 19:45:33',NULL),
(25,20,'bet_settlement',20.00,'USD','completed',NULL,NULL,NULL,NULL,'4753242e-4c8a-3835-a848-83fc5dc00abd',NULL,NULL,0,NULL,'Loss on 88317b0c9ebdb820791b9a04f7f4cb53 (bet=20.0, win=0)','2026-10-02 19:48:21','2026-10-02 19:48:21',NULL),
(26,20,'bet_settlement',30.00,'USD','completed',NULL,NULL,NULL,NULL,'0879f04e-0813-39c1-bbd9-1079f10c05a0',NULL,NULL,0,NULL,'Win on 88317b0c9ebdb820791b9a04f7f4cb53 (bet=0, win=30.0)','2026-10-02 19:48:39','2026-10-02 19:48:39',NULL),
(27,11,'deposit',500.00,'USDT','pending','upi',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-10-03 06:21:05','2026-10-03 06:21:05',NULL),
(28,11,'deposit',500.00,'USDT','pending','crypto',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-10-03 08:07:56','2026-10-03 08:07:56',NULL),
(29,19,'bet_settlement',100.00,'USD','completed',NULL,NULL,NULL,NULL,'212a8daa-70ce-36f1-b289-77dd2fbabe4a',NULL,NULL,0,NULL,'Loss on 08ced9dd788aed11ff3c7f387ae0f063 (bet=100.0, win=0)','2026-10-03 15:42:55','2026-10-03 15:42:55',NULL),
(30,19,'bet_settlement',100.00,'USD','completed',NULL,NULL,NULL,NULL,'d0eb4f19-7738-307f-820f-8338b8eaac38',NULL,NULL,0,NULL,'Win on 08ced9dd788aed11ff3c7f387ae0f063 (bet=0, win=100.0)','2026-10-03 15:42:56','2026-10-03 15:42:56',NULL),
(31,19,'bet_settlement',100.00,'USD','completed',NULL,NULL,NULL,NULL,'84295924-9b42-37f9-a56e-ee4f4e81da97',NULL,NULL,0,NULL,'Loss on 08ced9dd788aed11ff3c7f387ae0f063 (bet=100.0, win=0)','2026-10-03 15:45:11','2026-10-03 15:45:11',NULL),
(32,19,'bet_settlement',100.00,'USD','completed',NULL,NULL,NULL,NULL,'db99fa32-e9ca-3e2a-b04d-c1bbe567ff5c',NULL,NULL,0,NULL,'Loss on 08ced9dd788aed11ff3c7f387ae0f063 (bet=100.0, win=0)','2026-10-03 15:45:12','2026-10-03 15:45:12',NULL),
(33,19,'bet_settlement',100.00,'USD','completed',NULL,NULL,NULL,NULL,'0b241ed0-d4d1-3fb2-aacb-827023634870',NULL,NULL,0,NULL,'Loss on 08ced9dd788aed11ff3c7f387ae0f063 (bet=100.0, win=0)','2026-10-03 15:45:13','2026-10-03 15:45:13',NULL),
(34,21,'deposit',100.00,'USDT','pending','upi',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-10-04 11:47:21','2026-10-04 11:47:21',NULL),
(35,23,'deposit',3000.00,'USDT','completed','upi',NULL,NULL,NULL,'ADMIN-1791150963509',NULL,NULL,0,NULL,NULL,'2026-10-04 21:32:26','2026-10-04 21:56:04',NULL),
(36,25,'deposit',5000.00,'USDT','completed','upi',NULL,NULL,NULL,'ADMIN-1791151655482',NULL,NULL,0,NULL,NULL,'2026-10-04 22:07:27','2026-10-04 22:07:36',NULL),
(37,26,'deposit',5000.00,'USDT','completed','upi',NULL,NULL,NULL,'ADMIN-1791152293075',NULL,NULL,0,NULL,NULL,'2026-10-04 22:18:07','2026-10-04 22:18:13',NULL),
(38,27,'adjustment',2000.00,'USDT','completed',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'ADJUSTMENT','2026-10-04 23:09:14','2026-10-04 23:09:14',NULL);

/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `user_bonuses`
--

DROP TABLE IF EXISTS `user_bonuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_bonuses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `bonus_id` bigint unsigned DEFAULT NULL,
  `amount` decimal(18,2) NOT NULL,
  `wagering_required` decimal(18,2) DEFAULT '0.00',
  `wagering_completed` decimal(18,2) DEFAULT '0.00',
  `credit_target` enum('bonus','main') DEFAULT 'bonus',
  `award_mode` enum('locked','pending') NOT NULL DEFAULT 'locked',
  `source` enum('joining','deposit','referral','game','cashback','promo','manual') NOT NULL DEFAULT 'manual',
  `transaction_id` bigint unsigned DEFAULT NULL,
  `granted_by` bigint unsigned DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `status` enum('pending','active','completed','expired','forfeited') DEFAULT 'pending',
  `expires_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_bonuses_user` (`user_id`),
  KEY `idx_user_bonuses_bonus` (`bonus_id`),
  KEY `idx_user_bonuses_source` (`source`),
  KEY `idx_user_bonuses_user_bonus` (`user_id`,`bonus_id`),
  CONSTRAINT `user_bonuses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_bonuses_ibfk_2` FOREIGN KEY (`bonus_id`) REFERENCES `bonuses` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_bonuses`
--

LOCK TABLES `user_bonuses` WRITE;
/*!40000 ALTER TABLE `user_bonuses` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `user_bonuses` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `user_settings`
--

DROP TABLE IF EXISTS `user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `gender` enum('male','female','other','prefer_not_to_say') DEFAULT NULL,
  `phone_verified` tinyint(1) DEFAULT '0',
  `two_factor_enabled` tinyint(1) DEFAULT '0',
  `two_factor_secret` varchar(255) DEFAULT NULL,
  `affiliate_id` bigint unsigned DEFAULT NULL,
  `agent_id` bigint unsigned DEFAULT NULL,
  `referral_code` varchar(20) DEFAULT NULL,
  `referred_by` bigint unsigned DEFAULT NULL,
  `fraud_score` int DEFAULT '0',
  `risk_level` enum('low','medium','high') DEFAULT 'low',
  `vip_level` int DEFAULT '0',
  `is_demo` tinyint(1) DEFAULT '0',
  `demo_expires_at` datetime DEFAULT NULL,
  `website_language` varchar(10) DEFAULT 'en',
  `communication_language` varchar(10) DEFAULT 'en',
  `currency` varchar(10) DEFAULT 'USD',
  `registration_path` enum('direct') DEFAULT 'direct',
  `preferred_game_type` varchar(50) DEFAULT NULL,
  `typical_bet_range` varchar(20) DEFAULT NULL,
  `ai_voice_executive_id` varchar(50) DEFAULT NULL,
  `notifications_enabled` tinyint(1) DEFAULT '1',
  `marketing_opt_in` tinyint(1) DEFAULT '0',
  `settings` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `affiliate_link_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_settings_user` (`user_id`),
  UNIQUE KEY `uk_user_settings_referral_code` (`referral_code`),
  KEY `idx_user_settings_referred_by` (`referred_by`),
  KEY `idx_us_agent` (`agent_id`),
  CONSTRAINT `user_settings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_settings`
--

LOCK TABLES `user_settings` WRITE;
/*!40000 ALTER TABLE `user_settings` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `user_settings` VALUES
(1,2,NULL,0,0,NULL,NULL,NULL,NULL,NULL,0,'low',0,1,'2026-09-05 14:28:32','en','en','USDT','direct',NULL,NULL,NULL,1,0,NULL,'2026-09-05 13:58:32','2026-09-05 13:58:32',NULL),
(2,3,NULL,1,0,NULL,NULL,NULL,'ZEE4QW68',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_018',1,0,NULL,'2026-09-05 14:02:41','2026-09-05 14:02:41',NULL),
(3,4,NULL,1,0,NULL,NULL,NULL,'Y4ER75K3',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_020',1,0,NULL,'2026-09-06 08:41:41','2026-09-06 08:41:41',NULL),
(4,5,NULL,1,0,NULL,NULL,NULL,'U5KRA9MW',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_002',1,0,NULL,'2026-09-06 15:49:59','2026-10-04 23:10:35',NULL),
(5,6,NULL,0,0,NULL,NULL,NULL,NULL,NULL,0,'low',0,1,'2026-09-19 20:27:39','en','en','USDT','direct',NULL,NULL,NULL,1,0,NULL,'2026-09-19 19:57:39','2026-09-19 19:57:39',NULL),
(6,7,NULL,0,0,NULL,NULL,NULL,NULL,NULL,0,'low',0,1,'2026-09-22 13:17:37','en','en','USDT','direct',NULL,NULL,NULL,1,0,NULL,'2026-09-22 12:47:37','2026-09-22 12:47:37',NULL),
(7,8,NULL,1,0,NULL,NULL,NULL,'3NDEHTDD',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_020',1,0,NULL,'2026-09-22 12:49:41','2026-09-22 12:49:41',NULL),
(8,9,NULL,0,0,NULL,NULL,NULL,NULL,NULL,0,'low',0,1,'2026-09-23 19:31:19','en','en','USDT','direct',NULL,NULL,NULL,1,0,NULL,'2026-09-23 19:01:19','2026-09-23 19:01:19',NULL),
(9,10,NULL,0,0,NULL,NULL,NULL,NULL,NULL,0,'low',0,1,'2026-09-24 08:08:46','en','en','USDT','direct',NULL,NULL,NULL,1,0,NULL,'2026-09-24 07:38:46','2026-09-24 07:38:46',NULL),
(10,11,NULL,1,0,NULL,NULL,NULL,'NYY6X6CX',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_031',1,0,NULL,'2026-09-24 07:53:02','2026-09-24 07:53:02',NULL),
(11,12,NULL,0,0,NULL,NULL,NULL,NULL,NULL,0,'low',0,1,'2026-09-24 09:56:24','en','en','USDT','direct',NULL,NULL,NULL,1,0,NULL,'2026-09-24 09:26:24','2026-09-24 09:26:24',NULL),
(12,13,NULL,1,0,NULL,NULL,NULL,'7NYVTZRV',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_006',1,0,NULL,'2026-09-26 07:20:31','2026-09-26 07:20:31',NULL),
(13,14,NULL,0,0,NULL,NULL,NULL,NULL,NULL,0,'low',0,1,'2026-09-26 08:18:12','en','en','USDT','direct',NULL,NULL,NULL,1,0,NULL,'2026-09-26 07:48:12','2026-09-26 07:48:12',NULL),
(14,15,NULL,0,0,NULL,NULL,NULL,NULL,NULL,0,'low',0,1,'2026-09-26 08:18:39','en','en','USDT','direct',NULL,NULL,NULL,1,0,NULL,'2026-09-26 07:48:39','2026-09-26 07:48:39',NULL),
(15,16,NULL,0,0,NULL,NULL,NULL,NULL,NULL,0,'low',0,1,'2026-09-26 08:20:10','en','en','USDT','direct',NULL,NULL,NULL,1,0,NULL,'2026-09-26 07:50:10','2026-09-26 07:50:10',NULL),
(16,17,NULL,1,0,NULL,NULL,NULL,'S4QY2ZFW',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_027',1,0,NULL,'2026-09-28 13:39:45','2026-10-04 21:52:05',NULL),
(17,18,NULL,1,0,NULL,NULL,NULL,'8PVZUA4S',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_018',1,0,NULL,'2026-09-30 09:00:01','2026-09-30 09:00:01',NULL),
(18,19,NULL,1,0,NULL,NULL,NULL,'9WC2M9V5',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_024',1,0,NULL,'2026-09-30 09:12:43','2026-09-30 09:12:43',NULL),
(19,20,NULL,1,0,NULL,NULL,NULL,'EL43JX9B',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_006',1,0,NULL,'2026-10-02 19:43:11','2026-10-02 19:43:11',NULL),
(20,21,NULL,1,0,NULL,NULL,NULL,'7D4FRGZU',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_011',1,0,NULL,'2026-10-04 11:46:09','2026-10-04 11:46:09',NULL),
(21,22,NULL,0,0,NULL,NULL,NULL,NULL,NULL,0,'low',0,1,'2026-10-04 21:39:39','en','en','USDT','direct',NULL,NULL,NULL,1,0,NULL,'2026-10-04 21:09:39','2026-10-04 21:09:39',NULL),
(22,23,NULL,1,0,NULL,NULL,NULL,'TPDAYSSZ',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_015',1,0,NULL,'2026-10-04 21:32:04','2026-10-04 21:32:04',NULL),
(23,24,NULL,1,0,NULL,NULL,NULL,'GGZAG9BH',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_037',1,0,NULL,'2026-10-04 21:49:59','2026-10-04 21:49:59',NULL),
(24,25,NULL,1,0,NULL,NULL,NULL,'8DJVA6TX',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_021',1,0,NULL,'2026-10-04 22:07:18','2026-10-04 22:07:18',NULL),
(25,26,NULL,1,0,NULL,NULL,NULL,'YL73S7PG',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_046',1,0,NULL,'2026-10-04 22:18:00','2026-10-04 22:18:00',NULL),
(26,27,NULL,1,0,NULL,NULL,NULL,'9T6N3S27',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_047',1,0,NULL,'2026-10-04 23:07:39','2026-10-04 23:15:43',NULL),
(27,28,NULL,1,0,NULL,NULL,NULL,'SRGBFYGN',NULL,0,'low',0,0,NULL,'en','en','USDT','direct',NULL,NULL,'AI_EXEC_002',1,0,NULL,'2026-10-04 23:24:16','2026-10-04 23:24:16',NULL);

/*!40000 ALTER TABLE `user_settings` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `country_code` char(2) DEFAULT NULL,
  `state` varchar(60) DEFAULT NULL,
  `signup_ip` varchar(45) DEFAULT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `role` enum('user','admin') NOT NULL DEFAULT 'user',
  `staff_group_id` bigint unsigned DEFAULT NULL,
  `account_status` enum('active','inactive','suspended','blocked') DEFAULT 'active',
  `last_login_at` datetime DEFAULT NULL,
  -- Most recently issued login token id; a newer login invalidates older sessions.
  `active_session_id` varchar(64) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `phone` (`phone`),
  KEY `idx_users_phone` (`phone`),
  KEY `idx_users_status` (`account_status`),
  KEY `idx_users_country` (`country_code`),
  KEY `idx_users_role` (`role`),
  KEY `idx_users_signup_ip` (`signup_ip`),
  KEY `idx_users_created_at` (`created_at`),
  KEY `idx_users_staff_group` (`staff_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `users` VALUES
(1,'admin',NULL,NULL,NULL,NULL,NULL,'$2b$12$7ApjIY9R97wMLZ4Q5QnateoIhY9YZFqC3.xHAc0RDM8k6kBoPCQge','Platform Admin','admin',NULL,'active','2026-10-04 23:08:15',NULL,'2026-09-04 15:02:40','2026-10-04 23:08:15'),
(2,'DEMO_9DJBY4JM',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'user',NULL,'active',NULL,NULL,'2026-09-05 13:58:32','2026-09-05 13:58:32'),
(3,'10000000','IN',NULL,NULL,NULL,'9856256956','$2b$12$lHKrCmdGyBDjtT2tNY7S6ugKr1L9/Gtu7B9qh/kluYdV6s4txCGgK','Ravan','user',NULL,'active',NULL,NULL,'2026-09-05 14:02:41','2026-09-05 14:02:41'),
(4,'10000001','IN',NULL,NULL,NULL,'7418529630','$2b$12$vpxwAl3cc2VIopXenZY6eeArEI8S67tsWzkbvSugOHhwQ8A9oc.N6','Tanuj','user',NULL,'active',NULL,NULL,'2026-09-06 08:41:41','2026-09-06 08:41:41'),
(5,'10000002','IN',NULL,NULL,NULL,'1111111111','$2b$12$EQjQpwDTt9XdKwSJZvLkO.gyRwbCpW0FwIURJBDSWheDq253YSumO','TESTING','user',NULL,'active','2026-10-04 23:10:35',NULL,'2026-09-06 15:49:59','2026-10-04 23:10:35'),
(6,'DEMO_XIRVTERI',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'user',NULL,'active',NULL,NULL,'2026-09-19 19:57:39','2026-09-19 19:57:39'),
(7,'DEMO_HL299YMD',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'user',NULL,'active',NULL,NULL,'2026-09-22 12:47:37','2026-09-22 12:47:37'),
(8,'10000003','IN',NULL,NULL,NULL,'7015711089','$2b$12$OpZdbLAO6VLe9VsPX28YeOGQFeYKT4D8Gru5FlxV2TBWPBZifiGuW','robish mittal','user',NULL,'active',NULL,NULL,'2026-09-22 12:49:41','2026-09-22 12:49:41'),
(9,'DEMO_KWZY6O63',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'user',NULL,'active',NULL,NULL,'2026-09-23 19:01:19','2026-09-23 19:01:19'),
(10,'DEMO_TMDGVZ17',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'user',NULL,'active',NULL,NULL,'2026-09-24 07:38:46','2026-09-24 07:38:46'),
(11,'10000004','IN',NULL,NULL,NULL,'0558421678','$2b$12$0L7e7wwWUIRy2Fik1Q62YObzY.tmESwOSeSr.ra5OWWwNJsfqIXem','muhammed irshad','user',NULL,'active','2026-10-03 06:20:41',NULL,'2026-09-24 07:53:02','2026-10-03 06:20:41'),
(12,'DEMO_YT7IKMI1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'user',NULL,'active',NULL,NULL,'2026-09-24 09:26:24','2026-09-24 09:26:24'),
(13,'10000005','IN',NULL,NULL,NULL,'0545511223','$2b$12$ljJAlTPYxl5KIhBbFRvJj.90R6BsnlrlpHY.5iqW69wbsuotol66a','Dollar','user',NULL,'active',NULL,NULL,'2026-09-26 07:20:31','2026-09-26 07:20:31'),
(14,'DEMO_S7B43THU',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'user',NULL,'active',NULL,NULL,'2026-09-26 07:48:12','2026-09-26 07:48:12'),
(15,'DEMO_IYWZ4A34',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'user',NULL,'active',NULL,NULL,'2026-09-26 07:48:39','2026-09-26 07:48:39'),
(16,'DEMO_KQOC7GG6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'user',NULL,'active',NULL,NULL,'2026-09-26 07:50:10','2026-09-26 07:50:10'),
(17,'10000006','IN',NULL,NULL,NULL,'9500012345','$2b$12$z6yZ1lCz6Ph2uUTPmbx8OeqXgAYIJpkWnQ7/bZXXNiaod8YuDtGWS','Tanuj','user',NULL,'active','2026-10-04 21:52:06',NULL,'2026-09-28 13:39:45','2026-10-04 21:52:05'),
(18,'10000007','IN',NULL,NULL,NULL,'7373737373','$2b$12$E9PMgovxSCGoEgIgT0U6Ruzm23eRPAn2mCxMavrsa8vC9w.pAbdi.','Dollar','user',NULL,'active',NULL,NULL,'2026-09-30 09:00:01','2026-09-30 09:00:01'),
(19,'10000008','IN',NULL,NULL,NULL,'7878787878','$2b$12$F6jx0kJMi9JwzH6SgQI/Iuz95dkMDW6rPwBoAcgzc3IlrnwZYReJ6','Dhan','user',NULL,'active','2026-10-03 15:41:01',NULL,'2026-09-30 09:12:43','2026-10-03 15:41:00'),
(20,'10000009','IN',NULL,NULL,NULL,'5641100850','$2b$12$WExjn8b3oNFdWhBYO7mT5e506jmg.wsz7eoUsUQXCvFDoGsThUbYu','Tanuj','user',NULL,'active',NULL,NULL,'2026-10-02 19:43:11','2026-10-02 19:43:11'),
(21,'10000010','IN',NULL,NULL,NULL,'1234567995','$2b$12$GhE4JgbYfn7MwceHdFhel.u0SApPl7kzCeZR80mrEx88w2L3EMyhq','DEV','user',NULL,'active',NULL,NULL,'2026-10-04 11:46:09','2026-10-04 11:46:09'),
(22,'DEMO_5GI2NUV5',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'user',NULL,'active',NULL,NULL,'2026-10-04 21:09:39','2026-10-04 21:09:39'),
(23,'10000011','IN',NULL,'49.37.116.35',NULL,'1515151515','$2b$12$1wbZathVkVXn7r3WAigoueDFNmTQTeJQBuFgXJEFnMQEGbIQNfhW2','test','user',NULL,'active',NULL,NULL,'2026-10-04 21:32:04','2026-10-04 21:32:04'),
(24,'10000012','IN',NULL,'86.99.156.72',NULL,'7412589630','$2b$12$IqUksVDnzO0ciVICqNp.v.mkk4ZgDKbpMyKsQJ8flEHAm26QuAFU6','Tanujtech','user',NULL,'active',NULL,NULL,'2026-10-04 21:49:59','2026-10-04 21:49:59'),
(25,'10000013','IN',NULL,'49.37.116.35',NULL,'1616161616','$2b$12$2rxvLUob2L6/apXSX2WIpO.qN7YVX465GLujx/WudX9qfjGuze3W2','test new','user',NULL,'active',NULL,NULL,'2026-10-04 22:07:18','2026-10-04 22:07:18'),
(26,'10000014','IN',NULL,'49.37.116.35',NULL,'1011011011','$2b$12$.9kBfl/0OxM41wb/68rH8eHnbTcl68tybmjIrEKSleacmsFjVyf56','test now','user',NULL,'active',NULL,NULL,'2026-10-04 22:18:00','2026-10-04 22:18:00'),
(27,'10000015','IN',NULL,'86.96.106.82',NULL,'4444444444','$2b$12$6oEwwKoL9abr5x/LtIXDpeYKZu9VAgkHVom5rCFo8Uila3QMV9LCK','Dhan','user',NULL,'active','2026-10-04 23:15:44',NULL,'2026-10-04 23:07:39','2026-10-04 23:15:43'),
(28,'10000016','IN',NULL,'49.37.116.35',NULL,'1717171717','$2b$12$vidmTa/TcPTfFClUGAipmOP3VZFAG1/opkiSWgQkAR2xA3OyheefW','test fresh','user',NULL,'active',NULL,NULL,'2026-10-04 23:24:16','2026-10-04 23:24:16');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `wallets`
--

DROP TABLE IF EXISTS `wallets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wallets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `main_balance` decimal(18,2) DEFAULT '0.00',
  `bonus_balance` decimal(18,2) DEFAULT '0.00',
  `sports_bonus_balance` decimal(18,2) DEFAULT '0.00',
  `exposure_balance` decimal(18,2) DEFAULT '0.00',
  `locked_balance` decimal(18,2) DEFAULT '0.00',
  `wagering_balance` decimal(18,2) DEFAULT '0.00',
  `currency` varchar(10) DEFAULT 'USD',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_wallet_user` (`user_id`),
  CONSTRAINT `wallets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallets`
--

LOCK TABLES `wallets` WRITE;
/*!40000 ALTER TABLE `wallets` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `wallets` VALUES
(1,2,50000.00,5000.00,0.00,0.00,0.00,0.00,'USDT','2026-09-05 13:58:32','2026-09-05 13:58:32'),
(2,3,0.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-09-05 14:02:41','2026-09-05 14:02:41'),
(3,4,0.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-09-06 08:41:41','2026-09-06 08:41:41'),
(4,5,148.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-09-06 15:49:59','2026-09-26 18:34:51'),
(5,6,50000.00,5000.00,0.00,0.00,0.00,0.00,'USDT','2026-09-19 19:57:39','2026-09-19 19:57:39'),
(6,7,51000.00,5000.00,0.00,0.00,0.00,0.00,'USDT','2026-09-22 12:47:37','2026-09-23 04:10:34'),
(7,8,0.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-09-22 12:49:41','2026-09-22 12:49:41'),
(8,9,50166.00,5000.00,0.00,0.00,0.00,0.00,'USDT','2026-09-23 19:01:19','2026-09-26 07:56:07'),
(9,10,50000.00,5000.00,0.00,0.00,0.00,0.00,'USDT','2026-09-24 07:38:46','2026-09-24 07:38:46'),
(10,11,0.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-09-24 07:53:02','2026-09-24 07:53:02'),
(11,12,1000.00,5000.00,0.00,0.00,0.00,0.00,'USDT','2026-09-24 09:26:24','2026-09-24 09:26:24'),
(12,13,0.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-09-26 07:20:31','2026-09-26 07:20:31'),
(13,14,1000.00,5000.00,0.00,0.00,0.00,0.00,'USDT','2026-09-26 07:48:12','2026-09-26 07:48:12'),
(14,15,1000.00,5000.00,0.00,0.00,0.00,0.00,'USDT','2026-09-26 07:48:39','2026-09-26 07:48:39'),
(15,16,900.00,5000.00,0.00,0.00,0.00,0.00,'USDT','2026-09-26 07:50:10','2026-09-26 07:51:02'),
(16,17,0.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-09-28 13:39:45','2026-09-28 13:39:45'),
(17,18,100.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-09-30 09:00:01','2026-09-30 09:04:32'),
(18,19,700.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-09-30 09:12:43','2026-10-03 15:45:13'),
(19,20,110.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-10-02 19:43:11','2026-10-02 19:48:39'),
(20,21,0.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-10-04 11:46:09','2026-10-04 11:46:09'),
(21,22,1000.00,5000.00,0.00,0.00,0.00,0.00,'USDT','2026-10-04 21:09:39','2026-10-04 21:09:39'),
(22,23,3000.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-10-04 21:32:04','2026-10-04 21:56:03'),
(23,24,0.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-10-04 21:49:59','2026-10-04 21:49:59'),
(24,25,5000.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-10-04 22:07:18','2026-10-04 22:07:35'),
(25,26,5000.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-10-04 22:18:00','2026-10-04 22:18:13'),
(26,27,2000.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-10-04 23:07:39','2026-10-04 23:09:14'),
(27,28,0.00,0.00,0.00,0.00,0.00,0.00,'USDT','2026-10-04 23:24:16','2026-10-04 23:24:16');

/*!40000 ALTER TABLE `wallets` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `withdrawal_stages`
--

DROP TABLE IF EXISTS `withdrawal_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `withdrawal_stages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `transaction_id` bigint unsigned NOT NULL,
  `stage` enum('account_verification','duplicate_check','wagering_compliance','final_approval','payment_processing') NOT NULL,
  `status` enum('pending','passed','failed','review') DEFAULT 'pending',
  `details` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `transaction_id` (`transaction_id`),
  CONSTRAINT `withdrawal_stages_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `withdrawal_stages`
--

LOCK TABLES `withdrawal_stages` WRITE;
/*!40000 ALTER TABLE `withdrawal_stages` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `withdrawal_stages` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Dumping routines for database 'cadiplay'
--
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_bo_add_column` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
DELIMITER ;;
CREATE PROCEDURE `_bo_add_column`(
  IN tbl VARCHAR(64), IN col VARCHAR(64), IN ddl VARCHAR(512)
)
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = tbl AND COLUMN_NAME = col
  ) THEN
    SET @sql = CONCAT('ALTER TABLE `', tbl, '` ADD COLUMN ', ddl);
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_bo_add_index` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
DELIMITER ;;
CREATE PROCEDURE `_bo_add_index`(
  IN tbl VARCHAR(64), IN idx VARCHAR(64), IN cols VARCHAR(255)
)
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = tbl AND INDEX_NAME = idx
  ) THEN
    SET @sql = CONCAT('ALTER TABLE `', tbl, '` ADD INDEX `', idx, '` (', cols, ')');
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- ===========================================================================
-- Normalize game_providers / games.provider_id (idempotent; safe on fresh import)
-- ===========================================================================

INSERT INTO `game_providers` (`name`, `slug`, `is_active`, `created_at`)
SELECT * FROM (SELECT 'PG Soft' AS n, 'pg-soft' AS s, 1 AS a, NOW() AS c) AS t
WHERE NOT EXISTS (SELECT 1 FROM `game_providers` WHERE `name` = 'PG Soft');

UPDATE `games` g
  JOIN `game_providers` p ON p.`name` = TRIM(g.`game_type`)
SET g.`provider_id` = p.`id`
WHERE (g.`provider_id` IN (1,2,3,4,5,6,7) OR g.`provider_id` IS NULL)
  AND g.`game_type` IS NOT NULL
  AND p.`id` NOT IN (1,2,3,4,5,6,7)
  AND g.`provider_id` <> p.`id`;

UPDATE `games` g
  JOIN `game_providers` p
    ON p.`name` = CASE LOWER(TRIM(g.`game_type`))
         WHEN 'slot'            THEN 'PG Soft'
         WHEN 'casinotable'     THEN 'Spribe'
         WHEN '18peaches'       THEN '18 Peaches'
         WHEN 'inout minigames' THEN 'IN OUT MINI GAMES'
         WHEN 'lottery'         THEN 'India Lotto'
         WHEN 'cockfighting'    THEN 'Odin Cockfighting'
         WHEN 'sport'           THEN 'SportsGame'
         WHEN 'sports'          THEN 'SportsGame'
         WHEN 'blackjack'       THEN 'Evolution Live'
         WHEN 'casino'          THEN 'Evolution Live'
       END
SET g.`provider_id` = p.`id`
WHERE (g.`provider_id` IN (1,2,3,4,5,6,7) OR g.`provider_id` IS NULL)
  AND g.`provider_id` <> p.`id`;

UPDATE `games` g
  JOIN `game_providers` p ON p.`name` = 'Evolution Live'
SET g.`provider_id` = p.`id`
WHERE TRIM(g.`name`) IN (
        'Lightning Roulette', 'Speed Roulette', 'Immersive Roulette',
        'Baccarat B', 'First Person Lightning Baccarat', 'Infinite blackjack',
        'Power Blackjack', 'Blackjack Silver'
      )
  AND (g.`provider_id` IN (1,2,3,4,5,6,7) OR g.`provider_id` IS NULL);

UPDATE `games` g
  JOIN `game_providers` p ON p.`name` = 'LuckSportsGame'
SET g.`provider_id` = p.`id`
WHERE g.`name` = 'Luck Sports'
  AND (g.`provider_id` IN (1,2,3,4,5,6,7) OR g.`provider_id` IS NULL);

UPDATE `games` g
  JOIN `game_providers` p ON p.`name` = 'India Poker Game'
SET g.`provider_id` = p.`id`
WHERE TRIM(g.`name`) = 'Pool Rummy'
  AND (g.`provider_id` IN (1,2,3,4,5,6,7) OR g.`provider_id` IS NULL);

UPDATE `games` g
  JOIN `game_providers` p ON p.`name` = 'Fish Game'
SET g.`provider_id` = p.`id`
WHERE TRIM(g.`name`) = 'Mines Raider'
  AND (g.`provider_id` IN (1,2,3,4,5,6,7) OR g.`provider_id` IS NULL);

UPDATE `games` g
  JOIN `game_providers` p ON p.`name` = 'jilli'
SET g.`provider_id` = p.`id`
WHERE TRIM(g.`name`) = 'Wheel'
  AND g.`thumbnail_url` LIKE '%/gamelogo/JILI/%'
  AND (g.`provider_id` IN (1,2,3,4,5,6,7) OR g.`provider_id` IS NULL);

UPDATE `games` g
  JOIN `game_providers` p ON p.`name` = 'jilli'
  JOIN `game_providers` cur ON cur.`id` = g.`provider_id`
SET g.`provider_id` = p.`id`
WHERE g.`thumbnail_url` LIKE '%/gamelogo/JILI/%'
  AND cur.`name` = 'CasinoLive';

UPDATE `games` g
  JOIN `game_providers` p ON p.`id` = g.`provider_id`
SET g.`game_type` = p.`name`
WHERE (g.`game_type` IS NULL OR g.`game_type` = '')
  AND p.`id` NOT IN (1,2,3,4,5,6,7);

UPDATE `game_providers`
SET `is_active` = 0
WHERE `id` IN (1,2,3,4,5,6,7)
  AND NOT EXISTS (SELECT 1 FROM `games` WHERE `games`.`provider_id` = `game_providers`.`id`);

