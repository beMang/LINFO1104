%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------Accumulateurs et état-------------------------------------
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

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------CALCULATRICE----------------------------------------------
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
            [] '-' then {Push Stack ~({Pop Stack}-{Pop Stack})} %Astuce de la commutativité pour éviter création de 2 variables
            [] '+' then {Push Stack {Pop Stack}+{Pop Stack}}
            [] '/' then
                local T1 T2 in
                    T2 = {Pop Stack}
                    T1 = {Pop Stack}
                    {Push Stack T1 div T2}
                end
            else {Push Stack X}
            end
        end
        {Pop Stack}
    end
end
{Browse {Eval [13 45 '+' 89 17 '-' '*']}} % affiche 4176 = (13+45)*(89-17)
{Browse {Eval [13 45 '+' 89 '*' 17 '-']}} % affiche 5145 = ((13+45)*89)-17
{Browse {Eval [13 45 89 17 '-' '+' '*']}} % affiche 1521 = 13*(45+(89-17))
{Browse {Eval [120 10 '/']}}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------ENCAPSULATION---------------------------------------------
declare
fun {NewStack}
    S = {NewCell nil}
    fun {IsEmpty} @S==nil end
    proc {Push X} S:=X|@S end
    fun {Pop} %Surement moyen de faire + simple
        if {IsEmpty} then nil
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
    in
        stack(isEmpty:IsEmpty push:Push pop:Pop)
end
Stack1={NewStack} % pile 1
Stack2={NewStack} % pile 2
{Browse {Stack1.isEmpty}} % affiche true; la pile 1 est vide
{Stack1.push 13} % empile 13 sur la pile 1
{Browse {Stack1.isEmpty}} % affiche false; la pile 1 n'est pas vide
{Browse {Stack2.isEmpty}} % affiche true; la pile 2 est toujours vide
{Stack1.push 45} % empile 45 sur la pile 1
{Stack2.push {Stack1.pop}} % enlève 45 de la pile 1 et l'empile sur la pile 2
{Browse {Stack2.isEmpty}} % affiche false; la pile 2 n'est pas vide
{Browse {Stack1.pop}} % enlève 13 de la pile 1 et l'affiche
%Autre manière de fair l'encapsulation de données : utiliser les fonctions Wrap et Unwrap

%Il faut adapter Eval :
fun {Eval L}
    local Stack in
        Stack = {NewStack}
        for X in L do
            case X of '*' then {Stack.push {Stack.pop}*{Stack.pop}}
            [] '-' then {Stack.push ~({Stack.pop}-{Stack.pop})} %Astuce de la commutativité pour éviter création de 2 variables
            [] '+' then {Stack.push {Stack.pop}+{Stack.pop}}
            [] '/' then
                local T1 T2 in
                    T2 = {Stack.pop}
                    T1 = {Stack.pop}
                    {Stack.push T1 div T2}
                end
            else {Stack.push X}
            end
        end
        {Stack.pop}
    end
end
%On a bien les mêmes résultats :
{Browse {Eval [13 45 '+' 89 17 '-' '*']}} % affiche 4176 = (13+45)*(89-17)
{Browse {Eval [13 45 '+' 89 '*' 17 '-']}} % affiche 5145 = ((13+45)*89)-17
{Browse {Eval [13 45 89 17 '-' '+' '*']}} % affiche 1521 = 13*(45+(89-17))
{Browse {Eval [120 10 '/']}}


%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------SHUFFLE_LIST----------------------------------------------
declare
fun {Random N} % renvoie un nombre aleatoire entre 1 et N
    {OS.rand} mod N + 1 
end
fun {ListToArrayHelper L Acc I}
    case L 
    of nil then Acc
    [] H|T then
        Acc.I:=H 
        {ListToArrayHelper T Acc I+1}
    end
end
fun {ListToArray L}
    {ListToArrayHelper L {NewArray 1 {Length L} 0} 1}
end
fun {ShuffleHelper Array I Acc}
    if I ==0 then Acc
    else
        local R Temp in
            R = {Random I}
            Temp = Array.R
            Array.R:=Array.I
            {ShuffleHelper Array I-1 {Append Acc [Temp]}}
        end
    end
end
fun {Shuffle L}
    {ShuffleHelper {ListToArray L} {Length L} nil}
end
{Browse {Shuffle [a b c d e]}} % peut afficher [d c a b e]
{Browse {Shuffle [a b c d e]}}
{Browse {Shuffle [a b c d e]}}

%Tentative en déclaratif, c'est fonctionnel mais un peu moche car on repioche les indices déjà utilisé.
declare
fun {Random N} % renvoie un nombre aleatoire entre 1 et N
    {OS.rand} mod N + 1 
