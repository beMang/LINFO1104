%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------Threads et concurrence------------------------------------

declare A B C D 
thread D = C+1 end %Threads créé dans l'ordre des instructions : D C A B
thread C = B+1 end %Ordre d'execution n'est pas connu : A B C D
thread A = 1 end
thread B = A+1 end
{Browse D}

%Machine abstraite : fait en TP

%2
local X Y Z in
    thread if X==1 then Y=2 else Z=2 end end
    thread if Y==1 then X=1 else Z=2 end end
    X=1
    %X=1 Y=2 Z=2
    {Browse X}
    {Browse Y}
    {Browse Z}
end

local X Y Z in
    thread if X==1 then Y=2 else Z=2 end end
    thread if Y==1 then X=1 else Z=2 end end
    X=2
    %X=2 Y=? Z=2
    {Browse X}
    {Browse Y}
    {Browse Z}
end

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------PRODUCER_CONSUMER-----------------------------------------
declare
fun {ProduceInts N}
    if N==0 then nil
    else N|{ProduceInts N-1} end
end

fun {SumHelper L Acc}
    case L of nil then Acc
    []H|T then {SumHelper T Acc+H} end
end
fun {Sum Str}
    {SumHelper Str 0}
end

declare Xs S
thread Xs = {ProduceInts 10} end
thread S = {Sum Xs} end
{Browse S}

declare Xs S
Xs = {ProduceInts 10}
S = {Sum Xs}
{Browse S}

%4 début : filtre
declare
fun {FilterOdd N}
    case N of nil then nil
    []H|T then
        if H mod 2==0 then
            H|{FilterOdd T}
        else
            {FilterOdd T}
        end
    end
end

declare Xs S Ys
thread Xs = {ProduceInts 10} end
thread Ys = {FilterOdd Xs} end
thread S = {Sum Ys} end
{Browse S}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------FILTER----------------------------------------------------
declare
fun {ServeBeer}
    if {OS.rand} mod 2 == 0 then trappist else beer end
end
fun {Barman N}
    {Delay 3000}
    if N==0 then nil
    else
        {ServeBeer}|{Barman N-1}
    end
end

fun {SmellTrappist Beer}
    Beer==trappist
end

fun {Charlotte BeerStream}
    case BeerStream of nil then 0
    [] H|T then
        if {SmellTrappist H} then 1+{Charlotte T} else {Charlotte T} end
    end
end

declare
N=5
BeerStream = {Barman N}
Cha = {Charlotte BeerStream}
{Browse 'Bière Charlotte :'}
{Browse Cha}
{Browse 'Ami Charlotte :'}
{Browse N-Cha}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------TRACKING_INFORMATION--------------------------------------

declare
fun {GetList NewElement Acc}
    case Acc
    of nil then [NewElement#1]
    [] H|T then
        if NewElement==H.1 then
            NewElement#H.2+1|T
        else 
            H|{GetList NewElement T}
        end
    end
end
fun {CounterHelper InS Acc}
    case InS
    of nil then nil
    []H|T then 
        {GetList H Acc}|{CounterHelper T {GetList H Acc}} 
    end
end
fun {Counter InS}
    thread {CounterHelper InS nil} end
end
local InS in
    {Browse {Counter InS}}
    InS=a|b|a|c|_
end

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------PORTE_LOGIQUE---------------------------------------------
declare
fun {Not N}
    if N==1 then 0 else 1 end
end
fun {NotGate Stream}
    case Stream
    of nil then nil
    []H|T then {Not H}|{NotGate T}
    [] _ then _
    end
end

declare
fun {OrGate S1 S2}
    if S1.1==1 then 1|{OrGate S1.2 S2.2}
    elseif S2.1==1 then 1|{OrGate S1.2 S2.2}
    else 0|{OrGate S1.2 S2.2} end
end

declare
fun {AndGate S1 S2}
    if S1.1==1 then
        if S2.1==1 then 1|{AndGate S1.2 S2.2} else 0|{AndGate S1.2 S2.2}end
    else 0|{AndGate S1.2 S2.2} end
end

declare
fun {Simulate G Inputs}
    thread
        case G
        of gate(value:V X Y) then
            if V=='or' then
                {OrGate {Simulate X Inputs} {Simulate Y Inputs}}
            else
                {AndGate {Simulate X Inputs} {Simulate Y Inputs}}
            end
        [] gate(value:V X) then {NotGate {Simulate X Inputs}}
        [] input(V) then Inputs.V
        end
    end
end

declare G S
G = gate(value:'or'
        gate(value:'and'
            input(x)
            input(y)
        )
        gate(value:'not' input(z))
    )
{Browse {Simulate G S}}
S=input(x: 1|0|1|0|_ y:0|1|0|1|_ z:1|1|0|0|_)