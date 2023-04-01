#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//----------------//
//  The elevator  //
//----------------//

elevatorWalls : DefaultWall
    vocabWords = 'elevator north n south s west w stainless steel north/n/south/s/west/w/wall/walls'
    name = 'elevator walls'
    desc = "The preponderance of stainless steel---thin strips of
	    stainless steel on the wall, the stainless steel leaning
	    bar, the stainless steel doors, control panel,
	    everything---firmly places the elevator as a <q>choice
	    from the Catalogue of the Painfully Usual</q> as far as
	    building design goes. "
    isPlural = true
;

+Component
    vocabWords = '(metal) stainless steel lean leaning bar/rail/pipe/stand/railing/balustrade'
    name = 'metal bar'
    desc = "Skirting the three main walls is a metal bar for your
	    leaning pleasure. It sags a little from use, but is
	    otherwise okay. "
    feelDesc = "The railing feels cold and metallic. "
    dobjFor(Fix) { verify() { illogical('Cool off your fire of altruism and leave that for the caretaker. '); }}
;

+Component
    vocabWords = '(metal) dense vertical thin steel stainless steel strips/stripes/lines'
    name = 'strips of metal'
    desc = "The walls are covered in dense vertical lines of
	    stainless steel. "
    feelDesc = "The strips are fun to rattle your fingernail along,
		but feel rather much like you\'d expect: metal and
		stripey. "
;

elevatorFront : DefaultWall
    vocabWords = '(elevator) east e front east/e/front/door/doors/wall'
    name = 'elevator doors'
    desc = "The front of the elevator looks the same as all others
	    you\'ve stared at while you\'ve waited. To the right of
	    the doors is the requisite control panel. "
;

+elevatorPanel : Component
    vocabWords = '(elevator) control panel/controls/buttons'
    name = 'elevator control panel'
    desc = "To the right of the elevator doors is a simple control
	    panel with an assortment of buttons reading: G, 1, 2, 3,
	    4, 5, 6, and 7, as well as the usual ones to manually open
	    and close the doors. Below these is a slot for a keycard. "

    // This function deactivates all the buttons
    deactivateButtons() {

	foreach(local x in [elevatorGButton, elevator1Button, elevator2Button, elevator3Button, elevator4Button, elevator5Button, elevator6Button, elevator7Button]) {
	    x.makeEnabled(nil);
	}
    }
;

++elevatorOpenButton : Component, Button
    vocabWords = 'manual open O button/key/switch/open'
    name = 'manual open button'
    desc = "This button opens the doors to the elevator, when they can be. "
    dobjFor(Push) {
	verify() {}
	check() {
	    if(elevator.currentAction is in (elevatorGoingUp, elevatorGoingDown)) {
		"You press the <q>open</q> button and it briefly
		 lights up but darkens as soon as you remove your
		 finger. ";
		exit;
	    }
	}
	action() {
	    // Already open or just about to close, so reset the close action
	    // and open the door (Without triggering the usual things)
	    if(elevator.isDoorsOpen || elevator.currentAction == elevatorCloseDoor) {
		elevator.currentAction = elevatorOpenDoor;
		if(elevator.currentActionID != nil)
		    elevator.currentActionID.removeEvent;
		elevator.currentActionID = new Fuse(elevator,&closeDoors,elevator.doorCloseTime);
		"You press the button and the doors reopen. ";
	    }
	    else {
		"You press the <q>open doors</q> button and the elevator complies. ";
		elevator.openDoors();
	    }
	}
    }
;

++elevatorCloseButton : Component, Button
    vocabWords = 'manual close C button/key/switch/close/closed'
    name = 'manual close button'
    desc = "This button closes the doors when the automatic timer
	    just isn't fast enough. The label seems to be more worn
	    than the surrounding buttons. Impatient residents, you
	    guess. "
    dobjFor(Push) {
	verify() {}
	check() {
	    if(!elevator.isDoorsOpen) {
		"The doors are already closed, so naturally, the elevator does not respond. ";
		exit;
	    }
	}
	action() {
	    elevator.closeDoors();
	}
    }
;

