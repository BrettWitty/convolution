#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//--------------------//
//  The Second Floor  //
//--------------------//

secondStairwell : StairwellRoom
    name = 'Second floor stairwell'
    destName = 'the second floor stairwell'
    desc = "UNIMPLEMENTED YET. "
    west = secondStairwellToHallwayDoor
    out asExit(west)
    east : AskConnector {
	promptMessage = "There are two stairways to the east. "
	travelObjs = [secondStairwellUp, secondStairwellDown]
	travelObjsPhrase = 'one of them'
	isConnectorListed = nil
	}
    down = secondStairwellDown
    up = secondStairwellUp
;

+secondStairwellToHallwayDoor : Door 'west w door/doorway/out/west/w/exit' 'door to the second floor'
    "A cleanly-presented blue door leads west to the second floor. "
;

+secondStairwellDown : StairwayDown, TravelMessage ->firstStairwellUp 'd/down/stairway/stairwell/stairs/stair' 'stairs going down'
    "The simple concrete stairs lead down to the first floor. "
    travelDesc = "The lonely echo of your footsteps reverberate around the
		  stairwell as you make your descent. "
;

+secondStairwellSign : Readable, Fixture 'shiny metal sign/arrow' 'sign'
    desc = "A polished metal sign indicates you are on the second
	    floor. Two arrows point up and down to the first and
	    third floors, respectively. "
    readDesc = "An arrow points up the stairwell with the label: <Q>Third</Q>.
		Another points down with the label: <Q>First</Q>. A third and
		final arrow points out to the hallway to the west indicating
		<Q>Second</Q>."
;

+secondStairwellFluoro : Fixture
    vocabWords = 'stairwell fluoro fluorescent flouro flourescent light/lights/fluoro/fluoros/flouro/flouros'
    name = 'fluorescent lights'
    desc = "It's just standard fluorescent lighting. Bright lights ceased being
	   entertaining for you many years ago. "
    brightness = 4
;

++secondStairwellFluoroHum : SimpleNoise 'hum/humming/buzz/buzzing' 'hum of the fluorescent lights'
    desc = "The fluorescent lights hum single-mindedly. "
    isQualifiedName = true
;

+secondStairwellUp : StairwayUp 'up u second level stairwell/stairway/stair/stairs/up/u' 'stairs leading up to the second level'
    desc = "Instead of a simply dangerous film of water on the
	    stairs, these ones are buried underneath an avalanche of
	    furniture. It\'s like a removalist\'s revenge. The only
	    way through would require a cache of explosives and a
	    gutful of daredevilish idiocy. You may need to find
	    another way up. "
    travelBarrier = [secondStairwellUpBlocked]
;

++secondStairwellUpBlocked : TravelBarrier
    canTravelerPass(traveler) {return nil; }
    explainTravelBarrier(traveler) { "The bizarre avalanche of
				      furniture completely blocks
				      the stairs leading up. You
				      will need to find another way
				      up. "; }
;


secondHallway1 : Room
    name = 'Second floor hallway'
    east = secondHallwayToStairwell
    west = secondHallway2
;

+ secondHallwayToStairwell : Door ->secondStairwellToHallwayDoor 'stairway stairwell stairway/stairwell/doorway/door/e/east' 'doorway to the stairwell'
    "A freshly-painted blue door leads east into the stairwell. "
    isOpen = true
;

+secondHallwayToRaverDoor : Door
    vocabWords = 'south door/doorway/door'
    name = 'door'
    desc = "NOT IMPLEMENTED YET."
;

	    
secondHallway2 : Room
    name = 'Second floor hallway junction'
    destName = 'the second floor hallway junction'
    east = secondHallway1
    west = secondElevatorDoors
    north = secondHallway3
;

+secondElevatorDoors : ElevatorDoors
    myCallButton = secondElevatorCallButton
;

+secondElevatorCallButton : ElevatorExteriorButton, Fixture
    myFloor = 2
;

secondHallway3 : Room
    name = 'End of the second floor hallway'
    destName = 'the end of the second floor hallway'
    south = secondHallway2
    east = mafiaDoor
;
