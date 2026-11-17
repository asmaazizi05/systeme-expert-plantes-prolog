"""
Interface web (Streamlit) - Système expert de diagnostic des maladies de la tomate.

Lancer (depuis la racine du projet) :
    pip install streamlit
    streamlit run interface/application_web.py

Le moteur de diagnostic est entièrement en Prolog (prolog/*.pl) ;
cette interface ne fait que guider l'utilisateur et afficher les résultats.
"""
import streamlit as st

import bridge

st.set_page_config(page_title="Diagnostic tomate", page_icon="🍅", layout="centered")

ETAPES = ["Situation", "Symptômes", "Questions", "Résultat"]

PRECAUTIONS = [
    "Lire l'étiquette du produit et respecter la dose et le nombre d'applications.",
    "Porter des équipements de protection (gants, masque, lunettes) pendant le traitement.",
    "Respecter le délai avant récolte (DAR) indiqué sur l'étiquette avant toute cueillette.",
    "N'utiliser que des produits homologués au Maroc (index phytosanitaire de l'ONSSA).",
]
PRECAUTION_BIO = ("En production biologique, vérifiez aussi que le produit est autorisé "
                  "par votre cahier des charges ou votre organisme certificateur.")


# ---------------------------- état et navigation ----------------------------

def init_etat():
    st.session_state.setdefault("etape", 0)
    st.session_state.setdefault("mode", "biologique")
    st.session_state.setdefault("organe", None)
    st.session_state.setdefault("symptomes", [])
    st.session_state.setdefault("conditions", [])


def aller(etape):
    st.session_state["etape"] = etape


def recommencer():
    for cle in list(st.session_state.keys()):
        del st.session_state[cle]


@st.cache_data(show_spinner=False)
def charger_organes():
    return bridge.organes()


@st.cache_data(show_spinner=False)
def charger_symptomes(organe):
    return bridge.symptomes(organe)


def niveau(confiance):
    if confiance >= 70:
        return "élevée"
    if confiance >= 50:
        return "moyenne"
    return "faible"


def liste_puces(elements, vide):
    if not elements:
        st.write(vide)
        return
    for e in elements:
        st.markdown(f"- {e}")


# ---------------------------- étapes ----------------------------

def etape_situation():
    st.subheader("1. Votre situation")
    st.write("**Culture :** Tomate 🍅")

    mode = st.radio(
        "Mode de production",
        ["biologique", "conventionnel"],
        format_func=lambda m: "Biologique" if m == "biologique" else "Conventionnel",
        index=0 if st.session_state["mode"] == "biologique" else 1,
        horizontal=True,
    )
    st.session_state["mode"] = mode

    organes = charger_organes()
    ids = [o[0] for o in organes]
    noms = dict(organes)
    actuel = st.session_state["organe"]
    organe = st.radio(
        "Quel organe de la plante est atteint ?",
        ids,
        format_func=lambda i: noms[i],
        index=ids.index(actuel) if actuel in ids else 0,
    )
    if st.button("Suivant", type="primary"):
        if organe != st.session_state["organe"]:
            st.session_state["symptomes"] = []
            st.session_state["conditions"] = []
        st.session_state["organe"] = organe
        aller(1)
        st.rerun()


def etape_symptomes():
    organe = st.session_state["organe"]
    st.subheader("2. Quels symptômes observez-vous ?")
    st.caption("Cochez tout ce que vous voyez. Plus vous cochez de symptômes, plus le diagnostic est précis.")

    choisis = []
    with st.container(height=420, border=True):
        for sid, texte in charger_symptomes(organe):
            defaut = sid in st.session_state["symptomes"]
            if st.checkbox(texte, value=defaut, key=f"sym_{organe}_{sid}"):
                choisis.append(sid)
    if choisis:
        st.caption(f"{len(choisis)} symptôme(s) sélectionné(s).")

    col1, col2 = st.columns(2)
    if col1.button("← Retour"):
        aller(0)
        st.rerun()
    if col2.button("Suivant", type="primary"):
        if not choisis:
            st.warning("Cochez au moins un symptôme.")
        else:
            st.session_state["symptomes"] = choisis
            aller(2)
            st.rerun()


def etape_questions():
    organe = st.session_state["organe"]
    st.subheader("3. Quelques questions pour affiner")
    questions = bridge.questions(organe, st.session_state["symptomes"])

    OPTIONS = ["Oui", "Non", "Je ne sais pas"]
    reponses = {}
    if not questions:
        st.write("Aucune question supplémentaire pour ces symptômes.")
    for qid, texte in questions:
        defaut = "Oui" if qid in st.session_state["conditions"] else "Je ne sais pas"
        reponses[qid] = st.radio(texte, OPTIONS, index=OPTIONS.index(defaut),
                                 horizontal=True, key=f"q_{qid}")

    col1, col2 = st.columns(2)
    if col1.button("← Retour"):
        aller(1)
        st.rerun()
    if col2.button("Voir le diagnostic", type="primary"):
        st.session_state["conditions"] = [q for q, r in reponses.items() if r == "Oui"]
        aller(3)
        st.rerun()


