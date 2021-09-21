---
layout: dbs
categories: labs
title: 2. týždeň - riešenia
date: 2019-02-22
published: false
---

## Cvičenia v druhom týždni

### Dátové modelovanie #1 - Kardinality

1. Oddelenie zamestnáva osoby. Osoba je zamestnaná najviac v jednom oddelení.
  * Osoba nemusí byť zamestnaná na oddelení. Oddelenie musí zamestnávať prinajmenšom jednu osobu.
  * ![Cardinality department member](/labs/files/lab02/osoba_oddelenie_kardinality.png "Kardinality pre oddelenie a osobu")

2. Manažér riadi najviac jedno oddelenie. Oddelenie je riadené najviac jedným manažérom.
  * Oddelenie nemusí mať manažéra. Manažér nemusí riadiť oddelenie.
  * ![Cardinality department manager](/labs/files/lab02/manazer_oddelenie_kardinality.png "Kardinality pre oddelenie a manažéra")

3. Autor môže napísať veľa článkov. Veľa článkov môže byť napísaných viacerými autormi. Autor článku môže byť neznámy.
  * Autor nemusí napísať článok (nemôžem pridať do systému autora, keď ešte nenapísal článok? – nemôžem pridať do systému zákazníka, keď ešte nič nekúpil?). Článok nemusí mať autora (neznámy autor).
  * ![Cardinality writer article](/labs/files/lab02/autor_clanok_kardinality.png "Kardinality pre autora a článok")

4. Tím je zložený z viacerých hráčov. Hráč hrá iba za jeden tím. Osoba, ktorá nehrá za tím nie je hráč.
  * „Tím“ musí mať prinajmenšom „jedného“ hráča. Hráč musí hrať práve v jednom tíme.
  * ![Cardinality team player](/labs/files/lab02/hrac_tim_kardinality.png "Kardinality pre hráča a tím")

5. Produkt patrí do viacerých kategórií. Kategória obsahuje veľa produktov. Produkt nemôže existovať bez kategórie.
  * Každý produkt musí mať kategóriu. Kategória nemusí obsahovať žiaden produkt (ako by sme inak vytvorili kategóriu bez produktov.)
  * ![Cardinality product category](/labs/files/lab02/produkt_kategoria_kardinality.png "Kardinality pre produkt a kategoriu")

6. Konkrétny produkt sa predáva v najviac jednej krajine. V krajine sa predáva veľa produktov.
  * Konkrétny produkt (unikátny kód produktu) sa predáva iba jednej alebo žiadnej krajine. Krajina nemusí predávať žiadne
  produkty.
  * ![Cardinality product country](/labs/files/lab02/produkt_krajina_kardinality.png "Kardinality pre produkt a krajinu")

### Dátové modelovanie #2 - Kardinality

V nasledovných diagramoch vysvetlite kardinalitu vzťahov medzi entitami. Určte, ktorý z týchto vzťahov
je typu 1:1 a vysvetlite, prečo je vždy potrebné zvážiť vhodnosť použitia takéhoto typu vzťahu. Vysvetlite, 
akým typom vzťahu by ho bolo vhodné v tomto prípade nahradiť, a prečo.

![ER-diagram kardinality](/labs/files/lab02/kardinality_zadanie.png "E-R diagram kardinality")

Riešenie:

1. Každý areál môže byť strážený ľubovoľným počtom strážnikov, ale nemusí byť strážený ani jedným.
Strážnik môže strážiť ľubovoľný počet areálov, ale strážiť musí aspoň jeden.
2. Policajt môže byť držiteľom práve jednej zbrane, ktorá môže byť držaná práve jedným policajtom.
3. Každý poistenec má práve jedného obvodného lekára, pričom každý lekár je obvodným lekárom aspoň jedného
alebo viac poistencov.

