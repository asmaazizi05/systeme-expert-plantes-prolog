:- encoding(utf8).
% GÉNÉRÉ par data/generer_faits.py à partir de base_connaissances_tomate_v4.xlsx - ne pas modifier à la main.
:- discontiguous maladie/2, cause/2, organe_maladie/2, symptome_maladie/3, symptome_organe/2, condition_favorable/3, traitement/3.

culture(tomate, maraichage).

maladie(mildiou, champignon).
maladie(alternariose, champignon).
maladie(oidium, champignon).
maladie(botrytis, champignon).
maladie(fusariose, champignon).
maladie(verticilliose, champignon).
maladie(septoriose, champignon).
maladie(chancre_bacterien, bacterie).
maladie(tache_bacterienne, bacterie).
maladie(tylcv, virus).
maladie(mosaique_tomate, virus).
maladie(tuta_absoluta, ravageur).
maladie(aleurodes, ravageur).
maladie(pucerons, ravageur).
maladie(acariens, ravageur).
maladie(nematodes_galles, ravageur).
maladie(necrose_apicale, trouble_physiologique).
maladie(stress_hydrique, trouble_physiologique).
maladie(eclatement_fruits, trouble_physiologique).
maladie(coup_de_soleil, trouble_physiologique).

cause(mildiou, 'Phytophthora infestans').
cause(alternariose, 'Alternaria solani').
cause(oidium, 'Leveillula taurica').
cause(botrytis, 'Botrytis cinerea').
cause(fusariose, 'Fusarium oxysporum f. sp. lycopersici').
cause(verticilliose, 'Verticillium dahliae').
cause(septoriose, 'Septoria lycopersici').
cause(chancre_bacterien, 'Clavibacter michiganensis').
cause(tache_bacterienne, 'Xanthomonas spp.').
cause(tylcv, 'Tomato yellow leaf curl virus').
cause(mosaique_tomate, 'Tomato mosaic virus (ToMV)').
cause(tuta_absoluta, 'Tuta absoluta').
cause(aleurodes, 'Bemisia tabaci').
cause(pucerons, 'Myzus persicae').
cause(acariens, 'Tetranychus urticae').
cause(nematodes_galles, 'Meloidogyne spp.').
cause(necrose_apicale, 'carence en calcium').
cause(stress_hydrique, 'manque ou exces d\'eau').
cause(eclatement_fruits, 'irrigation irreguliere').
cause(coup_de_soleil, 'exposition excessive').

organe_maladie(mildiou, feuilles).
organe_maladie(mildiou, tiges).
organe_maladie(mildiou, fruits).
organe_maladie(alternariose, feuilles).
organe_maladie(alternariose, tiges).
organe_maladie(alternariose, fruits).
organe_maladie(oidium, feuilles).
organe_maladie(botrytis, feuilles).
organe_maladie(botrytis, tiges).
organe_maladie(botrytis, fruits).
organe_maladie(fusariose, tiges).
organe_maladie(fusariose, racines).
organe_maladie(verticilliose, feuilles).
organe_maladie(verticilliose, racines).
organe_maladie(septoriose, feuilles).
organe_maladie(chancre_bacterien, feuilles).
organe_maladie(chancre_bacterien, tiges).
organe_maladie(chancre_bacterien, fruits).
organe_maladie(tache_bacterienne, feuilles).
organe_maladie(tache_bacterienne, fruits).
organe_maladie(tylcv, feuilles).
organe_maladie(mosaique_tomate, feuilles).
organe_maladie(mosaique_tomate, fruits).
organe_maladie(tuta_absoluta, feuilles).
organe_maladie(tuta_absoluta, fruits).
organe_maladie(aleurodes, feuilles).
organe_maladie(pucerons, feuilles).
organe_maladie(pucerons, tiges).
organe_maladie(acariens, feuilles).
organe_maladie(nematodes_galles, racines).
organe_maladie(necrose_apicale, fruits).
organe_maladie(stress_hydrique, feuilles).
organe_maladie(stress_hydrique, tiges).
organe_maladie(eclatement_fruits, fruits).
organe_maladie(coup_de_soleil, fruits).

