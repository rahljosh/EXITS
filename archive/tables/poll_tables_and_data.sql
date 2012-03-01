-- phpMyAdmin SQL Dump
-- version 2.10.3
-- http://www.phpmyadmin.net
-- 
-- Host: 192.168.0.10:3306
-- Generation Time: Feb 23, 2010 at 07:34 AM
-- Server version: 5.0.45
-- PHP Version: 4.3.9

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

-- 
-- Database: `smg`
-- 

-- --------------------------------------------------------

-- 
-- Table structure for table `poll_answers`
-- 

CREATE TABLE IF NOT EXISTS `poll_answers` (
  `answerid` int(11) NOT NULL auto_increment,
  `questionid` int(11) NOT NULL default '0',
  `answer` varchar(250) NOT NULL default '',
  `votes` int(11) NOT NULL default '0',
  PRIMARY KEY  (`answerid`),
  KEY `questionid` (`questionid`),
  KEY `answer` (`answer`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

-- 
-- Dumping data for table `poll_answers`
-- 

INSERT INTO `poll_answers` (`answerid`, `questionid`, `answer`, `votes`) VALUES 
(1, 1, 'St. Petersburg, Russia', 145),
(2, 1, 'Seoul, Korea', 29),
(3, 1, 'Leon, Mexico', 21),
(4, 1, 'Sofia, Bulgaria', 14),
(5, 1, 'Bangkok, Thailand', 83),
(6, 1, 'Paris, France', 87),
(7, 1, 'Lisbon, Portugal', 63),
(8, 1, 'London, England', 88),
(9, 1, 'Other', 78);

-- --------------------------------------------------------

-- 
-- Table structure for table `poll_other`
-- 

CREATE TABLE IF NOT EXISTS `poll_other` (
  `otherid` int(11) NOT NULL auto_increment,
  `questionid` int(11) NOT NULL default '0',
  `answerid` int(11) NOT NULL default '0',
  `other` varchar(250) NOT NULL default '',
  PRIMARY KEY  (`otherid`),
  KEY `questionid` (`questionid`,`answerid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=79 ;

-- 
-- Dumping data for table `poll_other`
-- 

INSERT INTO `poll_other` (`otherid`, `questionid`, `answerid`, `other`) VALUES 
(1, 1, 9, 'Stockholm, Sweden'),
(2, 1, 9, 'Ukraine'),
(3, 1, 9, 'Copenhagen, Denmark'),
(4, 1, 9, 'Ireland'),
(5, 1, 9, 'Coburg, Germany'),
(6, 1, 9, 'Sydney, Australia'),
(7, 1, 9, 'Mascow, Russia'),
(8, 1, 9, 'New Zealand'),
(9, 1, 9, 'Norway fjords and mountains'),
(10, 1, 9, 'Poland'),
(11, 1, 9, 'Japan'),
(12, 1, 9, 'Germany'),
(13, 1, 9, 'Spain'),
(14, 1, 9, 'Madrid Spain'),
(15, 1, 9, 'Dublin Ireland'),
(16, 1, 9, 'Germany'),
(17, 1, 9, 'washington,usa'),
(18, 1, 9, 'Cairns, Australia'),
(19, 1, 9, 'Italy'),
(20, 1, 9, 'Copenhagen, Denmark'),
(21, 1, 9, 'Copenhagen Denmark'),
(22, 1, 9, 'Hawaii'),
(23, 1, 9, 'Zurich, Switzerland or Copenhagen, Denmark'),
(24, 1, 9, 'Greece'),
(25, 1, 9, 'vietnam'),
(26, 1, 9, 'Italy'),
(27, 1, 9, 'Spain'),
(28, 1, 9, 'Boston, Massachusetts, United States'),
(29, 1, 9, 'Nepal'),
(30, 1, 9, 'Nepal'),
(31, 1, 9, 'Germany'),
(32, 1, 9, 'Honolulu Hawaii'),
(33, 1, 9, 'new zealand'),
(34, 1, 9, 'viet nam'),
(35, 1, 9, 'Italy, Rome'),
(36, 1, 9, 'Italy, Rome'),
(37, 1, 9, 'Hamburg Germany'),
(38, 1, 9, 'Navajo  Reservation in  United  States'),
(39, 1, 9, 'Vienna, Austria'),
(40, 1, 9, 'Ireland'),
(41, 1, 9, 'alaska'),
(42, 1, 9, 'philippines'),
(43, 1, 9, 'norway'),
(44, 1, 9, 'Almaty, Kazakhstan'),
(45, 1, 9, 'Madrid, Spain'),
(46, 1, 9, 'Veracruz, Mexico!'),
(47, 1, 9, 'New Zealand'),
(48, 1, 9, 'Madrid, Spain'),
(49, 1, 9, 'Texas, usa'),
(50, 1, 9, 'Heidelburg, Germany'),
(51, 1, 9, 'Vietnam'),
(52, 1, 9, 'Saigan, Vietnam'),
(53, 1, 9, 'Hochiminh city, Vietnam'),
(54, 1, 9, 'cruise'),
(55, 1, 9, 'Paraguay,South America'),
(56, 1, 9, 'usa'),
(57, 1, 9, 'vn'),
(58, 1, 9, 'Germany'),
(59, 1, 9, 'Islip, NY'),
(60, 1, 9, 'usa'),
(61, 1, 9, 'usa'),
(62, 1, 9, 'Germany'),
(63, 1, 9, 'Norway'),
(64, 1, 9, 'la caruna, Spain'),
(65, 1, 9, 'la caruna, Spain'),
(66, 1, 9, 'Germany'),
(67, 1, 9, 'Norway'),
(68, 1, 9, 'Madrid, Spain'),
(69, 1, 9, 'Oslo, Norway'),
(70, 1, 9, 'Oslo, Norway'),
(71, 1, 9, 'loja, ecuador'),
(72, 1, 9, 'Valencia, Spain'),
(73, 1, 9, 'Berlin, Germany'),
(74, 1, 9, 'Sydney, Australia'),
(75, 1, 9, 'japan'),
(76, 1, 9, 'my'),
(77, 1, 9, 'USA'),
(78, 1, 9, 'USA');

-- --------------------------------------------------------

-- 
-- Table structure for table `poll_questions`
-- 

CREATE TABLE IF NOT EXISTS `poll_questions` (
  `questionid` int(11) NOT NULL auto_increment,
  `caption` varchar(250) NOT NULL default '',
  `question` varchar(250) NOT NULL default '',
  `date` date default NULL,
  `active` smallint(4) NOT NULL default '1',
  PRIMARY KEY  (`questionid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- 
-- Dumping data for table `poll_questions`
-- 

INSERT INTO `poll_questions` (`questionid`, `caption`, `question`, `date`, `active`) VALUES 
(1, 'We want to hear from you as to where you would like to go on an upcoming Incentive Trip.  Please vote and let us know.', 'I would like to go to the following city for the 2007 Incentive Trip:', '2005-12-16', 1);
