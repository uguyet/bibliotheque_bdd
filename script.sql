
/**************************************************************/
/**                  PROJET BASE DE DONNEES                 ***/ 
/**************************************************************/


/* Binome : Ulysse Guyet et Jennifer Rondineau   */

/**************************************************************/
/********************* PARTIE 1 *******************************/ 
/**************************************************************/


/*Commande permettant d'afficher toutes les tables d'un compte */
SELECT table_name FROM user_tables;


/* QUESTION 1 */

/*Création des tables de la base de données*/

CREATE TABLE Ouvrages (	isbn NUMBER, 	titre VARCHAR2(200) NOT NULL, 	auteur VARCHAR2(50), 	genre VARCHAR2(3) NOT NULL, 	editeur VARCHAR2(50), 	CONSTRAINT pk_isbn PRIMARY KEY(isbn));

CREATE TABLE Exemplaires (	isbn NUMBER, 	numExemplaire NUMBER, 	etat VARCHAR2(10), 	CONSTRAINT fk_isbn FOREIGN KEY (isbn) REFERENCES Ouvrages(isbn), 	CONSTRAINT pk_exemplaires PRIMARY KEY(isbn, numExemplaire));

CREATE TABLE Membres (numMembre NUMBER, 	nom VARCHAR2(40) NOT NULL,	prenom VARCHAR2(40) NOT NULL, 	adresse VARCHAR2(100) NOT NULL,	telephone CHAR(10),	dateAdhesion DATE NOT NULL, 	duree NUMBER NOT NULL, 	CONSTRAINT pk_membres PRIMARY KEY(numMembre), 	CONSTRAINT duree_adhesion CHECK (duree>=0));

CREATE TABLE Emprunts (	idEmprunt NUMBER, 	numMembre NUMBER, 	dateEmprunt DATE DEFAULT sysdate, 	CONSTRAINT pk_emprunts PRIMARY KEY(idEmprunt), 	CONSTRAINT fk_emprunts FOREIGN KEY (numMembre) REFERENCES Membres(numMembre));

CREATE TABLE DetailsEmprunts (	idEmprunt NUMBER, 	isbn NUMBER, 	numeroEmprunt NUMBER, 	numExemplaire NUMBER,	dateRetour DATE,	CONSTRAINT PK_Details_Emprunts PRIMARY KEY(idEmprunt, numeroEmprunt), 	CONSTRAINT fk_idemprunt FOREIGN KEY(idEmprunt) REFERENCES Emprunts(idEmprunt), 	CONSTRAINT fk_Exemplaire FOREIGN KEY(isbn, numExemplaire) REFERENCES Exemplaires(isbn, numExemplaire) ON DELETE CASCADE);


/* QUESTION 2 */

CREATE SEQUENCE incrementation START WITH 1 INCREMENT BY 1;


/* QUESTION 3 */

ALTER TABLE Membres ADD CONSTRAINT unique_membres UNIQUE(nom, prenom, telephone);

/* QUESTION 4 */
/*La contrainte check_06 permet de vérifier que le 'portable' commence bien par '06'*/
ALTER TABLE Membres ADD portable CHAR(10) CONSTRAINT check_06 CHECK (portable LIKE '06%');

/* QUESTION 5 */
/*On supprime l'ancienne contrainte d'unicité sur Membres*/
ALTER TABLE Membres DROP CONSTRAINT unique_membres;
/*Et on ajoute la nouvelle comportant cette fois le numéro de portable*/
ALTER TABLE Membres ADD CONSTRAINT unique_membres UNIQUE(nom, prenom, portable); 
ALTER TABLE Membres SET UNUSED(telephone);
ALTER TABLE Membres DROP UNUSED COLUMNS;

/* QUESTION 6 */

CREATE INDEX index_FK_exemplaires_isbn ON Exemplaires(isbn);
CREATE INDEX index_FK_Emprunts_numMembre ON Emprunts(numMembre);
CREATE INDEX index_FK_idEmprunt ON DetailsEmprunts(idEmprunt);
CREATE INDEX index_FK_isbn ON DetailsEmprunts(isbn);
CREATE INDEX index_FK_numExemplaire ON DetailsEmprunts(numExemplaire);

/* QUESTION 7 */

ALTER TABLE DetailsEmprunts DROP CONSTRAINT fk_idemprunt;
ALTER TABLE DetailsEmprunts ADD CONSTRAINT fk_idemprunt FOREIGN KEY (idEmprunt) REFERENCES Emprunts(idEmprunt) ON DELETE CASCADE ;

/* QUESTION 8 */

ALTER TABLE Exemplaires MODIFY etat DEFAULT 'NE';

/* QUESTION 9 insufficient privileges */

CREATE SYNONYM Abonnes FOR Membres;

/* QUESTION 10 */

ALTER TABLE DetailsEmprunts RENAME TO Details;



/**************************************************************/
/********************* PARTIE 2 *******************************/ 
/**************************************************************/

/* QUESTION 1 */

CREATE TABLE Genres (code VARCHAR2(3) CONSTRAINT pk_genre PRIMARY KEY, libelle VARCHAR2(20) NOT NULL);

/*Remplissage de la table Genres*/
INSERT INTO Genres VALUES('REC','Récit');
INSERT INTO Genres VALUES('POL','Policier');
INSERT INTO Genres VALUES('BD','Bande Dessinée');
INSERT INTO Genres VALUES('INF','Informatique');
INSERT INTO Genres VALUES('THE','Théatre');
INSERT INTO Genres VALUES('ROM','Roman');

ALTER TABLE Ouvrages ADD CONSTRAINT fk_codeGenre FOREIGN KEY(genre) REFERENCES Genres(code);

/*Remplissage de la table Ouvrages*/
INSERT INTO Ouvrages VALUES (2203314168, 'LEFRANC-Lultimatum', 'Martin, Carin', 'BD', 'Casterman'); 
INSERT INTO Ouvrages VALUES (2746021285, 'HTML – entraînez-vous pour maîtriser le code source', 'Luc Van Lancker ', 'INF', 'ENI'); 
INSERT INTO Ouvrages VALUES (2746026090, 'Oracle 10g SQL, PL/SQL, SQL*Plus', 'J. Gabillaud', 'INF', 'ENI');
INSERT INTO Ouvrages VALUES (2266085816, 'Pantagruel', ' F. Robert', 'ROM', 'Pocket');  
INSERT INTO Ouvrages VALUES (2266091611, ' Voyage au centre de la terre', 'Jules VERNE', 'ROM', 'Pocket');  
INSERT INTO Ouvrages VALUES (2253010219, 'Le crime de lOrient Express', 'Agatha Christie', 'POL', 'Livre de Poche');  
INSERT INTO Ouvrages VALUES (2070400816, 'Le Bourgois gentilhomme', 'Molière', 'THE', 'Gallimard');  
INSERT INTO Ouvrages VALUES (2070397177, ' Le curé de Tours',  'Honoré de Balzac', 'ROM','Gallimard');  
INSERT INTO Ouvrages VALUES (2080720872, ' Boule de suif', 'G. de Maupassant', 'REC', 'Flammarion');  
INSERT INTO Ouvrages VALUES (2877065073, ' La gloire de mon père', ' Marcel Pagnol', 'ROM', 'Fallois');  
INSERT INTO Ouvrages VALUES (2020549522, ' Laventure des manuscrits  de la mer morte', '', 'REC', 'Seuil');  
INSERT INTO Ouvrages VALUES (2253006327, 'Vingt mille lieues sous les mers', 'Jules Verne', 'ROM', 'LGF');  
INSERT INTO Ouvrages VALUES (2038704015, 'De la terre à la lune', 'Jules Verne ', 'ROM', 'Larousse');  

