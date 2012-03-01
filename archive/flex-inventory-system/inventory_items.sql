# SQL-Front 5.1  (Build 4.16)

/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE */;
/*!40101 SET SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES */;
/*!40103 SET SQL_NOTES='ON' */;


# Host: 204.12.102.10    Database: smg
# ------------------------------------------------------
# Server version 5.1.43-community

#
# Source for table inventory_items
#

CREATE TABLE `inventory_items` (
  `itemid` int(11) NOT NULL AUTO_INCREMENT,
  `companyid` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` longtext NOT NULL,
  `file` varchar(150) NOT NULL,
  `stock` int(11) NOT NULL,
  `printed` varchar(20) NOT NULL,
  `sample` varchar(100) NOT NULL,
  `low_point` int(5) NOT NULL,
  `status` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`itemid`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=latin1;

#
# Dumping data for table inventory_items
#

INSERT INTO `inventory_items` VALUES (7,4,'#10 Envelopes','DMD #10 Envelopes.','Y:/Printed Materials/DMD/DMD-Envelopes',3000,'MPI','DMD/DMD-envelope10.jpg',501,1);
INSERT INTO `inventory_items` VALUES (8,4,'Large Envelope','DMD Large Envelopes','Y:/Printed Materials/DMD/DMD-Envelopes',2800,'MPI','DMD/DMD-envelopeLarge.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (9,4,'Lettherhead','DMD Lettherhead.','Y:/Printed Materials/DMD/DMD-Letterhead',1000,'MPI','DMD/DMD-letter-head.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (10,4,'Folders','DMD Presentation Folders.','Y:/Printed Materials/DMD/DMD-Folder',1500,'MPI','DMD/DMD-folder-outline.jpg',500,1);
INSERT INTO `inventory_items` VALUES (11,4,'Corporate Brochure','DMD Corporate Brochure','Y:/Printed Materials/DMD/DMD-Corporate_Brochure',2480,'MPI','DMD/Corporate_Brochure.jpg',500,1);
INSERT INTO `inventory_items` VALUES (12,4,'Host Family Trifold','DMD Host Family Trifold - Host an Exchange Student and Change theWorld!','Y:/Printed Materials/DMD/DMD-HF-Trifold',3600,'MPI','DMD/DMD-HF-Trifold.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (13,4,'Host Family Flyer','DMD Host Family Flyer - Host A Foreign Student Flyer','Y:/Printed Materials/DMD/DMD-HF-Flyer',1800,'MPI','DMD/DMD-HF-Flyer.jpg',301,1);
INSERT INTO `inventory_items` VALUES (14,4,'AR Trifold','DMD AR Trifold - Working With Tomorrow\'s Leaders','Y:/Printed Materials/DMD/DMD-AR-Trifold',2000,'MPI','DMD/DMD-AR-Trifold.jpg',501,1);
INSERT INTO `inventory_items` VALUES (15,4,'Personal Safety Flyer','DMD Personal Safety Flyer','Y:/Printed Materials/DMD/PersonalSafety',300,'SMG Office','DMD/Sexual-Abuse-Flyer.jpg',201,1);
INSERT INTO `inventory_items` VALUES (16,4,'Changing Lives','DMD - Area Representative Recruitment Threefold, Changing Lives','Y:/Printed Materials/DMD/Changing_Lives',0,'SMG Office','DMD/Changing_Lives.jpg',0,0);
INSERT INTO `inventory_items` VALUES (17,4,'Appreciation Certificates (HF)','DMD Appreciation Certificates for Host Family','Y:/Printed Materials/DMD/DMD-Certificates/',200,'MPI','DMD/host-family-certificate-outline.jpg',201,1);
INSERT INTO `inventory_items` VALUES (19,1,'#10 Envelope','ISE # 10 Envelope','Y:/Printed Materials/ISE/Envelopes/ISE-Envelope1.ai',9000,'MPI','ISE/ISE-Envelope1.jpg',2000,1);
INSERT INTO `inventory_items` VALUES (20,1,'Large Envelope','ISE Large Envelope','Y:/Printed Materials/ISE/Envelopes/ISE-Envelope2.ai',3700,'MPI','ISE/ISE-Envelope2.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (21,1,'Letterhead','ISE Letterhead','Y:/Printed Materials/ISE/LetterHead/ISE-letterhead.ai',5000,'MPI','ISE/ISE-letterhead.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (22,1,'Welcome Home Tri-fold ','ISE Welcome Home Tri-fold','Y:/Printed Materials/ISE/welcome home',3150,'MPI','ISE/ISE-hostfamily.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (23,1,'Corporate Brochure','ISE Corporate Brochure','Y:/Printed Materials/ISE/Corporate Brochure',4500,'MPI','ISE/ISE-company-brochure-1all.jpg',750,1);
INSERT INTO `inventory_items` VALUES (24,1,'HAFS Flyer','ISE Host a Foreign Student Flyer','Y:/Printed Materials/ISE/Host-Foreign-Student-Flyer/ISE-host-foreign-student-flyer.ai',6000,'MPI','ISE/ISE-host-foreign-student-flyer.jpg',1250,1);
INSERT INTO `inventory_items` VALUES (26,1,'Business Cards (Laser Print)','ISE Business Cards (Laser Print)','Y:/Printed Materials/ISE/Business Cards/ISE-PerforatedBC.ai',1500,'MPI','ISE/ISE-PerforatedBC-OUTLINE.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (27,1,'Business cards (STD)','ISE Business Card Standard','Y:/Printed Materials/ISE/Business Cards/ISE-blank-business-card.ai',10950,'MPI','ISE/ISE-blank-business-card.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (28,1,'Appreciation Cert. (HS)','ISE High School Appreciation Certificate','Y:/Printed Materials/ISE/Certificates/ISE-high-school-certificate.ai',1500,'MPI','ISE/ISE-high-school-certificate.jpg',500,1);
INSERT INTO `inventory_items` VALUES (29,1,'Appreciation Cert. (HF)','ISE Host Family Appreciation Certificate','Y:/Printed Materials/ISE/Certificates/ISE-host-family-certificate.ai',1500,'MPI','ISE/ISE-host-family-certificate.jpg',500,1);
INSERT INTO `inventory_items` VALUES (30,1,'Tomorrow\'s Leaders Tri-Fold','ISE Tomorrow\'s Leaders Tri-Fold','Y:/Printed Materials/ISE/Tomorrow\'s Leaders',2000,'MPI','ISE/ISE-TomorrowLeaders.jpg',750,1);
INSERT INTO `inventory_items` VALUES (31,1,'Personal Safety Flyer','ISE Personal Safety Flyer','Y:/Printed Materials/ISE/Personal Safety',3500,'MPI','ISE/Sexual-Abuse-Flyer.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (32,1,'Presentation Folder','ISE Presentation Folder','Y:/Printed Materials/ISE/Presentation Folder',100,'MPI','ISE/ISE-Folder.jpg',500,1);
INSERT INTO `inventory_items` VALUES (33,1,'Thank You Cards','ISE Thank You Cards/ Envelopes','Y:/Printed Materials/ISE/Thank You Cards',5000,'MPI','ISE/ISE-ThankyouCard.jpg',750,1);
INSERT INTO `inventory_items` VALUES (34,4,'Appreciation Certificates (HS)','DMD Appreciation Certificates for High School','Y:/Printed Materials/DMD/DMD-Certificates',500,'MPI','DMD/high-school-certificate-outline.jpg',250,1);
INSERT INTO `inventory_items` VALUES (35,4,'Thank You Card','DMD Thank you card','Y:/Printed Materials/DMD/ThankyouCard',2000,'MPI','DMD/DMD-ThankyouCard.jpg',500,1);
INSERT INTO `inventory_items` VALUES (36,4,'Business Cards (Laser Print)','DMD Business Card Laser Print','Y:/Printed Materials/DMD/DMD-Business-Cards',3000,'MPI','DMD/DMD-PerforatedBC-SINGLE.jpg',500,1);
INSERT INTO `inventory_items` VALUES (37,4,'Business Card (STD)','DMD Standart Business Card','Y:/Printed Materials/DMD/DMD-Business-Cards',0,'MPI','DMD/DMD-blank-business-card.jpg',500,1);
INSERT INTO `inventory_items` VALUES (38,1,'CSIET Brochure','ISE - CSIET Brochure, not designed by us.','Not designed by us.',5000,'MPI','NoImage.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (39,6,'#10 Envelopes','PHP #10 Envelopes','Y:/Printed Materials/PHP/PHP-Letters & Envelopes',1500,'MPI','PHP/envelope1.jpg',500,1);
INSERT INTO `inventory_items` VALUES (40,6,'Large Envelopes','PHP Large Envelopes','Y:/Printed Materials/PHP/PHP-Letters & Envelopes',2000,'MPI','PHP/envelope2.jpg',0,1);
INSERT INTO `inventory_items` VALUES (41,6,'Letterhead','PHP Letterhead','Y:/Printed Materials/PHP/PHP-Letters & Envelopes',2000,'MPI','PHP/letter-head.jpg',500,1);
INSERT INTO `inventory_items` VALUES (42,1,'Trainee Tri-fold','ISE Trainee Tri-fold','Y:/Printed Materials/ISE/ISE-Trainee-Brochure',2000,'MPI','ISE/ISE-Trainee-Brochure.jpg',250,1);
INSERT INTO `inventory_items` VALUES (43,6,'Paper Folder','PHP Paper Folder','Y:/Printed Materials/PHP/PHP-Folder',2000,'MPI','PHP/folder-dmd.jpg',500,1);
INSERT INTO `inventory_items` VALUES (44,6,'Corporate Brochure','PHP Corporate Brochure','Y:/Printed Materials/PHP/PHP-Corporate-Brochure',1500,'MPI','PHP/dmd-brochure.jpg',0,1);
INSERT INTO `inventory_items` VALUES (45,6,'Students Card','PHP Students Card - 3.5 x 2 in','Y:/Printed Materials/PHP/PHP-Students-Card',0,'MPI','PHP/PHP-Students-Card.jpg',1,1);
INSERT INTO `inventory_items` VALUES (46,6,'Vinyl Folder','PHP Vinyl Folder','Y:/Printed Materials/PHP/PHP-vinyl-folder',525,'MPI','PHP/PHP-Folder.jpg',0,1);
INSERT INTO `inventory_items` VALUES (47,6,'Memo Card','PHP Memo Card - 7x3.5 in','Y:/Printed Materials/PHP/PHP-MemoCard',0,'MPI','PHP/PHP-MemoCard.jpg',1,1);
INSERT INTO `inventory_items` VALUES (48,6,'Agent Binder','PHP Agent Binder - Not designed by us.','Not designed by us.',162,'MPI','NoImage.jpg',0,1);
INSERT INTO `inventory_items` VALUES (49,6,'Business Card','PHP Personalized Business Card','Y:/Printed Materials/PHP/PHP-Business-card',0,'MPI','PHP/PHP-Business-card.jpg',0,0);
INSERT INTO `inventory_items` VALUES (50,6,'Personal Safety','PHP Personal Safety Brochure','Y:/Printed Materials/PHP/Personal Safety',150,'SMG Office','PHP/PersonalSafety.jpg',151,0);
INSERT INTO `inventory_items` VALUES (51,3,'#10 Envelopes','ASA #10 Envelopes','Y:/Printed Materials/ASA/ASAI-Envelopes',3000,'MPI','ASA/ASAI-envelope1.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (52,3,'Large Envelopes','ASA Large Envelopes','Y:/Printed Materials/ASA/ASAI-Envelopes',3900,'MPI','ASA/ASAI-envelope2.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (53,3,'Letterhead','ASA Letterhead','Y:/Printed Materials/ASA/ASAI-Letterheard',3500,'MPI','ASA/ASAI-letterhead.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (54,3,'Folder','ASA Paper Folder','Y:/Printed Materials/ASA/ASAI-Folder',5200,'MPI','ASA/ASAI-folder.jpg',500,1);
INSERT INTO `inventory_items` VALUES (55,3,'Share the World Tri-Fold','ASA Share the World Trifold - Welcome Home','Y:/Printed Materials/ASA/ASAI-Share World Tri-Fold',4850,'MPI','ASA/ASA-ShareWorldTriFold.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (56,3,'Corporate Brochure','ASA Corporate Brochure','Y:/Printed Materials/ASA/ASAI-Corporate-Brochure',2000,'MPI','ASA/ASAI-CorporateBrochure.jpg',500,1);
INSERT INTO `inventory_items` VALUES (57,3,'Open Community Tri-Fold','ASA Open Community Trifold - Tomorrow\'s Leaders','Y:/Printed Materials/ASA/ASAI-Brochure-Tomorrow-Leaders',4500,'MPI','ASA/ASAI-OpenCommunity-Trifold.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (58,3,'HAFS Flyer','ASA Host a Foreign Student Flyer','Y:/Printed Materials/ASA/ASAI-Host-Foreign-Student-Flyer',5000,'MPI','ASA/ASAI-host-foreign-student-flyer.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (59,3,'Business Card (laser)','ASA Business Card - Perforated, Laser Print','Y:/Printed Materials/ASA/ASAI-Business-Card',3000,'MPI','ASA/ASA-PerforatedBC-SINGLE.jpg',1,1);
INSERT INTO `inventory_items` VALUES (60,3,'Business Card (SRD)','ASA Personalized Business Card','Y:/Printed Materials/ASA/ASAI-Business-Card',11000,'MPI','ASA/ASAI-business-card.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (61,3,'Appreciation Certificates (HF)','ASA Host Family Appreciation Certificates','Y:/Printed Materials/ASA/ASAI-Certificates',4000,'MPI','ASA/ASAI-host-family-certificate.jpg',500,1);
INSERT INTO `inventory_items` VALUES (62,3,'Appreciation Certificates (HS)','ASA High School Appreciation Certificates','Y:/Printed Materials/ASA/ASAI-Certificates',4000,'MPI','ASA/ASAI-high-school-certificate.jpg',500,1);
INSERT INTO `inventory_items` VALUES (63,3,'CSIET Brochure','ASA - CSIET Brochure - Not designed by us.','Not designed by us.',3500,'MPI','NoImage.jpg',500,1);
INSERT INTO `inventory_items` VALUES (64,3,'Personal Safety','ASA Personal Safety Brochure','Y:/Printed Materials/ASA/PersonalSafety',5000,'MPI','ASA/ASAI-PersonalSafety.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (65,3,'Thank You Card','ASA Thank You Card','Y:/Printed Materials/ASA/ThankYouCard',3000,'MPI','ASA/ASAI-ThankYouCard.jpg',500,1);
INSERT INTO `inventory_items` VALUES (66,2,'#10 Envelopes','INTO # 10 Envelopes','Y:/Printed Materials/INTO/INTO-Envelopes',1500,'MPI','INTO/INTO-envelope1.jpg',750,1);
INSERT INTO `inventory_items` VALUES (67,2,'Large Envelopes','INTO Large Envelopes','Y:/Printed Materials/INTO/INTO-Envelopes',3700,'MPI','INTO/INTO-envelope2.jpg',750,1);
INSERT INTO `inventory_items` VALUES (68,2,'Letterhead','INTO Letterhead','Y:/Printed Materials/INTO/INTO-Letterhead',6250,'MPI','INTO/INTO-letterhead.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (69,2,'Folder','INTO Paper Folder','Y:/Printed Materials/INTO/INTO-Folder',5000,'MPI','INTO/INTO-Folder.jpg',500,1);
INSERT INTO `inventory_items` VALUES (70,2,'Corporate Brochure','INTO Corporate Brochure','Y:/Printed Materials/INTO/INTO-Corporate-Brochure',2500,'MPI','INTO/INTO-Corporate-brochure.jpg',750,1);
INSERT INTO `inventory_items` VALUES (71,2,'HAFS Flyer','INTO Host a Foreign Student Flyer','Y:/Printed Materials/INTO/INTO-Host-Foreign-Studet-Flyer',3500,'MPI','INTO/Host-Foreign-Student-Flyer.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (72,2,'Making a Difference Tri-Fold','INTO Making a Difference Tri-Fold - Tomorrow\'s Leaders','Y:/Printed Materials/INTO/INTO-MakingADifference-Trifold',5000,'MPI','INTO/into-MakingDifference-Trifold.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (73,2,'Business Card (laser)','INTO Business Card - Perforated Laser Print','Y:/Printed Materials/INTO/INTO-business-card',1500,'MPI','INTO/INTO-PerforatedBC-SINGLE.jpg',500,1);
INSERT INTO `inventory_items` VALUES (74,2,'Business Card (STD)','INTO Personalized Business Card','Y:/Printed Materials/INTO/INTO-business-card',5000,'MPI','INTO/INTO-blank-business-card.jpg',500,1);
INSERT INTO `inventory_items` VALUES (75,2,'Hosting Tri-Fold','INTO Hosting Tri-Fold ','Y:/Printed Materials/INTO/INTO-Hosting Tri-Fold',2500,'MPI','INTO/INTO-HostiongTrifold.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (76,2,'Appreciation Certificates (HF)','INTO Host Family Appreciation Certificates','Y:/Printed Materials/INTO/INTO-Certificates',3500,'MPI','INTO/INTO-host-family-certificate.jpg',500,1);
INSERT INTO `inventory_items` VALUES (77,2,'Appreciation Certificates (HS)','INTO High School Appreciation Certificates','Y:/Printed Materials/INTO/INTO-Certificates',3500,'MPI','INTO/INTO-high-school-certificate.jpg',500,1);
INSERT INTO `inventory_items` VALUES (78,2,'CSIET Brochure','INTO CSIET Brochure - Not Designed by us.','INTO-high-school-certificate.jpg',1000,'MPI','NoImage.jpg',500,1);
INSERT INTO `inventory_items` VALUES (79,2,'Personal Safety','INTO Personal Safety Brochure','Y:/Printed Materials/INTO/PersonalSafety',4750,'MPI','INTO/PersonalSafety.jpg',500,1);
INSERT INTO `inventory_items` VALUES (80,2,'Thank You Card','INTO Thank You Card','Y:/Printed Materials/INTO/ThankyouCard',5000,'MPI','INTO/INTO-ThankyouCard.jpg',500,1);
INSERT INTO `inventory_items` VALUES (81,5,'#10 Envelopes','SMG #10 Envelopes','Y:/Printed Materials/SMG/SMG-Envelopes',3000,'MPI','SMG/SMG-Envelope1.jpg',750,1);
INSERT INTO `inventory_items` VALUES (82,5,'Large Envelopes','SMG Large Envelopes','Y:/Printed Materials/SMG/SMG-Envelopes',3500,'MPI','SMG/SMG-Envelope2.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (83,5,'Letterhead','SMG Letterhead','Y:/Printed Materials/SMG/SMG-Letterhead',1200,'MPI','SMG/SMG-Letterhead.jpg',1201,1);
INSERT INTO `inventory_items` VALUES (84,5,'Flyer','SMG Flyer - Front and Back','Y:/Printed Materials/SMG/SMG-Flyer',3000,'MPI','SMG/SMG-flyer.jpg',750,1);
INSERT INTO `inventory_items` VALUES (85,5,'Calling Card','SMG Calling Card - Business Card Size','Y:/Printed Materials/SMG/calling-service',800,'MPI','SMG/SMG-calling-service-BC.jpg',500,1);
INSERT INTO `inventory_items` VALUES (86,5,'Calling Card Flyer','SMF Calling Card - Flyer','Y:/Printed Materials/SMG/calling-service',800,'MPI','SMG/SMG-calling-service.jpg',750,1);
INSERT INTO `inventory_items` VALUES (87,5,'Student Tours Flyer 2008-09','SMG Student Tours Flyers - trips descriptions, color 2008-09','Y:/Printed Materials/SMG/SMG Trips/2008-09',0,'MPI','SMG/SMGTrips_08-09.jpg',0,1);
INSERT INTO `inventory_items` VALUES (88,5,'Corporate Brochure','SMG Corporate Brochure - Not Designed by us.','Not Designed by us.',2250,'MPI','NoImage.jpg',750,1);
INSERT INTO `inventory_items` VALUES (89,5,'Making a Difference Newsletter','SMG Making a Difference Newsletter','',0,'','NoImage.jpg',0,0);
INSERT INTO `inventory_items` VALUES (90,5,'VSC Premium Policy','','',750,'','NoImage.jpg',751,0);
INSERT INTO `inventory_items` VALUES (91,5,'VSC Standard Comprehensive Policy','','',1500,'','NoImage.jpg',0,0);
INSERT INTO `inventory_items` VALUES (92,5,'VSC Comprehensive Deductible Policy','','',200,'','NoImage.jpg',201,0);
INSERT INTO `inventory_items` VALUES (93,5,'VSC ID Cards','','',0,'','NoImage.jpg',1,1);
INSERT INTO `inventory_items` VALUES (94,5,'Global Secutive HS Brochure','','',1500,'','NoImage.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (95,5,'Global Secutive WE Brochure','','',0,'','NoImage.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (96,5,'IHI Supreme L cards','','',0,'','NoImage.jpg',1,1);
INSERT INTO `inventory_items` VALUES (97,5,'IHI Supreme 50 cards','','',0,'','NoImage.jpg',1,1);
INSERT INTO `inventory_items` VALUES (98,5,'IHI Elite L cards','','',0,'','NoImage.jpg',1,1);
INSERT INTO `inventory_items` VALUES (99,5,'IHI comfort 50 cards','','',0,'','NoImage.jpg',1,1);
INSERT INTO `inventory_items` VALUES (100,5,'Athens Postcard','','',0,'','NoImage.jpg',0,1);
INSERT INTO `inventory_items` VALUES (101,5,'Host Apps - Cover Sheet ','Cover Sheet (11x17) folded','',6000,'','NoImage.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (102,5,'Host Apps - CBC (white)','','',6000,'','NoImage.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (103,5,'Host Apps - Confidential Host Visit (yellow)','','',6000,'','NoImage.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (104,5,'Host Apps - Personal Reference (white)','','',6000,'','NoImage.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (105,5,'Host Apps - Verbal References (blue)','','',5750,'','NoImage.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (106,5,'Host Apps - Family Album/letter (white)','','',6000,'','NoImage.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (107,5,'Host Apps - School acceptence (pink)','','',6000,'','NoImage.jpg',1000,1);
INSERT INTO `inventory_items` VALUES (110,4,'CSIET Pamphlet','CSIET Pamphlet','',2000,'CSIET','',500,1);
INSERT INTO `inventory_items` VALUES (111,3,'Quick Reference Trifold','ASA-Quick Reference Trifold','',2000,'MPI','',1,1);
INSERT INTO `inventory_items` VALUES (112,4,'Quick Reference Trifold','DMD-Quick Reference Trifold','',1500,'MPI','',1,1);
INSERT INTO `inventory_items` VALUES (113,2,'Quick Reference Trifold','INTO-Quick Reference Trifold','',0,'MPI','',1,1);
INSERT INTO `inventory_items` VALUES (114,1,'Quick Reference Trifold','ISE-Quick Reference Trifold','',1000,'MPI','',200,1);
INSERT INTO `inventory_items` VALUES (115,1,'Door Hanger','ISE Blank Door Hangers, to be presonalized.','Y:/Printed Materials/ISE/Door-hangers',2250,'MPI','ISE/ISE-door-hangers.jpg',500,1);
INSERT INTO `inventory_items` VALUES (116,2,'Door hanger','INTO Blank Door Hangers, to be presonalized.','Y:/Printed Materials/INTO/INTO-Door-hangers',2750,'MPI','INTO/INTO-door-hangers.jpg',250,1);
INSERT INTO `inventory_items` VALUES (117,3,'Door Hanger','ASA Blank Door Hangers, to be presonalized.','Y:/Printed Materials/ASA/ASAI-Door-Hanger',2600,'MPI','ASA/ASAI-Door-Hangers.jpg',601,1);
INSERT INTO `inventory_items` VALUES (118,4,'Door Hanger','DMD Blank Door Hangers, to be presonalized.','Y:/Printed Materials/DMD/DMD-Door-Hanger',750,'MPI','DMD/DMD-door-hangers.jpg',250,1);

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
