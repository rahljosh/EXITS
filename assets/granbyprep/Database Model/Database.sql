SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
CREATE SCHEMA IF NOT EXISTS `granbyprep` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;
USE `granbyprep` ;

-- -----------------------------------------------------
-- Table `granbyprep`.`application`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`application` (
  `Id` SMALLINT(6) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(100) NOT NULL DEFAULT '' ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8
COMMENT = 'Store Different Applications';


-- -----------------------------------------------------
-- Table `granbyprep`.`applicationquestion`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`applicationquestion` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT ,
  `applicationID` SMALLINT(6) NOT NULL DEFAULT '0' ,
  `fieldKey` VARCHAR(100) NOT NULL DEFAULT '' ,
  `displayField` VARCHAR(255) NOT NULL DEFAULT '' ,
  `sectionName` VARCHAR(50) NOT NULL DEFAULT '' ,
  `orderKey` SMALLINT(6) NOT NULL DEFAULT '0' COMMENT 'Used to identify questions in a page. These must be unique.' ,
  `classType` VARCHAR(50) NOT NULL DEFAULT '' ,
  `isRequired` BIT(1) NOT NULL DEFAULT b'0' ,
  `requiredMessage` VARCHAR(100) NOT NULL DEFAULT '' ,
  `isDeleted` BIT(1) NOT NULL DEFAULT b'0' ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) ,
  INDEX `applicationID` (`applicationID` ASC) ,
  INDEX `fkApplicationQuestionApplicationID` (`applicationID` ASC) ,
  CONSTRAINT `fkApplicationQuestionApplicationID`
    FOREIGN KEY (`applicationID` )
    REFERENCES `granbyprep`.`application` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 82
DEFAULT CHARACTER SET = utf8
COMMENT = 'Stores Applications Questions';


-- -----------------------------------------------------
-- Table `granbyprep`.`applicationanswer`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`applicationanswer` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT ,
  `applicationQuestionID` INT(11) NOT NULL DEFAULT '0' ,
  `foreignTable` VARCHAR(100) NOT NULL DEFAULT '' ,
  `foreignID` INT(11) NOT NULL DEFAULT '0' COMMENT 'This could be studentID, candidateID, hostID, etc.' ,
  `fieldKey` VARCHAR(100) NOT NULL DEFAULT '' ,
  `answer` LONGTEXT NOT NULL ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) ,
  INDEX `fkApplicationAnswerApplicationQuestionID` (`applicationQuestionID` ASC) ,
  CONSTRAINT `fkApplicationAnswerApplicationQuestionID`
    FOREIGN KEY (`applicationQuestionID` )
    REFERENCES `granbyprep`.`applicationquestion` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 168
DEFAULT CHARACTER SET = utf8
COMMENT = 'Stores application answers';


-- -----------------------------------------------------
-- Table `granbyprep`.`applicationlookup`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`applicationlookup` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT ,
  `applicationID` SMALLINT(6) NOT NULL DEFAULT '0' ,
  `fieldKey` VARCHAR(100) NOT NULL DEFAULT '' ,
  `name` VARCHAR(100) NOT NULL DEFAULT '' ,
  `isActive` BIT(1) NOT NULL DEFAULT b'1' ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) ,
  INDEX `fkApplicationLookUpApplicationID` (`applicationID` ASC) ,
  CONSTRAINT `fkApplicationLookUpApplicationID`
    FOREIGN KEY (`applicationID` )
    REFERENCES `granbyprep`.`application` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 24
DEFAULT CHARACTER SET = utf8
COMMENT = 'Stores values used in the system';


