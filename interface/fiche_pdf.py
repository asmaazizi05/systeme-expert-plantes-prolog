"""
Génération de la fiche de diagnostic en PDF (bouton « Télécharger » de l'interface web).

Nécessite : pip install reportlab
Le reste du projet fonctionne sans reportlab ; seul le bouton PDF est désactivé.
"""
from datetime import datetime
from io import BytesIO
from xml.sax.saxutils import escape

try:
    from reportlab.graphics.shapes import Drawing, Rect
    from reportlab.lib import colors
    from reportlab.lib.pagesizes import A4
    from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
    from reportlab.lib.units import cm
    from reportlab.platypus import (KeepTogether, Paragraph, SimpleDocTemplate,
                                    Spacer, Table, TableStyle)
    DISPONIBLE = True
except ImportError:  # reportlab non installé
    DISPONIBLE = False

PRECAUTIONS = [
    "Lire l'étiquette du produit et respecter la dose et le nombre d'applications.",
    "Porter des équipements de protection (gants, masque, lunettes) pendant le traitement.",
    "Respecter le délai avant récolte (DAR) indiqué sur l'étiquette avant toute cueillette.",
    "N'utiliser que des produits homologués au Maroc (index phytosanitaire de l'ONSSA).",
]
PRECAUTION_BIO = ("En production biologique, vérifiez aussi que le produit est autorisé "
                  "par votre cahier des charges ou votre organisme certificateur.")
MESSAGE_INCERTAIN = (
    "Diagnostic incertain. Faites des observations supplémentaires (examen des racines, "
    "observation à la loupe, face inférieure des feuilles) ou demandez l'avis d'un "
    "spécialiste. En cas de doute persistant, envoyez un échantillon de plante à un "
    "laboratoire de phytopathologie (par exemple via l'ONSSA ou un institut agronomique)."
)
AVERTISSEMENT_FINAL = (
    "Ce diagnostic est une aide de premier niveau. Il ne remplace pas l'avis d'un "
    "ingénieur agronome ni une analyse en laboratoire."
)
NB_DETAILS_MAX = 3
VERT = "#2E7D32"


def niveau(confiance):
    if confiance >= 70:
        return "élevée"
    if confiance >= 50:
        return "moyenne"
    return "faible"


def message_traitement_vide(type_probleme, mode):
    if type_probleme == "Trouble physiologique":
        return ("Aucun produit à appliquer : c'est un trouble physiologique, corrigez la "
                "cause (voir les gestes culturaux).")
    return f"Aucune mesure {mode} citée dans la base pour ce problème."


def _t(texte):
    """Texte sûr pour reportlab : jeu de caractères Windows-1252 + échappement XML."""
    s = str(texte).replace("\u202f", " ").replace("\u00a0", " ")
    s = s.encode("cp1252", errors="replace").decode("cp1252")
    return escape(s)


def _barre(confiance, largeur, hauteur):
    c = colors.HexColor("#2E7D32" if confiance >= 70 else "#EF9F27" if confiance >= 50 else "#C0392B")
    d = Drawing(largeur, hauteur)
    d.add(Rect(0, 0, largeur, hauteur, fillColor=colors.HexColor("#E0E0E0"), strokeColor=None))
    d.add(Rect(0, 0, largeur * min(max(confiance, 0), 100) / 100, hauteur,
               fillColor=c, strokeColor=None))
    return d


def _pied_de_page(canvas, doc):
    canvas.saveState()
    canvas.setFont("Helvetica", 8)
    canvas.setFillColor(colors.HexColor("#666666"))
    canvas.drawString(2 * cm, 1.2 * cm, "Système expert - diagnostic des maladies de la tomate")
    canvas.drawRightString(A4[0] - 2 * cm, 1.2 * cm, f"Page {doc.page}")
    canvas.restoreState()


