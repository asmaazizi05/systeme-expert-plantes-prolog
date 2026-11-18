"""
Pont Python <-> Prolog.

Python lance SWI-Prolog (prolog/api.pl), lui envoie une requête JSON sur
l'entrée standard et lit la réponse JSON. Aucune bibliothèque Python
supplémentaire n'est nécessaire (pas de pyswip).

Prérequis : SWI-Prolog installé (commande `swipl`).
Si `swipl` n'est pas trouvé automatiquement, définir la variable
d'environnement SWIPL avec son chemin complet.
"""
import json
import os
import shutil
import subprocess
from pathlib import Path

DOSSIER_PROLOG = Path(__file__).resolve().parent.parent / "prolog"

CHEMINS_USUELS = [
    r"C:\Program Files\swipl\bin\swipl.exe",
    r"C:\Program Files (x86)\swipl\bin\swipl.exe",
    "/Applications/SWI-Prolog.app/Contents/MacOS/swipl",
    "/opt/homebrew/bin/swipl",
    "/usr/local/bin/swipl",
    "/usr/bin/swipl",
]


class ErreurProlog(RuntimeError):
    pass


def trouver_swipl():
    chemin = os.environ.get("SWIPL") or shutil.which("swipl")
    if chemin:
        return chemin
    for c in CHEMINS_USUELS:
        if os.path.exists(c):
            return c
    raise ErreurProlog(
        "SWI-Prolog introuvable. Installez-le (https://www.swi-prolog.org) "
        "ou définissez la variable d'environnement SWIPL."
    )


def appeler(requete):
    """Envoie une requête (dict) à Prolog et retourne la réponse (dict)."""
    cmd = [trouver_swipl(), "-q", "-g", "api_main", "-t", "halt", "api.pl"]
    try:
        r = subprocess.run(
            cmd,
            input=json.dumps(requete, ensure_ascii=False),
            capture_output=True,
            text=True,
            encoding="utf-8",
            timeout=30,
            cwd=DOSSIER_PROLOG,
        )
    except subprocess.TimeoutExpired as e:
        raise ErreurProlog("Prolog ne répond pas (délai dépassé).") from e
    sortie = r.stdout.strip()
    if not sortie:
        raise ErreurProlog("Réponse vide de Prolog.\n" + r.stderr[-800:])
    try:
        rep = json.loads(sortie)
    except json.JSONDecodeError as e:
        raise ErreurProlog("Réponse Prolog illisible : " + sortie[:300]) from e
    if "erreur" in rep:
        raise ErreurProlog(rep["erreur"])
    return rep


# ---------------- fonctions utilisées par les interfaces ----------------

def organes():
    return [(o["id"], o["nom"]) for o in appeler({"action": "organes"})["organes"]]


def symptomes(organe):
    rep = appeler({"action": "symptomes", "organe": organe})
    return [(s["id"], s["texte"]) for s in rep["symptomes"]]


def questions(organe, symptomes_observes):
    rep = appeler({"action": "questions", "organe": organe,
                   "symptomes": list(symptomes_observes)})
    return [(q["id"], q["texte"]) for q in rep["questions"]]


def diagnostiquer(organe, symptomes_observes, conditions_oui, mode):
    """mode : 'biologique' ou 'conventionnel'."""
    return appeler({"action": "diagnostic", "organe": organe,
                    "symptomes": list(symptomes_observes),
                    "conditions": list(conditions_oui), "mode": mode})
