#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//--------------------//
//  The Ravers' Room  //
//--------------------//

raverLounge : Room
    name = 'Lounge room'
    north = raverLoungeToHallway
    out asExit(north)
    south = raverKitchen
    east = raverBedroom
;

+raverLoungeToHallway : Door -> secondHallwayToRaverDoor
    vocabWords = 'north door/doorway/way'
    name = 'door'
    desc = "NOT IMPLEMENTED YET."
;

+ Surface
    vocabWords = 'coffee table'
    name = 'coffee table'
    desc = "NOT IMPLEMENTED YET."
    sightSize = large
;

// YOU WILL NEED A NEW VERB TO GET UNDER THE TABLE (IF WE ARE DOING THIS PUZZLE)
++ NominalPlatform
    name = 'table'
    actorInPrep = 'under'
;

+ Bed
    vocabWords = 'lounge/sofa/couch'
    name = 'couch'
    desc = "NOT IMPLEMENTED YET."
    sightSize = large
;


// We connect the kitchen and the lounge via a distance connector
DistanceConnector [raverLounge, raverKitchen];

raverKitchen : Room
    name = 'Kitchen'
    desc = "NOT IMPLEMENTED YET."
    north = raverLounge
;



raverBedroom : Room
    name = 'Bedroom'
    desc = "NOT IMPLEMENTED YET."
    west = raverLounge
    south = raverBathroom
;

raverBathroom : Room
    name = 'Bathroom'
    desc = "NOT IMPLEMENTED YET."
    north = raverBedroom
;
