-- =========================
-- SUPPRESSION DES TABLES
-- =========================

DROP TABLE IF EXISTS utilisateur;
DROP TABLE IF EXISTS filiere;
DROP TABLE IF EXISTS matiere;
DROP TABLE IF EXISTS utilisateur_competence;
DROP TABLE IF EXISTS utilisateur_lacunes;
DROP TABLE IF EXISTS disponibilite;
DROP TABLE IF EXISTS offre_mentorat;
DROP TABLE IF EXISTS demande_mentorat;
DROP TABLE IF EXISTS match;
DROP TABLE IF EXISTS messages;

-- =========================
-- CREATION DES TABLES
-- =========================

-- Table Messages
CREATE TABLE messages (
    id_message SERIAL PRIMARY KEY,
    id_expediteur INT NOT NULL,
    id_destinataire INT NOT NULL,
    contenu TEXT,
    date_envoi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lu BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_message_expediteur
        FOREIGN KEY (id_expediteur)
        REFERENCES utilisateur(id_user)
        actif BOOLEAN DEFAULT TRUE
        ON UPDATE CASCADE,
    CONSTRAINT fk_message_destinataire
        FOREIGN KEY (id_destinataire)
        REFERENCES utilisateur(id_user)
        actif BOOLEAN DEFAULT TRUE
        ON UPDATE CASCADE
);

-- Table Match
CREATE TABLE match (
    id_match SERIAL PRIMARY KEY,
    id_mentor INT NOT NULL,
    id_mentore INT NOT NULL,
    id_matiere INT NOT NULL,
    score INT NOT NULL CHECK (score >= 0),
    statut VARCHAR(20) DEFAULT 'propose',
    date_match TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (id_mentor, id_mentore, id_matiere),
    CHECK (id_mentor <> id_mentore),

    CONSTRAINT fk_match_mentor
        FOREIGN KEY (id_mentor)
        REFERENCES utilisateur(id_user)
        ON UPDATE CASCADE,

    CONSTRAINT fk_match_mentore
        FOREIGN KEY (id_mentore)
        REFERENCES utilisateur(id_user)
        ON UPDATE CASCADE,

    CONSTRAINT fk_match_matiere
        FOREIGN KEY (id_matiere)
        REFERENCES matiere(id_matiere)
        ON UPDATE CASCADE
);

-- Table Demande_Mentorat
CREATE TABLE demande_mentorat (
    id_demande SERIAL PRIMARY KEY,
    id_mentore INT NOT NULL,
    id_offre INT NOT NULL,
    message TEXT,
    date_demande TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(20) DEFAULT 'en_attente',

    CONSTRAINT fk_demande_mentore
        FOREIGN KEY (id_mentore)
        REFERENCES utilisateur(id_user)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_demande_offre
        FOREIGN KEY (id_offre)
        REFERENCES offre_mentorat(id_offre)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table Offre_Mentorat
CREATE TABLE offre_mentorat (
    id_offre SERIAL PRIMARY KEY,
    id_mentor INT NOT NULL,
    titre VARCHAR(100) NOT NULL,
    description TEXT,
    disponibilite VARCHAR(100),
    date_publication TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(20) DEFAULT 'active',

    CONSTRAINT fk_offre_mentor
        FOREIGN KEY (id_mentor)
        REFERENCES utilisateur(id_user)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table Disponibilite
CREATE TABLE IF NOT EXISTS disponibilite (
    id_disponibilite INT PRIMARY KEY,
    id_user INT,
    jour ENUM('Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'),
    mois ENUM('Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'), 
    heure_debut TIME,
    heure_fin TIME,
    CONSTRAINT fk_disponibilite_user
        FOREIGN KEY (id_user)
        REFERENCES utilisateur(id_user)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table Utilisateur_Lacunes
CREATE TABLE utilisateur_lacunes (
    id_user INT,
    id_matiere INT,
    PRIMARY KEY (id_user, id_matiere),
    FOREIGN KEY (id_user)
        REFERENCES utilisateur(id_user),
    FOREIGN KEY (id_matiere)
        REFERENCES matiere(id_matiere)
);

-- Table Utilisateur_Competence
CREATE TABLE utilisateur_competence (
    id_user INT,
    id_matiere INT,
    PRIMARY KEY (id_user, id_matiere),
    FOREIGN KEY (id_user)
        REFERENCES utilisateur(id_user),
    FOREIGN KEY (id_matiere)
        REFERENCES matiere(id_matiere)
);

-- Table Filiere
CREATE TABLE IF NOT EXISTS filiere (
    id_filiere INT PRIMARY KEY,
    nom_filiere VARCHAR(100)
);

-- Table Matieres
CREATE TABLE IF NOT EXISTS matiere (
    id_matiere INT PRIMARY KEY,
    nom_matiere VARCHAR(100)
);

-- Table Utilisateur
CREATE TABLE IF NOT EXISTS utilisateur (
    id_user SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL
        CHECK (role IN ('mentor', 'mentore')),
    filiere VARCHAR(100),
    bio TEXT,
    actif BOOLEAN DEFAULT TRUE,
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);