/*Remplissage de la table Exemplaires*/
INSERT INTO Exemplaires VALUES (2203314168, 1, 'Moyen');
INSERT INTO Exemplaires VALUES (2203314168, 2, 'Bon');
INSERT INTO Exemplaires VALUES (2203314168, 3, 'Neuf');
INSERT INTO Exemplaires VALUES (2746021285, 1, 'Bon');
INSERT INTO Exemplaires VALUES (2746021285, 2, 'Moyen'); /*rajouter car problème d'intégrité pour la table Emprunts qui le contient*/
INSERT INTO Exemplaires VALUES (2746026090, 1, 'Bon');
INSERT INTO Exemplaires VALUES (2746026090, 2, 'Moyen');
INSERT INTO Exemplaires VALUES (2266085816, 1, 'Bon');
INSERT INTO Exemplaires VALUES (2266085816, 2, 'Moyen');
INSERT INTO Exemplaires VALUES (2266091611, 1, 'Bon');
INSERT INTO Exemplaires VALUES (2266091611, 2, 'Moyen');
INSERT INTO Exemplaires VALUES (2253010219, 1, 'Bon');
INSERT INTO Exemplaires VALUES (2253010219, 2, 'Moyen');
INSERT INTO Exemplaires VALUES (2070400816, 1, 'Bon');
INSERT INTO Exemplaires VALUES (2070400816, 2, 'Moyen');
INSERT INTO Exemplaires VALUES (2070397177, 1, 'Bon');
INSERT INTO Exemplaires VALUES (2070397177, 2, 'Moyen');
INSERT INTO Exemplaires VALUES (2080720872, 1, 'Bon');
INSERT INTO Exemplaires VALUES (2080720872, 2, 'Moyen');
INSERT INTO Exemplaires VALUES (2877065073, 1, 'Bon');
INSERT INTO Exemplaires VALUES (2877065073, 2, 'Moyen');
INSERT INTO Exemplaires VALUES (2020549522, 1, 'Bon');
INSERT INTO Exemplaires VALUES (2020549522, 2, 'Moyen');
INSERT INTO Exemplaires VALUES (2253006327, 1, 'Bon');
INSERT INTO Exemplaires VALUES (2253006327, 2, 'Moyen');
INSERT INTO Exemplaires VALUES (2038704015, 1, 'Bon');
INSERT INTO Exemplaires VALUES (2038704015, 2, 'Moyen');


/* QUESTION2 */

CREATE SEQUENCE incrementation_membre START WITH 1 INCREMENT BY 1 MINVALUE 0;
incrementation_membre

/*Remplissage de la table Membres*/
INSERT INTO Membres VALUES(incrementation_membre.nextval, 'Albert', 'Anne', '13 rue des Alpes', Sysdate-60, 1, '0601020304');
INSERT INTO Membres VALUES(incrementation_membre.nextval, 'Bernaud', 'Barnabé', '6 rue des bécasses', Sysdate-10, 3, '0602030105');
INSERT INTO Membres VALUES(incrementation_membre.nextval, 'Cuvard', 'Camille', '53 rue des cerisiers', Sysdate-100, 6, '0602010509');
INSERT INTO Membres VALUES(incrementation_membre.nextval, 'Dupond', 'Daniel', '11 rue des daims', Sysdate-250, 12, '0610236515');
INSERT INTO Membres VALUES(incrementation_membre.nextval, 'Evroux', 'Eglantine', '34 rue des elfes', Sysdate-150, 6, '0658963125');
INSERT INTO Membres VALUES(incrementation_membre.nextval, 'Fregeon', 'Fernand', '11 rue de Francs', Sysdate-400, 6, '0602036987');
INSERT INTO Membres VALUES(incrementation_membre.nextval, 'Gorit', 'Gaston', '96 rue de la glacerie', Sysdate-150, 1, '0684235781');
INSERT INTO Membres VALUES(incrementation_membre.nextval, 'Hevard', 'Hector', '12 rue haute', Sysdate-250, 12, '0608546578');
INSERT INTO Membres VALUES(incrementation_membre.nextval, 'Ingrand', 'Irène', '54 rue de iris', Sysdate-50, 12, '0605020409');
INSERT INTO Membres VALUES(incrementation_membre.nextval, 'Juste', 'Julien', '5 place des Jacobins', Sysdate-100, 6, '0603069876');


/* QUESTION 3*/

CREATE SEQUENCE incrementation_ouvrages START WITH 1 INCREMENT BY 1;

/*Remplissage de la table Emprunts*/
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 1, Sysdate-200);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 3, Sysdate-190);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 4, Sysdate-180);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 1, Sysdate-170);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 5, Sysdate-160);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 2, Sysdate-150);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 4, Sysdate-140);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 1, Sysdate-130);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 9, Sysdate-120);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 6, Sysdate-110);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 1, Sysdate-100);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 6, Sysdate-90);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 2, Sysdate-80);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 4, Sysdate-70);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 1, Sysdate-60);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 3, Sysdate-50);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 1, Sysdate-40);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 5, Sysdate-30);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 4, Sysdate-20);
INSERT INTO Emprunts VALUES(incrementation_ouvrages.nextval, 1, Sysdate-10);

/*Remplissage de la table Details*/
INSERT INTO Details VALUES(1,2038704015,1,1,Sysdate-195);
INSERT INTO Details VALUES(1,2070397177,2,2,Sysdate-190);
INSERT INTO Details VALUES(2,2080720872,1,1,Sysdate-180);
INSERT INTO Details VALUES(2,2203314168,2,1,Sysdate-179);
INSERT INTO Details VALUES(3,2038704015,1,1,Sysdate-170);
INSERT INTO Details VALUES(4,2203314168,1,2,Sysdate-155);
INSERT INTO Details VALUES(4,2080720872,2,1,Sysdate-155);
INSERT INTO Details VALUES(4,2266085816,3,1,Sysdate-159);
INSERT INTO Details VALUES(5,2038704015,1,2,Sysdate-140);
INSERT INTO Details VALUES(6,2266085816,1,2,Sysdate-141);
INSERT INTO Details VALUES(6,2080720872,2,2,Sysdate-130);
INSERT INTO Details VALUES(6,2746021285,3,2,Sysdate-133);
INSERT INTO Details VALUES(7,2038704015,1,2,Sysdate-100);
INSERT INTO Details VALUES(8,2080720872,1,1,Sysdate-116);
INSERT INTO Details VALUES(9,2080720872,1,1,Sysdate-100);
INSERT INTO Details VALUES(10,2080720872,1,2,Sysdate-107);
INSERT INTO Details VALUES(10,2746026090,2,1,Sysdate-78);
INSERT INTO Details VALUES(11,2746021285,1,1,Sysdate-81);
INSERT INTO Details VALUES(12,2203314168,1,1,Sysdate-86);
INSERT INTO Details VALUES(12,2038704015,2,1,Sysdate-60);
INSERT INTO Details VALUES(13,2070397177,1,1,Sysdate-65);
INSERT INTO Details VALUES(14,2266091611,1,1,Sysdate-66);
INSERT INTO Details VALUES(15,2266085816,1,1,Sysdate-50);
INSERT INTO Details VALUES(16,2253010219,1,2,Sysdate-41);
INSERT INTO Details VALUES(16,2070397177,2,2,Sysdate-41);
INSERT INTO Details VALUES(17,2877065073,1,2,Sysdate-36);
INSERT INTO Details VALUES(18,2070397177,1,1,Sysdate-14);
INSERT INTO Details VALUES(19,2746026090,1,1,Sysdate-12);
INSERT INTO Details VALUES(20,2266091611,1,1,'');
INSERT INTO Details VALUES(20,2253010219,2,1,'');

/* Nous avons trouvé une erreur dans l'énoncé, l'isbn 2070367177 au lieu de l'isbn 2070397177*/


/* QUESTION 4 */

SELECT * FROM Ouvrages;
SELECT * FROM Exemplaires;
SELECT * FROM Membres;
SELECT * FROM Emprunts;
SELECT * FROM Details;
SELECT * FROM Genres;

/* QUESTION 5*/ 

ALTER TABLE Membres ENABLE ROW MOVEMENT; 
ALTER TABLE DETAILS ENABLE ROW MOVEMENT; 

/* QUESTION 6*/
/*Ajout d'une colonne 'etat' à la table emprunts*/
ALTER TABLE Emprunts ADD etat char(2) DEFAULT 'EC';
ALTER TABLE Emprunts ADD CONSTRAINT check_emprunts CHECK (etat IN('EC', 'RE'));

/* pour le moment tous les états sont par défaut à EC, il faut mettre une condition si les emprunts ont une date de retour alors mettre RE*/ 
UPDATE Emprunts SET etat='RE' WHERE etat='EC' AND idEmprunt NOT IN (SELECT idEmprunt from Details where dateRetour is NULL);

/* QUESTION 7*/
/*Création d'une table temporaire ’Locations’ permettant de stocker les isbn des ouvrages, le numéro d’exemplaire ainsi que le nombre de fois que cet exemplaire a été emprunté*/
CREATE TABLE Locations AS SELECT isbn, numExemplaire, count(*) AS nblocation FROM Details GROUP BY isbn, numExemplaire;

