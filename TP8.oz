%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------Threades et concurrence-----------------------------------

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
