# NPRG005 - Hledání min

Vypracování programu doplňujícího konfigurace hry "Hledání min" na všechny validní varianty.

## Uživatelský manuál

Celou funkcionalitu programu lze vyvolat dotazem `minesweeper(X).`, kde X je neúplná čtvercová konfigurace min. Konfigurace je zapsána seznamem seznamů, má tedy následující tvar:

```
[[_,_,2,_,3,_],
[2,_,_,_,_,_],
[_,_,2,4,_,3],
[1,_,3,4,_,_],
[_,_,_,_,_,3],
[_,3,_,3,_,_]]
```

Ve vstupní konfiguraci se mohou vyskytovat číslice 0 až 8 indikující počet min v sousedních devíti pozicích, znak `*` reprezentující minu, či `_` představující neznámou hodnotu - proměnnou.

Po zavolání predikátu `minesweeper/1` jsou výsledky postupně vypisovány do konzole. Výsledky nejsou vraceny ve výstupních proměnných. Výsledkem je úplná konfigurace, tedy taková, v níž se nevyskytují znaky `_`, pokud taková konfigurace existuje. Výsledek může vypadat následovně:

```
* 2 2 2 3 * 
2 * 2 * * 3 
1 1 2 4 * 3 
1 2 3 4 * 2 
2 * * * 4 3 
* 3 3 3 * *
```

Test suite lze vyvolat predikátem `test/0`, jednotlivé testy pak predikáty `test0X/0`, kde X je číslo od 1 do 8. Pro zobrazení všech výsledků jednotlivých testů je nutno testy volat individuálně. Volání celého test suite totiž zobrazí jen jedinou variantu výsledku.

## Programátorská dokumentace

Hlavním predikátem programu je unární `minesweeper`. Jeho argument, seznam seznamů, je zkontrolován predikátem `isSquare`, aby se potvrdil jeho správný formát. Poté začíná vyhodnocování. Úkolem programu je dostat se ke všem validním variantám konečné konfigurace ve stavovém prostoru. Dojít k těmto konfiguracím lze postupným doplňováním volných proměnných na termy, které jsou v hledání min povoleny (`*`, `0 ... 8`) a zkoušením všech variant. Jakmile dosáhneme stavu, v němž jsou predikáty `fillNeighborhood`  na všech položkách vstupní matice pravdivé, je stav validní a vypíše se výsledek. 

Prolog tedy konfiguraci doplní tak, aby byly podmínky hry splněny. Tyto podmínky jsou definovány právě predikátem `fillNeighborhood/2`, který zaručuje, že devět sousedních políček obsahuje buďto jen miny, či miny a čísla tak, aby každé číslo odpovídalo počtu sousedních min. Predikát `fillNeighborhood` musí platit pro všechny položky matice, je tedy nutné nějakým způsobem matici projít a zavolat jej pro každou položku. Přístup, který jsem zvolil, není pro programování v prologu typický. Namísto rekurzivního ukusovaní prvků seznamu jsem implementoval procházení pomocí indexů. Matice se tedy prochází po řádcích, odkud získáváme index i. Každý řádek se pak prochází indexem j. Se znalostí obou indexů lze již čitelně získat všechny sousedy daného prvku. Prvek na daném indexu a seznam jeho sousedů jsou poté předány v argumentech výše zmíněnému predikátu.

Pro konečnost výpočtu je zde nutné omezit stavový prostor. Vyhovující termy, především číslovky, se proto hodí zapsat do predikátů, z nichž výpočet čerpá platné hodnoty. Zde jsou těmito predikáty `isInSearchSpace/1` a `hasSuccessor/1`, které říkají, zda je argument číslo 0 až 8 a v druhém případě, zda má argument celočíselného následníka, který leží mezi čísly 0 až 8. Jiná čísla nás totiž nezajímají a pouze výpočet zpomalují či zabraňují jeho dokončení.

Jelikož vypracované řešení pracuje hrubou silou do chvíle, než splní všechny predikáty, je doba běhu dlouhá. Převratné heuristiky mě zde nenapadly. Experimentoval jsem jen s odpočítáváním čísel vzestupně i sestupně, což odpovídá pořadí zapsání predikátu `isInSearchSpace`, a zvolil jsem rychlejší variantu (sestupnou).