/*mise à jour de la table Exemplaires, en modifiant l’ ́etat des livres selon le nombre de fois qu'ils ont été emprunté*/
UPDATE Exemplaires SET etat='Bon' WHERE (isbn, numExemplaire) IN (SELECT isbn, numExemplaire FROM Locations WHERE nblocation BETWEEN 11 AND 25);
UPDATE Exemplaires SET etat='Moyen' WHERE (isbn, numExemplaire) IN (SELECT isbn, numExemplaire FROM Locations WHERE nblocation BETWEEN 26 AND 60);
UPDATE Exemplaires SET etat='Mauvais' WHERE (isbn, numExemplaire) IN (SELECT isbn, numExemplaire FROM Locations WHERE nblocation > 60);

/*Suppression des livres en mauvais état*/
DELETE FROM Exemplaires WHERE etat='Mauvais';

/*Suppression de la table temporaire*/
DROP TABLE Locations;


/* QUESTION 8*/
DELETE FROM Exemplaires WHERE etat='Mauvais';


/* QUESTION 9*/
/*liste des ouvrages dont dispose la bibliotheque*/
SELECT * FROM Ouvrages;


/* QUESTION 10*/
SELECT Membres.numMembre, Membres.nom, Membres.prenom, Ouvrages.titre 
FROM Membres, Ouvrages, Emprunts, Details 
WHERE Membres.numMembre = Emprunts.numMembre AND Emprunts.dateEmprunt < Sysdate-14 AND Details.idemprunt=Emprunts.idEmprunt AND Ouvrages.isbn=Details.isbn AND Details.dateRetour IS NULL ; 
/* On selectionne les membres ayant emprunté un ouvrage depuis plus de deux semaines (SYSDATE-14 : 14 jours soit 2 semaines avant la date du
jour), et qui n’ont pas rendu cet ouvrage (dateRetour IS NULL).*/


/* QUESTION 11*/
SELECT genre, COUNT(*) AS nbOuvrages 
FROM  Ouvrages, Exemplaires 
WHERE Ouvrages.isbn=Exemplaires.isbn 
GROUP BY genre;
/*GROUP BY permet de donner le résultat par ordre alphabétique des genres*/


/* QUESTION 12*/
/*moyenne entre la date de retour du livre et la date à laquelle il a été emprunté*/
SELECT AVG(dateRetour - DateEmprunt) AS DureeMoyenne 
FROM Emprunts, Details 
WHERE Emprunts.idEmprunt=Details.idEmprunt AND dateRetour IS NOT NULL;



/* QUESTION 13*/
SELECT genre, AVG(dateRetour - DateEmprunt) AS DureeMoyenne 
FROM Emprunts, Details, Ouvrages 
WHERE Emprunts.idEmprunt=Details.idEmprunt AND dateRetour IS NOT NULL AND Details.isbn=Ouvrages.isbn 
GROUP BY genre;  /*On regroupe le résultat par genre de livre*/


/* QUESTION 14*/
SELECT Exemplaires.isbn 
FROM Emprunts, Details, Exemplaires
WHERE Details.numExemplaire=Exemplaires.numExemplaire AND Details.isbn=Exemplaires.isbn AND Details.idEmprunt=Emprunts.idEmprunt AND MONTHS_BETWEEN(Emprunts.DateEmprunt, Sysdate)<12 /*permet de sélectionner les emprunts effectués dans les 12 mois précédant la date du jour (sysdate)*/
GROUP BY Exemplaires.isbn HAVING COUNT(*)>10;


/* QUESTION 15*/
SELECT Ouvrages.*, Exemplaires.numExemplaire 
FROM Ouvrages, Exemplaires 
WHERE Ouvrages.isbn=Exemplaires.isbn;


/* QUESTION 16 insufficient privileges */
CREATE OR REPLACE VIEW OuvragesEmpruntes AS SELECT Emprunts.numMembre, COUNT(*) AS NombreLivresEmpruntes FROM Emprunts, Details WHERE Details.idEmprunt=Emprunts.idEmprunt AND Details.dateRetour IS NULL GROUP BY Emprunts.numMembre;
/*On trie le résultat en fonction des numéros de membres.*/

/* QUESTION 17 insufficient privileges */
CREATE OR REPLACE VIEW EmpruntsParOuvrage AS SELECT isbn, COUNT(*) AS NbEmprunts FROM Details GROUP BY isbn;


/* QUESTION 18*/
SELECT * FROM Membres ORDER BY nom, prenom;


/* QUESTION 19*/
/*création de la table temporaire*/
CREATE GLOBAL TEMPORARY TABLE EmpruntsResume(isbn NUMBER,numExemplaire NUMBER,NbEmpruntsExemplaire NUMBER,NbEmpruntsOuvrage NUMBER)ON COMMIT PRESERVE ROWS;

/*Insertion des données concernant les exemplaires dans la table temporaire*/
INSERT INTO EmpruntsResume(isbn, numExemplaire, NbEmpruntsExemplaire) SELECT isbn, numExemplaire, COUNT(*) FROM Details GROUP BY isbn, numExemplaire;

/*Insertion des données concernant les ouvrages dans la table temporaire*/
UPDATE EmpruntsResume SET NbEmpruntsOuvrage=(SELECT COUNT(*) FROM Details WHERE Details.isbn=EmpruntsResume.isbn);

/*Terminer la mise à jour */
COMMIT;

/*Supprimer les infos présentes dans cette table*/
DELETE FROM EmpruntsResume;


/* QUESTION 20*/
SELECT Genres.libelle, Ouvrages.titre FROM Genres, Ouvrages WHERE Genres.code=Ouvrages.genre ORDER BY Genres.libelle, Ouvrages.titre;



/**************************************************************/
/********************* PARTIE 3 *******************************/ 
/**************************************************************/

/* QUESTION 1*/
SELECT isbn, numExemplaire, COUNT(*) AS NombreDemprunt FROM Details GROUP BY ROLLUP(isbn, numExemplaire);

/*La requête suivante permet d'obtenir un résultat plus lisible grâce à la fonction DECODE */
SELECT isbn, DECODE(GROUPING(numExemplaire),1,'Tous exemplaires',numExemplaire) AS exemplaire, COUNT(*) AS nombre 
FROM Details 
GROUP BY ROLLUP(isbn, numExemplaire);


/* QUESTION 2*/
SELECT * FROM Exemplaires WHERE NOT EXISTS(SELECT * FROM Details WHERE MONTHS_BETWEEN(sysdate, dateRetour)<3 AND Details.isbn=Exemplaires.isbn AND Details.numExemplaire=Exemplaires.numExemplaire);


/* QUESTION 3*/
SELECT * FROM Ouvrages WHERE isbn NOT IN (SELECT isbn FROM Exemplaires WHERE etat='Neuf');


/* QUESTION 4*/
SELECT isbn, titre FROM Ouvrages WHERE LOWER(titre) LIKE '%mer%';


/* QUESTION 5*/
SELECT DISTINCT auteur FROM Ouvrages WHERE auteur LIKE '% de %';


/* QUESTION 6*/
SELECT isbn, titre, CASE genre WHEN 'BD' THEN 'Jeunesse' WHEN 'INF' THEN 'Professionnel' WHEN 'POL' THEN 'Adulte' WHEN 'REC' THEN 'Tous' WHEN 'ROM' THEN 'Tous' WHEN 'THE' THEN 'Tous' END AS "Public" FROM Ouvrages;


/* QUESTION 7*/
COMMENT ON TABLE Membres IS 'Descriptifs des membres. Possède le synonyme Abonnes';
COMMENT ON TABLE Genres IS 'Definition des genres possibles des ouvrages';
COMMENT ON TABLE Ouvrages IS 'Descriptifs des ouvrages référencés par la bibliothèque';
COMMENT ON TABLE Exemplaires IS 'Définition précise des livres présents dans la bibliothèque';
COMMENT ON TABLE Emprunts IS 'Fiche d''emprunts de livres, toujours associée à un et un seul membre';
COMMENT ON TABLE Details IS 'Chaque ligne correspond à un livre emprunté';


/* QUESTION 8*/
SELECT table_name, comments FROM USER_TAB_COMMENTS WHERE comments IS NOT null;


/* QUESTION 9*/
ALTER TABLE Emprunts DROP CONSTRAINT fk_emprunts;
ALTER TABLE Emprunts ADD CONSTRAINT fk_emprunts FOREIGN KEY (numMembre) REFERENCES Membres(numMembre) initially deferred;


/* QUESTION 10*/
DROP TABLE Details;


/* QUESTION 11*/
FLASHBACK TABLE Details TO BEFORE DROP;


/* QUESTION 12*/
SELECT Ouvrages.isbn, Ouvrages.titre, CASE COUNT(*) WHEN 0 THEN 'Aucun' WHEN 1 THEN 'Peu' WHEN 2 THEN 'Peu' WHEN 3 THEN 'Normal' WHEN 4 THEN 'Normal' WHEN 5 THEN 'Normal' ELSE 'Beaucoup' END AS "NB exemplaires" FROM Ouvrages, Exemplaires WHERE Ouvrages.isbn=Exemplaires.isbn GROUP BY Ouvrages.isbn, Ouvrages.titre;



