% 1-2-3 INTRO
{Browse 1}
{Browse 2}
{Browse 3}
{Browse 4}

{Browse (1+5)*(9-2)}


% 3 ENTIER ET FLOTTANTS

{Browse {Int.toFloat 123} + 456.0}
{Browse 123 + {Float.toInt 456.0}}

% 4 VARIABLES

declare
X = 678-3*20
{Browse X}
{Browse X+56}

local X in
    X = 5*26
    {Browse X}
    local X in
        X = 5
        {Browse X}
    end
end

% 5 DECLARATION MULTIPLE

declare
X=42
Z=~3
{Browse X} % (1) #après avoir executé le 3ème bloc, la valeur de X a été modifiée
{Browse Z}

declare
Y=X+5
{Browse Y} % (2) # n'est pas influencé car Y a été stocké en mémoire

declare
X=1234567890
{Browse X} % (3)


% 6 EXPRESSION BOOLEENNE

{Browse 3 == 7} % egaux
{Browse 3 \= 7} % differents
{Browse 3 < 7} % plus petit
{Browse 3 =< 7} % plus petit ou egal
{Browse 3 > 7} % plus grand
{Browse 3 >= 3} % plus grand ou egal

% 7 FONCTIONS ET EXPRESSIONS

{Browse {Max 3 7}} % Trouve le maximum => 7
{Browse {Not 3==7}} % Valeur bool inverse => true

local X=5 Y=5 Z=6 R in
    R = {Max {Max X Y} Z}
    {Browse R}
end

declare 
fun {Signe X}
    if X==0 then 0 elseif X>0 then 1 else ~1 end
end

{Browse {Signe 45}}

% 8 PORTEE LEXICALE ET ENVIRONMENT

local P Q X Y Z in % (1) % décalre plusieurs variable
    fun {P X} % P est une fonction
        X*Y+Z % (2)
    end
    fun {Q Y} % Q est une fonction
        X*Y+Z % (3)
    end

    X=1 % Donne une valeur à X, Y et Z
    Y=2
    Z=3

    {Browse {P 4}} % Valeur : 4*2+3 = 11
    {Browse {Q 4}} % Valeur : 1*4+3 = 7
    {Browse {Q {P 4}}} % (4) Valeur : 1*11+3 = 14
    end

% Modif

local P Q X Y Z in % (1)
    fun {P U}
        U*X+Z % (2)
    end
    fun {Q Y} % Q est une fonction
        X*Y+Z % (3)
    end

    X=1
    Y=2
    Z=3

    {Browse {P 4}}
    {Browse {Q 4}}
    {Browse {Q {P 4}}} 
    end

% 9 ASTRACTION PROCEDURALE

declare
X=3

declare 
X=4
fun {Add2}
    X+2
end
fun {Mul2}
    X*2
end

{Browse {Add2}} % (1)
{Browse {Mul2}} % (2)


%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------------------------EXERCICES-------------------------------

%Sommes des carrés
declare 
% Sommes des carrés des entiers jusqu'à N
fun {Sum1 N}
    if N==0 then 0 else N*N + {Sum1 N-1} end
end
fun{Sum2 N Acc}
    if N==0 then Acc else {Sum2 N-1 Acc+N*N} end
end

{Browse {Sum1 6}}
{Browse {Sum2 6 0}}
%_________________________________

%Miroir mon beau miroir
declare 
fun {Mirror2 N Acc}
    if N==0 then Acc
    else
        {Mirror2 N div 10 Acc*10+N mod 10}
    end
end
fun {Mirror N}
    {Mirror2 N 0}
end

{Browse {Mirror 1234}}
%_________________________________

%Univers parallèle

% Partie 1

% Nombre de chiffre d'un nombre positif (Ne fonctionne pas pour N<0)
declare
fun {Foo N}
    if N<10 then 1
    else 1+{Foo (N div 10)}
    end
end

{Browse {Foo ~11234}}


% Partie 2

declare
local
    fun {FooHelper N Acc}
    if N<10 then Acc+1
    else {FooHelper (N div 10) Acc+1}
    end
end
in
    fun {Foo N}
    {FooHelper N 0}
    end
end

% Correct aussi, on utilise un accumulateur pour avoir le résultat.
{Browse {Foo 11234}} % Comportement identique pour des N<0

%_________________________________


%Procédure (1,2,3 nous irons au bois)
declare 
proc {BrowseNumber N}
    {Browse N}
    {Browse N+1}
end
proc {CountDown N}
    {Browse N}
    if N\=0 then {CountDown N-1} else skip end
end

{CountDown 55}
%_________________________________