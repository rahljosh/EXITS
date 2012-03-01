# SQL-Front 5.1  (Build 4.16)

/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE */;
/*!40101 SET SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES */;
/*!40103 SET SQL_NOTES='ON' */;


# Host: 204.12.102.10    Database: smg
# ------------------------------------------------------
# Server version 5.1.43-community

#
# Source for table sea_user
#

CREATE TABLE `sea_user` (
  `user` varchar(100) NOT NULL DEFAULT '',
  `pass` varchar(100) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#
# Dumping data for table sea_user
#

INSERT INTO `sea_user` VALUES ('gene','tipton');

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