++elevatorGButton : ElevatorButton, Component
    vocabWords = 'level floor storey ground g button bottom floor/level/storey/ground/g/button*buttons'
    name = '<q>G</q> button'
    myFloor = 0
    myFloorName = 'G'
    myFloorNameOrdinal = 'ground'
    isInteriorButton = true
;

++elevator1Button : ElevatorButton, Component
    vocabWords = 'level floor storey first 1 1st one button floor/level/storey/1/1st/one/first/button*buttons'
    name = 'button for the first floor'
    myFloor = 1
    isInteriorButton = true
;

++elevator2Button : ElevatorButton, Component
    vocabWords = 'level floor storey 2 two 2nd second button floor/level/storey/two/2/second/2nd/button*buttons'
    name = '<q>2</q> button'
    myFloor = 2
    isInteriorButton = true
;

++elevator3Button : ElevatorButton, Component
    vocabWords = 'level floor storey 3 three 3rd third button floor/level/storey/3/three/third/3rd/button*buttons'
    name = '<q>3</q> button'
    myFloor = 3
    isInteriorButton = true
;

++elevator4Button : ElevatorButton, Component
    vocabWords = 'level floor storey 4 four fourth 4th button floor/level/storey/4/four/fourth/4th/button*buttons'
    name = '<q>4</q> button'
    myFloor = 4
    isInteriorButton = true
;

++elevator5Button : ElevatorButton, Component
    vocabWords = 'level floor storey 5 five 5th fifth button floor/level/storey/5/five/fifth/5th/button*buttons'
    name = '<q>5</q> button'
    myFloor = 5
    isInteriorButton = true
;

++elevator6Button : ElevatorButton, Component
    vocabWords = 'level floor storey 6 six sixth 6th button floor/level/storey/6/six/sixth/6th/button*buttons'
    name = '<q>6</q> button'
    myFloor = 6
    isInteriorButton = true
;

++elevator7Button : ElevatorButton, Component
    vocabWords = 'level floor storey 7 seven seventh 7th button floor/level/storey/7/seven/seventh/7th/button*buttons'
    name = '<q>7</q> button'
    myFloor = 7
    isInteriorButton = true
;

++elevatorCardReader : Component, Readable
    vocabWords = 'keycard card security reader/slot/hole'
    name = 'card slot'
    desc = "A security card reader is installed in the elevator\'s
	    control panel at about navel-height. In miniature
	    writing above the slot is the text <q>INSERT KEY
	    CARD</q>. "
    readDesc = "Miniature writing about the slot reads: <q>INSERT
		KEY CARD</q> "
    currentEnabled = [ ]
    beforeAction() {
        
        inherited;
        if( gActionIs(Swipe) && gDobj.ofKind(SwipeCard) )
            replaceAction(SwipeThrough, gDobj, self);
    }
    iobjFor(SwipeThrough) asIobjFor(PutIn)
    iobjFor(PutIn) {
	verify() {}
	check() {
	    if(!gDobj.ofKind(SwipeCard)) {
		if(gDobj.bulk > 2)
		    "{The dobj/he} {is} too big to fit in the slot. ";
		else
		    "{The dobj/he} {is} inappropriate to put in the slot. ";
		exit;
	    }
	    if(!gDobj.isValid || gDobj.accessibleFloors.length == 0) {
		"You insert the card into the slot. It is taken in
		 and the reader thinks about it for a second before
		 buzzily angrily and spitting the card back out.
		 Maybe there is something wrong with the card? ";
		exit;
	    }
	}
	action() {
	    // Set up the variables
	    local buttonlst = [elevatorGButton, elevator1Button, elevator2Button, elevator3Button, elevator4Button, elevator5Button, elevator6Button, elevator7Button];
	    local activated = [];

	    // If our floor is on the card, enable the button
	    foreach(local x in buttonlst) {
		if(gDobj.accessibleFloors.indexOf(x.myFloor) != nil) {
		    x.makeEnabled(true);
		    activated = activated.append(x.myFloorNameOrdinal);
		}
	    }

	    "The card reader sucks in the card, thinks for a second
	     and chirps happily before ejecting the card. The
	     buttons for the <<stringLister.showList(activated)>>
	     floors light up. ";
	}
    }
;


