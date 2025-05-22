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

%Ex4.3: seqR2
% seqR2 (N, List ) --> is [0 ,1 ,... ,N -1]
% example: seqR2(s(s(s(zero))), cons(zero,cons(s(zero),cons(s(s(zero)),nil)))).
% Note, you may need to add a predicate “last”
last(nil, Last, cons(Last, nil)).
last(cons(H, L2), Last, cons(H, L)) :- last(L2, Last, L).
% working with --> last(cons(a,cons(b,nil)),c,cons(a,cons(b,cons(c,nil)))).
% NB: funziona anche come append

seqR2(zero, nil).
seqR2(s(N), NL) :-
	last(L, N, NL),
	seqR2(N, L).