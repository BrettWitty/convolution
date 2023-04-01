#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//----------------//
//  The Basement  //
//----------------//

behindBunchOfBoxes : Room
    name = 'Behind a bunch of boxes'
    destName = 'the pile of boxes'
    desc = "Apart from the dry brick wall next to you, this little
	    nook is almost all boxes. Every stack is comprised of
	    uniformly-sized, production-line delivery boxes, piled
	    high in some places to the ceiling, in other places,
	    only a box or two high. Murky light filters through the
	    boxes from a thin, dusty row of windows near the ceiling
	    to the north. A larger beam shines across what seems to
	    be a break in the boxes to the east --- a windy passage
	    disappearing behind the boxes, but presumably leading
	    out. "

    roomAfterAction() {

	// We trigger a headache reminder on the end of the third
        // turn, so long as you're not moving and not checking
        // yourself out
	if( !(gActionIs(TravelVia) || (gActionIs(Examine) && gDobj == me) ) && libGlobal.totalTurns == 3 )
	    extraReport('<.p>An invisible claw crushes your brain
			 and you wince. Heaven would be an aspirin
			 bottle right now.');

    }
    
    roomParts = [crumblingBasementWall,bunchOfBoxesCeiling,bunchOfBoxesFloor]
    eastLook = (boxesToMainBasement.desc)
    southLook = "A dense pile of boxes extend southwards into the boxes. "
    northLook = "A beam of sunlight sneaks between haphazardly stacked packages. "
    east = boxesToMainBasement
    out asExit(east)
;

+boxesToMainBasement : ThroughPassage, TravelMessage ->basementToBehindBoxes
    vocabWords = 'east e eastwards easterly windy passage/path/east/e/entrance'
    name = 'passage through the boxes'
    desc = "A tight passage wends its way east through the
	    boxes<<gActor.hasSeen(mainBasement) ? ' through to the
	    main basement' : ', presumably out to the main room'>>. "
    travelDesc = (say(travelMsgs.getNextValue()))
    travelMsgs : ShuffledList {
	valueList = ['Turning sideways you squeeze through the boxes out into the basement proper. ',
		     'Stepping over a low box, you push through the passage out into the basement proper. ',
		     'Careful not to knock over any of the boxes, you shuffle through the tight passage. ']
		     }
    hideFromAll(action) { return true; }
;

+tumbledPileOfBoxes : PresentLater, Fixture
    vocabWords = 'collapsed tumbled stack boxes/box/boxs/packages/stack'
    name = 'collapsed stack of boxes'
    desc = "A tumbled stack of boxes lie at your feet<<wasAttacked ?
	    ', a result of your devastating attack.' : '.'>> "
    specialDesc = (desc)
    wasAttacked = nil
    dobjFor(Clean) {
	preCond = [touchObj]
	verify() {}
	check() {}
	action() {
	    "With a twinge of guilt, you stack the boxes back neatly. ";
	    moveInto(nil);
	}
    }
    dobjFor(Clear) asDobjFor(Clean)
    dobjFor(Kick) {
	verify() {}
	check() {}
	action() {
	    "Not content with just taking down the stack of boxes, you kick
	     them while they are down. The boxes scrape across the
	     ground and tumble over each other. ";
	}
    }
    dobjFor(Punch) {
	verify() {
	    logicalRank(90,'prefer the other pile');
	}
	action() {
	    "You drop to your knees and sink a punch into a fallen
	     box. Mercy is for the weak. ";
	}
    }
    dobjFor(Push) {
	verify() {}
	action() { "You crouch down and rummage through the fallen
		    boxes, finding nothing of interest. "; }
    }
    dobjFor(Pull) remapTo(Push,self)
    dobjFor(Move) remapTo(Push,self)
;

+pilesOfBoxes : Fixture
    vocabWords = 'pile piles delivery hundreds unopened reject mail cardboard uniformly sized uniformly-sized generic boxes/box/boxs/pile/stack/packages/south/s/north/n/northeast/ne/northwest/nw/southeast/se/southwest/sw'
    name = 'pile of boxes'
    desc = "The boxes surrounding you seem to be unopened delivery
	    boxes, piled high in vaguely ordered way. Surprisingly,
	    they all seem very generic; the packaging is
	    professional, smooth cardboard, but nondescript, and all
	    of the boxes you\'ve read have incredibly mundane names
	    and addresses, almost boilerplate. "
    feelDesc = "The boxes are covered in a smooth, thin layer of wax
		for waterproofing. Your fingers have traced a thin
		line through the dust on the firm cardboard. "
    smellDesc = "The boxes have the slightest whiff of cardboard and
		 preservative chemicals. "
    soundDesc = "The boxes remain unsurprisingly silent. "
    isPlural = true
    pluralName = (name)
    dobjFor(Read) remapTo(Read,addressesBoxes)
    dobjFor(Kick) {
	verify() {
	    if(tumbledPileOfBoxes.location == behindBunchOfBoxes)
		logicalRank(80,'prefer the collapsed pile');
	}
	action() {
	    if(tumbledPileOfBoxes.location != behindBunchOfBoxes) {
		"A stack of boxes look like they\'re trying to stick
		 out, so you take aim and swing your boot into them.
		 They tumble down, bumping other stacks on the way.
		 You stand over the collapsed pile, victorious. ";
		tumbledPileOfBoxes.makePresent();
	    }
	    else
		replaceAction(Kick,tumbledPileOfBoxes);
	}
    }
    dobjFor(Punch) {
	verify() {}
	action() {
	    if(tumbledPileOfBoxes.location == behindBunchOfBoxes) {
		"With the Bruce Lee-like speed, you snap a punch
		 deep into another stack of boxes, causing them to
		 collapse on top of the previously felled stack. ";
	    }
	    else {
		"Leaping onto the balls of your feet, you slide back
		 and forth, suddenly cracking a punch into a pile of
		 delivery boxes. <q>Eye of the Tiger</q> plays on
		 your imaginary soundtrack as the boxes tumble to
		 the ground, like Apollo Creed all those years ago. ";
		tumbledPileOfBoxes.makePresent();
	    }
	}
    }
    dobjFor(Push) {
	verify() {}
	action() {
	    if(tumbledPileOfBoxes.location == behindBunchOfBoxes) {
		"Stepping over the previously-fallen boxes, you
		 nudge through the boxes, finding nothing. ";
	    }
	    else {
		"While trying to peer through the thick wall of
		 boxes, you move a pile to the side, unfortunately
		 beyond its centre of gravity. The boxes twist and
		 fall as you step out of the way, watching them
		 tumble across the floor. ";
		tumbledPileOfBoxes.makePresent();
	    }
	}
    }
    dobjFor(Pull) remapTo(Push,self)
    dobjFor(Move) remapTo(Push,self)
;

++addressesBoxes: Readable, Component
    vocabWords = 'delivery boxes boilerplate mundane address/addresses/label/labels/lable/lables/name/names'
    name = 'addresses on the delivery boxes'
    desc = "Every label has been pressed onto the boxes with a mechanical
	    care. Every address is printed with the same precision. Endless
	    piles of perfectly manufactured delivery boxes. Impressive arrays
	    of perfection without a scrap of soul to be found. "
    addressNames : ShuffledList{ valueList = ['Jones', 'Smith', 'Smith', 'Jackson', 'Johnson', 'Brown', 'Williams'] shuffleFirst = true}
    addressStreets : ShuffledList{ valueList = ['First Street', 'Main Street', 'Park Avenue', 'the corner of Rose and Third', 'Twelfth Avenue', 'Long Road', 'Samsara Court','Free Boulevard','Plain Street','Cycle Way'] shuffleFirst = true}
    addressTitles : ShuffledList{ valueList = ['Mr ','Mr ','Mr ','Mrs ', 'Mr and Mrs ', 'Dr ', 'Miss ','A.\ ','someone called ', 'Rev. '] shuffleFirst = true }
    readDesc {	boxReadMsgs.doScript(); }
    boxReadMsgs : ShuffledEventList {

	firstEvents = [ {: "You peer at the label of a nearby box. <<addressesBoxes.generateAddress('It reads ')>> There are so many labels here... so many invisible people..." } ]
	
	eventList = [ {: "You pick a nearby box at random and read the neatly printed address. <<addressesBoxes.generateAddress(nil)>> " },
		     { : "You pull a box from the top of some stack. <<addressesBoxes.generateAddress(nil)>> You slide it back." },
{ : "A box near your foot <<addressesBoxes.generateAddress('is addressed to ')>> You nudge it away with your shoe. " },
{ : "You look around for a box you haven\'t checked out yet. One of them near the ceiling looks inviting, so you pull it forward. <<addressesBoxes.generateAddress('It is addressed to ')>> With your curiosity satisfied, you push it back. " },
{ : "You grab a nearby box destined for <<addressesBoxes.addressTitles.getNextValue() + addressesBoxes.addressNames.getNextValue()>> on <<addressesBoxes.addressStreets.getNextValue()>>. It strikes you that these boxes are just shells of identity for all these people. Little reminders of existence. " }
    ]
    }
    generateAddress(val) {
	if(val == nil)
	    val = 'This one seems to be addressed to ';
	
	val = val + addressTitles.getNextValue() + addressNames.getNextValue() + ', living on ' + addressStreets.getNextValue() + '. ';
	return val;
	}
    
    isPlural = true
    hideFromAll(action) { return true; }
;


+basementSmallWindow : Fixture
    vocabWords = '(small) thin dusty grimy window/windows'
    name = 'thin dusty windows'
    desc = "Above the skyline of boxes, just below the ceiling, a
	    thin row of windows span the entirety of the north wall.
	    Murky light seeps through the dusty panes, illuminating
	    this nook of the basement. "
    cannotOpenMsg = 'These windows are sealed, and cannot be opened. '
    shouldNotBreakMsg = 'The windows are barely as high as your
			 fist, so are tough to break. And it\'d be
			 pointless. '
    nothingThroughMsg = '{You/he} can only see blurry, indistinct
			 shapes through the dusty window. '
    dobjFor(Clean) {
	verify() {}
	check() {
	    "You rub at the window, only to find that the grime and
	     dust is mostly on the outside. ";
	    exit;
	}
    }
;

// Beam of light
+Vaporous
    vocabWords = 'large beam murky dim light/ray/sunlight'
    name = 'beam of dim sunlight'
    desc = "As if it were orchestrated that way, the boxes block out
	    some of the light to form a solid beam illuminating the
	    entrance of the passage leading out. Blurry bars of
	    light shine through the cracks between the boxes,
	    breaking up over others. "
    lookInVaporousMsg = 'The sunlight filters through the dusty
			 window, blurring out over the boxes. '
;

+SimpleNoise 'general background mumble/noise/quiet/silence' 'general noise'
    "Except for a general mumble of machinery to the east, you
     cannot hear anything. No-one moving around, no-one talking, no
     cars, no bustle. Nothing. It\'s as if the world had been
     abandoned and you were left behind. "
    isQualifiedName = true
;

crumblingBasementWall : defaultWestWall
    vocabWords = 'crumbling west w dry brick wall/west/w/bricks/brick'
    name= 'crumbling west wall'
    desc = "For a stretch of maybe a few metres wide, the west wall
	    is free of boxes, revealing the dry bricks and dust. The
	    bricks are so dry and old that they crumble under any
	    moderate force, which has left them with a rough texture
	    over the years. "
    feelDesc = "A piece of brick chips off as you run your hand over
		it. The brick is particularly rough and dry. "
    cannotMoveFixtureMsg = 'The wall solidly resists your efforts,
			    though small flakes of brick remain on
			    your hands, which you dust off. '
;

bunchOfBoxesCeiling : defaultCeiling
    vocabWords = '(concrete) rough ceiling/up/u/roof'
    name = 'ceiling'
    desc = "The rough concrete ceiling lies lower than usual, but
	    not claustrophobically so. "
;

bunchOfBoxesFloor : defaultFloor
    vocabWords = '(concrete) ground/floor'
    name = 'floor'
    desc = "The floor is made out of smooth, mottled concrete.
	    Various muddled tracks in the dust swarm around you and
	    lead out through the gap to the east. "
;

//-----------------//
//  Main Basement  //
//-----------------//

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
    roomParts = [mainBasementFloor, mainBasementCeiling, mainBasementSouthWall, mainBasementEastWall, basementToBoilerRoomDoorway, basementToBehindBoxes]
    west = basementToBehindBoxes
    north = basementToBoilerRoomDoorway
    east = basementStairsUp
    up asExit(east)
    south = basementToJanitorDoor
;

+basementToBehindBoxes : ThroughPassage, TravelMessage
    vocabWords = 'west w boxes/passage/west/w'
    name = 'passage into the boxes'
    desc = "A tight passage pushes deep through the thick wall of boxes to the west. The boxes nearest to the northern doorway sweat as waves of heat billow out. "
    destination = behindBunchOfBoxes
    travelDesc = "You squeeze through the boxes, and shuffle into
		  the small clearing inside. "
    dobjFor(Kick) {
	verify() {}
	action() {
	    "Though it feel like kicking someone in the back, you
	     swing your boot into the boxes. They sway and ripple in
	     response, and somewhere inside the circle of boxes you
	     hear the <<tumbledPileOfBoxes.moved ? 'familiar ' : '
	     '>> sound of boxes tumbling onto the floor. ";
	    tumbledPileOfBoxes.makePresent();
	}
    }
;

+basementToBoilerRoomDoorway : ThroughPassage, TravelMessage, ShuffledEventList
    vocabWords = 'north northern n n/north/opening/entryway/entrance/gap/wall'
    name = 'entryway to the north'
    desc = "You feel waves of heat ebb through the narrow opening in
	    the brick wall to the north."
    destination = boilerRoom
    //travelDesc { doScript(); }
    eventList  = ['You squint your eyes and wade through the heat into the boiler room beyond. ',
		     'You brave the humidity streaming out of the opening and step through it. ']
;

+basementStairsUp : StairwayUp, TravelMessage ->basementStairsDown
    vocabWords = 'stair case/stairway/staircase/e/east/up/u/stairs'
    name = 'staircase leading up'
    desc = "A plain set of concrete stairs lead up through the light into
	    <<gActor.hasSeen(backRoom) ? 'the back room. ' : 'what looks like a hallway
	    or small room. '>>"
    travelDesc = "Shading your eyes from the bright light, you stomp up the
		  stairs. "
;

+Decoration 'spider cob spiderweb/spiderwebs/web/webs/cobweb/cobwebs' 'spiderwebs'
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

+Decoration 'dust/grime' 'dust'
    "The dust seems to have settled in well here, except for a clear
     track from the stairs, forking to the gap in the north wall,
     and to the metal door to the south. "
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

+Decoration '(dust) track/traffic' 'track through the dust'
    "A lane of foot traffic has kept a path through the basement
     relatively dust-free. It splits in the middle of the room,
     going north through the gap in the brick wall and south to the
     metal door. "
;

+Vaporous 'ray/shaft/beam/light' 'shaft of light'
    "From the stairway to the east, a large beam of light cuts
     through the murkiness of the basement lending some light to the
     surroundings. A few dust motes meander lazily through the air. "
    lookInVaporousMsg(obj) { return 'In the middle of the shaft of light you can make out a concrete stairway leading up. '; }
;

+Vaporous '(dust) specks/particles/motes/mote/speck/particle' 'motes of dust'
    "Tiny as can be, the dust particles wander through the air, inexorably
     downwards but with a seeming disposition to stay aloft. "
    lookInVaporousMsg(obj) { return 'In between the specks of dust there is nothing but air. You\'ll never know what is actually inside a single mote, but you\'re guessing you\'re not missing out on much. '; }
;

+SimpleNoise 'general background mumble/noise/quiet/silence' 'general noise'
    "Other than the rumble of the boiler room to the north, the
     place is quiet. No, the world is quiet and you feel terribly
     lonely. "
    isQualifiedName = true
;

+basementToJanitorDoor : LockableWithKey, Door
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

++Component
    '(door) scratches/scratchings/etch/etchings/sign' 'scratched sign on the metal door'
    "The word <q>Janitor</q> has been scratched in the middle of the
     metal door, perhaps with a screwdriver or knife. "
;

mainBasementEastWall : DefaultWall
    vocabWords = 'dusty smooth smoother brick east e wall/brick/bricks/east/e*walls'
    desc = "The bricks here are smoother than those behind the
	    boxes. They have the same coat of dust and grime,
	    however. A staircase leads up to somewhere brighter. "
;

mainBasementSouthWall : DefaultWall
    vocabWords = 'dusty smooth smoother brick south s wall/brick/bricks/south/s*walls'
    desc = "The bricks here are smoother than those behind the
	    boxes. They have the same coat of dust and grime,
	    however. Spiderless cobwebs hang loosely across the
	    wall.<.p>The south wall is broken up by a small metal
	    door<<basementToJanitorDoor.isOpen ? ', which is
	    currently open.' : '.'>>"
;

mainBasementCeiling : defaultCeiling
    vocabWords = '(concrete) rough ceiling/up/u/roof'
    name = 'ceiling'
    desc = "The rough concrete ceiling lies lower than usual, but
	    not claustrophobically so. "
;

mainBasementFloor : defaultFloor
    vocabWords = '(concrete) dusty ground/floor/tracks/footprints'
    name = 'floor'
    desc = "The smooth, mottled concrete floor is covered in a thin
	    film of dust. A clear track leads through the dust
	    through the gap to the north, to the metal door to the
	    south and to the staircase to the east. Your footsteps
	    track from the west, though there seems to be more than
	    you would expect. "
    feelDesc = "The floor is cold and dusty. "
;


// BOILER ROOM IN BOILER.T


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

+janitorToBasementDoor : LockableWithKey, Door ->basementToJanitorDoor
    vocabWords = '(small janitor) metal janitor\'s south door'
    name = 'small metal door'
    desc {
	if (isOpen )
	    "The door to the janitor\'s room is open. ";
	else
	    "The sturdy metal door is shut. Literally scratched into the middle of it is
	     the word <q>Janitor</q>. ";
    }
    initiallyOpen = nil
    initiallyLocked = true
    keyList = [janitorKey]
;

+janitorCloset : OpenableContainer
    vocabWords = '(janitor) utility closet/cupboard/storage'
    name = 'utility closet'
    desc {
	if (isOpen)
	    "The janitor has been provided with a small, but
	     servicable utility closet. Various hooks and
	     compartments allow him to store whatever he needs to
	     use to take care of the building. ";
	else
	    "The sturdy utility closet shows signs of wear and tear.
	     It could do with a new paint job, but is otherwise
	     servicable. The doors are currently closed. ";
    }
    specialDesc = "A worn but sturdy utility closet leans against
		   the side wall. "
;
