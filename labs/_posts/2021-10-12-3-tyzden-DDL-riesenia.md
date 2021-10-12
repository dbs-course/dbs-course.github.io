---
layout: dbs
categories: labs
title: 3. týždeň - DDL - riešenia
published: true
---
# Cvičenia v treťom týždni

### Relačná algebra - Autopožičovňa

Uvažujte nasledovný relačný dátový model:

![ER-diagram autopozicovna riesenie](/labs/files/lab03/autopozicovna_riesenie.png "E-R diagram autopozicovna riesenie")

1. Ceny všetkých ukončených výpožičiek zákazníka s menom „Jozef Mrkvička“
  &Pi;<sub>cena</sub>( &sigma;<sub>name=‘Jozef Mrkvicka‘&and;do != NULL</sub> (Zakaznik &#x22C8; Vypozicka))
2. Továrenské značky všetkých momentálne vypožičaných automobilov
  &Pi;<sub>oznacenie</sub>(&sigma;<sub>do = NULL</sub> (Vypozicka &#x22C8; (Model &#x22C8; Automobil)))
3. Továrenské značky automobilov, ktoré sa včera vrátili z údržby
  &Pi;<sub>oznacenie</sub>(&sigma;<sub>do = "vcera"</sub> (Udrzba &#x22C8; (Model &#x22C8; Automobil)))
4. Dátum výroby všetkých áut, ktoré ešte neboli v servise
  &Pi;<sub>datum-vyroby</sub>(&Pi;<sub>id</sub>(Automobil) - (&rho;<sub>id</sub>(&Pi;<sub>automobil-id</sub>(Udrzba))) &#x22C8;  Automobil)

### Relačná algebra - Morské akvárium

Uvažujte nasledovný dátový model:
 
 ![Fyzický model akvárium](/labs/files/lab03/morsky_svet_riesenieA.png "Fyzický model akvárium")
 

Napíšte výrazy relačnej algebry poskytujúce odpovede na nasledujúce dopyty (predpokladajte, že
máte vyplnené tabuľky)
1. Latinské názvy druhov živočíchov, ktoré mali dnes veterinárnu prehliadku:
  &Pi;<sub>latinsky-nazov</sub>(&sigma;<sub>datum = dnes </sub>(Prehliadka  &#x22C8; (Druh &#x22C8; Zivocich)))
2. Názvy nádrží, ktorých správcovia sú veterinári:   &Pi;<sub>nazov</sub>(&sigma;<sub>veterinar = true </sub>(Zamestnanec  &#x22C8; (Nadrz &#x22C8; Spravca)))
3. Mená správcov, ktorí majú v nádrži kosatky: 
&Pi;<sub>meno-spravcu</sub>(&rho;<sub>meno/meno-spravcu</sub>(Zamestnanec) &#x22C8; (Spravca &#x22C8; (&sigma;<sub>nazov = 'kosatka'</sub>(Nadrz &#x22C8; (Umiestnenie &#x22C8; (Zivocich &#x22C8; Druh)))))
4. Názvy symptómov všetkých živočíchov v karanténe (Názov nádrže "Karanténa"):
&Pi;<sub>nazov</sub>(&sigma;<sub>nazov-nadrze = 'karantena'</sub>((&rho;<sub>nazov/nazov-nadrze</sub>(Nadrz)) &#x22C8; (Umiestnenie &#x22C8; (Zivocich &#x22C8; (Prehliadka &#x22C8; (Diagnoza &#x22C8; Symptom))))))

 
 
	

