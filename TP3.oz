%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------TRADUCTION EN LANGAGE NOYAU-------------------------------

% a)
declare
fun {Sum N}
if N == 1 then 1
else N*N + {Sum N-1} end
end

{Browse {Sum 10}}

% Traduction de Sum en langage noyau :
local Sum in
    Sum = proc {$ N ?R}
        local One B in
            One = 1
            B = N==One
            if B then R=One
            else
                local Mult S Add in
                    Mult = N*N
                    S = {Sum N-1}
                    Add = Mult + S
                    R = Add
                end
            end
        end
    end
    
{Browse {Sum 10}}
end

% b)
declare
fun {SumAux N Acc}
    if N == 1 then Acc + 1
    else {SumAux N-1 N*N+Acc} end
end

fun {Sum N}
    {SumAux N 0}
end

{Browse {Sum 20}}

% Traduction de SumAux en langage noyau :
declare 
SumAux = proc {$ N Acc ?R}
    local One B Int in
        One = 1
        B = One==N
        if B then
            Int = Acc + 1
            R = Int
        else
            local Mult Add N1  in
                Mult = N*N
                Add = Mult + Acc
                N1 = N-One
                {SumAux N1 Add R}
            end
        end
    end
end

Sum = proc {$ N ?R}
    {SumAux N 0 R}
end

{Browse {Sum 20}}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------ONLY_RECORDS----------------------------------------------
declare 
L1 = [1]
R1 = '|'(1:1 2:nil)
{Browse R1==L1}

L2 =  [1 2 3]
R2 = '|'(1:1 2:'|'(1:2 2:'|'(1:3 2:nil)))
{Browse R2==L2}

L3 = nil
R3 = nil
{Browse R3==L3}

L4 = state(4 f 3)
R4 = state(1:4 2:f 3:3)
{Browse R4==L4}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------ENVIRONMENT_CONTEXTUEL------------------------------------
proc {Q A} {P A+1} end % EC = {P->p}
proc {P} {Browse A} end % EC = {A->a, Browse->b}

local P Q in
    proc {P A R} R=A+2 end %EC= {vide}
    local P R in
        fun {Q A} % EC = {P->p, R->r}
            {P A R}
            R
        end
        proc {P A R} R=A-2 end % EC = {vide}
    end
    %% Qu'affiche {Browse {Q 4}} ? %Ca affiche 2 ? OUII
    {Browse {Q 4}}
end

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------SEMANTIQUE------------------------------------------------

%fait sur feuille manuscrite sorry faudra se débrouiller :/

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------SEMANTIQUE------------------------------------------------

%Il faudrait détailler l'execution avec la machine abstraite.
local MakeAdd Add1 Add2 in
    proc {MakeAdd X Add}
        proc {Add Y Z}
            Z=X+Y
        end
    end
    {MakeAdd 1 Add1} %Add1 pointe vers une fonction bien définie dans la mémoire
    {MakeAdd 2 Add2} %Add1 pointe vers une fonction bien définie dans la mémoire (autre que celle de Add1)
    local V in
        {Add1 42 V} {Browse V} %Utilise la fonction stockée en mémoire, qui est identifiée par Add1
    end
    local V in
        {Add2 42 V} {Browse V} %Utilise la fonction stockée en mémoire, qui est identifiée par Add2
    end
end