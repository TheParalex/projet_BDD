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
-- Temporary view structure for view `v_top_ventes_mois`
--

DROP TABLE IF EXISTS `v_top_ventes_mois`;
/*!50001 DROP VIEW IF EXISTS `v_top_ventes_mois`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_top_ventes_mois` AS SELECT 
 1 AS `id_jeu`,
 1 AS `nom`,
 1 AS `qte`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_jeux_disponibles`
--

DROP TABLE IF EXISTS `v_jeux_disponibles`;
/*!50001 DROP VIEW IF EXISTS `v_jeux_disponibles`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_jeux_disponibles` AS SELECT 
 1 AS `id_jeu`,
 1 AS `nom`,
 1 AS `dispo_vente`,
 1 AS `dispo_location`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_historique_location`
--

DROP TABLE IF EXISTS `v_historique_location`;
/*!50001 DROP VIEW IF EXISTS `v_historique_location`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_historique_location` AS SELECT 
 1 AS `id_location`,
 1 AS `nom`,
 1 AS `prenom`,
 1 AS `jeu`,
 1 AS `date_debut`,
 1 AS `date_fin`,
 1 AS `statut`,
 1 AS `montant_total`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_notes_jeux`
--

DROP TABLE IF EXISTS `v_notes_jeux`;
/*!50001 DROP VIEW IF EXISTS `v_notes_jeux`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_notes_jeux` AS SELECT 
 1 AS `id_jeu`,
 1 AS `nom`,
 1 AS `moyenne`,
 1 AS `nb_avis`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_top_ventes_mois`
--

/*!50001 DROP VIEW IF EXISTS `v_top_ventes_mois`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_top_ventes_mois` AS select `j`.`id_jeu` AS `id_jeu`,`j`.`nom` AS `nom`,sum(`lc`.`quantite`) AS `qte` from (((`commande` `c` join `lignecommande` `lc` on((`c`.`id_commande` = `lc`.`id_commande`))) join `stock` `s` on((`lc`.`id_stock` = `s`.`id_stock`))) join `jeu` `j` on((`j`.`id_jeu` = `s`.`id_jeu`))) where ((`s`.`type_stock` = 'vente') and (month(`c`.`date_commande`) = month(curdate())) and (year(`c`.`date_commande`) = year(curdate()))) group by `j`.`id_jeu` order by `qte` desc limit 5 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_jeux_disponibles`
--

/*!50001 DROP VIEW IF EXISTS `v_jeux_disponibles`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_jeux_disponibles` AS select `j`.`id_jeu` AS `id_jeu`,`j`.`nom` AS `nom`,sum((case when (`s`.`type_stock` = 'vente') then `s`.`quantite` end)) AS `dispo_vente`,sum((case when (`s`.`type_stock` = 'location') then `s`.`quantite` end)) AS `dispo_location` from (`jeu` `j` join `stock` `s` on((`j`.`id_jeu` = `s`.`id_jeu`))) group by `j`.`id_jeu` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_historique_location`
--

/*!50001 DROP VIEW IF EXISTS `v_historique_location`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_historique_location` AS select `l`.`id_location` AS `id_location`,`u`.`nom` AS `nom`,`u`.`prenom` AS `prenom`,`j`.`nom` AS `jeu`,`l`.`date_debut` AS `date_debut`,`l`.`date_fin` AS `date_fin`,`l`.`statut` AS `statut`,`l`.`montant_total` AS `montant_total` from (((`location` `l` join `utilisateur` `u` on((`u`.`id_utilisateur` = `l`.`id_utilisateur`))) join `stock` `s` on((`l`.`id_stock` = `s`.`id_stock`))) join `jeu` `j` on((`j`.`id_jeu` = `s`.`id_jeu`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_notes_jeux`
--

/*!50001 DROP VIEW IF EXISTS `v_notes_jeux`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_notes_jeux` AS select `j`.`id_jeu` AS `id_jeu`,`j`.`nom` AS `nom`,round(avg(`a`.`note`),2) AS `moyenne`,count(`a`.`id_avis`) AS `nb_avis` from (`jeu` `j` left join `avis` `a` on((`j`.`id_jeu` = `a`.`id_jeu`))) group by `j`.`id_jeu` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Dumping events for database 'projet_bdd'
--

--
-- Dumping routines for database 'projet_bdd'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_moyenne_jeu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `fn_moyenne_jeu`(p_jeu INT) RETURNS decimal(3,2)
    READS SQL DATA
BEGIN
  DECLARE m DECIMAL(3,2);
  SELECT ROUND(AVG(note),2) INTO m FROM AVIS WHERE id_jeu = p_jeu;
  RETURN IFNULL(m,0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_louer_jeu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_louer_jeu`(
  IN p_utilisateur INT,
  IN p_stock       INT,
  IN p_debut       DATE,
  IN p_fin         DATE,
  OUT p_ok         TINYINT
)
BEGIN
  DECLARE dispo INT;
  SELECT quantite INTO dispo FROM STOCK WHERE id_stock = p_stock AND type_stock='location';
  IF dispo > 0 THEN
    INSERT INTO LOCATION(date_debut,date_fin,id_stock,id_utilisateur)
    VALUES(p_debut,p_fin,p_stock,p_utilisateur);
    SET p_ok = 1;
  ELSE
    SET p_ok = 0;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_retour_jeu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_retour_jeu`(IN p_location INT)
BEGIN
  UPDATE LOCATION
  SET statut = 'terminé',
      date_fin = CURDATE()
  WHERE id_location = p_location;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-09 11:54:38
