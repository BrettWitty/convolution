#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//--------------------//
//  Locked Apartment  //
//--------------------//

lockedLounge : Room
    name = 'Lounge Room'
    destName = 'the lounge room'
    desc = "Compared to the other rooms you\'ve seen so far, this
	    room is quite impressive. The entrance is a small
	    polished wood platform extending from the west wall,
	    leading into the sunken lounge room. The layout is
	    simple but elegant. A neatly arranged open-style
	    kitchenette lies to the north. A platform skirts the
	    south and east walls, capped with a small set of stairs
	    leading east into
	    <<gPlayerChar.knowsAbout(lockedBedroom) ? 'the bedroom'
	    : 'some room'>>, and south into
	    <<gPlayerChar.knowsAbout(lockedBedroom) ? ' ' : 'what
	    seems to be '>> a study area. "
    north = lockedKitchen
    south = lockedLoungeToStudy
    east = lockedLoungeToBedroomDoor
    west = lockedLoungeToHallwayDoor
    up = lockedLoungeEntrancePlatform
;

+ lockedLoungeToKitchen : Passage
    vocabWords = 'neatly arranged open-style north northern n kitchen/kitchenette/north/n'
    name = 'kitchenette'
    desc = "Although not particularly spacious, the kitchenette area
	    seems to be well-designed and well-stocked. "
    destination = lockedKitchen
    hideFromAll(action) { return true; }
;

+lockedLoungeEntrancePlatform : Fixture, Platform
    vocabWords = 'entrance platform/entrance'
    name = 'the platform to the entrance'
    desc = "From the front door a short entryway makes way into a
	    parquet platform, stepping down into the recessed
	    lounge room. "
    exitDestination = lockedLounge
    isQualifiedName = true
    down = lockedLounge
    west = lockedLoungeToHallwayDoor
;

++lockedLoungeToHallwayDoor : Lockable, Door ->firstHallwayToLockedApartmentDoor
    vocabWords = 'west western w front door/west/w/entrance'
    name = 'front door'
    desc = "The parquet platform rising above the lounge room floor
	    leads into a dim entrance way of about a few paces
	    long--- just long enough to hold the jacket stand. The
	    entrance way ends in a smooth, dark grey door. "
    feelDesc = "The painted door is smooth to the touch. "
    initiallyOpen = nil
    initiallyLocked = true
    hideFromAll(action) { return true; }
;

+lockedLoungeToBedroomDoor : Door
    vocabWords = 'east eastern e east/e/door'
    name = 'door to the east'
    desc {
	if(isOpen)
	    "Three short steps lead up to the east into a brightly-lit room. ";
	else
	    "Three short steps lead up to the east, terminating in a closed door. ";
    }
    initiallyOpen = true
    hideFromAll(action) { return true; }
;

+lockedLoungeToStudy : Passage, TravelMessage
    vocabWords = 'south southern s study door/doorway/south/s/study'
    name = 'doorway to the study'
    desc = "Just off the parquet entrance lies a door leading south
	    into a artificially lit study. "
    travelDesc = "{Your/his} boots clop loudly on the wooden steps
		  as you step up into the study. "
    destination = lockedStudy
    hideFromAll(action) { return true; }
;