end
fun {ShuffleHelper L Added Acc}
    if {Length Added}=={Length L} then Acc
    else
        local R Temp in
            R = {Random {Length L}}
            if {Member R Added} then
                {ShuffleHelper L Added Acc}
            else
                {ShuffleHelper L {Append Added [R]} {Append Acc [{Nth L R}]}}
            end
        end
    end
end
fun {Shuffle L}
    {ShuffleHelper L nil nil}
end
{Browse {Shuffle [a b c d e]}} % peut afficher [d c a b e]
{Browse {Shuffle [a b c d e]}}
{Browse {Shuffle [a b c d e]}}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------CELLULE_ET_LISTE------------------------------------------
declare 
L1={NewCell 0}|{NewCell 1}|{NewCell 2}|nil %L1 est une liste de cellule 
L2=0|{NewCell 1|{NewCell 2|{NewCell nil}}} %L2 n'est pas une liste car il n'y a pas de nil à la fin, L3 en est une :
L3 = 0|{NewCell 1|{NewCell 2|{NewCell nil}}}|nil

%Tests :
{Browse {IsList L1}}
{Browse {IsList L2}}
{Browse {IsList L3}}

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------POO_EXEMPLE-----------------------------------------------
declare
class Counter %Implémente un compteur
    attr value %Son attribut, qui va être une cellule
    meth init % (re)initialise le compteur
        value:=0
    end

    meth inc % incremente le compteur
        value:=@value+1
    end

    meth get(X) % renvoie la valeur courante du compteur dans X
        X=@value
    end
end
MonCompteur={New Counter init}
for X in [65 81 92 34 70] do {MonCompteur inc} end
{Browse {MonCompteur get($)}} % affiche 5


