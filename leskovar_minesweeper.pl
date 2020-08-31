% Rozlozeni min je zapsano pomoci seznamu (s kratkym u) seznamu (s dlouhym u).
% Rozlozeni je dle zadani ctvercove.
% V rozlozeni se mohou objevit cisla 0-8, indikujici pocet min v sousednich
% osmi policcich, nebo znak hvezdicka reprezentujici minu.
% Ukolem je doplnit neuplne rozlozeni na uplne polozenim min a cisel.

test :- test01,
		test02,
		test03,
		test04,
		test05,
		test06,
		test07,
		test08,
		!.

test01 :- write("Test 01:"),
	minesweeper([
    [*,_],
    [_,_]]).

test02 :- write("Test 02:"), 
	minesweeper([
    [2,3,_],
    [*,_,*],
    [_,3,2]]).

test03:- write("Test 03:"),
	minesweeper([
    [2,_],
    [_,2]]).

test04 :- write("Test 04:"), 
	minesweeper([
    [_,_],
    [2,_]]).

test05 :- write("Test 05:"), 
	minesweeper([
    [_,3],
    [_,_]]).

test06 :- write("Test 06:"), 
	minesweeper([
    [_,_,_],
    [_,8,_],
    [_,_,_]]).

test07 :- write("Test 07:"), 
	minesweeper([
    [*,*,*],
    [*,_,*],
    [*,*,*]]).

test08 :- write("Test 08:"), 
	minesweeper([
    [_,_,2,_,3,_],
    [2,_,_,_,_,_],
    [_,_,2,4,_,3],
    [1,_,3,4,_,_],
    [_,_,_,_,_,3],
    [_,3,_,3,_,_]]).
	

%minesweeper(+X):- Doplni neuplne vstupni rozlozeni X.
minesweeper(X) :- isSquare(X),
				  traverseAndFillMatrix(X, 1),
				  printResult(X).

%isSquare(+X):- Overi, zda je matice ctvercova.
isSquare([]).
isSquare([[_]]).
isSquare(M) :- M = [X | Xs], length(M, Radky), length(X, L), 
			   Radky =:= L, isOfLength(Xs, L).

%isOfLength(+X, ?L) :- Overi, zda maji podseznamy stejnou delku.
isOfLength([X], L) :- length(X, L).
isOfLength([X | Xs], L) :- length(X, L), isOfLength(Xs, L).

%isInBounds(+X, +I):- Overi, zda lze indexem I pristupovat do seznamu X.
% 					  Indexy se zde pocitaji od 1.
isInBounds(X, I) :- I >= 1, length(X, L1), I =< L1.

%element(+M, +I, +J, -P):- Nalezne prvek matice M na pozici I, J. 
%						   V pripade, kdy je index neplatny,
%						   je vracen nil.
element(M, I, J, P) :- isInBounds(M, I), nth1(I, M, R),
					   isInBounds(R, J), nth1(J, R, P), !.
element(_, _, _, nil).
					
%neighborsRaw(+M, +I, +J, -N):- Nalezne sousedy (v 8 sousednich
%							    pozicich) prvku na pozici I, J a to 
%								vcetne prvku mimo matici (nil).
neighborsRaw(M, I, J, N) :- N = [N1, N2, N3, N4, N5, N6, N7, N8],
						I1 is I - 1, I2 is I + 1, 
						J1 is J - 1, J2 is J + 1,
						element(M, I1, J1, N1),
						element(M, I1, J, N2),
						element(M, I1, J2, N3),
						element(M, I, J1, N4),
						element(M, I, J2, N5),
						element(M, I2, J1, N6),
						element(M, I2, J, N7),
						element(M, I2, J2, N8).

%neighbors(+M, +I, +J, -N):- Nalezne platne sousedy (v 8 sousednich
%							 pozicich matice M) prvku na pozici I, J.						
neighbors(M, I, J, N) :- neighborsRaw(M, I, J, N1),
						 filterList(nil, N1, N).

%areIdentical(+X, +Y):- Overi, zda jsou prvky X a Y shodne.
areIdentical(X, Y) :- X == Y.

%filterList(+P, +X, -Y):- Odstrani prvky P ze seznamu X, vysledek
%						  preda v Y.
filterList(P, X, Y) :- exclude(areIdentical(P), X, Y).
						
%fillNeighborhood(?P, ?N):- Budto doplni hodnotu prvku na zaklade 
%							jeho sousednich prvku, nebo sousedni
%							prvky na zaklade hodnoty prvku. 
%							Predikat plati jen pokud vsech 9
%							policek splnuje pravidlo, kdy cisla
%							odpovidaji poctu sousednich min.
fillNeighborhood(*, _).
fillNeighborhood(0, []).
fillNeighborhood(P, [* | Ns]) :- succ(P1, P), fillNeighborhood(P1, Ns).
fillNeighborhood(P, [N | Ns]) :- isInSearchSpace(P), isInSearchSpace(N),
								 fillNeighborhood(P, Ns).

%traverseAndFillMatrix(+M, +I):- Projde radky matice M od I-teho 
%								 radku a volanymi predikaty zmeni
%								 jejich obsah. 
traverseAndFillMatrix(M, I1) :- length(M, I), I1 is I + 1.
traverseAndFillMatrix(M, I) :- I1 is I + 1, traverseAndFillRow(M, I, 1),
							   traverseAndFillMatrix(M, I1).

%traverseAndFillRow(+M, +I, +J):- Projde I-ty radek matice M od J-teho
% 								  indexu. Pro kazdy prvek doplni jeho
%								  hodnotu a sousedy.
traverseAndFillRow([X | _], _, J1) :- length(X, J), J1 is J + 1.
traverseAndFillRow(M, I, J) :- J1 is J + 1, element(M, I, J, P),
							   neighbors(M, I, J, N), 
							   fillNeighborhood(P, N), 
							   traverseAndFillRow(M, I, J1).

%printResult(+M):- Vypise obsah matice M s jednoradkovym odsazenim.
printResult(M) :- write("\n"), printMatrix(M), write("\n").

%printMatrix(+M):- Vypise obsah seznamu seznamu M v poradi.
printMatrix([]).
printMatrix([X | Xs]) :- printRow(X), write("\n"), printMatrix(Xs).

%printRow(+X):- Vypise obsah seznamu X.
printRow([]).
printRow([X | Xs]) :- write(X), write(" "), printRow(Xs).

%succ(+X, -Y):- Vrati celociselneho naslednika Y celeho cisla X.
succ(X, Y) :- hasSuccessor(X), Y is X + 1.

%isInSearchSpace(?N):- Vrati ta cela cisla, ktera jsou ve search space
%					   -> pocet sousednich min -> 0 az 8.
isInSearchSpace(8).
isInSearchSpace(7).
isInSearchSpace(6).
isInSearchSpace(5).
isInSearchSpace(4).
isInSearchSpace(3).
isInSearchSpace(2).
isInSearchSpace(1).
isInSearchSpace(0).

%hasSuccessor(?N):- Vrati ta cela cisla, ktera maji ve search space 
%					naslednika.
hasSuccessor(7).
hasSuccessor(6).
hasSuccessor(5).
hasSuccessor(4).
hasSuccessor(3).
hasSuccessor(2).
hasSuccessor(1).
hasSuccessor(0).