symptome_maladie(mildiou, taches_huileuses, 0.7).
symptome_maladie(mildiou, duvet_blanc_face_inferieure, 0.9).
symptome_maladie(mildiou, taches_brunes_dures, 0.6).
symptome_maladie(mildiou, lesions_sombres_tiges_petioles, 0.6).
symptome_maladie(alternariose, taches_concentriques, 0.8).
symptome_maladie(alternariose, halo_jaune, 0.5).
symptome_maladie(alternariose, taches_sur_feuilles_agees_d_abord, 0.4).
symptome_maladie(alternariose, taches_noires_enfoncees_pres_pedoncule, 0.7).
symptome_maladie(alternariose, lesions_enfoncees_tiges, 0.5).
symptome_maladie(oidium, taches_jaunes_face_superieure, 0.7).
symptome_maladie(oidium, sporulation_blanche_face_inferieure, 0.6).
symptome_maladie(oidium, poudre_blanche_face_superieure, 0.5).
symptome_maladie(oidium, centre_taches_necrotique, 0.5).
symptome_maladie(botrytis, moisissure_grise, 0.9).
symptome_maladie(botrytis, chancre_avec_moisissure_grise, 0.7).
symptome_maladie(botrytis, taches_fantomes_halo_clair, 0.6).
symptome_maladie(botrytis, moisissure_grise_sur_feuilles, 0.7).
symptome_maladie(botrytis, fleurs_mortes_couvertes_moisissure, 0.6).
symptome_maladie(fusariose, jaunissement_d_un_seul_cote, 0.8).
symptome_maladie(fusariose, brunissement_vaisseaux_coupe, 0.7).
symptome_maladie(fusariose, fletrissement, 0.5).
symptome_maladie(verticilliose, jaunissement_en_v, 0.7).
symptome_maladie(verticilliose, jaunissement_entre_nervures, 0.5).
symptome_maladie(verticilliose, fletrissement_chaud_reprise_nuit, 0.5).
symptome_maladie(verticilliose, brunissement_pale_vaisseaux_pres_base, 0.6).
symptome_maladie(verticilliose, feuilles_agees_atteintes_d_abord, 0.4).
symptome_maladie(septoriose, petites_taches_rondes_centre_gris, 0.8).
symptome_maladie(septoriose, points_noirs_dans_taches, 0.7).
symptome_maladie(septoriose, nombreuses_taches_par_feuille, 0.5).
symptome_maladie(septoriose, debut_sur_feuilles_basses_apres_nouaison, 0.4).
symptome_maladie(septoriose, jaunissement_puis_dessechement_feuilles, 0.4).
symptome_maladie(chancre_bacterien, bordure_feuille_brulee, 0.7).
symptome_maladie(chancre_bacterien, taches_oeil_d_oiseau, 0.9).
symptome_maladie(chancre_bacterien, chancre_tige, 0.6).
symptome_maladie(chancre_bacterien, fletrissement_unilateral_feuilles_basses, 0.5).
symptome_maladie(chancre_bacterien, brunissement_vaisseaux_aux_noeuds, 0.5).
symptome_maladie(tache_bacterienne, petites_taches_noires_halo_jaune, 0.7).
symptome_maladie(tache_bacterienne, taches_aqueuses_devenant_noires, 0.6).
symptome_maladie(tache_bacterienne, petites_taches_noires_surelevees_vertes, 0.7).
symptome_maladie(tache_bacterienne, taches_liegeuses_croutes, 0.6).
symptome_maladie(tylcv, enroulement_vers_le_haut, 0.8).
symptome_maladie(tylcv, jaunissement_marge_feuille, 0.7).
symptome_maladie(tylcv, feuilles_reduites, 0.5).
symptome_maladie(tylcv, nanisme_plante, 0.6).
symptome_maladie(tylcv, chute_de_fleurs, 0.4).
symptome_maladie(mosaique_tomate, mosaique_vert_clair_vert_fonce, 0.8).
symptome_maladie(mosaique_tomate, feuilles_filiformes_en_fougere, 0.6).
symptome_maladie(mosaique_tomate, jeunes_feuilles_enroulees, 0.4).
symptome_maladie(mosaique_tomate, nanisme_plante, 0.5).
symptome_maladie(tuta_absoluta, galeries_mines, 0.9).
symptome_maladie(tuta_absoluta, trous_avec_galeries, 0.8).
symptome_maladie(tuta_absoluta, necroses_sur_calice, 0.6).
symptome_maladie(tuta_absoluta, chenilles_et_dejections_dans_galeries, 0.7).
symptome_maladie(aleurodes, petits_insectes_blancs_face_inferieure, 0.9).
symptome_maladie(aleurodes, miellat_fumagine, 0.6).
symptome_maladie(aleurodes, jaunissement_enroulement_feuilles, 0.5).
symptome_maladie(aleurodes, maturation_irreguliere, 0.4).
symptome_maladie(pucerons, colonies_face_inferieure_jeunes_feuilles, 0.8).
symptome_maladie(pucerons, jaunissement_face_superieure_feuilles_jeunes, 0.5).
symptome_maladie(pucerons, feuilles_enroulees_deformees, 0.6).
symptome_maladie(pucerons, miellat_fumagine, 0.6).
symptome_maladie(acariens, fines_toiles, 0.9).
symptome_maladie(acariens, ponctuations_blanches_jaunes_face_superieure, 0.7).
symptome_maladie(acariens, bronzage_dessechement_feuilles, 0.6).
symptome_maladie(acariens, colonies_face_inferieure, 0.6).
symptome_maladie(nematodes_galles, galles_renflements, 0.9).
symptome_maladie(nematodes_galles, plante_rabougrie_jaunie, 0.5).
symptome_maladie(nematodes_galles, fletrissement_chaleur_de_l_apres_midi, 0.5).
symptome_maladie(necrose_apicale, tache_aqueuse_beige_extremite_fleur, 0.8).
symptome_maladie(necrose_apicale, tache_noire_enfoncee_coriace_base_fruit, 0.9).
symptome_maladie(stress_hydrique, fletrissement_en_journee, 0.5).
symptome_maladie(stress_hydrique, feuilles_enroulees, 0.4).
symptome_maladie(stress_hydrique, bords_brules_feuillage, 0.4).
symptome_maladie(eclatement_fruits, fissures_concentriques_autour_pedoncule, 0.8).
symptome_maladie(eclatement_fruits, fissures_radiales_depuis_pedoncule, 0.8).
symptome_maladie(coup_de_soleil, zone_jaune_brune_coriace_cote_expose, 0.9).
symptome_maladie(coup_de_soleil, zone_blanchatre_cartonneuse_avec_le_temps, 0.6).
symptome_maladie(coup_de_soleil, lesion_sur_epaules_pres_pedoncule, 0.5).

