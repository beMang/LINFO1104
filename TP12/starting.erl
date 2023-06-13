%J'ai regroupé le début du TP dans ce fichier

-module(starting).
-export([start/0, my_add/2, myfib/1, my_pow/2]).
hello_world() ->
    io:fwrite("Hello, World!\n").

start() -> %A amélioré pour la tâche 2
    io:fwrite("~p~n", [my_pow(2,3)]).

my_add(A, B) -> A + B.

myfib(N) when N>1 ->
    myfib(N-1)+myfib(N-2);
myfib(1) -> 1;
myfib(0) -> 0.

my_pow(B, E) -> my_pow_helper(B, E, 1).%fonctionne pour E>0

my_pow_helper(B, E, Acc) when E>0 ->
    my_pow_helper(B, E-1, Acc*B);
my_pow_helper(B, E, Acc) -> Acc.
