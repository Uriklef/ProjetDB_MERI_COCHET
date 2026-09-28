# Mini-projet TI503N : Base de données d'une compagnie aérienne

**Module** : TI503N – Bases de données 1 : Concepts de base (EFREI)
**Partie 1** : analyse des besoins et MCD



## Étape 1 : Analyse des besoins

### 1.1 Prompt final (framework RICARDO)

Le prompt part de la base fournie. Seules les parties **Contexte** et **Références** ont été complétées.

```text
Tu travailles dans le domaine des compagnies aériennes. Ta compagnie a comme activité d’organiser des vols de passagers (court, moyen et long-courrier) entre différents aéroports, avec une flotte d’avions, des équipages et un système de réservation et de vente de billets. C’est une compagnie comme Air France, Ryanair, Air India ou Delta. Inspire-toi des sites web suivants : https://www.airfrance.fr, https://www.ryanair.com, https://www.airindia.com, https://www.delta.com.
Ta compagnie veut appliquer MERISE pour concevoir un système d'information. Tu es chargé de la partie analyse, c’est-à-dire de collecter les besoins auprès de l’entreprise. Elle a fait appel à un étudiant en ingénierie informatique pour réaliser ce projet, tu dois lui fournir les informations nécessaires pour qu’il applique ensuite lui-même les étapes suivantes de conception et développement de la base de données.
D’abord, établis les règles de gestions des données de la compagnie sous la forme d'une liste à puce. Elle doit correspondre aux informations que fournit quelqu’un qui connaît le fonctionnement de l’entreprise, mais pas comment se construit un système d’information.
Ensuite, à partir de ces règles, fournis un dictionnaire de données brutes avec les colonnes suivantes, regroupées dans un tableau : signification de la donnée, type, taille en nombre de caractères ou de chiffres. Il doit y avoir entre 25 et 35 données. Il sert à fournir des informations supplémentaires sur chaque donnée (taille et type) mais sans a priori sur comment les données vont être modélisées ensuite.
Fournis donc les règles de gestion et le dictionnaire de données.
```

### 1.2 Règles de gestion

**Flotte**

- La compagnie possède des avions. Chaque avion est identifié par son immatriculation (ex. F-HBXA) et a une date de mise en service.
- Chaque avion appartient à un modèle (ex. A320, Boeing 777). Un modèle a un constructeur et une capacité en nombre de sièges. Tous les avions d'un même modèle ont la même capacité.

**Aéroports et lignes**

- La compagnie dessert des aéroports, identifiés par leur code IATA de 3 lettres (ex. CDG, JFK). Un aéroport a un nom, une ville et un pays.
- Une ligne relie un aéroport de départ à un aéroport d'arrivée différent. Elle est identifiée par son numéro de vol (2 lettres suivies de 1 à 4 chiffres, ex. AF7) et a une distance en km.

**Vols**

- Une ligne est exploitée régulièrement. Un vol correspond à l'exploitation d'une ligne à une date précise : on le désigne par le numéro de vol et la date de départ (ex. AF7 du 12/03/2026). Le même numéro de vol ne peut pas avoir deux départs le même jour.
- Un vol a une heure de départ prévue, une heure d'arrivée prévue et un statut (Prévu, Retardé, Annulé ou Effectué).
- Un vol est assuré par un seul avion. Un avion assure plusieurs vols, mais jamais deux en même temps.

**Personnel**

- Chaque employé a un matricule, un nom, un prénom, une date d'embauche et une fonction (pilote, copilote, chef de cabine, hôtesse ou steward, agent d'escale).
- Chaque employé a un supérieur hiérarchique, qui est lui-même un employé. Seul le directeur des opérations n'en a pas.
- Pour chaque vol, plusieurs employés sont affectés à bord. Chacun y tient un rôle précis (commandant de bord, officier pilote de ligne, chef de cabine, personnel de cabine). Un même employé peut avoir des rôles différents d'un vol à l'autre, mais un seul rôle sur un vol donné.
- Un vol doit avoir au moins un commandant de bord et un officier pilote de ligne.

**Passagers, réservations et billets**

- Un passager est identifié par son numéro de passeport. On enregistre son nom, son prénom, sa date de naissance et son email.
- Une réservation est faite par un passager. Elle a un numéro de 6 caractères et une date de réservation. Une réservation peut regrouper plusieurs billets (famille, amis), mais elle est toujours au nom d'un seul passager.
- Un billet est identifié par un numéro de 13 chiffres. Il concerne un seul passager, sur un seul vol, dans une seule classe de voyage. Il a un prix payé et un numéro de siège.
- Sur un vol donné, un siège ne peut être attribué qu'à un seul billet.
- Les classes de voyage sont Économique, Premium, Affaires et Première. Chaque classe donne droit à un poids de bagage en soute (en kg).
- Un passager peut avoir une carte de fidélité, identifiée par un numéro de 10 chiffres.

### 1.3 Dictionnaire de données

| N° | Signification de la donnée | Type | Taille |
|---:|---|---|---|
| 1 | Immatriculation de l'avion | Texte | 6 caractères |
| 2 | Date de mise en service de l'avion | Date | 10 caractères (JJ/MM/AAAA) |
| 3 | Nom du modèle d'avion | Texte | 30 caractères |
| 4 | Constructeur du modèle d'avion | Texte | 30 caractères |
| 5 | Capacité du modèle en nombre de sièges | Entier | 3 chiffres |
| 6 | Code IATA de l'aéroport | Texte | 3 caractères |
| 7 | Nom de l'aéroport | Texte | 60 caractères |
| 8 | Ville de l'aéroport | Texte | 40 caractères |
| 9 | Pays de l'aéroport | Texte | 40 caractères |
| 10 | Numéro de vol de la ligne | Texte | 6 caractères |
| 11 | Distance de la ligne en km | Entier | 5 chiffres |
| 12 | Date de départ du vol | Date | 10 caractères (JJ/MM/AAAA) |
| 13 | Heure de départ prévue | Heure | 5 caractères (HH:MM) |
| 14 | Heure d'arrivée prévue | Heure | 5 caractères (HH:MM) |
| 15 | Statut du vol | Texte | 10 caractères |
| 16 | Matricule de l'employé | Texte | 6 caractères |
| 17 | Nom de l'employé | Texte | 40 caractères |
| 18 | Prénom de l'employé | Texte | 40 caractères |
| 20 | Fonction de l'employé | Texte | 25 caractères |
| 21 | Matricule du supérieur hiérarchique | Texte | 6 caractères |
| 23 | Numéro de passeport du passager | Texte | 9 caractères |
| 24 | Nom du passager | Texte | 40 caractères |
| 25 | Prénom du passager | Texte | 40 caractères |
| 26 | Date de naissance du passager | Date | 10 caractères (JJ/MM/AAAA) |
| 27 | Email du passager | Texte | 100 caractères |
| 29 | Numéro de réservation | Texte | 6 caractères |
| 30 | Date de la réservation | Date | 10 caractères (JJ/MM/AAAA) |
| 31 | Numéro de billet | Texte | 13 chiffres |
| 32 | Numéro de siège | Texte | 3 caractères |
| 33 | Prix payé du billet en euros | Décimal | 7 chiffres dont 2 décimales |
| 34 | Libellé de la classe de voyage | Texte | 15 caractères |
| 35 | Poids de bagage en soute inclus en kg | Entier | 2 chiffres |

## Étape 2 : MCD

**Outil de modélisation utilisé** : draw.io
Le MCD : https://drive.google.com/file/d/1GQE_Xg7uJaPWITQxJn6EabNelp2B7sxK/view?usp=sharing
