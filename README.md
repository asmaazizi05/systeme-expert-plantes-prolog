# systeme-expert-plantes-prolog
# 🌱 Système Expert de Diagnostic des Maladies de la Tomate avec Prolog

**Mini-projet :** Système expert avec Prolog  
**Module :** Fondements avancés de l’intelligence artificielle  
**Filière :** Master IA – S1  
**Encadrante :** Pr. Hasna Elalaoui  
**Année universitaire :** 2026–2027  
**Auteurs :** Asmae Azizi et Ait Bilfakih

---

## 1. Contexte du projet

L’agriculture joue un rôle important dans l’économie marocaine. Cependant, les cultures sont régulièrement menacées par différentes maladies, des ravageurs et des troubles physiologiques qui peuvent réduire la production.

La tomate est une culture maraîchère qui peut être affectée par plusieurs problèmes phytosanitaires. L’identification correcte de ces problèmes est essentielle pour éviter les traitements inadaptés et limiter les pertes agricoles.

Ce projet consiste à développer un système expert en Prolog capable d’aider les agriculteurs à identifier les maladies et les problèmes susceptibles d’affecter leurs plants de tomates, à partir des symptômes observés et des conditions environnementales.

## 2. Problématique

**Comment développer un système expert capable d’identifier les maladies et les ravageurs de la tomate à partir des symptômes observés, puis de proposer des mesures de traitement et de prévention adaptées ?**

### Questions secondaires

- Quels sont les principaux symptômes permettant de différencier les maladies de la tomate ?
- Comment représenter les connaissances phytosanitaires sous forme de faits et de règles en Prolog ?
- Comment utiliser les réponses de l’utilisateur pour affiner le diagnostic ?
- Comment attribuer un niveau de confiance aux diagnostics proposés ?
- Quelles mesures de traitement et de prévention recommander selon le problème identifié ?

## 3. Description du domaine étudié

- **Culture étudiée :** Tomate.
- **Domaine :** Cultures maraîchères.
- **Technologie principale :** Prolog.
- **Type de système :** Système expert de diagnostic phytosanitaire.
- **Nombre minimal de problèmes à couvrir :** 15 maladies, ravageurs ou troubles physiologiques.

### Informations à représenter dans la base de connaissances

| Type d'information | Exemples |
|---|---|
| Culture | Tomate |
| Organe atteint | Feuilles, tiges, fruits, racines |
| Symptômes | Taches, jaunissement, flétrissement, pourriture |
| Conditions favorables | Humidité élevée, chaleur, conditions climatiques |
| Causes possibles | Champignons, bactéries, virus, insectes, carences |
| Traitements | Mesures de lutte adaptées au diagnostic |
| Prévention | Gestes culturaux et mesures préventives |

## 4. Méthodologie

Le développement du système expert suivra les étapes suivantes :

1. **Délimitation du domaine :** étude des maladies, ravageurs et troubles physiologiques affectant la tomate.
2. **Acquisition des connaissances :** recherche de sources fiables pour identifier les symptômes, les conditions favorables et les moyens de lutte.
3. **Construction de la base de connaissances :** représentation des faits et des règles de diagnostic en Prolog.
4. **Développement du moteur de diagnostic :** création des règles permettant de relier les symptômes et le contexte aux causes probables.
5. **Développement de l’interface utilisateur :** création d’un parcours interactif permettant à l’utilisateur de sélectionner la culture, l’organe atteint et les symptômes.
6. **Évaluation du diagnostic :** attribution d’un niveau de confiance et proposition de plusieurs hypothèses lorsque le diagnostic reste incertain.
7. **Recommandations :** présentation des mesures de traitement et de prévention, avec les précautions nécessaires.
8. **Tests et validation :** vérification du comportement du système à partir de différents scénarios.

## 5. Structure du dépôt

```text
projet-diagnostic-tomate/
├── data/
│   └── base_connaissances.md
├── prolog/
│   ├── faits.pl
│   ├── regles.pl
│   ├── diagnostic.pl
│   └── main.pl
├── interface/
│   └── application.*
├── tests/
│   └── scenarios_tests.md
├── rapport/
│   └── rapport_projet.pdf
├── README.md
└── requirements.txt
```

*Remarque : cette structure est proposée pour organiser le travail. Les noms et les fichiers seront adaptés aux technologies effectivement utilisées.*

## 6. Répartition des tâches

| Tâche | Responsable |
|---|---|
| Recherche sur les maladies de la tomate | Asmae Azizi et Ait Bilfakih |
| Construction de la base de faits | Asmae Azizi |
| Développement des règles de diagnostic en Prolog | Asmae Azizi |
| Développement de l’interface utilisateur | Ait Bilfakih |
| Intégration de l’interface avec Prolog | Ait Bilfakih et Asmae Azizi |
| Tests et validation du système | Les deux |
| Rédaction du rapport PDF | Les deux |
| Préparation de la présentation | Les deux |

## 7. Résultats attendus

À la fin du projet, le système devra permettre de :

- Sélectionner la culture étudiée et l’organe atteint.
- Décrire les symptômes observés à travers une interface interactive.
- Poser des questions complémentaires pour affiner le diagnostic.
- Identifier une ou plusieurs causes probables parmi au moins 15 problèmes phytosanitaires documentés.
- Afficher un niveau de confiance pour les diagnostics proposés.
- Fournir des recommandations de traitement et de prévention adaptées.
- Signaler les situations incertaines nécessitant des observations supplémentaires ou l’avis d’un spécialiste.

## 8. Conclusion et perspectives

Ce projet vise à appliquer les concepts de l’intelligence artificielle et de la programmation logique au domaine agricole, à travers la réalisation d’un système expert de diagnostic des maladies de la tomate.

Il permettra de mettre en pratique la représentation des connaissances, les règles de raisonnement en Prolog et le développement d’une interface interactive.

Une évolution possible serait d’étendre le système à d’autres cultures maraîchères et d’enrichir sa base de connaissances à partir de sources agronomiques fiables.

## 9. Technologies utilisées

- **Prolog :** représentation des connaissances et moteur de raisonnement.
- **Interface utilisateur :** application console interactive ou interface web simple.
- **Base de connaissances :** faits et règles décrivant les maladies, les symptômes et les traitements.

## 10. Livrables

Conformément aux consignes du mini-projet, le rendu final comprendra :

- Le code Prolog complet.
- Le code de l’interface utilisateur.
- Un rapport PDF détaillant les tâches réalisées.

Les fichiers seront regroupés dans une archive compressée et nommés de manière à identifier les deux membres du binôme.

**Date limite indiquée : dimanche 13 décembre 2026 à minuit.**
