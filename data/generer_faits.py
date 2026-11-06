
import re
import sys
import os
import pandas as pd

xlsx = sys.argv[1] if len(sys.argv) > 1 else "base_connaissances_tomate_v4.xlsx"
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "prolog")


def q(s):
    s = str(s).strip()
    if re.fullmatch(r"[a-z][A-Za-z0-9_]*", s):
        return s
    return "'" + s.replace("\\", "\\\\").replace("'", "\\'") + "'"


MOTS = dict(
    humidite="humidité",
    elevee="élevée",
    elevees="élevées",
    temperature="température",
    temperatures="températures",
    moderee="modérée",
    fletrissement="flétrissement",
    necrose="nécrose",
    necroses="nécroses",
    necrotique="nécrotique",
    lesions="lésions",
    lesion="lésion",
    deja="déjà",
    irreguliere="irrégulière",
    residus="résidus",
    variete="variété",
    elimination="élimination",
    eviter="éviter",
    resistante="résistante",
    dejections="déjections",
    reduites="réduites",
    agees="âgées",
    superieure="supérieure",
    inferieure="inférieure",
    brulee="brûlée",
    brules="brûlés",
    oeil="œil",
    surelevees="surélevées",
    liegeuses="liégeuses",
    croutes="croûtes",
    cote="côté",
    expose="exposé",
    blanchatre="blanchâtre",
    epaules="épaules",
    pedoncule="pédoncule",
    fantomes="fantômes",
    apres="après",
    dessechement="dessèchement",
    perturbes="perturbés",
    poussiereuses="poussiéreuses",
    azotee="azotée",
    endommagees="endommagées",
    eclaboussures="éclaboussures",
    infectes="infectés",
    infecte="infecté",
    contamines="contaminés",
    contaminees="contaminées",
    solanacees="solanacées",
    hotes="hôtes",
    defoliation="défoliation",
    presence="présence",
    debut="début",
    fraiche="fraîche",
    recente="récente",
    verifier="vérifier",
    spontanes="spontanés",
    periode="période",
    sup=">",
    desinfection="désinfection",
    eliminer="éliminer",
    detruire="détruire",
    residu="résidu"
)


def libelle(i):
    i = str(i).strip()
    if i.startswith("("):
        return i
    t = " ".join(MOTS.get(w, w) for w in i.split("_"))
    t = re.sub(r"\b([dl]) ", lambda m: m.group(1) + "’", t)
    return t[0].upper() + t[1:]


m = pd.read_excel(xlsx, "Maladies")
s = pd.read_excel(xlsx, "Symptomes")
c = pd.read_excel(xlsx, "Conditions")
t = pd.read_excel(xlsx, "Traitements")

L = [
    ":- encoding(utf8).",
    "% GÉNÉRÉ par data/generer_faits.py à partir de " + os.path.basename(xlsx) + " - ne pas modifier à la main.",
    ":- discontiguous maladie/2, cause/2, organe_maladie/2, symptome_maladie/3, "
    "symptome_organe/2, condition_favorable/3, traitement/3.",
    "",
    "culture(tomate, maraichage).",
    ""
]

for _, r in m.iterrows():
    L.append(f"maladie({q(r.Maladie)}, {q(r.Type)}).")

L.append("")

for _, r in m.iterrows():
    L.append(f"cause({q(r.Maladie)}, {q(r.Nom_latin_ou_cause)}).")

L.append("")

for _, r in m.iterrows():
    for o in str(r.Organes).split(";"):
        L.append(f"organe_maladie({q(r.Maladie)}, {q(o.strip())}).")

L.append("")

for _, r in s.iterrows():
    L.append(
        f"symptome_maladie({q(r.Maladie)}, {q(r.Symptome)}, {float(r.Certitude)})."
    )

L.append("")

for sym, org in sorted({(r.Symptome, r.Organe) for _, r in s.iterrows()}):
    L.append(f"symptome_organe({q(sym)}, {q(org)}).")

L.append("")

for _, r in c.iterrows():
    L.append(
        f"condition_favorable({q(r.Maladie)}, {q(r.Condition)}, {float(r.Certitude)})."
    )

L.append("")

for _, r in t.iterrows():
    L.append(
        f"traitement({q(r.Maladie)}, {q(r.Mode)}, {q(r.Mesure_ou_produit)})."
    )

open(
    os.path.join(OUT, "faits.pl"),
    "w",
    encoding="utf-8"
).write("\n".join(L) + "\n")


lib = os.path.join(OUT, "libelles.pl")

if not os.path.exists(lib):
    ids = sorted(
        set(s.Symptome)
        | set(c.Condition)
        | set(t.Mesure_ou_produit.astype(str))
    )

    out = [
        ":- encoding(utf8).",
        "% Textes affichés à l'utilisateur. MODIFIABLE à la main (jamais écrasé).",
        ""
    ]

    out += [
        f"libelle({q(i)}, {q(libelle(i))})."
        for i in ids
    ]

    open(
        lib,
        "w",
        encoding="utf-8"
    ).write("\n".join(out) + "\n")


print(
    "OK :",
    len(m), "maladies,",
    len(s), "symptômes,",
    len(c), "conditions,",
    len(t), "traitements"
)

