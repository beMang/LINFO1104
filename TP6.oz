declare
fun {Reverse Xs}
    local Cell in
        Cell = {NewCell nil}
        for I in Xs do
            Cell:=I|@Cell
        end
        @Cell
    end
end

{Browse {Reverse [1 2 3]}}

% Calculatrice
%Implémentation d'une stack
declare 
fun {NewStack}
    {NewCell nil}
end
fun {IsEmpty S}
    case @S
    of nil then true
    [] H|T then false
    end
end
proc {Push S X}
    S:=X|@S
end
fun {Pop S}
    if {IsEmpty S} then nil
    else
        local St in
            St = @S
            case St
            of H|T then
                S:=T
                H
            end
        end
    end
end
fun {Eval L}
    local Stack in
        Stack = {NewStack}
        for X in L do
            case X of '*' then {Push Stack {Pop Stack}*{Pop Stack}}
            [] '-' then {Push Stack ~({Pop Stack}-{Pop Stack})}
            [] '+' then {Push Stack {Pop Stack}+{Pop Stack}}
            [] '/' then {Push Stack {Pop Stack} div {Pop Stack}}
            else {Push Stack X}
            end
        end
        {Pop Stack}
    end
end
{Browse {Eval [13 45 '+' 89 17 '-' '*']}} % affiche 4176 = (13+45)*(89-17)
{Browse {Eval [13 45 '+' 89 '*' 17 '-']}} % affiche 5145 = ((13+45)*89)-17
{Browse {Eval [13 45 89 17 '-' '+' '*']}} % affiche 1521 = 13*(45+(89-17))
{Browse {Eval [10 120 '/']}}