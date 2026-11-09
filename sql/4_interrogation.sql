USE compagnie_aerienne;

-- 1. PROJECTIONS ET SÉLECTIONS

-- 1.1 la liste des pays desservis par la compagnie, sans doublon
SELECT DISTINCT pays
FROM AEROPORT
ORDER BY pays;

-- 1.2 les lignes long-courrier, de la plus longue à la plus courte
SELECT numero_vol, code_iata_depart, code_iata_arrivee, distance_km
FROM LIGNE
WHERE distance_km > 5000
ORDER BY distance_km DESC;

-- 1.3 les vols perturbés (retardés ou annulés), triés par date (IN + ORDER BY).
SELECT numero_vol, date_depart, heure_depart, statut
FROM VOL
WHERE statut IN ('Retardé', 'Annulé')
ORDER BY date_depart, numero_vol;

-- 1.4 les billets haut de gamme (Affaires ou Première) dont le prix est compris entre 1 000 € et 3 000 €
SELECT num_billet, classe, prix, numero_vol, date_depart
FROM BILLET
WHERE classe IN ('Affaires', 'Première')
  AND prix BETWEEN 1000 AND 3000
ORDER BY prix DESC;

-- 1.5 les passagers dont le nom commence par « M » (masque LIKE), triés par nom puis prénom.
SELECT num_passeport, nom_passager, prenom_passager, email
FROM PASSAGER
WHERE nom_passager LIKE 'M%'
ORDER BY nom_passager, prenom_passager;


-- 2. FONCTIONS D'AGRÉGATION, GROUP BY ET HAVING

-- 2.1 le nombre de vols pour chaque statut (COUNT + GROUP BY).
SELECT statut, COUNT(*) AS nb_vols
FROM VOL
GROUP BY statut
ORDER BY nb_vols DESC;

-- 2.2 pour chaque classe de voyage, le nombre de billets vendus, le chiffre d'affaires, le prix moyen, minimum et maximum (COUNT, SUM, AVG, MIN, MAX).
SELECT classe,
       COUNT(*)              AS nb_billets,
       SUM(prix)             AS chiffre_affaires,
       ROUND(AVG(prix), 2)   AS prix_moyen,
       MIN(prix)             AS prix_min,
       MAX(prix)             AS prix_max
FROM BILLET
GROUP BY classe
ORDER BY chiffre_affaires DESC;

-- 2.3 les vols ayant au moins 3 billets vendus, avec le nombre de billets et la recette (HAVING).
SELECT numero_vol, date_depart,
       COUNT(*)  AS nb_billets,
       SUM(prix) AS recette
FROM BILLET
GROUP BY numero_vol, date_depart
HAVING COUNT(*) >= 3
ORDER BY nb_billets DESC, recette DESC;

-- 2.4 les réservations de groupe (au moins 2 billets), avec le montant total à payer (HAVING).
SELECT num_reservation,
       COUNT(*)  AS nb_billets,
       SUM(prix) AS montant_total
FROM BILLET
GROUP BY num_reservation
HAVING COUNT(*) >= 2
ORDER BY montant_total DESC;

-- 2.5 les avions qui assurent au moins 3 vols sur la période (avions les plus utilisés, HAVING).
SELECT immatriculation, COUNT(*) AS nb_vols
FROM VOL
GROUP BY immatriculation
HAVING COUNT(*) >= 3
ORDER BY nb_vols DESC, immatriculation;


-- 3. JOINTURES

-- 3.1 Jointure multiple : le programme des vols avec la ville de départ et la ville d'arrivée.
SELECT v.numero_vol, v.date_depart, v.heure_depart,
       ad.ville AS ville_depart,
       aa.ville AS ville_arrivee,
       v.statut
FROM VOL v
JOIN LIGNE l     ON l.numero_vol = v.numero_vol
JOIN AEROPORT ad ON ad.code_iata = l.code_iata_depart
JOIN AEROPORT aa ON aa.code_iata = l.code_iata_arrivee
ORDER BY v.date_depart, v.heure_depart;

