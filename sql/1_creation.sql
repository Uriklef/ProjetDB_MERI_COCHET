CREATE DATABASE IF NOT EXISTS compagnie_aerienne;

USE compagnie_aerienne;

CREATE TABLE MODELE_AVION (
    nom_modele VARCHAR(30) NOT NULL,
    constructeur VARCHAR(30) NOT NULL,
    capacite_sieges SMALLINT NOT NULL,

    PRIMARY KEY (nom_modele)
);

CREATE TABLE AVION (
    immatriculation VARCHAR(6) NOT NULL,
    date_mise_service DATE NOT NULL,
    nom_modele VARCHAR(30) NOT NULL,

    PRIMARY KEY (immatriculation),

    CONSTRAINT fk_avion_1
        FOREIGN KEY (nom_modele)
        REFERENCES MODELE_AVION(nom_modele)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE AEROPORT (
    code_iata CHAR(3) NOT NULL,
    nom_aeroport VARCHAR(60) NOT NULL,
    ville VARCHAR(40) NOT NULL,
    pays VARCHAR(40) NOT NULL,

    PRIMARY KEY (code_iata)
);

CREATE TABLE LIGNE (
    numero_vol VARCHAR(6) NOT NULL,
    distance_km INT NOT NULL,
    code_iata_depart CHAR(3) NOT NULL,
    code_iata_arrivee CHAR(3) NOT NULL,

    PRIMARY KEY (numero_vol),

    CONSTRAINT fk_ligne_1
        FOREIGN KEY (code_iata_depart)
        REFERENCES AEROPORT(code_iata)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_ligne_2
        FOREIGN KEY (code_iata_arrivee)
        REFERENCES AEROPORT(code_iata)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE VOL (
    numero_vol VARCHAR(6) NOT NULL,
    date_depart DATE NOT NULL,
    heure_depart TIME NOT NULL,
    heure_arrivee TIME NOT NULL,
    statut VARCHAR(10) NOT NULL DEFAULT 'Prévu',
    immatriculation VARCHAR(6) NOT NULL,

    PRIMARY KEY (numero_vol, date_depart),

    CONSTRAINT fk_vol_1
        FOREIGN KEY (numero_vol)
        REFERENCES LIGNE(numero_vol)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_vol_2
        FOREIGN KEY (immatriculation)
        REFERENCES AVION(immatriculation)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE EMPLOYE (
    matricule VARCHAR(6) NOT NULL,
    nom_employe VARCHAR(40) NOT NULL,
    prenom_employe VARCHAR(40) NOT NULL,
    date_embauche DATE NOT NULL,

    PRIMARY KEY (matricule)
);

CREATE TABLE SUPERVISER (
    matricule_subordonne VARCHAR(6) NOT NULL,
    matricule_superieur VARCHAR(6) NOT NULL,

    PRIMARY KEY (matricule_subordonne),

    CONSTRAINT fk_superviser_1
        FOREIGN KEY (matricule_subordonne)
        REFERENCES EMPLOYE(matricule)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_superviser_2
        FOREIGN KEY (matricule_superieur)
        REFERENCES EMPLOYE(matricule)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE ROLE_A_BORD (
    libelle_role VARCHAR(30) NOT NULL,

    PRIMARY KEY (libelle_role)
) ENGINE = InnoDB;

CREATE TABLE AFFECTER (
    matricule VARCHAR(6) NOT NULL,
    numero_vol VARCHAR(6) NOT NULL,
    date_depart DATE NOT NULL,
    libelle_role VARCHAR(30) NOT NULL,

    PRIMARY KEY (matricule, numero_vol, date_depart),

    CONSTRAINT fk_affecter_1
        FOREIGN KEY (matricule)
        REFERENCES EMPLOYE(matricule)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_affecter_2
        FOREIGN KEY (numero_vol, date_depart)
        REFERENCES VOL(numero_vol, date_depart)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_affecter_3
        FOREIGN KEY (libelle_role)
        REFERENCES ROLE_A_BORD(libelle_role)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE PASSAGER (
    num_passeport VARCHAR(9) NOT NULL,
    nom_passager VARCHAR(40) NOT NULL,
    prenom_passager VARCHAR(40) NOT NULL,
    date_naissance DATE NOT NULL,
    email VARCHAR(100) NOT NULL,

    PRIMARY KEY (num_passeport)
);

CREATE TABLE RESERVATION (
    num_reservation CHAR(6) NOT NULL,
    date_reservation DATE NOT NULL,
    num_passeport_reservant VARCHAR(9) NOT NULL,

    PRIMARY KEY (num_reservation),

    CONSTRAINT fk_reservation_1
        FOREIGN KEY (num_passeport_reservant)
        REFERENCES PASSAGER(num_passeport)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE BILLET (
    num_billet CHAR(13) NOT NULL,
    prix DECIMAL(7,2) NOT NULL,
    num_siege VARCHAR(3) NOT NULL,
    classe VARCHAR(15) NOT NULL,
    poids_bagage SMALLINT NOT NULL,
    num_reservation CHAR(6) NOT NULL,
    num_passeport VARCHAR(9) NOT NULL,
    numero_vol VARCHAR(6) NOT NULL,
    date_depart DATE NOT NULL,

    PRIMARY KEY (num_billet),

    UNIQUE (numero_vol, date_depart, num_siege),

    CONSTRAINT fk_billet_1
        FOREIGN KEY (num_reservation)
        REFERENCES RESERVATION(num_reservation)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_billet_2
        FOREIGN KEY (num_passeport)
        REFERENCES PASSAGER(num_passeport)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_billet_3
        FOREIGN KEY (numero_vol, date_depart)
        REFERENCES VOL(numero_vol, date_depart)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);