-- -----------------------------------------------------
-- Table `granbyprep`.`sessioninformation`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`sessioninformation` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT ,
  `httpReferer` VARCHAR(500) NOT NULL DEFAULT '' ,
  `entryPage` VARCHAR(500) NOT NULL DEFAULT '' ,
  `httpUserAgent` VARCHAR(500) NOT NULL DEFAULT '' ,
  `queryString` VARCHAR(500) NOT NULL DEFAULT '' ,
  `remoteAddr` VARCHAR(255) NOT NULL DEFAULT '' ,
  `remoteHost` VARCHAR(255) NOT NULL DEFAULT '' ,
  `httpHost` VARCHAR(255) NOT NULL DEFAULT '' ,
  `https` VARCHAR(255) NOT NULL DEFAULT '' ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Stores session information such as IP, date etc.';


-- -----------------------------------------------------
-- Table `granbyprep`.`country`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`country` (
  `Id` SMALLINT(6) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL DEFAULT '' ,
  `code` VARCHAR(5) NOT NULL DEFAULT '' ,
  `sevisCode` VARCHAR(5) NOT NULL DEFAULT '' ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 225
DEFAULT CHARACTER SET = utf8
COMMENT = 'List of Countries';


-- -----------------------------------------------------
-- Table `granbyprep`.`applicationpayment`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`applicationpayment` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT ,
  `applicationID` SMALLINT(6) NOT NULL DEFAULT '0' ,
  `sessionInformationID` INT(11) NOT NULL DEFAULT '0' ,
  `foreignTable` VARCHAR(255) NULL DEFAULT NULL ,
  `foreignID` INT(11) NOT NULL DEFAULT '0' COMMENT 'StudentID' ,
  `authTransactionID` VARCHAR(100) NOT NULL DEFAULT '' ,
  `authIsSuccess` BIT(1) NOT NULL DEFAULT b'0' ,
  `authApprovalCode` VARCHAR(100) NOT NULL DEFAULT '' ,
  `authResponseCode` VARCHAR(100) NOT NULL DEFAULT '' ,
  `authResponseReason` VARCHAR(100) NOT NULL DEFAULT '' ,
  `amount` FLOAT NOT NULL DEFAULT '0.00' ,
  `paymentMethodID` SMALLINT(6) NOT NULL DEFAULT '0' ,
  `paymentMethodType` VARCHAR(50) NOT NULL DEFAULT '' ,
  `creditCardTypeID` SMALLINT(6) NOT NULL DEFAULT '0' ,
  `creditCardType` VARCHAR(50) NOT NULL DEFAULT '' ,
  `nameOnCard` VARCHAR(100) NOT NULL DEFAULT '' ,
  `lastDigits` VARCHAR(4) NOT NULL DEFAULT '' ,
  `expirationMonth` VARCHAR(2) NOT NULL DEFAULT '' ,
  `expirationYear` VARCHAR(4) NOT NULL DEFAULT '' ,
  `billingFirstName` VARCHAR(100) NOT NULL DEFAULT '' ,
  `billingLastName` VARCHAR(100) NOT NULL DEFAULT '' ,
  `billingCompany` VARCHAR(100) NOT NULL DEFAULT '' ,
  `billingAddress` VARCHAR(100) NOT NULL DEFAULT '' ,
  `billingCity` VARCHAR(100) NOT NULL DEFAULT '' ,
  `billingState` VARCHAR(100) NOT NULL DEFAULT '' ,
  `billingZipCode` VARCHAR(50) NOT NULL DEFAULT '' ,
  `billingCountryID` SMALLINT(6) NOT NULL DEFAULT '0' ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) ,
  INDEX `fkApplicationPaymentApplicationID` (`applicationID` ASC) ,
  INDEX `fkApplicationPaymentSessionInformationID` (`sessionInformationID` ASC) ,
  INDEX `fkApplicationPaymentBillingCountryID` (`billingCountryID` ASC) ,
  CONSTRAINT `fkApplicationPaymentApplicationID`
    FOREIGN KEY (`applicationID` )
    REFERENCES `granbyprep`.`application` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkApplicationPaymentSessionInformationID`
    FOREIGN KEY (`sessionInformationID` )
    REFERENCES `granbyprep`.`sessioninformation` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkApplicationPaymentBillingCountryID`
    FOREIGN KEY (`billingCountryID` )
    REFERENCES `granbyprep`.`country` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Stores Application Payment Information';


