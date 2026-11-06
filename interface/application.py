#!/usr/bin/env python3
"""
Interface console - Système expert de diagnostic des maladies de la tomate.

Usage :
    python application.py            -> utilise Prolog (prolog/main.pl) si disponible,
                                        sinon bascule sur le mode simulation
    python application.py --demo     -> force le mode simulation (sans Prolog)

Prérequis pour le mode Prolog :
    - SWI-Prolog installé
    - pip install pyswip

CONTRAT AVEC LE CODE PROLOG (à valider avec Asmae)
--------------------------------------------------
Faits :
    organe(Id, Nom).                      ex: organe(feuilles, 'Feuilles').
    symptome(Id, Organe, Texte).          ex: symptome(taches_brunes, feuilles, 'Taches brunes').
    question(Id, Organe, Texte).          ex: question(q_humidite, feuilles, 'Temps humide ces derniers jours ?').
    info(Probleme, Nom, Cause, Traitement, Prevention).
    (déjà fournis par prolog/regles.pl)

Prédicats dynamiques (remplis par l'interface avant le diagnostic) :
    :- dynamic symptome_observe/1.        symptome_observe(taches_brunes).
    :- dynamic reponse/2.                 reponse(q_humidite, oui).  (oui / non)

Prédicat de diagnostic (un résultat par solution) :
    diagnostic(Organe, Probleme, Confiance).   Confiance = entier 0..100
"""

import sys

SEUIL_INCERTAIN = 50  # en dessous, on signale une situation incertaine


# ----------------------------------------------------------------------
# Backend Prolog
# ----------------------------------------------------------------------
class PrologBackend:
    def __init__(self, fichier="../prolog/main.pl"):
        from pyswip import Prolog  # peut lever ImportError
        self.prolog = Prolog()
        self.prolog.consult(fichier)

    @staticmethod
    def _txt(valeur):
        if isinstance(valeur, bytes):
            return valeur.decode("utf-8")
        return str(valeur)

    def organes(self):
        return [(self._txt(r["Id"]), self._txt(r["Nom"]))
                for r in self.prolog.query("organe(Id, Nom)")]

    def symptomes(self, organe):
        q = f"symptome(Id, {organe}, Texte)"
        return [(self._txt(r["Id"]), self._txt(r["Texte"]))
                for r in self.prolog.query(q)]

    def questions(self, organe, symptomes=()):
        # Les questions dépendent des symptômes déjà observés
        list(self.prolog.query("retractall(symptome_observe(_))"))
        for sy in symptomes:
            list(self.prolog.query(f"assertz(symptome_observe({sy}))"))
        q = f"question(Id, {organe}, Texte)"
        return [(self._txt(r["Id"]), self._txt(r["Texte"]))
                for r in self.prolog.query(q)]

    def diagnostiquer(self, organe, symptomes, reponses):
        list(self.prolog.query("retractall(symptome_observe(_))"))
        list(self.prolog.query("retractall(reponse(_, _))"))
        for s in symptomes:
            list(self.prolog.query(f"assertz(symptome_observe({s}))"))
        for qid, rep in reponses.items():
            list(self.prolog.query(f"assertz(reponse({qid}, {rep}))"))
        resultats = {}
        for r in self.prolog.query(f"diagnostic({organe}, P, C)"):
            p, c = self._txt(r["P"]), int(r["C"])
            resultats[p] = max(c, resultats.get(p, 0))
        return sorted(resultats.items(), key=lambda x: -x[1])

    def info(self, probleme):
        q = f"info({probleme}, Nom, Cause, Traitement, Prevention)"
        for r in self.prolog.query(q):
            return {k.lower(): self._txt(v) for k, v in r.items()}
        return {"nom": probleme, "cause": "?", "traitement": "?", "prevention": "?"}


# ----------------------------------------------------------------------
# Backend de simulation (pour tester l'interface sans Prolog)
# ----------------------------------------------------------------------
class DemoBackend:
    ORGANES = [("feuilles", "Feuilles"), ("fruits", "Fruits"),
               ("tiges", "Tiges"), ("racines", "Racines")]
    SYMPTOMES = {
        "feuilles": [("taches_brunes", "Taches brunes"),
                     ("jaunissement", "Jaunissement"),
                     ("feutrage_blanc", "Feutrage blanc"),
                     ("galeries", "Galeries (mines) dans les feuilles")],
        "fruits": [("pourriture_noire", "Pourriture noire à l'extrémité"),
                   ("taches_molles", "Taches molles")],
        "tiges": [("fletrissement", "Flétrissement"),
                  ("chancre", "Chancre / lésions")],
        "racines": [("galles", "Galles (renflements)"),
                    ("brunissement", "Brunissement")],
    }
    QUESTIONS = {
        "feuilles": [("q_humidite", "Le temps est-il humide depuis plusieurs jours ?")],
        "fruits": [("q_arrosage", "L'arrosage est-il irrégulier ?")],
        "tiges": [("q_chaleur", "Fait-il très chaud en ce moment ?")],
        "racines": [("q_sol", "Le sol est-il sableux ?")],
    }
    REGLES = {  # symptôme -> (problème, score)
        "taches_brunes": ("mildiou", 60), "jaunissement": ("carence_azote", 40),
        "feutrage_blanc": ("oidium", 70), "galeries": ("tuta_absoluta", 80),
        "pourriture_noire": ("pourriture_apicale", 65),
        "taches_molles": ("botrytis", 50), "fletrissement": ("fusariose", 55),
        "chancre": ("alternaria", 50), "galles": ("nematodes", 75),
        "brunissement": ("fusariose", 45),
    }
    INFOS = {
        "mildiou": ("Mildiou", "Champignon (Phytophthora infestans)",
                    "Fongicide homologué (cuivre) ; retirer les feuilles atteintes.",
                    "Éviter l'humidité sur le feuillage, aérer, rotation des cultures."),
    }

    def organes(self): return self.ORGANES
    def symptomes(self, o): return self.SYMPTOMES[o]
    def questions(self, o, symptomes=()): return self.QUESTIONS[o]

    def diagnostiquer(self, organe, symptomes, reponses):
        scores = {}
        for s in symptomes:
            p, sc = self.REGLES[s]
            scores[p] = min(100, scores.get(p, 0) + sc)
        if any(v == "oui" for v in reponses.values()):
            scores = {p: min(100, c + 10) for p, c in scores.items()}
        return sorted(scores.items(), key=lambda x: -x[1])

    def info(self, p):
        nom, cause, trait, prev = self.INFOS.get(
            p, (p.replace("_", " ").capitalize(), "(démo)", "(démo)", "(démo)"))
        return {"nom": nom, "cause": cause, "traitement": trait, "prevention": prev}