symptome_organe(bords_brules_feuillage, feuilles).
symptome_organe(bordure_feuille_brulee, feuilles).
symptome_organe(bronzage_dessechement_feuilles, feuilles).
symptome_organe(brunissement_pale_vaisseaux_pres_base, tiges).
symptome_organe(brunissement_vaisseaux_aux_noeuds, tiges).
symptome_organe(brunissement_vaisseaux_coupe, tiges).
symptome_organe(centre_taches_necrotique, feuilles).
symptome_organe(chancre_avec_moisissure_grise, tiges).
symptome_organe(chancre_tige, tiges).
symptome_organe(chenilles_et_dejections_dans_galeries, feuilles).
symptome_organe(chute_de_fleurs, fleurs).
symptome_organe(colonies_face_inferieure, feuilles).
symptome_organe(colonies_face_inferieure_jeunes_feuilles, feuilles).
symptome_organe(debut_sur_feuilles_basses_apres_nouaison, feuilles).
symptome_organe(duvet_blanc_face_inferieure, feuilles).
symptome_organe(enroulement_vers_le_haut, feuilles).
symptome_organe(feuilles_agees_atteintes_d_abord, feuilles).
symptome_organe(feuilles_enroulees, feuilles).
symptome_organe(feuilles_enroulees_deformees, feuilles).
symptome_organe(feuilles_filiformes_en_fougere, feuilles).
symptome_organe(feuilles_reduites, feuilles).
symptome_organe(fines_toiles, feuilles).
symptome_organe(fissures_concentriques_autour_pedoncule, fruits).
symptome_organe(fissures_radiales_depuis_pedoncule, fruits).
symptome_organe(fletrissement, feuilles).
symptome_organe(fletrissement_chaleur_de_l_apres_midi, feuilles).
symptome_organe(fletrissement_chaud_reprise_nuit, feuilles).
symptome_organe(fletrissement_en_journee, feuilles).
symptome_organe(fletrissement_unilateral_feuilles_basses, feuilles).
symptome_organe(fleurs_mortes_couvertes_moisissure, fleurs).
symptome_organe(galeries_mines, feuilles).
symptome_organe(galles_renflements, racines).
symptome_organe(halo_jaune, feuilles).
symptome_organe(jaunissement_d_un_seul_cote, feuilles).
symptome_organe(jaunissement_en_v, feuilles).
symptome_organe(jaunissement_enroulement_feuilles, feuilles).
symptome_organe(jaunissement_entre_nervures, feuilles).
symptome_organe(jaunissement_face_superieure_feuilles_jeunes, feuilles).
symptome_organe(jaunissement_marge_feuille, feuilles).
symptome_organe(jaunissement_puis_dessechement_feuilles, feuilles).
symptome_organe(jeunes_feuilles_enroulees, feuilles).
symptome_organe(lesion_sur_epaules_pres_pedoncule, fruits).
symptome_organe(lesions_enfoncees_tiges, tiges).
symptome_organe(lesions_sombres_tiges_petioles, tiges).
symptome_organe(maturation_irreguliere, fruits).
symptome_organe(miellat_fumagine, feuilles).
symptome_organe(moisissure_grise, fruits).
symptome_organe(moisissure_grise_sur_feuilles, feuilles).
symptome_organe(mosaique_vert_clair_vert_fonce, feuilles).
symptome_organe(nanisme_plante, feuilles).
symptome_organe(necroses_sur_calice, fruits).
symptome_organe(nombreuses_taches_par_feuille, feuilles).
symptome_organe(petites_taches_noires_halo_jaune, feuilles).
symptome_organe(petites_taches_noires_surelevees_vertes, fruits).
symptome_organe(petites_taches_rondes_centre_gris, feuilles).
symptome_organe(petits_insectes_blancs_face_inferieure, feuilles).
symptome_organe(plante_rabougrie_jaunie, feuilles).
symptome_organe(points_noirs_dans_taches, feuilles).
symptome_organe(ponctuations_blanches_jaunes_face_superieure, feuilles).
symptome_organe(poudre_blanche_face_superieure, feuilles).
symptome_organe(sporulation_blanche_face_inferieure, feuilles).
symptome_organe(tache_aqueuse_beige_extremite_fleur, fruits).
symptome_organe(tache_noire_enfoncee_coriace_base_fruit, fruits).
symptome_organe(taches_aqueuses_devenant_noires, feuilles).
symptome_organe(taches_brunes_dures, fruits).
symptome_organe(taches_concentriques, feuilles).
symptome_organe(taches_fantomes_halo_clair, fruits).
symptome_organe(taches_huileuses, feuilles).
symptome_organe(taches_jaunes_face_superieure, feuilles).
symptome_organe(taches_liegeuses_croutes, fruits).
symptome_organe(taches_noires_enfoncees_pres_pedoncule, fruits).
symptome_organe(taches_oeil_d_oiseau, fruits).
symptome_organe(taches_sur_feuilles_agees_d_abord, feuilles).
symptome_organe(trous_avec_galeries, fruits).
symptome_organe(zone_blanchatre_cartonneuse_avec_le_temps, fruits).
symptome_organe(zone_jaune_brune_coriace_cote_expose, fruits).