def carte_hypothese(h, mode, ouvert):
    titre = f"{h['rang']}. {h['nom']} - confiance {h['confiance']} % ({niveau(h['confiance'])})"
    with st.expander(titre, expanded=ouvert):
        st.progress(min(h["confiance"], 100) / 100)
        st.caption(f"{h['type']} · cause : {h['cause']}")
        t1, t2, t3 = st.tabs(["Pourquoi ce diagnostic ?", "Plan d'action", "À vérifier"])

        with t1:
            st.markdown("**Symptômes observés correspondant à ce problème :**")
            liste_puces([f"{s['texte']} (poids {s['certitude']})" for s in h["symptomes"]],
                        "Aucun.")
            if h["conditions"]:
                st.markdown("**Conditions favorables confirmées :**")
                liste_puces([f"{c['texte']} (poids {c['certitude']})" for c in h["conditions"]],
                            "Aucune.")
            st.caption("Le niveau de confiance combine les poids des symptômes et des conditions "
                       "avec la méthode des facteurs de certitude (type MYCIN).")

        with t2:
            nom_mode = "biologique" if mode == "biologique" else "conventionnel"
            st.markdown(f"**Traitement ({nom_mode}) :**")
            if h["type"] == "Trouble physiologique":
                vide = ("Aucun produit à appliquer : c'est un trouble physiologique, "
                        "corrigez la cause (voir les gestes culturaux ci-dessous).")
            else:
                vide = f"Aucune mesure {nom_mode} citée dans la base pour ce problème."
            liste_puces(h["traitement"], vide)
            st.markdown("**Gestes culturaux et prévention :**")
            liste_puces(h["prevention"], "Aucun geste cultural cité dans la base.")
            st.markdown("**Précautions d'emploi :**")
            for p in PRECAUTIONS:
                st.markdown(f"- {p}")
            if mode == "biologique":
                st.markdown(f"- {PRECAUTION_BIO}")

        with t3:
            if h["a_verifier"]:
                st.markdown("**Autres signes à rechercher pour confirmer :**")
                liste_puces(h["a_verifier"], "")
            else:
                st.write("Vous avez déjà signalé tous les symptômes connus pour ce problème.")


def etape_resultat():
    st.subheader("4. Résultat du diagnostic")
    rep = bridge.diagnostiquer(
        st.session_state["organe"],
        st.session_state["symptomes"],
        st.session_state["conditions"],
        st.session_state["mode"],
    )
    hyp = rep["hypotheses"]

    if not hyp:
        st.warning("Aucune hypothèse suffisante avec ces observations. Ajoutez d'autres "
                   "symptômes ou consultez un technicien agricole.")
    else:
        for h in hyp:
            carte_hypothese(h, rep["mode"], ouvert=(h["rang"] == 1))

        for msg in rep["avertissements"]:
            st.warning(msg)
        for msg in rep["confusions"]:
            st.info("**Confusion possible.** " + msg)

    if rep["incertain"]:
        st.error(
            "**Diagnostic incertain.** Faites des observations supplémentaires (voir l'onglet "
            "« À vérifier » de chaque hypothèse : examen des racines, observation à la loupe, "
            "face inférieure des feuilles) ou demandez l'avis d'un spécialiste. En cas de doute "
            "persistant, envoyez un échantillon de plante à un laboratoire de phytopathologie "
            "(par exemple via l'ONSSA ou un institut agronomique)."
        )

    st.caption("Ce diagnostic est une aide de premier niveau. Il ne remplace pas l'avis d'un "
               "ingénieur agronome ni une analyse en laboratoire.")

    col1, col2 = st.columns(2)
    if col1.button("← Modifier mes réponses"):
        aller(2)
        st.rerun()
    if col2.button("Nouveau diagnostic", type="primary"):
        recommencer()
        st.rerun()


# ---------------------------- application ----------------------------

def main():
    init_etat()
    st.title("🍅 Diagnostic des maladies de la tomate")

    etape = st.session_state["etape"]
    st.progress((etape + 1) / len(ETAPES), text=f"Étape {etape + 1} sur {len(ETAPES)} : {ETAPES[etape]}")

    with st.sidebar:
        st.header("À propos")
        st.write("Système expert en Prolog : il pose des questions comme un agronome, puis propose "
                 "les causes probables avec un niveau de confiance.")
        st.write("Master IA - Fondements avancés de l'IA")
        if st.button("Recommencer"):
            recommencer()
            st.rerun()

    try:
        [etape_situation, etape_symptomes, etape_questions, etape_resultat][etape]()
    except bridge.ErreurProlog as e:
        st.error("Erreur du moteur Prolog : " + str(e))
        st.stop()


main()
