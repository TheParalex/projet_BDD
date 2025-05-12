use projet_bdd;
-- Jeux encore disponibles à la vente ou location
CREATE VIEW v_jeux_disponibles AS
SELECT j.id_jeu, j.nom,
       SUM(CASE WHEN s.type_stock='vente'    THEN s.quantite END) AS dispo_vente,
       SUM(CASE WHEN s.type_stock='location' THEN s.quantite END) AS dispo_location
FROM   JEU j
JOIN   STOCK s USING(id_jeu)
GROUP  BY j.id_jeu;

-- Historique complet des locations avec noms
CREATE VIEW v_historique_location AS
SELECT l.id_location, u.nom, u.prenom, j.nom AS jeu,
       l.date_debut, l.date_fin, l.statut, l.montant_total
FROM   LOCATION l
JOIN   UTILISATEUR u  ON u.id_utilisateur = l.id_utilisateur
JOIN   STOCK      s  USING(id_stock)
JOIN   JEU        j  ON j.id_jeu = s.id_jeu;

-- Moyenne des notes + nombre d'avis
CREATE VIEW v_notes_jeux AS
SELECT j.id_jeu, j.nom,
       ROUND(AVG(a.note),2)  AS moyenne,
       COUNT(a.id_avis)      AS nb_avis
FROM   JEU j
LEFT JOIN AVIS a USING(id_jeu)
GROUP  BY j.id_jeu;

/* Vue : top 5 des jeux les plus vendus sur le mois courant */
CREATE OR REPLACE VIEW v_top_ventes_mois AS
SELECT j.id_jeu,
       j.nom,
       SUM(lc.quantite) AS qte
FROM   COMMANDE c
JOIN   LIGNECOMMANDE lc USING(id_commande)
JOIN   STOCK s          USING(id_stock)
JOIN   JEU   j          ON j.id_jeu = s.id_jeu
WHERE  s.type_stock = 'vente'
  AND  MONTH(c.date_commande) = MONTH(CURDATE())
  AND  YEAR(c.date_commande)  = YEAR(CURDATE())
GROUP  BY j.id_jeu
ORDER  BY qte DESC
LIMIT  5;


-- Accélère la recherche d'un jeu et son stock
CREATE INDEX idx_stock_jeu_type ON STOCK(id_jeu, type_stock);

-- Accélère l’historique location / retours par utilisateur
CREATE INDEX idx_location_utilisateur ON LOCATION(id_utilisateur, statut);

-- Accélère le calcul des moyennes de notes
CREATE INDEX idx_avis_jeu ON AVIS(id_jeu);

use projet_bdd;
-- 1. Diminuer le stock quand une location est créée
DELIMITER //
CREATE TRIGGER trg_location_insert
AFTER INSERT ON LOCATION
FOR EACH ROW
BEGIN
  UPDATE STOCK
  SET quantite = quantite - 1
  WHERE id_stock = NEW.id_stock;
END//
DELIMITER ;

-- 2. Ré-augmenter le stock quand une location passe à 'terminé'
DELIMITER //
CREATE TRIGGER trg_location_update
AFTER UPDATE ON LOCATION
FOR EACH ROW
BEGIN
  IF NEW.statut = 'terminé' AND OLD.statut <> 'terminé' THEN
    UPDATE STOCK
    SET quantite = quantite + 1
    WHERE id_stock = NEW.id_stock;
  END IF;
END//
DELIMITER ;

-- 3. Mettre à jour automatiquement montant_total d’une location
DELIMITER //
CREATE TRIGGER trg_location_calcul_montant
BEFORE INSERT ON LOCATION
FOR EACH ROW
BEGIN
  DECLARE prix DECIMAL(8,2);
  DECLARE nbj  INT;
  SELECT prix_unitaire INTO prix FROM STOCK WHERE id_stock = NEW.id_stock;
  SET nbj = DATEDIFF(NEW.date_fin, NEW.date_debut);
  SET NEW.montant_total = prix * nbj;
END//
DELIMITER ;

use projet_bdd;
-- 1. Louer un jeu (vérifie stock et crée la location)
DELIMITER //
CREATE PROCEDURE sp_louer_jeu(
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
END//
DELIMITER ;

-- 2. Retourner un jeu
DELIMITER //
CREATE PROCEDURE sp_retour_jeu(IN p_location INT)
BEGIN
  UPDATE LOCATION
  SET statut = 'terminé',
      date_fin = CURDATE()
  WHERE id_location = p_location;
END//
DELIMITER ;

-- 3. Fonction moyenne de notes pour un jeu
DELIMITER //
CREATE FUNCTION fn_moyenne_jeu(p_jeu INT)
RETURNS DECIMAL(3,2)
READS SQL DATA
BEGIN
  DECLARE m DECIMAL(3,2);
  SELECT ROUND(AVG(note),2) INTO m FROM AVIS WHERE id_jeu = p_jeu;
  RETURN IFNULL(m,0);
END//
DELIMITER ;