-- 3.2 Jointure interne simple : l'identité des passagers voyageant en classe Première, avec le vol, la date et le prix payé.
SELECT p.nom_passager, p.prenom_passager, b.numero_vol, b.date_depart, b.prix
FROM BILLET b
JOIN PASSAGER p ON p.num_passeport = b.num_passeport
WHERE b.classe = 'Première'
ORDER BY b.prix DESC;

-- 3.3 Jointure externe gauche : tous les aéroports avec le nombre de lignes qui en partent, y compris ceux sans départ.
SELECT a.code_iata, a.nom_aeroport, COUNT(l.numero_vol) AS nb_lignes_au_depart
FROM AEROPORT a
LEFT JOIN LIGNE l ON l.code_iata_depart = a.code_iata
GROUP BY a.code_iata, a.nom_aeroport
ORDER BY nb_lignes_au_depart DESC, a.code_iata;

-- 3.4 Auto-jointure avec jointure externe : chaque employé avec son supérieur hiérarchique.
SELECT e.matricule, e.nom_employe, e.prenom_employe,
       sup.nom_employe AS nom_superieur
FROM EMPLOYE e
LEFT JOIN SUPERVISER s ON s.matricule_subordonne = e.matricule
LEFT JOIN EMPLOYE sup  ON sup.matricule = s.matricule_superieur
ORDER BY e.matricule;

-- 3.5 Jointure sur les trois tables de l'association ternaire : l'équipage du vol AF106 du 04/11/2026 (employé et rôle à bord).
SELECT r.libelle_role, e.matricule, e.nom_employe, e.prenom_employe
FROM AFFECTER af
JOIN EMPLOYE e       ON e.matricule = af.matricule
JOIN ROLE_A_BORD r   ON r.libelle_role = af.libelle_role
WHERE af.numero_vol = 'AF106'
  AND af.date_depart = '2026-11-04'
ORDER BY r.libelle_role, e.nom_employe;


-- 4. REQUÊTES IMBRIQUÉES

-- 4.1 NOT IN : les aéroports qui ne sont le départ d'aucune ligne (destinations seulement).
SELECT code_iata, nom_aeroport, ville
FROM AEROPORT
WHERE code_iata NOT IN (SELECT code_iata_depart FROM LIGNE)
ORDER BY code_iata;

-- 4.2 IN : les passagers ayant déjà voyagé en classe Première.
SELECT num_passeport, nom_passager, prenom_passager
FROM PASSAGER
WHERE num_passeport IN (SELECT num_passeport
                        FROM BILLET
                        WHERE classe = 'Première')
ORDER BY nom_passager;

-- 4.3 EXISTS : les avions qui ont assuré au moins un vol retardé ou annulé.
SELECT av.immatriculation, av.nom_modele
FROM AVION av
WHERE EXISTS (SELECT 1
              FROM VOL v
              WHERE v.immatriculation = av.immatriculation
                AND v.statut IN ('Retardé', 'Annulé'))
ORDER BY av.immatriculation;

-- 4.4 NOT EXISTS : les passagers qui n'ont fait aucune réservation à leur nom.
SELECT p.num_passeport, p.nom_passager, p.prenom_passager
FROM PASSAGER p
WHERE NOT EXISTS (SELECT 1
                  FROM RESERVATION r
                  WHERE r.num_passeport_reservant = p.num_passeport)
ORDER BY p.nom_passager;

-- 4.5 ANY : les billets Affaires vendus moins cher qu'au moins un billet Économique.
SELECT num_billet, prix, numero_vol, date_depart
FROM BILLET
WHERE classe = 'Affaires'
  AND prix < ANY (SELECT prix FROM BILLET WHERE classe = 'Économique')
ORDER BY prix;


-- 5. REQUÊTE POUR L'ÉTUDE DES PLANS D'EXÉCUTION (voir README)

-- le numéro, le prix et la date de départ des billets de
-- classe Affaires pour les vols dont la ligne part de CDG
SELECT b.num_billet, b.prix, b.date_depart
FROM BILLET b
JOIN VOL v   ON v.numero_vol = b.numero_vol
            AND v.date_depart = b.date_depart
JOIN LIGNE l ON l.numero_vol = v.numero_vol
WHERE b.classe = 'Affaires'
  AND l.code_iata_depart = 'CDG';