elevatorCeiling : defaultCeiling
    vocabWords = '(elevator) ceiling/up/u/roof'
    name = 'ceiling'
    desc = "In the usual elevator wait, you\'ve often peered up at
	    the ceiling. This ceiling is no different---just the
	    usual lights, frame, and access panel.
	    <<elevatorCeilingPanel.discover()>> "
    location = elevator
;

elevatorCeilingPanel : Door, Hidden ->elevatorAccessPanel
    vocabWords = '(elevator) (ceiling) access emergency exit panel/exit/hole/manhole/portal'
    name = 'emergency exit panel'
    desc = "Although a little more conspicuous than your usual
	    elevator emergency exit, the panel in the roof is
	    unremarkable. "
    location = elevator
    initiallyOpen = nil
    okayOpenMsg = 'You shove the access panel open. It lifts up and
		   clangs on the roof of the elevator. '
    okayCloseMsg = 'You reach up and grab the access panel. After a
		    little bit of stretching and straining you
		    manage to pull the panel shut. '
    isComponentOf(obj) {
	return obj==elevatorCeiling;
    }
;

elevatorFloor : defaultFloor
    vocabWords = '(elevator) floor/down/d/ground'
    name = 'floor'
    desc = "A worn, grille-shaped carpet once decorated the floor
	    and is now only here because of tenure, you\'re
	    guessing. "
;



// Elevator Open event
elevatorOpenEvent : SoundEvent;

// Elevator Close event
elevatorCloseEvent : SoundEvent;

// Elevator slowing down event
elevatorStoppingEvent : SoundEvent;

// Elevator moving event
elevatorMovingEvent : SoundEvent;

// Elevator starting to move
elevatorStartingEvent : SoundEvent;

// THE ELEVATOR

enum elevatorIdle, elevatorGoingUp, elevatorGoingDown, elevatorStopping, elevatorOpenDoor, elevatorCloseDoor;

elevator : Room
    name = 'Elevator'
    destName = 'the elevator'
    desc = "Except for the roughly carpeted floor, the elevator is
	    pretty much entirely stainless steel. And uninspiringly
	    so. The walls have thin, vertical metal strips for
	    decoration, as well as a bar to lean on. Apart from the
	    control panel adjacent to the doors, this is as exciting
	    as this elevator gets. "
    roomParts = [elevatorWalls,elevatorFront,elevatorCeiling,elevatorFloor]
    out = elevatorInnerDoors
    east asExit(out)
    up {
	if(elevatorCeilingPanel.discovered() )
	    return elevatorCeilingPanel;
	else
	    return nil;
    }

    // Elevator-specific code

    // This holds the reference to the current action
    currentActionID = nil
    isDoorsOpen = nil
    queuedAction = nil
    currentAction = elevatorIdle
    currentFloor = 0
    initialFloor = 0
    goalFloor = 0
    doorCloseTime = 3

    // What is my outside door?
    myOutsideDoor() {

	local x;
	
	switch(currentFloor) {

	    case 0:
		x = groundElevatorDoors;
		break;

	    case 1:
		x = firstElevatorDoors;
		break;

	    case 2:
		x = secondElevatorDoors;
		break;

	    case 7:
		x = seventhElevatorDoors;
		break;

	    default:
		x = nil;
	    }

	return x;
    }

    // Remove daemons
    removeDaemons() {
	if(currentActionID != nil) {
	    currentActionID.removeEvent;
	    currentActionID = nil;
	}
    }

    // Trigger movement or not
    triggerMovement() {
	if(currentFloor != goalFloor) {
	    currentAction = (currentFloor > goalFloor ? elevatorGoingDown : elevatorGoingUp);
	    currentActionID = new Daemon(self,&doTravel,1);
	}
	else {
	    currentAction = elevatorIdle;
	    currentActionID = nil;
	}
    }

    // Code to open the doors
    openDoors() {

	isDoorsOpen = true;
	currentAction = elevatorOpenDoor;

	// Notify my floor that I've opened
	elevatorOpenEvent.triggerEvent(myOutsideDoor());
	elevatorOpenEvent.triggerEvent(elevatorInnerDoors);

	// Queue the door closing
	if(currentActionID != nil) {
	    currentActionID.removeEvent;
	}
	currentActionID = new Fuse(self,&closeDoors,doorCloseTime);

    }

    // Code to close the doors
    closeDoors() {

	if(currentAction not in (elevatorCloseDoor, elevatorGoingUp, elevatorGoingDown)) {

	    isDoorsOpen = nil;
	    currentAction = elevatorCloseDoor;
	    initialFloor = myOutsideDoor().myFloor;
	    
	    // Notify my floor that I've closed
	    elevatorCloseEvent.triggerEvent(myOutsideDoor());
	    elevatorCloseEvent.triggerEvent(elevatorInnerDoors);
	    
	    // Take care of daemons
	    removeDaemons();
	    
	    // If I have a new goal level, start that
	    triggerMovement();

	}

    }

    // Do travel
    doTravel() {

	// Check if we've reached our floor
	if(currentFloor == goalFloor) {

	    // Remove the travelling daemon
	    if(currentActionID != nil) {
		currentActionID.removeEvent;
	    }

	    // Set up the door opening
	    currentActionID = new Fuse(self,&openDoors,1);
	    currentAction = elevatorStopping;

	    if(myOutsideDoor() != nil)
		elevatorStoppingEvent.triggerEvent(myOutsideDoor());
	    elevatorStoppingEvent.triggerEvent(elevatorInnerDoors);

	}
	else {

	    // Still moving, so make some noise, but do nothing else
	    if(myOutsideDoor() != nil)
		elevatorMovingEvent.triggerEvent(myOutsideDoor());
	    if(currentFloor != initialFloor)
		elevatorMovingEvent.triggerEvent(elevatorInnerDoors);

	}

	if(currentAction is in (elevatorGoingUp,elevatorGoingDown)) {
	    if(currentAction == elevatorGoingUp)
		currentFloor++;
	    else
		currentFloor--;
	}

    }
