-- phpMyAdmin SQL Dump
-- version 2.10.3
-- http://www.phpmyadmin.net
-- 
-- Host: 192.168.0.10:3306
-- Generation Time: Feb 23, 2010 at 07:35 AM
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
