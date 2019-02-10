---
layout: dbs
categories: labs
title: 3. týždeň - DM - riešenia
published: true
---
# Cvičenia v treťom týždni

## Dátové modelovanie

### Autopožičovňa

Zadanie

Uvažujte spoločnosť na požičiavanie automobilov. Táto spoločnosť poskytuje niekoľko automobilov
rôznych značiek a modelov. Zákazník si môže požičať automobil na dobu určitú. Spoločnosť si eviduje
výnosy z výpožičiek. Automobil vyžaduje poistenie a údržbu. Údržbu automobilov zabezpečujú
servisné strediská. Tieto strediská poskytujú rôzne služby, pričom dve rozdielne strediská môžu
poskytovať rovnakú službu za rozdielnu cenu. Spoločnosť si eviduje náklady na údržbu automobilov.

* Vytvorte najskôr logický model, identifikujte entity, vzťahy medzi entitami a nakreslite ER diagram.
* Pre tento model vytvorte fyzický model, pre ktorý identifikujte potrebné entity, vzťahy medzi nimi, kardinalitu, definujte atribúty a ich typy, primárne a cudzie kľúče.

Riešenie

![Fyzický model autopožičovňa](/labs/files/lab03/autopozicovna_riesenie.png "Autopožičovňa riešenie")

### Letisko

Zadanie

V diagrame je zobrazený zjednodušený logický entitno-relačný model letiska.

* Vytvorte z tohto modelu fyzický relačný model. Identifikujte potrebné entity, ich vzťahy, a správne do neho umiestnite primárne a cudzie kľúče. Ďalšie atribúty môžete pri riešení zanedbať.
* Zavedte do modelu entitu letenky, na základe ktorej pasažier cestuje z počiatočného letiska do svojho cieľa. Uvažujte pritom aj možnosť, že aj po vydaní boarding passu môže byť let zrušený, a pasažier bude musieť cestovať odlišným letom.

![Logický model letisko](/labs/files/lab03/letisko_zadanie.png "Logický model letisko")

Riešenie

![Fyzický model letisko](/labs/files/lab03/letisko_riesenieA.png "Letisko riešenie")
![Model letisko s letenkami](/labs/files/lab03/letisko_riesenieB.png "Letisko riešenie")
