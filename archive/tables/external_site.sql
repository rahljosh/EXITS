# SQL-Front 5.1  (Build 4.16)

/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE */;
/*!40101 SET SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES */;
/*!40103 SET SQL_NOTES='ON' */;


# Host: 204.12.102.10    Database: smg
# ------------------------------------------------------
# Server version 5.1.43-community

#
# Source for table external_site
#

CREATE TABLE `external_site` (
  `background_image` varchar(50) NOT NULL,
  `image` varchar(50) NOT NULL,
  `css_id` varchar(20) NOT NULL,
  `css_class` varchar(25) NOT NULL,
  `text` longtext NOT NULL,
  `title` varchar(50) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `active` int(11) NOT NULL DEFAULT '1',
  `link` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

#
# Dumping data for table external_site
#

INSERT INTO `external_site` VALUES ('','YES_logo.png','yesProgram','info4','<strong>Youth Exchange and Study (YES)</strong> is a program that was established in October, 2002 and sponsored by ECA to provide scholarships for high school students (15-17 years) from countries with significant Muslim populations to spend up to one academic year in the U.S.','Youth Exchange and Study (YES)',1,1,'http://www.iseusa.com/newsite/yesProgram/yes.cfm');
INSERT INTO `external_site` VALUES ('','bstudentphoto.png','studentTab','info1','<strong> For a foreign student, spending a semester or year in the US is the fulfillment of a lifetime dream.</strong> American culture plays an important role all over the world. English language is the international language of our times. And American families are known the world over for their warmth and generosity.','Be a Student',2,1,'http://www.iseusa.com/newsite/StudentInfo/studentInfo.cfm');
INSERT INTO `external_site` VALUES ('','hostfamilyphoto.png','hostStudent','info2','Learn more about hosting a foreign student and <strong>“Making a Difference”</strong>, in a young person.\r\n<br><br>\r\nISE host families are middle class Americans. They open their heart and home to young people from over 55 countries. Each host family has an Area Representative who will meet with them and help them select the ideal student for their home.','Host a Student',3,1,'http://www.iseusa.com/newsite/HostFamily/hostFamily.cfm');
INSERT INTO `external_site` VALUES ('','scholarshipPhoto.png','scholarship','info3','<strong>The Jordan Nagler Memorial Scholarship Fund</strong> was created to honor and commemorate the life and work of Jordan Nagler.\r\n<br><br>\r\nTo commemorate the hard work, effort and results that Jordan achieved in his brief eight years while with SMG, this scholarship was created to allow disadvantaged students to become part of the Academic Year Program.','Jordan Nagler Scholarship',4,1,'http://www.iseusa.com/newsite/scholarship/scholarship.cfm');
INSERT INTO `external_site` VALUES ('','studentsPhoto.png','incStudent','info5','If you are interested in viewing a sample of our <strong> potential Exchange Students...</strong>   ','View Students Coming to the US',5,1,'');

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
