#include <convolution.h>

/* Second floor */

secondFloorEast : Room
    roomName = 'Second floor hallway'
    
    desc = "Second floor hallway. Programmer's room to north. ?? to south.
        Stairwell to east. "
    
    east = stairwellSecond
    west = secondFloorWest
    
;

secondFloorWest : Room
    roomName = 'Second floor hallway'
    desc = "Second floor hallway. Recluse's room to south. Academic's room to
        north. Elevator to the west. "
    
    east = secondFloorEast
    //west = elevator
    
;