;

+elevatorInnerDoors : ElevatorDoors
    vocabWords = '(elevator) (lift) (elevater) metal east e door/doors/east/e/out'
    destination = (elevator.myOutsideDoor().location)
    cannotTravel() { reportFailure(cannotGoThatWayMsg); }
    cannotGoThatWayMsg = 'The elevator is currently in motion, wait until it has stopped. '
    myFloor = (elevator.currentFloor)
    myCallButton = elevatorOpenButton
    //dobjFor(Open) remapTo(Push,elevatorOpenButton)
    dobjFor(Close) remapTo(Push,elevatorCloseButton)
    //dobjFor(TravelVia) { preCond = (inherited() + objOpen) }
;

+ElevatorSounds
    openMsg = 'The doors open, heralded by a exclamatory <i>ding!</i> '
    closeMsg = 'The doors slide shut with a low rumble and a clunk. '
    stopMsg = 'The elevator glides to a whining halt. '
    movingMsg = 'The elevator continues rumbling along. '
    startMsg {
	if(elevator.currentAction == elevatorGoingUp)
	    return 'The elevator groans and begins moving upwards. ';
	else
	    return 'With a sigh, the elevator drops, leaving your stomach trailing a little behind. ';
    }
;


//
// On top of the elevator

elevatorTop : Room
    name = 'On top of the elevator'
    destName = 'on top of the elevator'
    desc = "UNIMPLEMENTED"
    roomParts = [elevatorTopGround]
    down = elevatorAccessPanel

    roomBeforeAction() {
	if( gActionIs(Yell) ) {
	    "You shout out loud. Your voice echoes up and down the
	     elevator shaft. It soon fades. ";
	    exit;
	}
    }
;

+ elevatorAccessPanel : Door // ->elevatorCeilingPanel
    vocabWords = 'access emergency panel/hole/porthole'
    name = 'emergency panel'
    desc = "UNIMPLEMENTED"
    initNominalRoomPartLocation = elevatorTopGround
;

elevatorTopGround : Floor
    name = 'top of the elevator'
    desc = "UNIMPLEMENTED"
;



//
// ASSOCIATED CLASSES

