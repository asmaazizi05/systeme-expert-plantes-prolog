
:- encoding(utf8).

:- dynamic symptome_observe/1.
:- dynamic reponse/2.

poids_conditions(0.5).

combiner(A, B, C) :-
    C is A + B * (1 - A).

combiner_liste(Liste, CF) :-
    foldl(combiner, Liste, 0.0, CF).

symptome_present(Organe, M, S, C) :-
    symptome_maladie(M, S, C),
    symptome_observe(S),
    symptome_organe(S, Organe).

maladie_candidate(Organe, M) :-
    maladie(M, _),
    once(symptome_present(Organe, M, _, _)).

cf_symptomes(Organe, M, CF) :-
    findall(C, symptome_present(Organe, M, _, C), L),
    L \= [],
    combiner_liste(L, CF).

cf_conditions(M, CF) :-
    findall(
        C,
        (condition_favorable(M, Cd, C), reponse(Cd, oui)),
        L
    ),
    combiner_liste(L, CF).

confiance(Organe, M, Pct) :-
    cf_symptomes(Organe, M, CS),
    cf_conditions(M, CC),
    poids_conditions(W),
    CF is CS + CC * W * (1 - CS),
    Pct is round(CF * 100).

confusion(fusariose, verticilliose,
    'Fusariose ou verticilliose : brunissement pâle près de la base et sol frais pour Verticillium, plus foncé et plus haut et sol chaud pour Fusarium. Une analyse en laboratoire peut être nécessaire.').

confusion(alternariose, septoriose,
    'Alternariose ou septoriose : anneaux concentriques pour l’alternariose ; petites taches à centre gris et points noirs pour la septoriose.').

confusion(aleurodes, pucerons,
    'Aleurodes ou pucerons : les dégâts (miellat, jaunissement) se ressemblent, observez l’insecte lui-même.').

confusion(nematodes_galles, fusariose,
    'Nématodes ou fusariose : symptômes aériens identiques, seul l’examen des racines (galles) départage.').

confusion(nematodes_galles, verticilliose,
    'Nématodes ou verticilliose : symptômes aériens identiques, examinez les racines.').

confusion(acariens, stress_hydrique,
    'Acariens ou stress hydrique : cherchez les fines toiles et la face inférieure des feuilles à la loupe.').

confusion(tylcv, mosaique_tomate,
    'TYLCV ou mosaïque : la mosaïque passe par semences et contact, le TYLCV uniquement par les aleurodes.').

avertissement(tylcv,
    'Aucun traitement curatif : le virus est transmis uniquement par les aleurodes, traitez aussi les aleurodes.').

avertissement(aleurodes,
    'Les aleurodes sont vecteurs du TYLCV : surveillez enroulement et jaunissement des jeunes feuilles.').

avertissement(chancre_bacterien,
    'Maladie systémique sans traitement curatif : prévention par semences saines et désinfection des outils.').

avertissement(mosaique_tomate,
    'Aucun traitement curatif : arracher les plants atteints et désinfecter outils et mains.').

avertissement(stress_hydrique,
    'Diagnostic d’exclusion (preuves faibles) : vérifiez d’abord l’absence de maladie ou de ravageur.').

avertissement(coup_de_soleil,
    'Souvent secondaire à une défoliation (septoriose, flétrissement, chancre bactérien) : cherchez la maladie causale.').

avertissement(necrose_apicale,
    'Trouble physiologique (pas de pathogène) : régularisez l’arrosage ; un apport de calcium sur le feuillage est inefficace.').

organe(feuilles, 'Feuilles').
organe(tiges, 'Tiges').
organe(fruits, 'Fruits').
organe(racines, 'Racines').
organe(fleurs, 'Fleurs').

texte(Id, T) :-
    (libelle(Id, T) -> true ; T = Id).

symptome(Id, Organe, Texte) :-
    symptome_organe(Id, Organe),
    texte(Id, Texte).

question(Cond, Organe, Texte) :-
    setof(
        Cd,
        M^C^(maladie_candidate(Organe, M), condition_favorable(M, Cd, C)),
        Conds
    ),
    member(Cond, Conds),
    texte(Cond, L),
    format(atom(Texte), 'Situation observée : ~w ?', [L]).

nom_maladie(mildiou, 'Mildiou').
nom_maladie(alternariose, 'Alternariose').
nom_maladie(oidium, 'Oïdium').
nom_maladie(botrytis, 'Botrytis (pourriture grise)').
nom_maladie(fusariose, 'Fusariose').
nom_maladie(verticilliose, 'Verticilliose').
nom_maladie(septoriose, 'Septoriose').
nom_maladie(chancre_bacterien, 'Chancre bactérien').
nom_maladie(tache_bacterienne, 'Tache bactérienne').
nom_maladie(tylcv, 'TYLCV (virus de l’enroulement jaune)').
nom_maladie(mosaique_tomate, 'Mosaïque de la tomate (ToMV)').
nom_maladie(tuta_absoluta, 'Tuta absoluta (mineuse de la tomate)').
nom_maladie(aleurodes, 'Aleurodes (mouches blanches)').
nom_maladie(pucerons, 'Pucerons').
nom_maladie(acariens, 'Acariens (tétranyques)').
nom_maladie(nematodes_galles, 'Nématodes à galles').
nom_maladie(necrose_apicale, 'Nécrose apicale (cul noir)').
nom_maladie(stress_hydrique, 'Stress hydrique').
nom_maladie(eclatement_fruits, 'Éclatement des fruits').
nom_maladie(coup_de_soleil, 'Coup de soleil').

type_texte(champignon, 'Champignon').
type_texte(bacterie, 'Bactérie').
type_texte(virus, 'Virus').
type_texte(ravageur, 'Ravageur').
type_texte(trouble_physiologique, 'Trouble physiologique').

mesures(M, Modes, Liste) :-
    findall(
        L,
        (member(Mo, Modes), traitement(M, Mo, Me), texte(Me, L)),
        Liste
    ).

mesures_texte(M, Modes, Texte) :-
    mesures(M, Modes, Ls),
    (
        Ls == []
    ->
        Texte = 'Aucune mesure citée dans la base.'
    ;
        atomic_list_concat(Ls, ' ; ', Texte)
    ).

info(M, Nom, Cause, Traitement, Prevention) :-
    maladie(M, Type),
    nom_maladie(M, Nom),
    cause(M, C),
    type_texte(Type, TT),
    format(atom(Cause), '~w (~w)', [TT, C]),
    mesures_texte(M, [biologique, conventionnel], T0),
    (
        traitement(M, conventionnel, _)
    ->
        atom_concat(
            T0,
            ' - Produits à vérifier sur l’index ONSSA avant usage.',
            Traitement
        )
    ;
        Traitement = T0
    ),
    mesures_texte(M, [cultural], Prevention).

