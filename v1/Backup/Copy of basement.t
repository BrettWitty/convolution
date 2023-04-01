#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//----------------//
//  The Basement  //
//----------------//

behindBunchOfBoxes: Room
    name = 'Behind a bunch of boxes'
    destName = 'the pile of boxes'
    desc = "Hundreds and hundreds of delivery boxes surround you in
	    silent oppression. This storage area seems to be tucked
	    away in some mouldy corner of a basement somewhere.
	    Murky light seeps in from the small, dusty window near
	    the ceiling. "
    east = boxesToMainBasementWay
    north {
	if(nailedShutBoards.isCleared)
	    return nailedShutDoor;
	else
	    return nil;
    }
;

+ boxesToMainBasementWay : ThroughPassage, TravelMessage
    vocabWords = 'passage/east/e'
    name = 'passage through boxes'
    desc = "A small passage leads eastwards through the boxes. "
    destination = mainBasement
    travelDesc = "Turning sideways you squeeze through the boxes out
		  into the basement proper. "
    hideFromAll(action) { return true; }
;

+bunchOfBoxes : Fixture, Chair, Readable
    vocabWords = '(bunch) pile hundreds unopened reject mail delivery cardboard boxes/box'
    name = 'pile of boxes'
    desc = "The boxes surrounding you seem to be unopened delivery
	    boxes, piled high in vaguely ordered way. Surprisingly,
	    they all seem very generic; the packaging is
	    professional, but nondescript, and all of the boxes
	    you\'ve read have incredibly mundane names and
	    addresses, almost boilerplate. "
    feelDesc = "The boxes are covered in a smooth, thin layer of wax
		for waterproofing. Your fingers have traced a thin
		line through the dust on the firm cardboard. "
    smellDesc = "The boxes have the slightest whiff of cardboard and
		 preservative chemicals. "
    soundDesc = "The boxes remain unsurprisingly silent. "
    isCleared = nil
    isPlural = true
    hasBeenSearched = nil
    dobjFor(Search) {
	verify() {}
	check() {
	    if (hasBeenSearched && !isCleared)
		{
		    "{You/he} do{es}n\'t find anything else other
		     than the alcove in the north wall hidden by the
		     boxes that you saw before. ";
		    exit;
		}
	    else {
		if (hasBeenSearched && isCleared)
		    {
			"{You/he} find{s} nothing amongst the delivery boxes. ";
			exit;
		    }
	    }
	}
	action() {
	    "{You/he} look{s} through the pile of boxes for anything
	     useful. After shifting a few things around, {you/he}
	     sp{ies} an alcove in the north wall almost completely
	     buried by the boxes. Through the shadows {you/he}
	     notice{s} a weathered door in the alcove. Maybe it
	     leads somewhere interesting? ";
	    hasBeenSearched = true;
	}
    }
    dobjFor(Clear) {
	verify() {}
	check() {
	    if (isCleared) {
		"{You/he} do{es}n\'t feel like {you/he} need{s} to
		 shift any more boxes around. ";
		exit;
	    }
	    if (!hasBeenSearched) {
		"{You/he} see{s} no reason why you should shift all
		 the boxes around. Well, {you/he} could rearrange
		 them to make it resemble a medieval castle more,
		 but you grew out of that many years ago. ";
		exit;
	    }
	}
	action() {
	    "Most of the boxes are particularly light, so you
	     quickly clear a path towards the hidden alcove. With
	     the boxes out of the way, you notice that the alcove
	     has several wooden planks nailed across it, preventing
	     anyone from opening the door beyond. Nevertheless, the
	     planks don\'t look like they couldn\'t be removed with
	     a bit of force or leverage. <.reveal nailed-boards>";
	    isCleared = true;
	}
    }
    dobjFor(Move) remapTo(Clear,self)
    dobjFor(Read) remapTo(Read,addressesBoxes)
    specialDesc {
	if (!isCleared)
	    "The boxes surround you, except for a passage to the east, and almost reach the ceiling. ";
	else {
	    if(isCleared)
		"You are surrounded by stacks of boxes that almost
		 touch the ceiling. To the east there is a narrow
		 passageway through the boxes out into the rest of
		 the basement and to the north you have cleared a
		 small path. At the end of this path is
		 <<nailedShutDoor.farDesc>> ";
	}
    }
