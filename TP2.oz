%-----------------------------------INTRO LISTE--------------------------
declare
L1 = a | nil
L2 = a | (b | (c | nil)) | d | nil
L3 = proc {$} {Browse oui} end | proc {$}{Browse non} end | nil
L4 = est | une | liste | nil
L5 = (a | p | nil) | nil

New = ceci | L4
{Browse New}

{L3.1}
{Browse L2.2}

declare 
fun {Head L}
    L.1
end
fun {Tail L}
    L.2
end

{Browse {Head [a b c]}} % affiche a
{Browse {Tail [a b c]}} % affiche [b c]

%Writing list
{Browse [[1 2 3] [4 5 6]]}
{Browse (1|2|3|nil)|(4|5|6|nil)|nil}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------------------------LENGTH----------------------------------
declare 
fun {LengthHelper L S}
    if L==nil then
        S
    else
        {LengthHelper L.2 S+1}
    end
end
fun {Length L}
    {LengthHelper L 0}
end

%Invariant : S
{Browse {Length [r a p h]}} % affiche 4
{Browse {Length [[b o r] i s]}} % affiche 3
{Browse {Length [[l u i s]]}} % affiche 1

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------------------------APPEND----------------------------------
declare
fun {Append L1 L2}
    if L1==nil then L2 else 
        if L1.2 \= nil then
            L1.1 | {Append L1.2 L2}
        else L1.1 | L2
        end
    end
end

{Browse {Append [r a] [p h]}} % affiche [r a p h]
{Browse {Append [b [o r]] [i s]}} % affiche [b [o r] i s]
{Browse {Append nil [l u i s]}} % affiche [l u i s]

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------------------------PATTERN_MATCHING------------------------
declare 
proc {F1 L}
    case L
    of nil then {Browse empty}
    [] H|T then {Browse nonEmpty}
    else {Browse other}
    end
end
fun {Head L}
    case L
    of H|T then H
    else erreur
    end
end
fun {Tail L}
    case L
    of H|T then T
    else erreur
    end
end
fun {Lenght L S}
    case L
    of H|T then {Lenght T S+1}
    [] nil then S
    end
end
fun {Append L1 L2}
    case L1
    of H|T then H | {Append T L2}
    [] nil then L2
    else L1.1 | L2
    end
end

{Browse {Append [test test2 test3] [oz donne des erreurs pas ouf]}}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------------------------SUB_SEQUENCE----------------------------
declare 
fun {Take L N}
    if N==0 then
        nil
    else
        if L == nil then L 
        else
            L.1 | {Take L.2 N-1}
        end
    end
end
fun {Drop L N}
    if N==0 then
        L 
    else
        if L==nil then
            L
        else
            {Drop L.2 N-1}
        end
    end
end

{Browse {Take [r a p h] 2}} % affiche [r a]
{Browse {Take [r a p h] 7}} % affiche [r a p h]
{Browse {Take [r [a p] h] 2}} % quel est le resultat?

{Browse {Drop [r a p h] 2}} % affiche [p h]
{Browse {Drop [r a p h] 7}} % affiche nil
{Browse {Drop [r [a p] h] 2}} % quel est le resultat?

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------------------------MULTIPLICATION--------------------------
declare 
fun {MultHelper L Acc}
    case L
    of H|T then {MultHelper T H*Acc}
    else Acc
    end
end
fun {MultList L}
    {MultHelper L 1}
end

{Browse {MultList [1 2 3 4 5]}} % affiche 120


%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------------------------ECRITURE_LISTE--------------------------

%Example :
declare
{Browse [5 6 7 8]}
{Browse 5|[6 7 8]}
{Browse 5|6|7|8|nil}
A=5
B=[6 7 8]
{Browse A|B}

%Exo :
declare
L1 = [[1 2 3] [4 5 6]]
L2 = (1|2|3|nil)|(4|5|6|nil)|nil
{Browse L1}
{Browse L2}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------------------------OCCURENCE_SUB_LIST----------------------

declare
fun {Prefix L1 L2}
    case L2
    of nil then false
    else
        case L1
        of nil then true
        [] H|T then
            if H==L2.1 then {Prefix T L2.2} else false end
        end
    end
end
fun {FindStringHelper Searched Lst Acc Index}
    case Lst
    of nil then Acc
    [] H|T then
        if {Prefix Searched Lst} then
            {FindStringHelper Searched T {List.append Acc Index|nil} Index+1}
        else
            {FindStringHelper Searched T Acc Index+1}
        end
    end
end
fun {FindString Searched Lst}
    {FindStringHelper Searched Lst nil 1}
end
{Browse {Prefix [1 2 1] [1 2 3 4]}} % affiche false
{Browse {Prefix [1 2 3] [1 2 3 4]}} % affiche true
{Browse {Prefix "del" "delhaize"}} %True
{Browse {Prefix "dil" "delhaize"}} %False

{Browse {FindString [a b a b] [a b a b a b]}} % affiche [1 3]
{Browse {FindString [a] [a b a b a b]}} % affiche [1 3 5]
{Browse {FindString [c] [a b a b a b]}} % affiche nil


%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------------------------RECORDS---------------------------------

declare
Carte = carte(
        menu(entree: 'salade verte aux lardons' plat: 'steak frites' prix: 10)
        menu(entree: 'salade de crevettes grises' plat: 'saumon fume et pommes de terre' prix: 12)
        menu(plat: 'choucroute garnie' prix: 9)
    )