/**************************************************************/
/********************* PARTIE 4 *******************************/ 
/**************************************************************/


/* QUESTION 1*/
/*curseur qui permet de sélectionner tous les exemplaires de la table Exemplaires*/
DECLARE CURSOR c_nb_emprunts
		IS SELECT * FROM Exemplaires FOR UPDATE OF etat;
		v_etat Exemplaires.etat%type;
		v_nb_emprunts NUMBER;
	BEGIN 
	/*pour chaque exemplaires du curseur*/
	FOR v_exemplaire in c_nb_emprunts LOOP
		/*calcul du nombre d''emprunts pour l''exemplaire*/
		SELECT count(*) INTO v_nb_emprunts FROM Details WHERE Details.isbn=v_exemplaire.isbn AND Details.numExemplaire = v_exemplaire.numExemplaire;
		/*en fonction du nombre d''emprunts, un etat est choisi*/
		IF (v_nb_emprunts <= 10) THEN
			v_etat := 'Neuf';		
			ELSE IF (v_nb_emprunts <= 25) THEN
				v_etat := 'Bon';
				ELSE IF (v_nb_emprunts <= 40) THEN
					v_etat := 'Moyen';
					ELSE
						v_etat := 'Mauvais';
					END IF;
				END IF;
		END IF;
		/*l'état de l'exemplaire est mis à jour*/
		UPDATE Exemplaires SET etat = v_etat WHERE CURRENT OF c_nb_emprunts;
	END LOOP;
END;
/

/* QUESTION 2*/ 
DECLARE
	/*curseur sélectionnant uniquement les membres dont l''adhésion a expiré depuis 2 ans ou plus*/
	CURSOR c_membre 
	IS SELECT * FROM Membres
	WHERE MONTHS_BETWEEN(SYSDATE, ADD_MONTHS(dateAdhesion, duree)) > 24;
	v_nombre NUMBER;
	n_nombre NUMBER;
BEGIN	
	/*pour chaque membre dans le curseur*/
	FOR v_membre IN c_membre LOOP
		/*vérification du nombre de livres empruntés et non rendus*/
		SELECT count(*) INTO v_nombre
		FROM Details, Emprunts
		WHERE dateRetour IS NULL AND Details.idEmprunt = Emprunts.idEmprunt AND Emprunts.numMembre = v_membre.numMembre;
		/*si tous les livres ont été rendu:*/
		IF (v_nombre = 0) THEN
			/*on regarde si le membre a déjà emprunté des livres*/
			SELECT count(*) INTO n_nombre FROM Emprunts WHERE numMembre = v_membre.numMembre;

			IF (n_nombre != 0) THEN
				/*si le membre a déjà emprunté des livres on remplace son numéro de membre par NULL dan la table Emprunts*/
				UPDATE Emprunts SET numMembre = NULL
				WHERE numMembre = v_membre.numMembre;
			END IF;
			/*on supprime le membre de la table Membres*/
			DELETE FROM Membres WHERE numMembre = v_membre.numMembre;
			/*validation de la transaction*/
			COMMIT;
		END IF;
	END LOOP;
END;
/

/* QUESTION 3*/

/*Activation du package DNBM_OUTPUT qui permet d'écrire des messages dans un buffer d'écriture*/
Set serveroutput on

DECLARE
	/*Curseur triant les membres par ordre croissant en fonction du nombre d''emprunts*/
	CURSOR c_mauvais IS SELECT Emprunts.numMembre, count(*)
	FROM Emprunts , Details 
	WHERE Emprunts.idEmprunt = Details.idEmprunt AND MONTHS_BETWEEN(SYSDATE, dateEmprunt) <= 10 
	GROUP BY Emprunts.numMembre
	ORDER BY 2 ASC;

	/*Curseur triant les membres par ordre décroissant en fonction du nombre d''emprunts*/
	CURSOR c_meilleur IS SELECT Emprunts.numMembre, count(*)
	FROM Emprunts , Details 
	WHERE  Emprunts.idEmprunt = Details.idEmprunt  AND MONTHS_BETWEEN(SYSDATE, dateEmprunt) <= 10 
	GROUP BY Emprunts.numMembre
	ORDER BY 2 DESC;

	v_membre Membres%ROWTYPE;
	v_numMembre c_meilleur%ROWTYPE;
	i NUMBER;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Les 3 membres ayant emprunté le plus d''ouvrages au cours des 10 derniers mois :');
	OPEN c_meilleur;
	/*selection des 3 premières lignes du 2ème curseur*/
	FOR i IN 1..3 LOOP
		FETCH c_meilleur INTO v_numMembre;
		SELECT * INTO v_membre
		FROM Membres
		WHERE numMembre = v_numMembre.numMembre;
	DBMS_OUTPUT.PUT_LINE(i||') numero de membre :'||v_membre.numMembre ||', nom : '||v_membre.nom);
	END LOOP;
	CLOSE c_meilleur;
	DBMS_OUTPUT.PUT_LINE('Les 3 membres ayant emprunté le moins d''ouvrages au cours des 10 derniers mois : ');
	OPEN c_mauvais;
	/*selection des 3 premières lignes du 1er curseur*/
	FOR i IN 1..3 LOOP
		FETCH c_mauvais INTO v_numMembre;
		SELECT * INTO v_membre
		FROM Membres
		WHERE numMembre = v_numMembre.numMembre;
	DBMS_OUTPUT.PUT_LINE(i||') numero de membre :'||v_membre.numMembre ||', nom : '||v_membre.nom);
	END LOOP;
	CLOSE c_mauvais;
END;
/


/* QUESTION 4*/

Set serveroutput on

DECLARE
	/*curseur qui renseigne le nombre d''emprunts pour chaque ouvrage, et les classe par ordre décroissant*/
	CURSOR c_ouvrages IS SELECT isbn, count(*) AS nbEmprunts
	FROM Details
	GROUP BY isbn
	ORDER BY 2 DESC;
v_ouvrages c_ouvrages%ROWTYPE;
i NUMBER;
BEGIN 
	OPEN c_ouvrages;
	DBMS_OUTPUT.PUT_LINE('Les cinq ouvrages les plus empruntés sont :');
	/*selection des 5 premières lignes du curseur*/
	FOR i IN 1..5 LOOP
		FETCH c_ouvrages INTO v_ouvrages;
		EXIT WHEN c_ouvrages%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(i||') isbn :' || v_ouvrages.isbn);
	END LOOP;
	CLOSE c_ouvrages;
END;
/


/* QUESTION 5*/

Set serveroutput on;

DECLARE
	/*curseur sélectionnant tous les membres de la table Membres*/
	CURSOR c_membres IS SELECT * FROM Membres;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Liste des membres dont l''adhesion va expirer :');
	FOR v_membres IN c_membres LOOP
		/*pour chaque élément du curseur on regarde si son adhésion a expiré ou va expiré dans les 30 jours
		si c''est le cas l''afficher à l''écran*/
		IF (ADD_MONTHS(v_membres.dateAdhesion, v_membres.duree) < SYSDATE + 30) THEN
			DBMS_OUTPUT.PUT_LINE('Numero de membres : ' || v_membres.numMembre || ', nom '|| v_membres.nom);
		END IF;
	END LOOP;
END;
/

/* QUESTION 6 a*/

/*Ajout des nouvelles colonnes dans la table Exemplaires*/
ALTER TABLE Exemplaires ADD nombreEmprunts NUMBER(3) DEFAULT 0;
ALTER TABLE Exemplaires ADD dateCalculEmprunts DATE DEFAULT SYSDATE;

/*Pour l'instant la table n'est pas à jour, le calcul du nombre d'emprunt est à 0 et la date de calcul est par défaut à la date du jour, il faut faire une mise à jour*/

UPDATE Exemplaires SET dateCalculEmprunts = (SELECT min(dateEmprunt) FROM Emprunts , Details 
	WHERE Emprunts.idEmprunt = Details.idEmprunt AND Details.isbn = Exemplaires.isbn AND Details.numExemplaire = Exemplaires.numExemplaire);

UPDATE Exemplaires SET dateCalculEmprunts = SYSDATE WHERE dateCalculEmprunts IS NULL ;

COMMIT;

/* QUESTION 6 b*/

