%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------Definition/Appel de procédure-----------------------------

local P in % identificateur pointe vers p (valeur de la mémoire)
    local Z in
        Z=1
        proc {P X Y} Y=X+Z end % on attribue unne valeur à p dans la mémoire (qui était vide avant)
    end
    local B A in
        A=10
        {P A B} % On appelle la fonction stockée avant
        {Browse B}
    end
end

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------Filtrer une liste-----------------------------------------

declare 
fun {MakeMulFilter N}
    fun {$ I}
        I mod N == 0
    end
end
fun {Filter L F}
    case L
    of nil then nil
    [] H|T then
        if {F H} then
            H | {Filter T F}
        else
            {Filter T F}
        end
    end
end

L = [1 2 3 4 5 6 7 8 9 419]
L2 = {Filter L {MakeMulFilter 2}} %Nombre paire
L3 = {Filter L {MakeMulFilter 3}} %Multiple de trois
{Browse L2}
{Browse L3}

fun {PrimeHelper N Acc}
    if Acc=<1 then true
    else
        if (N mod Acc)== 0 then false
        else
            {PrimeHelper N Acc-1}
        end
    end
end
fun {IsPrime N} %Fonction utilisée par le filtre pour déteminer si premier ou pas
    {PrimeHelper N N-1}
end
{Browse {Filter L IsPrime}}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------REDUCTION_DE_LISTE----------------------------------------
declare
fun {Reduce L F Acc}
    case L
    of nil then Acc
    [] H|T then
        {Reduce T F {F Acc H}}
    end
end
fun {Add X Y}
    X+Y
end
fun {Mul X Y}
    X*Y
end
fun {Diff X Y} %A voir si c'est ça qu'ils appelent une différence
    X-Y
end

L=[1 2 3 4]
{Browse {Reduce L Add 0}}
{Browse {Reduce L Diff 0}}
{Browse {Reduce L Mul 1}}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------APPLICATION/MAP-------------------------------------------
declare
%Ici j'utilise Map à la place de Applique du TP3 (Mais ça fait la même chose)
L = [1 2 3 4]
L1 = {Map L fun {$ E} E*2 end}
{Browse L1}
fun {MakePowFunction E}
    fun {$ N}
        {Pow N E}
    end
end
L2 = {Map L {MakePowFunction 4}}
{Browse L2}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------TAUX_DE_CONVERSION----------------------------------------

declare 
fun {Convertir T V Offset}
    T*V+Offset
end
%On créée des fonctions pour ne pas préciser le taux à chaque fois
fun {MakePiedToMeter X}
    {Convertir X 1.0/3.281 0.0}
end
fun {MakeFarenheitToCelsius X}
    {Convertir X 0.56 ~17.79}
end
{Browse {MakePiedToMeter 4.0}}
{Browse {MakeFarenheitToCelsius 4.0}}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------PIPELINE--------------------------------------------------
declare 
fun {GenerateHelper N E}
    if E==N+1 then nil
    else
        E | {GenerateHelper N E+1}
    end
end
fun {GenerateList N}
    {GenerateHelper N 0}
end
fun {MyFilter L F}
    case L
    of nil then nil
    [] H|T then
        if {F H} then
            H | {MyFilter T F}
        else
            {MyFilter T F}
        end
    end
end
fun {MyMap L F}
    case L
    of nil then nil
    [] H|T then
        {F H} | {MyMap T F}
    end
end
declare
fun {MyFoldL L F Acc}
    case L
    of nil then Acc
    [] H|T then
        {MyFoldL T F {F Acc H}}
    end
end
fun {PipeLine N}
    P1 P2 P3 in
    P1 = {GenerateList N}
    P2 = {MyFilter P1 fun {$ X} X mod 2 \= 0 end}
    P3 = {MyMap P2 fun {$ X} X * X end}
    {MyFoldL P3 fun {$ Acc X} X + Acc end 0}
end
{Browse {PipeLine 7}}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------ENVIRONEMENT_CONTEXTUEL-----------------------------------

local Y LB in
    Y=10
    proc {LB X ?Z} %lors de l'appel, X=5
        if X>=Y then Z=X %condition est fausse (on se réfère au Y=10 car c'est celui de l'environement de la procédure)
        else Z=Y end %Z=Y=10
    end
    local Y=15 Z in
        {LB 5 Z}
        {Browse Z} %Affiche 10
    end
end

%Traduction en langage noyau (Essai en tt cas)
local Y LB Condition in
    Y=10
    LB = proc {$ X ?Z}
        Condition = X>=Y
        if Condition then Z=X
        else Z=Y end
    end
    local Y=15 Z Cinq in
        Cinq = 5
        {LB Cinq Z}
        {Browse Z}
    end
end