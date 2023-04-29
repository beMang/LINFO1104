%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------Fabriques-------------------------------------------------
declare
fun {MakeBinaryGate F}
    fun {$ Xs Ys}
        fun {GateLoop Xs Ys}
            case Xs#Ys of (X|Xr)#(Y|Yr) then
                {F X Y}|{GateLoop Xr Yr}
            end
        end
    in
        thread {GateLoop Xs Ys} end
    end
end

fun {Xor A B} (A + B) mod 2 end
fun {And A B}
    if A==1 then
        if B==1 then 1 else 0 end
    else 0 end
end
fun {Or A B}
    if A==1 then 1
    elseif B==1 then 1
    else 0 end
end
fun {Nor A B}
    if A==0 then
        if B==0 then 1 else 0 end
    else 0 end
end

XorG = {MakeBinaryGate Xor}
AndG = {MakeBinaryGate And}
OrG = {MakeBinaryGate Or}
NorG = {MakeBinaryGate Nor}

%Test
A = 0|1|0|_
B = 1|1|0|_
{Browse {AndG A B}}

%Complexité de MakeBinaryGate : O(1)
%Complexité des fonctions retournées : O(n)

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------Portes_logiques-------------------------------------------

%TODO :
local R=1|1|1|0|_ S=0|1|0|0_ Q NotQ
    proc {Bascule Rs Ss Qs NotQs}
        {NorG Rs NotQs Qs}
        {NorG Ss Qs NotQs}
    end
in
    {Bascule R S Q NotQ}
    {Browse Q#NotQ}
end

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------LIST_COMPREHENSION----------------------------------------
declare
proc {ForCollect Xs P Ys}
    Acc={NewCell Ys}
    proc {C X} R2 in @Acc=X|R2 Acc:=R2 end
in
    for X in Xs do {P C X} end @Acc=nil
end

{Browse {ForCollect [0 2 4 6 8] proc {$ Collect X} {Collect X div 2} end}} % [0 1 2 3 4]

declare %(j'ai supposé qu'on pouvait utiliser des fonctions) ->Dernière question, non car le passage de la valeur se fait dans l'argument et donc on a besoin
%d'une fonction et pas d'un procédure pour pouvoir passer le résultat à l'appel récursif (terminal)
fun {ForCollectDecl Xs Proc Acc}
    fun {C X} {ForCollectDecl Xs.2 Proc {Append Acc [X]}} end
in
    {Show Xs}
    case Xs
        of nil then Acc
        [] H|T then {Proc C H}
    end
end

{Browse {ForCollectDecl [0 2 4 6 8] fun {$ Collect X} {Collect X div 2} end nil}} % [0 1 2 3 4]

{Browse {ForCollect [0 1 2 3 4 5] proc {$ Collect X} %pas possible ave cette procédure-ci
        case X mod 3
        of 0 then {Collect X} {Collect X}
        [] 1 then {Collect X}
        [] 2 then skip
        end
    end}
} % Affiche ? [0 0 1 3 3 4]