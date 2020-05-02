grid_build(N,M):- length(M,N),grid_buildH(N,M).
grid_buildH(_,[]).
grid_buildH(N,[H|T]):- length(H,N),grid_buildH(N,T).


random(F,N,X):- num_gen(F,N,R),R=[H|T],F1 is F+1,(X=H;random(F1,N,X)).

grid_gen(N,M):- grid_build(N,M),grid_genH(N,M).



grid_genH(_,[]).
grid_genH(N,[H|T1]):-maplist(random(1,N),H),grid_genH(N,T1).




num_gen(F,L,[F|T]):- F<L,F1 is F+1,num_gen(F1,L,T).
num_gen(L,L,[L]).

max([H],H).
max([H|T],X):-  max(T,R),H>=R,X=H. 
max([H|T],X):- max(T,R),H<R,X=R.

largest([],0).
largest([H|T],L):- max(H,X),largest(T,L),X=<L.
largest([H|T],L):- max(H,L),largest(T,X),X<L.

check_num_grid(G):- largest(G,L),length(G,N),L=<N,num_gen(1,L,R),contains(R,G).

contains([],_).
contains([H|T],G):- containsH(H,G),contains(T,G).

containsH(X,[H|_]):- containshelper(X,H).
containsH(X,[H|T]):- \+containshelper(X,H),containsH(X,T).

containshelper(X,[X|_]).
containshelper(X,[H|T]):- X\=H,containshelper(X,T).


trans(M,M1):- transH(M,M1,1).

transH(M,[H|T],N):- length(M,X),N=<X,helperr2(M,H,N),N1 is N+1,transH(M,T,N1).
transH(M,[],N):- length(M,X),N>X.

helper([[]],_,_).
helper([],[],_).
helper([[H1|T1]|T],R,1):- append([H1],R1,R),helper(T,R1,N).
helper([[H1|T1]|T],R,N):- N\=1,N1 is N-1,helper2([[H1|T1]|T],R1),helper(R1,R,N1).


helperr2([[]|T],R,N):- helperr2(T,R,N).
helperr2([],[],_).
helperr2([[H1|T1]|T],R,1):- append([H1],R1,R),helperr2(T,R1,N).
helperr2([[H1|T1]|T],R,N):- N\=1,N1 is N-1,helper2([[H1|T1]|T],R1),helperr2(R1,R,N1).


helper2([],[]).
helper2([[H|T]|T1],[T|X]):- helper2(T1,X).

acceptable_distribution(G):- trans(G,M),acceptable_distributionH(G,M).

acceptable_distributionH([],[]).
acceptable_distributionH([H|T],[H1|T1]):- H\=H1,acceptable_distributionH(T,T1).

distinct_rows([]).
distinct_rows([H|T]):- distinct_rowsH(H,T),distinct_rows(T).

distinct_rowsH(_,[]).
distinct_rowsH(H,[H1|T]):- H\=H1,distinct_rowsH(H,T).

distinct_columns(G):- trans(G,M),distinct_rows(M).




acceptable_permutation(G,M):- permutation(G,M),acceptable_distributionH(G,M).


row_col_match(G):- trans(G,M),acceptable_permutation(G,M).

helsinki(N,G):- grid_gen(N,G),check_num_grid(G),distinct_rows(G),distinct_columns(G),row_col_match(G).

