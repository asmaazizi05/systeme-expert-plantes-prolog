
:- encoding(utf8).

:- [faits, libelles, regles, diagnostic].

demarrer :-
    catch(set_stream(user_output, encoding(utf8)), _, true),
    catch(set_stream(user_input, encoding(utf8)), _, true),
    repeat,
        session,
        lire_oui_non('Nouveau diagnostic ?', Rep),
        Rep == non,
    !,
    writeln('Au revoir !').

session :-
    reinitialiser,
    nl,
    writeln('=== SYSTÈME EXPERT - DIAGNOSTIC DES MALADIES DE LA TOMATE ==='),
    findall(Id-Nom, organe(Id, Nom), Organes),
    choisir_un('Quel organe est atteint ?', Organes, Organe),
    findall(Id-T, symptome(Id, Organe, T), Symptomes),
    choisir_plusieurs('Quels symptômes observez-vous ?', Symptomes, Choisis),
    forall(member(S, Choisis), assertz(symptome_observe(S))),
    poser_questions(Organe),
    afficher_resultats(Organe).

afficher_options(Options) :-
    forall(
        nth1(I, Options, _-T),
        format('  ~w. ~w~n', [I, T])
    ).

choisir_un(Titre, Options, Id) :-
    nl,
    writeln(Titre),
    afficher_options(Options),
    length(Options, N),
    repeat,
        write('Votre choix : '),
        flush_output,
        read_line_to_string(user_input, Ligne),
        number_string(K, Ligne),
        integer(K),
        K >= 1,
        K =< N,
    !,
    nth1(K, Options, Id-_).

choisir_plusieurs(Titre, Options, Ids) :-
    nl,
    writeln(Titre),
    afficher_options(Options),
    length(Options, N),
    repeat,
        write('Numéros séparés par des virgules (ex: 1,3) : '),
        flush_output,
        read_line_to_string(user_input, Ligne),
        split_string(Ligne, ",", " ", Parts),
        Parts \= [""],
        maplist(
            [P, K]>>(
                number_string(K, P),
                integer(K),
                K >= 1,
                K =< N
            ),
            Parts,
            Ks
        ),
    !,
    sort(Ks, Ks1),
    findall(
        Id,
        (member(K, Ks1), nth1(K, Options, Id-_)),
        Ids
    ).

lire_oui_non(Question, Rep) :-
    repeat,
        format('~w (o/n) : ', [Question]),
        flush_output,
        read_line_to_string(user_input, L0),
        string_lower(L0, L),
        (
            memberchk(L, ["o", "oui"]) -> Rep = oui
        ;
            memberchk(L, ["n", "non"]) -> Rep = non
        ),
    !.

poser_questions(Organe) :-
    findall(Id-T, question(Id, Organe, T), Qs),
    (
        Qs == []
    ->
        true
    ;
        nl,
        writeln('Quelques questions pour affiner le diagnostic :'),
        forall(
            member(Id-T, Qs),
            (
                lire_oui_non(T, R),
                assertz(reponse(Id, R))
            )
        )
    ).

afficher_resultats(Organe) :-
    diagnostics(Organe, Liste),
    nl,
    writeln('=== RÉSULTAT DU DIAGNOSTIC ==='),
    (
        Liste == []
    ->
        writeln(
            'Aucune hypothèse suffisante. Faites d’autres observations ou consultez un technicien agricole.'
        )
    ;
        forall(
            nth1(Rang, Liste, P-M),
            afficher_hypothese(Organe, Rang, P, M)
        ),
        confusions(Liste, Confs),
        forall(
            member(C, Confs),
            format('~n[Confusion possible] ~w~n', [C])
        ),
        avertissements_liste(Liste, Avs),
        forall(
            member(A, Avs),
            format('[Attention] ~w~n', [A])
        ),
        (
            incertain(Liste)
        ->
            nl,
            writeln(
                'Diagnostic incertain : faites des observations supplémentaires ou demandez l’avis d’un spécialiste.'
            )
        ;
            true
        ),
        nl,
        writeln(
            'Précaution : respectez doses et délais avant récolte indiqués sur l’étiquette des produits.'
        )
    ).

afficher_hypothese(Organe, Rang, P, M) :-
    info(M, Nom, Cause, Traitement, Prevention),
    raisons(Organe, M, Ss, _),
    findall(L, member(L-_, Ss), Ls),
    atomic_list_concat(Ls, ', ', Raisons),
    format('~n~w. ~w - confiance : ~w %~n', [Rang, Nom, P]),
    format(
        '   Cause       : ~w~n   Symptômes   : ~w~n   Traitement  : ~w~n   Prévention  : ~w~n',
        [Cause, Raisons, Traitement, Prevention]
    ).
