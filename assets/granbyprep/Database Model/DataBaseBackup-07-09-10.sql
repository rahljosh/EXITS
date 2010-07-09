# MySQL-Front 5.1  (Build 4.2)

/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE */;
/*!40101 SET SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES */;
/*!40103 SET SQL_NOTES='ON' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;


# Host: 192.168.100.151    Database: granbyprep
# ------------------------------------------------------
# Server version 5.1.47-community

DROP DATABASE IF EXISTS `granbyprep`;
CREATE DATABASE `granbyprep` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `granbyprep`;

#
# Source for table application
#

DROP TABLE IF EXISTS `application`;
CREATE TABLE `application` (
  `Id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `dateCreated` timestamp NULL DEFAULT NULL,
  `dateUpdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Store Different Applications';

#
# Dumping data for table application
#

LOCK TABLES `application` WRITE;
/*!40000 ALTER TABLE `application` DISABLE KEYS */;
INSERT INTO `application` VALUES (1,'Student Application','2010-06-11 13:06:05','2010-06-11 13:06:09');
/*!40000 ALTER TABLE `application` ENABLE KEYS */;
UNLOCK TABLES;

#
# Source for table applicationanswer
#

DROP TABLE IF EXISTS `applicationanswer`;
CREATE TABLE `applicationanswer` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `applicationQuestionID` int(11) NOT NULL DEFAULT '0',
  `foreignID` int(11) NOT NULL DEFAULT '0' COMMENT 'This could be studentID, candidateID, hostID, etc.',
  `fieldKey` varchar(100) NOT NULL DEFAULT '',
  `answer` longtext NOT NULL,
  `dateCreated` timestamp NULL DEFAULT NULL,
  `dateUpdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COMMENT='Stores application answers';

#
# Dumping data for table applicationanswer
#

LOCK TABLES `applicationanswer` WRITE;
/*!40000 ALTER TABLE `applicationanswer` DISABLE KEYS */;
INSERT INTO `applicationanswer` VALUES (1,1,1,'firstLanguage','Portuguese','2010-07-08 17:08:12','2010-07-08 17:08:12');
INSERT INTO `applicationanswer` VALUES (2,2,1,'homeAddress','111 Cooper Street','2010-07-08 17:08:12','2010-07-08 17:08:12');
INSERT INTO `applicationanswer` VALUES (3,3,1,'homeAddress2','','2010-07-08 17:08:12','2010-07-08 17:08:12');
INSERT INTO `applicationanswer` VALUES (4,4,1,'homeCity','Babylon','2010-07-08 17:08:12','2010-07-08 17:08:12');
INSERT INTO `applicationanswer` VALUES (5,5,1,'homeState','NY','2010-07-08 17:08:12','2010-07-08 17:08:12');
INSERT INTO `applicationanswer` VALUES (6,6,1,'homeZipCode','11702','2010-07-08 17:08:12','2010-07-08 17:08:12');
INSERT INTO `applicationanswer` VALUES (7,7,1,'homeCountryID','211','2010-07-08 17:08:12','2010-07-08 17:08:12');
INSERT INTO `applicationanswer` VALUES (8,8,1,'homeHomePhone','55-84-9989-7878','2010-07-08 17:08:12','2010-07-08 17:08:12');
INSERT INTO `applicationanswer` VALUES (9,9,1,'homeFax','631-893-4540','2010-07-08 17:08:12','2010-07-08 17:08:12');
INSERT INTO `applicationanswer` VALUES (10,10,1,'presentSchoolName','Colegio Objetivo','2010-07-08 17:08:12','2010-07-08 17:08:12');
INSERT INTO `applicationanswer` VALUES (11,11,1,'presentSchoolAddress','Rua Floriano Peixoto','2010-07-08 17:08:12','2010-07-08 17:08:12');
INSERT INTO `applicationanswer` VALUES (12,12,1,'presentSchoolCity','Natal','2010-07-08 17:08:12','2010-07-08 17:08:12');
INSERT INTO `applicationanswer` VALUES (13,13,1,'presentSchoolState','RN','2010-07-08 17:08:13','2010-07-08 17:08:12');
INSERT INTO `applicationanswer` VALUES (14,14,1,'presentSchoolZip','59020-760','2010-07-08 17:08:13','2010-07-08 17:08:12');
INSERT INTO `applicationanswer` VALUES (15,15,1,'presentSchoolCountryID','28','2010-07-08 17:08:13','2010-07-08 17:08:13');
INSERT INTO `applicationanswer` VALUES (16,16,1,'presentSchooldatesOfAttendance','1999-2000','2010-07-08 17:08:13','2010-07-08 17:08:13');
INSERT INTO `applicationanswer` VALUES (17,17,1,'presentSchoolType','Independent','2010-07-08 17:08:13','2010-07-08 17:08:13');
INSERT INTO `applicationanswer` VALUES (18,18,1,'currentGrade','7','2010-07-08 17:08:13','2010-07-08 17:08:13');
INSERT INTO `applicationanswer` VALUES (19,19,1,'applyingGrade','9','2010-07-08 17:08:13','2010-07-08 17:08:13');
INSERT INTO `applicationanswer` VALUES (20,20,1,'entranceDate','07/23/2010','2010-07-08 17:08:13','2010-07-08 17:08:13');
INSERT INTO `applicationanswer` VALUES (21,21,1,'applyingAs','BoardingStudent','2010-07-08 17:08:13','2010-07-08 17:08:13');
INSERT INTO `applicationanswer` VALUES (22,22,1,'pastSchools','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam vehicula tempus eleifend. Proin interdum arcu eu est dignissim auctor. In.','2010-07-08 17:08:13','2010-07-08 17:08:13');
INSERT INTO `applicationanswer` VALUES (23,72,1,'applicantLives','Father','2010-07-08 17:11:46','2010-07-08 17:11:53');
INSERT INTO `applicationanswer` VALUES (24,73,1,'AdmissionMaterial','Father','2010-07-08 17:11:46','2010-07-08 17:11:53');
INSERT INTO `applicationanswer` VALUES (25,74,1,'ParentInformation','fatherDeceased,motherDeceased','2010-07-08 17:11:46','2010-07-08 17:11:57');
INSERT INTO `applicationanswer` VALUES (26,75,1,'parentCustody','Father','2010-07-08 17:11:46','2010-07-08 17:14:09');
INSERT INTO `applicationanswer` VALUES (27,76,1,'financialAid','1','2010-07-08 17:11:46','2010-07-08 17:14:03');
/*!40000 ALTER TABLE `applicationanswer` ENABLE KEYS */;
UNLOCK TABLES;

#
# Source for table applicationpayment
#

DROP TABLE IF EXISTS `applicationpayment`;
CREATE TABLE `applicationpayment` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `sessionInformationID` int(11) NOT NULL DEFAULT '0',
  `applicationID` smallint(6) NOT NULL DEFAULT '0',
  `foreignTable` varchar(255) DEFAULT NULL,
  `foreignID` int(11) NOT NULL DEFAULT '0' COMMENT 'StudentID',
  `paymentMethodID` smallint(6) NOT NULL DEFAULT '0',
  `paymentMethod` varchar(50) NOT NULL DEFAULT '',
  `paymentTypeID` smallint(6) NOT NULL DEFAULT '0',
  `paymentType` varchar(50) NOT NULL DEFAULT '',
  `nameOnCard` varchar(100) NOT NULL DEFAULT '',
  `lastDigits` varchar(4) NOT NULL DEFAULT '',
  `expirationMonth` varchar(2) NOT NULL DEFAULT '',
  `expirationYear` varchar(4) NOT NULL DEFAULT '',
  `billingFirstName` varchar(100) NOT NULL DEFAULT '',
  `billingLastName` varchar(100) NOT NULL DEFAULT '',
  `billingCompany` varchar(100) NOT NULL DEFAULT '',
  `billingAddress` varchar(100) NOT NULL DEFAULT '',
  `billingAddress2` varchar(100) NOT NULL DEFAULT '',
  `billingApt` varchar(50) NOT NULL DEFAULT '',
  `billingCity` varchar(100) NOT NULL DEFAULT '',
  `billingState` varchar(100) NOT NULL DEFAULT '',
  `billingZipCode` varchar(50) NOT NULL DEFAULT '',
  `billingCountryID` smallint(6) NOT NULL DEFAULT '0',
  `dateCreated` timestamp NULL DEFAULT NULL,
  `dateUpdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Dumping data for table applicationpayment
#

LOCK TABLES `applicationpayment` WRITE;
/*!40000 ALTER TABLE `applicationpayment` DISABLE KEYS */;
/*!40000 ALTER TABLE `applicationpayment` ENABLE KEYS */;
UNLOCK TABLES;

#
# Source for table applicationquestion
#

