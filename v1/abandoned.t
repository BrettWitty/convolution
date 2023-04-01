#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//-----------------//
//  The abandoned  //
//    apartment    //
//-----------------//

abandonedFloor : defaultFloor
    vocabWords = 'bare floor smooth dusty floorboards/boards/ground/floor/down/d/slats'
    name = 'floor'
    desc = "With the carpet removed, the floor is just smooth, dusty
            floor boards. One of the boards sticks up peculiarly, as
            if loose or propped up by something underneath. "
;

abandonedCeiling : defaultCeiling
    vocabWords = 'up/u/ceiling/roof'
    name = 'ceiling'
    desc = "The ceiling is a blank whiteness, disrupted only by a
	    dismantled light fixture, and illuminated by the
	    reflection of the floor. "
;

abandonedEastWall : defaultEastWall
    vocabWords = 'east e eastern east/e/wall*walls'
    name = 'east wall'
    desc = "The east wall is completely blank. The pale grey paint
	    has only a few scratches and marks. "
;

abandonedSouthWall : defaultSouthWall
    vocabWords = 'south s southern south/s/wall*walls'
    name = 'south wall'
    desc = "The south wall is the same unadorned pale grey as the
	    others. The only difference is the maroon door leading
	    out. "
;

abandonedNorthWall : defaultNorthWall
    vocabWords = 'north n northern north/n/wall*walls'
    name = 'north wall'
    desc = "Apart from the bright, plain window in the middle, the
	    north wall is unadorned. "
;

abandonedLounge : Room
    name = 'Abandoned Lounge'
    destName = 'the abandoned lounge room'
    desc = "The bare floorboards and distinct lack of furniture
	    suggests that this place has been abandoned. The lights
	    are out and the only illumination comes from the small,
	    unadorned window to the
	    north<<abandonedToHallwayDoor.isOpen ? ' and from the
	    hallway through the door to the south' : ''>>. A vacant
	    kitchen area lies to the west and a
	    <<abandonedToBedroomDoor.isOpen ? ' ' : 'closed '>> door
	    to the northwest. "
    brightness = 3
    roomBeforeAction() {
        if(gActionIs(Read))
            "{You/he} maneuver{s} {yourself/himself} near the window
             and hold {the dobj/him} up into the light. ";
    }
    
    roomParts = [abandonedFloor,abandonedCeiling, abandonedNorthWall, abandonedSouthWall, abandonedEastWall]
    south = abandonedToHallwayDoor
    out {
	if(!abandonedToCatwalkWindow.isOpen)
	    return south;
	else
	    return outChooser;
    }		
    west = abandonedLoungeToKitchen
    northwest = abandonedToBedroomDoor
    north = abandonedToCatwalkWindow
    outChooser : AskConnector {
	promptMessage = "There are two ways out. "
	travelAction = GoThroughAction
	travelObjs = [abandonedToHallwayDoor, abandonedToCatwalkWindow]
	travelObjsPhrase = ''
    }
;

+abandonedToHallwayDoor : LockableWithKey, Door ->firstHallwayToAbandonedDoor 'south southern s out door/doorway/south/s/out' 'southern door out to the hallway'
    "The door is rather uninteresting. It is painted in a cheap
     maroon paint and is otherwise undecorated. "
;

+abandonedLoungeToKitchen : Passage
    vocabWords = 'west w west/w/kitchen'
    name = 'the kitchen'
    desc = "A bare kitchen lies to the west, the empty fittings the
            only supporting evidence of its kitchenship. "
    destination = abandonedKitchen
;

+abandonedToBedroomDoor : LockableWithKey, Door 'northwest nw northwestern bedroom northwest/nw/door/doorway' 'bedroom door'
    "The plain wooden door to the northwest reveals nothing. You
     guess it leads to the bedroom"
    openStatus() {
	if(isOpen)
	    ", which is just an empty room now";
	else
	    ", \vbut it is locked and so you may never know";
    }
    initiallyOpen = nil
    initiallyLocked = true
    keyList = []
;

