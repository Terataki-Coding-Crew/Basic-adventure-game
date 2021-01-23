/* Beginning state of adventure */

 
introduction:-
    write('Welcome to the adventure \n\n').

room(kitchen).
room(office).

:- dynamic here/1.
here('by the gates').


:- dynamic is_in/1.
is_in(knife,desk).

:- dynamic have/1.


:- dynamic flashlight/1.
flashlight(off).


/* location(NAME,ID,DESCRIPTION,LINKS[N,E,S,W,U,D])*/
/* location/4 */
location('by the gates',
         'gates',
         'by the gates to a large, old house. Beyond the gates there is an overgrown drive curving up to the house.',
         ['','','the drive','','','']).
location('the drive',
         'drive',
         'on an overgrown gravel drive, curving smoothly to your left. At the end of the drive there is an old, three-storey house. ',
         ['by the gates','','','','','']).
location('on a forest path',
         'forest1',
         '',
         ['','','','','','']).
location('in the kitchen',
         'kitchen',
         '',
         ['','','','','','']).
location('in an office','office','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).
location('','','','',['','','','','','']).


:- dynamic door/3.
% There is a door between two locations
door(office,hall,closed).
door(kitchen,office,closed).
door(hall, 'dining room', closed).
door(kitchen, cellar, closed).
door('dining room',kitchen, closed).
door(gates, drive1, open).

:- dynamic location_list/2. %Where objects are found and what is at each location. - add descriptions
location_list(object(desk, description('a large wooden desk with two drawers, one of which is locked'), weight(90)),office).
location_list(object(apple,  description('a red apple on the table'), weight(1)),kitchen).
location_list(object(flashlight, description('a torch lying on the desk'), weight(2)),desk).
location_list(object('washing machine', description('an old washing machine that has seen better days'), weight(200)), cellar).
location_list(object(moosies, description('a medium-sized black dog with a silly grin'), weight(10)),'dog basket').
location_list(object(broccoli, description('a sprig of broccoli'), weight(1)),kitchen).
location_list(object(crackers, description('a packet of crackers, recently opened'), weight(1)),kitchen).
location_list(object(computer, description('an old Commodore Amiga computer'), weight(10)), desk).