DECLARE
	/*curseur contenant tous les exemplaires qui vont avoir leur champs nombreEmprunts et dateCalculEmprunts mis à jour*/
	CURSOR c_exemplaires IS
		SELECT * FROM Exemplaires
		FOR UPDATE OF nombreEmprunts, dateCalculEmprunts;
	
	v_nombreEmprunts Exemplaires.nombreEmprunts%TYPE;
BEGIN
	FOR v_exemplaires IN c_exemplaires LOOP
		/*pour chaque élément du curseur:
		on récupère le nombre d'emprunts de l'exemplaire*/
		SELECT count(*) INTO v_nombreEmprunts
		FROM Details, Emprunts
		WHERE Details.idEmprunt = Emprunts.idEmprunt AND isbn = v_exemplaires.isbn AND numExemplaire = v_exemplaires.numExemplaire AND dateEmprunt >= v_exemplaires.dateCalculEmprunts;
		/*mise à jour du nombre d'emprunts de l'exemplaire*/
		UPDATE Exemplaires SET nombreEmprunts = nombreEmprunts + v_nombreEmprunts
		WHERE CURRENT OF c_exemplaires;
		/*mise à jour de l'état de l'exemplaire*/		
		UPDATE Exemplaires SET etat = 'Neuf' WHERE nombreEmprunts <= 10;
		UPDATE Exemplaires SET etat = 'Bon' WHERE nombreEmprunts BETWEEN 11 AND 25;
		UPDATE Exemplaires SET etat = 'Moyen' WHERE nombreEmprunts BETWEEN 26 AND 40;
		UPDATE Exemplaires SET etat = 'Mauvais' WHERE nombreEmprunts >= 41;
	END LOOP;
	COMMIT;
END;
/

/* QUESTION 7*/

DECLARE
	v_nbMoyenMauvais NUMBER;
	v_total NUMBER;
BEGIN
	/* calcul du rapport d'exemplaires dans un état moyen ou moyen sur le nombre total d'exemplaires*/
	SELECT count(*) INTO v_nbMoyenMauvais
	FROM Exemplaires
	WHERE etat in ('Moyen','Mauvais');
	
	SELECT count(*) INTO v_total
	FROM Exemplaires;
	
	IF (v_nbMoyenMauvais > v_total / 2) THEN
		/*suppression de la contrainte existante*/
		EXECUTE IMMEDIATE 'ALTER TABLE Exemplaires ADD constraint ck_exemplaire_etat CHECK IN (''Neuf'',''Bon'',''Moyen'',''Mauvais'',''Douteux'')';
		/*mise à jour du nombre d''exemplaires*/
		UPDATE Exemplaires SET etat ='Douteux'
		WHERE nombreEmprunts BETWEEN 41 and 60;
		/*validation de la transaction*/
		COMMIT;
	END IF;
END;
/


/* QUESTION 8*/
/*supprimer tous les membres qui n'ont pas effectué d'emprunts depuis 3 ans*/
DELETE FROM Membres WHERE numMembre IN (SELECT DISTINCT numMembre FROM Emprunts GROUP BY numMembre HAVING MAX(dateEmprunt) < ADD_MONTHS(SYSDATE, -36));

/* QUESTION 9*/
/*14 caractères car 4 espaces en plus (ajout d'espace tous les deux numéros) */
ALTER TABLE Membres MODIFY portable VARCHAR2(14);
ALTER TABLE Membres DROP CONSTRAINT check_06;

DECLARE
	/*curseur sélectionnant le numéro de portable de tous les membres*/
	CURSOR c_membre IS
		SELECT portable FROM Membres
		FOR UPDATE OF portable;

	v_portable VARCHAR2(14);
BEGIN
	/*pour chaque numéro de portable contenu dans le curseur: ajout d''espace tous les 2 numéros*/
	FOR v_membre IN c_membre LOOP
		IF (INSTR(v_membre.portable, ' ') != 2) THEN
			v_portable := SUBSTR(v_membre.portable, 1, 2)||' '||SUBSTR(v_membre.portable, 3, 2)||' '||SUBSTR(v_membre.portable, 5, 2)||' '||SUBSTR(v_membre.portable, 7, 2)||' '||SUBSTR(v_membre.portable, 9, 2);
			UPDATE Membres SET portable = v_portable
			WHERE CURRENT OF c_membre;
		END IF;
	END LOOP;
END;
/
/*contrainte obligeant la présence d'espace tous les 2 numéros dans le numéro de portable*/
ALTER TABLE Membres ADD CONSTRAINT check_portable CHECK (REGEXP_LIKE(portable, '^06 [0-9]{2} [0-9]{2} [0-9]{2} [0-9]{2}$')); 


/**************************************************************/
/********************* PARTIE 5 *******************************/ 
/**************************************************************/

/* QUESTION 1 */
/*passage en paramètre d'un numéro de membre*/
CREATE OR REPLACE FUNCTION FinValidite(v_numMembre in NUMBER) RETURN DATE IS 	
	date_fin_validite DATE;
BEGIN
	/*calcul de la date de fin de validité du membre passé en paramètre*/ 
	SELECT ADD_MONTHS(dateAdhesion, duree) INTO date_fin_validite
	FROM Membres
	WHERE numMembre = v_numMembre;
	/*renvoie la date de fin de validité*/
	Return date_fin_validite;  
END;
/



/*test de la fonction*/ 
Set serveroutput on;
begin 
	DBMS_OUTPUT.PUT_LINE('fin de validite: ' || FinValidite(10));
end;
/



/* QUESTION 2*/
/*passage en paramètre d'un numéro de membre*/
CREATE OR REPLACE FUNCTION AdhesionJour(v_numMembre in NUMBER) RETURN BOOLEAN AS  
BEGIN  
	/*si la date de fin de validité n''a pas dépassé la date du jour -> retourner vrai*/
	IF (FinValidite(v_numMembre) >= SYSDATE) THEN
		RETURN TRUE;
	ELSE 
		RETURN FALSE;
	END IF;
END; 
/


/*test de la fonction*/ 

Set serveroutput on;
DECLARE
	resultat BOOLEAN := AdhesionJour(10);
begin  
	DBMS_OUTPUT.PUT_LINE('adhesion possible: '|| case when resultat
													then 'Oui' 
													else 'Non' 
												end);
end;
/


/* QUESTION 3*/
/*prend en paramètre un numéro d'ISBN et un numéro d'exemplaire*/
CREATE OR REPLACE PROCEDURE RetourExemplaire(v_isbn in NUMBER, v_numExemplaire in NUMBER) AS
BEGIN
	/*Mise à jour de la date de retour au jour courant*/
	UPDATE Details SET dateRetour=Sysdate
	WHERE dateRetour is NULL
	AND isbn=v_isbn AND numExemplaire=v_numExemplaire;
END;
/

/* QUESTION 4*/ 
CREATE OR REPLACE PROCEDURE PurgeMembres AS
BEGIN
	/*suppression des membres dont l'adhésion n'a pas été renouvelée depuis 3ans*/
	DELETE FROM Membres
	WHERE ( trunc(SYSDATE(), 'YYYY') - trunc(ADD_MONTHS(dateAdhesion,duree),'YYYY'))>3;

END;
/


/* QUESTION 5*/
CREATE OR REPLACE FUNCTION MesureActivite(v_periode in NUMBER) RETURN NUMBER IS 
	v_numMembre NUMBER;
BEGIN
	/*compte le nombre d'emprunts pour chaque membre dans la table Emprunts en triant par ordre décroissant
	et il faut que la durée entre la date d'emprunt et la date du jour soit inférieure à la période entrée en paramètre*/
	SELECT count(*) INTO v_numMembre FROM Emprunts 
	WHERE MONTHS_BETWEEN(SYSDATE, dateEmprunt) < v_periode AND rownum = 1 
	GROUP BY (numMembre) 
	ORDER BY count(*) DESC;
	/*renvoie la première ligne de la liste*/
	Return v_numMembre;
END;
/

/* QUESTION 6*/
CREATE OR REPLACE FUNCTION EmpruntMoyen(v_numMembre in NUMBER) RETURN NUMBER IS
	v_DureeMoy NUMBER;
BEGIN
	/*calcul de la moyenne des différences entre dates de retour et dates d''emprunts*/
	SELECT AVG(Details.dateRetour-Emprunts.dateEmprunt+1) INTO v_DureeMoy
	FROM Emprunts, Details
	WHERE Emprunts.numMembre = v_numMembre
	AND Details.idEmprunt = Emprunts.idEmprunt
	/*vérifier que l''ouvrages a bien été rendu*/
	AND Details.dateRetour is NOT NULL;
	/*renvoie la durée moyenne d''emprunt pour le membre entré en paramètre*/
	RETURN v_DureeMoy;
