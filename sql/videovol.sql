-- MySQL dump 10.13  Distrib 5.6.22, for osx10.10 (x86_64)
--
-- Host: localhost    Database: videovol
-- ------------------------------------------------------
-- Server version	5.6.22

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ccdata`
--

DROP TABLE IF EXISTS `ccdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ccdata` (
  `name` varchar(30) DEFAULT NULL,
  `state` varchar(30) DEFAULT NULL,
  `district` varchar(30) DEFAULT NULL,
  `village` varchar(30) DEFAULT NULL,
  `statecodes` varchar(20) DEFAULT NULL,
  `ccid` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ccid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ccdata`
--

LOCK TABLES `ccdata` WRITE;
/*!40000 ALTER TABLE `ccdata` DISABLE KEYS */;
INSERT INTO `ccdata` VALUES ('raju','karnataka','bangalore','sarjapur','KA',1),('ram','andhrapradesh','hyderabad','kookatpalli','AP',2),('Example','Kerala','Cochin','Kochi','KL',3);
/*!40000 ALTER TABLE `ccdata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tracker`
--

DROP TABLE IF EXISTS `tracker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tracker` (
  `UID` varchar(20) NOT NULL,
  `ccname` varchar(20) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `program` varchar(30) DEFAULT NULL,
  `iutheme` varchar(20) DEFAULT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `storydate` date DEFAULT NULL,
  `mentor` varchar(30) DEFAULT NULL,
  `storytype` varchar(20) DEFAULT NULL,
  `shootplan` varchar(500) DEFAULT NULL,
  `relateduid` varchar(20) DEFAULT NULL,
  `impactpossible` varchar(5) DEFAULT NULL,
  `targetofficial` varchar(30) DEFAULT NULL,
  `desiredchange` varchar(300) DEFAULT NULL,
  `impactplan` varchar(2000) DEFAULT NULL,
  `impactfollowup` varchar(5) DEFAULT NULL,
  `impactfollowupnotes` varchar(300) DEFAULT NULL,
  `impactprocess` varchar(800) DEFAULT NULL,
  `impactstatus` varchar(20) DEFAULT NULL,
  `impactdate` date DEFAULT NULL,
  `screeningdone` varchar(5) DEFAULT NULL,
  `screeningheadcount` int(20) DEFAULT NULL,
  `screeningnotes` varchar(300) DEFAULT NULL,
  `officialinvolved` int(20) DEFAULT NULL,
  `officialsatscreening` int(20) DEFAULT NULL,
  `officialscreeningnotes` text,
  `collaborations` varchar(300) DEFAULT NULL,
  `peopleinvolved` int(20) DEFAULT NULL,
  `peopleimpacted` int(20) DEFAULT NULL,
  `villagesimpacted` int(20) DEFAULT NULL,
  `videofoldertitle` varchar(100) DEFAULT NULL,
  `footageinstate` date DEFAULT NULL,
  `assignededitor` varchar(30) DEFAULT NULL,
  `footagefromstate` date DEFAULT NULL,
  `editedvideofromstate` date DEFAULT NULL,
  `editstatus` varchar(20) DEFAULT NULL,
  `footagereview` varchar(300) DEFAULT NULL,
  `roughcutreview` varchar(300) DEFAULT NULL,
  `footagerating` int(10) DEFAULT NULL,
  `paymentapproved` varchar(5) DEFAULT NULL,
  `roughcutdate` date DEFAULT NULL,
  `editdate` date DEFAULT NULL,
  `finalvideorating` int(10) DEFAULT NULL,
  `bonus` varchar(5) DEFAULT NULL,
  `youtubedate` date DEFAULT NULL,
  `youtubeurl` varchar(120) DEFAULT NULL,
  `iupublishdate` date DEFAULT NULL,
  `videotitle` varchar(200) DEFAULT NULL,
  `subtitleneeded` varchar(5) DEFAULT NULL,
  `secondaryiuissue` varchar(30) DEFAULT NULL,
  `subcategory` varchar(30) DEFAULT NULL,
  `project` varchar(30) DEFAULT NULL,
  `blognotes` varchar(50) DEFAULT NULL,
  `flag` varchar(20) DEFAULT NULL,
  `flagnotes` varchar(200) DEFAULT NULL,
  `updatedate` date DEFAULT NULL,
  `note` text DEFAULT NULL,
  PRIMARY KEY (`UID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trackerOld`
--

DROP TABLE IF EXISTS `trackerOld`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trackerOld` (
  `UID` varchar(20) NOT NULL,
  `ccname` text,
  `state` text,
  `program` text,
  `iutheme` text,
  `description` text,
  `storydate` text,
  `mentor` text,
  `storytype` text,
  `shootplan` text,
  `relateduid` text,
  `impactpossible` text,
  `targetofficial` text,
  `desiredchange` text,
  `impactplan` text,
  `impactfollowup` text,
  `impactfollowupnotes` text,
  `impactprocess` text,
  `impactstatus` text,
  `impactdate` text,
  `screeningdone` text,
  `screeningheadcount` text,
  `screeningnotes` text,
  `officialinvolved` text,
  `officialsatscreening` text,
  `officialscreeningnotes` text,
  `collaborations` text,
  `peopleinvolved` text,
  `peopleimpacted` text,
  `villagesimpacted` text,
  `videofoldertitle` text,
  `footageinstate` text,
  `assignededitor` text,
  `footagefromstate` text,
  `editedvideofromstate` text,
  `editstatus` text,
  `footagereview` text,
  `roughcutreview` text,
  `footagerating` text,
  `paymentapproved` text,
  `roughcutdate` text,
  `editdate` text,
  `finalvideorating` text,
  `bonus` text,
  `youtubedate` text,
  `youtubeurl` text,
  `iupublishdate` text,
  `videotitle` text,
  `subtitleneeded` text,
  `secondaryiuissue` text,
  `subcategory` text,
  `project` text,
  `blognotes` text,
  `flag` text,
  `flagnotes` text,
  PRIMARY KEY (`UID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `UID` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(20) DEFAULT NULL,
  `middlename` varchar(20) DEFAULT NULL,
  `lastname` varchar(20) DEFAULT NULL,
  `password` varchar(32) DEFAULT NULL,
  `user_type` int(5) DEFAULT NULL,
  `post` varchar(20) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `emailid` varchar(20) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `pincode` int(10) DEFAULT NULL,
  `contactNo` int(10) DEFAULT NULL,
  `language` varchar(10) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `login_status` int(5) DEFAULT NULL,
  `village` varchar(20) DEFAULT NULL,
  `district` varchar(20) DEFAULT NULL,
  `refreeName` varchar(20) DEFAULT NULL,
  `refreeContactNo` int(20) DEFAULT NULL,
  `organisation` int(20) DEFAULT NULL,
  PRIMARY KEY (`UID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Exa','Mp','Le',NULL,0,'filming','male','apwdko','0001-01-01','KL',9210,120910921,'Hindi','0001-01-02',0,'Kochin','Cohin','Test',1029112030,NULL),(2,'Exa','Mp','Le',NULL,1,'filming','male','apwdko','0001-01-01','KL',9210,120910921,'Hindi','0001-01-02',1,'Kochin','Cohin','Test',1029112030,NULL),(3,'Exa','Mp','Le',NULL,1,'filming','male','apwdko','0001-01-01','KL',9210,120910921,'Hindi','0001-01-02',1,'Kochin','Cohin','Test',1029112030,1),(4,'','','awdawdawd',NULL,NULL,'','','',NULL,'',NULL,NULL,'',NULL,NULL,'','','',NULL,NULL),(5,'','','awdawd','awdwd',NULL,'','','',NULL,'',NULL,NULL,'',NULL,NULL,'','','',NULL,NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-01-30 12:20:07
