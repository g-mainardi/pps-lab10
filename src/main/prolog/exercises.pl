% 1.1
% search2(Elem, List )
% looks for two consecutive occurrences of Elem
search2(E, [E, E | _]).
search2(E, [_ | T]) :- search2(E, T).

% 1.2
% search_two(Elem , List)
% looks for two occurrences of Elem with any element in between!
search_two(E, [E, _, E | _]).
search_two(E, [_ | T]) :- search_two(E, T).

% 1.3
% size(List, Size)
size([], 0).
size([E | T], S) :- size(T, Ss), S is Ss + 1.

% 1.4
% sum(List, Sum)
sum([], 0).
sum([E | T], S) :- sum(T, Ss), S is Ss + E.

% 1.5
% max(List, Max, Min)
max_min([H | List], Max, Min) :- max_min(List, H, H, Max, Min).
max_min([], Max, Min, Max, Min).
max_min([H | List], TMax, TMin, Max, Min):-
	H > TMax,
	!,
	max_min(List, H, TMin, Max, Min).
max_min([H | List], TMax, TMin, Max, Min):-
	H < TMin,
	!,
	max_min(List, TMax, H, Max, Min).
max_min([H | List], TMax, TMin, Max, Min):-
	max_min(List, TMax, TMin, Max, Min).

% 1.6
% split (List1 , Elements , SubList1 , SubList2 )
% example : split([10 ,20 ,30 ,40 ,50], 2, L1, L2). 
%           -> L1/[10 ,20] L2 /[30 ,40 ,50]
split(List, 0, [], List):- !.
split([H | L], Split, [H | SubList1], SubList2):-
	DecSplit is Split - 1,
	split(L, DecSplit, SubList1, SubList2).

% 1.7
% rotate(List, RotatedList)
% example: rotate([10, 20, 30, 40], L). -> L /[20 ,30 ,40 ,10]
rotate([H | T], RList):- append(T, [H], RList).

% 1.8
% count_occurrences ( Element , List , Count )
% example : count_occurrences(2, [1, 2, 3, 2, 4, 2], Count). -> Count /3
count_occurrences(_, [], 0).
count_occurrences(E, [E | T], Count):-
	!,
	count_occurrences(E, T, Counts),
	Count is Counts + 1.
count_occurrences(E, [_ | T], Count):-
	count_occurrences(E, T, Count).

% 1.9
% Utile per dice (range)
% interval(@A, @B, -X).
interval(A, _, A).
interval(A, B, X):- A2 is A +1, A2 < B, interval(A2, B, X).

% dice(X)
% Generates all possible outcomes of throwing a dice .
% example : dice (X): X /1; X/2; ... X/6
dice(X):- interval(1, 7, X).

% 1.10
% Generalizzazione di three_dice
n_dice([], 0):- !.
n_dice([X | L], N) :- 
	dice(X),
	Nn is N - 1, 
	n_dice(L, Nn).
	
% three_dice(L)
three_dice(L):- n_dice(L, 3).

% 1.11

% distinct(+List, -DistinctList)
% DistinctList contains all distinct elements from List .
% example : distinct([1 ,2 ,3 ,2 ,4 ,1] ,L). -> L/[1 ,2 ,3 ,4]
distinct([], []).
distinct([E | T], DT) :- member(E, T), !,  distinct(T, DT).
distinct([E | T], [E | DT]) :- distinct(T, DT).

% 2.1
% dropAny(?Elem, ?List, ?OutList)
dropAny(X, [X|T], T).
dropAny(X, [H|Xs], [H|L]):- dropAny(X, Xs, L).

% 2.2 
% dropFirst: drops only the first occurrence (showing no alternative results)
dropFirst(E, L, DL):- dropAny(E, L, DL), !.

% dropLast: drops only the last occurrence (showing no alternative results)

% my version
%dropLast(E, [H|T], [H|DL]):- member(E, T), !, dropLast(E, T, DL).
%dropLast(E, [E|T], T).

% version by swapping dropAny clauses
%dropLast(X, [H|Xs], [H|L]):- dropLast(X, Xs, L), !.
%dropLast(X, [X|T], T).

