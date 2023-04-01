#charset "us-ascii"
#include "adv3.h"
#include "en_us.h"

//-----------------//
//  Jack n Jill's  //
//-----------------//

// define the '+' property
// (we need this only once per source file)
+ property location;

jjEntrance : Room
    name = 'Apartment Entrance'
    destName = 'the apartment entrance'
    jjName = 'Jack and Jill\'s Apartment'
    jjDestName = 'Jack and Jill\'s apartment'
    desc = ""
    east = jjFrontDoorToHallway
    west = jjBathroom
    south = jjKitchen
    north = jjBedroom
    northwest = jjLounge
;

+ jjFrontDoorToHallway : Door
    vocabWords = 'front east eastern e door/east/e/out/exit'
    name = 'apartment front door'
    jjName = 'door to Jack and Jill\'s'
    desc = ""
    initiallyOpen = true
    initiallyLocked = nil
;

jjBathroom : Room
    name = 'Bathroom'
    destName = 'the bathroom'
    jjName = 'Jack and Jill\'s Bathroom'
    jjDestName = 'Jack and Jill\'s bathroom'
    desc = ""
    east = jjEntrance
;

jjLounge : Room
    name = 'Lounge'
    destName = 'the lounge'
    jjName = 'Jack and Jill\'s Lounge room'
    jjDestName = 'Jack and Jill\'s lounge room'
    desc = ""
    southeast = jjEntrance
;

jjBedroom : Room
    name = 'Bedroom'
    destName = 'the bedroom'
    jjName = 'Jack and Jill\'s Bedroom'
    jjDestName = 'Jack and Jill\'s bedroom'
    desc = ""
    south = jjEntrance
;

jjKitchen : Room
    name = 'Kitchen'
    destName = 'the kitchen'
    jjName = 'Jack and Jill\'s Kitchen'
    jjDestName = 'Jack and Jill\'s kitchen'
    desc = ""
    north = jjEntrance
;