// Elevator buttons class
class ElevatorButton : Button
    desc {
	"The large <q><<myFloorName>></q> indicates this button
	 takes the elevator to the <<myFloorNameOrdinal>> floor. ";
	if(isEnabled)
	    "The button is currently lit. ";
	else
	    "The button is currently dim. ";
    }
    myFloor = 0
    myFloorName { return toString(myFloor); }
    myFloorNameOrdinal { return spellIntOrdinal(myFloor); }
    isInteriorButton = true
    isEnabled = nil
    makeEnabled(val) {
	isEnabled = val;
    }
    dobjFor(Push) {
	verify() {}
	check() {
	    if(!isEnabled) {
		"You push the button but the elevator does not
		 respond. The button is not illuminated, probably
		 meaning you can\'t use it now. ";
		exit;
	    }
	}
	action() {

	    // We're rolling, so deactivate all the buttons
	    // This happens regardless of whether we are an interior button or not
	    elevatorPanel.deactivateButtons();

	    // If we're already there
	    if(elevator.currentFloor == myFloor) {
		if(!elevator.isDoorsOpen)
		    elevator.openDoors();
		else {
		    if(isInteriorButton)
			mainReport('You press the button, but nothing happens, presumably because you are already at the ground floor. ');
		    else
			mainReport('You press the button and stare embarrassed into the open, inviting elevator. ');
		}
	    }
	    // Otherwise, close the doors if need be and move.
	    else {
		elevator.goalFloor = myFloor;
		if(!elevator.isDoorsOpen) {
		    if(!isInteriorButton)
			mainReport('You press the button and wait for the elevator. ');
		    elevator.triggerMovement();
		    elevatorStartingEvent.triggerEvent(elevator.myOutsideDoor());
		    elevatorStartingEvent.triggerEvent(elevatorInnerDoors);
		}
		else {
		    if(isInteriorButton)
			mainReport('You press the button and the doors begin to close. ');
		    else
			mainReport('You press the button and wait for the elevator. ');
		    if(currentActionID != nil)
			currentActionID.removeEvent;
		    currentActionID = new Fuse(elevator,&closeDoors,1);
		}
	    }
	}
    }
;

// Exterior elevator button
// Has some extra customizations
class ElevatorExteriorButton : ElevatorButton
    vocabWords = '(elevator) call button/switch/key/up/down/u/d/call'
    name = 'elevator call button'
    desc = "This button, when pressed, calls the elevator.
	    <<isIlluminated ? 'The button is illuminated, indicating
	    the elevator is on its way. ' : 'The button is dim. '>> "
    isInteriorButton = nil
    isEnabled = true
    isIlluminated() { return (elevator.currentAction is in (elevatorGoingUp, elevatorGoingDown)); }
;

// Elevator doors class
class ElevatorDoors : ThroughPassage
    vocabWords = '(elevator) (lift) (elevater) metal west w door/doors/west/w/in'
    name = 'elevator doors'
    desc = "The elevator doors are of the usual shiny metal design. <<openStatus()>>"
    openStatus() {
	if(isOpen)
	    return 'They are currently open. ';
	else
	    return 'They are currently closed. ';
    }
    isOpen = (elevator.isDoorsOpen && elevator.currentFloor == myFloor)
    myFloor = (myCallButton.myFloor)
    myCallButton = nil
    destination = elevator
    dobjFor(Open) remapTo(Push,myCallButton)
    dobjFor(TravelVia) maybeRemapTo(!elevator.isDoorsOpen,Push,myCallButton)
;

// Elevator sounds class
class ElevatorSounds : SecretFixture, SoundObserver
    notifySoundEvent(event, source, info) {

	switch(event) {

	    case elevatorOpenEvent:
		callWithSenseContext(source, sight, {: say(openMsg) });
	        break;

	    case elevatorCloseEvent:
		callWithSenseContext(source, sight, {: say(closeMsg) });
	        break;

	    case elevatorStoppingEvent:
		callWithSenseContext(source, sight, {: say(stopMsg) });
	        break;

	    case elevatorMovingEvent:
		callWithSenseContext(source, sight, {: say(movingMsg) });
	        break;

	    case elevatorStartingEvent:
		callWithSenseContext(source, sight, {: say(startMsg) });
		break;
	    }
    }
;
