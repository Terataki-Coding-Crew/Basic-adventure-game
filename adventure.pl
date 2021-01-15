:-[initial_state].
%consult('./initial_state.pl').


main:-
    adventure.



    /* Redefinitions */
:- op(35,xfy,is_in).
:- op(35,fx,go_to).
:- op(37,fx,take).
:- op(37,fx,put).
:- op(37,fx,leave).
:- op(37,fx,turn_on).
:- op(37,fx,turn_off).





connected_by_door(X,Y):-
    door(X,Y,_).
connected_by_door(X,Y):-
    door(Y,X,_).
connected_open(X,Y):-
    location(X,_,List),
    member(Y, List),
    fail.
connected_open(_,_).

% open_link(X,Y) if lined(X,Y) and no door


list_things(Place):-
    location_list(object(X,article(A),colour(Y),_,_), Place),
    tab(2),
    respond(['You see ',A,Y,X]),
    fail.
list_things(_).

/* list_connections(Place):-
    connected(Place, X),
    tab(2),
    write(X),
    nl,
    fail. */
list_connections(Place):-
    findall(X,(location(Place,_,List), member(X, List), \+(X = '')), L),
    print_list(L),
    nl.
% list_connections(_).

print_list([]).
print_list([H|T]):-
    write(H),
    nl,
    print_list(T).




connected(X,Y):-
    connected_by_door(X,Y).
connected(X,Y):-
    connected_open(X,Y).

look:-
    here(Place),
    write('You are '), write(Place), nl,
    write('You can see: '), nl,
    list_things(Place),
    write('You can go to: '), nl,
    list_connections(Place).

list_contents(Container):-
    is_in(X,Container),
    tab(2),
    write(X),
    nl,
    fail.
list_contents(_).

look_in(X):-
    write('Looking in the '), write(X), write(', you can see:'), nl,
    list_contents(X).

go_to(Place):-
    can_go(Place),
    move(Place),
    look.

can_go(Place):-
    here(X),
    connected_by_door(X,Place),
    door_is_open(X,Place).
can_go(Place):-
    here(X),
    connected_open(X,Place).
can_go(_):-
    write('You can''t get there from here.'),
    fail.

door_is_open(X,Y):-
    door(X,Y,open).
door_is_open(X,Y):-
    door(Y,X,open).
door_is_open(_,Place):-
    write('The door to the '), write(Place), write(' is closed.'), nl,
    fail.

open_door(Place):-
    here(X),
    \+(connected(X,Place)), % not connected
    write('There is no door to the '), write(Place), write(' from here. '), nl.
open_door(Place):-  % Two possible cases
    here(X),
    door(X,Place,closed),
    retract(door(X,Place,closed)),  % Alter state of door
    asserta(door(X,Place,open)),
    write('The door to the '), write(Place), write(' is open.'), nl.
open_door(Place):-
    here(X),
    door(Place, X, closed),
    retract(door(Place, X, closed)),
    asserta(door(Place, X, open)),
    write('The door to the '), write(Place), write('is open.'), nl.
open_door(_):-   %  Already open
    write('The door is open.'), nl.

close_door(Place):-
    here(X),
    \+(connected(X,Place)),
    write('There is no door to the '), write(Place), write(' from here. '), nl.
close_door(Place):-
    here(X),
    door(X,Place,open),
    retract(door(X,Place,open)),
    asserta(door(X,Place,closed)),
    write('The door to the '), write(Place), write(' is closed.'), nl.
close_door(Place):-
    here(X),
    door(Place, X, open),
    retract(door(Place, X, open)),
    asserta(door(Place, X, closed)),
    write('The door to the '), write(Place), write('is closed.'), nl.
close_door(_):-
    write('The door is closed.'), nl.



move(Place):-
    retract(here(_)),
    asserta(here(Place)).


/* Taking an object */
take(X):-
    can_take(X),
    take_object(X).

can_take(Object):-
    here(Place),
    is_contained_in(Object,Place).
can_take(Object):-
    write('There is no '), write(Object),
    write(' here.'), nl,
    fail.

take_object(Object):-
    retract(location(object(Object,_,_,_),_)),
    asserta(have(Object)),
    write('Taken.').


/* End taking object process */

/* Putting and leaving objects */

put(Item):-
    retract(have(Item)),
    here(Place),
    asserta(location(object(Item,_,_,_),Place)).