-- -----------------------------------------------------
-- Table `granbyprep`.`applicationstatus`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`applicationstatus` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(100) NOT NULL DEFAULT '' ,
  `description` VARCHAR(255) NOT NULL DEFAULT '' ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8
COMMENT = 'Stores a list of application status.';


-- -----------------------------------------------------
-- Table `granbyprep`.`applicationstatusjn`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`applicationstatusjn` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT ,
  `applicationStatusID` INT(11) NOT NULL DEFAULT '0' ,
  `sessionInformationID` INT(11) NOT NULL DEFAULT '0' ,
  `foreignTable` VARCHAR(100) NOT NULL DEFAULT '' ,
  `foreignID` INT(11) NOT NULL DEFAULT '0' ,
  `description` VARCHAR(255) NOT NULL DEFAULT '' ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) ,
  INDEX `fkApplicationStatusJNApplicationStatusID` (`applicationStatusID` ASC) ,
  CONSTRAINT `fkApplicationStatusJNApplicationStatusID`
    FOREIGN KEY (`applicationStatusID` )
    REFERENCES `granbyprep`.`applicationstatus` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8
COMMENT = 'Student Application Status History';


-- -----------------------------------------------------
-- Table `granbyprep`.`content`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`content` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT ,
  `contentKey` VARCHAR(100) NOT NULL DEFAULT '' ,
  `name` VARCHAR(100) NOT NULL DEFAULT '' ,
  `content` TEXT NOT NULL ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8
COMMENT = 'Stores content used in any part of the site';


-- -----------------------------------------------------
-- Table `granbyprep`.`documenttype`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`documenttype` (
  `Id` SMALLINT(6) NOT NULL AUTO_INCREMENT ,
  `applicationID` SMALLINT(6) NOT NULL DEFAULT '0' ,
  `name` VARCHAR(100) NOT NULL DEFAULT '' ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) ,
  INDEX `fkDocumentTypeApplicationID` (`applicationID` ASC) ,
  CONSTRAINT `fkDocumentTypeApplicationID`
    FOREIGN KEY (`applicationID` )
    REFERENCES `granbyprep`.`application` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 16
DEFAULT CHARACTER SET = utf8
COMMENT = 'List of document types';


-- -----------------------------------------------------
-- Table `granbyprep`.`document`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`document` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT ,
  `hashID` VARCHAR(50) NOT NULL DEFAULT '' ,
  `foreignTable` VARCHAR(255) NULL DEFAULT NULL ,
  `foreignID` INT(11) NOT NULL DEFAULT '0' ,
  `documentTypeID` SMALLINT(6) NOT NULL DEFAULT '0' ,
  `description` VARCHAR(100) NOT NULL DEFAULT '' ,
  `serverName` VARCHAR(255) NOT NULL DEFAULT '' ,
  `serverExt` VARCHAR(10) NOT NULL DEFAULT '' ,
  `clientName` VARCHAR(255) NOT NULL DEFAULT '' ,
  `clientExt` VARCHAR(10) NOT NULL DEFAULT '' ,
  `fileSize` VARCHAR(50) NOT NULL DEFAULT '' ,
  `location` VARCHAR(255) NOT NULL DEFAULT '' ,
  `isDeleted` BIT(1) NOT NULL DEFAULT b'0' ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) ,
  INDEX `fkDocumentDocumentTypeID` (`documentTypeID` ASC) ,
  CONSTRAINT `fkDocumentDocumentTypeID`
    FOREIGN KEY (`documentTypeID` )
    REFERENCES `granbyprep`.`documenttype` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8
COMMENT = 'List of uploaded documents';


