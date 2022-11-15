-- MariaDB dump 10.19  Distrib 10.6.10-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: railway
-- ------------------------------------------------------
-- Server version	10.6.10-MariaDB-1+b1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `railway`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `railway` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `railway`;

--
-- Table structure for table `AVAILABLE`
--

DROP TABLE IF EXISTS `AVAILABLE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AVAILABLE` (
  `train_no` varchar(10) NOT NULL,
  `week_day` varchar(10) NOT NULL,
  `seat` int(11) NOT NULL,
  PRIMARY KEY (`train_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AVAILABLE`
--

LOCK TABLES `AVAILABLE` WRITE;
/*!40000 ALTER TABLE `AVAILABLE` DISABLE KEYS */;
INSERT INTO `AVAILABLE` VALUES ('12045','026',50),('12049','026',50),('12068','02456',120),('12108','136',100),('12168','345',100),('12184','145',120),('12303','012',100),('12381','0236',120),('12417','01234',120),('12487','036',100),('12555','256',20),('12557','256',20),('14006','024',120),('14033','035',40),('20548','0246',100),('213213','123',23),('22538','034',100),('22548','456',100),('545454','12345',122),('98988','0123456',120);
/*!40000 ALTER TABLE `AVAILABLE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SEARCH`
--

DROP TABLE IF EXISTS `SEARCH`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEARCH` (
  `from_code` varchar(10) NOT NULL,
  `to_code` varchar(10) NOT NULL,
  `d_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SEARCH`
--

LOCK TABLES `SEARCH` WRITE;
/*!40000 ALTER TABLE `SEARCH` DISABLE KEYS */;
/*!40000 ALTER TABLE `SEARCH` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `STATION`
--

DROP TABLE IF EXISTS `STATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `STATION` (
  `station_code` varchar(10) NOT NULL,
  `train_no` varchar(10) NOT NULL,
  `arrival_t` varchar(10) NOT NULL,
  `departure_t` varchar(10) NOT NULL,
  `mode` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`train_no`,`station_code`,`mode`),
  CONSTRAINT `fk_station2_to_train` FOREIGN KEY (`train_no`) REFERENCES `AVAILABLE` (`train_no`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `STATION`
--

LOCK TABLES `STATION` WRITE;
/*!40000 ALTER TABLE `STATION` DISABLE KEYS */;
INSERT INTO `STATION` VALUES ('PNBE','12068','20:40','20:50',0),('CNB','12108','20:40','20:50',0),('DHN','12168','20:40','20:50',0),('CNB','12184','19:10','19:20',0),('DHN','12184','09:10','09:20',1),('PNBE','12184','05:10','05:20',1),('CNB','12303','08:00','08:10',0),('PNBE','12303','05:00','05:20',1),('CNB','12381','08:15','08:20',0),('DHN','12381','18:15','18:20',0),('PNBE','12381','12:15','12:20',0),('DHN','12417','08:00','08:10',0),('PNBE','12487','08:00','08:10',0),('KRH','12557','15:20','15:30',0),('PNBE','12557','20:20','20:30',1),('CNB','14006','18:00','18:10',0),('DHN','14006','05:05','05:05',0),('PNBE','14006','01:05','01:05',0),('DHN','14033','10:20','10:30',1),('KRH','14033','06:20','06:30',0),('PNBE','20548','00:35','00:50',0),('DHN','213213','14:30','22:30',0),('PNBE','213213','10:20','20:30',1),('CNB','22538','00:35','00:50',0),('DHN','22548','00:35','00:50',0),('CNB','545454','16:20','16:50',1),('DHN','545454','14:10','14:20',0);
/*!40000 ALTER TABLE `STATION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TICKET`
--

DROP TABLE IF EXISTS `TICKET`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TICKET` (
  `pnr` int(11) NOT NULL AUTO_INCREMENT,
  `from_code` varchar(10) NOT NULL,
  `to_code` varchar(10) NOT NULL,
  `d_date` date NOT NULL,
  `passenger_name` varchar(20) DEFAULT NULL,
  `seat_no` int(11) DEFAULT NULL,
  `train_no` varchar(10) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  PRIMARY KEY (`pnr`),
  KEY `fk_user_id_to_user` (`user_id`),
  CONSTRAINT `fk_user_id_to_user` FOREIGN KEY (`user_id`) REFERENCES `USER` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10084 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TICKET`
--

LOCK TABLES `TICKET` WRITE;
/*!40000 ALTER TABLE `TICKET` DISABLE KEYS */;
INSERT INTO `TICKET` VALUES (10000,'CNB','DHN','2022-11-11','Driver',1,'12184','gulshan2052@gmail.com'),(10001,'DHN','PNBE','2022-11-01','Gulshan Anand',1,'12381','gulshan2052@gmail.com'),(10002,'DHN','PNBE','2022-11-01','Varun',2,'12381','gulshan2052@gmail.com'),(10003,'DHN','PNBE','2022-11-01','Aviral',1,'14006','gulshan2052@gmail.com'),(10004,'DHN','PNBE','2022-11-01','Avishek Kumar',2,'14006','gulshan2052@gmail.com'),(10005,'DHN','PNBE','2022-11-15','Ravi',1,'14006','gulshan2052@gmail.com'),(10006,'DHN','PNBE','2022-11-16','Rahul',1,'12381','gulshan2052@gmail.com'),(10007,'PNBE','DHN','2022-11-04','Messi',1,'12184','gulshan2052@gmail.com'),(10008,'PNBE','CNB','2022-11-05','Ronaldo',1,'12381','gulshan2052@gmail.com'),(10009,'DHN','PNBE','2022-11-01','Kohli',3,'14006','gulshan2052@gmail.com'),(10010,'PNBE','DHN','2022-11-01','Rohit',4,'14006','gulshan2052@gmail.com'),(10011,'CNB','PNBE','2022-11-01','Dhoni',5,'14006','gulshan2052@gmail.com'),(10012,'CNB','DHN','2022-11-04','Yuvraj Singh',2,'12184','gulshan2052@gmail.com'),(10013,'CNB','DHN','2022-10-04','varun',1,'12381','gulshan2052@gmail.com'),(10014,'CNB','DHN','2022-11-01','gulshan',3,'12381','gulshan2052@gmail.com'),(10015,'CNB','DHN','2022-11-01','Priya',4,'12381','gulshan2052@gmail.com'),(10016,'DHN','PNBE','2022-11-01','Gulshan Anand',5,'12381','gulshan2052@gmail.com'),(10017,'CNB','PNBE','2022-11-01','vatun',1,'12303','gulshan2052@gmail.com'),(10077,'CNB','PNBE','2022-11-01','Ram',2,'12303','gulshan2052@gmail.com'),(10078,'CNB','PNBE','2022-11-01','Ram Jr',3,'12303','gulshan2052@gmail.com'),(10079,'CNB','PNBE','2022-11-17','Abababa',1,'12184','aks@gmail.com1'),(10080,'CNB','PNBE','2022-11-15','qwqw',1,'12303','aks@gmail.com1'),(10081,'KRH','PNBE','2022-11-11','Kakaaa',1,'12557','gulshan2052@gmail.com'),(10082,'PNBE','DHN','2022-11-18','Harry',1,'25621','aks@gmail.com1'),(10083,'PNBE','DHN','2022-11-15','Amitabh',1,'25621','aks@gmail.com1');
/*!40000 ALTER TABLE `TICKET` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`admin`@`%`*/ /*!50003 trigger chk_seat_exist
before insert on TICKET
for each row
begin
declare avail_seat int(11);
declare total_seat int(11);
set avail_seat=( select count(*) from TICKET where train_no=new.train_no and d_date=new.d_date);
set total_seat=( select seat from AVAILABLE where train_no=new.train_no);
if((total_seat-avail_seat) <= 0) then
signal SQLSTATE '24004' set MESSAGE_TEXT="No seats Available for the desired Date";
end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `USER`
--

DROP TABLE IF EXISTS `USER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USER` (
  `user_name` varchar(20) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `user_password` varchar(20) NOT NULL,
  `age` int(11) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `phone_no` varchar(10) NOT NULL,
  `emailid` varchar(50) NOT NULL,
  `address` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER`
--

LOCK TABLES `USER` WRITE;
/*!40000 ALTER TABLE `USER` DISABLE KEYS */;
INSERT INTO `USER` VALUES ('Admin','admin123@gmail.com','godpassword',42,'Male','9898989898','admin123@gmail.com','Delhi'),('aviral','aks@gmail.com1','1234',19,'male','100','aks@gmail.com1','house no'),('Aviral','aviral@gmail.com','1234',19,'Male','8795654558','aviral@gmail.com','Delhi'),('Babar','b@b.com','123',30,'Male','8888888888','b@b.com','Pakistan'),('Hello','google@d.com','123',12,'Male','1234567890','google@d.com','Goa'),('Gulshan Anand','gulshan2052@gmail.com','123456',20,'Male','8797287249','gulshan2052@gmail.com','Patna'),('A','IR12','IR12',19,'M','0023332123','abc@gmail.com','Amber'),('B','IR13','IR13',29,'M','0023332133','def@gmail.com','Jasper'),('C','IR14','IR14',39,'M','0023332143','ghi@gmail.com','Rosaline'),('Karan','k@k.com','123',20,'male','5623587454','k@k.com','Patna'),('Komal','k@m.com','12',55,'Female','8796548578','k@m.com','Mumbai'),('Modi','m@m.com','12',55,'male','8798655421','m@m.com','surat'),('Nitish','n@t.com','123456',34,'Male','8564712856','n@t.com','Patna'),('Rohit','rohit@gmail.com','1111',36,'Male','5698569856','rohit@gmail.com','Mumbai'),('sonam','sonam@gmail.com','123',20,'female','7543548154','sonam@gmail.com','Rosaline'),('varun','varun@gmail.com','0987',25,'female','101','varun@gmail.com','stable');
/*!40000 ALTER TABLE `USER` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-06 15:54:42