condition_favorable(mildiou, humidite_elevee_sup_90, 0.5).
condition_favorable(mildiou, temperature_moderee_15_26, 0.4).
condition_favorable(mildiou, irrigation_par_aspersion, 0.4).
condition_favorable(mildiou, pluie_recente, 0.4).
condition_favorable(alternariose, humidite_elevee, 0.4).
condition_favorable(alternariose, climat_frais_humide_apres_pluie, 0.4).
condition_favorable(alternariose, temperature_chaude_28_30, 0.3).
condition_favorable(alternariose, residus_culture_infectes, 0.3).
condition_favorable(oidium, humidite_elevee, 0.4).
condition_favorable(oidium, temperature_moderee, 0.3).
condition_favorable(oidium, stress_hydrique, 0.3).
condition_favorable(oidium, culture_sous_abri, 0.3).
condition_favorable(botrytis, humidite_elevee, 0.5).
condition_favorable(botrytis, eau_libre_sur_plante_4_6h, 0.4).
condition_favorable(botrytis, feuillage_dense, 0.4).
condition_favorable(botrytis, temperature_fraiche, 0.3).
condition_favorable(fusariose, sol_chaud, 0.4).
condition_favorable(fusariose, sol_peu_humide, 0.3).
condition_favorable(fusariose, sol_deja_infecte, 0.4).
condition_favorable(fusariose, nematodes_galles_presents, 0.3).
condition_favorable(verticilliose, sol_frais, 0.4).
condition_favorable(verticilliose, sol_deja_infecte, 0.4).
condition_favorable(verticilliose, stress_hydrique_temps_chaud, 0.3).
condition_favorable(verticilliose, periode_de_grossissement_des_fruits, 0.3).
condition_favorable(septoriose, humidite_elevee_prolongee, 0.4).
condition_favorable(septoriose, feuillage_mouille, 0.4).
condition_favorable(septoriose, temperature_16_27, 0.3).
condition_favorable(septoriose, residus_ou_solanacees_hotes, 0.3).
condition_favorable(chancre_bacterien, semences_ou_plants_infectes, 0.5).
condition_favorable(chancre_bacterien, outils_contamines, 0.4).
condition_favorable(chancre_bacterien, eclaboussures_pluie_irrigation, 0.3).
condition_favorable(tache_bacterienne, temps_chaud_humide, 0.4).
condition_favorable(tache_bacterienne, pluie_ou_irrigation_par_aspersion, 0.4).
condition_favorable(tache_bacterienne, plants_infectes_sans_symptome, 0.4).
condition_favorable(tylcv, presence_aleurodes, 0.6).
condition_favorable(tylcv, plants_infectes_a_la_plantation, 0.3).
condition_favorable(tylcv, culture_voisine_de_tomate_ou_poivron, 0.3).
condition_favorable(mosaique_tomate, manipulation_plants_outils_mains, 0.5).
condition_favorable(mosaique_tomate, semences_contaminees, 0.4).
condition_favorable(mosaique_tomate, tabac_a_proximite, 0.3).
condition_favorable(tuta_absoluta, tomate_sur_tomate_ou_solanacees, 0.3).
condition_favorable(tuta_absoluta, solanacees_adventices_voisines, 0.2).
condition_favorable(aleurodes, ennemis_naturels_perturbes, 0.3).
condition_favorable(aleurodes, culture_sous_serre, 0.3).
condition_favorable(aleurodes, presence_fourmis, 0.2).
condition_favorable(pucerons, debut_de_saison, 0.3).
condition_favorable(pucerons, plantes_en_stress_hydrique, 0.2).
condition_favorable(pucerons, insecticides_perturbant_ennemis_naturels, 0.2).
condition_favorable(acariens, temps_chaud_et_sec, 0.5).
condition_favorable(acariens, conditions_poussiereuses, 0.4).
condition_favorable(acariens, plantes_en_stress_hydrique, 0.4).
condition_favorable(acariens, insecticides_persistants_utilises, 0.3).
condition_favorable(nematodes_galles, sol_sableux_leger, 0.4).
condition_favorable(nematodes_galles, adventices_hotes_morelles, 0.3).
condition_favorable(nematodes_galles, sol_chaud, 0.3).
condition_favorable(necrose_apicale, irrigation_irreguliere, 0.5).
condition_favorable(necrose_apicale, sol_sableux, 0.3).
condition_favorable(necrose_apicale, fertilisation_azotee_excessive, 0.3).
condition_favorable(necrose_apicale, racines_endommagees, 0.2).
condition_favorable(stress_hydrique, irrigation_insuffisante, 0.5).
condition_favorable(stress_hydrique, irrigation_excessive, 0.4).
condition_favorable(stress_hydrique, temperatures_elevees, 0.3).
condition_favorable(eclatement_fruits, irrigation_irreguliere, 0.5).
condition_favorable(eclatement_fruits, pluie_apres_periode_seche, 0.4).
condition_favorable(eclatement_fruits, croissance_rapide_temps_chaud_sol_humide, 0.4).
condition_favorable(coup_de_soleil, fort_ensoleillement, 0.5).
condition_favorable(coup_de_soleil, defoliation_maladies_ou_taille, 0.5).