END;
/


/*test de la fonction*/ 
Set serveroutput on;
begin 
	DBMS_OUTPUT.PUT_LINE('durée moyenne: ' || EmpruntMoyen(2));
end;
/

/* QUESTION 7*/

CREATE OR REPLACE FUNCTION DureeMoyenne(v_isbn in NUMBER, v_numExemplaire in NUMBER default NULL) 
RETURN NUMBER IS
  v_duree NUMBER;
BEGIN
  IF (v_numExemplaire is NULL) THEN
  	/*si uniquement l''ISBN est entré en paramètre:*/
    /*moyenne des différences entre les dates de retour et dates d''emprunt
    de l'ouvrage correspondant à l'isbn entré en paramètre*/
    SELECT AVG(Details.dateRetour-Emprunts.dateEmprunt+1)
    INTO v_duree
    FROM Emprunts, Details
    WHERE Emprunts.idEmprunt=Details.idEmprunt
    AND Details.isbn=v_isbn
    AND Details.dateRetour is NOT NULL;
  ELSE
  	/*si l'ISBN et le numéro d'exemplaire sont entrés en paramètre:*/
    /*moyenne des différences entre les dates de retour et dates d'emprunt
    de l'ouvrage correspondant à l'isbn et le numéro d'exemplaire entrés en paramètre*/
    SELECT AVG(Details.dateRetour-Emprunts.dateEmprunt+1)
    INTO v_duree
    FROM Emprunts, Details
    WHERE Emprunts.idEmprunt=Details.idEmprunt
    AND Details.isbn=v_isbn
    AND Details.numExemplaire=v_numExemplaire
    AND Details.dateRetour is NOT NULL;
  END IF;
  RETURN v_duree;
END;
/

/*test de la fonction*/ 

Set serveroutput on;
begin 
	DBMS_OUTPUT.PUT_LINE('durée moyenne: ' || DureeMoyenne(2070397177,2));
end;
/

/* QUESTION 8*/

CREATE OR REPLACE PROCEDURE MAJEtatExemplaire IS
  /* le curseur contient tous les exemplaires contenus dans la table Exemplaires*/
  CURSOR c_exemplaire IS SELECT * FROM Exemplaires 
    FOR UPDATE OF NombreEmprunts, DateCalculEmprunts;
  v_nombre NUMBER;
BEGIN
  FOR v_exemplaire IN c_exemplaire LOOP
  	/*Pour chaque exemplaire du curseur, on regarde dans la table emprunts si des emprunts ont été réalisés pour l''exemplaire donné 
  	et non mis jour dans le champs nombreEmprunts de la table Exemplaires.*/
    SELECT count(*) INTO v_nombre
      FROM Details, Emprunts
      WHERE Details.idEmprunt=Emprunts.idEmprunt
      AND isbn=v_Exemplaire.isbn 
      AND numExemplaire=v_Exemplaire.numExemplaire
      AND dateEmprunt>=v_Exemplaire.DateCalculEmprunts;
    UPDATE Exemplaires SET 
      nombreEmprunts=nombreEmprunts+v_nombre,
      DateCalculEmprunts=sysdate 
      WHERE CURRENT OF c_exemplaire;
  END LOOP;
  /*Mise à jour de l''état des exemplaires */
  UPDATE Exemplaires SET etat='Neuf' WHERE nombreEmprunts<=10;
  UPDATE Exemplaires SET etat='Bon' 
    WHERE nombreEmprunts BETWEEN 11 AND 25;
  UPDATE Exemplaires SET etat='Moyen' 
    WHERE nombreEmprunts BETWEEN 26 AND 40;
  UPDATE Exemplaires SET etat='Douteux' 
    WHERE nombreEmprunts BETWEEN 41 AND 60;
  UPDATE Exemplaires SET etat='Mauvais' 
    WHERE nombreEmprunts >=61;
  COMMIT;
END;
/

--permet de planifier l'exécution de la fonction de façon régulière.
-- Ne marche que si l'on possède les privilèges
BEGIN
  DBMS_SCHEDULER.CREATE_JOB('CalculEtatExemplaire',
  'MAJEtatExemplaire',systimestamp, 'systimestamp+14');
END;
/



/* QUESTION 9*/

CREATE OR REPLACE FUNCTION AjouteMembre 
(v_nom in VARCHAR2, v_prenom in VARCHAR2, v_adresse in VARCHAR2, v_dateAdhesion in DATE, v_duree in NUMBER, v_portable in VARCHAR2)  
RETURN NUMBER AS 
  v_numMembre NUMBER;
BEGIN
  /*ajout du membre dans la table Membres avec les informations entrées en paramètres*/
  INSERT INTO Membres (numMembre, nom, 
    prenom, adresse, DateAdhesion, Duree, portable) 
  VALUES (incrementation_membre.nextval, v_nom, 
    v_prenom, v_adresse, v_DateAdhesion, v_duree, v_portable) 
  RETURNING  numMembre INTO v_numMembre;
  RETURN v_numMembre;
END;
/

/*test de la fonction*/ 
set serveroutput on
DECLARE
  v_numMembre NUMBER;
BEGIN
  v_numMembre := AjouteMembre('MARTIN','Roger','17 rue du port',sysdate,3,'06 09 11 11 11');
  DBMS_OUTPUT.PUT_LINE('Numero du nouveau membre: '||v_numMembre);
END;
/



/* QUESTION 10*/

CREATE OR REPLACE PROCEDURE SupprimeExemplaire(v_isbn in NUMBER, v_numExemplaire in NUMBER) AS
BEGIN
	/*suppression dans la table Exemplaires correspondant à l''exemplaire avec l'isbn et num d'exemplaire entrés en paramètre*/
  DELETE FROM Exemplaires 
    WHERE isbn=v_isbn AND numExemplaire=v_numExemplaire;
  IF (SQL%ROWCOUNT=0) THEN
  	/*si l'exemplaire voulu n'existe pas on lève une exception*/
    RAISE NO_DATA_FOUND;
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  	/*l'exception renvoie un message et un code d'erreur*/
    raise_application_error(-20001, 'L''exemplaire entré n''est pas connu') ;
END ;
/

/* QUESTION 11*/

-- il faut savoir l'id max qui existe pour les emprunts
SELECT MAX(idEmprunt) FROM Emprunts;

--afin de créer une séquence pour que ça commence à la suite
CREATE SEQUENCE sequence_emprunts START WITH 20;

CREATE OR REPLACE PROCEDURE EmpruntExpress(v_numMembre NUMBER, v_isbn NUMBER, v_numExemplaire NUMBER) 
AS v_NumEmprunt NUMBER;
BEGIN
	/*insertion de l''emprunt dans la table Emprunts à partir des infos entrées en paramètre*/
  INSERT INTO Emprunts (idEmprunt, numMembre, DateEmprunt)
    VALUES(sequence_emprunts.nextval, v_numMembre, SYSDATE)
    RETURNING idEmprunt INTO v_NumEmprunt;
    /*insertion de l''emprunt dans la table Details à partir des infos entrées en paramètre*/
  INSERT INTO Details(idEmprunt, isbn, numeroEmprunt, numExemplaire)
    VALUES(v_NumEmprunt, v_isbn, 1, v_numExemplaire);
END;
/

/* QUESTION 12*/
/*Définition de l'en-tête du package Livre*/
CREATE OR REPLACE PACKAGE Livre AS
	FUNCTION FinValidite(v_numMembre in NUMBER) RETURN DATE;
	FUNCTION AdhesionJour(v_numMembre in NUMBER) RETURN BOOLEAN;
	PROCEDURE RetourExemplaire(v_isbn in NUMBER, v_numExemplaire in NUMBER);
	PROCEDURE PurgeMembres;
	FUNCTION MesureActivite(v_periode in NUMBER) RETURN NUMBER;
	FUNCTION EmpruntMoyen(v_numMembre in NUMBER) RETURN NUMBER;
	FUNCTION DureeMoyenne(v_isbn in NUMBER, v_numExemplaire in NUMBER default NULL) RETURN NUMBER;
 	PROCEDURE MAJEtatExemplaire;
 	FUNCTION AjouteMembre (v_nom in VARCHAR2, v_prenom in VARCHAR2, v_adresse in VARCHAR2, v_dateAdhesion in DATE, v_duree in NUMBER, v_portable in VARCHAR2) RETURN NUMBER;
	PROCEDURE SupprimeExemplaire(v_isbn in NUMBER, v_numExemplaire in NUMBER); 
	PROCEDURE empruntExpress(v_numMembre NUMBER, v_isbn NUMBER, v_numExemplaire NUMBER);

END Livre;
/


