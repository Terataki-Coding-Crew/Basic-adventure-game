/* Beginning state of adventure */

 
introduction:-
    write('Welcome to the adventure').

room(kitchen).
room(office).

:- dynamic here/1.
here('By the gates').


:- dynamic is_in/1
is_in(knife,desk).

:- dynamic have/1.


:- dynamic flashlight/1.
flashlight(off).


/* location(NAME,ID,DESCRIPTION,LINKS[N,E,S,W]) */
location('By the gates', '', ['','','On the drive','']).
location('On the drive', '', ['By the gates','','','']).
location('On a forest path'), '', ['','','','']).


:- dynamic door/3.
door(office,hall,closed).
door(kitchen,office,closed).
door(hall, 'dining room', closed).
door(kitchen, cellar, closed).
door('dining room',kitchen, closed).
door('By the gates', 'On the drive', open).

:- dynamic location_list/2.
location_list(object(desk, article(a), colour(brown), size(large), weight(90)),office).
location_list(object(apple, article(a), colour(red), size(small), weight(1)),kitchen).
location_list(object(flashlight, article(a), colour(silver), size(small), weight(2)),desk).
location_list(object('washing machine', article(a), colour(white), size(large), weight(200)), cellar).
location_list(object(moosies, article(the), colour(black), size(small), weight(10)),'dog basket').
location_list(object(broccoli, article(some), colour(green), size(small), weight(1)),kitchen).
location_list(object(crackers, article(some), colour(biscuit-coloured), size(small), weight(1)),kitchen).
location_list(object(computer, article(a), colour(cream), size(medium), weight(10)), desk).
