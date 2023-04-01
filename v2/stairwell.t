#include <convolution.h>

/* Stairwell */

stairwellGround : Room
    roomName = 'Stairwell (ground floor)'
    
    desc = "Stairwell ground floor. "
    
    west = foyer
    up = stairwellFirst
    east asExit(up)
    
    
;

stairwellFirst : Room
    roomName = 'Stairwell (first floor)'
    
    desc = "Stairwell first floor. "
    
    west = firstFloorEast
    out asExit(west)
    down = stairwellGround
    up = stairwellSecond
;

stairwellSecond : Room
    roomName = 'Stairwell (second floor)'
    
    desc = "Stairwell second floor. "
    
    west = secondFloorEast
    out asExit(west)
    down = stairwellFirst
    
;