/*corps du package Livre*/
CREATE OR REPLACE PACKAGE BODY Livre AS

	/*Fonction FinValidite*/
	FUNCTION FinValidite(v_numMembre in NUMBER) RETURN DATE IS 	
		date_fin_validite DATE;
	BEGIN  
		SELECT ADD_MONTHS(dateAdhesion, duree) INTO date_fin_validite
		FROM Membres
		WHERE numMembre = v_numMembre;
		Return date_fin_validite;  
	END;
	

	/*Fonction AdhesionAJour*/
	FUNCTION AdhesionJour(v_numMembre in NUMBER) RETURN BOOLEAN AS  
	BEGIN  
		IF (FinValidite(v_numMembre) >= SYSDATE) THEN
			RETURN TRUE;
		ELSE 
			RETURN FALSE;
		END IF;
	END;

	/*Procédure RetourExemplaire*/	
	PROCEDURE RetourExemplaire(v_isbn in NUMBER, v_numExemplaire in NUMBER) AS
	BEGIN
		UPDATE Details SET dateRetour=Sysdate
		WHERE dateRetour is NULL
		AND isbn=v_isbn AND numExemplaire=v_numExemplaire;
	END;

	/*Procédure PurgeMembres*/
	PROCEDURE PurgeMembres AS
	BEGIN
		DELETE FROM Membres
		WHERE ( trunc(SYSDATE(), 'YYYY') - trunc(ADD_MONTHS(dateAdhesion,duree),'YYYY'))>3;

	END;


	/*Fonction MesureActivite*/
	FUNCTION MesureActivite(v_periode in NUMBER) RETURN NUMBER IS 
		v_numMembre NUMBER;
	BEGIN
		SELECT count(*) INTO v_numMembre FROM Emprunts 
		WHERE MONTHS_BETWEEN(SYSDATE, dateEmprunt) < v_periode AND rownum = 1 
		GROUP BY (numMembre) 
		ORDER BY count(*) DESC;
		Return v_numMembre;
	END;

	/* Fonction Emprunt Moyen */
	FUNCTION EmpruntMoyen(v_numMembre in NUMBER) RETURN NUMBER IS
		v_DureeMoy NUMBER;
	BEGIN
		SELECT AVG(Details.dateRetour-Emprunts.dateEmprunt+1) INTO v_DureeMoy
		FROM Emprunts, Details
		WHERE Emprunts.numMembre = v_numMembre
		AND Details.idEmprunt = Emprunts.idEmprunt
		AND Details.dateRetour is NOT NULL;
		RETURN v_DureeMoy;
	END;


	/*Fonction DureeMoyenne*/
	FUNCTION DureeMoyenne(v_isbn in NUMBER, v_numExemplaire in NUMBER default NULL) 
	RETURN NUMBER IS
	  v_duree NUMBER;
	BEGIN
	  IF (v_numExemplaire is NULL) THEN
	    SELECT AVG(Details.dateRetour-Emprunts.dateEmprunt+1)
	    INTO v_duree
	    FROM Emprunts, Details
	    WHERE Emprunts.idEmprunt=Details.idEmprunt
	    AND Details.isbn=v_isbn
	    AND Details.dateRetour is NOT NULL;
	  ELSE
	    SELECT AVG(Details.dateRetour-Emprunts.dateEmprunt+1)
	    INTO v_duree
	    FROM Emprunts, Details
	    WHERE Emprunts.idEmprunt=Details.idEmprunt
	    AND Details.isbn=v_isbn
	    AND Details.numExemplaire=v_numExemplaire
	    AND Details.dateRetour is NOT NULL;
	  END IF;
	  RETURN v_duree;
	END;

	/* Procedure MajEtatExemplaire */

	PROCEDURE MAJEtatExemplaire IS
	  CURSOR c_exemplaire IS SELECT * FROM Exemplaires 
	    FOR UPDATE OF NombreEmprunts, DateCalculEmprunts;
	  v_nombre NUMBER;
	BEGIN
	  FOR v_exemplaire IN c_exemplaire LOOP
	    SELECT count(*) INTO v_nombre
	      FROM Details, Emprunts
	      WHERE Details.idEmprunt=Emprunts.idEmprunt
	      AND isbn=v_Exemplaire.isbn 
	      AND numExemplaire=v_Exemplaire.numExemplaire
	      AND dateEmprunt>=v_Exemplaire.DateCalculEmprunts;
	    UPDATE Exemplaires SET 
	      nombreEmprunts=nombreEmprunts+v_nombre,
	      DateCalculEmprunts=sysdate 
	      WHERE CURRENT OF c_exemplaire;
	  END LOOP;
	  UPDATE Exemplaires SET etat='Neuf' WHERE nombreEmprunts<=10;
	  UPDATE Exemplaires SET etat='Bon' 
	    WHERE nombreEmprunts BETWEEN 11 AND 25;
	  UPDATE Exemplaires SET etat='Moyen' 
	    WHERE nombreEmprunts BETWEEN 26 AND 40;
	  UPDATE Exemplaires SET etat='Douteux' 
	    WHERE nombreEmprunts BETWEEN 41 AND 60;
	  UPDATE Exemplaires SET etat='Mauvais' 
	    WHERE nombreEmprunts >=61;
	  COMMIT;
	END;


	/* Fonction AjouteMembre */

	FUNCTION AjouteMembre 
	(v_nom in VARCHAR2, v_prenom in VARCHAR2, v_adresse in VARCHAR2, v_dateAdhesion in DATE, v_duree in NUMBER, v_portable in VARCHAR2)  
	RETURN NUMBER AS 
	  v_numMembre NUMBER;
	BEGIN
	  INSERT INTO Membres (numMembre, nom, 
	    prenom, adresse, DateAdhesion, Duree, portable) 
	  VALUES (incrementation_membre.nextval, v_nom, 
	    v_prenom, v_adresse, v_DateAdhesion, v_duree, v_portable) 
	  RETURNING  numMembre INTO v_numMembre;
	  RETURN v_numMembre;
	END;


	/* Procedure SupprimeExemplaire */

	PROCEDURE SupprimeExemplaire(v_isbn in NUMBER, v_numExemplaire in NUMBER) AS
	BEGIN
	  DELETE FROM Exemplaires 
	    WHERE isbn=v_isbn AND numExemplaire=v_numExemplaire;
	  IF (SQL%ROWCOUNT=0) THEN
	    RAISE NO_DATA_FOUND;
	  END IF;
	EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	    raise_application_error(-20001, 'L''exemplaire entré n''est pas connu') ;
	END ;

	/* PROCEDURE EmpruntExpress */

	PROCEDURE EmpruntExpress(v_numMembre NUMBER, v_isbn NUMBER, v_numExemplaire NUMBER) 
	AS v_NumEmprunt NUMBER;
	BEGIN
	  INSERT INTO Emprunts (idEmprunt, numMembre, DateEmprunt)
	    VALUES(sequence_emprunts.nextval, v_numMembre, SYSDATE)
	    RETURNING idEmprunt INTO v_NumEmprunt;
	  INSERT INTO Details(idEmprunt, isbn, numeroEmprunt, numExemplaire)
	    VALUES(v_NumEmprunt, v_isbn, 1, v_numExemplaire);
	END;

END Livre;
/

/**************************************************************/
/********************* PARTIE 6 *******************************/ 
/**************************************************************/

/* QUESTION 1*/

/*on spécifie que la contrainte d'intégrité doit être validée au niveau de la transaction*/
ALTER TABLE Exemplaires DROP CONSTRAINT fk_isbn;
ALTER TABLE Exemplaires ADD CONSTRAINT fk_isbn FOREIGN KEY(isbn) REFERENCES ouvrages(isbn) initially deferred;

/*création d'une table qui va dénombrer les exemplaires pour chaque ouvrage*/
CREATE TABLE QuantiteExemplaires (isbn NUMBER, quantite NUMBER default 0);

/*initialise de la table avec les données actuelles de la base*/
INSERT INTO QuantiteExemplaires (isbn, quantite)
SELECT isbn, count(*) FROM Exemplaires GROUP BY isbn;
  
/*ce déclencheur est défini pour compléter la table QuantiteExemplaires*/
CREATE OR REPLACE TRIGGER apres_insertion_Exemplaires
  AFTER INSERT ON Exemplaires
  FOR EACH ROW
BEGIN
	/*si la ligne existe déjà, la mettre à jour*/
  UPDATE QuantiteExemplaires SET quantite=quantite+1 WHERE isbn=:new.isbn;
  IF (SQL%ROWCOUNT=0) THEN
  	/*si la ligne n''existe pas créer une nouvelle ligne*/
    INSERT INTO QuantiteExemplaires(isbn, quantite) VALUES (:new.isbn, 1);
  END IF;
