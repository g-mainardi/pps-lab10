% 3.1
% same (List1 , List2 )
% are the two lists exactly the same ?
same(nil, nil).
same(cons(H, L1), cons(H,L2)) :- same(L1, L2).
% same(L, L). SAREBBE STATO EQUIVALENTE?

% Necessaria per la all_bigger
greater(s(_), zero).
greater(s(G), s(N)) :- greater(G, N).

% 3.2
% all_bigger(List1, List2)
% all elements in List1 are bigger than those in List2 , 1 by 1
all_bigger(nil, nil).
all_bigger(cons(H1, L1), cons(H2, L2)) :-
	greater(H1, H2),
	all_bigger(L1, L2).
	
% Necessaria per la sub_list
search(X, cons(X, _)).
search(X, cons(_, Xs)) :- search(X, Xs).

% 3.3
% sublist(List1, List2 )
% List1 should contain elements all also in List2
sublist(nil, _).
sublist(cons(H, L1), L2) :-
	search(H, L2),
	sublist(L1, L2).