Druhý vzťah je príkladom vzťahu 1:1. Potrebu takýchto vzťahov je vždy potrebné zvážiť, nakoľko v ich prípade je možné entity zlúčiť
do jednej tabuľky - napríklad v tomto prípade uviesť evidenčné číslo zbrane ako atribút v tabuľke policajtov.
Tento vzťah by mohol byť problémový, pokiaľ by sme chceli viesť evidenciu držania zbraní v čase, pokiaľ by zbrane menili držiteľov,
alebo by policajti dostávali nové zbrane.

### Dátové modelovanie #3 - e-shop

Doplňte do E-R diagramu kardinalitu medzi entitami.

![ER-diagram e-shop](/labs/files/lab02/e-shop_zadanie.png "E-R diagram e-shop - zadanie")

Riešenie:

![ER-diagram e-shop](/labs/files/lab02/e-shop_riesenie.png "E-R diagram e-shop - riešenie")

### Dátové modelovanie #4 - Štúdium

Fakulta pozostáva z ústavov a každý ústav ponúka niekoľko študijných programov.
Každý študijný program ponúka niekoľko kurzov (predmetov) zameraných na určitú problematiku.
Študenti sa zapisujú na konkrétny študijný program, v ktorom musia absolvovať predpísané kurzy.
Každý kurz je vyučovaný učiteľom (učiteľmi), pričom učiteľ je zamestnancom konkrétneho ústavu.

* Doplňte vzťahy, kardinalitu a odôvodnite existenciu vzťahov
* Tento model je až príliš zjednodušený. Identifikujte jeho nedostatky.

![ER-diagram faculty](/labs/files/lab02/studium_zadanie.png "E-R diagram štúdium - zadanie")

Riešenie:

![ER-diagram faculty](/labs/files/lab02/studium_riesenie.png "E-R diagram štúdium - riešenie")

Nedostatky:

* Chýba zachytenie časového aspektu 
  * entita zamestnanie (od, do) medzi ústavom a učiteľom
  * učiteľ vyučuje kurz v konkrétnom akademickom roku
  * študent je zapísaný na študijný program v určitom roku

* Kurz môže byť v študijnom programe povinne/nepovinne (asociácia by mala byť entitou)

### Dátové modelovanie #5 - Provider
Doplňte chýbajúce vzťahy medzi entitami a opravte kardinalitu vo vytvorených vzťahoch (ak je potrebné):

![ER-diagram provider](/labs/files/lab02/poskytovatel_zadanie.png "E-R diagram provider - zadanie")

Riešenie:

![ER-diagram provider](/labs/files/lab02/poskytovatel_riesenie.png "E-R diagram provider - riešenie")

### Dátové modelovanie #6 - Farmaceutická firma

Doplňte logický model distribúcie vo farmaceutickej firme tak, aby zahŕňal:

* Evidenciu zásielok tovaru, pričom každú objednávku musí byť možné rozdeliť na viac zásielok pokiaľ si to odoberateľ želá
* Evidenciu jázd obchodného reprezentanta. Pre každú jazdu farmaceutickú spoločnosť zaujíma množstvo spotrebovaného paliva a navštívené predajne.
* Zmeniť mapovanie vytvorených objednávok na zodpovedného obchodného reprezentanta z priameho, na založené na regióne, v ktorom
sa predajňa nachádza a reprezentant ho má na starosti

![ER-diagram farmácia](/labs/files/lab02/farmacia_zadanie.png "E-R diagram farmácia")

Riešenie:

![ER-diagram farmácia](/labs/files/lab02/farmacia_riesenie.png "E-R diagram farmácia")


### Dátové modelovanie #7 - Autobusový dopravca

Regionálny autobusový dopravca vlastní niekoľko autobusov. Každý autobus je priradený na určitú
trasu, avšak niektoré trasy môžu vyžadovať priradenie viacerých autobusov. Každá trasa prechádza
niekoľkými mestami a je vytvorená z jedného alebo viacerých úsekov. Jeden úsek zahŕňa niekoľko
miest (všetky úseky tvoria trasu). Šofér autobusu môže byť priradený na jeden alebo viac úsekov (na
konci úseku sa napr. môžu šoféri striedať). V niektorých mestách je situovaná garáž pre autobusy.
Identifikujte entity, vzťahy medzi entitami a nakreslite logický dátový model.

