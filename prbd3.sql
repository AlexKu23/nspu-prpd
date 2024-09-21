-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema bd_school
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema bd_school
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bd_school` DEFAULT CHARACTER SET utf8 ;
USE `bd_school` ;

-- -----------------------------------------------------
-- Table `bd_school`.`student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_school`.`student` (
  `id` INT NOT NULL,
  `full_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NULL,
  `phone_number` VARCHAR(45) NOT NULL,
  `date_of_birth` DATE NULL,
  `place_of_residence` MEDIUMTEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_school`.`subject`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_school`.`subject` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_school`.`teacher`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_school`.`teacher` (
  `id` INT NOT NULL,
  `name` MEDIUMTEXT NOT NULL,
  `passport` VARCHAR(45) NOT NULL,
  `subject_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_teacher_subject_idx` (`subject_id` ASC) VISIBLE,
  CONSTRAINT `fk_teacher_subject`
    FOREIGN KEY (`subject_id`)
    REFERENCES `bd_school`.`subject` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_school`.`organization`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_school`.`organization` (
  `inn` INT NOT NULL,
  PRIMARY KEY (`inn`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_school`.`group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_school`.`group` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `time` TIME NOT NULL,
  `date` DATE NOT NULL,
  `subject_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_group_subject1_idx` (`subject_id` ASC) VISIBLE,
  CONSTRAINT `fk_group_subject1`
    FOREIGN KEY (`subject_id`)
    REFERENCES `bd_school`.`subject` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_school`.`list_of_students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_school`.`list_of_students` (
  `group_id` INT NOT NULL,
  `student_id` INT NOT NULL,
  PRIMARY KEY (`group_id`, `student_id`),
  INDEX `fk_group_has_student_student1_idx` (`student_id` ASC) VISIBLE,
  INDEX `fk_group_has_student_group1_idx` (`group_id` ASC) VISIBLE,
  CONSTRAINT `fk_group_has_student_group1`
    FOREIGN KEY (`group_id`)
    REFERENCES `bd_school`.`group` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_has_student_student1`
    FOREIGN KEY (`student_id`)
    REFERENCES `bd_school`.`student` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_school`.`pay`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_school`.`pay` (
  `institution_inn` INT NOT NULL,
  `student_id` INT NOT NULL,
  `subject_id` INT NOT NULL,
  `info` VARCHAR(45) NULL,
  `paycol` VARCHAR(45) NULL,
  `pay_all_course` VARCHAR(45) NULL,
  `pay_half_course` VARCHAR(45) NULL,
  `pay_monthly` VARCHAR(45) NULL,
  PRIMARY KEY (`institution_inn`, `student_id`),
  INDEX `fk_institution_has_student_student1_idx` (`student_id` ASC) VISIBLE,
  INDEX `fk_institution_has_student_institution1_idx` (`institution_inn` ASC) VISIBLE,
  INDEX `fk_pay_subject1_idx` (`subject_id` ASC) VISIBLE,
  CONSTRAINT `fk_institution_has_student_institution1`
    FOREIGN KEY (`institution_inn`)
    REFERENCES `bd_school`.`organization` (`inn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_institution_has_student_student1`
    FOREIGN KEY (`student_id`)
    REFERENCES `bd_school`.`student` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pay_subject1`
    FOREIGN KEY (`subject_id`)
    REFERENCES `bd_school`.`subject` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_school`.`work`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_school`.`work` (
  `teacher_id` INT NOT NULL,
  `institution_inn` INT NOT NULL,
  PRIMARY KEY (`teacher_id`, `institution_inn`),
  INDEX `fk_teacher_has_institution_institution1_idx` (`institution_inn` ASC) VISIBLE,
  INDEX `fk_teacher_has_institution_teacher1_idx` (`teacher_id` ASC) VISIBLE,
  CONSTRAINT `fk_teacher_has_institution_teacher1`
    FOREIGN KEY (`teacher_id`)
    REFERENCES `bd_school`.`teacher` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_teacher_has_institution_institution1`
    FOREIGN KEY (`institution_inn`)
    REFERENCES `bd_school`.`organization` (`inn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_school`.`curse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_school`.`curse` (
  `student_id` INT NOT NULL,
  `subject_id` INT NOT NULL,
  `pay_institution_inn` INT NOT NULL,
  `pay_student_id` INT NOT NULL,
  `finish_date` DATE NULL,
  `start_date` DATE NULL,
  PRIMARY KEY (`student_id`, `subject_id`, `pay_institution_inn`, `pay_student_id`),
  INDEX `fk_student_has_subject_subject1_idx` (`subject_id` ASC) VISIBLE,
  INDEX `fk_student_has_subject_student1_idx` (`student_id` ASC) VISIBLE,
  INDEX `fk_curse_pay1_idx` (`pay_institution_inn` ASC, `pay_student_id` ASC) VISIBLE,
  CONSTRAINT `fk_student_has_subject_student1`
    FOREIGN KEY (`student_id`)
    REFERENCES `bd_school`.`student` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_student_has_subject_subject1`
    FOREIGN KEY (`subject_id`)
    REFERENCES `bd_school`.`subject` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_curse_pay1`
    FOREIGN KEY (`pay_institution_inn` , `pay_student_id`)
    REFERENCES `bd_school`.`pay` (`institution_inn` , `student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
