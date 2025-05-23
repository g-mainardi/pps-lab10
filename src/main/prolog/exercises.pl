% Ex 1
% 1.1
% search(Elem, List)
search(X, cons(X, _)).
search(X, cons(_, Xs)) :- search(X, Xs).

% 1.2
% search2 (Elem , List) --> looks for two consecutive occurrences of Elem
search2(X, cons(X, cons(X, _))).
search2(X, cons(_ , Xs )) :- search2(X, Xs).

% 1.3
% search_two(Elem, List)
% looks for two occurrencies of Elem with any element in between!
search_two(X, cons(X, cons(_, cons(X, _)))).
search_two(X, cons(_, Xs)) :- search_two(X, Xs).

% 1.4
% search_anytwo(Elem, List) --> looks for any Elem that occurs two times, anywhere
search_anytwo(X, cons(X, Xs)) :- search(X, Xs).
search_anytwo(X, cons(_, Xs)) :- search_anytwo(X, Xs).

% 2.1
% size (List , Size)
size(nil, zero).
size(cons(_, T), s(N)) :- size(T, N).

% 2.2
% SOMMA NUMERI PEANO
sum(A, zero, A).
sum(A, s(B), s(C)) :- sum(A, B, C).
% sum_list (List , Sum )
sum_list(nil, zero).				  % caso lista vuota (opzionale)
sum_list(cons(H, T), Res) :- % caso generale ricorsivo: sommo e vado avanti
	sum_list(T, ResT),
	sum(ResT, H, Res).

% 2.3
% count(List, Element, NOccurrences)
count(List, E, N) :- count(List, E, zero, N).							% uso "variabile extra"
% definiamo la funzione ausiliaria
count(nil, _, N, N). 																				% caso base
count(cons(E, L), E, N, M) :- count(L, E, s(N), M). 				% caso match testa
count(cons(E, L), E2, N, M) :- E\=E2, count(L, E2, N, M). % caso NON match testa: passo

% Necessaria per la max
greater(s(_), zero).
greater(s(G), s(N)) :- greater(G, N).
	
% 2.4
% max(List , Max )
% Max is the biggest element in List
% Suppose the list has at least one element
max(cons(First, L), Max) :- max(L, First, Max).
max(nil, M, M). 					  % caso base
max(cons(E, L), TM, M) :-  % caso nuovo massimo
	greater(E, TM),
	max(L, E, M).
max(cons(E, L), TM, M) :-  % caso NON nuovo massimo: passo
	greater(TM, E),
	max(L, TM, M).

% 2.5
% min-max(List, Min, Max) [Suppose the list has at least one element]
min_max(cons(First, L), Min, Max) :- min_max(L, First, First, Min, Max).
min_max(nil, TMin, TMax, TMin, TMax).        % caso base
min_max(cons(E, L), TMin, TMax, Min, Max) :- % caso nuovo massimo
	greater(E, TMax),
	min_max(L, TMin, E, Min, Max).
min_max(cons(E, L), TMin, TMax, Min, Max) :- % caso nuovo minimo
	greater(TMin, E),
	min_max(L, E, TMax, Min, Max).
min_max(cons(E, L), TMin, TMax, Min, Max) :- % caso nè nuovo minimo nè nuovo massimo: passo
	greater(TMax, E),
	greater(E, TMin),
	min_max(L, TMin, TMax, Min, Max).

% 3.1
% same (List1 , List2 ) --> are the two lists exactly the same ?
same(nil, nil).
same(cons(H, L1), cons(H,L2)) :- same(L1, L2).
% same(L, L). SAREBBE STATO EQUIVALENTE?

% 3.2
% all_bigger(List1, List2) --> all elements in List1 are bigger than those in List2 , 1 by 1
all_bigger(nil, nil).
all_bigger(cons(H1, L1), cons(H2, L2)) :-
	greater(H1, H2),
	all_bigger(L1, L2).

% 3.3
% sublist(List1, List2 )
% List1 should contain elements all also in List2
sublist(nil, _).
sublist(cons(H, L1), L2) :-
	search(H, L2),
	sublist(L1, L2).

% 4.1
% seq(N,E, List ) --> List is [E,E ,... ,E] with size N
% example : seq( s(s(s( zero ))), a, cons(a, cons(a, cons(a, nil )))).
seq(zero, _, nil).
seq(s(N), E, cons(E, T)) :- seq(N, E, T).

% 4.2
% seqR(N, List)
% example: seqR(s(s(s(zero))), cons(s(s(zero)),cons(s(zero),cons(zero,nil)))).
seqR(zero, nil).
seqR(s(N), cons(N,L)) :-seqR(N, L).

% Predicato ausiliario last
last(nil, Last, cons(Last, nil)).
last(cons(H, L2), Last, cons(H, L)) :- last(L2, Last, L).
% working with --> last(cons(a,cons(b,nil)),c,cons(a,cons(b,cons(c,nil)))).
% NB: funziona anche come append

%Ex4.3: seqR2
% seqR2 (N, List ) --> is [0 ,1 ,... ,N -1]
% example: seqR2(s(s(s(zero))), cons(zero,cons(s(zero),cons(s(s(zero)),nil)))).
seqR2(zero, nil).
seqR2(s(N), NL) :-
	last(L, N, NL),
	seqR2(N, L).

% Ex 5: Functions for List[Int]
% filter(List, Predicate)
filter(nil, nil).
filter(cons(H, L), cons(H, FL)) :- 
	filter_pred(H), 
	filter(L, FL).
filter(cons(H, L), FL) :- 
	filter_pred(Ok),
	H\=Ok, 
	filter(L, FL).
% Il predicato per il filtraggio va specificato qui: 
filter_pred(s(N)). % esempio: filtra solo numeri > 0
% Esempio goal:
% filter(cons(s(zero), cons(zero, cons(s(s(zero)), nil))), L) => in L trovo la lista [1,2], zero rimosso

% map(List, Mapping_Func)
map(nil, nil).
map(cons(H, L), cons(NH, NL)) :- 
	map_func(H, NH), 
	map(L, NL).
% La funzione di mapping va specificata qui:
map_func(N, s(N)). % esempio: incrementa ogni elemento di uno
% Esempio goal:
% map(cons(s(zero), cons(s(s(s(zero))), cons(s(s(zero)), nil))), L) => in L trovo tutti gli elementi INCREMENTATI di uno
% map(L, cons(s(zero), cons(s(s(s(zero))), cons(s(s(zero)), nil)))) => in L trovo tutti gli elementi DECREMENTATI di uno

% take(List, Number)
take(nil, _, nil).
take(_, zero, nil).
take(cons(H, L), s(N), cons(H, L2)) :- take(L, N, L2).
% Esempio goal:
% take(cons(s(zero), cons(s(s(s(zero))), cons(zero, cons(s(s(zero)), cons(s(zero), nil))))), s(s(zero)), L)
% 	=> in L trovo solo la lista con solo i primi due elementi [1,3]
% take(cons(s(zero), nil), s(s(zero)), L) => ho chiesto due elementi, ce n'era solo uno, in L trovo quello

% reversed(List)
reversed(nil, nil).
reversed(cons(H, T), RL):-
	last(ORL, H, RL),
	reversed(T, ORL).
% Esempio goal:
% reversed(cons(s(zero), cons(s(s(s(zero))), cons(zero, cons(s(s(zero)), nil)))), L) => in L trovo la lista ribaltata
% reversed(L, cons(s(zero), cons(s(s(s(zero))), cons(zero, cons(s(s(zero)), nil))))) => posso invertire Input/Output

