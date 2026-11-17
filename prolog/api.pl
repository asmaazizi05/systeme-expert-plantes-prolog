:- encoding(utf8).
% ============================================================
% api.pl - Pont entre l'interface (Python) et le moteur Prolog
% Lancer :  swipl -q -g api_main -t halt api.pl   (requête JSON sur stdin)
% Ne modifie AUCUN fichier existant : il charge main.pl tel quel.
% ============================================================
:- use_module(library(http/json)).
:- use_module(library(lists)).
:- use_module(library(apply)).

:- [main].   % charge faits, libelles, regles, diagnostic

api_main :-
    set_stream(user_input, encoding(utf8)),
    set_stream(user_output, encoding(utf8)),
    catch(
        ( json_read_dict(user_input, Req),
          handle(Req, Resp) ),
        E,
        ( term_string(E, Msg), Resp = _{erreur: Msg} )
    ),
    json_write_dict(current_output, Resp, [width(0)]),
    nl.

a(Dict, Cle, Atome) :-
    get_dict(Cle, Dict, Valeur),
    atom_string(Atome, Valeur).

liste_a(Dict, Cle, Atomes) :-
    (   get_dict(Cle, Dict, Vs)
    ->  maplist([V, A]>>atom_string(A, V), Vs, Atomes)
    ;   Atomes = []
    ).

charger_observations(Dict) :-
    reinitialiser,
    liste_a(Dict, symptomes, Ss),
    forall(member(S, Ss), assertz(symptome_observe(S))),
    liste_a(Dict, conditions, Cs),
    forall(member(C, Cs), assertz(reponse(C, oui))).

% ---------------- actions ----------------

handle(Req, Resp) :-
    get_dict(action, Req, "organes"), !,
    findall(_{id: Id, nom: Nom}, organe(Id, Nom), L),
    Resp = _{organes: L}.

handle(Req, Resp) :-
    get_dict(action, Req, "symptomes"), !,
    a(Req, organe, O),
    findall(T-Id, symptome(Id, O, T), Paires0),
    sort(Paires0, Paires),
    findall(_{id: Id, texte: T}, member(T-Id, Paires), L),
    Resp = _{symptomes: L}.

handle(Req, Resp) :-
    get_dict(action, Req, "questions"), !,
    a(Req, organe, O),
    charger_observations(Req),
    findall(Id-T, question(Id, O, T), Paires0),
    sort(Paires0, Paires),
    findall(_{id: Id, texte: T}, member(Id-T, Paires), L),
    Resp = _{questions: L}.

handle(Req, Resp) :-
    get_dict(action, Req, "diagnostic"), !,
    a(Req, organe, O),
    ( a(Req, mode, Mode) -> true ; Mode = biologique ),
    charger_observations(Req),
    diagnostics(O, Liste),
    findall(H,
            ( nth1(Rang, Liste, P-M), hypothese(O, Rang, P, M, Mode, H) ),
            Hs),
    ( confusions(Liste, Confs) -> true ; Confs = [] ),
    ( avertissements_liste(Liste, Avs) -> true ; Avs = [] ),
    ( incertain(Liste) -> Inc = true ; Inc = false ),
    Resp = _{ hypotheses: Hs, confusions: Confs, avertissements: Avs,
              incertain: Inc, mode: Mode }.

handle(_, _{erreur: "action inconnue"}).

% ---------------- une hypothèse ----------------

hypothese(O, Rang, P, M, Mode,
          _{ rang: Rang, id: M, nom: Nom, confiance: P, cause: Cause,
             type: TT, symptomes: Ss, conditions: Cs,
             traitement: Trait, prevention: Prev, a_verifier: AV }) :-
    nom_maladie(M, Nom),
    maladie(M, Type),
    type_texte(Type, TT),
    cause(M, C),
    format(atom(Cause), '~w', [C]),
    raisons(O, M, Sy, Co),
    findall(_{texte: L, certitude: K}, member(L-K, Sy), Ss),
    findall(_{texte: L, certitude: K}, member(L-K, Co), Cs),
    mesures(M, [Mode], T0), list_to_set(T0, Trait),
    mesures(M, [cultural], P0), list_to_set(P0, Prev),
    a_verifier(M, AV).

% Observations complémentaires : symptômes connus de la maladie
% que l'utilisateur n'a pas encore signalés (les plus discriminants d'abord).
a_verifier(M, Textes) :-
    findall(C-L,
            ( symptome_maladie(M, S, C), \+ symptome_observe(S), texte(S, L) ),
            Ps0),
    sort(0, @>=, Ps0, Ps),
    findall(L, member(_-L, Ps), Ls0),
    list_to_set(Ls0, Ls),
    (   append(Textes, _, Ls), length(Textes, 3) -> true ; Textes = Ls ).