def generer_fiche(rep, organe_nom, symptomes, conditions, mode, culture="Tomate"):
    """
    rep         : réponse de bridge.diagnostiquer(...)
    organe_nom  : nom affichable de l'organe
    symptomes   : libellés des symptômes cochés
    conditions  : libellés des conditions confirmées (réponse « Oui »)
    mode        : 'biologique' ou 'conventionnel'
    Retourne le PDF sous forme de bytes.
    """
    if not DISPONIBLE:
        raise RuntimeError("reportlab n'est pas installé (pip install reportlab).")

    base = getSampleStyleSheet()
    normal = ParagraphStyle("n", parent=base["Normal"], fontName="Helvetica", fontSize=10, leading=13.5)
    petit = ParagraphStyle("p", parent=normal, fontSize=8.5, leading=11, textColor=colors.HexColor("#555555"))
    titre = ParagraphStyle("t", parent=normal, fontName="Helvetica-Bold", fontSize=19, leading=23,
                           textColor=colors.HexColor(VERT), spaceAfter=2)
    h2 = ParagraphStyle("h2", parent=normal, fontName="Helvetica-Bold", fontSize=12.5, leading=16,
                        textColor=colors.HexColor(VERT), spaceBefore=12, spaceAfter=4)
    h3 = ParagraphStyle("h3", parent=normal, fontName="Helvetica-Bold", fontSize=11, leading=14,
                        spaceBefore=3, spaceAfter=2)
    puce = ParagraphStyle("b", parent=normal, leftIndent=14, bulletIndent=4, spaceAfter=1.5)
    alerte = ParagraphStyle("a", parent=normal, backColor=colors.HexColor("#FFF4E5"),
                            borderPadding=(5, 6, 5, 6), spaceBefore=4, spaceAfter=6)
    erreur = ParagraphStyle("e", parent=alerte, backColor=colors.HexColor("#FDECEA"))
    info = ParagraphStyle("i", parent=alerte, backColor=colors.HexColor("#E8F1FB"))

    def puces(elements, vide=None):
        if not elements:
            return [Paragraph(_t(vide), normal)] if vide else []
        return [Paragraph(_t(e), puce, bulletText="•") for e in elements]

    nom_mode = "Biologique" if mode == "biologique" else "Conventionnel"
    maintenant = datetime.now().strftime("%d/%m/%Y à %H:%M")

    histoire = [
        Paragraph("Fiche de diagnostic", titre),
        Paragraph(_t(f"Culture : {culture}  ·  Établie le {maintenant}"), petit),
        Spacer(1, 6),
    ]

    # --- contexte
    contexte = Table(
        [[Paragraph("<b>Organe atteint</b>", normal), Paragraph(_t(organe_nom), normal)],
         [Paragraph("<b>Mode de production</b>", normal), Paragraph(_t(nom_mode), normal)]],
        colWidths=[4.5 * cm, 12.5 * cm])
    contexte.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (0, -1), colors.HexColor("#F1F8F1")),
        ("BOX", (0, 0), (-1, -1), 0.5, colors.HexColor("#C8D8C8")),
        ("INNERGRID", (0, 0), (-1, -1), 0.25, colors.HexColor("#C8D8C8")),
        ("TOPPADDING", (0, 0), (-1, -1), 4), ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
    ]))
    histoire.append(contexte)

    histoire.append(Paragraph("Observations de l'utilisateur", h2))
    histoire.append(Paragraph("<b>Symptômes observés :</b>", normal))
    histoire += puces(symptomes, "Aucun.")
    histoire.append(Spacer(1, 3))
    histoire.append(Paragraph("<b>Conditions confirmées :</b>", normal))
    histoire += puces(conditions, "Aucune condition confirmée.")

    # --- résumé des hypothèses
    hyp = rep.get("hypotheses", [])
    histoire.append(Paragraph("Diagnostic probable", h2))
    if not hyp:
        histoire.append(Paragraph(_t(
            "Aucune hypothèse suffisante avec ces observations. Ajoutez d'autres symptômes "
            "ou consultez un technicien agricole."), alerte))
    else:
        lignes = [[Paragraph("<b>#</b>", normal), Paragraph("<b>Problème</b>", normal),
                   Paragraph("<b>Type</b>", normal), Paragraph("<b>Confiance</b>", normal)]]
        for h in hyp:
            lignes.append([
                Paragraph(str(h["rang"]), normal),
                Paragraph(_t(h["nom"]), normal),
                Paragraph(_t(h["type"]), normal),
                [_barre(h["confiance"], 3.4 * cm, 0.3 * cm),
                 Paragraph(_t(f"{h['confiance']} % ({niveau(h['confiance'])})"), petit)],
            ])
        tab = Table(lignes, colWidths=[1 * cm, 7 * cm, 3.6 * cm, 5.4 * cm], repeatRows=1)
        tab.setStyle(TableStyle([
            ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#E3F0E3")),
            ("LINEBELOW", (0, 0), (-1, -1), 0.25, colors.HexColor("#C8D8C8")),
            ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
            ("TOPPADDING", (0, 0), (-1, -1), 4), ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
        ]))
        histoire.append(tab)

        # --- détail des meilleures hypothèses
        for h in hyp[:NB_DETAILS_MAX]:
            bloc = [
                Paragraph(_t(f"{h['rang']}. {h['nom']} - {h['confiance']} % ({niveau(h['confiance'])})"), h2),
                Paragraph(_t(f"{h['type']} · cause : {h['cause']}"), petit),
                Spacer(1, 3),
                Paragraph("Pourquoi ce diagnostic", h3),
            ]
            bloc += puces([f"{s['texte']} (poids {s['certitude']})" for s in h["symptomes"]],
                          "Aucun symptôme correspondant.")
            if h["conditions"]:
                bloc.append(Paragraph("<b>Conditions favorables confirmées :</b>", normal))
                bloc += puces([f"{c['texte']} (poids {c['certitude']})" for c in h["conditions"]])
            bloc.append(Paragraph(_t(f"Plan d'action ({mode})"), h3))
            bloc += puces(h["traitement"], message_traitement_vide(h["type"], mode))
            bloc.append(Paragraph("Gestes culturaux et prévention", h3))
            bloc += puces(h["prevention"], "Aucun geste cultural cité dans la base.")
            if h["a_verifier"]:
                bloc.append(Paragraph("À vérifier pour confirmer", h3))
                bloc += puces(h["a_verifier"])
            histoire.append(KeepTogether(bloc))   # une hypothèse = un bloc (pas coupé entre 2 pages)

    # --- alertes
    for m in rep.get("avertissements", []):
        histoire.append(Paragraph(_t("Attention : " + m), alerte))
    for m in rep.get("confusions", []):
        histoire.append(Paragraph(_t("Confusion possible : " + m), info))
    if rep.get("incertain"):
        histoire.append(Paragraph(_t(MESSAGE_INCERTAIN), erreur))

    # --- précautions
    precautions = list(PRECAUTIONS) + ([PRECAUTION_BIO] if mode == "biologique" else [])
    bloc_pre = [Paragraph("Précautions d'emploi des produits", h2)] + puces(precautions)
    histoire.append(KeepTogether(bloc_pre))
    histoire.append(Spacer(1, 10))
    histoire.append(Paragraph(_t(AVERTISSEMENT_FINAL), petit))

    sortie = BytesIO()
    doc = SimpleDocTemplate(sortie, pagesize=A4, leftMargin=2 * cm, rightMargin=2 * cm,
                            topMargin=1.8 * cm, bottomMargin=2 * cm,
                            title="Fiche de diagnostic - tomate", author="Système expert tomate")
    doc.build(histoire, onFirstPage=_pied_de_page, onLaterPages=_pied_de_page)
    return sortie.getvalue()