traitement(mildiou, cultural, variete_resistante).
traitement(mildiou, cultural, elimination_plants_spontanes_morelle).
traitement(mildiou, cultural, verifier_plants_sains).
traitement(mildiou, cultural, eviter_irrigation_aspersion).
traitement(mildiou, cultural, enfouir_residus_apres_recolte).
traitement(mildiou, biologique, bouillie_bordelaise).
traitement(mildiou, conventionnel, mancozebe).
traitement(mildiou, conventionnel, chlorothalonil).
traitement(mildiou, conventionnel, azoxystrobine).
traitement(alternariose, cultural, rotation_cultures).
traitement(alternariose, cultural, eviter_irrigation_aspersion).
traitement(alternariose, cultural, detruire_morelles_et_plants_spontanes).
traitement(alternariose, biologique, cuivre).
traitement(alternariose, conventionnel, '(produit homologué à relever sur ONSSA)').
traitement(oidium, cultural, variete_resistante).
traitement(oidium, biologique, soufre_mouillable).
traitement(oidium, biologique, bicarbonate_de_potassium).
traitement(oidium, biologique, 'Bacillus_subtilis').
traitement(oidium, conventionnel, azoxystrobine).
traitement(botrytis, cultural, humidite_inferieure_90).
traitement(botrytis, cultural, aeration_serre).
traitement(botrytis, cultural, detruire_residus_et_desinfecter_serre).
traitement(botrytis, cultural, inspecter_plants_avant_plantation).
traitement(botrytis, conventionnel, chlorothalonil).
traitement(botrytis, conventionnel, boscalid).
traitement(fusariose, cultural, variete_resistante).
traitement(fusariose, cultural, rotation_cultures).
traitement(fusariose, cultural, eviter_nematodes).
traitement(fusariose, cultural, semences_et_plants_sains).
traitement(fusariose, conventionnel, '(aucun fongicide curatif cité)').
traitement(verticilliose, cultural, variete_resistante_V).
traitement(verticilliose, cultural, rotation_cereales_mais).
traitement(verticilliose, cultural, nettoyage_materiel).
traitement(verticilliose, cultural, solarisation_sol).
traitement(verticilliose, conventionnel, '(aucun fongicide curatif cité)').
traitement(septoriose, cultural, eliminer_feuilles_basses_atteintes).
traitement(septoriose, cultural, aeration_tuteurage).
traitement(septoriose, cultural, paillage).
traitement(septoriose, cultural, eviter_irrigation_aspersion).
traitement(septoriose, cultural, rotation_1_2_ans).
traitement(septoriose, cultural, eliminer_morelles_adventices).
traitement(septoriose, biologique, cuivre).
traitement(septoriose, conventionnel, chlorothalonil).
traitement(septoriose, conventionnel, mancozebe).
traitement(chancre_bacterien, cultural, semences_et_plants_certifies_sains).
traitement(chancre_bacterien, cultural, desinfection_outils_eau_de_javel).
traitement(chancre_bacterien, cultural, incorporer_residus_fin_saison).
traitement(chancre_bacterien, cultural, eliminer_morelles).
traitement(chancre_bacterien, conventionnel, '(aucun traitement curatif)').
traitement(tache_bacterienne, cultural, semences_et_plants_sains).
traitement(tache_bacterienne, cultural, eviter_irrigation_aspersion).
traitement(tache_bacterienne, cultural, traitement_eau_chaude_semences).
traitement(tache_bacterienne, biologique, cuivre_preventif).
traitement(tache_bacterienne, conventionnel, '(produit homologué à relever sur ONSSA)').
traitement(tylcv, cultural, filets_anti_insectes).
traitement(tylcv, cultural, variete_resistante).
traitement(tylcv, cultural, plants_sans_virus).
traitement(tylcv, cultural, paillage_reflechissant).
traitement(tylcv, cultural, eliminer_plants_atteints).
traitement(tylcv, cultural, detruire_vite_cultures_recoltees).
traitement(tylcv, cultural, gerer_adventices).
traitement(tylcv, biologique, lutte_contre_aleurodes_huiles_savons).
traitement(tylcv, conventionnel, insecticide_contre_aleurodes).
traitement(mosaique_tomate, cultural, variete_resistante).
traitement(mosaique_tomate, cultural, semences_saines_certifiees).
traitement(mosaique_tomate, cultural, traitement_thermique_ou_phosphate_semences).
traitement(mosaique_tomate, cultural, desinfection_mains_et_outils).
traitement(mosaique_tomate, cultural, eliminer_plants_atteints).
traitement(mosaique_tomate, cultural, eviter_tabac_pres_des_plants).
traitement(mosaique_tomate, conventionnel, '(aucun traitement curatif)').
traitement(tuta_absoluta, cultural, detruire_parties_attaquees).
traitement(tuta_absoluta, cultural, travail_du_sol_et_solarisation).
traitement(tuta_absoluta, biologique, pieges_a_pheromones).
traitement(tuta_absoluta, biologique, lachers_auxiliaires_predateurs).
traitement(tuta_absoluta, biologique, parasitoide_des_oeufs).
traitement(tuta_absoluta, biologique, huile_de_neem).
traitement(tuta_absoluta, biologique, 'Bacillus_thuringiensis').
traitement(tuta_absoluta, conventionnel, '(produit homologué à relever sur ONSSA)').
traitement(aleurodes, cultural, pieges_jaunes_collants).
traitement(aleurodes, cultural, retirer_plants_infestes).
traitement(aleurodes, cultural, filets_anti_insectes).
traitement(aleurodes, cultural, paillage_reflechissant).
traitement(aleurodes, biologique, savon_insecticide_ou_huile).
traitement(aleurodes, biologique, auxiliaires_Encarsia).
traitement(aleurodes, biologique, preserver_ennemis_naturels).
traitement(aleurodes, conventionnel, '(produit homologué à relever sur ONSSA)').
traitement(pucerons, cultural, preserver_ennemis_naturels).
traitement(pucerons, biologique, savon_insecticide_ou_huile_horticole).
traitement(pucerons, biologique, auxiliaires_coccinelles_chrysopes_syrphes).
traitement(pucerons, conventionnel, '(produit homologué à relever sur ONSSA)').
traitement(acariens, cultural, irrigation_suffisante).
traitement(acariens, cultural, brumisation_face_inferieure).
traitement(acariens, cultural, plants_sans_acariens).
traitement(acariens, cultural, eviter_plantation_periode_chaude_seche).
traitement(acariens, biologique, savon_insecticide_ou_huile).
traitement(acariens, biologique, acariens_predateurs).
traitement(acariens, conventionnel, '(miticide homologué à relever sur ONSSA)').
traitement(nematodes_galles, cultural, variete_resistante_Mi).
traitement(nematodes_galles, cultural, rotation_cultures_non_hotes).
traitement(nematodes_galles, cultural, desherbage).
traitement(nematodes_galles, cultural, verifier_galles_sur_racines).
traitement(nematodes_galles, conventionnel, '(produit homologué à relever sur ONSSA)').
traitement(necrose_apicale, cultural, irrigation_reguliere).
traitement(necrose_apicale, cultural, apport_gypse_si_sol_pauvre_en_calcium).
traitement(necrose_apicale, cultural, eviter_exces_azote).
traitement(necrose_apicale, cultural, pas_de_calcium_foliaire).
traitement(stress_hydrique, cultural, irrigation_adaptee_selon_humidite_sol).
traitement(stress_hydrique, cultural, paillage).
traitement(eclatement_fruits, cultural, irrigation_reguliere).
traitement(eclatement_fruits, cultural, recolter_fruits_murs_apres_pluie).
traitement(coup_de_soleil, cultural, maintenir_feuillage_protecteur).
traitement(coup_de_soleil, cultural, ombrage_en_pleine_chaleur).
traitement(coup_de_soleil, cultural, controler_maladies_defoliantes).