% compact version (not efficient)
dropLast(X, L, DL):- 	reverse(L, RL), dropFirst(X, RL, RDL), reverse(RDL, DL).

% dropAll: drop all occurrences, returning a single list as a result
dropAll(E, L, DA):- member(E, L), !, dropFirst(E, L, DF), dropAll(E, DF, DA).
dropAll(_, L, L).

% 3.1
% fromList(+List, -Graph)
fromList([_], []).
fromList([H1, H2|T], [e(H1, H2)|L]):- fromList([H2|T], L).

% 3.2
% outDegree(+Graph, +Node, -Deg)
% Deg is the number of edges which start from Node
outDegree([], _, 0):- !.
outDegree([e(N, _)|T], N, D):- !, outDegree(T, N, Dd), D is Dd + 1.
outDegree([_|T], N, D):- outDegree(T, N, D).

% 3.3
% reaching(+Graph, +Node, -List)
% all the nodes that can be reached in 1 step from Node
% possibly use findall, looking for e(Node, _) combined with member(?Elem, ?List)
reaching(G, Node, Res):- findall(E, (member(e(Node, E), G)), Res).

% 3.4
% nodes(+Graph, -Nodes)
% create a list of all nodes(no duplicates) in the graph(inverse of fromList)
nodes(Graph, Nodes):- nodes(Graph, Nodes, All), distinct(All, Nodes).
nodes([], _, []).
nodes([e(S, D)|T],_, [S, D|List]):- nodes(T, _, List).

% 3.5
% anypath(+Graph, +Node1, +Node2, -ListPath)
% a path from Node1 to Node2, if there are many path, they are showed 1-by-1
anypath(G, N1, N2, [e(N1, N2)]):- reaching(G, N1, L1), member(N2, L1).
anypath(G, N1, N2, [e(N1, E)|LD]):- member(e(N1, E), G), anypath(G, E, N2, LD).

% 3.6
% allreaching(+Graph, +Node, -List)
% all the nodes that can be reached from Node
% Suppose the graph is NOT circular! Use findall and anyPath !
allreaching(G, N, L):- 	findall(E, anypath(G, N, E, _), L).

%--- --------------------
% From lesson slides
%------------------------
neighbour(X, Y, X, Y2) :- Y2 is Y + 1.
neighbour(X, Y, X, Y2) :- Y2 is Y - 1.
neighbour(X, Y, X2, Y) :- X2 is X + 1.
neighbour(X, Y, X2, Y) :- X2 is X - 1.

gridlink(N, M, link(X, Y, X2, Y2)) :-
    interval(0, N, X),
    interval(0, M, Y),
    neighbour(X, Y, X2, Y2),
    X2 >= 0, Y2 >= 0, X2 < N, Y2 < M.
%-------------------------

% 3.7
% (auxiliar) Generate an edge for a Graph of size S
% gridedge(+Size, ?Edge)
gridedge(S, e(E1, E2)):- interval(0, S, E1), interval(0, S, E2), E1=\=E2.

% Grid Graph construction (1-dimension)
% gridgraph(+Width, +Height, -Graph)
gridgraph(N, M, G):- Size is N * M, findall(E, gridedge(Size, E), G).

% Grid Graph construction (2-dimension)
% gridgraph_2(+Width, +Height, -Graph)
% Functor "n" for representing the node
gridgraph_2(N, M, G) :- findall(e(n(X,Y), n(X2,Y2)), gridlink(N, M, link(X,Y,X2,Y2)), G).

% (auxiliar) allpathcount(+Graph, +Source, +Destination, -NHops, -Path)
allpathcount(G, S, D, 1, [e(S, D)]):- member(e(S, D), G), !.
allpathcount(G, S, D, N, [e(S, E)|Path]):- member(e(S, E), G), allpathcount(G, E, D, Hop, Path), N is Hop + 1.

% allpathlimited(+Graph, +Source, +Destination, ?MaxHops, -Path)
allpathlimited(G, S, D, Max, Path):- var(Max), allpathcount(G, S, D, Max, Path).
allpathlimited(G, S, D, Max, Path):- number(Max), allpathcount(G, S, D, N, Path), N =< Max.