Riešenie:

![ER-diagram prepravca](/labs/files/lab02/prepravca_riesenie.png "E-R diagram prepravca - riešenie")


### Dátové modelovanie #8 - Publikácie

Vydavateľská spoločnosť produkuje vedecké publikácie (knihy) na rôzne témy. Publikácie sú
zamerané predovšetkým na jednu odbornú tému a sú napísané jediným autorom, ktorý sa
špecializuje na konkrétnu tému. Spoločnosť zamestnáva editorov, ktorí majú výhradnú zodpovednosť
za editáciu aspoň jednej publikácie. Títo editori nemusia byť nutne odborníci na danú problematiku,
a preto sa pre zvýšenie kvality snažia najímať iných autorov v roli recenzentov. Tí sú špecialistami na
odborné témy, pričom na jednu tému najíma editor viacero recenzentov. Pri písaní publikácie je
autor pod dohľadom týchto recenzentov. Identifikujte entity, vzťahy medzi entitami a nakreslite logický dátový model.

Riešenie:

![ER-diagram vydavatel](/labs/files/lab02/vydavatel_riesenie.png "E-R vydavatel - riešenie")


### Dátové modelovanie #9 - Nemocnica

Všeobecná nemocnica sa skladá z niekoľkých špecializovaných izieb (napr. pediatrické oddelenie,
onkologické oddelenie). Na každej izbe je určitý počet pacientov, ktorí boli prijatí na odporúčanie ich
všeobecného lekára a konzultanta (doktor) zamestnaného nemocnicou. Vykonané testy a výsledky
predpísanej liečby sú zaznamenávané v samostatnej evidencii. Každý pacient sa môže podrobiť
viacerým testom. Je mu priradený jeden osobný konzultant, ale ak je potrebné, môže byť vyšetrený
viacerými doktormi s cieľom stanoviť (určiť) diagnózy. Doktor je špecialista v určitom odbore
medicíny a môže byť vedúci konzultant pre niekoľkých pacientov súčasne a nie nutne na rovnakom
oddelení. Pre pacienta navrhuje liečbu (liečby) doktor. Identifikujte entity, vzťahy medzi entitami
a nakreslite logický dátový model.

![ER-diagram nemocnica](/labs/files/lab02/nemocnica_riesenie.png "E-R nemocnica - riešenie")


### Dátové modelovanie #10 - Centrum voľného času

Centrum voľného času (ďalej CVČ) organizuje detské krúžky s rôznym zameraním (šachový, futbalový, plavecký atď.). 
Stretnutia krúžkov sa počas jedného sa kurzu konajú vždy každý týždeň pravidelne. V prípade veľkého záujmu o niektoré 
krúžky CVČ tiež zvykne organizovať viacero rovnakých kurzov o rôznych časoch, prípadne aj naraz. Po tom čo sa otvorí prázdny kurz,
je možné sa naň zapísať. Rodičia môžu zapísať svoje deti na koľko krúžkov len chcú. Za kurz sa vždy CVČ platí dopredu prostredníctvom platbou z účtu.
Vedenie CVČ sa pri evidovaní platieb nezaujíma o vlastníka účtu, pokiaľ je kurz riadne zaplatený.
Každý kurz vedie vždy minimálne jeden inštruktor. Inštruktori zvyknú tiež viesť viacero kurzov, 
samozrejme pokiaľ sa im pri tom nekolidujú termíny. Kurzom ktoré si to vyžadujú CVČ priraďuje v rozvrhu vhodné priestory 
v ktorých sa môžu do plnej miery venovať svojim aktivitám (miestnosť, ihrisko, plavecká dráha atď.). Niekedy môže rovnaké priestory zdieľať 
aj viacero kurzov. Identifikujte entity, vzťahy medzi entitami a nakreslite ER diagram.

Riešenie:

![ER-diagram centrum volneho casu](/labs/files/lab02/cvc_riesenie.png "E-R centrum volneho casu")