DROP TABLE IF EXISTS `applicationquestion`;
CREATE TABLE `applicationquestion` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `applicationID` smallint(6) NOT NULL DEFAULT '0',
  `fieldKey` varchar(100) NOT NULL DEFAULT '',
  `displayField` varchar(255) NOT NULL DEFAULT '',
  `sectionName` varchar(50) NOT NULL DEFAULT '',
  `orderKey` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Used to identify questions in a page. These must be unique.',
  `classType` varchar(50) NOT NULL DEFAULT '',
  `isRequired` bit(1) NOT NULL DEFAULT b'0',
  `requiredMessage` varchar(100) NOT NULL DEFAULT '',
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `dateCreated` timestamp NULL DEFAULT NULL,
  `dateUpdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`),
  KEY `applicationID` (`applicationID`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8 COMMENT='Stores Applications Questions';

#
# Dumping data for table applicationquestion
#

LOCK TABLES `applicationquestion` WRITE;
/*!40000 ALTER TABLE `applicationquestion` DISABLE KEYS */;
INSERT INTO `applicationquestion` VALUES (1,1,'firstLanguage','First language other than English','section1',1,'largeField',b'0','',b'0','2010-07-06 11:51:11','2010-07-06 11:53:57');
INSERT INTO `applicationquestion` VALUES (2,1,'homeAddress','Address','section1',2,'largeField',b'1','Please enter home address',b'0','2010-06-22 09:33:48','2010-07-06 11:52:32');
INSERT INTO `applicationquestion` VALUES (3,1,'homeAddress2','Address 2','section1',3,'largeField',b'0','',b'0','2010-06-28 14:14:34','2010-07-06 11:52:33');
INSERT INTO `applicationquestion` VALUES (4,1,'homeCity','City','section1',4,'mediumField',b'1','Please enter home city',b'0','2010-06-22 09:34:28','2010-07-06 11:52:33');
INSERT INTO `applicationquestion` VALUES (5,1,'homeState','State/Province','section1',5,'mediumField',b'1','Please enter home state',b'0','2010-06-22 09:34:46','2010-07-06 11:52:34');
INSERT INTO `applicationquestion` VALUES (6,1,'homeZipCode','Zip/Postal Code','section1',6,'smallField',b'1','Please enter home zip/postal code',b'0','2010-06-22 09:35:41','2010-07-06 11:52:34');
INSERT INTO `applicationquestion` VALUES (7,1,'homeCountryID','Country','section1',7,'mediumField',b'1','Please select a home country',b'0','2010-06-22 09:36:47','2010-07-06 11:52:35');
INSERT INTO `applicationquestion` VALUES (8,1,'homeHomePhone','Home Telephone','section1',8,'xxSmallField',b'1','Please enter a home telephone number',b'0','2010-06-22 09:44:10','2010-07-06 11:52:35');
INSERT INTO `applicationquestion` VALUES (9,1,'homeFax','Fax','section1',9,'xxSmallField',b'0','',b'0','2010-06-22 09:59:46','2010-07-06 11:52:36');
INSERT INTO `applicationquestion` VALUES (10,1,'presentSchoolName','School Name','section1',10,'largeField',b'0','',b'0','2010-06-15 10:19:04','2010-07-06 11:52:36');
INSERT INTO `applicationquestion` VALUES (11,1,'presentSchoolAddress','Address','section1',11,'largeField',b'0','',b'0','2010-06-15 10:22:00','2010-07-06 11:52:37');
INSERT INTO `applicationquestion` VALUES (12,1,'presentSchoolCity','City','section1',12,'mediumField',b'0','',b'0','2010-06-15 10:22:51','2010-07-06 11:52:37');
INSERT INTO `applicationquestion` VALUES (13,1,'presentSchoolState','State','section1',13,'mediumField',b'0','',b'0','2010-06-15 10:23:22','2010-07-06 11:52:38');
INSERT INTO `applicationquestion` VALUES (14,1,'presentSchoolZip','Zip Code','section1',14,'smallField',b'0','',b'0','2010-06-15 10:23:38','2010-07-06 11:52:39');
INSERT INTO `applicationquestion` VALUES (15,1,'presentSchoolCountryID','Country','section1',15,'mediumField',b'0','',b'0','2010-06-21 14:53:12','2010-07-06 11:52:39');
INSERT INTO `applicationquestion` VALUES (16,1,'presentSchooldatesOfAttendance','Dates of Attendance','section1',16,'largeField',b'0','',b'0','2010-06-15 10:24:05','2010-07-06 11:52:40');
INSERT INTO `applicationquestion` VALUES (17,1,'presentSchoolType','Type','section1',17,'smallField',b'0','',b'0','2010-06-15 10:25:17','2010-07-06 11:52:40');
INSERT INTO `applicationquestion` VALUES (18,1,'currentGrade','Current Grade','section1',18,'smallField',b'0','',b'0','2010-06-21 17:01:51','2010-07-06 11:52:41');
INSERT INTO `applicationquestion` VALUES (19,1,'applyingGrade','Applying Grade','section1',19,'smallField',b'0','',b'0','2010-06-21 17:04:27','2010-07-06 11:52:42');
INSERT INTO `applicationquestion` VALUES (20,1,'entranceDate','Proposed Entrance Date','section1',20,'smallField datepicker',b'0','',b'0','2010-06-21 17:05:33','2010-07-06 11:52:42');
INSERT INTO `applicationquestion` VALUES (21,1,'applyingAs','Applying As','section1',21,'smalField',b'0','',b'0','2010-06-21 17:23:55','2010-07-06 11:52:43');
INSERT INTO `applicationquestion` VALUES (22,1,'pastSchools','Please list the name(s) and complete address(es) of any other schools the applicant has attended in the past three years','section1',22,'largeTextField',b'0','',b'0','2010-06-21 17:26:26','2010-07-06 11:52:44');
INSERT INTO `applicationquestion` VALUES (23,1,'relationshipApplicant','Relationship to applicant','section2',1,'largeField',b'1','Please enter relationship to applicant',b'0','2010-06-22 09:21:08','2010-07-06 11:52:55');
INSERT INTO `applicationquestion` VALUES (24,1,'parentFirstName','First Name','section2',2,'largeField',b'1','Please enter first name',b'0','2010-06-22 09:21:34','2010-07-06 11:52:52');
INSERT INTO `applicationquestion` VALUES (25,1,'parentMiddleName','Middle Name','section2',3,'largeField',b'0','',b'0','2010-06-22 09:22:46','2010-07-06 11:52:52');
INSERT INTO `applicationquestion` VALUES (26,1,'parentLastName','Last Name','section2',4,'largeField',b'1','Please enter last name',b'0','2010-06-22 09:23:15','2010-07-06 11:52:00');
INSERT INTO `applicationquestion` VALUES (27,1,'parentPreferredName','Preferred Name or nickname','section2',5,'largeField',b'0','',b'0','2010-06-22 09:26:54','2010-07-06 11:51:59');
INSERT INTO `applicationquestion` VALUES (28,1,'parentAddress','Address','section2',6,'largeField',b'1','Please enter home address',b'0','2010-06-22 09:33:48','2010-07-06 11:51:59');
INSERT INTO `applicationquestion` VALUES (29,1,'parentCity','City','section2',7,'mediumField',b'1','Please enter home city',b'0','2010-06-22 09:34:28','2010-07-06 11:51:58');
INSERT INTO `applicationquestion` VALUES (30,1,'parentState','State/Province','section2',8,'mediumField',b'1','Please enter home state',b'0','2010-06-22 09:34:46','2010-07-06 11:51:57');
INSERT INTO `applicationquestion` VALUES (31,1,'parentZipCode','Zip/Postal Code','section2',9,'smallField',b'1','Please enter home zip/postal code',b'0','2010-06-22 09:35:41','2010-07-06 11:51:57');
INSERT INTO `applicationquestion` VALUES (32,1,'parentCountryID','Country','section2',10,'mediumField',b'1','Please select a country',b'0','2010-06-22 09:36:47','2010-07-06 11:51:56');
INSERT INTO `applicationquestion` VALUES (33,1,'parentHomePhone','Home Telephone','section2',11,'xxSmallField',b'1','Please enter a phone number',b'0','2010-06-22 09:44:10','2010-07-06 11:51:56');
INSERT INTO `applicationquestion` VALUES (34,1,'parentFax','Fax','section2',12,'xxSmallField',b'0','',b'0','2010-06-22 09:59:46','2010-07-06 11:51:55');
INSERT INTO `applicationquestion` VALUES (35,1,'parentEmail','Email Address','section2',13,'largeField',b'0','',b'0','2010-06-22 10:00:25','2010-07-06 11:51:54');
INSERT INTO `applicationquestion` VALUES (36,1,'parentCompany','Company','section2',14,'largeField',b'0','',b'0','2010-06-22 10:20:22','2010-07-06 11:51:53');
INSERT INTO `applicationquestion` VALUES (37,1,'parentPosition','Position','section2',15,'largeField',b'0','',b'0','2010-06-22 10:20:40','2010-07-06 11:51:53');
INSERT INTO `applicationquestion` VALUES (38,1,'parentBusinessAddress','Address','section2',16,'largeField',b'0','',b'0','2010-06-22 10:21:42','2010-07-06 11:51:52');
INSERT INTO `applicationquestion` VALUES (39,1,'parentBusinessCity','City','section2',17,'mediumField',b'0','',b'0','2010-06-22 10:36:30','2010-07-06 11:51:52');
INSERT INTO `applicationquestion` VALUES (40,1,'parentBusinessState','State/Province','section2',18,'mediumField',b'0','',b'0','2010-06-22 10:39:51','2010-07-06 11:51:51');
INSERT INTO `applicationquestion` VALUES (41,1,'parentBusinessZip','Zip/Postal Code','section2',19,'smallField',b'0','',b'0','2010-06-22 10:41:11','2010-07-06 11:51:50');
INSERT INTO `applicationquestion` VALUES (42,1,'parentBusinessCountryID','Country','section2',20,'mediumField',b'0','',b'0','2010-06-22 10:44:54','2010-07-06 11:51:50');
INSERT INTO `applicationquestion` VALUES (43,1,'parentBusinessPhone','Telephone','section2',21,'xxSmallField',b'0','',b'0','2010-06-22 10:47:11','2010-07-06 11:51:49');
INSERT INTO `applicationquestion` VALUES (51,1,'guardianRelationshipApplicant','Relationship to applicant','section3',1,'largeField',b'1','Please enter relationship to applicant',b'0','2010-06-22 09:21:08','2010-07-06 15:03:59');
INSERT INTO `applicationquestion` VALUES (52,1,'guardiantFirstName','First Name','section3',2,'largeField',b'1','Please enter first name',b'0','2010-06-22 09:21:34','2010-07-06 15:04:04');
INSERT INTO `applicationquestion` VALUES (53,1,'guardianMiddleName','Middle Name','section3',3,'largeField',b'0','',b'0','2010-06-22 09:22:46','2010-07-06 15:04:09');
INSERT INTO `applicationquestion` VALUES (54,1,'guardianLastName','Last Name','section3',4,'largeField',b'1','Please enter last name',b'0','2010-06-22 09:23:15','2010-07-06 15:04:14');
INSERT INTO `applicationquestion` VALUES (55,1,'guardianPreferredName','Preferred Name or nickname','section3',5,'largeField',b'0','',b'0','2010-06-22 09:26:54','2010-07-06 15:04:19');
INSERT INTO `applicationquestion` VALUES (56,1,'guardianAddress','Address','section3',6,'largeField',b'1','Please enter home address',b'0','2010-06-22 09:33:48','2010-07-06 15:04:36');
INSERT INTO `applicationquestion` VALUES (57,1,'guardianCity','City','section3',7,'mediumField',b'1','Please enter home city',b'0','2010-06-22 09:34:28','2010-07-06 15:04:41');
INSERT INTO `applicationquestion` VALUES (58,1,'guardianState','State/Province','section3',8,'mediumField',b'1','Please enter home state',b'0','2010-06-22 09:34:46','2010-07-06 15:04:46');
INSERT INTO `applicationquestion` VALUES (59,1,'guardianZipCode','Zip/Postal Code','section3',9,'smallField',b'1','Please enter home zip/postal code',b'0','2010-06-22 09:35:41','2010-07-06 15:04:50');
INSERT INTO `applicationquestion` VALUES (60,1,'guardianCountryID','Country','section3',10,'mediumField',b'1','Please select a country',b'0','2010-06-22 09:36:47','2010-07-06 15:04:55');
INSERT INTO `applicationquestion` VALUES (61,1,'guardianHomePhone','Home Telephone','section3',11,'xxSmallField',b'1','Please enter a phone number',b'0','2010-06-22 09:44:10','2010-07-06 15:04:59');
INSERT INTO `applicationquestion` VALUES (62,1,'guardianFax','Fax','section3',12,'xxSmallField',b'0','',b'0','2010-06-22 09:59:46','2010-07-06 15:05:03');
INSERT INTO `applicationquestion` VALUES (63,1,'guardianEmail','Email Address','section3',13,'largeField',b'0','',b'0','2010-06-22 10:00:25','2010-07-06 15:05:09');
INSERT INTO `applicationquestion` VALUES (64,1,'guardianCompany','Company','section3',14,'largeField',b'0','',b'0','2010-06-22 10:20:22','2010-07-06 15:05:18');
INSERT INTO `applicationquestion` VALUES (65,1,'guardianPosition','Position','section3',15,'largeField',b'0','',b'0','2010-06-22 10:20:40','2010-07-06 15:05:30');
INSERT INTO `applicationquestion` VALUES (66,1,'guardianBusinessAddress','Address','section3',16,'largeField',b'0','',b'0','2010-06-22 10:21:42','2010-07-06 15:05:33');
INSERT INTO `applicationquestion` VALUES (67,1,'guardianBusinessCity','City','section3',17,'mediumField',b'0','',b'0','2010-06-22 10:36:30','2010-07-06 15:05:40');
INSERT INTO `applicationquestion` VALUES (68,1,'guardianBusinessState','State/Province','section3',18,'mediumField',b'0','',b'0','2010-06-22 10:39:51','2010-07-06 15:05:50');
INSERT INTO `applicationquestion` VALUES (69,1,'guardianBusinessZip','Zip/Postal Code','section3',19,'smallField',b'0','',b'0','2010-06-22 10:41:11','2010-07-06 15:05:55');
INSERT INTO `applicationquestion` VALUES (70,1,'guardianBusinessCountryID','Country','section3',20,'mediumField',b'0','',b'0','2010-06-22 10:44:54','2010-07-06 15:05:59');
INSERT INTO `applicationquestion` VALUES (71,1,'guardianBusinessPhone','Telephone','section3',21,'xxSmallField',b'0','',b'0','2010-06-22 10:47:11','2010-07-06 15:06:07');
INSERT INTO `applicationquestion` VALUES (72,1,'applicantLives','Applicant Lives With','section4',1,'xxSmallField',b'0','',b'0','2010-06-22 10:50:22','2010-07-06 12:48:36');
INSERT INTO `applicationquestion` VALUES (73,1,'AdmissionMaterial','Admission materials should be sent to','section4',2,'xxSmallField',b'0','',b'0','2010-06-22 11:18:25','2010-07-06 12:48:36');
INSERT INTO `applicationquestion` VALUES (74,1,'ParentInformation','Mark if appropriate','section4',3,'xxSmallField',b'0','',b'0','2010-06-22 11:22:51','2010-07-06 12:48:37');
INSERT INTO `applicationquestion` VALUES (75,1,'parentCustody','If parents are divorced or separated, who has legal custody of the applicant?','section4',4,'largeField',b'0','',b'0','2010-06-22 11:44:12','2010-07-06 12:48:38');
INSERT INTO `applicationquestion` VALUES (76,1,'financialAid','Are you applying for financial aid?','section4',5,'xxSmallField',b'0','',b'0','2010-06-22 11:56:15','2010-07-06 12:48:39');
INSERT INTO `applicationquestion` VALUES (77,1,'studentEssay','If you had a day to spend as you wish, how would you use your time?','section5',1,'xlTextField',b'1','Please enter an essay',b'0','2010-06-22 12:07:04','2010-07-06 12:48:39');
INSERT INTO `applicationquestion` VALUES (78,1,'studentEssayAttest','I attest that this essay is my own work and that I did not receive assistance in creating it.','section5',2,'xxSmallField',b'1','Please attest that this essay is your own work',b'0','2010-06-22 12:24:40','2010-07-06 12:48:40');
/*!40000 ALTER TABLE `applicationquestion` ENABLE KEYS */;
UNLOCK TABLES;

#
# Source for table content
#

DROP TABLE IF EXISTS `content`;
CREATE TABLE `content` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `contentKey` varchar(100) NOT NULL DEFAULT '',
  `name` varchar(100) NOT NULL DEFAULT '',
  `content` text NOT NULL,
  `dateCreated` timestamp NULL DEFAULT NULL,
  `dateUpdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

#
# Dumping data for table content
#

LOCK TABLES `content` WRITE;
/*!40000 ALTER TABLE `content` DISABLE KEYS */;
INSERT INTO `content` VALUES (1,'applicationParentAgreement','Parent Agreement','By signing this form, I give my consent to GPA to release my child\'s name and photograph to the media for athletic and academic achievements and to have his/her photograph published in GPA publications, including the Web site. The Academy may contact any person listed on this application for additional information relative to my child\'s candidacy. I understand that information which is incomplete, withheld, or incorrect may disqualify the student from admission or may later be the basis for his/her withdrawal or dismissal from Granby Preparatory Academy. \r\n\r\nPlease sign this form and return it with your $75 application fee ($150 for international students) to: Office of Admission, Granby Preparatory Academy, 66 School Street, Granby, MA 01033\r\n','2010-07-07 15:01:04','2010-07-07 18:03:41');
INSERT INTO `content` VALUES (2,'applicationGetHelp','Get Help - Application Page','',NULL,'2010-07-07 18:03:31');
/*!40000 ALTER TABLE `content` ENABLE KEYS */;
UNLOCK TABLES;

#
# Source for table country
#

DROP TABLE IF EXISTS `country`;
CREATE TABLE `country` (
  `Id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `code` varchar(5) NOT NULL DEFAULT '',
  `sevisCode` varchar(5) NOT NULL DEFAULT '',
  `dateCreated` timestamp NULL DEFAULT NULL,
  `dateUpdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=225 DEFAULT CHARSET=utf8 COMMENT='List of Countries';

#
# Dumping data for table country
#

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES (1,'Afghanistan','AF','AF','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (2,'Albania','AL','AL','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (3,'Algeria','DZ','AG','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (4,'American Samoa','AS','AQ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (5,'Andorra','AD','AN','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (6,'Angola','AO','AO','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (7,'Anguilla','AI','AV','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (8,'Antigua & Barbuda','AG','AC','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (9,'Argentina','AR','AR','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (10,'Armenia','AM','AM','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (11,'Aruba','AW','AA','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (12,'Australia','AU','AS','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (13,'Austria','AT','AU','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (14,'Azerbaijan','AZ','AJ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (15,'Bahamas','BS','BF','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (16,'Bahrain','BH','BA','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (17,'Bangladesh','BD','BG','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (18,'Barbados','BB','BB','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (19,'Belarus','BY','BO','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (20,'Belgium','BE','BE','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (21,'Belize','BZ','BH','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (22,'Benin','BJ','BN','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (23,'Bermuda','BM','BD','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (24,'Bhutan','BT','BT','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (25,'Bolivia','BO','BL','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (26,'Bosnia & Herzegovina','BX','BK','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (27,'Botswana','BW','BC','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (28,'Brazil','BR','BR','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (29,'British Indian Ocean Territory','IO','IO','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (30,'Brunei','BN','BX','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (31,'Bulgaria','BG','BU','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (32,'Burkina Faso','BF','UV','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (33,'Burundi','BI','BY','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (34,'Cambodia','KH','CB','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (35,'Cameroon','CM','CM','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (36,'Canada','CA','CA','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (37,'Cape Verde','CV','CV','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (38,'Cayman Islands','KY','CJ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (39,'Central African Republic','CF','CT','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (40,'Chad','TD','CD','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (41,'Chile','CL','CI','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (42,'China','CN','CH','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (43,'Christmas Island','CX','KT','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (44,'Cocos Island','CC','CK','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (45,'Colombia','CO','CO','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (46,'Comoros','KM','CN','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (47,'Congo','CG','CF','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (48,'Cook Islands','CK','CW','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (49,'Costa Rica','CR','CS','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (50,'Cote D\'Ivore','ZZ','IV','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (51,'Croatia','HR','HR','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (52,'Cuba','CU','CU','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (53,'Czech Republic','CZ','EZ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (54,'Denmark','DK','DA','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (55,'Djibouti','DJ','DJ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (56,'Dominica','DM','DO','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (57,'Dominican Republic','DO','DR','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (58,'East Timor','TP','TT','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (59,'Ecuador','EC','EC','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (60,'Egypt','EG','EG','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (61,'El Salvador','SV','ES','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (62,'Equatorial Guinea','GQ','EK','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (63,'Eritrea','ER','ER','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (64,'Estonia','EE','EN','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (65,'Ethiopia','ET','ET','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (66,'Falkland Islands','FK','FK','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (67,'Faroe Islands','FO','FO','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (68,'Fiji','FJ','FJ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (69,'Finland','FI','FI','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (70,'France','FR','FR','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (71,'French Guiana','GF','FG','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (72,'French Polynesia','PF','FP','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (73,'French Southern Territories','TF','FS','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (74,'Gabon','GA','GB','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (75,'Gambia','GM','GA','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (76,'Gaza','','','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (77,'Georgia','GE','GG','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (78,'Germany','DE','GM','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (79,'Ghana','GH','GH','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (80,'Gibraltar','GI','GI','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (81,'Greece','GR','GR','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (82,'Greenland','GL','GL','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (83,'Grenada','GD','GJ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (84,'Guadeloupe','GP','GP','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (85,'Guam','GU','GQ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (86,'Guatemala','GT','GT','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (87,'Guinea','GN','GV','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (88,'Guyana','GY','GY','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (89,'Haiti','HT','HA','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (90,'Honduras','HN','HO','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (91,'Hong Kong','HK','HK','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (92,'Hungary','HU','HU','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (93,'Iceland','IS','IC','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (94,'India','IN','IN','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (95,'Indonesia','ID','ID','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (96,'Iran','IR','IR','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (97,'Iraq','IQ','IZ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (98,'Ireland','IE','EI','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (99,'Israel','IL','IS','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (100,'Italy','IT','IT','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (101,'Jamaica','JM','JM','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (102,'Japan','JP','JA','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (103,'Jordan','JO','JO','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (104,'Kazakhstan','KZ','KZ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (105,'Kenya','KE','KE','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (106,'Kiribati','KI','KR','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (107,'Korea North','KP','KN','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (108,'Korea South','KR','KS','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (109,'Kuwait','KW','KU','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (110,'Kyrgyzstan','KG','KG','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (111,'Laos','LA','LA','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (112,'Latvia','LV','LG','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (113,'Lebanon','LB','LE','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (114,'Lesotho','LS','LT','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (115,'Liberia','LR','LI','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (116,'Libya','LY','LY','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (117,'Liechtenstein','LI','LS','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (118,'Lithuania','LT','LH','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (119,'Luxembourg','LU','LU','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (120,'Macau','MO','MC','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (121,'Macedonia','MK','MK','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (122,'Madagascar','MG','MA','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (123,'Malawi','MW','MI','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (124,'Malaysia','MY','MY','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (125,'Maldives','MV','MV','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (126,'Mali','ML','ML','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (127,'Malta','MT','MT','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (128,'Marshall Islands','MH','RM','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (129,'Martinique','MQ','MB','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (130,'Mauritania','MR','MR','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (131,'Mauritius','MU','MP','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (132,'Mayotte','YT','MF','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (133,'Mexico','MX','MX','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (134,'Moldova','MD','MD','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (135,'Monaco','MC','MN','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (136,'Mongolia','MN','MG','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (137,'Montenegro','YU','MJ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (138,'Montserrat','MS','MH','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (139,'Morocco','MB','MO','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (140,'Mozambique','MZ','MZ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (141,'Nambia','NA','WA','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (142,'Nauru','NR','NR','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (143,'Nepal','NP','NP','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (144,'Netherland Antilles','AN','NT','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (145,'Netherlands','NL','NL','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (146,'New Caledonia','NC','NC','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (147,'New Zealand','NZ','NZ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (148,'Nicaragua','NI','NU','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (149,'Niger','NE','NG','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (150,'Nigeria','NG','NI','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (151,'Niue','NU','NE','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (152,'Norfolk Island','NF','NF','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (153,'Norway','NO','NO','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (154,'Oman','OM','MU','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (155,'Pakistan','PK','PK','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (156,'Palau Island','PW','PS','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (157,'Panama','PA','PM','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (158,'Papua New Guinea','PG','PP','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (159,'Paraguay','PY','PA','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (160,'Peru','PE','PE','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (161,'Philippines','PH','RP','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (162,'Pitcairn Island','PN','PC','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (163,'Poland','PL','PL','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (164,'Portugal','PT','PO','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (165,'Puerto Rico','PR','RQ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (166,'Qatar','QA','QA','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (167,'Republic of Kosovo','KV','KV','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (168,'Republic of San Marino','SM','SM','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (169,'Reunion','RE','RE','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (170,'Romania','RO','RO','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (171,'Russia','RU','RS','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (172,'Rwanda','RW','RW','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (173,'Samoa','WS','WS','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (174,'Sao Tome & Principe','ST','TP','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (175,'Saudi Arabia','SX','SA','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (176,'Senegal','SN','SG','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (177,'Serbia','SF','RI','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (178,'Serbia and Montenegro','CS','YI','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (179,'Seychelles','SC','SE','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (180,'Sierra Leone','SL','SL','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (181,'Singapore','SG','SN','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (182,'Slovakia','SK','LO','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (183,'Slovenia','SI','SI','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (184,'Solomon Islands','SB','BP','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (185,'Somalia','SO','SO','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (186,'South Africa','ZA','SF','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (187,'Spain','ES','SP','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (188,'Sri Lanka','LK','CE','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (189,'Stateless','U3','U3','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (190,'Suriname','SR','NS','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (191,'Sweden','SE','SW','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (192,'Switzerland','CH','SZ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (193,'Syria','SY','SY','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (194,'Taiwan','TW','TW','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (195,'Tajikistan','TJ','TI','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (196,'Tanzania','TZ','TZ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (197,'Thailand','TH','TH','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (198,'Togo','TG','TO','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (199,'Tokelau','TK','TL','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (200,'Tonga','TO','TN','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (201,'Trinidad & Tobago','TT','TD','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (202,'Tunisia','TN','TS','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (203,'Turkey','TR','TU','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (204,'Turkmenistan','TM','TX','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (205,'Turks & Caicos Is','TC','TK','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (206,'Tuvalu','TV','TV','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (207,'Uganda','UG','UG','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (208,'Ukraine','UA','UP','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (209,'United Arab Erimates','AE','TC','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (210,'United Kingdom','GB','UK','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (211,'United States of America','US','US','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (212,'Uruguay','UY','UY','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (213,'Uzbekistan','UZ','UZ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (214,'Vanuatu','VU','NH','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (215,'Vatican City State','VA','VT','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (216,'Venezuela','VE','VE','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (217,'Vietnam','VN','VM','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (218,'Virgin Islands (USA)','VG','VQ','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (219,'Wallis & Futana Is','WF','WF','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (220,'West Bank','','','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (221,'Yemen','YE','YM','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (222,'Yugoslavia','YU','YI','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (223,'Zambia','ZM','ZA','2010-06-18 14:39:19','2010-06-18 14:40:44');
INSERT INTO `country` VALUES (224,'Zimbabwe','ZW','ZI','2010-06-18 14:39:19','2010-06-18 14:40:44');
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

#
# Source for table document
#

DROP TABLE IF EXISTS `document`;
CREATE TABLE `document` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `foreignTable` varchar(255) DEFAULT NULL,
  `foreignID` int(11) NOT NULL DEFAULT '0',
  `documentTypeID` smallint(6) NOT NULL DEFAULT '0',
  `serverName` varchar(255) NOT NULL DEFAULT '',
  `serverExt` varchar(10) NOT NULL DEFAULT '',
  `clientName` varchar(255) NOT NULL DEFAULT '',
  `clientExt` varchar(10) NOT NULL DEFAULT '',
  `fileSize` varchar(50) NOT NULL DEFAULT '',
  `location` varchar(255) NOT NULL DEFAULT '',
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `dateCreated` timestamp NULL DEFAULT NULL,
  `dateUpdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='List of uploaded documents';

#
# Dumping data for table document
#

LOCK TABLES `document` WRITE;
/*!40000 ALTER TABLE `document` DISABLE KEYS */;
INSERT INTO `document` VALUES (1,'student',1,4,'DreamHost Web Panel _ Billi..','pdf','DreamHost Web Panel _ Billi..','pdf','71 Kb','C:/websites/www/granbyprep/upload/documents/student/1',b'0','2010-07-02 19:25:45','2010-07-02 19:26:05');
INSERT INTO `document` VALUES (2,'student',1,3,'Gamestop.com - Order Histor..','pdf','Gamestop.com - Order Histor..','pdf','107 Kb','C:/websites/www/granbyprep/upload/documents/student/1',b'0','2010-07-02 19:25:45','2010-07-05 18:35:32');
INSERT INTO `document` VALUES (3,'student',1,0,'GameStop','pdf','GameStop','pdf','16 Kb','C:/websites/www/granbyprep/upload/documents/student/1',b'1','2010-07-02 19:25:45','2010-07-07 12:24:50');
INSERT INTO `document` VALUES (4,'student',1,1,'Itinerary496653875','pdf','Itinerary496653875','pdf','81 Kb','C:/websites/www/granbyprep/upload/documents/student/1',b'0','2010-07-02 19:25:46','2010-07-02 19:25:53');
INSERT INTO `document` VALUES (5,'student',1,3,'Marcus','jpg','Marcus','jpg','969 Kb','C:/websites/www/granbyprep/upload/documents/student/1',b'0','2010-07-02 19:25:46','2010-07-02 19:25:57');
/*!40000 ALTER TABLE `document` ENABLE KEYS */;
UNLOCK TABLES;

#
# Source for table documenttype
#

DROP TABLE IF EXISTS `documenttype`;
CREATE TABLE `documenttype` (
  `Id` smallint(6) NOT NULL AUTO_INCREMENT,
  `applicationID` smallint(6) NOT NULL DEFAULT '0',
  `name` varchar(100) NOT NULL DEFAULT '',
  `dateCreated` timestamp NULL DEFAULT NULL,
  `dateUpdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

#
# Dumping data for table documenttype
#

LOCK TABLES `documenttype` WRITE;
/*!40000 ALTER TABLE `documenttype` DISABLE KEYS */;
INSERT INTO `documenttype` VALUES (1,1,'Mathematics Teacher Recommendation','2010-07-02 13:54:08','2010-07-02 13:56:37');
INSERT INTO `documenttype` VALUES (2,1,'English Teacher Recommendation','2010-07-02 13:54:19','2010-07-02 13:56:37');
INSERT INTO `documenttype` VALUES (3,1,'Transcript for at least the last two years','2010-07-02 13:54:20','2010-07-02 13:56:37');
INSERT INTO `documenttype` VALUES (4,1,'Standardized test scores','2010-07-02 13:54:25','2010-07-02 13:56:38');
INSERT INTO `documenttype` VALUES (5,1,'Other','2010-07-02 13:54:27','2010-07-02 13:56:38');
/*!40000 ALTER TABLE `documenttype` ENABLE KEYS */;
UNLOCK TABLES;

#
# Source for table faq
#

DROP TABLE IF EXISTS `faq`;
CREATE TABLE `faq` (
  `Id` smallint(6) NOT NULL AUTO_INCREMENT,
  `question` varchar(255) NOT NULL DEFAULT '',
  `answer` varchar(255) NOT NULL DEFAULT '',
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `dateCreated` timestamp NULL DEFAULT NULL,
  `dateUpdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Frequently Asked Questions';

#
# Dumping data for table faq
#

LOCK TABLES `faq` WRITE;
/*!40000 ALTER TABLE `faq` DISABLE KEYS */;
INSERT INTO `faq` VALUES (1,'How can I change my email address?','Please click on \"update login\" on your top-right corner to change your email and password.',b'0','2010-06-25 13:08:50','2010-06-25 13:08:55');
INSERT INTO `faq` VALUES (2,'What are the payments methods accepted?','Visa, MasterCard and Amex credit cards.',b'0','2010-06-25 13:09:36','2010-06-25 13:09:40');
/*!40000 ALTER TABLE `faq` ENABLE KEYS */;
UNLOCK TABLES;

#
# Source for table metadata
#

DROP TABLE IF EXISTS `metadata`;
CREATE TABLE `metadata` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `pageName` varchar(100) NOT NULL DEFAULT '',
  `title` varchar(100) NOT NULL DEFAULT '',
  `keyword` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(100) NOT NULL DEFAULT '',
  `dateCreated` timestamp NULL DEFAULT NULL,
  `dateUpdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores page metadata information';

#
# Dumping data for table metadata
#

LOCK TABLES `metadata` WRITE;
/*!40000 ALTER TABLE `metadata` DISABLE KEYS */;
/*!40000 ALTER TABLE `metadata` ENABLE KEYS */;
UNLOCK TABLES;

#
# Source for table semester
#

DROP TABLE IF EXISTS `semester`;
CREATE TABLE `semester` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `startDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  `isActive` bit(1) NOT NULL DEFAULT b'1',
  `dateCreated` timestamp NULL DEFAULT NULL,
  `dateUpdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

#
# Dumping data for table semester
#

LOCK TABLES `semester` WRITE;
/*!40000 ALTER TABLE `semester` DISABLE KEYS */;
INSERT INTO `semester` VALUES (1,'Fall 2011',NULL,NULL,b'1','2010-07-06 11:28:17','2010-07-06 11:28:20');
/*!40000 ALTER TABLE `semester` ENABLE KEYS */;
UNLOCK TABLES;

#
# Source for table sessioninformation
#

DROP TABLE IF EXISTS `sessioninformation`;
CREATE TABLE `sessioninformation` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `httpReferer` varchar(500) NOT NULL DEFAULT '',
  `entryPage` varchar(500) NOT NULL DEFAULT '',
  `httpUserAgent` varchar(500) NOT NULL DEFAULT '',
  `queryString` varchar(500) NOT NULL DEFAULT '',
  `remoteAddr` varchar(255) NOT NULL DEFAULT '',
  `remoteHost` varchar(255) NOT NULL DEFAULT '',
  `httpHost` varchar(255) NOT NULL DEFAULT '',
  `https` varchar(255) NOT NULL DEFAULT '',
  `dateCreated` timestamp NULL DEFAULT NULL,
  `dateUpdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=386 DEFAULT CHARSET=utf8;

#
# Dumping data for table sessioninformation
#

LOCK TABLES `sessioninformation` WRITE;
/*!40000 ALTER TABLE `sessioninformation` DISABLE KEYS */;
INSERT INTO `sessioninformation` VALUES (1,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:18:42','2010-07-08 10:18:42');
INSERT INTO `sessioninformation` VALUES (2,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:21:22','2010-07-08 10:21:22');
INSERT INTO `sessioninformation` VALUES (3,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:21:48','2010-07-08 10:21:48');
INSERT INTO `sessioninformation` VALUES (4,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:22:10','2010-07-08 10:22:10');
INSERT INTO `sessioninformation` VALUES (5,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:22:36','2010-07-08 10:22:36');
INSERT INTO `sessioninformation` VALUES (6,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:23:11','2010-07-08 10:23:11');
INSERT INTO `sessioninformation` VALUES (7,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:23:24','2010-07-08 10:23:24');
INSERT INTO `sessioninformation` VALUES (8,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:23:54','2010-07-08 10:23:54');
INSERT INTO `sessioninformation` VALUES (9,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:24:08','2010-07-08 10:24:08');
INSERT INTO `sessioninformation` VALUES (10,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:24:36','2010-07-08 10:24:36');
INSERT INTO `sessioninformation` VALUES (11,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:28:11','2010-07-08 10:28:11');
INSERT INTO `sessioninformation` VALUES (12,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:28:11','2010-07-08 10:28:11');
INSERT INTO `sessioninformation` VALUES (13,'http://granbyprep.local/admissions/?init=1','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:28:18','2010-07-08 10:28:18');
INSERT INTO `sessioninformation` VALUES (14,'http://granbyprep.local/admissions/?init=1','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:28:18','2010-07-08 10:28:18');
INSERT INTO `sessioninformation` VALUES (15,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:28:20','2010-07-08 10:28:20');
INSERT INTO `sessioninformation` VALUES (16,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=submit','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:28:22','2010-07-08 10:28:22');
INSERT INTO `sessioninformation` VALUES (17,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:28:25','2010-07-08 10:28:25');
INSERT INTO `sessioninformation` VALUES (18,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:30:34','2010-07-08 10:30:34');
INSERT INTO `sessioninformation` VALUES (19,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:30:55','2010-07-08 10:30:55');
INSERT INTO `sessioninformation` VALUES (20,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:30:56','2010-07-08 10:30:56');
INSERT INTO `sessioninformation` VALUES (21,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:31:05','2010-07-08 10:31:05');
INSERT INTO `sessioninformation` VALUES (22,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:31:14','2010-07-08 10:31:14');
INSERT INTO `sessioninformation` VALUES (23,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:31:36','2010-07-08 10:31:36');
INSERT INTO `sessioninformation` VALUES (24,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:31:45','2010-07-08 10:31:45');
INSERT INTO `sessioninformation` VALUES (25,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:31:54','2010-07-08 10:31:54');
INSERT INTO `sessioninformation` VALUES (26,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:31:59','2010-07-08 10:31:59');
INSERT INTO `sessioninformation` VALUES (27,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:32:15','2010-07-08 10:32:15');
INSERT INTO `sessioninformation` VALUES (28,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:32:28','2010-07-08 10:32:28');
INSERT INTO `sessioninformation` VALUES (29,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:32:33','2010-07-08 10:32:33');
INSERT INTO `sessioninformation` VALUES (30,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:32:39','2010-07-08 10:32:39');
INSERT INTO `sessioninformation` VALUES (31,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:33:03','2010-07-08 10:33:03');
INSERT INTO `sessioninformation` VALUES (32,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:33:04','2010-07-08 10:33:04');
INSERT INTO `sessioninformation` VALUES (33,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:33:09','2010-07-08 10:33:09');
INSERT INTO `sessioninformation` VALUES (34,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:33:41','2010-07-08 10:33:41');
INSERT INTO `sessioninformation` VALUES (35,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:34:47','2010-07-08 10:34:47');
INSERT INTO `sessioninformation` VALUES (36,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:35:00','2010-07-08 10:35:00');
INSERT INTO `sessioninformation` VALUES (37,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:35:13','2010-07-08 10:35:13');
INSERT INTO `sessioninformation` VALUES (38,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:35:22','2010-07-08 10:35:22');
INSERT INTO `sessioninformation` VALUES (39,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:35:29','2010-07-08 10:35:29');
INSERT INTO `sessioninformation` VALUES (40,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:35:36','2010-07-08 10:35:36');
INSERT INTO `sessioninformation` VALUES (41,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:36:02','2010-07-08 10:36:02');
INSERT INTO `sessioninformation` VALUES (42,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:36:03','2010-07-08 10:36:03');
INSERT INTO `sessioninformation` VALUES (43,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:36:07','2010-07-08 10:36:07');
INSERT INTO `sessioninformation` VALUES (44,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:36:11','2010-07-08 10:36:11');
INSERT INTO `sessioninformation` VALUES (45,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:36:15','2010-07-08 10:36:15');
INSERT INTO `sessioninformation` VALUES (46,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:36:43','2010-07-08 10:36:43');
INSERT INTO `sessioninformation` VALUES (47,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:37:00','2010-07-08 10:37:00');
INSERT INTO `sessioninformation` VALUES (48,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:37:14','2010-07-08 10:37:14');
INSERT INTO `sessioninformation` VALUES (49,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:37:26','2010-07-08 10:37:26');
INSERT INTO `sessioninformation` VALUES (50,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:37:28','2010-07-08 10:37:28');
INSERT INTO `sessioninformation` VALUES (51,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:37:30','2010-07-08 10:37:30');
INSERT INTO `sessioninformation` VALUES (52,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:38:42','2010-07-08 10:38:42');
INSERT INTO `sessioninformation` VALUES (53,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:38:44','2010-07-08 10:38:44');
INSERT INTO `sessioninformation` VALUES (54,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:39:23','2010-07-08 10:39:23');
INSERT INTO `sessioninformation` VALUES (55,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:40:21','2010-07-08 10:40:21');
INSERT INTO `sessioninformation` VALUES (56,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:40:38','2010-07-08 10:40:38');
INSERT INTO `sessioninformation` VALUES (57,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:40:45','2010-07-08 10:40:45');
INSERT INTO `sessioninformation` VALUES (58,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:40:51','2010-07-08 10:40:51');
INSERT INTO `sessioninformation` VALUES (59,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:41:02','2010-07-08 10:41:02');
INSERT INTO `sessioninformation` VALUES (60,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:41:15','2010-07-08 10:41:15');
INSERT INTO `sessioninformation` VALUES (61,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:42:10','2010-07-08 10:42:10');
INSERT INTO `sessioninformation` VALUES (62,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:42:21','2010-07-08 10:42:21');
INSERT INTO `sessioninformation` VALUES (63,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:43:40','2010-07-08 10:43:40');
INSERT INTO `sessioninformation` VALUES (64,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:44:06','2010-07-08 10:44:06');
INSERT INTO `sessioninformation` VALUES (65,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:44:23','2010-07-08 10:44:23');
INSERT INTO `sessioninformation` VALUES (66,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:45:16','2010-07-08 10:45:16');
INSERT INTO `sessioninformation` VALUES (67,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:46:16','2010-07-08 10:46:16');
INSERT INTO `sessioninformation` VALUES (68,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:47:36','2010-07-08 10:47:36');
INSERT INTO `sessioninformation` VALUES (69,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:48:13','2010-07-08 10:48:13');
INSERT INTO `sessioninformation` VALUES (70,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:48:18','2010-07-08 10:48:18');
INSERT INTO `sessioninformation` VALUES (71,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:48:59','2010-07-08 10:48:59');
INSERT INTO `sessioninformation` VALUES (72,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:50:13','2010-07-08 10:50:13');
INSERT INTO `sessioninformation` VALUES (73,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:50:22','2010-07-08 10:50:22');
INSERT INTO `sessioninformation` VALUES (74,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:50:31','2010-07-08 10:50:31');
INSERT INTO `sessioninformation` VALUES (75,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:50:38','2010-07-08 10:50:38');
INSERT INTO `sessioninformation` VALUES (76,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:52:08','2010-07-08 10:52:08');
INSERT INTO `sessioninformation` VALUES (77,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:52:40','2010-07-08 10:52:40');
INSERT INTO `sessioninformation` VALUES (78,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 10:56:47','2010-07-08 10:56:47');
INSERT INTO `sessioninformation` VALUES (79,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:00:35','2010-07-08 11:00:35');
INSERT INTO `sessioninformation` VALUES (80,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:00:35','2010-07-08 11:00:35');
INSERT INTO `sessioninformation` VALUES (81,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:00:44','2010-07-08 11:00:44');
INSERT INTO `sessioninformation` VALUES (82,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:00:44','2010-07-08 11:00:44');
INSERT INTO `sessioninformation` VALUES (83,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee&init=1&initsession=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:01:03','2010-07-08 11:01:03');
INSERT INTO `sessioninformation` VALUES (84,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee&init=1&initsession=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:01:03','2010-07-08 11:01:03');
INSERT INTO `sessioninformation` VALUES (85,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee&init=1&initsession=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:01:04','2010-07-08 11:01:04');
INSERT INTO `sessioninformation` VALUES (86,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:02:23','2010-07-08 11:02:23');
INSERT INTO `sessioninformation` VALUES (87,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:02:23','2010-07-08 11:02:23');
INSERT INTO `sessioninformation` VALUES (88,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:02:24','2010-07-08 11:02:24');
INSERT INTO `sessioninformation` VALUES (89,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:02:24','2010-07-08 11:02:24');
INSERT INTO `sessioninformation` VALUES (90,'http://granbyprep.local/admissions/?init=1','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:02:28','2010-07-08 11:02:28');
INSERT INTO `sessioninformation` VALUES (91,'http://granbyprep.local/admissions/?init=1','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:02:28','2010-07-08 11:02:28');
INSERT INTO `sessioninformation` VALUES (92,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:02:30','2010-07-08 11:02:30');
INSERT INTO `sessioninformation` VALUES (93,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:02:32','2010-07-08 11:02:32');
INSERT INTO `sessioninformation` VALUES (94,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:07:58','2010-07-08 11:07:58');
INSERT INTO `sessioninformation` VALUES (95,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:08:22','2010-07-08 11:08:22');
INSERT INTO `sessioninformation` VALUES (96,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:08:50','2010-07-08 11:08:50');
INSERT INTO `sessioninformation` VALUES (97,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:09:59','2010-07-08 11:09:59');
INSERT INTO `sessioninformation` VALUES (98,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:10:13','2010-07-08 11:10:13');
INSERT INTO `sessioninformation` VALUES (99,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:10:25','2010-07-08 11:10:25');
INSERT INTO `sessioninformation` VALUES (100,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:10:42','2010-07-08 11:10:42');
INSERT INTO `sessioninformation` VALUES (101,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:10:51','2010-07-08 11:10:51');
INSERT INTO `sessioninformation` VALUES (102,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:10:54','2010-07-08 11:10:54');
INSERT INTO `sessioninformation` VALUES (103,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:11:12','2010-07-08 11:11:12');
INSERT INTO `sessioninformation` VALUES (104,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:11:24','2010-07-08 11:11:24');
INSERT INTO `sessioninformation` VALUES (105,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:15:54','2010-07-08 11:15:54');
INSERT INTO `sessioninformation` VALUES (106,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:16:41','2010-07-08 11:16:40');
INSERT INTO `sessioninformation` VALUES (107,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:29:13','2010-07-08 11:29:13');
INSERT INTO `sessioninformation` VALUES (108,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:29:37','2010-07-08 11:29:37');
INSERT INTO `sessioninformation` VALUES (109,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:29:38','2010-07-08 11:29:38');
INSERT INTO `sessioninformation` VALUES (110,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:30:49','2010-07-08 11:30:49');
INSERT INTO `sessioninformation` VALUES (111,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:31:02','2010-07-08 11:31:02');
INSERT INTO `sessioninformation` VALUES (112,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:50:42','2010-07-08 11:50:42');
INSERT INTO `sessioninformation` VALUES (113,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:50:59','2010-07-08 11:50:59');
INSERT INTO `sessioninformation` VALUES (114,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:51:03','2010-07-08 11:51:02');
INSERT INTO `sessioninformation` VALUES (115,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:51:06','2010-07-08 11:51:06');
INSERT INTO `sessioninformation` VALUES (116,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:53:20','2010-07-08 11:53:20');
INSERT INTO `sessioninformation` VALUES (117,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:57:08','2010-07-08 11:57:08');
INSERT INTO `sessioninformation` VALUES (118,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:58:25','2010-07-08 11:58:25');
INSERT INTO `sessioninformation` VALUES (119,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:59:02','2010-07-08 11:59:02');
INSERT INTO `sessioninformation` VALUES (120,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:59:17','2010-07-08 11:59:17');
INSERT INTO `sessioninformation` VALUES (121,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:59:21','2010-07-08 11:59:21');
INSERT INTO `sessioninformation` VALUES (122,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:59:23','2010-07-08 11:59:23');
INSERT INTO `sessioninformation` VALUES (123,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:59:24','2010-07-08 11:59:24');
INSERT INTO `sessioninformation` VALUES (124,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:59:26','2010-07-08 11:59:26');
INSERT INTO `sessioninformation` VALUES (125,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:59:40','2010-07-08 11:59:40');
INSERT INTO `sessioninformation` VALUES (126,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 11:59:44','2010-07-08 11:59:44');
INSERT INTO `sessioninformation` VALUES (127,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:00:43','2010-07-08 12:00:43');
INSERT INTO `sessioninformation` VALUES (128,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:00:47','2010-07-08 12:00:47');
INSERT INTO `sessioninformation` VALUES (129,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:00:51','2010-07-08 12:00:51');
INSERT INTO `sessioninformation` VALUES (130,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:01:42','2010-07-08 12:01:42');
INSERT INTO `sessioninformation` VALUES (131,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:01:45','2010-07-08 12:01:45');
INSERT INTO `sessioninformation` VALUES (132,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:01:47','2010-07-08 12:01:47');
INSERT INTO `sessioninformation` VALUES (133,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:01:49','2010-07-08 12:01:49');
INSERT INTO `sessioninformation` VALUES (134,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:01:51','2010-07-08 12:01:51');
INSERT INTO `sessioninformation` VALUES (135,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:02:05','2010-07-08 12:02:05');
INSERT INTO `sessioninformation` VALUES (136,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:02:13','2010-07-08 12:02:13');
INSERT INTO `sessioninformation` VALUES (137,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial&currentTabID=5','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:51:03','2010-07-08 12:51:03');
INSERT INTO `sessioninformation` VALUES (138,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=5','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:51:04','2010-07-08 12:51:05');
INSERT INTO `sessioninformation` VALUES (139,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial&currentTabID=5','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:51:33','2010-07-08 12:51:33');
INSERT INTO `sessioninformation` VALUES (140,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=5','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:51:35','2010-07-08 12:51:35');
INSERT INTO `sessioninformation` VALUES (141,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial&currentTabID=5','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:56:16','2010-07-08 12:56:16');
INSERT INTO `sessioninformation` VALUES (142,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=5','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:56:18','2010-07-08 12:56:18');
INSERT INTO `sessioninformation` VALUES (143,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=5','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:56:19','2010-07-08 12:56:19');
INSERT INTO `sessioninformation` VALUES (144,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=5','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:56:58','2010-07-08 12:56:58');
INSERT INTO `sessioninformation` VALUES (145,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=5','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:57:01','2010-07-08 12:57:01');
INSERT INTO `sessioninformation` VALUES (146,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=5','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:57:07','2010-07-08 12:57:07');
INSERT INTO `sessioninformation` VALUES (147,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=faq','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:57:15','2010-07-08 12:57:15');
INSERT INTO `sessioninformation` VALUES (148,'http://granbyprep.local/admissions/index.cfm?action=faq','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:57:18','2010-07-08 12:57:18');
INSERT INTO `sessioninformation` VALUES (149,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:57:23','2010-07-08 12:57:23');
INSERT INTO `sessioninformation` VALUES (150,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:57:39','2010-07-08 12:57:39');
INSERT INTO `sessioninformation` VALUES (151,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=help','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:58:41','2010-07-08 12:58:41');
INSERT INTO `sessioninformation` VALUES (152,'http://granbyprep.local/admissions/index.cfm?action=help','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=faq','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:58:44','2010-07-08 12:58:44');
INSERT INTO `sessioninformation` VALUES (153,'http://granbyprep.local/admissions/index.cfm?action=faq','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:58:52','2010-07-08 12:58:52');
INSERT INTO `sessioninformation` VALUES (154,'http://granbyprep.local/admissions/index.cfm?action=faq','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:59:01','2010-07-08 12:59:01');
INSERT INTO `sessioninformation` VALUES (155,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:59:05','2010-07-08 12:59:05');
INSERT INTO `sessioninformation` VALUES (156,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:59:10','2010-07-08 12:59:10');
INSERT INTO `sessioninformation` VALUES (157,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:59:12','2010-07-08 12:59:12');
INSERT INTO `sessioninformation` VALUES (158,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:59:52','2010-07-08 12:59:52');
INSERT INTO `sessioninformation` VALUES (159,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 12:59:53','2010-07-08 12:59:53');
INSERT INTO `sessioninformation` VALUES (160,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:00:33','2010-07-08 13:00:33');
INSERT INTO `sessioninformation` VALUES (161,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:00:35','2010-07-08 13:00:35');
INSERT INTO `sessioninformation` VALUES (162,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:00:37','2010-07-08 13:00:37');
INSERT INTO `sessioninformation` VALUES (163,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:00:39','2010-07-08 13:00:39');
INSERT INTO `sessioninformation` VALUES (164,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:00:46','2010-07-08 13:00:46');
INSERT INTO `sessioninformation` VALUES (165,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:01:42','2010-07-08 13:01:42');
INSERT INTO `sessioninformation` VALUES (166,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:01:43','2010-07-08 13:01:43');
INSERT INTO `sessioninformation` VALUES (167,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:02:31','2010-07-08 13:02:31');
INSERT INTO `sessioninformation` VALUES (168,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:02:33','2010-07-08 13:02:33');
INSERT INTO `sessioninformation` VALUES (169,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:04:28','2010-07-08 13:04:28');
INSERT INTO `sessioninformation` VALUES (170,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:04:29','2010-07-08 13:04:29');
INSERT INTO `sessioninformation` VALUES (171,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:04:31','2010-07-08 13:04:31');
INSERT INTO `sessioninformation` VALUES (172,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:04:37','2010-07-08 13:04:37');
INSERT INTO `sessioninformation` VALUES (173,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:04:40','2010-07-08 13:04:40');
INSERT INTO `sessioninformation` VALUES (174,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:04:41','2010-07-08 13:04:42');
INSERT INTO `sessioninformation` VALUES (175,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:04:44','2010-07-08 13:04:44');
INSERT INTO `sessioninformation` VALUES (176,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:04:46','2010-07-08 13:04:46');
INSERT INTO `sessioninformation` VALUES (177,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:04:49','2010-07-08 13:04:49');
INSERT INTO `sessioninformation` VALUES (178,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:04:51','2010-07-08 13:04:51');
INSERT INTO `sessioninformation` VALUES (179,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:04:56','2010-07-08 13:04:56');
INSERT INTO `sessioninformation` VALUES (180,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:04:59','2010-07-08 13:04:59');
INSERT INTO `sessioninformation` VALUES (181,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 13:05:00','2010-07-08 13:05:00');
INSERT INTO `sessioninformation` VALUES (182,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 16:02:34','2010-07-08 16:02:34');
INSERT INTO `sessioninformation` VALUES (183,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 16:02:34','2010-07-08 16:02:34');
INSERT INTO `sessioninformation` VALUES (184,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 16:02:41','2010-07-08 16:02:41');
INSERT INTO `sessioninformation` VALUES (185,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 16:02:41','2010-07-08 16:02:41');
INSERT INTO `sessioninformation` VALUES (186,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 16:02:43','2010-07-08 16:02:43');
INSERT INTO `sessioninformation` VALUES (187,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 16:11:59','2010-07-08 16:11:59');
INSERT INTO `sessioninformation` VALUES (188,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 16:12:01','2010-07-08 16:12:01');
INSERT INTO `sessioninformation` VALUES (189,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 16:23:32','2010-07-08 16:23:32');
INSERT INTO `sessioninformation` VALUES (190,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 16:23:33','2010-07-08 16:23:33');
INSERT INTO `sessioninformation` VALUES (191,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 16:23:45','2010-07-08 16:23:45');
INSERT INTO `sessioninformation` VALUES (192,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 16:38:32','2010-07-08 16:38:32');
INSERT INTO `sessioninformation` VALUES (193,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 16:41:51','2010-07-08 16:41:51');
INSERT INTO `sessioninformation` VALUES (194,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 16:42:08','2010-07-08 16:42:08');
INSERT INTO `sessioninformation` VALUES (195,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 16:43:33','2010-07-08 16:43:33');
INSERT INTO `sessioninformation` VALUES (196,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:01:11','2010-07-08 17:01:11');
INSERT INTO `sessioninformation` VALUES (197,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:01:11','2010-07-08 17:01:11');
INSERT INTO `sessioninformation` VALUES (198,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:01:18','2010-07-08 17:01:18');
INSERT INTO `sessioninformation` VALUES (199,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:01:18','2010-07-08 17:01:18');
INSERT INTO `sessioninformation` VALUES (200,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:01:35','2010-07-08 17:01:34');
INSERT INTO `sessioninformation` VALUES (201,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:01:35','2010-07-08 17:01:34');
INSERT INTO `sessioninformation` VALUES (202,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:03:16','2010-07-08 17:03:16');
INSERT INTO `sessioninformation` VALUES (203,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:03:16','2010-07-08 17:03:16');
INSERT INTO `sessioninformation` VALUES (204,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:03:50','2010-07-08 17:03:50');
INSERT INTO `sessioninformation` VALUES (205,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:03:50','2010-07-08 17:03:50');
INSERT INTO `sessioninformation` VALUES (206,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:04:05','2010-07-08 17:04:05');
INSERT INTO `sessioninformation` VALUES (207,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:04:05','2010-07-08 17:04:05');
INSERT INTO `sessioninformation` VALUES (208,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:04:06','2010-07-08 17:04:06');
INSERT INTO `sessioninformation` VALUES (209,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:04:06','2010-07-08 17:04:06');
INSERT INTO `sessioninformation` VALUES (210,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:04:24','2010-07-08 17:04:24');
INSERT INTO `sessioninformation` VALUES (211,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:04:24','2010-07-08 17:04:24');
INSERT INTO `sessioninformation` VALUES (212,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:05:26','2010-07-08 17:05:26');
INSERT INTO `sessioninformation` VALUES (213,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:06:09','2010-07-08 17:06:09');
INSERT INTO `sessioninformation` VALUES (214,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:06:19','2010-07-08 17:06:19');
INSERT INTO `sessioninformation` VALUES (215,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:06:20','2010-07-08 17:06:20');
INSERT INTO `sessioninformation` VALUES (216,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:08:12','2010-07-08 17:08:12');
INSERT INTO `sessioninformation` VALUES (217,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial&currentTabID=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:08:13','2010-07-08 17:08:13');
INSERT INTO `sessioninformation` VALUES (218,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=0','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:08:19','2010-07-08 17:08:19');
INSERT INTO `sessioninformation` VALUES (219,'http://granbyprep.local/admissions/index.cfm','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:08:22','2010-07-08 17:08:22');
INSERT INTO `sessioninformation` VALUES (220,'http://granbyprep.local/admissions/index.cfm','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:08:22','2010-07-08 17:08:22');
INSERT INTO `sessioninformation` VALUES (221,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:08:23','2010-07-08 17:08:23');
INSERT INTO `sessioninformation` VALUES (222,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:08:27','2010-07-08 17:08:27');
INSERT INTO `sessioninformation` VALUES (223,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial&currentTabID=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:08:27','2010-07-08 17:08:27');
INSERT INTO `sessioninformation` VALUES (224,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:08:31','2010-07-08 17:08:31');
INSERT INTO `sessioninformation` VALUES (225,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:10:05','2010-07-08 17:10:05');
INSERT INTO `sessioninformation` VALUES (226,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:10:09','2010-07-08 17:10:09');
INSERT INTO `sessioninformation` VALUES (227,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:10:14','2010-07-08 17:10:14');
INSERT INTO `sessioninformation` VALUES (228,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:10:14','2010-07-08 17:10:14');
INSERT INTO `sessioninformation` VALUES (229,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:10:16','2010-07-08 17:10:16');
INSERT INTO `sessioninformation` VALUES (230,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:10:19','2010-07-08 17:10:19');
INSERT INTO `sessioninformation` VALUES (231,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:10:21','2010-07-08 17:10:21');
INSERT INTO `sessioninformation` VALUES (232,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=home','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:03','2010-07-08 17:11:03');
INSERT INTO `sessioninformation` VALUES (233,'http://granbyprep.local/admissions/index.cfm?action=home','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:04','2010-07-08 17:11:04');
INSERT INTO `sessioninformation` VALUES (234,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:06','2010-07-08 17:11:06');
INSERT INTO `sessioninformation` VALUES (235,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:08','2010-07-08 17:11:08');
INSERT INTO `sessioninformation` VALUES (236,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:10','2010-07-08 17:11:10');
INSERT INTO `sessioninformation` VALUES (237,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:14','2010-07-08 17:11:14');
INSERT INTO `sessioninformation` VALUES (238,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:20','2010-07-08 17:11:20');
INSERT INTO `sessioninformation` VALUES (239,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:20','2010-07-08 17:11:20');
INSERT INTO `sessioninformation` VALUES (240,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:21','2010-07-08 17:11:21');
INSERT INTO `sessioninformation` VALUES (241,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:22','2010-07-08 17:11:22');
INSERT INTO `sessioninformation` VALUES (242,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:46','2010-07-08 17:11:46');
INSERT INTO `sessioninformation` VALUES (243,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial&currentTabID=3','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:46','2010-07-08 17:11:46');
INSERT INTO `sessioninformation` VALUES (244,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:48','2010-07-08 17:11:48');
INSERT INTO `sessioninformation` VALUES (245,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:49','2010-07-08 17:11:49');
INSERT INTO `sessioninformation` VALUES (246,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial&currentTabID=3','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:49','2010-07-08 17:11:49');
INSERT INTO `sessioninformation` VALUES (247,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:51','2010-07-08 17:11:51');
INSERT INTO `sessioninformation` VALUES (248,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:53','2010-07-08 17:11:52');
INSERT INTO `sessioninformation` VALUES (249,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial&currentTabID=3','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:53','2010-07-08 17:11:53');
INSERT INTO `sessioninformation` VALUES (250,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:54','2010-07-08 17:11:54');
INSERT INTO `sessioninformation` VALUES (251,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:57','2010-07-08 17:11:57');
INSERT INTO `sessioninformation` VALUES (252,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial&currentTabID=3','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:57','2010-07-08 17:11:57');
INSERT INTO `sessioninformation` VALUES (253,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:58','2010-07-08 17:11:58');
INSERT INTO `sessioninformation` VALUES (254,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:59','2010-07-08 17:11:59');
INSERT INTO `sessioninformation` VALUES (255,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial&currentTabID=3','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:11:59','2010-07-08 17:11:59');
INSERT INTO `sessioninformation` VALUES (256,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:12:01','2010-07-08 17:12:01');
INSERT INTO `sessioninformation` VALUES (257,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:12:01','2010-07-08 17:12:01');
INSERT INTO `sessioninformation` VALUES (258,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial&currentTabID=3','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:12:01','2010-07-08 17:12:01');
INSERT INTO `sessioninformation` VALUES (259,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:12:03','2010-07-08 17:12:03');
INSERT INTO `sessioninformation` VALUES (260,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:12:09','2010-07-08 17:12:09');
INSERT INTO `sessioninformation` VALUES (261,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:12:11','2010-07-08 17:12:11');
INSERT INTO `sessioninformation` VALUES (262,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:14:02','2010-07-08 17:14:02');
INSERT INTO `sessioninformation` VALUES (263,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial&currentTabID=3','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:14:03','2010-07-08 17:14:03');
INSERT INTO `sessioninformation` VALUES (264,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:14:04','2010-07-08 17:14:04');
INSERT INTO `sessioninformation` VALUES (265,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:14:09','2010-07-08 17:14:09');
INSERT INTO `sessioninformation` VALUES (266,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial&currentTabID=3','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:14:09','2010-07-08 17:14:09');
INSERT INTO `sessioninformation` VALUES (267,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:14:11','2010-07-08 17:14:11');
INSERT INTO `sessioninformation` VALUES (268,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=3','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=home','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:14:12','2010-07-08 17:14:12');
INSERT INTO `sessioninformation` VALUES (269,'http://granbyprep.local/admissions/index.cfm?action=home','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:14:24','2010-07-08 17:14:24');
INSERT INTO `sessioninformation` VALUES (270,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:14:26','2010-07-08 17:14:26');
INSERT INTO `sessioninformation` VALUES (271,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:14:28','2010-07-08 17:14:28');
INSERT INTO `sessioninformation` VALUES (272,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:14:30','2010-07-08 17:14:30');
INSERT INTO `sessioninformation` VALUES (273,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:17:14','2010-07-08 17:17:14');
INSERT INTO `sessioninformation` VALUES (274,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:17:17','2010-07-08 17:17:17');
INSERT INTO `sessioninformation` VALUES (275,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:17:28','2010-07-08 17:17:28');
INSERT INTO `sessioninformation` VALUES (276,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:17:44','2010-07-08 17:17:44');
INSERT INTO `sessioninformation` VALUES (277,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:17:49','2010-07-08 17:17:49');
INSERT INTO `sessioninformation` VALUES (278,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:18:18','2010-07-08 17:18:18');
INSERT INTO `sessioninformation` VALUES (279,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:18:24','2010-07-08 17:18:24');
INSERT INTO `sessioninformation` VALUES (280,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:18:28','2010-07-08 17:18:28');
INSERT INTO `sessioninformation` VALUES (281,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:18:46','2010-07-08 17:18:46');
INSERT INTO `sessioninformation` VALUES (282,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:18:47','2010-07-08 17:18:47');
INSERT INTO `sessioninformation` VALUES (283,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:19:00','2010-07-08 17:19:00');
INSERT INTO `sessioninformation` VALUES (284,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:19:10','2010-07-08 17:19:10');
INSERT INTO `sessioninformation` VALUES (285,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:19:22','2010-07-08 17:19:22');
INSERT INTO `sessioninformation` VALUES (286,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:19:34','2010-07-08 17:19:34');
INSERT INTO `sessioninformation` VALUES (287,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:19:40','2010-07-08 17:19:40');
INSERT INTO `sessioninformation` VALUES (288,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:19:46','2010-07-08 17:19:46');
INSERT INTO `sessioninformation` VALUES (289,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:19:51','2010-07-08 17:19:51');
INSERT INTO `sessioninformation` VALUES (290,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:19:59','2010-07-08 17:19:59');
INSERT INTO `sessioninformation` VALUES (291,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:20:22','2010-07-08 17:20:22');
INSERT INTO `sessioninformation` VALUES (292,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:20:37','2010-07-08 17:20:37');
INSERT INTO `sessioninformation` VALUES (293,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:21:36','2010-07-08 17:21:36');
INSERT INTO `sessioninformation` VALUES (294,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:23:08','2010-07-08 17:23:08');
INSERT INTO `sessioninformation` VALUES (295,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:23:27','2010-07-08 17:23:27');
INSERT INTO `sessioninformation` VALUES (296,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:23:38','2010-07-08 17:23:38');
INSERT INTO `sessioninformation` VALUES (297,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:26:34','2010-07-08 17:26:34');
INSERT INTO `sessioninformation` VALUES (298,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:26:53','2010-07-08 17:26:53');
INSERT INTO `sessioninformation` VALUES (299,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:26:54','2010-07-08 17:26:54');
INSERT INTO `sessioninformation` VALUES (300,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:26:58','2010-07-08 17:26:58');
INSERT INTO `sessioninformation` VALUES (301,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:27:36','2010-07-08 17:27:36');
INSERT INTO `sessioninformation` VALUES (302,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:27:45','2010-07-08 17:27:45');
INSERT INTO `sessioninformation` VALUES (303,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:27:47','2010-07-08 17:27:47');
INSERT INTO `sessioninformation` VALUES (304,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:27:53','2010-07-08 17:27:53');
INSERT INTO `sessioninformation` VALUES (305,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:28:01','2010-07-08 17:28:01');
INSERT INTO `sessioninformation` VALUES (306,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:28:31','2010-07-08 17:28:31');
INSERT INTO `sessioninformation` VALUES (307,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:28:42','2010-07-08 17:28:42');
INSERT INTO `sessioninformation` VALUES (308,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:28:50','2010-07-08 17:28:50');
INSERT INTO `sessioninformation` VALUES (309,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:28:55','2010-07-08 17:28:55');
INSERT INTO `sessioninformation` VALUES (310,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:29:00','2010-07-08 17:29:00');
INSERT INTO `sessioninformation` VALUES (311,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:29:15','2010-07-08 17:29:15');
INSERT INTO `sessioninformation` VALUES (312,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:31:21','2010-07-08 17:31:21');
INSERT INTO `sessioninformation` VALUES (313,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:32:29','2010-07-08 17:32:29');
INSERT INTO `sessioninformation` VALUES (314,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:33:25','2010-07-08 17:33:25');
INSERT INTO `sessioninformation` VALUES (315,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:33:32','2010-07-08 17:33:32');
INSERT INTO `sessioninformation` VALUES (316,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:33:47','2010-07-08 17:33:47');
INSERT INTO `sessioninformation` VALUES (317,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:34:01','2010-07-08 17:34:01');
INSERT INTO `sessioninformation` VALUES (318,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:34:15','2010-07-08 17:34:15');
INSERT INTO `sessioninformation` VALUES (319,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:34:21','2010-07-08 17:34:21');
INSERT INTO `sessioninformation` VALUES (320,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:34:25','2010-07-08 17:34:25');
INSERT INTO `sessioninformation` VALUES (321,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:34:34','2010-07-08 17:34:34');
INSERT INTO `sessioninformation` VALUES (322,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:34:51','2010-07-08 17:34:51');
INSERT INTO `sessioninformation` VALUES (323,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:34:59','2010-07-08 17:34:59');
INSERT INTO `sessioninformation` VALUES (324,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:35:19','2010-07-08 17:35:19');
INSERT INTO `sessioninformation` VALUES (325,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:35:59','2010-07-08 17:35:59');
INSERT INTO `sessioninformation` VALUES (326,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:37:50','2010-07-08 17:37:50');
INSERT INTO `sessioninformation` VALUES (327,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:38:08','2010-07-08 17:38:08');
INSERT INTO `sessioninformation` VALUES (328,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:38:26','2010-07-08 17:38:26');
INSERT INTO `sessioninformation` VALUES (329,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:40:41','2010-07-08 17:40:41');
INSERT INTO `sessioninformation` VALUES (330,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 17:41:08','2010-07-08 17:41:08');
INSERT INTO `sessioninformation` VALUES (331,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:02:44','2010-07-08 18:02:44');
INSERT INTO `sessioninformation` VALUES (332,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:04:40','2010-07-08 18:04:40');
INSERT INTO `sessioninformation` VALUES (333,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:05:37','2010-07-08 18:05:37');
INSERT INTO `sessioninformation` VALUES (334,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:06:39','2010-07-08 18:06:39');
INSERT INTO `sessioninformation` VALUES (335,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:08:06','2010-07-08 18:08:06');
INSERT INTO `sessioninformation` VALUES (336,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:09:31','2010-07-08 18:09:31');
INSERT INTO `sessioninformation` VALUES (337,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication?initApplication=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:13:29','2010-07-08 18:13:29');
INSERT INTO `sessioninformation` VALUES (338,'http://granbyprep.local/admissions/index.cfm?action=printApplication?initApplication=1','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:13:33','2010-07-08 18:13:33');
INSERT INTO `sessioninformation` VALUES (339,'http://granbyprep.local/admissions/index.cfm?action=printApplication?initApplication=1','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:13:33','2010-07-08 18:13:33');
INSERT INTO `sessioninformation` VALUES (340,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:13:35','2010-07-08 18:13:35');
INSERT INTO `sessioninformation` VALUES (341,'http://granbyprep.local/admissions/index.cfm?action=printApplication?initApplication=1','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:13:59','2010-07-08 18:13:59');
INSERT INTO `sessioninformation` VALUES (342,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:01','2010-07-08 18:14:01');
INSERT INTO `sessioninformation` VALUES (343,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:02','2010-07-08 18:14:02');
INSERT INTO `sessioninformation` VALUES (344,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication?init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:09','2010-07-08 18:14:09');
INSERT INTO `sessioninformation` VALUES (345,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication?init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:10','2010-07-08 18:14:10');
INSERT INTO `sessioninformation` VALUES (346,'http://granbyprep.local/admissions/index.cfm?action=printApplication?init=1','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:14','2010-07-08 18:14:14');
INSERT INTO `sessioninformation` VALUES (347,'http://granbyprep.local/admissions/index.cfm?action=printApplication?init=1','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:14','2010-07-08 18:14:14');
INSERT INTO `sessioninformation` VALUES (348,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:16','2010-07-08 18:14:16');
INSERT INTO `sessioninformation` VALUES (349,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:25','2010-07-08 18:14:25');
INSERT INTO `sessioninformation` VALUES (350,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:36','2010-07-08 18:14:36');
INSERT INTO `sessioninformation` VALUES (351,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:36','2010-07-08 18:14:36');
INSERT INTO `sessioninformation` VALUES (352,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:37','2010-07-08 18:14:37');
INSERT INTO `sessioninformation` VALUES (353,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:37','2010-07-08 18:14:37');
INSERT INTO `sessioninformation` VALUES (354,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:38','2010-07-08 18:14:37');
INSERT INTO `sessioninformation` VALUES (355,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','init=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:38','2010-07-08 18:14:38');
INSERT INTO `sessioninformation` VALUES (356,'http://granbyprep.local/admissions/?init=1','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:42','2010-07-08 18:14:42');
INSERT INTO `sessioninformation` VALUES (357,'http://granbyprep.local/admissions/?init=1','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:42','2010-07-08 18:14:42');
INSERT INTO `sessioninformation` VALUES (358,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:44','2010-07-08 18:14:44');
INSERT INTO `sessioninformation` VALUES (359,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:14:46','2010-07-08 18:14:46');
INSERT INTO `sessioninformation` VALUES (360,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&INIT=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:15:13','2010-07-08 18:15:13');
INSERT INTO `sessioninformation` VALUES (361,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&INIT=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:15:13','2010-07-08 18:15:13');
INSERT INTO `sessioninformation` VALUES (362,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&INIT=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:15:14','2010-07-08 18:15:14');
INSERT INTO `sessioninformation` VALUES (363,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication&INIT=1','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:15:14','2010-07-08 18:15:14');
INSERT INTO `sessioninformation` VALUES (364,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=applicationFee','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:20:08','2010-07-08 18:20:08');
INSERT INTO `sessioninformation` VALUES (365,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:20:16','2010-07-08 18:20:16');
INSERT INTO `sessioninformation` VALUES (366,'http://granbyprep.local/admissions/index.cfm?action=applicationFee','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=submit','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:20:21','2010-07-08 18:20:21');
INSERT INTO `sessioninformation` VALUES (367,'http://granbyprep.local/admissions/index.cfm?action=submit','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial&currentTabID=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:20:24','2010-07-08 18:20:24');
INSERT INTO `sessioninformation` VALUES (368,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=0','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=6BADA5DDFE9149EC46766B317A91EB45&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:20:26','2010-07-08 18:20:26');
INSERT INTO `sessioninformation` VALUES (369,'http://granbyprep.local/admissions/index.cfm?action=initial&currentTabID=0','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=myAccount','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:20:37','2010-07-08 18:20:37');
INSERT INTO `sessioninformation` VALUES (370,'http://granbyprep.local/admissions/index.cfm?action=myAccount','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=myAccount','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:20:39','2010-07-08 18:20:39');
INSERT INTO `sessioninformation` VALUES (371,'http://granbyprep.local/admissions/index.cfm?action=myAccount','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=myAccount','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:20:39','2010-07-08 18:20:39');
INSERT INTO `sessioninformation` VALUES (372,'http://granbyprep.local/admissions/index.cfm?action=myAccount','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=myAccount','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:20:42','2010-07-08 18:20:42');
INSERT INTO `sessioninformation` VALUES (373,'http://granbyprep.local/admissions/index.cfm?action=myAccount','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=myAccount','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:20:42','2010-07-08 18:20:42');
INSERT INTO `sessioninformation` VALUES (374,'http://granbyprep.local/admissions/index.cfm?action=myAccount','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=faq','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:20:47','2010-07-08 18:20:47');
INSERT INTO `sessioninformation` VALUES (375,'http://granbyprep.local/admissions/index.cfm?action=faq','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=help','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:20:49','2010-07-08 18:20:49');
INSERT INTO `sessioninformation` VALUES (376,'http://granbyprep.local/admissions/index.cfm?action=help','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=home','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:20:50','2010-07-08 18:20:50');
INSERT INTO `sessioninformation` VALUES (377,'http://granbyprep.local/admissions/index.cfm?action=home','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=logoff','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:20:51','2010-07-08 18:20:51');
INSERT INTO `sessioninformation` VALUES (378,'http://granbyprep.local/admissions/index.cfm?action=home','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-08 18:20:51','2010-07-08 18:20:51');
INSERT INTO `sessioninformation` VALUES (379,'','http://granbyprep.local//index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-09 15:41:39','2010-07-09 15:41:45');
INSERT INTO `sessioninformation` VALUES (380,'','http://granbyprep.local//index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-09 15:41:44','2010-07-09 15:41:46');
INSERT INTO `sessioninformation` VALUES (381,'','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-09 15:42:00','2010-07-09 15:42:02');
INSERT INTO `sessioninformation` VALUES (382,'http://granbyprep.local/admissions/','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-09 15:42:13','2010-07-09 15:42:14');
INSERT INTO `sessioninformation` VALUES (383,'http://granbyprep.local/admissions/','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=initial','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-09 15:42:14','2010-07-09 15:42:15');
INSERT INTO `sessioninformation` VALUES (384,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//extensions/components/document.cfc','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','method=getDocumentsRemote&returnFormat=json&argumentCollection=%7B%22foreignTable%22%3A%22student%22%2C%22foreignID%22%3A%221%22%2C%22page%22%3A1%2C%22pageSize%22%3A6%2C%22gridSortColumn%22%3A%22%22%2C%22gridSortDirection%22%3A%22ASC%22%7D&_cf_nodebug=true&_cf_nocache=true&_cf_clientid=E07AB7BBF078EF6C9B14A1F9E3D0F00F&_cf_rc=0','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-09 15:42:23','2010-07-09 15:42:24');
INSERT INTO `sessioninformation` VALUES (385,'http://granbyprep.local/admissions/index.cfm?action=initial','http://granbyprep.local//admissions/index.cfm','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.6) Gecko/20100625 Firefox/3.6.6','action=printApplication','127.0.0.1','127.0.0.1','granbyprep.local','','2010-07-09 15:42:39','2010-07-09 15:42:40');
/*!40000 ALTER TABLE `sessioninformation` ENABLE KEYS */;
UNLOCK TABLES;

#
# Source for table state
#

DROP TABLE IF EXISTS `state`;
CREATE TABLE `state` (
  `Id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '100',
  `code` varchar(5) NOT NULL DEFAULT '',
  `dateCreated` timestamp NULL DEFAULT NULL,
  `dateUpdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8 COMMENT='List of states';

#
# Dumping data for table state
#

LOCK TABLES `state` WRITE;
/*!40000 ALTER TABLE `state` DISABLE KEYS */;
INSERT INTO `state` VALUES (1,' Alabama','AL','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (2,'Alaska','AK','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (3,'Arizona','AZ','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (4,'Arkansas','AR','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (5,'California','CA','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (6,'Colorado','CO','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (7,'Connecticut','CT','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (8,'Delaware','DE','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (9,'Florida','FL','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (10,'Georgia','GA','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (11,'Hawaii','HI','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (12,'Idaho','ID','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (13,' Illinois','IL','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (14,' Indiana','IN','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (15,' Iowa','IA','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (16,' Kansas','KS','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (17,' Kentucky','KY','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (18,' Louisiana','LA','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (19,' Maine','ME','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (20,' Maryland','MD','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (21,' Massachusetts','MA','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (22,' Michigan','MI','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (23,' Minnesota','MN','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (24,' Mississippi','MS','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (25,' Missouri','MO','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (26,' Montana','MT','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (27,' Nebraska','NE','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (28,' Nevada','NV','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (29,' New Hampshire','NH','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (30,' New Jersey','NJ','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (31,' New Mexico','NM','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (32,' New York','NY','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (33,' North Carolina','NC','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (34,' North Dakota','ND','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (35,' Ohio','OH','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (36,' Oklahoma','OK','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (37,' Oregon','OR','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (38,' Pennsylvania','PA','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (39,' Rhode Island','RI','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (40,' South Carolina','SC','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (41,' South Dakota','SD','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (42,' Tennessee','TN','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (43,' Texas','TX','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (44,' Utah','UT','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (45,' Vermont','VT','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (46,' Virginia','VA','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (47,' Washington State','WA','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (48,'Washington DC','DC','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (49,' West Virginia','WV','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (50,' Wisconsin','WI','2010-06-29 09:18:39','2010-06-29 09:19:01');
INSERT INTO `state` VALUES (51,' Wyoming','WY','2010-06-29 09:18:39','2010-06-29 09:19:01');
/*!40000 ALTER TABLE `state` ENABLE KEYS */;
UNLOCK TABLES;

#
# Source for table student
#

DROP TABLE IF EXISTS `student`;
CREATE TABLE `student` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `firstName` varchar(100) NOT NULL DEFAULT '',
  `middleName` varchar(100) NOT NULL DEFAULT '',
  `lastName` varchar(100) NOT NULL DEFAULT '',
  `preferredName` varchar(100) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `password` varchar(16) NOT NULL DEFAULT '',
  `gender` char(1) NOT NULL DEFAULT '',
  `dob` date DEFAULT NULL,
  `countryBirthID` tinyint(3) NOT NULL DEFAULT '0',
  `countryCitizenID` tinyint(3) NOT NULL DEFAULT '0',
  `isActive` bit(1) NOT NULL DEFAULT b'1',
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `dateCanceled` timestamp NULL DEFAULT NULL,
  `dateLastLoggedIn` datetime DEFAULT NULL,
  `dateCreated` timestamp NULL DEFAULT NULL,
  `dateUpdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='Stores basic student information';

#
# Dumping data for table student
#

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES (1,'Marcus','V F V','Melo','Marcus','marcus@iseusa.com','marcus','M','1990-06-09',28,28,b'1',b'0',NULL,'2010-07-09 15:42:13','2010-06-18 13:01:43','2010-07-09 15:42:15');
INSERT INTO `student` VALUES (2,'Gilberto','','Silva','','marcus1@iseusa.com','lisboa12','',NULL,0,0,b'1',b'0',NULL,'2010-06-24 17:57:48','2010-06-24 17:57:48','2010-06-24 17:57:48');
INSERT INTO `student` VALUES (3,'Marcus','','Melo','','marcusise@hotmail.com','marcus12','',NULL,0,0,b'1',b'0',NULL,'2010-06-25 13:17:25','2010-06-25 13:17:25','2010-06-25 13:17:25');
INSERT INTO `student` VALUES (4,'Joao','','Maria','','marcus@student-management.com','marcus123','',NULL,0,0,b'1',b'0',NULL,'2010-06-29 16:16:58','2010-06-29 16:13:57','2010-06-29 16:16:58');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;

/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