+abandonedToCatwalkWindow : Door, TravelMessage
    vocabWords = '(small) unadorned north n northern window/north/n'
    name = 'window to the north'
    desc = "Stripped of all decoration, the window is bare and too
            purely functional. Light from the alleyway streams in,
            barely filtered by the window. "
    initiallyOpen = nil
    okayOpenMsg = 'The window slides easily and locks in place at the top. '
    okayCloseMsg = 'The window slides shut, cutting short the
		    whisper of wind from the alleyway. '
    travelDesc = "You clamber through the window, stepping out onto
		  the fire escape outside. "
    shouldNotBreakMsg = 'There is no need to break the window, when
			 it is easily openable. '
    dobjFor(LookThrough) {
	verify() {}
	action() {

	    // HOOK INTO KARMA ENGINE!
	    "Outside of the window is a steel fire escape, hanging
	     over a narrow alleyway. ";
	}
    }
;

+ abandonedLights : Fixture 'dismantled removed uninstalled lights/light' 'dismantled lights'
    "In the ceiling where the lights should be, dangle torn, bare
     wires. You guess whoever once lived here removed everything
     when they left. "
    dobjFor(TurnOn) {
	verify() {
	    illogicalNow('The lights have been removed completely, so there is no way {you/he} can turn them on. ');
	}
    }
    dobjFor(TurnOff) {
	verify() {
	    illogicalNow('The lights have been removed completely, so there is no way {you/he} can turn them off. ');
	}
    }
;

++ Component '(lights) torn bare wires/wiring' 'wiring for the lights'
    "The wires hang loosely from the hole in the ceiling. They seem
     stretched and torn, as though someone made a quick (or
     desperate) departure. "
    isPlural = true
    feelDesc = "The wires give you an unexpected buzz. They must still be live! "
    owner = abandonedLights
    dobjFor(Pull) {
        verify() {}
        check() {
            "{You/he} better not --- the wires might still be live! ";
            exit;
        }
    }
    hideFromAll(action) { return true; }
;

+abandonedFloorboard : Fixture
    vocabWords = 'loose errant floor floorboard/board/wood/plank/slat'
    name = 'loose floor board'
    desc = "The smooth wooden slats are interrupted by one errant
	    board. <<abandonedFloorboardNote.isIn(self) ? 'A folded
	    scrap of paper has been wedged underneath. ' : ''>> "
;

abandonedKitchen: Room
    name = "Abandoned kitchen"
    destName = 'an empty kitchen'
    desc = "Stripped of everything that makes a kitchen useful, this
            area has just a bench, a dismantled sink and some
            cupboards. You can imagine where the various appliances
            would go by the faint outlines in the dust.\n The rest
            of the abandoned apartment lies to the east. "
    brightness = 2
    east = abandonedLounge
    out asExit(east)
    roomBeforeAction() {
        if(gActionIs(Read)) {
            "There's not enough light in the kitchen area to read
             by. There\'s more light in the main room though. ";
            exit;
        }
    }
;

+ abandonedKitchenBench : Fixture, Surface '(kitchen) top bench bench/surface/benchtop/table' 'kitchen bench'
    "The short kitchen bench is covered in a very ordinary grey
     vinyl. It doesn\'t look particularly new, but then again, it
     hasn\'t suffered much wear and tear. Near the south end of the
     bench is a dismantled sink. "
    bulkCapacity = 50
;

+ abandonedKitchenSink : Container, Fixture '(kitchen) dismantled metal sink/basin' 'dismantled kitchen sink'
    "Whoever previously lived here certainly didn\'t want to leave
     anything behind. The metal sink embedded in the kitchen bench
     is barely a receptacle. The taps have been removed, as well as
     most of the plumbing. Perhaps they wanted to avoid the
     clich&#233 and left the sink behind, you joke to yourself. "
;

++ abandonedKitchenSinkTaps : Unthing '(sink) tap/taps/faucet/faucets' 'taps to the sink'
    notHereMsg = 'Whoever abandoned this apartment seemed to have taken the taps with them. '
;
