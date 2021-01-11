/* Redefinitions */
:- op(35,xfy,is_in).
:- op(35,fx,go_to).




:- dynamic have/1.


room(kitchen).
room(office).
room(hall).
room('dining room').
room(cellar).

:- dynamic door/3.
door(office,hall,closed).
door(kitchen,office,closed).
door(hall, 'dining room', closed).
door(kitchen, cellar, closed).
door('dining room',kitchen, closed).

:- dynamic location/2.
location_list(object(desk, article(a), colour(brown), size(large), weight(90)),office).
location_list(object(apple, article(a), colour(red), size(small), weight(1)),kitchen).
location_list(object(flashlight, article(a), colour(silver), size(small), weight(2)),desk).
location_list(object('washing machine', article(a), colour(white), size(large), weight(200)), cellar).
location_list(object(nani, article(the), colour(brown), size(small), weight(3)),'washing machine').
location_list(object(broccoli, article(some), colour(green), size(small), weight(1)),kitchen).
location_list(object(crackers, article(some), colour(biscuit-coloured), size(small), weight(1)),kitchen).
location_list(object(computer, article(a), colour(cream), size(medium), weight(10)), desk).

:- dynamic flashlight/1.
flashlight(off).

edible(apple).
edible(crackers).

tastes_yucky(broccoli).

:- dynamic here/1.
here(kitchen).


is_in(knife,desk).

connected(X,Y):-
    door(X,Y,_).
connected(X,Y):-
    door(Y,X,_).

list_things(Place):-
    location_list(object(X,article(A),colour(Y),_,_), Place),
    tab(2),
    respond(['You see ',A,Y,X]),
    fail.
list_things(_).

list_connections(Place):-
    connected(Place, X),
    tab(2),
    write(X),
    nl,
    fail.
list_connections(_).

look:-
    here(Place),
    write('You are in the '), write(Place), nl,
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
    connected(X,Place),
    door_is_open(X,Place).
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

inventory:-
    nl,
    have(Object),
    write('You have the following objects:'), nl,
    write(Object),nl,
    fail.
inventory:-
    nl,
    write('You don\'t have anything else.').

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
member(H,[H|T]).
member(X,[H|T]):-
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
    write("\n").
respond([H|T]):-
    write(H),
    write(" "),
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


