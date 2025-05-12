CREATE DATABASE  IF NOT EXISTS `projet_bdd` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `projet_bdd`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: projet_bdd
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `jeu`
--

DROP TABLE IF EXISTS `jeu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jeu` (
  `id_jeu` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(120) NOT NULL,
  `description` text,
  `annee_publication` year DEFAULT NULL,
  `age_minimum` tinyint unsigned DEFAULT NULL,
  `duree_moyenne` smallint unsigned DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `id_editeur` int NOT NULL,
  PRIMARY KEY (`id_jeu`),
  KEY `id_editeur` (`id_editeur`),
  CONSTRAINT `jeu_ibfk_1` FOREIGN KEY (`id_editeur`) REFERENCES `editeur` (`id_editeur`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jeu`
--

LOCK TABLES `jeu` WRITE;
/*!40000 ALTER TABLE `jeu` DISABLE KEYS */;
INSERT INTO `jeu` VALUES (1,'Carcassonne','Pose de tuiles médiéval',2000,8,45,'',1),(2,'Splendor','Marchands de gemmes',2014,10,30,'',1),(3,'Pandemic','Sauvez le monde des virus',2008,8,45,'',2),(4,'7 Wonders','Draft de civilisation',2010,10,30,'',3),(5,'Codenames','Jeu d’ambiance par équipes',2015,10,15,'',4),(6,'Dixit','Association d’images',2008,8,30,'',4),(7,'Unlock!','Escape game narratif',2017,10,60,'',5),(8,'Terraforming Mars','Colonisation de Mars',2016,12,120,'',5),(9,'Kingdomino','Domino de royaumes',2016,8,20,'',6),(10,'Zombie Kids','Coopératif enfants',2018,7,15,'',7);
/*!40000 ALTER TABLE `jeu` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-09 11:54:36
