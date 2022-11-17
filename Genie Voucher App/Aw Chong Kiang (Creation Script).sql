-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Customer` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Customer` (
  `customer_id` CHAR(5) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `mobile_no` INT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `birth_date` DATE NOT NULL,
  `date_registered` DATE NOT NULL,
  `acc_reward_points` INT NOT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Credit_Card`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Credit_Card` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Credit_Card` (
  `credit_card_id` INT NOT NULL,
  `card_name` VARCHAR(30) NOT NULL,
  `payment_url` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`credit_card_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Coupon`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Coupon` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Coupon` (
  `coupon_code` CHAR(10) NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `discount` DECIMAL(3,2) NOT NULL,
  PRIMARY KEY (`coupon_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Billing`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Billing` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Billing` (
  `billing_no` CHAR(5) NOT NULL,
  `customer_id` CHAR(5) NOT NULL,
  `coupon_code` CHAR(10) NULL,
  `credit_card_id` INT NOT NULL,
  `payment_ref_no` CHAR(10) NOT NULL,
  PRIMARY KEY (`billing_no`),
  INDEX `fk_Billing_Customer_idx` (`customer_id` ASC) VISIBLE,
  INDEX `fk_Billing_Payment1_idx` (`credit_card_id` ASC) VISIBLE,
  INDEX `fk_Billing_Coupon1_idx` (`coupon_code` ASC) VISIBLE,
  CONSTRAINT `fk_Billing_Customer`
    FOREIGN KEY (`customer_id`)
    REFERENCES `mydb`.`Customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Billing_Payment1`
    FOREIGN KEY (`credit_card_id`)
    REFERENCES `mydb`.`Credit_Card` (`credit_card_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Billing_Coupon1`
    FOREIGN KEY (`coupon_code`)
    REFERENCES `mydb`.`Coupon` (`coupon_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Voucher_Message`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Voucher_Message` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Voucher_Message` (
  `message_id` INT NOT NULL,
  `voucher_description` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`message_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Voucher_Design`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Voucher_Design` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Voucher_Design` (
  `design_id` INT NOT NULL,
  `voucher_type` ENUM('Food', 'Ride') NOT NULL,
  `description` VARCHAR(100) NOT NULL,
  `design_url` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`design_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Voucher`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Voucher` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Voucher` (
  `voucher_no` INT NOT NULL,
  `design_id` INT NOT NULL,
  `message_id` INT NOT NULL,
  `voucher_type` ENUM('Food', 'Ride') NOT NULL,
  `voucher_datetimestamp` DATETIME NOT NULL,
  `voucher_value` INT NOT NULL,
  `personal_message` VARCHAR(100) NULL,
  `voucher_expiry` DATE NOT NULL,
  `recipient_name` VARCHAR(45) NOT NULL,
  `recipient_email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`voucher_no`),
  INDEX `fk_Voucher_Voucher_Message1_idx` (`message_id` ASC) VISIBLE,
  INDEX `fk_Voucher_Voucher_Design1_idx` (`design_id` ASC) VISIBLE,
  CONSTRAINT `fk_Voucher_Voucher_Message1`
    FOREIGN KEY (`message_id`)
    REFERENCES `mydb`.`Voucher_Message` (`message_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Voucher_Voucher_Design1`
    FOREIGN KEY (`design_id`)
    REFERENCES `mydb`.`Voucher_Design` (`design_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Login`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Login` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Login` (
  `login_id` INT NOT NULL,
  `customer_id` CHAR(5) NOT NULL,
  `login_type` ENUM('mobile', 'email') NOT NULL,
  `login_datetime` DATETIME NOT NULL,
  PRIMARY KEY (`login_id`),
  INDEX `fk_Login_Customer1_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_Login_Customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `mydb`.`Customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Preferred_Comm`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Preferred_Comm` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Preferred_Comm` (
  `comm_id` INT NOT NULL,
  `comm_type` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`comm_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Customer_Pref_Comm`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Customer_Pref_Comm` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Customer_Pref_Comm` (
  `cust_pref_id` INT NOT NULL,
  `customer_id` CHAR(5) NOT NULL,
  `comm_id` INT NOT NULL,
  `Date_Time` DATETIME NOT NULL,
  PRIMARY KEY (`cust_pref_id`),
  INDEX `fk_Customer_has_Preferred_Comm_Preferred_Comm1_idx` (`comm_id` ASC) VISIBLE,
  INDEX `fk_Customer_has_Preferred_Comm_Customer1_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_Customer_has_Preferred_Comm_Customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `mydb`.`Customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Customer_has_Preferred_Comm_Preferred_Comm1`
    FOREIGN KEY (`comm_id`)
    REFERENCES `mydb`.`Preferred_Comm` (`comm_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Shopping_Cart`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Shopping_Cart` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Shopping_Cart` (
  `customer_id` CHAR(5) NOT NULL,
  `item_id` INT NOT NULL,
  `message_id` INT NOT NULL,
  `voucher_type` ENUM('Food', 'Ride') NOT NULL,
  `voucher_value` ENUM('5', '10', '15', '20') NOT NULL,
  `quantity` INT NOT NULL,
  `date_updated` DATETIME NOT NULL,
  `recipient_name` VARCHAR(45) NOT NULL,
  `recipient_email` VARCHAR(45) NOT NULL,
  `personal_message` VARCHAR(100) NULL,
  PRIMARY KEY (`customer_id`, `item_id`),
  INDEX `fk_Shopping_Cart_Voucher_Message1_idx` (`message_id` ASC) VISIBLE,
  INDEX `fk_Shopping_Cart_Customer1_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_Shopping_Cart_Voucher_Message1`
    FOREIGN KEY (`message_id`)
    REFERENCES `mydb`.`Voucher_Message` (`message_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Shopping_Cart_Customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `mydb`.`Customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Billing_has_Voucher`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Billing_has_Voucher` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Billing_has_Voucher` (
  `billing_no` CHAR(5) NOT NULL,
  `voucher_no` INT NOT NULL,
  PRIMARY KEY (`billing_no`, `voucher_no`),
  INDEX `fk_Billing_has_Voucher_Voucher1_idx` (`voucher_no` ASC) VISIBLE,
  INDEX `fk_Billing_has_Voucher_Billing1_idx` (`billing_no` ASC) VISIBLE,
  CONSTRAINT `fk_Billing_has_Voucher_Billing1`
    FOREIGN KEY (`billing_no`)
    REFERENCES `mydb`.`Billing` (`billing_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Billing_has_Voucher_Voucher1`
    FOREIGN KEY (`voucher_no`)
    REFERENCES `mydb`.`Voucher` (`voucher_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `mydb`.`Customer`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00001', 'Mandy', 'Brown', 91115555, 'mandy.brown@yahoo.com', '1970-01-15', '2021-01-26', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00002', 'Ice', 'Ng', 82859794, 'ice.ng@gmail.com', '1981-02-05', '2021-02-06', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00003', 'Eric', 'Khoo', 86670892, 'eric.khoo@gmail.com', '2005-08-28', '2021-02-23', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00004', 'Jordan', 'Zhang', 85761320, 'jordan.zhang@gmail.com', '2005-07-10', '2021-04-06', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00005', 'Alice', 'Neo', 96570644, 'alice.neo@gmail.com', '1999-03-15', '2021-04-14', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00006', 'Dawn', 'Gan', 97498036, 'dawn.gan@gmail.com', '2003-07-16', '2021-05-04', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00007', 'Mary', 'Wu', 83002333, 'mary.wu@gmail.com', '1996-07-27', '2021-05-10', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00008', 'Aly', 'Song', 83445632, 'aly.song@gmail.com', '1994-08-03', '2021-05-28', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00009', 'Jon', 'Pang', 97622618, 'jon.pang@gmail.com', '1965-05-09', '2021-06-04', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00010', 'Tara', 'Yang', 89909690, 'tara.yang@gmail.com', '1991-10-12', '2021-06-09', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00011', 'Christine', 'Neo', 94808278, 'christine.neo@gmail.com', '1970-09-10', '2021-06-19', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00012', 'Nicole', 'Tan', 97331379, 'nicole.tan@gmail.com', '1966-02-27', '2021-06-21', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00013', 'Melinda', 'Lim', 85838092, 'melinda.lim@gmail.com', '1992-05-21', '2021-10-01', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00014', 'Amir', 'Huang', 94636783, 'amir.huang@gmail.com', '1974-06-15', '2021-10-21', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00015', 'Patrick', 'Lai', 99205668, 'patrick.lai@gmail.com', '1972-11-23', '2021-10-27', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00016', 'Aaron', 'Koh', 93982776, 'aaron.koh@gmail.com', '1978-07-26', '2021-10-27', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00017', 'Elliott', 'Hui', 81208921, 'elliott.hui@gmail.com', '1973-01-01', '2021-11-10', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00018', 'Kevin', 'Ang', 99993679, 'kevin.ang@gmail.com', '1981-07-27', '2021-12-01', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00019', 'Ryan', 'Ho', 87925583, 'ryan.ho@gmail.com', '1980-03-20', '2022-01-03', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00020', 'Cynthia', 'Chai', 85825457, 'cynthia.chai@gmail.com', '1969-02-23', '2022-01-04', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00021', 'Benjamin', 'Kang', 93964033, 'benjamin.kang@gmail.com', '1983-03-04', '2022-01-05', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00022', 'Leon', 'Kwek', 91352869, 'leon.kwek@gmail.com', '1992-11-11', '2022-01-21', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00023', 'Jaxon', 'Mok', 85014361, 'jaxon.mok@gmail.com', '1973-02-14', '2022-01-31', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00024', 'Veronica', 'Tan', 99791122, 'veronica.tan@gmail.com', '2002-07-28', '2022-02-01', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00025', 'Adam', 'Lim', 82785587, 'adam.lim@gmail.com', '1988-11-26', '2022-02-01', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00026', 'Anna', 'Chua', 82067073, 'anna.chua@gmail.com', '1989-12-12', '2022-02-12', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00027', 'Winston', 'Chew', 96512498, 'winston.chew@gmail.com', '1994-10-15', '2022-03-17', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00028', 'Tammie', 'Xie', 83278422, 'tammie.xie@gmail.com', '1980-09-08', '2022-04-01', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00029', 'Hazel', 'Tan', 91950491, 'hazel.tan@gmail.com', '1981-12-01', '2022-04-02', 0);
INSERT INTO `mydb`.`Customer` (`customer_id`, `first_name`, `last_name`, `mobile_no`, `email`, `birth_date`, `date_registered`, `acc_reward_points`) VALUES ('00030', 'Helen', 'Lim', 83194357, 'helen.lim@gmail.com', '1966-09-10', '2022-04-02', 0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Credit_Card`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Credit_Card` (`credit_card_id`, `card_name`, `payment_url`) VALUES (1, 'Visa', 'https://www.visa.com/payment');
INSERT INTO `mydb`.`Credit_Card` (`credit_card_id`, `card_name`, `payment_url`) VALUES (2, 'MasterCard', 'https://www.mastercard.com/payment');
INSERT INTO `mydb`.`Credit_Card` (`credit_card_id`, `card_name`, `payment_url`) VALUES (3, 'Discover', 'https://www.discover.com/payment');
INSERT INTO `mydb`.`Credit_Card` (`credit_card_id`, `card_name`, `payment_url`) VALUES (4, 'American Express', 'https://www.amex.com/payment');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Coupon`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Coupon` (`coupon_code`, `start_date`, `end_date`, `discount`) VALUES ('OPEN_MTH', '2021-01-25', '2021-02-25', 0.20);
INSERT INTO `mydb`.`Coupon` (`coupon_code`, `start_date`, `end_date`, `discount`) VALUES ('LABOUR10', '2021-05-01', '2021-05-08', 0.10);
INSERT INTO `mydb`.`Coupon` (`coupon_code`, `start_date`, `end_date`, `discount`) VALUES ('YULE15', '2021-12-13', '2021-12-27', 0.15);
INSERT INTO `mydb`.`Coupon` (`coupon_code`, `start_date`, `end_date`, `discount`) VALUES ('CNY18', '2022-02-01', '2022-02-07', 0.18);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Billing`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0001', '00001', NULL, 1, 'V202100051');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0002', '00002', 'OPEN_MTH', 1, 'V202100069');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0003', '00003', 'OPEN_MTH', 1, 'V202100073');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0004', '00003', 'OPEN_MTH', 1, 'V202100080');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0005', '00002', 'OPEN_MTH', 1, 'V202100094');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0006', '00003', 'OPEN_MTH', 1, 'V202100104');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0007', '00002', 'OPEN_MTH', 2, 'MC11100017');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0008', '00003', 'OPEN_MTH', 1, 'V202100106');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0009', '00003', NULL, 4, 'AMEX000048');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0010', '00004', NULL, 4, 'AMEX000111');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0011', '00005', NULL, 1, 'V202100107');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0012', '00004', 'LABOUR10', 2, 'MC11100288');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0013', '00005', 'LABOUR10', 2, 'MC11100614');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0014', '00005', 'LABOUR10', 1, 'V202100120');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0015', '00003', NULL, 1, 'V202100137');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0016', '00006', 'LABOUR10', 1, 'V202100139');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0017', '00005', 'LABOUR10', 1, 'V202100141');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0018', '00003', 'LABOUR10', 2, 'MC11100619');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0019', '00008', 'LABOUR10', 1, 'V202100156');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0020', '00009', NULL, 1, 'V202100159');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0021', '00008', NULL, 1, 'V202100217');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0022', '00004', NULL, 2, 'MC11100731');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0023', '00008', NULL, 1, 'V202100237');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0024', '00005', NULL, 1, 'V202100248');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0025', '00010', NULL, 2, 'MC11100783');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0026', '00008', NULL, 1, 'V202100251');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0027', '00007', NULL, 2, 'MC11100862');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0028', '00011', NULL, 1, 'V202100280');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0029', '00012', NULL, 2, 'MC11101003');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0030', '00008', NULL, 1, 'V202100318');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0031', '00005', NULL, 2, 'MC11101072');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0032', '00011', NULL, 1, 'V202100325');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0033', '00002', NULL, 1, 'V202100339');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0034', '00009', NULL, 2, 'MC11101333');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0035', '00002', NULL, 2, 'MC11101355');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0036', '00009', NULL, 4, 'AMEX000430');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0037', '00012', NULL, 1, 'V202100349');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0038', '00008', NULL, 1, 'V202100350');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0039', '00002', NULL, 1, 'V202100360');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0040', '00010', NULL, 1, 'V202100379');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0041', '00013', NULL, 1, 'V202100380');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0042', '00001', NULL, 1, 'V202100436');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0043', '00016', NULL, 1, 'V202100459');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0044', '00016', NULL, 4, 'AMEX000449');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0045', '00011', NULL, 1, 'V202100477');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0046', '00016', NULL, 2, 'MC11101703');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0047', '00005', NULL, 2, 'MC11101757');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0048', '00008', NULL, 2, 'MC11101850');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0049', '00001', NULL, 1, 'V202100481');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0050', '00016', NULL, 1, 'V202100483');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0051', '00012', 'YULE15', 2, 'MC11102018');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0052', '00016', 'YULE15', 1, 'V202100495');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0053', '00003', 'YULE15', 1, 'V202100496');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0054', '00004', 'YULE15', 2, 'MC11102021');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0055', '00007', 'YULE15', 1, 'V202100506');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0056', '00017', 'YULE15', 3, 'DIS-001001');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0057', '00009', 'YULE15', 2, 'MC11102092');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0058', '00013', 'YULE15', 1, 'V202100521');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0059', '00004', 'YULE15', 2, 'MC11102094');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0060', '00011', 'YULE15', 2, 'MC11102109');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0061', '00010', 'YULE15', 4, 'AMEX000589');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0062', '00013', 'YULE15', 2, 'MC11102141');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0063', '00016', 'YULE15', 1, 'V202100530');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0064', '00015', 'YULE15', 2, 'MC11102221');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0065', '00018', 'YULE15', 1, 'V202100562');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0066', '00019', NULL, 1, 'V202100580');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0067', '00013', NULL, 1, 'V202100601');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0068', '00013', NULL, 1, 'V202100604');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0069', '00015', NULL, 1, 'V202100604');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0070', '00008', NULL, 1, 'V202100610');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0071', '00016', NULL, 4, 'AMEX000661');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0072', '00004', NULL, 2, 'MC11102255');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0073', '00007', NULL, 1, 'V202100614');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0074', '00003', NULL, 1, 'V202100617');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0075', '00023', NULL, 2, 'MC11102308');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0076', '00025', 'CNY18', 2, 'MC11102314');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0077', '00001', 'CNY18', 2, 'MC11102417');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0078', '00007', NULL, 1, 'V202100641');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0079', '00026', NULL, 1, 'V202100679');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0080', '00005', NULL, 4, 'AMEX000665');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0081', '00016', NULL, 1, 'V202100682');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0082', '00017', NULL, 1, 'V202100683');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0083', '00012', NULL, 2, 'MC11102467');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0084', '00011', NULL, 3, 'DIS-001011');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0085', '00011', NULL, 1, 'V202200687');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0086', '00015', NULL, 3, 'DIS-001013');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0087', '00026', NULL, 4, 'AMEX000700');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0088', '00019', NULL, 1, 'V202200694');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0089', '00023', NULL, 2, 'MC11102509');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0090', '00015', NULL, 2, 'MC11102523');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0091', '00018', NULL, 1, 'V202200738');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0092', '00027', NULL, 2, 'MC11102601');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0093', '00006', NULL, 1, 'V202200752');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0094', '00018', NULL, 1, 'V202200766');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0095', '00006', NULL, 2, 'MC11102677');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0096', '00024', NULL, 2, 'MC11102679');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0097', '00022', NULL, 4, 'AMEX000757');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0098', '00015', NULL, 2, 'MC11102779');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0099', '00011', NULL, 2, 'MC11102853');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0100', '00016', NULL, 1, 'V202200769');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0101', '00024', NULL, 1, 'V202200775');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0102', '00030', NULL, 2, 'MC11102928');
INSERT INTO `mydb`.`Billing` (`billing_no`, `customer_id`, `coupon_code`, `credit_card_id`, `payment_ref_no`) VALUES ('B0103', '00019', NULL, 1, 'V202200778');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Voucher_Message`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Voucher_Message` (`message_id`, `voucher_description`) VALUES (1, 'Roses are red. Violets are blue. Poetry is hard. So here\'s a gift card.');
INSERT INTO `mydb`.`Voucher_Message` (`message_id`, `voucher_description`) VALUES (2, 'I\'m sorry I made a mistake.');
INSERT INTO `mydb`.`Voucher_Message` (`message_id`, `voucher_description`) VALUES (3, 'We don\'t have to eat together, to eat together.');
INSERT INTO `mydb`.`Voucher_Message` (`message_id`, `voucher_description`) VALUES (4, 'For the most practical person I know.');
INSERT INTO `mydb`.`Voucher_Message` (`message_id`, `voucher_description`) VALUES (5, 'Because I know you hate teddy bears.');
INSERT INTO `mydb`.`Voucher_Message` (`message_id`, `voucher_description`) VALUES (6, 'I can\'t thank you enough. But here\'s a start.');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Voucher_Design`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Voucher_Design` (`design_id`, `voucher_type`, `description`, `design_url`) VALUES (123, 'Food', 'Salad bowl', 'https://genie.net/imagelibrary/123.html');
INSERT INTO `mydb`.`Voucher_Design` (`design_id`, `voucher_type`, `description`, `design_url`) VALUES (152, 'Ride', 'Female passenger in Dubai', 'https://genie.net/imagelibrary/152.html');
INSERT INTO `mydb`.`Voucher_Design` (`design_id`, `voucher_type`, `description`, `design_url`) VALUES (457, 'Ride', 'Female passenger in Mount Fuji', 'https://genie.net/imagelibrary/123.html');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Voucher`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (1, 123, 3, 'Food', '2021-01-26 22:30:00', 15, 'Enjoy!', '2021-04-26', 'James Tan', 'jamestan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (2, 123, 3, 'Food', '2021-01-26 22:30:00', 15, 'Enjoy!', '2021-04-26', 'James Tan', 'jamestan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50000, 457, 4, 'Ride', '2021-01-26 22:30:00', 20, 'Happy Birthday!', '2021-04-26', 'James Tan', 'jamestan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50001, 152, 6, 'Ride', '2021-01-26 22:30:00', 20, 'Thanks for lending a listening ear!', '2021-04-26', 'Alan Ong', 'alanong@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (3, 123, 6, 'Food', '2021-02-06 21:01:00', 20, NULL, '2021-05-06', 'Mandy Brown', 'mandy.brown@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (4, 123, 2, 'Food', '2021-02-23 15:20:00', 20, 'You are a lifesaver!', '2021-05-23', 'Mandy Brown', 'mandy.brown@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50002, 152, 4, 'Ride', '2021-02-23 15:20:00', 10, 'Enjoy!', '2021-05-23', 'Ice Ng', 'ice.ng@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50003, 152, 4, 'Ride', '2021-02-23 15:20:00', 5, 'Job well done!', '2021-05-23', 'Ice Ng', 'ice.ng@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50004, 457, 2, 'Ride', '2021-02-23 17:34:00', 20, 'Thanks for your support!', '2021-05-23', 'Dawn Gan', 'dawn.gan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (5, 123, 5, 'Food', '2021-02-23 19:40:00', 10, 'Enjoy!', '2021-05-23', 'Mary Wu', 'mary.wu@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (6, 123, 5, 'Food', '2021-02-23 22:20:00', 10, 'Kudos to you!', '2021-05-23', 'Aly Song', 'aly.song@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50005, 152, 3, 'Ride', '2021-02-23 22:20:00', 15, 'You are AMAZING!', '2021-05-23', 'Jon Pang', 'jon.pang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (7, 123, 6, 'Food', '2021-03-08 20:30:00', 20, 'Friends forever!', '2021-06-08', 'Tara Yang', 'tara.yang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (8, 123, 3, 'Food', '2021-03-24 20:27:00', 20, 'Thanks for your support!', '2021-06-24', 'Tara Yang', 'tara.yang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (9, 123, 1, 'Food', '2021-03-24 20:27:00', 20, 'Thanks for your support!', '2021-06-24', 'Tara Yang', 'tara.yang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50006, 152, 1, 'Ride', '2021-04-09 13:21:00', 10, 'You are a lifesaver!', '2021-07-09', 'Nicole Tan', 'nicole.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50007, 152, 3, 'Ride', '2021-04-16 09:58:00', 10, 'Well done!', '2021-07-16', 'Melinda Lim', 'melinda.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (10, 123, 4, 'Food', '2021-04-22 13:28:00', 10, 'You are a lifesaver!', '2021-07-22', 'Patrick Lai', 'patrick.lai@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (11, 123, 1, 'Food', '2021-04-22 13:28:00', 10, 'You are a lifesaver!', '2021-07-22', 'Patrick Lai', 'patrick.lai@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50008, 457, 4, 'Ride', '2021-04-22 13:28:00', 5, 'Thanks for everything!', '2021-07-22', 'Amir Huang', 'amir.huang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50009, 457, 1, 'Ride', '2021-04-22 13:28:00', 5, 'Thanks for everything!', '2021-07-22', 'Amir Huang', 'amir.huang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50010, 457, 5, 'Ride', '2021-04-22 13:28:00', 5, 'Thanks for everything!', '2021-07-22', 'Amir Huang', 'amir.huang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50011, 152, 1, 'Ride', '2021-04-22 13:28:00', 5, 'Thanks for everything!', '2021-07-22', 'Amir Huang', 'amir.huang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50012, 457, 3, 'Ride', '2021-04-22 13:28:00', 5, 'Thanks for everything!', '2021-07-22', 'Amir Huang', 'amir.huang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50013, 152, 4, 'Ride', '2021-05-01 16:34:00', 15, 'Enjoy!', '2021-08-01', 'Aaron Koh', 'aaron.koh@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (12, 123, 6, 'Food', '2021-05-02 00:57:00', 5, 'Enjoy!', '2021-08-02', 'Aaron Koh', 'aaron.koh@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50014, 152, 3, 'Ride', '2021-05-03 15:53:00', 10, 'Thanks for your support!', '2021-08-03', 'Elliott Hui', 'elliott.hui@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50015, 152, 2, 'Ride', '2021-05-04 08:01:00', 10, 'You will be missed!', '2021-08-04', 'Kevin Ang', 'kevin.ang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50016, 152, 2, 'Ride', '2021-05-04 08:01:00', 10, 'You will be missed!', '2021-08-04', 'Kevin Ang', 'kevin.ang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50017, 152, 3, 'Ride', '2021-05-04 08:01:00', 10, 'You will be missed!', '2021-08-04', 'Kevin Ang', 'kevin.ang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (13, 123, 3, 'Food', '2021-05-04 13:41:00', 15, 'You are AWESOME!', '2021-08-04', 'Leon Kwek', 'leon.kwek@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (14, 123, 5, 'Food', '2021-05-05 07:41:00', 10, 'Friends forever!', '2021-08-05', 'Jaxon Mok', 'jaxon.mok@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (15, 123, 4, 'Food', '2021-05-16 13:33:00', 15, 'Happy Birthday!', '2021-08-16', 'Veronica Tan', 'veronica.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (16, 123, 4, 'Food', '2021-05-28 01:11:00', 5, 'Enjoy!', '2021-08-28', 'Adam Lim', 'adam.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (17, 123, 6, 'Food', '2021-05-28 01:11:00', 5, 'Enjoy!', '2021-08-28', 'Adam Lim', 'adam.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50018, 457, 2, 'Ride', '2021-05-28 01:11:00', 10, 'You will be missed!', '2021-08-28', 'Hazel Tan', 'hazel.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50019, 152, 3, 'Ride', '2021-06-04 12:44:00', 15, 'Thanks for your support!', '2021-09-04', 'Helen Lim', 'helen.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50020, 152, 6, 'Ride', '2021-06-05 12:04:00', 5, 'Happy Always!', '2021-09-05', 'Wilfred Lim', 'willful@hotmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50021, 152, 2, 'Ride', '2021-06-05 12:04:00', 5, 'Happy Always!', '2021-09-05', 'Wilfred Lim', 'willful@hotmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50022, 152, 6, 'Ride', '2021-06-05 12:04:00', 5, 'Happy Always!', '2021-09-05', 'Wilfred Lim', 'willful@hotmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (18, 123, 5, 'Food', '2021-06-06 13:21:00', 10, 'You deserve a good rest!', '2021-09-06', 'Sophia Loh', 'soulfool@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50023, 457, 1, 'Ride', '2021-06-06 13:21:00', 10, 'You deserve a good rest!', '2021-09-06', 'Isaac Chew', 'chewytoe@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50024, 457, 1, 'Ride', '2021-06-06 14:49:00', 5, 'Many thanks!', '2021-09-06', 'Charlene Zhu', 'zhuzhutrain@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50025, 457, 3, 'Ride', '2021-06-06 14:49:00', 5, 'Many thanks!', '2021-09-06', 'Charlene Zhu', 'zhuzhutrain@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50026, 457, 4, 'Ride', '2021-06-06 14:49:00', 5, 'Many thanks!', '2021-09-06', 'Charlene Zhu', 'zhuzhutrain@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50027, 152, 3, 'Ride', '2021-06-06 14:49:00', 5, 'Many thanks!', '2021-09-06', 'Charlene Zhu', 'zhuzhutrain@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50028, 152, 3, 'Ride', '2021-06-06 14:49:00', 5, 'Many thanks!', '2021-09-06', 'Danny Lam', 'lamsiusiu@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50029, 152, 3, 'Ride', '2021-06-06 14:49:00', 5, 'Many thanks!', '2021-09-06', 'Danny Lam', 'lamsiusiu@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50030, 152, 4, 'Ride', '2021-06-06 14:49:00', 5, 'Many thanks!', '2021-09-06', 'Danny Lam', 'lamsiusiu@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50031, 457, 4, 'Ride', '2021-06-06 14:49:00', 5, 'Many thanks!', '2021-09-06', 'Danny Lam', 'lamsiusiu@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (19, 123, 6, 'Food', '2021-06-07 21:14:00', 10, 'Thank you!', '2021-09-07', 'Eden Tan', 'eatturn@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (20, 123, 5, 'Food', '2021-06-07 21:14:00', 10, 'Thank you!', '2021-09-07', 'Eve Ang', 'elfie@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (21, 123, 4, 'Food', '2021-06-07 21:14:00', 10, 'Thank you!', '2021-09-07', 'Zack Chen', 'zackyzap@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (22, 123, 4, 'Food', '2021-06-07 21:14:00', 10, 'Thank you!', '2021-09-07', 'Zen Song', 'songswan@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (23, 123, 4, 'Food', '2021-06-07 21:14:00', 10, 'Thank you!', '2021-09-07', 'Lawrence Chen', 'lawnren@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (24, 123, 2, 'Food', '2021-06-09 19:24:00', 5, 'Enjoy!', '2021-09-09', 'Dresden Ong', 'Dres-down@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (25, 123, 2, 'Food', '2021-06-11 17:54:00', 5, 'A big thank you!', '2021-09-11', 'Mary Wu', 'mary.wu@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (26, 123, 3, 'Food', '2021-06-11 17:54:00', 5, 'A big thank you!', '2021-09-11', 'Mary Wu', 'mary.wu@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (27, 123, 2, 'Food', '2021-06-11 17:54:00', 5, 'A big thank you!', '2021-09-11', 'Aly Song', 'aly.song@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (28, 123, 4, 'Food', '2021-06-11 17:54:00', 5, 'A big thank you!', '2021-09-11', 'Aly Song', 'aly.song@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (29, 123, 1, 'Food', '2021-06-15 12:44:00', 5, 'Friends forever!', '2021-09-15', 'Tara Yang', 'tara.yang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50032, 457, 2, 'Ride', '2021-06-15 12:44:00', 5, 'Friends forever!', '2021-09-15', 'Tara Yang', 'tara.yang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50033, 457, 6, 'Ride', '2021-06-15 12:44:00', 5, 'Friends forever!', '2021-09-15', 'Tara Yang', 'tara.yang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (30, 123, 2, 'Food', '2021-06-19 10:33:00', 10, 'You are AMAZING!', '2021-09-19', 'Lawrence Chen', 'lawnren@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50034, 457, 2, 'Ride', '2021-06-19 10:33:00', 10, 'You are AMAZING!', '2021-09-19', 'Lawrence Chen', 'lawnren@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (31, 123, 4, 'Food', '2021-06-21 21:48:00', 15, 'Thanks for your encouragement!', '2021-09-21', 'Elliott Hui', 'elliott.hui@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50035, 152, 1, 'Ride', '2021-06-30 20:25:00', 10, 'You deserve a good rest!', '2021-09-30', 'Patrick Lai', 'patrick.lai@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50036, 152, 4, 'Ride', '2021-06-30 20:25:00', 10, 'You deserve a good rest!', '2021-09-30', 'Aaron Koh', 'aaron.koh@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50037, 152, 5, 'Ride', '2021-06-30 20:25:00', 10, 'You deserve a good rest!', '2021-09-30', 'Elliott Hui', 'elliott.hui@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50038, 152, 3, 'Ride', '2021-06-30 20:25:00', 10, 'You deserve a good rest!', '2021-09-30', 'Kevin Ang', 'kevin.ang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50039, 152, 2, 'Ride', '2021-06-30 20:25:00', 10, 'You deserve a good rest!', '2021-09-30', 'Leon Kwek', 'leon.kwek@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50040, 152, 3, 'Ride', '2021-06-30 20:25:00', 15, 'Well done!', '2021-09-30', 'Jaxon Mok', 'jaxon.mok@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (32, 123, 2, 'Food', '2021-07-13 22:08:00', 20, 'Well done!', '2021-10-13', 'James Tan', 'jamestan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (33, 123, 3, 'Food', '2021-07-30 10:08:00', 15, 'Job well done!', '2021-10-30', 'Eve Ang', 'elfie@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (34, 123, 4, 'Food', '2021-08-13 13:48:00', 10, 'Thanks for your hard work!', '2021-11-13', 'Wilfred Lim', 'willful@hotmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50041, 152, 5, 'Ride', '2021-08-13 13:48:00', 5, 'Enjoy!', '2021-11-13', 'Mandy Brown', 'mandy.brown@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50042, 457, 3, 'Ride', '2021-08-13 13:48:00', 5, 'Enjoy!', '2021-11-13', 'Mandy Brown', 'mandy.brown@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50043, 457, 2, 'Ride', '2021-08-13 13:48:00', 5, 'Enjoy!', '2021-11-13', 'Mandy Brown', 'mandy.brown@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50044, 457, 4, 'Ride', '2021-08-19 22:22:00', 15, 'Keep up the good work!', '2021-11-19', 'Eve Ang', 'elfie@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (35, 123, 3, 'Food', '2021-08-21 11:48:00', 15, 'Awesome work!', '2021-11-21', 'Charlene Zhu', 'zhuzhutrain@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (36, 123, 1, 'Food', '2021-08-21 11:48:00', 15, 'Awesome work!', '2021-11-21', 'Danny Lam', 'lamsiusiu@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (37, 123, 3, 'Food', '2021-08-21 11:48:00', 15, 'Awesome work!', '2021-11-21', 'Eden Tan', 'eatturn@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (38, 123, 4, 'Food', '2021-09-01 17:13:00', 5, 'Thank you!', '2021-12-01', 'Jaxon Mok', 'jaxon.mok@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (39, 123, 5, 'Food', '2021-09-01 17:13:00', 5, 'Thank you!', '2021-12-01', 'Jaxon Mok', 'jaxon.mok@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (40, 123, 2, 'Food', '2021-09-01 17:13:00', 5, 'Thank you!', '2021-12-01', 'Jaxon Mok', 'jaxon.mok@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (41, 123, 1, 'Food', '2021-09-01 17:13:00', 5, 'Thank you!', '2021-12-01', 'Jaxon Mok', 'jaxon.mok@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (42, 123, 1, 'Food', '2021-09-01 17:13:00', 5, 'Thank you!', '2021-12-01', 'Jaxon Mok', 'jaxon.mok@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50045, 457, 1, 'Ride', '2021-09-06 22:36:00', 10, 'Big Thank You!', '2021-12-06', 'Dawn Gan', 'dawn.gan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (43, 123, 5, 'Food', '2021-09-15 11:39:00', 5, 'Many thanks!', '2021-12-15', 'Kevin Ang', 'kevin.ang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (44, 123, 3, 'Food', '2021-09-15 11:39:00', 5, 'Many thanks!', '2021-12-15', 'Kevin Ang', 'kevin.ang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (45, 123, 1, 'Food', '2021-09-15 11:39:00', 5, 'Many thanks!', '2021-12-15', 'Kevin Ang', 'kevin.ang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (46, 123, 2, 'Food', '2021-09-15 11:39:00', 5, 'Many thanks!', '2021-12-15', 'Kevin Ang', 'kevin.ang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (47, 123, 1, 'Food', '2021-09-15 11:39:00', 5, 'Many thanks!', '2021-12-15', 'Kevin Ang', 'kevin.ang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50046, 457, 2, 'Ride', '2021-09-15 11:39:00', 15, 'Many thanks!', '2021-12-15', 'Alan Ong', 'alanong@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50047, 152, 6, 'Ride', '2021-09-15 11:39:00', 15, 'Many thanks!', '2021-12-15', 'Alan Ong', 'alanong@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50048, 152, 4, 'Ride', '2021-09-15 11:39:00', 15, 'Many thanks!', '2021-12-15', 'Alan Ong', 'alanong@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50049, 152, 2, 'Ride', '2021-09-15 11:39:00', 15, 'Many thanks!', '2021-12-15', 'Alan Ong', 'alanong@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50050, 152, 1, 'Ride', '2021-09-26 17:28:00', 10, 'Thank you!', '2021-12-26', 'James Tan', 'jamestan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50051, 152, 3, 'Ride', '2021-10-03 06:01:00', 5, 'Good job!', '2021-01-03', 'Helen Lim', 'helen.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50052, 152, 5, 'Ride', '2021-10-03 06:01:00', 5, 'Good job!', '2021-01-03', 'Helen Lim', 'helen.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50053, 152, 6, 'Ride', '2021-10-03 06:01:00', 5, 'Good job!', '2021-01-03', 'Helen Lim', 'helen.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50054, 152, 1, 'Ride', '2021-10-19 10:15:00', 5, 'Friends forever!', '2021-01-19', 'Leon Kwek', 'leon.kwek@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50055, 152, 1, 'Ride', '2021-10-19 10:15:00', 5, 'Friends forever!', '2021-01-19', 'Leon Kwek', 'leon.kwek@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50056, 457, 4, 'Ride', '2021-10-19 10:15:00', 5, 'Friends forever!', '2021-01-19', 'Leon Kwek', 'leon.kwek@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50057, 457, 2, 'Ride', '2021-10-19 10:15:00', 5, 'Friends forever!', '2021-01-19', 'Leon Kwek', 'leon.kwek@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (48, 123, 5, 'Food', '2021-10-26 09:33:00', 10, 'You are the best!', '2021-01-26', 'Mary Wu', 'mary.wu@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (49, 123, 6, 'Food', '2021-10-31 19:31:00', 5, 'Thanks!', '2021-01-31', 'Veronica Tan', 'veronica.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50058, 457, 2, 'Ride', '2021-11-06 17:21:00', 10, 'Many blessings!', '2021-02-06', 'Jon Pang', 'jon.pang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50059, 457, 3, 'Ride', '2021-11-06 17:21:00', 10, 'Many blessings!', '2021-02-06', 'Kevin Ang', 'kevin.ang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50060, 457, 6, 'Ride', '2021-11-06 17:21:00', 10, 'Many blessings!', '2021-02-06', 'Leon Kwek', 'leon.kwek@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50, 123, 1, 'Food', '2021-11-11 10:39:00', 15, 'Thanks!', '2021-02-11', 'Adam Lim', 'adam.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (51, 123, 6, 'Food', '2021-11-16 19:35:00', 10, 'Keep up the good work!', '2021-02-16', 'Tara Yang', 'tara.yang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (52, 123, 5, 'Food', '2021-11-19 10:20:00', 10, 'Keep up the good work!', '2021-02-19', 'Nicole Tan', 'nicole.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (53, 123, 5, 'Food', '2021-11-19 10:20:00', 10, 'Keep up the good work!', '2021-02-19', 'Melinda Lim', 'melinda.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (54, 123, 3, 'Food', '2021-11-19 10:20:00', 10, 'Keep up the good work!', '2021-02-19', 'Amir Huang', 'amir.huang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (55, 123, 2, 'Food', '2021-11-19 10:20:00', 15, 'Keep up the good work!', '2021-02-19', 'Patrick Lai', 'patrick.lai@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50061, 152, 3, 'Ride', '2021-11-28 18:10:00', 20, 'Thanks for your support!', '2021-02-28', 'Veronica Tan', 'veronica.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (56, 123, 5, 'Food', '2021-12-03 10:21:00', 5, 'Awesome work!', '2021-03-03', 'Zack Chen', 'zackyzap@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (57, 123, 2, 'Food', '2021-12-03 10:21:00', 5, 'Awesome work!', '2021-03-03', 'Zack Chen', 'zackyzap@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (58, 123, 5, 'Food', '2021-12-03 10:21:00', 5, 'Awesome work!', '2021-03-03', 'Zack Chen', 'zackyzap@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (59, 123, 2, 'Food', '2021-12-03 10:21:00', 10, 'Thank you!', '2021-03-03', 'Alan Ong', 'alanong@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (60, 123, 2, 'Food', '2021-12-03 10:21:00', 10, 'Thank you!', '2021-03-03', 'Jon Pang', 'jon.pang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (61, 123, 4, 'Food', '2021-12-03 10:21:00', 10, 'Thank you!', '2021-03-03', 'Aaron Koh', 'aaron.koh@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50062, 152, 3, 'Ride', '2021-12-03 10:21:00', 5, 'Awesome work!', '2021-03-03', 'Zack Chen', 'zackyzap@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50063, 152, 4, 'Ride', '2021-12-03 10:21:00', 5, 'Awesome work!', '2021-03-03', 'Zack Chen', 'zackyzap@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50064, 152, 1, 'Ride', '2021-12-03 10:21:00', 5, 'Awesome work!', '2021-03-03', 'Zack Chen', 'zackyzap@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50065, 152, 3, 'Ride', '2021-12-03 10:21:00', 5, 'Awesome work!', '2021-03-03', 'Zack Chen', 'zackyzap@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (62, 123, 3, 'Food', '2021-12-09 10:12:00', 10, 'Thank you!', '2021-03-09', 'Jaxon Mok', 'jaxon.mok@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50066, 152, 5, 'Ride', '2021-12-12 15:25:00', 5, 'Enjoy!', '2021-03-12', 'Ice Ng', 'ice.ng@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50067, 152, 1, 'Ride', '2021-12-12 15:25:00', 5, 'Enjoy!', '2021-03-12', 'Ice Ng', 'ice.ng@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50068, 457, 5, 'Ride', '2021-12-12 15:25:00', 5, 'Enjoy!', '2021-03-12', 'Ice Ng', 'ice.ng@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50069, 457, 6, 'Ride', '2021-12-12 15:25:00', 5, 'Enjoy!', '2021-03-12', 'Ice Ng', 'ice.ng@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50070, 457, 5, 'Ride', '2021-12-12 15:25:00', 5, 'Enjoy!', '2021-03-12', 'Ice Ng', 'ice.ng@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50071, 457, 6, 'Ride', '2021-12-13 20:55:00', 20, 'A big thank you!', '2021-03-13', 'Aly Song', 'aly.song@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50072, 457, 5, 'Ride', '2021-12-13 20:55:00', 20, 'Awesome work!', '2021-03-13', 'Melinda Lim', 'melinda.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50073, 152, 6, 'Ride', '2021-12-13 20:55:00', 20, 'Awesome work!', '2021-03-13', 'Patrick Lai', 'patrick.lai@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50074, 152, 2, 'Ride', '2021-12-13 20:55:00', 20, 'Awesome work!', '2021-03-13', 'Elliott Hui', 'elliott.hui@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50075, 152, 2, 'Ride', '2021-12-13 20:55:00', 20, 'Awesome work!', '2021-03-13', 'Leon Kwek', 'leon.kwek@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50076, 152, 5, 'Ride', '2021-12-13 20:55:00', 20, 'Awesome work!', '2021-03-13', 'Hazel Tan', 'hazel.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50077, 152, 1, 'Ride', '2021-12-13 20:55:00', 20, 'Awesome work!', '2021-03-13', 'Mandy Brown', 'mandy.brown@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50078, 152, 2, 'Ride', '2021-12-13 20:55:00', 20, 'Awesome work!', '2021-03-13', 'Dawn Gan', 'dawn.gan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50079, 152, 5, 'Ride', '2021-12-13 20:55:00', 20, 'Awesome work!', '2021-03-13', 'Tara Yang', 'tara.yang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50080, 152, 5, 'Ride', '2021-12-13 20:55:00', 20, 'Awesome work!', '2021-03-13', 'Veronica Tan', 'veronica.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (63, 123, 3, 'Food', '2021-12-14 15:51:00', 10, 'Enjoy!', '2021-03-14', 'Mary Wu', 'mary.wu@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (64, 123, 6, 'Food', '2021-12-18 14:12:00', 10, 'A big thank you!', '2021-03-18', 'Zen Song', 'songswan@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50081, 152, 6, 'Ride', '2021-12-18 14:12:00', 5, 'Enjoy!', '2021-03-18', 'Danny Lam', 'lamsiusiu@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50082, 152, 3, 'Ride', '2021-12-18 14:12:00', 5, 'Enjoy!', '2021-03-18', 'Danny Lam', 'lamsiusiu@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50083, 457, 2, 'Ride', '2021-12-18 14:12:00', 15, 'You deserve a good rest!', '2021-03-18', 'Zen Song', 'songswan@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (65, 123, 3, 'Food', '2021-12-22 10:07:00', 10, 'Thank you!', '2021-03-22', 'Ice Ng', 'ice.ng@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (66, 123, 1, 'Food', '2021-12-24 09:14:00', 10, 'Thank you!', '2021-03-24', 'Jon Pang', 'jon.pang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (67, 123, 5, 'Food', '2021-12-24 09:14:00', 10, 'Thank you!', '2021-03-24', 'Nicole Tan', 'nicole.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50084, 457, 4, 'Ride', '2021-12-24 10:59:00', 15, 'Thank you!', '2021-03-24', 'Melinda Lim', 'melinda.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (68, 123, 3, 'Food', '2021-12-24 11:11:00', 10, 'Thank you!', '2021-03-24', 'Aaron Koh', 'aaron.koh@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (69, 123, 5, 'Food', '2021-12-24 11:11:00', 10, 'Thank you!', '2021-03-24', 'Kevin Ang', 'kevin.ang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (70, 123, 3, 'Food', '2021-12-24 11:11:00', 10, 'Thank you!', '2021-03-24', 'Adam Lim', 'adam.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (71, 123, 6, 'Food', '2021-12-24 11:11:00', 10, 'Thank you!', '2021-03-24', 'Jaxon Mok', 'jaxon.mok@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50085, 457, 5, 'Ride', '2021-12-24 17:52:00', 5, 'Enjoy!', '2021-03-24', 'Hazel Tan', 'hazel.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50086, 457, 4, 'Ride', '2021-12-25 00:11:00', 5, 'Enjoy!', '2021-03-25', 'Hazel Tan', 'hazel.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (72, 123, 5, 'Food', '2021-12-26 12:12:00', 10, 'You deserve a good rest!', '2021-03-26', 'Alan Ong', 'alanong@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (73, 123, 4, 'Food', '2021-12-27 16:54:00', 10, 'Friends forever!', '2021-03-27', 'Dawn Gan', 'dawn.gan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (74, 123, 5, 'Food', '2021-12-27 16:54:00', 10, 'Friends forever!', '2021-03-27', 'Nicole Tan', 'nicole.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (75, 123, 3, 'Food', '2021-12-27 16:54:00', 10, 'Friends forever!', '2021-03-27', 'Elliott Hui', 'elliott.hui@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50087, 457, 3, 'Ride', '2021-12-28 16:08:00', 10, 'Good job!', '2021-03-28', 'Patrick Lai', 'patrick.lai@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50088, 457, 5, 'Ride', '2021-12-28 16:08:00', 10, 'Good job!', '2021-03-28', 'Wilfred Lim', 'willful@hotmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50089, 152, 2, 'Ride', '2021-12-29 17:30:00', 5, 'Enjoy!', '2021-03-29', 'Mandy Brown', 'mandy.brown@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50090, 152, 2, 'Ride', '2021-12-29 17:30:00', 5, 'Enjoy!', '2021-03-29', 'Mandy Brown', 'mandy.brown@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50091, 152, 2, 'Ride', '2021-12-29 17:30:00', 5, 'Enjoy!', '2021-03-29', 'Mandy Brown', 'mandy.brown@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50092, 152, 2, 'Ride', '2021-12-29 17:30:00', 5, 'Enjoy!', '2021-03-29', 'Mandy Brown', 'mandy.brown@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50093, 152, 6, 'Ride', '2021-12-30 12:31:00', 15, 'Good job!', '2021-03-30', 'Eve Ang', 'elfie@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (76, 123, 4, 'Food', '2022-01-03 05:22:00', 5, 'Enjoy!', '2022-04-03', 'Aly Song', 'aly.song@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (77, 123, 2, 'Food', '2022-01-06 07:15:00', 10, 'Thanks for listening!', '2022-04-06', 'Melinda Lim', 'melinda.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (78, 123, 1, 'Food', '2022-01-09 07:31:00', 10, 'Thanks for your encouragement!', '2022-04-09', 'Charlene Zhu', 'zhuzhutrain@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (79, 123, 6, 'Food', '2022-01-09 07:31:00', 10, 'Thanks for your encouragement!', '2022-04-09', 'Danny Lam', 'lamsiusiu@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50094, 152, 1, 'Ride', '2022-01-09 07:31:00', 15, 'Thanks for your encouragement!', '2022-04-09', 'Adam Lim', 'adam.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50095, 152, 2, 'Ride', '2022-01-09 07:31:00', 15, 'Thanks for your encouragement!', '2022-04-09', 'Sophia Loh', 'soulfool@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (80, 123, 5, 'Food', '2022-01-11 13:59:00', 5, 'Thank you!', '2022-04-11', 'Zack Chen', 'zackyzap@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (81, 123, 4, 'Food', '2022-01-11 13:59:00', 5, 'Thank you!', '2022-04-11', 'Zack Chen', 'zackyzap@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50096, 152, 3, 'Ride', '2022-01-11 13:59:00', 10, 'Thank you!', '2022-04-11', 'Eden Tan', 'eatturn@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50097, 152, 5, 'Ride', '2022-01-11 13:59:00', 10, 'Thank you!', '2022-04-11', 'Eve Ang', 'elfie@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (82, 123, 4, 'Food', '2022-01-14 13:40:00', 10, 'Good job!', '2022-04-14', 'Amir Huang', 'amir.huang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50098, 152, 3, 'Ride', '2022-01-17 17:16:00', 20, 'Many Thanks!', '2022-04-17', 'Dawn Gan', 'dawn.gan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (83, 123, 2, 'Food', '2022-01-23 14:00:00', 10, 'Many thanks!', '2022-04-23', 'Melinda Lim', 'melinda.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (84, 123, 5, 'Food', '2022-01-25 14:22:00', 5, 'Enjoy!', '2022-04-25', 'Zen Song', 'songswan@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (85, 123, 6, 'Food', '2022-01-28 21:50:00', 5, 'Enjoy!', '2022-04-28', 'Mary Wu', 'mary.wu@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (86, 123, 5, 'Food', '2022-01-28 21:50:00', 5, 'Enjoy!', '2022-04-28', 'Mary Wu', 'mary.wu@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (87, 123, 1, 'Food', '2022-01-28 21:50:00', 5, 'Enjoy!', '2022-04-28', 'Mary Wu', 'mary.wu@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50099, 152, 3, 'Ride', '2022-01-28 21:50:00', 10, 'Thanks for your encouragement!', '2022-04-28', 'Jon Pang', 'jon.pang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50100, 152, 6, 'Ride', '2022-01-28 21:50:00', 10, 'Thanks for your encouragement!', '2022-04-28', 'Adam Lim', 'adam.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50101, 152, 2, 'Ride', '2022-01-28 21:50:00', 10, 'Thanks for your encouragement!', '2022-04-28', 'Hazel Tan', 'hazel.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (88, 123, 3, 'Food', '2022-01-31 16:44:00', 15, 'Awesome work!', '2022-05-01', 'Zack Chen', 'zackyzap@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50102, 152, 1, 'Ride', '2022-02-03 12:41:00', 10, 'Thanks for everything!', '2022-05-03', 'Alan Ong', 'alanong@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50103, 152, 1, 'Ride', '2022-02-03 12:41:00', 10, 'Thanks for everything!', '2022-05-03', 'Mandy Brown', 'mandy.brown@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50104, 457, 6, 'Ride', '2022-02-03 12:41:00', 10, 'Thanks for everything!', '2022-05-03', 'Ice Ng', 'ice.ng@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50105, 457, 6, 'Ride', '2022-02-05 15:54:00', 10, 'Thanks for everything!', '2022-05-05', 'Dawn Gan', 'dawn.gan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50106, 457, 4, 'Ride', '2022-02-08 12:34:00', 10, 'Thanks for everything!', '2022-05-08', 'Mary Wu', 'mary.wu@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50107, 457, 4, 'Ride', '2022-02-08 12:34:00', 10, 'Thanks for everything!', '2022-05-08', 'Aly Song', 'aly.song@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50108, 457, 4, 'Ride', '2022-02-08 12:34:00', 10, 'Thanks for everything!', '2022-05-08', 'Jon Pang', 'jon.pang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50109, 457, 1, 'Ride', '2022-02-08 12:34:00', 10, 'Thanks for everything!', '2022-05-08', 'Tara Yang', 'tara.yang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50110, 457, 5, 'Ride', '2022-02-08 12:34:00', 10, 'Thanks for everything!', '2022-05-08', 'Nicole Tan', 'nicole.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50111, 457, 1, 'Ride', '2022-02-08 12:34:00', 10, 'Thanks for everything!', '2022-05-08', 'Melinda Lim', 'melinda.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50112, 152, 6, 'Ride', '2022-02-08 12:34:00', 10, 'Thanks for everything!', '2022-05-08', 'Amir Huang', 'amir.huang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50113, 152, 5, 'Ride', '2022-02-08 12:34:00', 10, 'Thanks for everything!', '2022-05-08', 'Patrick Lai', 'patrick.lai@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50114, 152, 2, 'Ride', '2022-02-08 12:34:00', 10, 'Thanks for everything!', '2022-05-08', 'Aaron Koh', 'aaron.koh@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50115, 152, 3, 'Ride', '2022-02-08 12:34:00', 10, 'Thanks for everything!', '2022-05-08', 'Elliott Hui', 'elliott.hui@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50116, 152, 2, 'Ride', '2022-02-08 12:34:00', 10, 'Thanks for everything!', '2022-05-08', 'Kevin Ang', 'kevin.ang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50117, 152, 1, 'Ride', '2022-02-08 12:34:00', 10, 'Thanks for everything!', '2022-05-08', 'Leon Kwek', 'leon.kwek@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50118, 152, 3, 'Ride', '2022-02-12 10:33:00', 20, 'Awesome work!', '2022-05-12', 'Helen Lim', 'helen.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50119, 152, 5, 'Ride', '2022-02-12 10:33:00', 20, 'Awesome work!', '2022-05-12', 'Wilfred Lim', 'willful@hotmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (89, 123, 4, 'Food', '2022-02-15 18:19:00', 20, 'I couldn\'t thank you enough!', '2022-05-15', 'Jaxon Mok', 'jaxon.mok@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50120, 152, 1, 'Ride', '2022-02-18 14:17:00', 20, 'Well done!', '2022-05-18', 'Veronica Tan', 'veronica.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (90, 123, 6, 'Food', '2022-02-21 16:41:00', 15, 'Enjoy!', '2022-05-21', 'Adam Lim', 'adam.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (91, 123, 6, 'Food', '2022-02-23 19:31:00', 10, 'Many Thanks!', '2022-05-23', 'Hazel Tan', 'hazel.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (92, 123, 6, 'Food', '2022-02-24 17:45:00', 10, 'Thank you!', '2022-05-24', 'Isaac Chew', 'chewytoe@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (93, 123, 4, 'Food', '2022-02-24 17:45:00', 10, 'Thank you!', '2022-05-24', 'Sophia Loh', 'soulfool@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50121, 457, 2, 'Ride', '2022-02-24 17:45:00', 5, 'Enjoy!', '2022-05-24', 'Charlene Zhu', 'zhuzhutrain@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50122, 457, 5, 'Ride', '2022-02-24 17:45:00', 5, 'Enjoy!', '2022-05-24', 'Charlene Zhu', 'zhuzhutrain@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50123, 457, 3, 'Ride', '2022-02-24 17:45:00', 5, 'Enjoy!', '2022-05-24', 'Charlene Zhu', 'zhuzhutrain@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50124, 457, 5, 'Ride', '2022-02-24 17:45:00', 20, 'A big thank you!', '2022-05-24', 'Danny Lam', 'lamsiusiu@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (94, 123, 5, 'Food', '2022-02-25 13:04:00', 5, 'Enjoy!', '2022-05-25', 'Dresden Ong', 'Dres-down@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50125, 457, 1, 'Ride', '2022-03-01 15:28:00', 15, 'Great work!', '2022-06-01', 'Eve Ang', 'elfie@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50126, 457, 5, 'Ride', '2022-03-08 01:15:00', 20, 'Thanks for your support!', '2022-06-08', 'Zen Song', 'songswan@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (95, 123, 1, 'Food', '2022-03-11 07:15:00', 10, 'Well done!', '2022-06-11', 'Eden Tan', 'eatturn@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50127, 457, 4, 'Ride', '2022-03-14 09:29:00', 15, 'Great job!', '2022-06-14', 'Lawrence Chen', 'lawnren@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50128, 457, 2, 'Ride', '2022-03-15 13:45:00', 10, 'You are AMAZING!', '2022-06-15', 'Zen Song', 'songswan@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50129, 152, 3, 'Ride', '2022-03-15 13:45:00', 10, 'You are AMAZING!', '2022-06-15', 'Zen Song', 'songswan@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50130, 152, 6, 'Ride', '2022-03-15 13:45:00', 15, 'Thanks for your support!', '2022-06-15', 'Lawrence Chen', 'lawnren@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (96, 123, 3, 'Food', '2022-03-17 14:45:00', 20, 'You are the best!', '2022-06-17', 'Zack Chen', 'zackyzap@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (97, 123, 1, 'Food', '2022-03-17 14:45:00', 20, 'You are AMAZING!', '2022-06-17', 'Mandy Brown', 'mandy.brown@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (98, 123, 6, 'Food', '2022-03-17 14:45:00', 10, 'Thank you!', '2022-06-17', 'Nicole Tan', 'nicole.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (99, 123, 4, 'Food', '2022-03-17 16:21:00', 10, 'You deserve a good rest!', '2022-06-17', 'Aly Song', 'aly.song@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (100, 123, 5, 'Food', '2022-03-17 16:21:00', 10, 'You deserve a good rest!', '2022-06-17', 'Aly Song', 'aly.song@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (101, 123, 5, 'Food', '2022-03-17 16:21:00', 10, 'You deserve a good rest!', '2022-06-17', 'Aly Song', 'aly.song@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50131, 152, 6, 'Ride', '2022-03-18 04:21:00', 15, 'Well done!', '2022-06-18', 'Ice Ng', 'ice.ng@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (102, 123, 3, 'Food', '2022-03-22 18:20:00', 10, 'I couldn\'t thank you enough!', '2022-06-22', 'Tara Yang', 'tara.yang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (103, 123, 4, 'Food', '2022-03-22 18:20:00', 10, 'I couldn\'t thank you enough!', '2022-06-22', 'Kevin Ang', 'kevin.ang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (104, 123, 6, 'Food', '2022-03-22 18:20:00', 10, 'I couldn\'t thank you enough!', '2022-06-22', 'Danny Lam', 'lamsiusiu@yahoo.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (105, 123, 5, 'Food', '2022-03-22 18:20:00', 10, 'I couldn\'t thank you enough!', '2022-06-22', 'Zack Chen', 'zackyzap@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50132, 152, 2, 'Ride', '2022-03-23 18:22:00', 15, 'Thanks for listening!', '2022-06-23', 'Amir Huang', 'amir.huang@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (106, 123, 2, 'Food', '2022-03-24 16:11:00', 10, 'Many Thanks!', '2022-06-24', 'Veronica Tan', 'veronica.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50133, 152, 3, 'Ride', '2022-03-28 13:21:00', 20, 'Well done!', '2022-06-28', 'Eve Ang', 'elfie@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50134, 152, 6, 'Ride', '2022-03-29 17:00:00', 15, 'Many Thanks!', '2022-06-29', 'Alan Ong', 'alanong@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (107, 123, 4, 'Food', '2022-03-30 18:17:00', 10, 'Thanks for your support!', '2022-06-30', 'Dawn Gan', 'dawn.gan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (108, 123, 3, 'Food', '2022-03-30 18:17:00', 10, 'Thanks for your support!', '2022-06-30', 'Nicole Tan', 'nicole.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (109, 123, 5, 'Food', '2022-03-30 18:17:00', 10, 'Thanks for your support!', '2022-06-30', 'Elliott Hui', 'elliott.hui@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (110, 123, 4, 'Food', '2022-03-30 18:17:00', 10, 'Thanks for your support!', '2022-06-30', 'Adam Lim', 'adam.lim@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50135, 152, 2, 'Ride', '2022-03-30 18:17:00', 5, 'Friends forever!', '2022-06-30', 'Mary Wu', 'mary.wu@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50136, 152, 4, 'Ride', '2022-03-30 18:17:00', 5, 'Friends forever!', '2022-06-30', 'Mary Wu', 'mary.wu@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50137, 152, 5, 'Ride', '2022-03-30 18:17:00', 5, 'Friends forever!', '2022-06-30', 'Mary Wu', 'mary.wu@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50138, 152, 6, 'Ride', '2022-03-30 18:17:00', 5, 'Friends forever!', '2022-06-30', 'Mary Wu', 'mary.wu@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50139, 152, 6, 'Ride', '2022-03-30 18:17:00', 5, 'Friends forever!', '2022-06-30', 'Mary Wu', 'mary.wu@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50140, 152, 5, 'Ride', '2022-03-30 18:17:00', 15, 'Well done!', '2022-06-30', 'Aaron Koh', 'aaron.koh@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50141, 152, 2, 'Ride', '2022-03-30 18:17:00', 15, 'Well done!', '2022-06-30', 'Leon Kwek', 'leon.kwek@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (111, 123, 3, 'Food', '2022-03-31 19:21:00', 10, 'Enjoy!', '2022-07-01', 'Eden Tan', 'eatturn@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (112, 123, 1, 'Food', '2022-03-31 19:21:00', 10, 'Enjoy!', '2022-07-01', 'Veronica Tan', 'veronica.tan@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (113, 123, 1, 'Food', '2022-03-31 19:21:00', 10, 'Enjoy!', '2022-07-01', 'Dresden Ong', 'Dres-down@outlook.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50142, 152, 1, 'Ride', '2022-04-02 15:43:00', 15, 'Thanks for being there for me!', '2022-07-02', 'Isaac Chew', 'chewytoe@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50143, 152, 6, 'Ride', '2022-04-02 21:20:00', 15, 'I couldn\'t thank you enough!', '2022-07-02', 'Jaxon Mok', 'jaxon.mok@gmail.com');
INSERT INTO `mydb`.`Voucher` (`voucher_no`, `design_id`, `message_id`, `voucher_type`, `voucher_datetimestamp`, `voucher_value`, `personal_message`, `voucher_expiry`, `recipient_name`, `recipient_email`) VALUES (50144, 152, 1, 'Ride', '2022-04-02 23:07:00', 20, 'Awesome work!', '2022-07-02', 'Helen Lim', 'helen.lim@gmail.com');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Login`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (1, '00001', 'email', '2021-01-26 22:30:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (2, '00002', 'email', '2021-02-06 21:01:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (3, '00001', 'email', '2021-02-07 09:01:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (4, '00002', 'email', '2021-02-22 13:41:06');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (5, '00003', 'email', '2021-02-23 15:20:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (6, '00003', 'email', '2021-02-23 17:34:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (7, '00002', 'email', '2021-02-23 19:40:02');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (8, '00003', 'email', '2021-02-23 22:20:03');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (9, '00003', 'email', '2021-02-24 22:00:04');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (10, '00003', 'mobile', '2021-02-25 23:40:05');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (11, '00002', 'email', '2021-02-27 22:41:06');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (12, '00001', 'email', '2021-02-28 18:41:07');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (13, '00002', 'email', '2021-02-28 19:21:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (14, '00003', 'email', '2021-03-01 19:30:09');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (15, '00003', 'email', '2021-03-02 15:02:10');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (16, '00002', 'mobile', '2021-03-05 17:20:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (17, '00002', 'email', '2021-03-08 20:30:12');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (18, '00001', 'email', '2021-03-11 11:25:04');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (19, '00002', 'email', '2021-03-13 21:39:05');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (20, '00003', 'mobile', '2021-03-19 08:22:06');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (21, '00003', 'email', '2021-03-20 18:10:07');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (22, '00003', 'email', '2021-03-22 17:25:08');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (23, '00003', 'email', '2021-03-24 20:27:08');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (24, '00002', 'email', '2021-03-27 19:25:08');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (25, '00002', 'email', '2021-03-29 15:11:38');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (26, '00002', 'email', '2021-03-30 16:15:08');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (27, '00002', 'mobile', '2021-03-31 15:55:08');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (28, '00002', 'email', '2021-04-01 06:17:08');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (29, '00003', 'email', '2021-04-01 12:37:08');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (30, '00003', 'email', '2021-04-01 15:55:08');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (31, '00003', 'email', '2021-04-03 13:01:48');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (32, '00003', 'email', '2021-04-05 18:55:08');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (33, '00004', 'email', '2021-04-06 15:10:16');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (34, '00002', 'email', '2021-04-07 20:10:17');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (35, '00004', 'email', '2021-04-08 23:00:18');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (36, '00003', 'email', '2021-04-09 13:21:19');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (37, '00002', 'email', '2021-04-10 07:31:20');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (38, '00004', 'mobile', '2021-04-11 06:50:21');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (39, '00002', 'mobile', '2021-04-12 16:44:22');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (40, '00003', 'email', '2021-04-13 21:10:23');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (41, '00005', 'email', '2021-04-14 07:09:03');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (42, '00002', 'email', '2021-04-14 10:29:04');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (43, '00004', 'email', '2021-04-14 12:31:34');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (44, '00004', 'email', '2021-04-14 12:51:59');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (45, '00005', 'email', '2021-04-15 07:54:23');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (46, '00004', 'email', '2021-04-16 09:58:40');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (47, '00004', 'email', '2021-04-17 08:27:27');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (48, '00005', 'email', '2021-04-18 09:21:41');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (49, '00004', 'mobile', '2021-04-19 14:14:29');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (50, '00002', 'email', '2021-04-20 12:54:20');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (51, '00004', 'mobile', '2021-04-21 12:34:19');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (52, '00005', 'email', '2021-04-22 13:28:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (53, '00004', 'mobile', '2021-04-23 13:34:51');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (54, '00005', 'mobile', '2021-04-24 16:14:29');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (55, '00003', 'email', '2021-04-25 08:54:43');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (56, '00003', 'email', '2021-04-26 08:07:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (57, '00002', 'email', '2021-04-27 07:14:41');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (58, '00003', 'email', '2021-04-28 12:54:29');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (59, '00005', 'email', '2021-04-29 11:17:09');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (60, '00002', 'email', '2021-04-30 15:04:17');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (61, '00004', 'mobile', '2021-05-01 16:34:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (62, '00005', 'email', '2021-05-02 00:57:29');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (63, '00005', 'email', '2021-05-03 15:53:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (64, '00003', 'email', '2021-05-04 08:01:09');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (65, '00006', 'mobile', '2021-05-04 13:41:52');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (66, '00005', 'email', '2021-05-05 07:41:53');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (67, '00006', 'email', '2021-05-06 08:41:54');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (68, '00006', 'email', '2021-05-07 08:45:55');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (69, '00005', 'email', '2021-05-07 21:21:21');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (70, '00004', 'email', '2021-05-08 08:49:57');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (71, '00003', 'email', '2021-05-09 07:11:58');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (72, '00004', 'email', '2021-05-09 08:51:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (73, '00003', 'email', '2021-05-10 11:41:15');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (74, '00007', 'email', '2021-05-10 12:19:45');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (75, '00002', 'email', '2021-05-11 09:15:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (76, '00004', 'email', '2021-05-12 09:45:16');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (77, '00005', 'email', '2021-05-13 11:35:17');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (78, '00004', 'email', '2021-05-14 11:05:39');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (79, '00005', 'email', '2021-05-15 20:15:15');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (80, '00003', 'email', '2021-05-16 13:33:30');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (81, '00003', 'email', '2021-05-17 09:45:47');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (82, '00007', 'email', '2021-05-18 11:15:50');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (83, '00006', 'email', '2021-05-19 11:10:04');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (84, '00007', 'email', '2021-05-20 15:17:15');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (85, '00006', 'mobile', '2021-05-21 06:35:21');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (86, '00006', 'email', '2021-05-22 07:55:29');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (87, '00003', 'email', '2021-05-23 08:11:40');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (88, '00002', 'email', '2021-05-24 18:41:34');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (89, '00005', 'email', '2021-05-25 10:15:50');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (90, '00002', 'email', '2021-05-26 10:11:10');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (91, '00005', 'mobile', '2021-05-27 11:05:44');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (92, '00004', 'email', '2021-05-28 00:22:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (93, '00008', 'email', '2021-05-28 01:11:02');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (94, '00007', 'email', '2021-05-28 06:31:03');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (95, '00005', 'mobile', '2021-05-28 07:50:04');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (96, '00004', 'email', '2021-05-28 14:21:05');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (97, '00006', 'email', '2021-05-28 15:19:06');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (98, '00008', 'email', '2021-05-28 17:11:07');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (99, '00009', 'email', '2021-06-04 12:44:15');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (100, '00008', 'email', '2021-06-05 12:04:18');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (101, '00002', 'email', '2021-06-06 08:44:19');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (102, '00005', 'email', '2021-06-06 09:27:20');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (103, '00004', 'email', '2021-06-06 13:21:19');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (104, '00008', 'mobile', '2021-06-06 14:49:22');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (105, '00007', 'email', '2021-06-07 14:52:23');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (106, '00005', 'email', '2021-06-07 21:14:24');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (107, '00008', 'email', '2021-06-08 16:37:25');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (108, '00010', 'email', '2021-06-09 19:24:38');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (109, '00009', 'email', '2021-06-10 07:44:02');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (110, '00008', 'mobile', '2021-06-11 17:54:36');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (111, '00002', 'email', '2021-06-14 13:04:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (112, '00007', 'email', '2021-06-15 12:44:39');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (113, '00007', 'email', '2021-06-18 11:41:51');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (114, '00011', 'mobile', '2021-06-19 10:33:29');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (115, '00010', 'email', '2021-06-19 10:43:30');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (116, '00009', 'email', '2021-06-19 10:58:31');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (117, '00004', 'email', '2021-06-19 12:08:35');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (118, '00012', 'mobile', '2021-06-21 21:48:52');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (119, '00010', 'email', '2021-06-24 20:48:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (120, '00009', 'email', '2021-06-25 20:28:57');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (121, '00008', 'email', '2021-06-27 19:59:05');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (122, '00002', 'email', '2021-06-28 22:13:36');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (123, '00005', 'email', '2021-06-29 12:28:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (124, '00004', 'email', '2021-06-29 23:58:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (125, '00008', 'email', '2021-06-30 20:25:41');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (126, '00007', 'mobile', '2021-07-04 19:34:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (127, '00005', 'mobile', '2021-07-06 17:41:39');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (128, '00010', 'mobile', '2021-07-06 21:11:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (129, '00009', 'mobile', '2021-07-07 17:37:12');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (130, '00011', 'mobile', '2021-07-10 15:48:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (131, '00002', 'mobile', '2021-07-13 13:19:44');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (132, '00005', 'mobile', '2021-07-13 22:08:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (133, '00004', 'mobile', '2021-07-16 22:41:44');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (134, '00008', 'email', '2021-07-19 15:48:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (135, '00007', 'email', '2021-07-20 16:44:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (136, '00005', 'email', '2021-07-21 17:05:41');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (137, '00008', 'email', '2021-07-22 18:46:13');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (138, '00011', 'email', '2021-07-23 19:18:33');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (139, '00009', 'mobile', '2021-07-24 20:58:52');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (140, '00008', 'email', '2021-07-25 21:07:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (141, '00002', 'email', '2021-07-26 23:09:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (142, '00007', 'email', '2021-07-27 18:35:26');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (143, '00010', 'mobile', '2021-07-28 21:38:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (144, '00009', 'email', '2021-07-29 16:04:04');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (145, '00011', 'email', '2021-07-30 10:08:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (146, '00002', 'email', '2021-07-31 22:38:26');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (147, '00011', 'email', '2021-08-01 08:22:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (148, '00004', 'mobile', '2021-08-02 11:56:36');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (149, '00008', 'email', '2021-08-03 15:18:44');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (150, '00007', 'email', '2021-08-04 19:14:41');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (151, '00005', 'email', '2021-08-05 22:09:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (152, '00003', 'email', '2021-08-06 22:59:02');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (153, '00007', 'email', '2021-08-07 00:48:33');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (154, '00006', 'email', '2021-08-08 14:48:18');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (155, '00007', 'email', '2021-08-09 14:39:42');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (156, '00006', 'email', '2021-08-10 14:18:29');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (157, '00006', 'email', '2021-08-11 21:34:25');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (158, '00003', 'mobile', '2021-08-12 21:37:20');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (159, '00002', 'mobile', '2021-08-13 13:48:51');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (160, '00005', 'email', '2021-08-14 17:05:37');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (161, '00002', 'email', '2021-08-15 17:24:44');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (162, '00005', 'email', '2021-08-16 21:22:22');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (163, '00012', 'email', '2021-08-17 19:33:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (164, '00010', 'email', '2021-08-18 19:49:51');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (165, '00009', 'mobile', '2021-08-19 22:22:22');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (166, '00008', 'email', '2021-08-20 22:34:27');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (167, '00002', 'email', '2021-08-21 11:48:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (168, '00005', 'email', '2021-08-22 13:28:40');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (169, '00004', 'email', '2021-08-23 21:38:14');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (170, '00008', 'email', '2021-08-24 20:28:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (171, '00001', 'mobile', '2021-08-25 21:17:06');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (172, '00002', 'email', '2021-08-26 19:48:43');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (173, '00007', 'email', '2021-08-27 20:58:16');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (174, '00003', 'mobile', '2021-08-28 23:21:59');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (175, '00002', 'email', '2021-08-29 17:11:23');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (176, '00012', 'email', '2021-08-30 16:39:02');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (177, '00007', 'email', '2021-08-31 16:59:41');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (178, '00009', 'email', '2021-09-01 17:13:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (179, '00008', 'email', '2021-09-02 21:00:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (180, '00009', 'email', '2021-09-03 22:35:49');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (181, '00008', 'email', '2021-09-04 21:41:23');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (182, '00010', 'email', '2021-09-05 21:32:05');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (183, '00012', 'email', '2021-09-06 22:36:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (184, '00003', 'email', '2021-09-07 21:37:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (185, '00002', 'email', '2021-09-08 20:29:09');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (186, '00005', 'email', '2021-09-09 17:48:24');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (187, '00002', 'email', '2021-09-10 16:58:05');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (188, '00005', 'email', '2021-09-11 18:37:25');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (189, '00007', 'email', '2021-09-12 15:41:49');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (190, '00010', 'email', '2021-09-13 21:39:25');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (191, '00009', 'email', '2021-09-14 12:47:55');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (192, '00008', 'email', '2021-09-15 11:39:21');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (193, '00002', 'email', '2021-09-16 19:26:26');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (194, '00003', 'email', '2021-09-17 20:05:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (195, '00002', 'email', '2021-09-18 19:48:15');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (196, '00005', 'email', '2021-09-19 20:27:19');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (197, '00002', 'email', '2021-09-20 21:55:06');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (198, '00005', 'mobile', '2021-09-21 21:12:12');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (199, '00012', 'email', '2021-09-22 20:19:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (200, '00010', 'email', '2021-09-23 20:24:34');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (201, '00009', 'mobile', '2021-09-24 11:01:02');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (202, '00008', 'email', '2021-09-25 12:41:51');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (203, '00002', 'email', '2021-09-26 17:28:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (204, '00005', 'email', '2021-09-27 22:01:41');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (205, '00004', 'email', '2021-09-28 23:33:21');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (206, '00008', 'email', '2021-09-29 20:34:43');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (207, '00001', 'email', '2021-09-30 19:48:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (208, '00013', 'email', '2021-10-01 06:17:30');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (209, '00008', 'email', '2021-10-02 13:17:31');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (210, '00010', 'email', '2021-10-03 06:01:31');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (211, '00009', 'email', '2021-10-04 06:29:08');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (212, '00012', 'email', '2021-10-05 07:17:31');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (213, '00008', 'email', '2021-10-06 11:37:55');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (214, '00013', 'mobile', '2021-10-07 07:11:12');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (215, '00002', 'email', '2021-10-08 09:31:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (216, '00010', 'email', '2021-10-09 10:49:31');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (217, '00009', 'email', '2021-10-12 13:17:25');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (218, '00012', 'email', '2021-10-14 12:21:27');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (219, '00001', 'email', '2021-10-15 07:57:31');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (220, '00013', 'email', '2021-10-15 11:24:12');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (221, '00001', 'email', '2021-10-17 09:47:31');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (222, '00013', 'email', '2021-10-19 10:15:39');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (223, '00002', 'email', '2021-10-20 10:23:09');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (224, '00014', 'email', '2021-10-21 03:09:58');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (225, '00009', 'email', '2021-10-22 08:00:29');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (226, '00001', 'email', '2021-10-23 03:17:34');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (227, '00007', 'mobile', '2021-10-24 09:09:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (228, '00013', 'email', '2021-10-25 09:25:51');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (229, '00001', 'email', '2021-10-26 09:33:27');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (230, '00015', 'email', '2021-10-27 14:46:13');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (231, '00016', 'email', '2021-10-27 23:41:29');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (232, '00014', 'email', '2021-10-29 00:11:23');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (233, '00012', 'email', '2021-10-30 17:46:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (234, '00016', 'email', '2021-10-31 19:31:14');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (235, '00013', 'email', '2021-11-01 13:11:23');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (236, '00015', 'email', '2021-11-02 15:21:53');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (237, '00014', 'email', '2021-11-03 16:01:23');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (238, '00010', 'mobile', '2021-11-04 16:19:53');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (239, '00009', 'email', '2021-11-05 13:31:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (240, '00016', 'email', '2021-11-06 17:21:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (241, '00009', 'email', '2021-11-07 18:39:43');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (242, '00016', 'email', '2021-11-08 20:29:23');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (243, '00001', 'email', '2021-11-09 20:31:35');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (244, '00016', 'email', '2021-11-09 23:09:20');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (245, '00017', 'email', '2021-11-10 15:01:27');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (246, '00009', 'email', '2021-11-10 15:12:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (247, '00011', 'email', '2021-11-11 10:39:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (248, '00014', 'mobile', '2021-11-12 15:12:21');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (249, '00016', 'mobile', '2021-11-13 12:32:51');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (250, '00005', 'mobile', '2021-11-14 14:10:09');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (251, '00017', 'mobile', '2021-11-15 15:01:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (252, '00016', 'mobile', '2021-11-16 19:35:45');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (253, '00007', 'mobile', '2021-11-17 18:12:51');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (254, '00015', 'mobile', '2021-11-18 15:44:30');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (255, '00005', 'mobile', '2021-11-19 10:20:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (256, '00002', 'mobile', '2021-11-20 12:29:58');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (257, '00014', 'email', '2021-11-21 09:50:14');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (258, '00012', 'email', '2021-11-22 17:12:33');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (259, '00006', 'email', '2021-11-23 18:50:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (260, '00002', 'email', '2021-11-24 12:26:51');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (261, '00016', 'email', '2021-11-25 14:30:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (262, '00011', 'email', '2021-11-26 15:01:20');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (263, '00012', 'email', '2021-11-27 14:12:23');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (264, '00008', 'email', '2021-11-28 18:10:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (265, '00015', 'mobile', '2021-11-29 19:30:24');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (266, '00014', 'email', '2021-11-30 15:05:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (267, '00018', 'email', '2021-12-01 20:55:20');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (268, '00015', 'email', '2021-12-02 15:41:10');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (269, '00001', 'email', '2021-12-03 10:21:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (270, '00012', 'email', '2021-12-04 22:12:51');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (271, '00013', 'email', '2021-12-05 00:10:32');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (272, '00011', 'email', '2021-12-06 05:30:44');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (273, '00010', 'email', '2021-12-07 07:28:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (274, '00004', 'email', '2021-12-08 09:40:02');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (275, '00016', 'email', '2021-12-09 10:12:41');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (276, '00016', 'email', '2021-12-10 12:20:20');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (277, '00004', 'email', '2021-12-11 18:28:36');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (278, '00012', 'email', '2021-12-12 15:25:41');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (279, '00016', 'email', '2021-12-13 20:55:52');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (280, '00003', 'email', '2021-12-14 15:51:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (281, '00003', 'email', '2021-12-15 18:53:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (282, '00004', 'mobile', '2021-12-16 15:40:44');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (283, '00018', 'email', '2021-12-17 20:19:58');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (284, '00004', 'email', '2021-12-18 14:12:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (285, '00016', 'email', '2021-12-19 15:12:55');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (286, '00009', 'email', '2021-12-20 21:02:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (287, '00003', 'email', '2021-12-21 15:52:17');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (288, '00007', 'email', '2021-12-22 10:07:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (289, '00018', 'mobile', '2021-12-23 08:41:18');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (290, '00017', 'email', '2021-12-24 09:14:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (291, '00009', 'email', '2021-12-24 10:59:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (292, '00013', 'mobile', '2021-12-24 11:11:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (293, '00004', 'email', '2021-12-24 17:52:21');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (294, '00011', 'email', '2021-12-25 00:11:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (295, '00010', 'mobile', '2021-12-26 12:12:40');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (296, '00013', 'email', '2021-12-27 16:54:02');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (297, '00016', 'email', '2021-12-28 16:08:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (298, '00015', 'email', '2021-12-29 17:30:28');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (299, '00018', 'email', '2021-12-30 12:31:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (300, '00018', 'email', '2021-12-31 12:36:12');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (301, '00017', 'email', '2022-01-01 11:11:42');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (302, '00019', 'email', '2022-01-03 05:22:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (303, '00020', 'mobile', '2022-01-04 10:11:14');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (304, '00021', 'email', '2022-01-05 13:15:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (305, '00013', 'email', '2022-01-06 07:15:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (306, '00016', 'email', '2022-01-07 08:35:45');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (307, '00011', 'mobile', '2022-01-08 09:02:05');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (308, '00013', 'email', '2022-01-09 07:31:09');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (309, '00009', 'email', '2022-01-10 17:45:05');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (310, '00015', 'email', '2022-01-11 13:59:38');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (311, '00016', 'email', '2022-01-12 13:21:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (312, '00002', 'email', '2022-01-13 13:29:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (313, '00008', 'email', '2022-01-14 13:40:49');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (314, '00015', 'mobile', '2022-01-15 15:27:41');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (315, '00005', 'email', '2022-01-16 14:47:09');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (316, '00016', 'email', '2022-01-17 17:16:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (317, '00022', 'email', '2022-01-21 19:00:31');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (318, '00008', 'email', '2022-01-22 13:00:40');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (319, '00004', 'mobile', '2022-01-23 14:00:33');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (320, '00003', 'mobile', '2022-01-24 15:17:02');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (321, '00007', 'mobile', '2022-01-25 14:22:32');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (322, '00004', 'mobile', '2022-01-27 20:00:32');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (323, '00003', 'mobile', '2022-01-28 21:50:55');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (324, '00008', 'email', '2022-01-30 22:09:31');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (325, '00023', 'email', '2022-01-31 16:44:47');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (326, '00024', 'email', '2022-02-01 09:31:54');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (327, '00025', 'email', '2022-02-01 14:14:10');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (328, '00011', 'email', '2022-02-02 12:14:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (329, '00025', 'email', '2022-02-03 12:41:10');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (330, '00015', 'email', '2022-02-04 23:14:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (331, '00001', 'email', '2022-02-05 15:54:17');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (332, '00003', 'email', '2022-02-06 14:57:51');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (333, '00017', 'email', '2022-02-07 14:44:44');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (334, '00007', 'email', '2022-02-08 12:34:55');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (335, '00006', 'email', '2022-02-09 11:34:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (336, '00021', 'email', '2022-02-10 01:09:02');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (337, '00022', 'email', '2022-02-11 10:27:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (338, '00026', 'email', '2022-02-12 10:33:12');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (339, '00021', 'email', '2022-02-13 17:14:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (340, '00002', 'email', '2022-02-14 18:14:19');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (341, '00005', 'email', '2022-02-15 18:19:38');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (342, '00007', 'email', '2022-02-16 13:30:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (343, '00007', 'email', '2022-02-17 14:09:10');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (344, '00016', 'email', '2022-02-18 14:17:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (345, '00024', 'email', '2022-02-19 14:22:51');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (346, '00018', 'email', '2022-02-20 15:19:19');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (347, '00017', 'mobile', '2022-02-21 16:41:33');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (348, '00015', 'email', '2022-02-22 18:24:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (349, '00012', 'email', '2022-02-23 19:31:25');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (350, '00011', 'email', '2022-02-24 17:45:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (351, '00011', 'email', '2022-02-25 13:04:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (352, '00001', 'email', '2022-02-26 14:57:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (353, '00017', 'email', '2022-02-27 10:14:09');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (354, '00020', 'email', '2022-02-28 11:11:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (355, '00015', 'email', '2022-03-01 15:28:35');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (356, '00002', 'email', '2022-03-02 18:31:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (357, '00024', 'mobile', '2022-03-03 13:17:38');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (358, '00026', 'email', '2022-03-08 01:15:25');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (359, '00002', 'email', '2022-03-09 01:15:26');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (360, '00003', 'email', '2022-03-10 00:15:56');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (361, '00019', 'email', '2022-03-11 07:15:27');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (362, '00012', 'email', '2022-03-12 08:15:02');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (363, '00015', 'email', '2022-03-13 09:14:34');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (364, '00023', 'email', '2022-03-14 09:29:29');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (365, '00014', 'email', '2022-03-15 08:51:26');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (366, '00015', 'email', '2022-03-15 13:45:25');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (367, '00012', 'email', '2022-03-16 13:15:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (368, '00018', 'email', '2022-03-17 14:45:55');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (369, '00027', 'email', '2022-03-17 16:21:44');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (370, '00006', 'email', '2022-03-18 04:21:45');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (371, '00023', 'email', '2022-03-19 05:59:40');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (372, '00010', 'email', '2022-03-20 13:29:45');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (373, '00012', 'mobile', '2022-03-21 19:39:39');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (374, '00018', 'email', '2022-03-22 18:20:05');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (375, '00006', 'email', '2022-03-23 18:22:35');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (376, '00024', 'email', '2022-03-24 16:11:45');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (377, '00011', 'email', '2022-03-25 16:35:25');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (378, '00011', 'email', '2022-03-26 13:21:45');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (379, '00011', 'email', '2022-03-27 12:47:41');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (380, '00022', 'email', '2022-03-28 13:21:45');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (381, '00015', 'mobile', '2022-03-29 17:00:11');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (382, '00011', 'email', '2022-03-30 18:17:22');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (383, '00016', 'mobile', '2022-03-31 19:21:01');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (384, '00028', 'email', '2022-04-01 08:15:58');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (385, '00001', 'mobile', '2022-04-01 22:00:00');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (386, '00029', 'mobile', '2022-04-02 09:03:24');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (387, '00024', 'email', '2022-04-02 15:43:23');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (388, '00030', 'email', '2022-04-02 21:20:07');
INSERT INTO `mydb`.`Login` (`login_id`, `customer_id`, `login_type`, `login_datetime`) VALUES (389, '00019', 'email', '2022-04-02 23:07:01');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Preferred_Comm`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Preferred_Comm` (`comm_id`, `comm_type`) VALUES (1, 'SMS');
INSERT INTO `mydb`.`Preferred_Comm` (`comm_id`, `comm_type`) VALUES (2, 'Call');
INSERT INTO `mydb`.`Preferred_Comm` (`comm_id`, `comm_type`) VALUES (3, 'Email');
INSERT INTO `mydb`.`Preferred_Comm` (`comm_id`, `comm_type`) VALUES (4, 'No, I would not like to receive communications');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Customer_Pref_Comm`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (1, '00001', 1, '2021-01-26 22:17:46');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (2, '00001', 2, '2021-01-26 22:17:46');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (3, '00001', 3, '2021-01-26 22:17:46');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (4, '00002', 1, '2021-02-06 20:55:14');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (5, '00002', 3, '2021-02-06 20:55:14');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (6, '00003', 4, '2021-02-23 15:10:04');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (7, '00004', 4, '2021-04-06 14:59:45');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (8, '00005', 1, '2021-04-14 06:58:06');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (9, '00005', 2, '2021-04-14 06:58:06');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (10, '00005', 3, '2021-04-14 06:58:06');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (11, '00006', 3, '2021-05-04 13:32:04');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (12, '00007', 1, '2021-05-10 12:15:00');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (13, '00007', 3, '2021-05-10 12:15:00');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (14, '00008', 4, '2021-05-28 01:04:25');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (15, '00009', 4, '2021-06-04 12:33:27');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (16, '00010', 4, '2021-06-09 19:16:17');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (17, '00011', 1, '2021-06-19 10:28:01');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (18, '00011', 2, '2021-06-19 10:28:01');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (19, '00011', 3, '2021-06-19 10:28:01');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (20, '00012', 4, '2021-06-21 21:41:14');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (21, '00013', 3, '2021-10-01 06:09:26');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (22, '00014', 1, '2021-10-21 03:05:13');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (23, '00014', 3, '2021-10-21 03:05:13');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (24, '00015', 4, '2021-10-27 14:35:25');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (25, '00016', 4, '2021-10-27 23:33:42');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (26, '00017', 4, '2021-11-10 14:53:49');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (27, '00018', 4, '2021-12-01 20:43:57');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (28, '00019', 1, '2022-01-03 05:13:57');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (29, '00019', 2, '2022-01-03 05:13:57');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (30, '00019', 3, '2022-01-03 05:13:57');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (31, '00020', 3, '2022-01-04 10:01:26');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (32, '00021', 4, '2022-01-05 13:06:30');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (33, '00022', 4, '2022-01-21 18:52:10');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (34, '00023', 4, '2022-01-31 16:40:02');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (35, '00024', 1, '2022-02-01 09:24:07');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (36, '00024', 3, '2022-02-01 09:24:07');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (37, '00025', 4, '2022-02-01 14:05:32');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (38, '00026', 4, '2022-02-12 10:27:44');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (39, '00027', 4, '2022-03-17 16:16:50');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (40, '00028', 1, '2022-04-01 08:11:13');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (41, '00028', 2, '2022-04-01 08:11:13');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (42, '00028', 3, '2022-04-01 08:11:13');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (43, '00029', 4, '2022-04-02 08:58:48');
INSERT INTO `mydb`.`Customer_Pref_Comm` (`cust_pref_id`, `customer_id`, `comm_id`, `Date_Time`) VALUES (44, '00030', 4, '2022-04-02 21:12:20');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Shopping_Cart`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Shopping_Cart` (`customer_id`, `item_id`, `message_id`, `voucher_type`, `voucher_value`, `quantity`, `date_updated`, `recipient_name`, `recipient_email`, `personal_message`) VALUES ('00014', 1, 6, 'Food', '5', 6, '2022-03-15 09:17:00', 'Sweet Jim', 'jimmy.chan@gmail.com', 'You are so sweet!');
INSERT INTO `mydb`.`Shopping_Cart` (`customer_id`, `item_id`, `message_id`, `voucher_type`, `voucher_value`, `quantity`, `date_updated`, `recipient_name`, `recipient_email`, `personal_message`) VALUES ('00014', 2, 3, 'Ride', '10', 2, '2022-03-15 09:17:00', 'Uncle Tan', 'tanchenghock@gmail.com', 'I can\'t thank you enough.');
INSERT INTO `mydb`.`Shopping_Cart` (`customer_id`, `item_id`, `message_id`, `voucher_type`, `voucher_value`, `quantity`, `date_updated`, `recipient_name`, `recipient_email`, `personal_message`) VALUES ('00020', 1, 1, 'Ride', '15', 1, '2022-01-04 10:55:01', 'KS', 'kheesong@gmail.com', NULL);
INSERT INTO `mydb`.`Shopping_Cart` (`customer_id`, `item_id`, `message_id`, `voucher_type`, `voucher_value`, `quantity`, `date_updated`, `recipient_name`, `recipient_email`, `personal_message`) VALUES ('00029', 1, 2, 'Food', '5', 4, '2022-04-02 10:17:32', 'Gang Ho Kel', 'kel001@gmail.com', 'Thanks for defending me!');
INSERT INTO `mydb`.`Shopping_Cart` (`customer_id`, `item_id`, `message_id`, `voucher_type`, `voucher_value`, `quantity`, `date_updated`, `recipient_name`, `recipient_email`, `personal_message`) VALUES ('00029', 2, 3, 'Ride', '10', 3, '2022-04-02 10:17:32', 'Gang Ho Kel', 'kel001@gmail.com', 'Thank you!');
INSERT INTO `mydb`.`Shopping_Cart` (`customer_id`, `item_id`, `message_id`, `voucher_type`, `voucher_value`, `quantity`, `date_updated`, `recipient_name`, `recipient_email`, `personal_message`) VALUES ('00029', 3, 2, 'Food', '10', 10, '2022-04-02 10:17:32', 'Mummy Dearest', 'cyn-tear@gmail.com', 'Happy Birthday!');
INSERT INTO `mydb`.`Shopping_Cart` (`customer_id`, `item_id`, `message_id`, `voucher_type`, `voucher_value`, `quantity`, `date_updated`, `recipient_name`, `recipient_email`, `personal_message`) VALUES ('00029', 4, 3, 'Ride', '5', 10, '2022-04-02 10:17:32', 'Ah Hock', 'atomicsam@gmail.com', 'Bestie Forever!');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Billing_has_Voucher`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0001', 1);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0001', 2);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0001', 50000);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0001', 50001);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0002', 3);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0003', 4);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0003', 50002);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0003', 50003);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0004', 50004);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0005', 5);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0006', 6);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0006', 50005);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0007', 7);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0008', 8);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0008', 9);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0009', 50006);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0010', 50007);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0011', 10);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0011', 11);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0011', 50008);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0011', 50009);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0011', 50010);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0011', 50011);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0011', 50012);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0012', 50013);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0013', 12);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0014', 50014);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0015', 50015);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0015', 50016);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0015', 50017);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0016', 13);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0017', 14);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0018', 15);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0019', 16);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0019', 17);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0019', 50018);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0020', 50019);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0021', 50020);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0021', 50021);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0021', 50022);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0022', 18);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0022', 50023);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0023', 50024);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0023', 50025);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0023', 50026);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0023', 50027);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0023', 50028);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0023', 50029);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0023', 50030);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0023', 50031);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0024', 19);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0024', 20);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0024', 21);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0024', 22);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0024', 23);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0025', 24);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0026', 25);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0026', 26);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0026', 27);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0026', 28);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0027', 29);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0027', 50032);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0027', 50033);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0028', 30);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0028', 50034);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0029', 31);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0030', 50035);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0030', 50036);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0030', 50037);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0030', 50038);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0030', 50039);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0030', 50040);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0031', 32);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0032', 33);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0033', 34);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0033', 50041);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0033', 50042);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0033', 50043);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0034', 50044);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0035', 35);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0035', 36);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0035', 37);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0036', 38);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0036', 39);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0036', 40);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0036', 41);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0036', 42);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0037', 50045);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0038', 43);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0038', 44);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0038', 45);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0038', 46);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0038', 47);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0038', 50046);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0038', 50047);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0038', 50048);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0038', 50049);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0039', 50050);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0040', 50051);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0040', 50052);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0040', 50053);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0041', 50054);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0041', 50055);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0041', 50056);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0041', 50057);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0042', 48);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0043', 49);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0044', 50058);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0044', 50059);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0044', 50060);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0045', 50);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0046', 51);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0047', 52);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0047', 53);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0047', 54);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0047', 55);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0048', 50061);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0049', 56);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0049', 57);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0049', 58);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0049', 59);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0049', 60);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0049', 61);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0049', 50062);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0049', 50063);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0049', 50064);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0049', 50065);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0050', 62);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0051', 50066);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0051', 50067);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0051', 50068);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0051', 50069);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0051', 50070);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0052', 50071);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0052', 50072);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0052', 50073);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0052', 50074);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0052', 50075);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0052', 50076);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0052', 50077);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0052', 50078);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0052', 50079);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0052', 50080);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0053', 63);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0054', 64);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0054', 50081);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0054', 50082);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0054', 50083);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0055', 65);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0056', 66);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0056', 67);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0057', 50084);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0058', 68);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0058', 69);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0058', 70);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0058', 71);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0059', 50085);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0060', 50086);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0061', 72);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0062', 73);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0062', 74);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0062', 75);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0063', 50087);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0063', 50088);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0064', 50089);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0064', 50090);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0064', 50091);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0064', 50092);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0065', 50093);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0066', 76);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0067', 77);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0068', 78);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0068', 79);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0068', 50094);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0068', 50095);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0069', 80);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0069', 81);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0069', 50096);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0069', 50097);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0070', 82);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0071', 50098);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0072', 83);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0073', 84);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0074', 85);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0074', 86);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0074', 87);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0074', 50099);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0074', 50100);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0074', 50101);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0075', 88);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0076', 50102);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0076', 50103);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0076', 50104);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0077', 50105);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0078', 50106);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0078', 50107);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0078', 50108);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0078', 50109);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0078', 50110);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0078', 50111);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0078', 50112);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0078', 50113);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0078', 50114);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0078', 50115);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0078', 50116);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0078', 50117);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0079', 50118);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0079', 50119);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0080', 89);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0081', 50120);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0082', 90);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0083', 91);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0084', 92);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0084', 93);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0084', 50121);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0084', 50122);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0084', 50123);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0084', 50124);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0085', 94);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0086', 50125);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0087', 50126);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0088', 95);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0089', 50127);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0090', 50128);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0090', 50129);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0090', 50130);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0091', 96);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0091', 97);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0091', 98);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0092', 99);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0092', 100);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0092', 101);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0093', 50131);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0094', 102);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0094', 103);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0094', 104);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0094', 105);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0095', 50132);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0096', 106);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0097', 50133);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0098', 50134);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0099', 107);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0099', 108);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0099', 109);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0099', 110);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0099', 50135);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0099', 50136);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0099', 50137);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0099', 50138);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0099', 50139);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0099', 50140);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0099', 50141);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0100', 111);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0100', 112);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0100', 113);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0101', 50142);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0102', 50143);
INSERT INTO `mydb`.`Billing_has_Voucher` (`billing_no`, `voucher_no`) VALUES ('B0103', 50144);

COMMIT;

