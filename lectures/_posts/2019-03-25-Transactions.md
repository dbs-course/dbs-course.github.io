---
layout: dbs
categories: lectures
anchor: transactions
order: 6
published: false
---
## Šiesta prednáška (Transakcie)

Prešli sme si ACID vlastnosti relačných databáz a transakcie ako nástroj na ich dosiahnutie:

* Atomicita - transakcia je buď spracovaná kompletne celá alebo vôbec
* Konzistencia - databáza, resp. dáta sú v konzistentnom stave pred aj po vykonaní transakcie
* Izolácia - napriek tomu, že vykonávanie transakcií môže byť vykonané paralelne, výsledok musí byť taký, ako keby boli vykonávané izolovane/sekvenčne
* Trvácnosť dát - dáta sú chránené voči zlyhaniam, výpadkom

[slajdy k Transakciám [pdf]](/lectures/files/06_Transactions.pdf)

Povedali sme si čo je to objektovo-relačné mapovanie, načo je to dobré a aké sú s tým spojené nástrahy.
Ukázali sme si 

* Niekoľko vzorov z [Patterns of Enterprise Application Architecture](https://www.martinfowler.com/eaaCatalog/)
  * s ORM súvisí napr. [Unit of Work](https://www.martinfowler.com/eaaCatalog/unitOfWork.html) alebo [Identity Map](https://www.martinfowler.com/eaaCatalog/identityMap.html)
* Hibernate (skúste `with-orm` branch ukážkového projektu) - toto ešte dokončím nabudúce.
* ActiveRecord - toto ešte dokončím nabudúce.

[slajdy k ORM [pdf]](/lectures/files/06_ORM.pdf)
