
:- encoding(utf8).

seuil_affichage(30).
seuil_incertain(50).
ecart_min(10).
ecart_confusion(25).

diagnostics(Organe, Liste) :-
    seuil_affichage(S),
    findall(
        P-M,
        (
            maladie_candidate(Organe, M),
            confiance(Organe, M, P),
            P >= S
        ),
        Paires
    ),
    sort(1, @>=, Paires, Liste).

diagnostic(Organe, M, P) :-
    diagnostics(Organe, Liste),
    member(P-M, Liste).

incertain([]).

incertain([P1-_|_]) :-
    seuil_incertain(S),
    P1 < S.

incertain([P1-_, P2-_|_]) :-
    ecart_min(E),
    P1 - P2 < E.

premiers_trois(Liste, Top) :-
    (
        Liste = [A, B, C|_]
    ->
        Top = [A, B, C]
    ;
        Top = Liste
    ).

confusion_entre(A, B, Msg) :-
    (
        confusion(A, B, Msg)
    ;
        confusion(B, A, Msg)
    ).

confusions(Liste, Messages) :-
    premiers_trois(Liste, Top),
    ecart_confusion(E),
    findall(
        Msg,
        (
            member(P1-A, Top),
            member(P2-B, Top),
            A @< B,
            abs(P1 - P2) =< E,
            confusion_entre(A, B, Msg)
        ),
        Ms
    ),
    sort(Ms, Messages).

avertissements_liste(Liste, Messages) :-
    premiers_trois(Liste, Top),
    findall(
        Msg,
        (
            member(_-M, Top),
            avertissement(M, Msg)
        ),
        Ms
    ),
    sort(Ms, Messages).

raisons(Organe, M, Symptomes, Conditions) :-
    findall(
        L-C,
        (
            symptome_present(Organe, M, S, C),
            texte(S, L)
        ),
        Symptomes
    ),
    findall(
        L-C,
        (
            condition_favorable(M, Cd, C),
            reponse(Cd, oui),
            texte(Cd, L)
        ),
        Conditions
    ).

reinitialiser :-
    retractall(symptome_observe(_)),
    retractall(reponse(_, _)).