;

++addressesBoxes: Readable, Component
    vocabWords = 'delivery boxes boilerplate mundane address/addresses/label/labels/lable/lables/name/names'
    name = 'addresses on the delivery boxes'
    desc = "Every label has been pressed onto the boxes with a mechanical
	    care. Every address is printed with the same precision. Endless
	    piles of perfectly manufactured delivery boxes. Impressive arrays
	    of perfection without a scrap of soul to be found. "
    addressNames : ShuffledList{ valueList = ['Jones', 'Smith', 'Smith', 'Jackson', 'Johnson', 'Brown']}
    addressStreets : ShuffledList{ valueList = ['First Street', 'Main Street', 'Park Avenue', 'the corner of Rose and Third', 'Twelfth Avenue', 'Long Road', 'Samsara Court','Free Boulevard','Plain Street']}
    readDesc { "You pick a nearby box at random and read the neatly printed address. This one seems to be addressed to ";
	       say(rand('Mr ','Mr ','Mr ','Mrs ', 'Mr and Mrs ', 'Dr ', 'Miss ','A.\ ','someone called ', 'Rev. '));
	       say(addressNames.getNextValue());
	       ", living on ";
	       say(addressStreets.getNextValue());
	       ".";}
    isPlural = true
    hideFromAll(action) { return true; }
;

+nailedShutDoor : OutOfReach, Door
    vocabWords = 'north n northern wooden small north/n/door/alcove'
    name = 'small wooden door'
    desc = "Set deep within the crumbling brick is a dry wooden
	    door. The wrinkles of remaining paint are covered with
	    dust but the door has retained a solid look, despite its
	    age and neglect. The alcove <<boardsDesc>>"
    farDesc() {
	if (nailedShutBoards.isCleared)
	    return 'a crumbling brick alcove fringed with
		    splintered wood, and just beyond it, a dry wooden door. ';
	else
	    return 'a criss-cross of wooden planks have been nailed
		    over a small alcove of crumbling brick. Behind
		    them you can just make out a dry wooden door in
		    the shadows. ';
    }
    boardsDesc {
	if(nailedShutBoards.isCleared)
	    return 'is fringed with splintered wood fragments. ';
	else {
	    if(nailedShutBoards.smashCount >1)
		return 'is crossed with a few broken planks nailed
			directly into the crumbling brick. ';
	    else
		return 'has a criss-cross of wooden planks nailed
			across it. ';
	}
    }
    sightPresence = (bunchOfBoxes.hasBeenSearched)
    canObjReachContents(obj) { return true;}
    canObjReachSelf(obj) {
	if(bunchOfBoxes.isCleared)
	    return true;
	else
	    return nil;
    }
    tooDistantMsg(obj) {
	gMessageParams(obj);
	return '{The dobj/he} cannot be reached with all the
		delivery boxes in the way. ';
    }
    okayOpenMsg {
	if(hasBeenOpened)
	    return 'The door opens easily with a soft creak. ';
	else
	    return 'You turn the handle and the door refuses to
		    budge. After a sharp tug the door comes free,
		    spraying dust and cracked paint chips all over
		    your jacket. You brush yourself off as the dust
		    settles. ';
    }
    okayCloseMsg = 'The door swings shut, closing with a light, hollow <i>clunk!</i>'
    hasBeenOpened = nil
    initiallyOpen = nil
    dobjFor(Open) {
	preCond = (inherited + objVisible)
	check() {
	    if (!nailedShutBoards.isCleared && nailedShutBoards.smashCount == 0) {
		"{You/he} squeeze{s} {your/his} hand between the boards and
		 tr{ies} to open the door. Unfortunately, the door opens
		 inwards and the planks are in the way. ";
		exit;
	    }
	    else {
		if(!nailedShutBoards.isCleared) {
		    "{You/he} wedge{s} {your/his} hand between the broken
		     boards and tr{ies} to open the door. Unfortunately, the
		     door opens inwards and the planks are still in the way.
		     Perhaps {you/he} should try breaking them up some more,
		     or clear them away? ";
		    exit;
		}
	    }
	}
	action() {
	    inherited();
	    hasBeenOpened = true;
	}
    }
