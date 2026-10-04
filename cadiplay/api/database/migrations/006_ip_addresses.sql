-- Migration: persist player IP on signup, cashier and game launch
-- Run directly against each existing tenant database:
--   mysql -u root <tenant_db> < database/migrations/006_ip_addresses.sql
--
-- Safe to re-run: each ADD COLUMN is skipped when the column already exists.

SET NAMES utf8mb4;

DROP PROCEDURE IF EXISTS _cadiplay_add_column_006;
DELIMITER $$
CREATE PROCEDURE _cadiplay_add_column_006(
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
END$$
DELIMITER ;

CALL _cadiplay_add_column_006('user_settings', 'signup_ip', "signup_ip VARCHAR(45) NULL AFTER settings");
CALL _cadiplay_add_column_006('user_settings', 'last_ip', "last_ip VARCHAR(45) NULL AFTER signup_ip");
CALL _cadiplay_add_column_006('transactions', 'ip_address', "ip_address VARCHAR(45) NULL AFTER notes");
CALL _cadiplay_add_column_006('game_sessions', 'ip_address', "ip_address VARCHAR(45) NULL AFTER last_played_at");

DROP PROCEDURE IF EXISTS _cadiplay_add_column_006;
