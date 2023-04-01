#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//---------------------//
//  The Seventh Floor  //
//---------------------//

seventhFloorHallway : Room
    name = 'Seventh floor hallway'
    destName = 'the seventh floor hallway'
    desc = "UNIMPLEMENTED YET. This is the seventh floor hallway. At
	    the west end there is the elevator doors and at the east
	    end, a door. "
    west = seventhElevatorDoors
    east = yinYangDoor
;

+seventhElevatorDoors : ElevatorDoors
    myCallButton = seventhElevatorCallButton
;

+seventhElevatorCallButton : ElevatorExteriorButton, Fixture
    myFloor = 7
;

+yinYangDoor : LockableWithKey, Door
    vocabWords = 'door/doorway/east/e'
    name = 'door'
    desc = "UNIMPLEMENTED YET. "
    initiallyLocked = true
    initiallyOpen = nil
    keyList = []
;