put(Item):-
    nl,
    write('You do not have the '),write(Item),nl,
    fail.

leave(Item):-
    put(Item).

inventory:-
    nl,
    have(Object),
    write('You have the following objects:'), nl,
    write(Object),nl,
    fail.
inventory:-
    nl,
    write('You don\'t have anything else.'),
    nl.

/* Lighting */
turn_on(_):-     %%% Generalise??
    flashlight(on),
    write('The flashlight is already on.').
turn_on(Item):-
    have(Item),
    retract(flashlight(off)),
    asserta(flashlight(on)),
    write('The flashlight is on.'), nl.
turn_on(_):-
    write('You do not have a flashlight.').     %%% Generalise??

turn_off(_):-     %%% Generalise??
    flashlight(off),
    write('The flashlight is already off.').
turn_off(Item):-
    have(Item),
    retract(flashlight(on)),
    asserta(flashlight(off)),
    write('The flashlight is off.'), nl.
turn_off(_):-
    write('You do not have a flashlight.').     %%% Generalise??

/* Recursive search*/
/* What is found in "Place"? */
is_contained_in(Item,Place):-
    location(object(Item, _, _, _),Place).
is_contained_in(Item,Place):-
    location(object(X,_,_,_),Place),
    is_contained_in(Item,X).

/* Where can "Item" be found? */
where_is(Item,Place):-
    location(object(Item,_,_,_),Place).
where_is(Item,Place):-
    location(object(Item,_,_,_),X),
    where_is(X,Place).

/* List predicates */
/* Membership predicates */
member(H,[H|_]).
member(X,[_|T]):-
    member(X,T).

/* Append predicate */
append([],X,X). % Appending X to an empty list id X.
append([H|T1],X,[H|T2]):-    % Append X to tail T1 to produce T2 and add it to H.
    append(T1,X,T2).


location(Item,Place):-     % Item is found in Place if it is a member of the Item-list of Place
    location_list(Item_list,Place),
    member(Item,Item_list).

/* Place item at or in location */
add_item(NewItem, Location, [NewItem|Item_List]):-
    location_list(Item_List,Location).

/* Write a responce */
respond([]):-
    write('\n').
respond([H|T]):-
    write(H),
    write(' '),
    respond(T).

/* LIST PREDICATES - move to new consult file */

/* Remove one instance of  element from a list - returns FALSE if not present */
remove_element(H, [H|T], T). % if element is head of list, return tail.
remove_element(Element, [H|T], [H|NewList]):- % if not head, add heat to processed tail
     remove_element(Element, T, NewList). % search tail for element and return new list with tail removed.

/*  list_length(List, Length) */
list_length([], 0).
list_length([_|T], NewLength):-
    list_length(T, L),
    NewLength is L + 1.

/* Next element in a list */
first_element([H|_], H).

next_element(H, [H|T], Next):-
     first_element(T, Next).
next_element(A, [_|T], Next):-
     next_element(A, T, Next).

/* Reverse List */
reverse_list([], List1, List1).
reverse_list([H|T], List1, List2):-
    reverse_list(T, List1, [H|List2]).

/* Last element in a list */
last_element(List, Element):-
     reverse_list(List, [H|_], []),
     Element = H.

/* Split list at element */
/*  split_at(Element, List, List1, list2). */
split_at(Elem,List,Left,Right) :-
  append(Left,[Elem|Rest],List), % Magic!!! append left list to right list (broken at elem) to produce full list
  Right = [Elem|Rest].

/* Game loop */
adventure:-
    %write('Welcome to Adventure.'),
    introduction,
    choose_options,
    nl,
    look,
    inventory,
    game_loop.

game_loop:-
    %repeat,
    read(Command),
    puzzle(Command),
    do(Command),
    nl,
    (endCond(Command); game_loop).

choose_options:-
    write('Would you like to continue your previous adventure y/n? \n'),
    read(Input),
    load_adventure(Input).
choose_options.

load_adventure(y):-
    write('loading saved adventure...').
    %restore(saved_state).
load_adventure(_).

save_adventure:-
    save(saved_state).

endCond(end):-
    write('Game over.'),
    !.
endCond(_):-
    fail.

/* do commands */
do(end).
do(inventory):-
     inventory,
     !.
do(look):-
     look,
     !.
do(peep):-
    look.


 /* Puzzles */
puzzle(_):-
    write('This is a puzzle'),
    nl.
