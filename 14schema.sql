-- MySQL dump 10.13  Distrib 8.0.16, for Win64 (x86_64)
--
-- Host: cs336.cbfliz2rkk2w.us-east-2.rds.amazonaws.com    Database: DatabaseProject
-- ------------------------------------------------------
-- Server version	5.7.22-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Accounts`
--

DROP TABLE IF EXISTS `Accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Accounts` (
  `accountID` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  PRIMARY KEY (`accountID`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Aircraft`
--

DROP TABLE IF EXISTS `Aircraft`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Aircraft` (
  `aircraftid` varchar(50) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `num_seats` int(11) DEFAULT NULL,
  PRIMARY KEY (`aircraftid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Airline`
--

DROP TABLE IF EXISTS `Airline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Airline` (
  `airlineid` char(2) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`airlineid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Airport`
--

DROP TABLE IF EXISTS `Airport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Airport` (
  `airportid` char(3) NOT NULL,
  `airportname` varchar(100) DEFAULT NULL,
  `country` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`airportid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Employee`
--

DROP TABLE IF EXISTS `Employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Employee` (
  `employeeid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `accountID` int(11) DEFAULT NULL,
  PRIMARY KEY (`employeeid`),
  KEY `accountID` (`accountID`),
  CONSTRAINT `Employee_ibfk_1` FOREIGN KEY (`accountID`) REFERENCES `Accounts` (`accountID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Flight`
--

DROP TABLE IF EXISTS `Flight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Flight` (
  `flight_no` int(11) NOT NULL,
  `num_passengers` int(11) DEFAULT '0',
  `aircraftid` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `numStops` int(11) DEFAULT NULL,
  PRIMARY KEY (`flight_no`),
  KEY `aircraftid` (`aircraftid`),
  CONSTRAINT `Flight_ibfk_1` FOREIGN KEY (`aircraftid`) REFERENCES `Aircraft` (`aircraftid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='connect ticket purchased to customer';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tickets`
--

DROP TABLE IF EXISTS `Tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Tickets` (
  `ticket_no` int(11) NOT NULL AUTO_INCREMENT,
  `seat` int(11) DEFAULT NULL,
  `class` varchar(50) DEFAULT NULL,
  `fare` int(11) DEFAULT NULL,
  `dept_date` datetime DEFAULT NULL,
  `meal` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ticket_no`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arrivesAt`
--

DROP TABLE IF EXISTS `arrivesAt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `arrivesAt` (
  `flight_no` int(11) NOT NULL,
  `airport_id` char(3) NOT NULL,
  `arrive_time` datetime NOT NULL,
  PRIMARY KEY (`flight_no`,`airport_id`),
  UNIQUE KEY `flight_no_UNIQUE` (`flight_no`),
  CONSTRAINT `arrivesAt_ibfk_1` FOREIGN KEY (`flight_no`) REFERENCES `Flight` (`flight_no`),
  CONSTRAINT `arrivesAt_ibfk_2` FOREIGN KEY (`flight_no`) REFERENCES `Flight` (`flight_no`),
  CONSTRAINT `arrivesAt_ibfk_3` FOREIGN KEY (`flight_no`) REFERENCES `Flight` (`flight_no`),
  CONSTRAINT `arrivesAt_ibfk_4` FOREIGN KEY (`flight_no`) REFERENCES `Flight` (`flight_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `associatedAirport`
--

DROP TABLE IF EXISTS `associatedAirport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `associatedAirport` (
  `airportid` char(3) NOT NULL,
  `airlineid` char(2) NOT NULL,
  PRIMARY KEY (`airportid`,`airlineid`),
  KEY `airlineid` (`airlineid`),
  CONSTRAINT `associatedAirport_ibfk_1` FOREIGN KEY (`airportid`) REFERENCES `Airport` (`airportid`),
  CONSTRAINT `associatedAirport_ibfk_2` FOREIGN KEY (`airlineid`) REFERENCES `Airline` (`airlineid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `buysTicket`
--

DROP TABLE IF EXISTS `buysTicket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `buysTicket` (
  `ticket_no` int(11) NOT NULL,
  `accountID` int(11) NOT NULL,
  `date_purchased` datetime DEFAULT NULL,
  `booking_fee` int(11) DEFAULT NULL,
  PRIMARY KEY (`ticket_no`,`accountID`),
  KEY `accountID` (`accountID`),
  CONSTRAINT `buysTicket_ibfk_1` FOREIGN KEY (`ticket_no`) REFERENCES `Tickets` (`ticket_no`) ON DELETE CASCADE,
  CONSTRAINT `buysTicket_ibfk_2` FOREIGN KEY (`accountID`) REFERENCES `Accounts` (`accountID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `departsFrom`
--

DROP TABLE IF EXISTS `departsFrom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `departsFrom` (
  `flight_no` int(11) NOT NULL,
  `airport_id` char(3) NOT NULL,
  `depart_time` datetime NOT NULL,
  PRIMARY KEY (`flight_no`,`airport_id`),
  UNIQUE KEY `flight_no_UNIQUE` (`flight_no`),
  KEY `airport_id` (`airport_id`),
  CONSTRAINT `departsFrom_ibfk_1` FOREIGN KEY (`flight_no`) REFERENCES `Flight` (`flight_no`),
  CONSTRAINT `departsFrom_ibfk_2` FOREIGN KEY (`airport_id`) REFERENCES `Airport` (`airportid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `flightsOnTicket`
--

DROP TABLE IF EXISTS `flightsOnTicket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `flightsOnTicket` (
  `ticket_no` int(11) NOT NULL,
  `flight_no` int(11) NOT NULL,
  PRIMARY KEY (`ticket_no`,`flight_no`),
  KEY `flight_no_fk_idx` (`flight_no`),
  CONSTRAINT `flight_no_fk` FOREIGN KEY (`flight_no`) REFERENCES `Flight` (`flight_no`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ticket_no_fk` FOREIGN KEY (`ticket_no`) REFERENCES `Tickets` (`ticket_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hasWaitlist`
--

DROP TABLE IF EXISTS `hasWaitlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `hasWaitlist` (
  `flight_no` int(11) NOT NULL,
  `waitlistid` int(11) NOT NULL,
  PRIMARY KEY (`flight_no`,`waitlistid`),
  CONSTRAINT `hasWaitlist_ibfk_1` FOREIGN KEY (`flight_no`) REFERENCES `Flight` (`flight_no`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `isOnWaitlist`
--

DROP TABLE IF EXISTS `isOnWaitlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `isOnWaitlist` (
  `waitlistid` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`waitlistid`),
  KEY `username` (`username`),
  CONSTRAINT `username` FOREIGN KEY (`username`) REFERENCES `Accounts` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `onDayOfWeek`
--

DROP TABLE IF EXISTS `onDayOfWeek`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `onDayOfWeek` (
  `airlineid` char(2) NOT NULL,
  `flight_no` int(11) NOT NULL,
  `dayofweek` varchar(10) NOT NULL,
  PRIMARY KEY (`airlineid`,`flight_no`,`dayofweek`),
  KEY `flight_no` (`flight_no`),
  CONSTRAINT `onDayOfWeek_ibfk_1` FOREIGN KEY (`airlineid`) REFERENCES `Airline` (`airlineid`),
  CONSTRAINT `onDayOfWeek_ibfk_2` FOREIGN KEY (`flight_no`) REFERENCES `Flight` (`flight_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `operatesFlight`
--

DROP TABLE IF EXISTS `operatesFlight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `operatesFlight` (
  `flight_no` int(11) NOT NULL,
  `airlineid` char(2) NOT NULL,
  PRIMARY KEY (`airlineid`,`flight_no`),
  CONSTRAINT `operatesFlight_ibfk_1` FOREIGN KEY (`airlineid`) REFERENCES `Airline` (`airlineid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ownsAircraft`
--

DROP TABLE IF EXISTS `ownsAircraft`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `ownsAircraft` (
  `airlineid` char(2) NOT NULL,
  `aircraftid` varchar(50) NOT NULL,
  PRIMARY KEY (`airlineid`,`aircraftid`),
  KEY `aircraftid` (`aircraftid`),
  CONSTRAINT `ownsAircraft_ibfk_1` FOREIGN KEY (`airlineid`) REFERENCES `Airline` (`airlineid`),
  CONSTRAINT `ownsAircraft_ibfk_2` FOREIGN KEY (`aircraftid`) REFERENCES `Aircraft` (`aircraftid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'DatabaseProject'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-08-09 10:07:36