%2ème menu : "salade de crevettes grise"
%Entrée second menu : salade de crevettes grises, plat second menue : saumon fume et pommes de terre. Type de entrée et plats : String
%Type second menu : records
%Fonction pour savoir combien ça paie :
fun {HowMuchPay N1 N2 N3}
    Carte.1.prix*N1 + Carte.2.prix*N2 + Carte.3.prix*N3
end
{Browse {HowMuchPay 1 1 1}} %Affiche 31
{Browse {HowMuchPay 1 1 2}} %Affiche 40
%Arité carte :
%Arité menu : 3 - 3 - 2


%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------------------------PROMENADE_ARBORICOLE (TREE)-------------
declare
fun {PromenadeHelper Tree Acc}
    case Tree
    of empty then 
        Acc
    else
        {PromenadeHelper Tree.right {PromenadeHelper Tree.left {List.append Acc Tree.1|nil}}}
    end
end
fun {Promenade Tree}
    {PromenadeHelper Tree nil}
end
fun {Sum X Y}
    X+Y
end
fun {SumList L}
    {List.foldL L Sum 0}
end
fun {SumTree T}
    {SumList {Promenade T}}
end
%Somme d'un arbre mais sans foldL
fun {SumAuxTreeHelper Tree Acc}
    case Tree
    of empty then 
        Acc
    else
        {SumAuxTreeHelper Tree.right {SumAuxTreeHelper Tree.left Tree.1+Acc}}
    end
end
fun {SumAuxTree Tree}
    {SumAuxTreeHelper Tree 0}
end

MyTree =btree(42
            left: btree(26
                left: btree(54
                    left: empty
                    right: btree(18 left: empty right: empty)
                )
                right: empty
            )
            right: btree(37
                left: btree(11 left: empty right: empty)
                right: empty
            )
        )
{Browse {Promenade MyTree}} % affiche [42 26 54 18 37 11]
{Browse {SumTree MyTree}} % affiche 42+26+54+18+37+11=188
{Browse {SumAuxTree MyTree}} % affiche aussi 188


%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------------------------DICTIONNAIRE----------------------------
declare
fun {DictionaryFilterHelper D F Acc}
    case D
    of leaf then %Si vide
        Acc
    else
        if {F D.info} then
            {DictionaryFilterHelper D.right F {DictionaryFilterHelper D.left F {List.append Acc [D.key#D.info]}}}
        else
            {DictionaryFilterHelper D.right F {DictionaryFilterHelper D.left F Acc}}
        end
    end
end
fun {DictionaryFilter D F}
    {DictionaryFilterHelper D F nil}
end
Class = dict(key:10
    info:person('Christian' 19)
    left:dict(key:7
        info:person('Denys' 25)
        left:leaf
        right:dict(key:9 info:person('David' 7) left:leaf right:leaf)
    )
    right:dict(key:18
        info:person('Rose' 12)
        left:dict(key:14 info:person('Ann' 27) left:leaf right:leaf )
        right:leaf
    )
)
fun {Old Info}
    Info.2 > 20
end
Val = {DictionaryFilter Class Old} % Val --> [7#person('Denys' 25) 14#person('Ann' 27)]
{Browse Val}


%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------------------------LIST_TUPLE_AND_RECORDS------------------
declare
T1 = example
T2 = example2
X1 = '|'(a b)  %Tuple
{Browse {IsTuple X1}}

X2 = '|'(a '|'(b nil)) %List
{Browse {IsList X2}}

X3 = '|'(2:nil a) %It's a list !
{Browse {IsList X3}}
{Browse X3==[a]} %X3 is in fact [a]

X4 = state(1 a 2)  %Tuple
{Browse {IsTuple X4}}

X5 = state(1 3:2 2:a)  %Tuple
{Browse {IsTuple X5}}

X6 = tree(v:a T1 T2) %Record
{Browse {IsTuple X6}==false}
{Browse {IsList X6}==false}

X7 = a#b#c %Shorter syntax for tuple
{Browse {IsTuple X7}}

X8 = [a b c] %List (but also a tuple, because every list is a tuple)
{Browse {IsList X8}}
{Browse {IsTuple X8}}

X9 = m|n|o %Tuple (not a list cause nil is missing)
{Browse {IsTuple X9}}


%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------------------------APPLIQUE/MAP----------------------------
declare
fun {AppliqueHelper L F Acc}
    case L
    of nil then Acc
    [] H|T then
        {AppliqueHelper T F {List.append Acc {F H}|nil}}
    end
end
fun {Applique L F}
    {AppliqueHelper L F nil}
end
fun {Lol X} lol(X) end
{Browse {Applique [1 2 3] Lol}} % Affiche [lol(1) lol(2) lol(3)]

%MakeAdder (créateur de fonction)
fun {MakeAdder N}
    fun {$ X}
        X+N
    end
end
fun {AddAll L N}
    {Applique L {MakeAdder N}}
end

Add5 = {MakeAdder 5}
{Browse {Add5 13}} % Affiche 18
L = [1 2 3 4]
{Browse {AddAll L 4}}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------------------------STRANGE_TUPLE---------------------------

{Browse {Label a#b#c}} % #car c'est le nom donné au tuple quand on utilise le raccourci #
{Browse {Width un#tres#long#tuple#tres#tres#long}} %7 car 7 éléments
{Browse {Arity 1#4#16}} % [1 2 3] car Arity renvoie les noms des éléments du record
