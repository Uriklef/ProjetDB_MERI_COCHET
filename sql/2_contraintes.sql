USE compagnie_aerienne;

-- La capacité doit être compris entre 1 et 999 sièges
ALTER TABLE MODELE_AVION
ADD CONSTRAINT ck_capacite
CHECK (capacite_sieges BETWEEN 1 AND 999);

-- La distance doit être supérieure à 0 et tenir sur 5 chiffres
ALTER TABLE LIGNE
ADD CONSTRAINT ck_distance
CHECK (distance_km BETWEEN 1 AND 99999);

-- L'heure de départ doit être une heure existante de la journée
ALTER TABLE VOL
ADD CONSTRAINT ck_heure_depart
CHECK (heure_depart BETWEEN '00:00:00' AND '23:59:59');

-- L'heure d'arrivée doit être une heure existante de la journée
ALTER TABLE VOL
ADD CONSTRAINT ck_heure_arrivee
CHECK (heure_arrivee BETWEEN '00:00:00' AND '23:59:59');

-- Le statut du vol doit faire parti de cette liste
ALTER TABLE VOL
ADD CONSTRAINT ck_statut
CHECK (statut IN ('Prévu', 'Retardé', 'Annulé', 'Effectué'));

-- Le rôle doit correspondre à une fonction prévue à bord
ALTER TABLE ROLE_A_BORD
ADD CONSTRAINT ck_role
CHECK (libelle_role IN ('Commandant de bord', 'Officier pilote de ligne', 'Chef de cabine', 'Personnel de cabine'));

-- L'adresse mail doit contenir une partie avant @ et un domaine avec un point
ALTER TABLE PASSAGER
ADD CONSTRAINT ck_email
CHECK (email LIKE '%_@_%._%');

-- Le numéro de réservation doit contenir 6 caractères exactement
ALTER TABLE RESERVATION
ADD CONSTRAINT ck_num_reservation
CHECK (num_reservation LIKE '______');

-- Le numéro de billet doit contenir 13 caractères exactement
ALTER TABLE BILLET
ADD CONSTRAINT ck_num_billet
CHECK (num_billet LIKE '_____________');

-- Le prix du billet peut pas être négatif
ALTER TABLE BILLET
ADD CONSTRAINT ck_prix
CHECK (prix >= 0);

-- Le numéro de siège peut pas être vide
ALTER TABLE BILLET
ADD CONSTRAINT ck_siege
CHECK (num_siege <> '');

-- La classe du billet doit faire parti des classes proposées
ALTER TABLE BILLET
ADD CONSTRAINT ck_classe
CHECK (classe IN ('Économique', 'Premium', 'Affaires', 'Première'));

-- Le poids de bagage doit être entre 0 et 99 kg
ALTER TABLE BILLET
ADD CONSTRAINT ck_poids_bagage
CHECK (poids_bagage BETWEEN 0 AND 99);
