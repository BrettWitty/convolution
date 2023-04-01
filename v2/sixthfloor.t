#include <convolution.h>

/* Sixth floor */

sixthFloorEast : Room
    roomName = 'Sixth floor hallway'
    
    desc = "Sixth floor east. Yin and Yang. "
    
    //east = infiniteHallway
    west = sixthFloorWest
    
;

sixthFloorWest : Room
    roomName = 'Sixth floor hallway'
    desc = "Sixth floor hallway. South to prisoner. "
    
    east = sixthFloorEast
    //west = elevator
    
;