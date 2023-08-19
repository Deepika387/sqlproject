 CREATE TABLE `rota` (
  `row_id` INT NOT NULL,
  `rota_id` VARCHAR(20) NULL,
  `date` DATETIME NULL,
  `shift_id` VARCHAR(20) NULL,
  `staff_id` VARCHAR(20) NULL,
  PRIMARY KEY (`row_id`));
  
  CREATE TABLE `staff` (
  `staff_id` VARCHAR(20) NOT NULL,
  `first_name` VARCHAR(50) NULL,
  `last_name` VARCHAR(50) NULL,
  `position` VARCHAR(100) NULL,
  `hourly_rate` DECIMAL(5,2) NULL,
  PRIMARY KEY (`staff_id`));
  
  CREATE TABLE `shift` (
  `shift_id` VARCHAR(20) NOT NULL,
  `day_of_week` VARCHAR(10) NULL,
  `strat_time` TIME NULL,
  `end_time` TIME NULL,
  PRIMARY KEY (`shift_id`));
  
  
  