-- -----------------------------------------------------
-- Table `granbyprep`.`faqtype`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`faqtype` (
  `Id` SMALLINT(6) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL DEFAULT '' ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8
COMMENT = 'FAQ Type';


-- -----------------------------------------------------
-- Table `granbyprep`.`faq`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`faq` (
  `Id` SMALLINT(6) NOT NULL AUTO_INCREMENT ,
  `faqTypeID` SMALLINT(6) NOT NULL DEFAULT '0' ,
  `question` VARCHAR(255) NOT NULL DEFAULT '' ,
  `answer` TEXT NOT NULL ,
  `isDeleted` BIT(1) NOT NULL DEFAULT b'0' ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) ,
  INDEX `fkFaqFaqTypeID` (`faqTypeID` ASC) ,
  CONSTRAINT `fkFaqFaqTypeID`
    FOREIGN KEY (`faqTypeID` )
    REFERENCES `granbyprep`.`faqtype` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8
COMMENT = 'Frequently Asked Questions';


-- -----------------------------------------------------
-- Table `granbyprep`.`metadata`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`metadata` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT ,
  `pageName` VARCHAR(100) NOT NULL DEFAULT '' ,
  `title` VARCHAR(100) NOT NULL DEFAULT '' ,
  `keyword` VARCHAR(255) NOT NULL DEFAULT '' ,
  `description` VARCHAR(100) NOT NULL DEFAULT '' ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Stores page metadata information';


-- -----------------------------------------------------
-- Table `granbyprep`.`state`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`state` (
  `Id` SMALLINT(6) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL DEFAULT '100' ,
  `code` VARCHAR(5) NOT NULL DEFAULT '' ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 52
DEFAULT CHARACTER SET = utf8
COMMENT = 'List of states';


-- -----------------------------------------------------
-- Table `granbyprep`.`student`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `granbyprep`.`student` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT ,
  `applicationStatusID` INT(11) NOT NULL DEFAULT '0' ,
  `applicationPaymentID` INT(11) NOT NULL DEFAULT '0' ,
  `firstName` VARCHAR(100) NOT NULL DEFAULT '' ,
  `middleName` VARCHAR(100) NOT NULL DEFAULT '' ,
  `lastName` VARCHAR(100) NOT NULL DEFAULT '' ,
  `preferredName` VARCHAR(100) NOT NULL DEFAULT '' ,
  `email` VARCHAR(100) NOT NULL DEFAULT '' ,
  `password` VARCHAR(16) NOT NULL DEFAULT '' ,
  `gender` CHAR(1) NOT NULL DEFAULT '' ,
  `dob` DATE NULL DEFAULT NULL ,
  `countryBirthID` SMALLINT(6) NOT NULL DEFAULT '0' ,
  `countryCitizenID` SMALLINT(6) NOT NULL DEFAULT '0' ,
  `hasAddFamInfo` BIT(1) NOT NULL DEFAULT b'0' COMMENT 'Set to 1 to display additional family information' ,
  `isActive` BIT(1) NOT NULL DEFAULT b'1' ,
  `isDeleted` BIT(1) NOT NULL DEFAULT b'0' ,
  `dateCanceled` TIMESTAMP NULL DEFAULT NULL ,
  `dateLastLoggedIn` DATETIME NULL DEFAULT NULL ,
  `dateCreated` TIMESTAMP NULL DEFAULT NULL ,
  `dateUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`Id`) ,
  INDEX `fkStudentApplicationStatusID` (`applicationStatusID` ASC) ,
  INDEX `fkStudentCountryBirthID` (`countryBirthID` ASC) ,
  INDEX `fkStudentCountryCitizenID` (`countryCitizenID` ASC) ,
  CONSTRAINT `fkStudentApplicationStatusID`
    FOREIGN KEY (`applicationStatusID` )
    REFERENCES `granbyprep`.`applicationstatus` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkStudentCountryBirthID`
    FOREIGN KEY (`countryBirthID` )
    REFERENCES `granbyprep`.`country` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fkStudentCountryCitizenID`
    FOREIGN KEY (`countryCitizenID` )
    REFERENCES `granbyprep`.`country` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8
COMMENT = 'Stores basic student information';



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
