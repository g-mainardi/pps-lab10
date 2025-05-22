% Functions for List[Int]

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

% Per la reversed, mi occorre la funzione last per fare append 
last(nil, Last, cons(Last, nil)).
last(cons(H, L2), Last, cons(H, L)) :- last(L2, Last, L).

% reversed(List)
reversed(nil, nil).
reversed(cons(H, T), RL):-
	last(ORL, H, RL),
	reversed(T, ORL).
% Esempio goal:
% reversed(cons(s(zero), cons(s(s(s(zero))), cons(zero, cons(s(s(zero)), nil)))), L) => in L trovo la lista ribaltata
% reversed(L, cons(s(zero), cons(s(s(s(zero))), cons(zero, cons(s(s(zero)), nil))))) => posso invertire Input/Output




