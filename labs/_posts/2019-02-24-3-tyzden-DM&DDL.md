---
layout: dbs
categories: labs
title: 3. týždeň - DDL
published: false
---
# Cvičenia v treťom týždni

## Dátové modelovanie

### Autopožičovňa

Uvažujte spoločnosť na požičiavanie automobilov. Táto spoločnosť poskytuje niekoľko automobilov
rôznych značiek a modelov. Zákazník si môže požičať automobil na dobu určitú. Spoločnosť si eviduje
výnosy z výpožičiek. Automobil vyžaduje poistenie a údržbu. Údržbu automobilov zabezpečujú
servisné strediská. Tieto strediská poskytujú rôzne služby, pričom dve rozdielne strediská môžu
poskytovať rovnakú službu za rozdielnu cenu. Spoločnosť si eviduje náklady na údržbu automobilov.

* Vytvorte najskôr logický model, identifikujte entity, vzťahy medzi entitami a nakreslite ER diagram.
* Pre tento model vytvorte fyzický model, pre ktorý identifikujte potrebné entity, vzťahy medzi nimi, kardinalitu, definujte atribúty a ich typy, primárne a cudzie kľúče.

### Letisko

V diagrame je zobrazený zjednodušený logický entitno-relačný model letiska.

* Vytvorte z tohto modelu fyzický relačný model. Identifikujte potrebné entity, ich vzťahy, a správne do neho umiestnite primárne a cudzie kľúče. Ďalšie atribúty môžete pri riešení zanedbať.
* Zavedte do modelu entitu letenky, na základe ktorej pasažier cestuje z počiatočného letiska do svojho cieľa. Uvažujte pritom aj možnosť, že aj po vydaní boarding passu môže byť let zrušený, a pasažier bude musieť cestovať odlišným letom.

![Logický model letisko](/labs/files/lab03/letisko_zadanie.png "Logický model letisko")

## SQL DDL

Aj keď väčšinu úloh z tohto cvičenia je možné vyklikať (pgadmin, phpmyadmin a pod.), snažte sa úlohu vyriešiť napísaním vlastných skriptov
a s použitím online dokumentácie. Pýtate sa prečo? Predstavte si, že jednotlivé kroky sú migračné skripty, ktoré potrebujete
vykonať na všetkých počítačoch/serveroch, kde je databáza nasadená (teda produkčné prostredie, testovacie prostredie,
počítače všetkých vývojárov atď.) a nechcete to predsa zakaždým vyklikávať.

### Ľudia

#### 1. Skript (init.sql)

- Vytvorte databázu s názvom `dbs_cvicenie_3` a nastavte znakovú sadu na UTF-8.
- V tejto databáze vytvorte tabuľku s názvom `ludia` a stĺpcami `id integer`, `meno varchar(50)`, `priezvisko varchar(50)`
  * `id` nech je auto inkrementujúci primárny kľúč

#### 2. Skript (migration1.sql)

- Teraz do tejto tabuľky pridajte stĺpec `vek integer`, `pohlavie char(1)` a `pozicia varchar(50)` (hľadajte ALTER TABLE...)
- Zväčšite stĺpec `priezvisko` na `varchar(100)`
- Zmažte stĺpec `pozicia` (rozhodli sme sa, že to budeme modelovať inak)

#### 3. Skript (seeds.sql)

Tabuľku naplňte 10 riadkami dát (dáta si vymyslite), tak aby sa vo vzorke nachádzalo 5 mužov a 5 žien, a z toho

  * 2 osoby mladšie ako 10 rokov,
  * 2 osoby 10-20,
  * 2 osoby 20-30,
  * 2 osoby 30-40 a
  * 2 osoby staršie ako 40 rokov

#### 4. Skript (migration2.sql)

- Pridajte stĺpec `titul varchar(10)` a pre všetky osoby
    * staršie ako 20 rokov ho nastavte na Ing., pre všetky osoby
    * staršie ako 30 rokov na doc. a pre všetky osoby
    * staršie ako 40 rokov na prof.
- Zmažte všetky záznamy pre mužov, mladších ako 10 rokov
- Vytvorte tabuľku `pozicie` so stĺpcami `id integer`, `osoba_id integer`, `pozicia varchar(50)` a nastavte stĺpec `osoba_id` ako cudzí kľúč do tabuľky `ludia` na `stĺpec id`
- Vytvorte tabuľku `profesori`, ako kópiu (aj štruktúrou aj dátami) tabuľky `ludia`, tak aby obsahovala len riadky zodpovedajúce profesorom.

### Dostihová dráha
- Vytvorte tabuľky dostihových stávok obsahujúcej stĺpce
  * primárny kľúč, 
  * výšku stávky, 
  * identifikátor koňa (v reále by bol FK),
  * id preteku preteku (tiež kandidát na FK), 
  * dátum vytvorenia a 
  * meno stávkovateľa
- Vložte 4 náhodné stávky do tabuľky (dve stávky nech sú pod 20€ a dve nad 20€, aspoň jednu vytvoril stávkovateľ Ján Kováč)
- Napíšte SQL príkazy pre
  * Vyhľadanie všetkých stávok vytvorených Jánom Kováčom a zvýšenie ich výšky na dvojnásobok
  * Vymazanie stĺpca meno stávkovateľa a pridanie stĺpca cudzí kľúč stávkovateľa
  * Vymazanie tejto tabuľky

### Elektronická zubná karta
1. Vaša spoločnosť získala zákazku na vytvorenie nového systému elektronických zubných kariet. Vývojový tím navrhol prvotný dátový model tak, ako je znázornený 
v nasledujúcom diagrame. Preklopte tento fyzický model do databázy tak, ako by ste to urobili pre testovacie prostredie používané počas vývoja systému.

![Fyzický model zubna karta](/labs/files/lab03/zubna_karta_zadanie.png "Fyzický model zubná karta")

2. Po ďalších konzultáciach so zadávateľom váš tím pozmenil fyzický model vytváraného systému. Upravte databázu v testovacom prostredí tak, aby spĺňala požiadavky vytváraného systému:
  * Pridajte do tabuľky pacientov stĺpce `rodne_cislo varchar(10)`, `pohlavie	char(1)`
  * Zmeny stavu zuba patria do obmedzenej množiny reťazcov (napr. `ok`, `kaz` alebo `plombovaný`). Nahraďte príslušný stĺpec v tabuľke stav zuba cudzím kľúčom na novú tabuľku, ktorá bude obsahovať tieto typy v stĺpci `nazov varchar(50)`.
3. Naplnte databázu tak, aby obsahovala aspoň troch pacientov z ktorých každý mal vykonanú aspoň jednu prehliadku jedným z dvoch zubárov. 
4. Skopírujte všetkých zubárov do tabuľky pacientov
	