+lockedLoungeSofa : Bed, Heavy
    vocabWords = 'elegant comfortable comfy soft leather lounge sofa/couch/lounge/chair'
    name = 'soft leather sofa'
    desc = "The soft black leather couch spans most of the lounge room,
	    running perfectly north-south along the middle of the
	    room. It seats three quite spaciously. <<myPillows>>"
    specialDesc = "An elegant soft leather sofa partitions the room. "
    myPillowsList = [lockedLoungeSofaPillow1, lockedLoungeSofaPillow2]
    myPillows() {

	local l = contents.intersect(myPillowsList).length;

	// All my pillows are belong to us
	if(l == myPillowsList.length)
	    return 'At either end of the couch is a single white cotton square cushion. ';
	else {
	    // Only one of the pillows remains
	    if( l == 1 )
		return 'A single white cotton square cushion sits at the end of the couch. ';
	    else
		return 'The couch looks incomplete without its decorative cushions. ';
	}
    }
    allowedPostures = [sitting,lying]
    cannotStandOnMsg = '{You/he} would feel awfully guilty putting
			your dirty shoes on the soft leather couch
			and your mother\'s stern face stops you from
			even considering it. (At least, you think
			you remember your mother\'s face) '
    roomOkayPostureChangeMsg(posture,obj) {
	if(posture == sitting)
	    return '{You/he} recline{s} on {the dobj/him}, settling
		    into the gloriously comfortable cushioning.
		    ';
	if(posture == lying)
	    return 'In a fit of guilty pleasure, {you/he} lie{s}
		    down on {the dobj/him} and sink into the
		    deliciously comfortable cushioning. ';
	else
	    return 'You shouldn\'t stand on the sofa, nor see this message. ';
    }
    iobjFor(PutOn) {
	check() {
	    if(gDobj == me) {
		"You should just say SIT ON SOFA or some such command. ";
		exit;
	    }
	}
    }
;

++lockedLoungeSofaPillow1 : lockedLoungeSofaPillow
    vocabWords = 'white cotton round circular decorative cushion/pillow/circle*pillows*cushions*circles'
    name = 'white cushion'
    desc = "The cushion is made out of fine white cotton, shaped
	    into a firm circle. It is supposed to decorate the soft
	    black leather lounge with its twin. "
    collectiveGroup = lockedLoungeSofaPillows
    isEquivalent = true
;

++lockedLoungeSofaPillow2 : lockedLoungeSofaPillow
    vocabWords = 'white cotton round circular decorative cushion/pillow/circle*pillows*cushions*circles'
    name = 'white cushion'
    desc = "The cushion is made out of fine white cotton, shaped
	    into a firm circle. It is supposed to decorate the soft
	    black leather lounge with its twin. "
    collectiveGroup = lockedLoungeSofaPillows
    isEquivalent = true
;

class lockedLoungeSofaPillow : Thing
    isListed {
	return !isIn(lockedLoungeSofa);
    }
    isListedInContents {
	return !isIn(lockedLoungeSofa);
    }
;

lockedLoungeSofaPillows : CollectiveGroup
    vocabWords = 'white cotton square decorative *pillows*cushions'
    name = 'cushions'
    desc = "These twin cushions are made out of fine white cotton,
	    each shaped into a firm square. They are supposed to
	    decorate the soft black leather couch in a strikingly
	    sharp but simple colour coordination. "
    isCollectiveAction(action, whichObj) {

	if(/*action.ofKind(TakeAction) ||*/ action.ofKind(ExamineAction))
	    return true;
	else
	    return nil;
    }
    dobjFor(Take) {
	action() {
	    replaceAction(Take,lockedLoungeSofaPillow1);
	}
    }
;




lockedKitchen : Room
    name = 'Kitchenette'
    destName = 'the kitchen area'
    desc = "In stark contrast to the rest of the building, someone
	    has put a lot of time, money and effort into the design
	    of this kitchenette. The walls are predominantly glossy
	    black tiles embedded periodically with a single white
	    tile in the shape of a diamond. A speckled marble bench
	    borders most of the walls, stopping short at the north
	    wall to leave some space for the refrigerator to nestle
	    in. The top half of the south wall has been removed,
	    opening up the kitchen to the lounge. You imagine a
	    stylish guy living in this apartment, making dinner for
	    some pretty young thing reclining in the lounge, and
	    laying on the smooth small-talk over the half-wall.
	    Bastard. "
    south = lockedKitchenToLounge
;

+ lockedKitchenToLounge : Passage
    vocabWords = 'stylish stylishly decorated lounge south southern s lounge/room/south/s'
    name = 'lounge'
    desc = 'A stylishly decorated lounge room lies to the south. '
    destination = lockedLounge
;




lockedBedroom : Room
    name = 'Bedroom'
    destName = 'the bedroom'
    desc = "Bright light pushes its way between the buildings
	    outside, spreading out onto the polished wooden floor.
	    The reflection melts out onto the walls, bringing the
	    dimensions of the room into crisp clarity. The room is
	    ever-so-slightly longer than it is wide, but is higher
	    than both directions. The walls are painted uniformly
	    white, interrupted only by a light fixture hanging over
	    the flawlessly tidy futon to the south. Below the east
	    window is an octagonal tatami mat, and outside, a fire
	    escape. <<doorText>> "
    doorText {
	if(lockedBedroomToLoungeDoor.isOpen) {
	    if(lockedBedroomToBathroomDoor.isOpen)
		return 'A door to the west leads out into a recessed
			lounge room, and a sliding door leads
			northwards into a small bathroom. ';
	    else
		return 'A door to the west leads out into a recessed
			lounge room. A closed sliding door lies to
			the north. ';
	}
	else {
	    if(lockedBedroomToBathroomDoor.isOpen)
		return 'Adjacent to the closed door to the west is a
			door leading northwards into a small
			bathroom. ';
	    else
		return 'Two closed doors lead out; a plain wooden
			one to the west and a sliding door to the
			north. ';
	}
    }
    north = lockedBedroomToBathroomDoor
    west = lockedBedroomToLoungeDoor
    east = lockedBedroomToCatwalkWindow
;

+lockedBedroomToLoungeDoor : Door ->lockedLoungeToBedroomDoor
    vocabWords = 'plain wooden recessed lounge west western w west/w/door/lounge/steps'
    name = 'door to the lounge'
    desc {
	if(isOpen)
	    "A plain polished door opens up to a recessed lounge
	     room. Below the door frame are three short steps
	     leading down into the lounge";
	else
	    "A solid lacquered door stands shut, but posing no
	     opposition to you opening it";
    }
    openStatus {}
    initiallyOpen = true
;

+lockedBedroomToBathroomDoor : Door
    vocabWords = '(small) north n northern sliding bathroom ensuite north/n/bathroom/ensuite/door'
    name = 'door to the bathroom'
    desc {
	if(isOpen)
	    "Through the white door frame you see an immaculate but
	     small bathroom. The edge of the white sliding door
	     sticks out. ";
	else
	    "The uniform white wall to the north breaks up into a
	     similarly white doorframe that holds a wooden sliding
	     door, also white, but with a small golden latch. ";
    }
    initiallyOpen = true
;

++Component '(small) golden door latch/lock/handle' 'golden latch'
    "The white sliding door to the north flaunts a soft polished
     gold latch. "
    cannotLockMsg = 'This door is locked from the other side. '
    cannotUnlockMsg = (cannotLockMsg)
;

+lockedBedroomToCatwalkWindow : Door, TravelMessage
    vocabWords = '(small) plain east e eastern window/east/e/out'
    name = 'window to the east'
    desc = "Keeping with the room\'s theme, the window is painted a
	    plain white and is otherwise undecorated. A fire escape lies beyond. "
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

+Fixture
    vocabWords = 'tatami straw octagonal meditation mat/carpet/octagon/tatami'
    name = 'tatami mat'
    desc = "The tatami mat below the window is a tightly-woven straw
	    mat, formed in the shape of an octagon. The mat is
	    divided into four parts, alternately dyed black or left
	    plain. You notice some wear close to the center of the
	    mat, though you cannot guess why. "
    cannotMoveFixtureMsg = 'The tatami mat is too heavy and bulky to bother with. '
    cannotTakeFixtureMsg = (cannotMoveFixtureMsg)
    cannotPutFixtureMsg = (cannotMoveFixtureMsg)
;

+lockedBedroomBed : Bed, Heavy
    vocabWords = '(small) low japanese flawlessly tidy neat futon/bed/fudon'
    name = 'futon'
    desc = "Neatly aligned alongside the north wall, is a shin-high
	    futon. The blankets have been stretched and folded to an
	    insane precision; the bed all straight lines and smooth
	    curves. However, the general indentation in the middle
	    and gentle softness to the blankets suggest that someone
	    sleeps here, but goes through all this trouble every
	    morning. You whistle, both impressed and incredulous. "
    allowedPostures = [sitting,lying]
    cannotStandOnMsg = 'It would be bad enough to sit or lie on the
			futon, but to put your dirty shoes on it... '
    okayPostureChangeMsg(posture) {
	if(posture == sitting)
	    return 'You sit warily on the futon, your knees rising
		    to chest-height. ';
	if(posture == lying)
	    return 'You cautiously sit on the end of the futon and
		    spin yourself around to lie down. Pangs of guilt
		    gnaw away at you. ';
	else
	    return 'You cannot stand on the futon. ';
    }
    iobjFor(PutOn) {
	check() {
	    if(gDobj == me) {
		"You should just use SIT ON FUTON or some such command. ";
		exit;
	    }
	}
    }
;

+Fixture '(black) (light) fixture/light/lamp' 'light fixture'
    "A simple black metal light juts out from the wall, a thin,
     round bar ending in a flat, wide shade. "
    dobjFor(TurnOn) {
	verify() {}
	check() {
	    "The natural sunlight provides more than enough illumination. ";
	    exit;
	}
    }
    dobjFor(TurnOff) {
	verify() { illogicalNow('The light is already off. '); }
    }
    dobjFor(Switch) remapTo(TurnOn,self)
;

+Vaporous 'bright natural sunshine/sunlight/light/sun/beam/ray' 'beam of sunlight'
    "After squeezing its way through the tightly packed buildings,
     the sunlight shines through the window, bouncing off the
     polished floor and soaking the room in a cheery glow. "
;




lockedBathroomWalls : DefaultWall
    vocabWords = 'bathroom ensuite tiled walls/tiles/north/n/south/s/east/e/west/w'
    name = 'walls'
    desc = "The ensuite walls are covered with smooth, white,
	    rectangular tiles. Every few tiles, in the intersection
	    of the grout, a small, black tile in the shape of a
	    diamond has been set. "
    cannotCleanMsg = 'The wall tiles are in no need of cleaning. '
;

lockedBathroomFloor : defaultFloor
    vocabWords = '(tiled) floor/ground/down/d'
    name = 'floor'
    desc = "A traditional checkerboard pattern of black and white
	    tiles cover the floor. All seem surprisingly clean. "
    cannotCleanMsg = 'The floor seems spotless already. '
;

lockedBathroom : Room
    name = 'Ensuite'
    destName = 'the ensuite'
    desc = "The ensuite continues with the same tidy simplicity of
	    the bedroom; everything is neatly arranged, though that
	    may be more of a function of the lack of space. Your
	    breathing reverberates off the tiled walls, reinforcing
	    the tightness, but the room\'s dimensions seem
	    deceptively larger. A
	    <<lockedBathroomToBedroomDoor.isOpen ? ' ' : 'closed'>>
	    sliding door to the south leads back to the bedroom. "
    roomParts = [lockedBathroomFloor, lockedBathroomWalls]
    south = lockedBathroomToBedroomDoor
;

+ lockedBathroomToBedroomDoor : Door ->lockedBedroomToBathroomDoor
    vocabWords = 'south s southern bedroom south/s/bedroom/door'
    name = 'door to the bedroom'
    desc = "The sliding door is a plain wooden one that slides into
	    a wall recess for maximum space conservation. "
    initiallyOpen = true
;






lockedStudy : Room
    name = 'Study'
    destName = 'the study'
    desc = "You\'re not exactly sure why, but this room has a
	    different feel to it than the other rooms in this
	    apartment. The pale peach walls, orangeish light shining
	    straight down from the ceiling, the exclusively wooden
	    furniture, all conspire to give this room a more
	    determined, serious and scholarly atmosphere. The only
	    light is artificial and the only way out is via the
	    doorway to the north. <<!lockedStudyCeiling.hasSeenMe ?
	    '<.p>Something else about this room bugs you, but you
	    can\'t quite put your finger on it.' : ' '>> "
    roomParts = [lockedStudyFloor, lockedStudyWalls, lockedStudyCeiling]
    north = lockedStudyToLounge
;

+lockedStudyToLounge : Passage, TravelMessage
    vocabWords = 'north northern n lounge door/doorway/north/n/lounge'
    name = 'doorway to the lounge room'
    desc = "A platform followed by a few steps lead down into the
	    lounge."
    destination = lockedLounge
    travelDesc = "{You/he} step slowly down the steps to the
		     lounge, hearing your steps on the wooden steps
		     echo about the apartment. "
;

+lockedStudyDesk : Heavy, ComplexContainer
    vocabWords = '(study) solid teak wood desk/table/surface'
    name = 'solid teak desk'
    desc = "An elegant teak desk sits precisely in the middle of the
	    room, facing west. The sides are smooth, seamless boards
	    sliding up to a simply-bevelled top surface. The desk
	    looks as though it has been made from a single block of
	    wood, although the size of the desk and the striations
	    along the edges show this to be impossible. The fine
	    carpentry is topped with a unnaturally uniform black
	    stone surface with a single plain white square set in
	    the center. Behind the desk is a similarly simple yet
	    elegant wooden chair. "
    initSpecialDesc = "Perfectly centered in the middle of the room
		       is a solid oak desk with a single wooden
		       chair behind it. "
    subSurface : ComplexComponent, Surface {
	bulkCapacity = 300
	contentsListed = nil
	contentsLister : ContentsLister, lockedDeskSurfaceContentsLister {}
	descContentsLister : DescContentsLister, lockedDeskSurfaceContentsLister {}
    }

    // This is not a ComplexComponent so we can get specialized messages "(opening the desk drawer)" etc
    subContainer : Component, OpenableContainer {
	vocabWords = '(desk) drawer'
	name = 'desk drawer'
	bulkCapacity = 20
	contentsListed = nil
	openStatus() {
	    if(isOpen)
		"The desk drawer lies open";
	    else
		"The single desk drawer is closed";
	}
	initializeLocation() {
	    location = lexicalParent;
	    inherited();
	}
    }

    // To make sure things are ordered properly
    examineStatus()
    {
        if (subSurface != nil)
            subSurface.examineStatus();
	if (subContainer != nil)
            subContainer.examineStatus(); 
        if (subRear != nil)
            subRear.examineStatus();
        if (subUnderside != nil)
            subUnderside.examineStatus();
    }
;

+lockedStudyChair : CustomImmovable, Chair
    vocabWords = '(desk) simple stained elegant wooden chair/seat'
    name = 'desk chair'
    desc = "The chair is made of gently curved, stained wood. The
	    seat is made out of unblemished, dark olive leather. The
	    whole package offers nothing more than simple elegance. "
    cannotTakeMsg = 'You don\'t need to take the chair elsewhere.
		     And anyway, it is too much of a hassle to drag
		     around behind you. '
    dobjFor(LookUnder) {
	verify() {}
	check() {
	    if(lockedStudyHiddenNote.moved) {
		say(&nothingUnderMsg);
		exit;
	    }
	}
	action() {
	    mainReport('With an air of idle curiosity, you duck down
			and look underneath the chair. To your
			surprise you find a green business card
			tucked into a fold underneath the chair. You
			stand up, dust your knees off and put the
			card in your jacket. ');
	    lockedStudyHiddenNote.moveInto(trenchCoat);
	}
    }
;

+Distant
    vocabWords = 'artificial orange orangeish orangish light/lights'
    name = 'ceiling lights'
    desc = "Two lights have been embedded in the ceiling, the
	    illumination spraying out over the room, giving it an
	    orange tint. Pools of light directly underneath the
	    lights flank the desk in the middle of the room. "
    brightness = 4
;

lockedDeskSurfaceContentsLister : Lister
    showListPrefixWide(itemCount, pov, parent) {
	"<.p> A few neat piles of books and pieces of paper lie on the
	 desk, as if left in the middle of work. Amongst this you
	 see ";
    }
    showListSuffixWide(itemCount, pov, parent) { ". "; }
    showListPrefixTall(itemCount, pov, parent) { "On <<parent.theNameObj>> <<itemCount == 1 ? 'is' : 'are'>>:"; }
    showListContentsPrefixTall(itemCount, pov, parent) { "<<parent.aName>>, on which <<itemCount == 1 ? 'is' : 'are'>>:"; }
;

lockedStudyFloor : defaultFloor
    vocabWords = 'polished wooden floor/ground/floor/down/d'
    name = 'the floor'
    isQualifiedName = true
    desc = "The unmarred polished floorboards gleam brightly under the direct
	    light shining from above. Two pools of light flank the
	    desk. "
    feelDesc = "The floor has a soft, polished feel. "
;

lockedStudyWalls : DefaultWall
    vocabWords = 'south s east e west w wall*walls'
    name = 'walls'
    isPlural = true
    desc = "The walls have been painted with a chalky peach colour
	    in rough, wispy circles. "
    feelDesc = "The walls have a rough, chalky feel to them. "
;

lockedStudyCeiling : defaultCeiling, Distant
    vocabWords = 'weird up/u/ceiling'
    name = 'ceiling'
    desc {
	if(!hasSeenMe) {
	    "You casually cast your eyes upwards, expecting the
	     usual ceiling. To your amazement, the ceiling is
	     actually a painting. But even more curious, the
	     painting is a precise, birds-eye-view of the study! The
	     detail is amazing. The desk and chair are exactly
	     mirrored, although the contents of the painted table
	     are different. The glow of the lights mimic the sheen
	     of that same light on the floor below. Curiously, the
	     space around the desk in the painting is glossy and
	     your can make out a blurred, shadowy reflection of
	     yourself looking up, or looking down as the case may
	     be. You survey the room again, nervously scratching
	     your neck. ";
	    hasSeenMe = true;
	}
	else
	    "You peer again at the strange painting on the ceiling.
	     The detail and layout so precisely matches the room
	     below, you figure it could be a perfect map of the
	     room. You stare fixedly into the blurry, ethereal
	     reflection of yourself above. You look back at the room
	     and swallow. ";
    }
    hasSeenMe = nil
;