;

++nailedShutBoards : Component
    vocabWords = 'criss-cross nailed wooden splintered plank/planks/board/boards/wood/timber'
    name = (smashCount == 0 ? 'wooden planks' : 'damaged wooden planks')
    desc = "<<currentCondition.doScript>>"
    isCleared = nil
    isPlural = true
    sightPresence = (nailedShutDoor.sightPresence)
    smashCount = (currentCondition.curScriptState -1)
    currentCondition : StopEventList {
	eventList = ['A zigzag of wooden planks have been nailed
		      directly into the cracked brick wall here,
		      blocking the door beyond. ',
		     'The planks remain nailed across the alcove. A
		      few of them have cracked slightly from your
		      attempts to break them, but you have some way
		      to go yet. ',
		    'Some of the boards blocking the door have
		     buckled under your force. One good hit should
		     finish them off. ',
		    'The boards that once blocked the alcove now
		     hang limply in pieces, thoroughly smashed in. ']
	scriptDone() { }
    }
    attackMsg : SyncEventList {
	eventList = ['You balance yourself carefully and hammer a kick into the
		     boards. They flex and crack slightly under the blow, but
		     do not break them all. A few more blows should do it. ',
		    'You take a step back then stamp heavily into the boards.
		     The blow punches through two boards, snapping them in two
		     and ripping the nails from the brick wall. One more kick
		     should finish off the rest. ',
		    'Steadying yourself with one hand on a pile of boxes, you
		     smash the remaining boards with your heel. Chips of the
		     brick wall hit you in the face as the barrier breaks and
		     buckles. You rub your stinging eye and peer at the
		     destroyed planks hanging limply from the wall, splinters
		     scattered around the base of the uncovered door. ']
	masterObject = lexicalParent.currentCondition
	advanceState() {}
    }
    dobjFor(Attack) {
	preCond = [objVisible, touchObj]
	verify() {}
	check() {
	    if(currentCondition.getScriptState() == currentCondition.eventList.length() || isCleared)
		{ "The boards have been sufficiently broken. Plus you\'ve gotten out all your aggression now. ";
		  exit;
	      }
	}
	action() {
	    attackMsg.doScript();
	    currentCondition.advanceState();
	}
    }
    dobjFor(Break) asDobjFor(Attack)
    dobjFor(Kick) asDobjFor(Attack)
    dobjFor(Clear) {
	preCond = [objVisible,touchObj]
	verify() {
	    if(isCleared)
		illogicalAlready('{The dobj/he} has already been cleared away. ');
	}
	check() {
	    if(smashCount < currentCondition.eventList.length() -1 ) {
		if(smashCount == 0)
		    "You need to break the boards up a bit before you can
		     clear them away. ";
		else
		    "The boards need to be broken up some more
		     before you can remove them. ";

		exit;
	    }
	}
	action() {
	    "Careful of splinters, you pull the fragments of boards
	     from the alcove and set them aside. Finally the doorway
	     is clear. ";
	    isCleared = true;
	}
    }
    dobjFor(Remove) asDobjFor(Clear)
    dobjFor(Pull) asDobjFor(Clear)
    dobjFor(Move) asDobjFor(Clear)
;


//
// MAIN BASEMENT
//


mainBasement: Room
    name = 'Basement'
    destName = 'the main area of the basement'
    desc = "The main area of the basement is much less cluttered
	    than the stack of boxes to the west. In fact, there is
	    little here save for spiderwebs and dust. It seems like
	    the owners of this place had pushed all the boxes to the
	    back of the room to make it easier to get to the small
	    metal door to the south and the small opening in the
	    brick wall to the north. A shaft of light penetrates the
	    dim, dusty basement air, illuminating the stairs leading
	    up to the east. "
    west = basementToBehindBoxesWay
    north = basementToBoilerRoomDoorway
    east = basementStairsUp
    up asExit(east)
    south = basementToJanitorDoor
;

+ basementToBehindBoxesWay : ThroughPassage, TravelMessage
    vocabWords = 'boxes/passage/west/w'
    name = 'passage into the boxes'
    desc = "A tight passage leads westwards into the boxes. "
    destination = behindBunchOfBoxes
    travelDesc = "You squeeze through the boxes, and shuffle into
		  the small clearing inside. "
;

+ basementToBoilerRoomDoorway : ThroughPassage, TravelMessage
    vocabWords = 'north northern n n/north/opening/entryway/entrance'
    name = 'entryway to the north'
    desc = "You can feel waves of heat ebb through the narrow
	    opening in the brick wall to the north."
    destination = boilerRoom
    travelDesc : ShuffledList {
	valueList = ['You squint your eyes and wade through the heat into the boiler room beyond. ',
		     'You brave the humidity streaming out of the opening and step through it. ']
	}
;

+ basementStairsUp : StairwayUp, TravelMessage ->basementStairsDown 'stairway/staircase/e/east/up/stairs' 'staircase leading up'
    desc = "A plain set of concrete stairs lead up through the light into
	    <<gActor.hasSeen(backRoom) ? 'the back room. ' : 'what looks like a hallway
	    or small room. '>>"
    travelDesc = "Shading your eyes from the bright light, you stomp up the
		  stairs. "
;

+ Decoration 'spider cob spiderweb/spiderwebs/web/webs/cobweb/cobwebs' 'spiderwebs'
    "Wispy strands of web dangle loosely between the rafters, seemingly
     abandoned by their makers. "
    takeMsgList : ShuffledList {
	valueList = [ '{You/he} pluck{s} a single thread of web, destroying
		       the support. The remaining web floats aimlessly in
		       the occasional draft. ',
		     '{You/he} plow{s} a hand through a nearby web, ruining
		      the intricate symmetry. ',
		     '{You/he} grab{s} the web and end{s} up with it all over
		      {your/his} hand. {You/he} shake{s} it off. '] }
    isPlural = true
    dobjFor(Take) {
        verify() {}
	action() {
	    say(takeMsgList.getNextValue());
	}
    }
    dobjFor(Pull) remapTo(Take, self)
    dobjFor(Clear) remapTo(Take, self)
    dobjFor(Tear) remapTo(Take, self)
;

+ Decoration 'dust/grime' 'dust'
    "The dust seems to have settled in well here, except for a clear track from the
     stairs to the metal door to the south. "
    isMassNoun = true
    dobjFor(Take) {
	verify() {}
	action() {
	    say('{You/he} look{s} at the dust, a reminder of
		 stagnation, of action past, and decide{s} that
		 {you/he} do{es}n\'t really need it. Anyway, who
		 collects dust? ');
	}
    }
    dobjFor(Clean) {
	verify() {}
	check() {
	    "Surely {you/he} {have} better things to do! And anyway,
		 it\'s not {your/his} job. ";
	    exit;
	}
    }
    dobjFor(Eat) {
	preCond = [touchObj]
	verify() {}
	check() {
	    "If only this were a drag race... ";
	    exit;
	}
    }
;

+ Vaporous 'ray shaft beam light' 'shaft of light'
    "From the stairway to the east, a large beam of light cuts
     through the murkiness of the basement lending some light to the
     surroundings. A few dust motes meander lazily through the air. "
    lookInVaporousMsg(obj) { return 'In the middle of the shaft of light you can make out a concrete stairway leading up. '; }
;

+ Vaporous '(dust) specks/particles/motes/mote/speck/particle' 'motes of dust'
    "Tiny as can be, the dust particles wander through the air, inexorably
     downwards but with a seeming disposition to stay aloft. "
    lookInVaporousMsg(obj) { return 'In between the specks of dust there is nothing but air. You\'ll never know what is actually inside a single mote, but you\'re guessing you\'re not missing out on much. '; }
;

+ basementToJanitorDoor : LockableWithKey, Door
    vocabWords = '(small) metal janitor\'s janitor south door'
    name = 'small metal door'
    desc {
	if (isOpen )
	    "The door to the janitor\'s room is open. ";
	else
	    "The sturdy metal door is shut. Scratched into the
	     middle of it is the word <q>Janitor</q>. No prizes for
	     whose room lies beyond.\b ";
    }
    initiallyOpen = nil
    initiallyLocked = true
    keyList = [janitorKey]
;

boilerRoom : Room
    name = 'The Boiler Room'
    destName = 'the boiler room'
    desc = "Buried deep underneath the building, carved into some
	    nook, is the boiler room. There are no windows and a
	    single entryway to the south that hasn\'t even been
	    given the honour of a door. The only decorations to the
	    room are a few small vents high in the north wall and
	    the pipes leading from the cantankerous old boiler that
	    occupies most of this hollow. "
    south = boilerRoomToBasementDoorway
;

+ boilerRoomToBasementDoorway : ThroughPassage, TravelMessage
    vocabWords = 's/south/opening/entryway/exit/entrance'
    desc = "The darker, cooler main basement lies through the
	    opening to the south. "
    destination = mainBasement
    travelDesc : ShuffledList {
	valueList = ['Feeling the hairs on the back of {your/his}
		      head roast, {you/he} step{s} out into the
		      cooler main basement. ',
		     '{You/he} sigh{s} as {you/he} step{s} into the
		      cooler air of the main basement. ']
	}
;

+ boiler : Fixture
    vocabWords = 'huge old large boiler/heater'
    name = 'the boiler'
    desc = "Most of this old boiler seems to come from The
	    Depression. The original frame is made out of the thick,
	    heavy cast-iron that they don\'t make anything out of
	    any more. Here and there someone has patched up pieces
	    with newer strips of aluminium or steel. It looks like
	    it should fall apart under any decent pressure, but
	    Depression-era construction has that way of looking
	    unstable but actually being impervious to anything
	    weaker than an atomic bomb blast (or the machinations of
	    a devious Communist).<.p> Nevertheless it bubbles away
	    obediently. The heat radiating from it is a bit
	    oppressive, but then again, this <i>is</i> the boiler
	    room."
    cannotTakeMsg = 'Now really, taking a boiler away with you is a
		     bit ambitious! '
;

/*+ boilerHeat : Heat
    vocabWords = 'oppressive boiler heat/warmth/hotness'
    name = 'the boiler heat'
    descWithSource = "The boiler pulses out steady waves of dry heat. It\'s
		      not enough to hurt you, but you feel a bit sweaty and
		      thirsty. "
    hereWithSource = descWithSource
    distantDesc = "The heat pulsates in a mechanical rhythm, making you feel
		   just that little bit uncomfortable. "
    isAmbient = true
    displaySchedule = [1,2,nil]
;*/


janitorRoom : Room
    name = 'The Janitor\'s room'
    destName = 'the janitor\'s room'
    desc {
	"Typical for someone employed to do all the hard work - the
	 caretaker's room is spartan and cramped. It's very utilitarian
	 (ironic for a utility closet). A bare light bulb illuminates the room
	 in a harsh light. <<janitorToBasementDoor.isOpen ?
	 'The door leading out is wide open. ' : ''>>";
    }
    north = janitorToBasementDoor
    out asExit(north)
;

+ janitorToBasementDoor : LockableWithKey, Door ->basementToJanitorDoor
    vocabWords = '(small janitor) metal janitor\'s south door'
    name = 'small metal door'
    desc {
	if (isOpen )
	    "The door to the janitor\'s room is open. ";
	else
	    "The sturdy metal door is shut. Scratched into the middle of it is
	     the word <q>Janitor</q>. No prizes for whose room lies beyond. ";
    }
    initiallyOpen = nil
    initiallyLocked = true
    keyList = [janitorKey]
;

+ janitorCloset : OpenableContainer
    vocabWords = '(janitor) utility closet/cupboard/storage'
    name = 'utility closet'
    desc {
	if (isOpen)
	    "The janitor has been provided with a small, but servicable
	     utility closet. Various hooks and compartments allow him to store
	     whatever he needs to use to take care of the building. ";
	else
	    "The sturdy utility closet shows signs of wear and tear. It could
	     do with a new paint job, but is otherwise servicable. The doors
	     are currently closed. ";
    }
    specialDesc = "A worn but sturdy utility closet leans against the side wall. "
;
