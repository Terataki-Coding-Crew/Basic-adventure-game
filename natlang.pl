/* Natural language engine.*/

consult(vocab).

/* difference lists */

sentence(S):-
    nounphrase(S-S1),
    verbphrase(S1-[]).

nounphrase(N-X):-
    determiner(N-S1),
    nounexpression(S1-X).
nounphrase(N-X):-
    nounexpression(N-X).

nounexpression(E-X):-
    noun(E-X).
nounexpression(E-X):-
    adjective(E-S1),
    nounexpression(S1-X).

verbphrase(V-X):-
    verb(V-S1),
    nounphrase(S1-X).