END;
/

/*déclencheur relatif à la suppression*/ 
CREATE OR REPLACE TRIGGER apres_suppresion_Exemplaires 
  /*Après suppression d''un exemplaire dans la table Exemplaires*/
  AFTER DELETE ON Exemplaires 
  FOR EACH ROW
DECLARE
	v_nombre NUMBER;
BEGIN
  SELECT quantite INTO v_nombre FROM QuantiteExemplaires WHERE isbn=:old.isbn;
  IF (v_nombre=1) THEN
  	/*si dans la table QuantiteExemplaires la quantité d'exemplaire pour l'ouvrage d'intérêt est égal à 1
  	alors supprimer l'ouvrage de la table Ouvrages*/
    DELETE FROM Ouvrages WHERE isbn= :old.isbn ;
	DELETE FROM QuantiteExemplaires WHERE isbn= :old.isbn ;
  ELSE
  	/*sinon on décrémente le nombre d''exemplaires disponible pour cet ouvrage de la table QuantiteExemeplaires*/
    UPDATE QuantiteExemplaires SET quantite=quantite-1 WHERE isbn=:old.isbn;
 END IF;
END ;
/


/* QUESTION 2*/
CREATE OR REPLACE TRIGGER apres_insertion_Emprunts
	/*après insertion dans la table Emprunts*/
  AFTER INSERT ON Emprunts
  FOR EACH ROW
DECLARE
  v_finValid DATE;
BEGIN
	/*on extrait la date de fin de validité du membre ayant réalisé l''emprunt*/
  SELECT ADD_MONTHS(dateAdhesion, Duree) INTO v_finValid
  FROM Membres
  WHERE numMembre= :new.numMembre;
  /*Si la date de fin de validité inférieur à la date du jour on lève une exception*/
  IF (v_finValid<sysdate) THEN
    RAISE_APPLICATION_ERROR(-20002,'Adhesion non valide');
  END IF;
END ;
/

/* QUESTION 3*/
CREATE OR REPLACE TRIGGER avant_MAJ_Emprunts
/*avant mise à jour du numéro de membre dans la table Emprunts*/
BEFORE UPDATE OF numMembre ON Emprunts
	FOR EACH ROW
BEGIN
	/*Si le nouveau numéro de membre ne correspond pas à l''ancien on lève une exception*/
	IF(:new.numMembre != :old.numMembre) THEN
		RAISE_APPLICATION_ERROR(-20003,'Opération interdite');
	END IF;
END;
/



/* QUESTION 4*/
CREATE OR REPLACE TRIGGER apres_MAJ_Details
	/*si l'isbn ou l'exemplaire a été mis à jour dans la table Détails*/
  AFTER UPDATE ON Details
  FOR EACH ROW
  WHEN ((old.isbn != new.isbn) OR (old.numExemplaire != new.numExemplaire))
BEGIN
	/*si l''isbn a été modifié*/
  IF ( :old.isbn != :new.isbn) THEN
  		/*on lève une exception*/
      RAISE_APPLICATION_ERROR(-20041, 'Impossible de changer d''ouvrage') ;
  ELSE
  	/*si le numéro d''exemplaire a été modifié*/
  	/*on lève une exception*/
      RAISE_APPLICATION_ERROR(-20042,'Impossible de changer d''exemplaire') ;
    END IF;
END ;
/

/* QUESTION 5*/
CREATE OR REPLACE TRIGGER avant_ins_MAJ_Exemplaires
	/*Avant de mettre à jour ou d’insérer une nouvelle valeur dans le champs nombreEmprunts*/
  BEFORE INSERT OR UPDATE OF nombreEmprunts ON Exemplaires
  FOR EACH ROW
BEGIN
  IF ( :new.nombreEmprunts <= 10) THEN
    :new.etat := 'Neuf' ;
  END IF;
  IF ( :new.nombreEmprunts BETWEEN 11 AND 25) THEN
    :new.etat := 'Bon' ;
  END IF;
  IF ( :new.nombreEmprunts BETWEEN 26 AND 40) THEN
    :new.etat := 'Moyen' ;
  END IF;
  IF ( :new.nombreEmprunts BETWEEN 41 AND 60) THEN
    :new.etat := 'Douteux' ;
  END IF;
  IF ( :new.nombreEmprunts >= 61) THEN
    :new.etat := 'Mauvais' ;
  END IF;
END ;
/

/* QUESTION 6*/

CREATE OR REPLACE TRIGGER trg_suppr_detail
	/*après avoir supprimer une ligne dans la table Details*/
	AFTER DELETE ON Details
	FOR EACH ROW
DECLARE
	v_isbn NUMBER;
	v_numExemplaire NUMBER;
BEGIN
	SELECT isbn INTO v_isbn FROM Details 
	WHERE isbn = :old.isbn;
	SELECT numExemplaire INTO v_numExemplaire FROM Details
	WHERE numExemplaire = :old.numExemplaire;
	/*incrémenter le champs nombreEmprunts de la table Exemplaires*/
	UPDATE Exemplaires SET nombreEmprunts = ((SELECT nombreEmprunts FROM Exemplaires WHERE Exemplaires.isbn = v_isbn and Exemplaires.numExemplaire = v_numExemplaire) + 1) 
	WHERE Exemplaires.isbn = v_isbn and Exemplaires.numExemplaire = v_numExemplaire;
END;
/

/* QUESTION 7*/

ALTER TABLE Emprunts ADD(UserAjout VARCHAR2(50), DateAjout DATE);
ALTER TABLE Details ADD(UserModif VARCHAR2(50), DateModif DATE);

CREATE OR REPLACE TRIGGER avant_insert_Emprunts 
  BEFORE INSERT ON Emprunts
  FOR EACH ROW
BEGIN
  :new.UserAjout :=user();
  :new.DateAjout :=sysdate();
END;
/

CREATE OR REPLACE TRIGGER avant_MAJ_Details
  BEFORE UPDATE ON Details
  FOR EACH ROW
  WHEN (old.dateRetour is NULL AND new.dateRetour is NOT NULL)
BEGIN
  :new.UserModif :=user();
  :new.DateModif :=sysdate();
END;
/


/* QUESTION 8*/
CREATE OR REPLACE FUNCTION AnalyseActivite(v_user  in VARCHAR2 default NULL, v_jour in DATE default NULL)
RETURN NUMBER IS
  v_resultatDeparts NUMBER :=0;
  v_resultatRetours NUMBER :=0;
BEGIN
	/*si le nom d''utilisateur seulement a été entré*/
  IF (v_user is not null AND v_jour is null) THEN
    SELECT count(*) INTO v_resultatDeparts 
      FROM emprunts
      WHERE UserAjout=v_user;
    SELECT count(*) INTO v_resultatRetours
      FROM details
      WHERE UserModif=v_user ;

    RETURN v_resultatDeparts+v_resultatRetours;
  END IF;
  /*si le jour seulement a été entré*/
  IF (v_user is null AND v_jour is not null) THEN
    SELECT count(*) INTO v_resultatDeparts 
      FROM emprunts
      WHERE DateAjout=v_jour;
    SELECT count(*) INTO v_resultatRetours
      FROM details
      WHERE DateModif=v_jour;

    RETURN v_resultatDeparts+v_resultatRetours;
  END IF;

  /*l''utilisateur et le jour ont été entrés*/
  IF (v_user is not null AND v_jour is not null) THEN
    SELECT count(*) INTO v_resultatDeparts 
      FROM emprunts
      WHERE UserAjout=v_user AND DateAjout=v_jour;
    SELECT count(*) INTO v_resultatRetours
      FROM details
      WHERE UserModif=v_user AND DateModif=v_jour;

    RETURN v_resultatDeparts+v_resultatRetours;
  END IF;
  /*si aucun paramètre n''a été entré*/
  RETURN 0;
END;
/


/* QUESTION 9*/
CREATE OR REPLACE TRIGGER avant_insert_Details
	/*avant d''insérer une nouvelle dans la table Details*/
  BEFORE INSERT ON details
  FOR EACH ROW
DECLARE
  v_etat CHAR;
BEGIN
	/*on extrait de la table Emprunts l'état de l'emprunt correspond*/
  SELECT etat INTO v_etat
    FROM Emprunts
    WHERE idEmprunt=:new.idEmprunt;
  IF (v_etat!='EC') THEN
  	/*si l''etat est en cours, on lève une exception*/
    Raise_application_error(-20006,'Etat non compatible de la fiche');
  END IF;
END;
/
