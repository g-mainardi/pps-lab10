% Extra implementations - useful list predicates for the Connect Three
% copylist(+List, -ListClone)
copylist([E], [_]):- var(E), !.
copylist([E], [E]):- atom(E).
copylist([E|T], [_|Tc]):- var(E), copylist(T, Tc), !.
copylist([E|T], [E|Tc]):- atom(E), copylist(T, Tc).

% M.C.O. = Max Consecutive Occurrencies (for Lists) => non matching variables
mco(E, L, MCO):- mco(E, L, 0, 0, MCO). % start recursion with accumulators: count and current max
mco(_, [], Count, Max, Max):- Max > Count, !.    % end without update
mco(_, [], Count, _, Count):- !.									 % end with update
mco(E, [D|T], Count, Max, F):- atom(D), D = E, !, Counts is Count + 1, mco(E, T, Counts, Max, F). % recursion consecutive
mco(E, [_|T], Count, Max, F):- Max > Count, !, mco(E, T, 0, Max, F).								% recursion cut without update
mco(E, [_|T], Count, Max, F):- mco(E, T, 0, Count, F).															% recursion cut with update

% 4.1
% (Fully relational) disk(?Disk): Player 'x' or 'o'
disk(x).
disk(o).

% Predicates useful for disk presence checking
atomdisk(D):- atom(D),  disk(D).
vardisk(D):- var(D),  disk(D).

% other(?Player1, ?Player2)
other(x, o).
other(o, x).

% Specifying the number of consecutive disks to win = 3
towin(3).

% (Fully relational) col(?Column): A List of disks (with check on free places with variable)
col([R]):- atomdisk(R), !.
col([R|T]):- atomdisk(R), !, fullcol(T).
col([R]):- vardisk(R).
col([R|T]):- vardisk(R), col(T).
col([R1, R2|T]):- vardisk(R1), vardisk(R2), !, col(T).
col([R1, R2|T]):- vardisk(R1), atomdisk(R2), fullcol(T).

% (Fully relational) table(+Table): A List of columns
table([C]):- col(C), !.
table([C|T]):-	col(C), table(T).

% emptytable(+Table): A List of empty Lists
emptytable([]).
emptytable([[]|T]):- emptytable(T).

% getfirstrow(@Table, -Row, -NewTable): Split the first row of the table from the rest
getfirstrow([], [], []).
getfirstrow([[E|C]|T], [E|R], [C|NewT]):- getfirstrow(T, R, NewT).

% traspose(@Table, -NewTable): switch rows and columns
traspose(T, []):- emptytable(T), !.
traspose(T, [R|Rs]):- getfirstrow(T, R, Td), traspose(Td, Rs).

% winninglist(@DiskList, ?Winner): States the winner from the given List of disks (no check on variables)
winninglist(L, W):- disk(W), towin(N), mco(W, L, M), M >= N, !.

% (Fully relational) winningtablecol(?Table, ?Winner)
winningtablecol([C|_], W):- copylist(C, Cp), col(Cp), winninglist(C, W), !.
winningtablecol([_|T], W):- winningtablecol(T, W).

% (Fully relational) winningtablerow(?Table, ?Winner)
winningtablerow([R|_], W):- winninglist(R, W), !.
winningtablerow([_|T], W):- winningtablerow(T, W).

% fullcol(@Column)
fullcol([R]):- atomdisk(R), !.
fullcol([R|T]):- atomdisk(R), fullcol(T).

% fulltable(@Table)
fulltable([C]):- fullcol(C).
fulltable([C|T]):-	fullcol(C), fulltable(T).

% getResult(+Table, -Result): Get the result of a table
result(T, win(W)):- winningtablecol(T, W), !.
result(T, win(W)):- traspose(T, Trasp), winningtablerow(Trasp, W), !.
result(T, even):- fulltable(T), !.
result(T, nothing):- copy_term(T, Tc), table(Tc), !.

% dropdisk(@Column, +Player, -NewColumn): drop a disk in the first available row of the column
dropdisk([R], P, [P]):- var(R), !, disk(P).                  % case last row and free
dropdisk([R1, R2|T], P, [P, R2|T]):- var(R1), atom(R2), !.   % case last free row
dropdisk([R|T], P, [R|NewT]):- var(R), dropdisk(T, P, NewT). % case free and continue

% play(@Table, +Pawn, -NewTable): drop a disk in the first available column of the table
play([C|T], P, [C|NewT]):- fullcol(C), !, play(T, P, NewT).
play([C|T], P, [NewC|T]):- copylist(C, Cp), col(Cp), !, dropdisk(C, P, NewC).

% next(@Table, @Player, -Result, -NewTable)
next(T, P, R, NewT):- play(T, P, NewT), result(NewT, R).

% 4.2
% game(@Table, @Player, -Result, -TableList)
game(T, P, Res, [T|List]):-
	result(T, R),   % not directly matching, or else it would adapt the table to the "nothing" result
	R = nothing, !,
	play(T, P, NewT),
	other(P, Pn), game(NewT, Pn, Res, List).
game(T, P, Res, [T]):-	result(T, Res).