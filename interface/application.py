#!/usr/bin/env python3
"""
Interface console - Système expert de diagnostic des maladies de la tomate.

Lancer (depuis la racine du projet) :
    python interface/application.py

Utilise le même pont Prolog que l'interface web (bridge.py) :
SWI-Prolog doit être installé, aucun paquet Python à ajouter.
"""
import bridge


def ligne(c="=", n=64):
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
    print(f"\n{titre}")
    for i, (_, texte) in enumerate(options, 1):
        print(f"  {i:2}. {texte}")
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
            return True
        if r in ("n", "non"):
            return False
        print("  Répondez par 'o' ou 'n'.")


def niveau(c):
    return "élevée" if c >= 70 else "moyenne" if c >= 50 else "faible"


def afficher(rep):
    ligne()
    print("RÉSULTAT DU DIAGNOSTIC")
    ligne()
    hyp = rep["hypotheses"]
    if not hyp:
        print("Aucune hypothèse suffisante. Ajoutez des observations ou consultez un technicien.")
    for h in hyp:
        barre = "#" * (h["confiance"] // 5) + "." * (20 - h["confiance"] // 5)
        print(f"\n{h['rang']}. {h['nom']} - confiance {h['confiance']} % ({niveau(h['confiance'])}) [{barre}]")
        print(f"   {h['type']} - {h['cause']}")
        print("   Symptômes retenus : " + ", ".join(s["texte"] for s in h["symptomes"]))
        if h["conditions"]:
            print("   Conditions confirmées : " + ", ".join(c["texte"] for c in h["conditions"]))
        vide = ("aucun produit : trouble physiologique, corrigez la cause"
                if h["type"] == "Trouble physiologique" else "aucune mesure citée")
        print(f"   Traitement ({rep['mode']}) : " + (" ; ".join(h["traitement"]) or vide))
        print("   Prévention : " + (" ; ".join(h["prevention"]) or "aucun geste cité"))
        if h["a_verifier"]:
            print("   À vérifier : " + " ; ".join(h["a_verifier"]))
    for m in rep["avertissements"]:
        print(f"\n[Attention] {m}")
    for m in rep["confusions"]:
        print(f"\n[Confusion possible] {m}")
    if rep["incertain"]:
        print("\n/!\\ Diagnostic incertain : faites des observations supplémentaires (racines, "
              "loupe, face inférieure des feuilles), demandez l'avis d'un spécialiste ou "
              "envoyez un échantillon à un laboratoire.")
    print("\nPrécautions : respectez doses et délais avant récolte indiqués sur l'étiquette ; "
          "produits homologués ONSSA uniquement ; portez des gants et un masque.")


def session():
    ligne()
    print("SYSTÈME EXPERT - DIAGNOSTIC DES MALADIES DE LA TOMATE")
    ligne()
    print("Culture : Tomate")
    mode = choisir_un("Mode de production ?",
                      [("biologique", "Biologique"), ("conventionnel", "Conventionnel")])
    organe = choisir_un("Quel organe est atteint ?", bridge.organes())
    symptomes = choisir_plusieurs("Quels symptômes observez-vous ?", bridge.symptomes(organe))
    conditions = []
    questions = bridge.questions(organe, symptomes)
    if questions:
        print("\nQuelques questions pour affiner le diagnostic :")
        for qid, texte in questions:
            if oui_non(texte):
                conditions.append(qid)
    afficher(bridge.diagnostiquer(organe, symptomes, conditions, mode))


def main():
    try:
        while True:
            session()
            if not oui_non("\nNouveau diagnostic ?"):
                print("Au revoir !")
                break
    except bridge.ErreurProlog as e:
        print("Erreur Prolog :", e)


if __name__ == "__main__":
    main()
