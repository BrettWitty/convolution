#include <convolution.h>

/* First floor */

firstFloorEast : Room
    roomName = 'First floor hallway'
    
    desc = "First floor hallway. Janitor's room to north. Old folks to south.
        Stairwell to east. "
    
    east = stairwellFirst
    west = firstFloorWest
    
;

firstFloorWest : Room
    roomName = 'First floor hallway'
    desc = "First floor hallway. Cody's room to south. Abandoned apartment to
        north. Elevator to west. "
    
    east = firstFloorEast
    //west = elevator
    
;