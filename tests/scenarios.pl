:- encoding(utf8).
% Lancer :  swipl -g tester -t halt scenarios.pl      (depuis le dossier tests/)
:- ['../prolog/main.pl'].

% scenario(Nom, Organe, Symptômes, ConditionsOui, Attendus)
% Attendus : top(Maladie) = maladie classée première ; incertain ; confusion
scenario('Mildiou sur feuilles', feuilles,
         [duvet_blanc_face_inferieure, taches_huileuses],
         [humidite_elevee_sup_90, pluie_recente], [top(mildiou)]).
scenario('Tuta absoluta sur feuilles', feuilles,
         [galeries_mines, chenilles_et_dejections_dans_galeries], [], [top(tuta_absoluta)]).
scenario('Tuta absoluta sur fruits', fruits,
         [trous_avec_galeries, necroses_sur_calice], [], [top(tuta_absoluta)]).
scenario('Oïdium (Leveillula)', feuilles,
         [taches_jaunes_face_superieure, sporulation_blanche_face_inferieure], [], [top(oidium)]).
scenario('Fusariose sur feuilles', feuilles,
         [jaunissement_d_un_seul_cote, fletrissement], [sol_chaud], [top(fusariose)]).
scenario('Nécrose apicale', fruits,
         [tache_noire_enfoncee_coriace_base_fruit], [irrigation_irreguliere], [top(necrose_apicale)]).
scenario('Éclatement des fruits', fruits,
         [fissures_concentriques_autour_pedoncule], [irrigation_irreguliere], [top(eclatement_fruits)]).
scenario('Acariens en temps chaud et sec', feuilles,
         [fines_toiles, ponctuations_blanches_jaunes_face_superieure], [temps_chaud_et_sec], [top(acariens)]).
scenario('Nématodes sur racines', racines,
         [galles_renflements], [], [top(nematodes_galles)]).
scenario('TYLCV avec aleurodes', feuilles,
         [enroulement_vers_le_haut, jaunissement_marge_feuille], [presence_aleurodes], [top(tylcv)]).
scenario('Symptôme peu spécifique -> incertain', feuilles,
         [feuilles_enroulees], [], [top(stress_hydrique), incertain]).
scenario('Fusariose ou verticilliose -> confusion signalée', tiges,
         [brunissement_vaisseaux_coupe, brunissement_pale_vaisseaux_pres_base], [], [confusion]).

verifier(Organe, Liste, top(M)) :- Liste = [_-M|_], !, Organe = Organe.
verifier(_, Liste, incertain) :- incertain(Liste).
verifier(_, Liste, confusion) :- confusions(Liste, [_|_]).

executer(Nom, Organe, Ss, Cs, Attendus) :-
    reinitialiser,
    forall(member(S, Ss), assertz(symptome_observe(S))),
    forall(member(C, Cs), assertz(reponse(C, oui))),
    diagnostics(Organe, Liste),
    (   forall(member(A, Attendus), verifier(Organe, Liste, A))
    ->  Statut = 'OK'
    ;   Statut = 'ECHEC'
    ),
    format('[~w] ~w~n', [Statut, Nom]),
    forall(member(P-M, Liste), format('       ~w % ~w~n', [P, M])),
    Statut == 'OK'.

tester :-
    findall(N, scenario(N, _, _, _, _), Tous), length(Tous, Total),
    findall(N, ( scenario(N, O, S, C, A), executer(N, O, S, C, A) ), Reussis),
    length(Reussis, R),
    format('~n~w / ~w scénarios réussis~n', [R, Total]).