%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------COLLECTIONS-----------------------------------------------
declare
class Collection
    attr elements
    meth init % initialise la collection
        elements:=nil
    end

    meth put(X) % insere X
        elements:=X|@elements
    end
    
    meth get($) % extrait un element et le supprime (à la manière d'une stack)
        case @elements of X|Xr then elements:=Xr X
        else {Exception.error "Empty list"} %Renvoie une exception
        end
    end
    
    meth isEmpty($) % renvoie true ssi la collection est vide
        @elements==nil
    end

    meth union(C2)
        if {C2 isEmpty($)}==false then
            {self put({C2 get($)})}
            {self union(C2)}
        end
    end

    meth print
        {Browse @elements}
    end
end

%Test :
C1 = {New Collection init}
C2 = {New Collection init}
{C1 put(5)}
{C1 put(6)}
{C2 put(9)}
{C2 put(10)}
{C1 union(C2)} %Complexité : O(n) où n est la taille de C2
{C1 print}
{C2 print}

%Collection triée :
declare
fun {RemoveOne L I Acc} %Retire à la liste L le premier élément I
    case L
    of nil then Acc
    [] H|T then
        if H==I then
            {Append Acc T}
        else
            {RemoveOne T I {Append Acc [H]}}
        end
    end
end
class SortedCollection from Collection
    meth get($) % extrait un element et le supprime (à la manière d'une stack)
        if {self isEmpty($)} then {Exception.error "Empty list"}
        else
            local Min in
                Min = {FoldL @elements fun{$ X Y} if Y<X then Y else X end end @elements.1}
                elements:={RemoveOne @elements Min nil}
                Min
            end
        end
    end
end

%Test collection triée (Trie dans l'ordre décroissant car fonctionne comme une stack)
declare
C1 = {New SortedCollection init}
C2 = {New SortedCollection init}
{C1 put(5)}
{C1 put(6)}
{C2 put(9)}
{C2 put(10)}
{C2 put(2)}
{C1 union(C2)} %Complexité : O(n^2) où n est la taille de C2
{C1 print}
{C2 print}

declare
%Le code est pas ouf il doit y avoir + simple
fun {ToSortedCollection Coll Acc}
    if {Coll isEmpty($)} then Acc
    else
        {Acc put({Coll get($)})}
        {ToSortedCollection Coll Acc}
    end
end
fun {SortCollection Coll} %Complexité : O(n^2)
    local Sorted Result in
        Sorted = {ToSortedCollection Coll {New SortedCollection init}}
        Result = {New Collection init}
        {Result union(Sorted)}
        Result
    end
end
NoSorted = {New Collection init}
{NoSorted put(500)}
{NoSorted put(6)}
{NoSorted put(625)}
{NoSorted put(420)}
{NoSorted put(314)}
{NoSorted print}
Sorted = {SortCollection NoSorted}
{Sorted print}


%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------EVALUATION_EXPRESSION-------------------------------------

declare
class Variable
    attr var 
    meth init(X)
        {self set(X)}
    end

    meth evalue($)
        @var
    end

    meth derive(Var $) %Renvoie une nouvelle expression !
        if Var==self then {New Constante init(1)} else {New Constante init(0)} end
    end

    meth set(X)
        var:=X
    end
end

class Puissance
    attr base puissance
    meth init(Base Puissance)
        base:=Base
        puissance:=Puissance
    end

    meth evalue($)
        {Pow {@base evalue($)} @puissance}
    end

    meth derive(Var $)
        local P1 Puiss in
            Puiss = {New Puissance init(@base @puissance-1)}
            P1 = {New Produit init({New Constante init(@puissance)} Puiss)}
            {New Produit init(P1 {@base derive(Var $)})}
        end
    end
end

class Constante
    attr cst
    meth init(Cst)
        cst:=Cst
    end

    meth evalue($)
        @cst
    end

    meth derive(Var $)
        {New Constante init(0)}
    end
end

class Somme
    attr t1 t2
    meth init(T1 T2)
        t1:=T1
        t2:=T2
    end

    meth evalue($)
        {@t1 evalue($)}+{@t2 evalue($)}
    end

    meth derive(Var $)
        {New Somme init({@t1 derive(Var $)} {@t2 derive(Var $)})}
    end
end

class Difference
    attr t1 t2
    meth init(T1 T2)
        t1:=T1
        t2:=T2
    end

    meth evalue($)
        {@t1 evalue($)}-{@t2 evalue($)}
    end

    meth derive(Var $)
        {New Difference init({@t1 derive(Var $)} {@t2 derive(Var $)})}
    end
end

class Produit
    attr t1 t2
    meth init(T1 T2)
        t1:=T1
        t2:=T2
    end

    meth evalue($)
        {@t1 evalue($)}*{@t2 evalue($)}
    end

    meth derive(Var $)
        local P1 P2 in
            P1 = {New Produit init({@t1 derive(Var $)} @t2)}
            P2 = {New Produit init(@t1 {@t2 derive(Var $)})}
            {New Somme init(P1 P2)}
        end
    end
end

declare
VarX={New Variable init(2)}
VarY={New Variable init(3)}
local
    ExprX2={New Puissance init(VarX 2)}
    Expr3={New Constante init(3)}
    Expr3X2={New Produit init(Expr3 ExprX2)}
    ExprXY={New Produit init(VarX VarY)}
    Expr3X2mXY={New Difference init(Expr3X2 ExprXY)}
    ExprY3={New Puissance init(VarY 3)}
in
    Formule={New Somme init(Expr3X2mXY ExprY3)}
    {VarX set(7)}
    {VarY set(23)}
    {Browse {Formule evalue($)}} % affiche 12153
    {VarX set(5)}
    {VarY set(8)}
    {Browse {Formule evalue($)}} % affiche 547

    %Pour la dérivée : 
    Derivee={Formule derive(VarX $)} % represente 6x - y
    {VarX set(7)}
    {VarY set(23)}
    {Browse {Derivee evalue($)}} % affiche 19
end

%Autre test :
declare
X = {New Variable init(5)}
X2 = {New Puissance init(X 2)}
X2M1 = {New Difference init(X2 {New Constante init(2)})}
Total = {New Puissance init(X2M1 3)}
Deriv = {Total derive(X $)}
{Browse {Deriv evalue($)}} %Ca marche :)


%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

%-----------------SEQUENCE_AND_PALYNDROME-----------------------------------

declare
class Sequence
    attr size lst 
    meth init
        size:=0
        lst:=nil
    end

    meth isEmpty($)
        @size==0
    end

    meth first($)
        @lst.1
    end

    meth last($)
        if {self isEmpty($)} then nil else {List.last @lst}end
    end
    
    meth insertFirst(X)
        lst:={Append [X] @lst}
        size:=@size+1
    end

    meth insertLast(X)
        lst:={Append @lst [X]}
        size:=@size+1
    end

    meth removeFirst
        if {self isEmpty($)}==false then
            lst:={List.drop @lst 1}
            size:=@size-1
        end
    end

    meth removeLast
        if {self isEmpty($)}==false then
            lst:={List.take @lst @size-1}
            size:=@size-1
        end
    end
end
fun {Palindrome Xs}
    S={New Sequence init}
    fun {Check}
    if {S isEmpty($)} then true
    else
        if {S last($)}=={S first($)} then
            {S removeLast}
            {S removeFirst}
            {Check}
        else
            false
        end
    end
    end
    in
    for C in Xs do
        {S insertLast(C)}
    end
    {Check}
end

%Test, seems to work
declare
W1 = "radar"
W2 = "ici"
W3 = "icir"
W4 = "eluparcettecrapule"
{Browse {Palindrome W1}}
{Browse {Palindrome W2}}
{Browse {Palindrome W3}}
{Browse {Palindrome W4}}