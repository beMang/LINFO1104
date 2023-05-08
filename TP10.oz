%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------PORTS-----------------------------------------------------

declare
P S
{NewPort S P}
{Send P foo}
{Send P bar}

proc {DisplayPort S}
    thread
        case S
        of nil then skip
        []H|T then
            {Browse H}
            {Wait T}
            {DisplayPort T}
        end
    end
end

{DisplayPort S}
{Send P test}

{Browse S} % S : foo|bar|_future

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------CALCULETTES_CONCURRENTES----------------------------------

declare A B N S Res1 Res2 Res3 Res4 Res5 Res6

proc {HandlePort S}
    case S
    of H|T then
        case H
            of add(X Y R) then R=X+Y
            [] pow(E B R) then R={Number.pow B E}
            [] 'div'(X Y R) then if Y\=0 then R=X div Y else R=0 end
            else {Browse 'je ne comprends pas ton message'}
        end
        {HandlePort T}
    end
end

fun {LaunchServer}
    P S
in
    {NewPort S P}
    thread
        {HandlePort S}
    end
    P
end

S = {LaunchServer}
{Send S add(321 345 Res1)}
{Browse Res1}

{Send S pow(2 N Res2)}
N = 8

{Browse Res2}
{Send S add(A B Res3)}
{Send S add(10 20 Res4)}
{Send S foo}

{Browse Res4}
A = 3
B = 0-A
{Send S 'div'(90 Res3 Res5)}
{Send S 'div'(90 Res4 Res6)}
{Browse Res3}
{Browse Res5}
{Browse Res6}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------CHARLOTTE_ET_COMPTAGE_DE_BIERES---------------------------

declare
fun {StudentRMI} %J'ai fait que pour cette version là de l'étudiant
    S 
in
    thread
        for ask(howmany:Beers) in S do
            Beers={OS.rand} mod 24
        end
    end
    {NewPort S}
end

%Créer une liste d'étudiant
fun {CreateUniversity Size}
    fun {CreateLoop I}
        if I =< Size then
        {StudentRMI}|{CreateLoop I+1}
        else nil end
    end
in
    {CreateLoop 1}
end

proc {CharlotteCounterHelper L Acc P}
    Result
in
    case L
    of nil then {Send P nil}
    [] H|T then
        {Send H ask(howmany:Result)}
        {Send P Acc+Result}
        {CharlotteCounterHelper T Acc+Result P}
    end
end
fun {CharlotteCounter L} %Renvoie une liste avec avec le nombre de bière bue après interrogation de chaque étudiant
    S
    Port = {NewPort S}
in
    {CharlotteCounterHelper L 0 Port}
    S
end

N = 50
Result = {CharlotteCounter {CreateUniversity N}}
{Browse {List.last Result}} %Pour avoir le nombre de bière consommée
{Browse {List.last Result} div N} %Moyenne
%On peut récupérer le max de Result pour connaitre le plus gros buveur mais flemme, le principe est là

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------PORT_OBJECT-----------------------------------------------

declare
R1 R2 R3
fun {NewPortObject Behaviour Init}
    proc {MsgLoop S1 State}
        case S1 
        of Msg|S2 then {MsgLoop S2 {Behaviour Msg State}}
        [] nil then skip
        end
    end
    Sin
in
    thread {MsgLoop Sin Init} end
    {NewPort Sin}
end

fun {Portier Message State}
    case Message
    of getIn(N) then State+N
    [] getOut(N) then State-N
    [] getCount(N) then N=State N
    else State
    end
end

%Test
PO = {NewPortObject Portier 0}
{Send PO getIn(5)}
{Send PO getCount(R1)}

{Browse R1}

{Send PO getOut(3)}
{Send PO getCount(R2)}
{Browse R2}

{Send PO getIn(10000)}
{Send PO getCount(R3)}
{Browse R3}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------STACK-----------------------------------------------------
declare
fun {NewPortObject Behaviour Init}
    proc {MsgLoop S1 State}
        case S1 
        of Msg|S2 then {MsgLoop S2 {Behaviour Msg State}}
        [] nil then skip
        end
    end
    Sin
in
    thread {MsgLoop Sin Init} end
    {NewPort Sin}
end

fun {StackBehaviour Msg State}
    case Msg
        of push(X) then X|State
        [] pop(R) then
            case State
            of nil then nil
            [] H|T then R=H T
            end
        [] isEmpty(R) then
            case State of nil then R=true else R=false end
            State
        else {Browse 'pas compris'} state
    end
end

proc {Push S X}
    {Send S push(X)}
end
fun {Pop S}
    R
in
    {Send S pop(R)}
    R
end
fun {IsEmpty S}
    R
in
    {Send S isEmpty(R)}
    R
end

PO = {NewPortObject StackBehaviour nil}
{Browse {IsEmpty PO}}
{Push PO 55}
{Browse {IsEmpty PO}}
{Push PO 43}
{Browse {Pop PO}}

{Browse {Pop PO}}
{Browse {IsEmpty PO}}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------FILE_CONCURRENTE------------------------------------------

declare
fun {NewPortObject Behaviour Init}
    proc {MsgLoop S1 State}
        case S1 
        of Msg|S2 then {MsgLoop S2 {Behaviour Msg State}}
        [] nil then skip
        end
    end
    Sin
in
    thread {MsgLoop Sin Init} end
    {NewPort Sin}
end

fun {QueueBehaviour Msg State}
    case Msg
        of enqueue(X) then X|State
        [] dequeue(R) then
            case State
            of nil then nil
            [] H|T then
                R = {List.last State}
                {List.take State {Length State}-1}
            end
        [] isEmpty(R) then
            case State of nil then R=true else R=false end
            State
        else {Browse 'pas compris'} state
    end
end

proc {Enqueue Q X}
    {Send Q enqueue(X)}
end
fun {Dequeue Q}
    R
in
    {Send Q dequeue(R)}
    R
end
fun {IsEmpty Q}
    R
in
    {Send Q isEmpty(R)}
    R
end

PO = {NewPortObject QueueBehaviour nil}
{Browse {IsEmpty PO}}
{Enqueue PO 55}
{Browse {IsEmpty PO}}
{Enqueue PO 43}
{Browse {Dequeue PO}}

{Browse {Dequeue PO}}
{Browse {IsEmpty PO}}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------TRACKING_INFO_WITH_PORT-----------------------------------


declare

fun {GetList NewElement Acc} %Refaire getList, c'est pas correct pour l'instant
    case Acc
    of _ then [NewElement#1]
    [] H|T then
        if NewElement==H.1 then
            NewElement#H.2+1|T
        else 
            H|{GetList NewElement T}
        end
    end
end
fun {CounterBehaviour Element State OutPort}
    NewState = {GetList Element State}
in
    {Browse State}
    {Send OutPort NewState}
    NewState
end
fun {Counter Output}
    Input
    Pout = {NewPort Output}
    Pin = {NewPort Input}
    proc {MsgLoop Input State}
        case Input 
        of H|T then {MsgLoop T {CounterBehaviour H State Pout}}
        [] nil then skip
        end
    end
in
    thread {MsgLoop Input _} end
    Pin
end

local Output Input in
    Input = {Counter Output}
    {Send Input a}
    {Send Input b}
    {Browse Output}
end