# ----------------------------------------------------------------------
# Interface utilisateur
# ----------------------------------------------------------------------
def ligne(c="=", n=60):
    print(c * n)


def choisir_un(titre, options):
    """options : liste de (id, texte). Retourne l'id choisi."""
    print(f"\n{titre}")
    for i, (_, texte) in enumerate(options, 1):
        print(f"  {i}. {texte}")
    while True:
        saisie = input("Votre choix : ").strip()
        if saisie.isdigit() and 1 <= int(saisie) <= len(options):
            return options[int(saisie) - 1][0]
        print("  Choix invalide, réessayez.")


def choisir_plusieurs(titre, options):
    """Sélection multiple : numéros séparés par des virgules."""
    print(f"\n{titre}")
    for i, (_, texte) in enumerate(options, 1):
        print(f"  {i}. {texte}")
    while True:
        saisie = input("Numéros séparés par des virgules (ex: 1,3) : ").strip()
        try:
            nums = {int(x) for x in saisie.replace(" ", "").split(",") if x}
            if nums and all(1 <= n <= len(options) for n in nums):
                return [options[n - 1][0] for n in sorted(nums)]
        except ValueError:
            pass
        print("  Saisie invalide, réessayez.")


def oui_non(question):
    while True:
        r = input(f"{question} (o/n) : ").strip().lower()
        if r in ("o", "oui"):
            return "oui"
        if r in ("n", "non"):
            return "non"
        print("  Répondez par 'o' ou 'n'.")


def afficher_resultats(backend, resultats):
    ligne()
    print("RÉSULTAT DU DIAGNOSTIC")
    ligne()
    if not resultats:
        print("Aucun diagnostic trouvé. Ajoutez des observations ou consultez un spécialiste.")
        return
    for rang, (probleme, confiance) in enumerate(resultats, 1):
        info = backend.info(probleme)
        barre = "#" * (confiance // 5) + "." * (20 - confiance // 5)
        print(f"\n{rang}. {info['nom']}  -  confiance : {confiance}%  [{barre}]")
        print(f"   Cause       : {info['cause']}")
        print(f"   Traitement  : {info['traitement']}")
        print(f"   Prévention  : {info['prevention']}")
    print()
    if resultats[0][1] < SEUIL_INCERTAIN or (
            len(resultats) > 1 and resultats[0][1] - resultats[1][1] < 10):
        print("/!\\ Diagnostic incertain : faites des observations supplémentaires "
              "ou demandez l'avis d'un technicien agricole.")
    print("Précaution : respectez les doses et les délais avant récolte indiqués "
          "sur l'étiquette des produits phytosanitaires.")


def session(backend):
    ligne()
    print("SYSTÈME EXPERT - DIAGNOSTIC DES MALADIES DE LA TOMATE")
    ligne()
    print("Culture : Tomate")

    organe = choisir_un("Quel organe est atteint ?", backend.organes())
    symptomes = choisir_plusieurs("Quels symptômes observez-vous ?",
                                  backend.symptomes(organe))

    reponses = {}
    questions = backend.questions(organe, symptomes)
    if questions:
        print("\nQuelques questions pour affiner le diagnostic :")
        for qid, texte in questions:
            reponses[qid] = oui_non(texte)

    resultats = backend.diagnostiquer(organe, symptomes, reponses)
    afficher_resultats(backend, resultats)


def creer_backend(force_demo):
    if force_demo:
        print("[Mode simulation]")
        return DemoBackend()
    try:
        return PrologBackend()
    except Exception as e:  # pyswip absent, fichier absent, erreur Prolog...
        print(f"[Prolog indisponible : {e}]\n[Bascule en mode simulation]")
        return DemoBackend()


def main():
    backend = creer_backend("--demo" in sys.argv)
    while True:
        session(backend)
        if oui_non("\nNouveau diagnostic ?") == "non":
            print("Au revoir !")
            break


if __name__ == "__main__":
    main()
