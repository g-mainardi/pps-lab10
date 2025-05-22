% 2.1
% size (List , Size)
% Size will contain the number of elements in List, written using notation zero, s(zero), s(s(zero))..
size(nil, zero).
size(cons(_, T), s(N)) :- size(T, N).

% 2.2
% SOMMA NUMERI PEANO
sum(A, zero, A).
sum(A, s(B), s(C)) :- sum(A, B, C).
% sum_list (List , Sum )
sum_list(nil, zero).
sum_list(cons(H, nil), H).
sum_list(cons(H, T), Res) :- 
	sum_list(T, ResT),
	sum(ResT, H, Res).

% 2.3
% count(List, Element, NOccurrences)
% it uses count(List, Element, NOccurrencesSoFar, NOccurrences) <-- "extra-variable"
count(List, E, N) :- count(List, E, zero, N).
% definiamo la funzione ausiliaria
count(nil, _, N, N). % <- fine
count(cons(E, L), E, N, M) :- count(L, E, s(N), M). % <- caso ricorsivo: match testa
count(cons(E, L), E2, N, M) :- E\=E2, count(L, E2, N, M). % <- caso ricorsivo: NON match testa 
% ==> tail recursion

% Necessaria per la max
greater(s(_), zero).
greater(s(G), s(N)) :- greater(G, N).
	
% 2.4
% max(List , Max )
% Max is the biggest element in List
% Suppose the list has at least one element
max(cons(First, L), Max) :- max(L, First, Max).
max(nil, M, M). 					 % <- fine: ritorno quello che c'è

max(cons(E, L), TM, M) :-  % <- testa più grande del max
	greater(E, TM),
	max(L, E, M).

max(cons(E, L), TM, M) :-  % <- testa NON più grande del max
	greater(TM, E),
	max(L, TM, M).

% 2.5
% min-max(List, Min, Max)
% Min is the smallest element in List
% Max is the biggest element in List
% Suppose the list has at least one element
min_max(cons(First, L), Min, Max) :- min_max(L, First, First, Min, Max).

min_max(nil, TMin, TMax, TMin, TMax).

min_max(cons(E, L), TMin, TMax, Min, Max) :-
	greater(E, TMax),
	min_max(L, TMin, E, Min, Max).

min_max(cons(E, L), TMin, TMax, Min, Max) :-
	greater(TMin, E),
	min_max(L, E, TMax, Min, Max).

min_max(cons(E, L), TMin, TMax, Min, Max) :-
	greater(E, LessEqual),
	TMax\=LessEqual,
	greater(Greater, E),
	TMin\=Greater,
	min_max(L, TMin, TMax, Min, Max).





