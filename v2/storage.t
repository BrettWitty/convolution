#include <convolution.h>

/* Storage room */

storageEast : Room
    roomName = 'Storage'
    
    desc = "Storage east. "
    
    east = backRoom
    out asExit(east)
    west = storageWest
    in asExit(west)
    
;

// triptych on floor in corner, leaning against the wall
// It's okay to make this a Hieronymous Bosch because Dante has already been
// dead for 100 years

+ triptych : Heavy
    vocabWords = 'leaning picture/painting/triptych'
    name = 'painting'
    
    desc = "A triptych. "
    
;

storageWest : Room
    roomName = 'Storage'
    
    desc = "Storage west. "
    
    east = storageEast
    out asExit(east)
    south = storageSouth
    in asExit(south)
    
;

storageSouth : Room
    roomName = 'Storage'
    
    desc = "Storage south. "
    
    north = storageWest
    out asExit(north)
    
;

