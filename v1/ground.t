#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//--------------------//
//  The Ground Floor  //
//--------------------//

backRoom : Room
    vocabWords = 'back room'
    name = 'Some Back Room'
    destName = 'the back room'
    desc {
	"With the precarious pillars of boxes and discarded
	 furniture scattered about the room, you guess this room is
	 a temporary storage area for someone. Well, more aptly, it
	 was probably used for storage one day but never
	 relinquished of this task, and the clutter has built up
	 over time. Strangely, no-one thought to put any of the
	 boxes in the bookcase that now stands empty against the
	 east wall.<.p>As if the pillars of boxes weren\'t enough of
	 an obstacle, someone has left a busted-up tangle of a
	 plastic chair near the entrance to the stairs that lead
	 west, down into the basement. This whole room seems to be
	 in sheer defiance of safety, capped off with the fortified
	 emergency exit to the north. ";

	if(!gPlayerChar.hasSeen(reception))
	    "<.p>Those responsible probably use what looks like an
	     office to the south. ";
	else
	    "Responsibility probably lies in whoever works in the
	     reception to the south. ";
    }
    roomAfterAction() {
	if(!haveDoneCreepyCallers) {
	    lobbyPhone.connectCall(creepyCallers);
	    haveDoneCreepyCallers = true;
	}
    }
    haveDoneCreepyCallers = nil
    west = basementStairsDown
    down asExit(west)
    in asExit(west)
    south : ThroughPassage {
	vocabWords = 'south s southern doorway/s/south'
	name = 'southern doorway'
	desc = "A plain, doorless doorway leads south into
		<<gActor.hasSeen(reception) ? 'the reception.' :
		'some cluttered office'>>. "
	destination = reception
    }
    north = backRoomDoor
    out asExit(north)
    southLook = "A plain, doorless doorway leads south into
		 <<gActor.hasSeen(reception) ? 'the reception.' : 'some cluttered office'>>. "
    westLook = "Stairs lead down into the dark basement where you
		woke up. "
    northLook = "The north is blocked by a large, fortified door
		 that is supposed to be for emergency egress. "
;

+basementStairsDown : StairwayDown, TravelMessage 'stairway/staircase/w/west/d/down/stairs' 'staircase leading down to the basement'
    desc = "A set of concrete stairs lead down into the dark, dusty basement. "
    travelDesc = "You step cautiously down the stairs into the
		  basement. It takes a while for your eyes to
		  adjust. "
    hideFromAll(action) { return true; }
;

+backRoomDoor : LockableWithKey, Door
    vocabWords = 'north n metal fortified emergency exit/door/north/n/out'
    name = 'fortified emergency exit'
    desc = "Whoever runs this place must have forgotten the purpose
	    of this emergency exit. The doorway is fairly wide so
	    you guess they may have used this as the main delivery
	    point - scratches of paint and blunt gouges in the metal
	    frame seem to confirm this theory. However they must
	    have found a better way and subsequently locked this
	    door permanently. It looks solid enough to shrug off any
	    axe-wielding maniac, and even seems to be doing a good
	    job against the occasional rust stain. Trying to shove
	    this door open would be a recipe for a broken shoulder.
	    You dread to think what the fire safety inspectors would
	    make of it. "
    initiallyLocked = true
    initiallyOpen = nil
    keyList = []
    cannotOpenLockedMsg = 'You rattle the door bar, but the door
			   doesn\'t even give a pretence of being
			   able to open. <.reveal back-door-locked>'
    cannotUnlockWithMsg = 'The keyhole seems plugged up with
			   something from the other side, making it
			   impossible to try to unlock the door,
			   even if you had the right key. <.reveal
			   back-door-locked>'
    keyDoesNotFitLockMsg = (cannotUnlockWithMsg)
    basicKnockResponse = '{You/he} knock{s} on the door to little
			  effect---the door bar rattles a little,
			  but the door itself seems too strong to
			  let {your/his} knocking through. '
;

+Immovable
    vocabWords = 'hastily stacked hastily-stacked cardboard delivery pile pillar/boxes/box/pile/clutter'
    name = 'pile of boxes'
    desc = "The arrangement of these boxes is clearly the product of
	    hastiness or laziness. Or both. Some boxes are stacked
	    askew, arranging themselves according to gravity. Others
	    seem to be stacked with good intention - one box has its
	    <q>This way up</q> arrow pointing directly down, a small
	    box supports a larger and heavier one... You're sure
	    that in the right gallery this would be an avante-garde
	    centerpiece of great distinction. Lying in this back
	    room they have been demoted to <q>clutter</q>. "
    hideFromAll(action) { return true; }
    cannotTakeImmovableMsg = 'The boxes that immediately catch your
			      eye do not keep your interest---you do
			      not feel you need to take them. '
    cannotMoveImmovableMsg = 'Moving any of the boxes around would
			      be like safely navigating a carpark in
			      post-Christmas sales time: more effort
			      than it\'s worth. Knocking any of the
			      piles over would exacerbate this (and
			      your ability to move) moreso. '
    cannotPutImmovableMsg = (cannotMoveImmovableMsg)
;

+Immovable
    vocabWords = 'abandoned busted up busted-up broken bent crooked twisted chair/stool/seat/furniture'
    name = 'busted-up chair'
    desc = "Some things in this world sure get the rough end of the
	    stick in terms of their existence: mayflies, dung
	    beetles, New Coke(tm) and this chair. It began its life
	    as one of those dime-a-dozen, plastic-backed,
	    unergonomic chairs that they often use for school
	    assemblies or town meetings. They are produced en masse
	    with cheap (foreign) labour; they only require screwing
	    two bent pieces of metal to the plastic seat.
	    Unfortunately, their cheap manufacture seems to induce
	    enraged people to hurl them at walls, lazy people to
	    snap their backs via creative posturing and the morbidly
	    obese to accidentally crush them. This specimen has had
	    its seat warped and its legs bent and snapped off. It
	    lies in a tangle heap of plastic and metal in one corner
	    of the room, just near the basement stairs. If it wasn't
	    just a stupid chair, you might shed a tear for its
	    beleaguered existence. "
    cannotTakeImmovableMsg = 'You think about taking this tangle of
			      plastic and metal, but it doesn\'t
			      serve its intended purpose --- you
			      couldn\'t possibly sit on it --- nor
			      does it lend itself to convenient
			      carrying. You are sure your creativity
			      stops well short of being able to make
			      this busted-up chair useful. '
    cannotMoveImmovableMsg = (cannotTakeImmovableMsg)
    cannotPutImmovableMsg = (cannotTakeImmovableMsg)
    shouldntKickMsg = 'The chair has taken enough abuse without you
		       taking out your anger on it. '
    shouldntPunchMsg = (shouldntKickMsg)
    hideFromAll(action) { return true; }
    dobjFor(Throw) {
	preCond = []
	verify() { illogical('{The dobj/he} has taken enough punishment. Leave it be. '); }
    }
    dobjFor(ThrowAt) remapTo(Throw)
    dobjFor(SitOn) { verify() { illogical('The broken chair is beyond being able to accommodate you. '); } }
;

+Heavy
    vocabWords = 'abandoned book bookcase/furniture/case/bookshelf/shelves/shelf'
    name = 'abandoned bookcase'
    desc = "A broken bookcase has been pushed into a corner here,
	    near the door. The fallen shelves house only dust. "
    foundCard = nil
    hideFromAll(action) { return true; }
    dobjFor(LookBehind) {
	verify() {}
	check() {
	    if(foundCard) {
		"There is nothing else behind the bookcase except for the wall. ";
		exit;
	    }
	}
	action() {
	    "You lean towards the bookcase, carefully stepping over
	     a box in the process. You pull the bookcase back and
	     suddenly a piece of card slides down the back, which
	     you reflexively catch. The bookcase claps back against
	     the wall as you peer at the card. The card is a folded
	     piece of packing cardboard, with some writing inside.
	     You shrug and put it in your jacket. ";
	    backRoomCard.moveInto(trenchCoat);
	    foundCard = true;
	}
    }
    dobjFor(Pull) asDobjFor(LookBehind)
    dobjFor(Search) asDobjFor(LookBehind)
;

//
// RECEPTION
//

reception : Room
    name = 'The Reception'
    destName = 'the reception'
    desc = "The reception office seems to be rarely used. It has the
	    usual assortment of administrative stuff strewn about,
	    but has that <Q>I'll be right back (in a month or so)</Q>
	    look to it. Between the mess and the filing cabinets is
	    an important-looking door to the east. Otherwise, a
	    plain-looking door to the north leads out the back and
	    you spot the main lobby to the south."
    east = receptionToManagerDoor
    in asExit(east)
    south = lobby
    north = backRoom
    southLook = "A simple doorframe leads out into the lobby. "
    northLook = "A plain, doorless doorway leads north into the back
		 room. "
;

+receptionToManagerDoor : LockableWithKey, Door ->managerToReceptionDoor
    vocabWords = 'e east manager manager\'s e/east/door/entry/doorway/office*doors*doorways'
    name = 'door to the east'
    desc = "By all rights, this door should be the same as all the
	    other standard wooden doors about the place. But as the
	    little gold-plated sign in the center of the door
	    indicates, this is the door to the Manager\'s office,
	    and standard isn't good enough. You guess he would have
	    wanted to install a grand oak door with intricate and
	    powerful carvings, but budget and space was tight so he
	    resigned himself to an extra coat of shellac on the door
	    (plus the spiffy gold-plated sign). <<isOpen ?
	    'Surprisingly, the door is open, inviting like the mouth
	    of a venus fly trap.' : 'Nevertheless it is firmly shut,
	    clearly demonstrating the line between the power and the
	    plebs.'>> <<changeName>>"
    initiallyOpen = nil
    initiallyLocked = true
    keyList = [hairPin]
    smellDesc = shellacRTMDoor.smellDesc
    feelDesc = shellacRTMDoor.feelDesc
    tasteDesc = shellacRTMDoor.tasteDesc
    soundDesc = shellacRTMDoor.soundDesc
    changeName() {
	name = 'door to the manager\'s office';
    }
    okayUnlockMsg {
	if(gIobj == hairPin)
	    return '{You/he} kneel{s} down and peer at the lock. Not
		    knowing exactly what to do, {you/he} jab{s} the
		    hair pin in the lock, jiggle{s} it around until
		    {you/he} hear{s} a mechanical click. With a
		    quick twist, the door is open. ';
	else
	    return 'The key slides in perfectly and the lock
		    disengages with a soft <i>click!</i>';
    }
    dobjFor(Kick) {
	verify() {
	    if(isOpen)
		illogicalNow('There is no need --- the door is already open. ');
	    else
		logical;
	}
	check() {
	    if(!isLocked)
		reportFailure('The door is unlocked --- no need to be dramatic. ');
	}
	action() {
	    makeLocked(nil);
	    makeOpen(true);
	    mainReport('The bolt jumps out of its recess as {you/he}
			bring{s} {your/his} foot down on the door.
			The door swings open, pained. ');
	}
    }
;

++managerDoorOuterLock : DoorLock
    desc = "The lock looks a little old... and simple. "
    myDoor = receptionToManagerDoor
;    

++managerSign : Component 'gold-plated gold spiffy manager manager\'s sign/emblem' 'sign saying <q>Manager</q>'
    desc = "This stylish, gold-plated wasn't from any ol\' hardware
	    store; it looks like it has been professionally machined
	    and fitted. It\'s even been polished recently, judging
	    from your golden reflection."
    hideFromAll(action) { return true; }
;


+shellacRTMDoor : MultiFaceted
    locationList = [reception, managerOffice]
    hideFromAll(action) { return true; }
    instanceObject : Decoration {
	vocabWords = 'shiny glossy extra coating shellac/paint/varnish/finish'
	name = 'shellac on the Manager\'s door'
	desc = "The door is thickly covered in glossy shellac. It must
	    be new (or so very thick) because it hasn't started to
	    crack yet. It's disconcerting to see something wood
	    being so reflective. At least it smells nice. "
        smellDesc = "Ah... the soothing aromas of liquified synthetic
		 insect resin. Not as wholesome as the old-fashioned
		 bug pulp they used to use but hey, synthetic
		 varnish is basically the same. Right?"
        feelDesc = "Smooth and velvety like a beautiful woman, but hard
		and cold like a manager. "
        tasteDesc = "The door is a crappy substitute for icecream. Well
		 at least you know now... "
        soundDesc = "If you listen really carefully to the door you can
		 hear tiny, tiny screams as if millions of bugs had
		 suddenly cried out in terror and were suddenly
		 silenced. "
    }
;

+Fixture 'front long counter/bench/table/desk' 'front counter'
    "The reception\'s front desk is an untidy affair with at least
     half an Amazon forest worth of paper strewn across it. Hiding
     amongst the papers are various items of stationery and several
     little knick-knacks. "
    hideFromAll(action) { return true; }
	dobjFor(Climb) {
		verify() { illogical('The reception window would be
				      tough to get through and
				      you\'re probably better off
				      going the traditional way:
				      through the door to the south. '); }
	}
	dobjFor(Board) asDobjFor(Climb)
	dobjFor(Enter) asDobjFor(Climb)
;

+Distant 'lobby pay ringing phone/telephone' 'lobby telephone'
    "Beyond the front desk and your reach is a
     <<lobbyPhone.isRinging() ? 'ringing' : ' '>> telephone. The
     plain doorway to the south <<lobby.pcSeen ? ' ' : 'probably'>>
     leads to the lobby and to the phone. "
    tooDistantMsg(obj) {
	return 'Even if you stretched over the front desk, you\'d
		probably still fall short of touching the phone.
		It\'s probably best to go around (via the door to
		the south). ';
    }
    hideFromAll(action) { return true; }
;

+Decoration
    vocabWords = 'untidy scrap uninteresting strewn scattered mess spread pile amazon admin administrative pieces papers/paper/mess/stuff/forms/memo/memos/scrap'
    name = 'scattered administrative papers'
    desc = "As if they were trying to hide the desk underneath,
	    various administrative forms, memos, and other assorted
	    scraps of paper cover the desk in a haphazard way.
	    <.p>The mess has spread to the top of the filing cabinet
	    where there\'s less paper but more knick-knacks. "
    isMassNoun = true
    isPlural = true
    cannotClearMsg = 'Hey! That\'s Someone Else\'s Problem(tm).
		      You\'ve got enough to worry about, anyway. '
    hideFromAll(action) { return true; }
    dobjFor(Take) {
	verify() {}
	check() {
	    reportFailure('From what you can see, the pieces of
			   paper strewn across the desk are
			   uninteresting and thus not worth taking. '); }
    }
    dobjFor(Search) {
	verify() {}
	check() {
	    if(receptionMessage.moved) {
		reportFailure('You sift through the papers, but you
			       don\'t find anything else of
			       interest. ');
		exit;
	    }
	}
	action() {
	    mainReport('You fish around the papers, trying to find
			anything interesting. Tucked under a thick
			wad of paper is a loose yellow memo written
			with a different handwriting than the rest
			of the administrivia. You tuck it away in
			your jacket for later reference. ');
	    receptionMessage.moveInto(trenchCoat);
	}
    }
;

+receptionFilingCabinets : ComplexContainer, Heavy
    vocabWords = 'filing office stationery stock standard cabinet/cabinets/cupboard/drawers'
    name = 'filing cabinets'
    desc = "Two stock-standard filing cabinets have been wedged in
	    the northeast corner of the reception"
    isPlural = true
    hideFromAll(action) { return true; }
    subContainer : ComplexComponent, OpenableContainer {
		bulkCapacity = 30
		okayOpenMsg {
		    if(receptionFilingCabinetNote.location == self)
			return 'The cabinet drawer slides open, a
				loose piece of paper scraping along
				the opening. ';
		    else
			return 'The cabinet drawer slides open. ';
		}
		okayCloseMsg {
		    if(receptionFilingCabinetNote.location == self)
			return 'You close the cabinet drawer, a
				piece of paper scraping against the
				interior as the drawer shuts. ';
		    else
			return 'You close the cabinet drawer with a
				solid <i>clunk!</i> ';
		}
		lookInDesc {
		    "The cabinets are full of uninteresting
		     documents: bills, legal documents, memorandums,
		     and the like. ";
		    if(receptionFilingCabinetNote.location == self)
			"However, a single loose piece of paper
			 sticks out from the drawer. ";
		}
		openStatus { if(isOpen) ". They are open"; }
    }
    subSurface : ComplexComponent, Surface {
		bulkCapacity = 10
		contentsListed = nil
                contentsLister : ContentsLister, receptionFilingCabinetSurfaceLister {}
                descContentsLister : DescContentsLister, receptionFilingCabinetSurfaceLister {}
                lookInLister : DescContentsLister, receptionFilingCabinetSurfaceLister {
		    showListEmpty(pov, parent) {
			gMessageParams(parent);
			defaultDescReport('{You/he} see{s} nothing on {the parent/him}. ');
		    }
		}
	}
;

++Surface '(coin) (change) metal plate/bowl/container/dish/platter' 'change bowl'
    "This flat, metal dish\'s sole reason for existence is to hold
     change. "
    subLocation = &subSurface
	bulkCapacity = 5
	bulk = 5
	weight = 2
	contentsListed = nil
	hideFromAll(action) { return !moved; }
;

+++Coin hideFromAll(action) { return !moved && !location.moved; };
+++Coin hideFromAll(action) { return !moved && !location.moved; };
+++Coin hideFromAll(action) { return !moved && !location.moved; };
+++Coin hideFromAll(action) { return !moved && !location.moved; };
+++Coin hideFromAll(action) { return !moved && !location.moved; };

class receptionFilingCabinetSurfaceLister : BaseSurfaceContentsLister
    showListPrefixWide(itemCount, pov, parent) {"On top of <<parent.theNameObj>> <<itemCount == 1 ? 'lies' : 'lie'>> "; }
    showListSuffixWide(itemCount, pov, parent) { ". "; }
    showListPrefixTall(itemCount, pov, parent) { "On top of <<parent.theNameObj>> <<itemCount == 1 ? 'is' : 'are'>>:"; }
    showListContentsPrefixTall(itemCount, pov, parent) { "<<parent.aName>>, on which <<itemCount == 1 ? 'is' : 'are'>>:"; }
;







lobby : Room
    vocabWords = 'lobby'
    name = 'The Lobby'
    destName = 'the lobby'
    desc = "You swear you\'ve seen this overly-bright lobby a
	    million times before --- most likely in countless movies
	    from the Eighties. The thin tan carpeting suggests that
	    this is an apartment lobby; an office building or hotel
	    would buy a bit more dignity with marble or tiled
	    flooring.<.p> Steel elevator doors lie to the west with
	    a lonely \'up\' button to its right. To the north there
	    is an open but empty reception window and a small
	    doorway to the left leading into the reception office.
	    Other than this you can go to the east down a short
	    hallway or towards the shadowy entrance to the south. "
    north = reception
    south = entrance
    east = groundHallway
    west = groundElevatorDoors
    southLook = "The light dims significantly towards the entrance.
		 Far beyond the main entrance area, you can see the
		 outside has been shut with some security door or
		 something. "
    northLook = "A simple doorframe leads back into the
		 receptionist\'s office. "
    eastLook = "A short hallway branches off from the main lobby. "
    westLook = "Shiny metal elevator doors stand off to the west. "
;

+groundElevatorDoors : ElevatorDoors
    myCallButton = groundElevatorCallButton
;

+groundElevatorCallButton : ElevatorExteriorButton, Fixture
    myFloor = 0
;

+lobbyFern : Heavy
    vocabWords = 'decorative potted pot plant/fern/tree/bush'
    name = 'decorative potted fern'
    desc {
	if(!hasFallenOver)
	    "As far as decorating the lobby goes, this poor fern is
	     doing the job all by itself. The upshot is that the
	     caretakers have lavished attention on it, dusting the
	     leaves and keeping it in a pot full of loose soil,
	     resulting in a proud, tall fern. But contrary to this,
	     the pot seems too small for it, as if the budget were
	     so tight they couldn\'t afford to waste money on
	     replacing the pot when the tree grew. The narrow base
	     and the thick spread of fronds high above make the
	     whole thing look very unstable. ";
	else
	    "A victim of your vengeance, the fern lies stricken on
	     the floor, its soil strewn across the carpet. ";
    }
    specialDesc {
	if(hasFallenOver)
	    "A decorative fern lies on its side, its soil strewn
	     across the carpet. ";
	else
	    "A lonely decorative fern stands to the entrance to the
	     eastern hallway. ";
    }
    hasFallenOver = nil
    dobjFor(Push) {
	verify() {
	    if(hasFallenOver)
		illogicalNow('{The dobj/he} has fallen over already. ');
	}
	check() {
	    if(gPlayerChar.canBeSeenBy(vern)) {
		"You\'d best not with Vern hanging around. You never
		 know deadly he is with those tools...";
		exit;
	    }
	}
	action() {
	    "You look around quickly and give the fern a quick
	     nudge. It teeters on the base of its pot for a second,
	     defying gravity, before falling to the ground, spilling
	     soil everywhere. You grin mischievously. ";
	    hasFallenOver = true;
	}
    }
    dobjFor(Take) maybeRemapTo( hasFallenOver, Pull, DirectObject )
    dobjFor(Raise) asDobjFor(Pull)
    dobjFor(Pull) {
	verify() {}
	check() {
	    if(hasFallenOver) {
		if(gPlayerChar.canBeSeenBy(vern))
		    "Vern waves you away from the spilt pot plant,
		     insisting on cleaning it up himself. ";
		else
		    "You try lifting the plant back up, succeeding
		     only in spilling more soil over the carpet.
		     After a few failed attempts with fronds poking
		     you in the face, you drop the plant back on the
		     ground in disgust. ";
		exit;
	    }
	}
	action() {
	    "Making sure no witnesses are about, you pull the plant
	     towards yourself and release it. It tips back on its
	     pot, then sways to the side and drops to the floor with
	     a rustle and thump as the soil spills out from the pot.
	     You grin mischievously. ";
	    hasFallenOver = true;
	}
    }
    dobjFor(Clear) asDobjFor(Clean)
    dobjFor(Clean) {
	verify() {
	    if(!hasFallenOver)
		illogicalNow('{The dobj/he} is clean enough. ');
	}
	check() {
	    failCheck('You try pushing handfuls of dirt back into
		       the pot, but it keeps tumbling back out
		       again. No point feeling guilty now; a cleaner
		       will take care of it as soon as they find
		       out. ');
	}
    }
    dobjFor(Kick) {
	verify() {};
	check() {
	    if(hasFallenOver) {
		failCheck('You kick the stricken plant a few more times. After
		 a while you feel rather silly kicking a plant,
		 especially when it\'s down. ');
	    }
	    if(gPlayerChar.canBeSeenBy(vern)) {
		failCheck('You better not --- the janitor might not appreciate it. ');
	    }
	}
	action() {
	    mainReport('Invoking the spirit of Bruce Lee, you give the plant a
	     decent roundhouse kick. It plunges to the ground,
	     spilling soil over the carpet as you finish your kick
	     with a flourish. ');
	    hasFallenOver = true;
	}
    }
    dobjFor(Attack) asDobjFor(Punch)
    dobjFor(Punch) {
	verify() { logical; }
	action() {
	    mainReport('You try roughing up the plant but it seems
			pretty resilient to your punches. ');
	}
    }
;

++lobbyFernSoil : Component
    vocabWords = 'potting loose lose rough soil/mix'
    name = 'soil'
    desc {
	if(lobbyFern.hasFallenOver)
	    "The soil from the fern has spilled across the floor.
	     The loose lumps of potting mix crumble over the lobby
	     carpet. ";
	else
	    "The fern sits in a pot of crumbly soil. ";
    }
    feelDesc = "The soil is soft and crumbly in your fingers. "
    tasteDesc = "You got over your dirt phase in kindergarten. "
    smellDesc = "You lean in close and smell the soil. It smells
		 much like dirt with a faint aroma of mulch. "
    cannotTakeMsg = 'You don\'t need any dirt, you\'re sure of it. '
    owner = lobbyFern
;

+lobbyPhoneSign : Fixture, Readable
    vocabWords = '(phone) (small) plastic numbers/sign'
    name = 'sign above the phone'
    desc {
	"A small, rectangular sign screwed into the wall lists
	 various phone numbers: the usual emergency numbers,
	 followed by a number written in ball-point pen: <font
	 face=tads-sans><B>Janitor: 101</B></font> ";
	gPlayerChar.setKnowsAbout(vern);
    }
;
											   
+Distant
    vocabWords = '(lobby) reception receptionist front counter/bench/table/window'
	name = 'front counter'
	desc = "The receptionist\'s main counter begins with a few
		thin metal bars, before dropping on the other side
		to the mess of paper beyond. "
	hideFromAll(action) { return true; }
	dobjFor(Climb) {
		verify() { illogical('You cannot fit through the
				      metal bars. Anyway, you can
				      just go through the door to
				      the north, to the left of the
				      counter. '); }
	}
	dobjFor(Board) asDobjFor(Climb)
	dobjFor(Enter) asDobjFor(Climb)
;

+ElevatorSounds
    openMsg = 'The elevator doors open with a <i>ding!</i> '
    closeMsg = 'The elevator doors to the west slowly slide shut. '
    stopMsg = 'You hear a muffled sigh as the elevator stops on this level. '
    movingMsg = 'You hear the elevator move away. '
;



    

entrance : Room
    vocabWords = 'entrance'
    name = 'The Entrance'
    destName = 'the entrance'
    desc = "You\'d expect this area to be the sunny entrance where
	    residents would come in from a long day\'s work, check
	    their mail and wander upstairs to their abode. But for
	    some strange reason this area is covered in dim shadows.
	    A pair of glass doors lie to the south, and immediately
	    beyond them, a large security roller door has been
	    pulled down, blocking out most of the light except for a
	    few broad shafts of sunlight streaming through the
	    cracks. "
    brightness = 2
    north = lobby
    south = glassDoors
    northLook = "The brighter lobby to the north looks inviting. "
    roomBeforeAction() {
        if(gActionIs(Read))
            "{You/he} maneuver{s} {yourself/himself} under a shaft of light
             and hold {the dobj/him} up into it. ";
    }
;

+Vaporous 'shaft shafts beam light/sunlight' 'shaft of sunlight'
    "A few thin cracks around the roller door produce flat beams of
     light, providing a little bit of illumination here. "
    lookInVaporousMsg(obj) {
	return '{You/he} tr{ies} to peer into the beam of light, but
		it\'s too bright to see through.';
    }
    brightness = 3
    hideFromAll(action) { return true; }
;

+glassDoors : LockableWithKey, Door
    vocabWords = 'south s pair glass front entrance doors/door/entrance'
    name = 'the front doors'
    disambigName = 'the pair of glass doors'
    desc = "The doors are slightly more impressive than you would
	    expect - the frames are constructed out of an expensive
	    oak, holding large glass panes stencilled with an
	    elaborate insignia. They remain solidly shut.
	    <<noteFromCreator.isIn(glassDoorHandles) ? 'On the cylindrical
	    brass door handles lies a professionally-made letter. '
	    : ''>> <<discoverLetter>> " //"
    discoverLetter {
	if (!noteFromCreator.discovered)
	    noteFromCreator.discover();
    }
    initiallyLocked = true
    initiallyOpen = nil
    isPlural = true
    isQualifiedName = true
    descContentsLister = thingContentsLister
;

++Component '(door) stencilled big large glass elaborate celtic insignia/symbol/crest/emblem/stencil/panes/pane/knot' 'insignia on the door'
    desc = "The insignia stencilled on the door is an elaborate
	    Celtic knot. It is woven in a maddening way - you can't
	    figure out if there is a beginning or an end, or even if
	    there is more than one distinct strand! The initials
	    <q>CT</q> lie below the design, etched in an
	    extravagant, calligraphic font. The whole thing is very
	    expensive and elaborate, but of no use to anybody. "
    hideFromAll(action) { return true; }
;

++glassDoorHandles : Component, RestrictedContainer
    vocabWords = '(door) handle/handles'
    name = 'door handles'
    desc = "The door handles are polished brass rods - simple but stylish.
	    Parades of residents have left a tarnished spot midway along them,
	    but they remain elegant. "
    validContents = [noteFromCreator]
    hideFromAll(action) { return true; }
    isPlural = true
;



+securityDoors : Distant 'security roller door/doors' 'security roller door'
    desc = "Just beyond the glass main doors someone has pulled down
	    a large aluminium security blind and locked it at the
	    base. A few flat beams of sunlight stream through the
	    small cracks to the side. It is very
	    <<initialScrapOfPaper.isRead ? 'imposing and drives away
	    any hope of you getting out of here. ' : 'imposing. '>>"
    hideFromAll(action) { return true; }
    
    // I don't like the current distant msg, so I have to redefine the object
    // to get my custom message.
    dobjFor(Default) {
        verify() { illogical(tooDistantMsg); }
    }
    iobjFor(Default) {
        verify() { illogical(tooDistantMsg); }
    }
    dobjFor(Examine) { verify { inherited() ; } }
    dobjFor(ListenTo) { verify() { inherited(); } }
    dobjFor(ShowTo) { verify() { inherited(); } }
    tooDistantMsg = '{You/he} can\'t reach {that dobj/him} with the glass doors in the way. '
;

mailboxes : CollectiveGroup
    vocabWords = 'mailboxes/boxes'
    name = 'the residents\' mailboxes'
	
    // This has some modified code to hint at the keyring.
    desc = "An array of mailboxes are embedded in the east wall.
	    They are all no-nonsense black-painted metal boxes,
	    locked with tiny, round keys that everyone seems to
	    lose. The numbers read 101 to 105, 201 to 205, 301 to
	    305 and are joined by a few special boxes labelled 400,
	    500, 600, 777 and Office.
	    <<oldFolksKeyring.isIn(mailbox102Door) ? 'You notice
	    that someone has left a keyring in one of the mailbox
	    doors, namely mailbox 102.' : ''>> "
    isCollectiveAction(action,whichObj) {
		return action.ofKind(ExamineAction);
    }
    isQualifiedName = true
;




groundHallway : Room
    vocabWords = 'ground floor hallway'
    name = 'Ground Floor Hallway'
    destName = 'the main hallway on the ground floor'
    desc = "This hallway slinks off to the side of the lobby. Some
	    effort has been made to jazz up the hallway with the an
	    obligatory scattering of paintings, but it does feel a
	    little underachieved. At the eastern end of the hallway
	    there is a stairwell leading up and immediately to the
	    south is a swinging door labelled <q>Laundry</q>.
	    Alternatively you can return to the lobby to the west.
	    <<stairwellStatus>>"
    stairwellStatus {
	if(groundHallwayToStairwellDoor.isOpen)
	    return '<.p>The door to the stairwell is currently open, slowly swinging shut. ';
	else
	    return '';
    }
    roomParts = [groundHallwayCarpet, groundHallwayNorthWall, groundHallwaySouthWall, groundHallwayCeiling]
    west = lobby
    out asExit(west)
    south = laundry
    east = groundHallwayToStairwellDoor
    eastLook = "The hallway terminates with a blue-green reinforced
		door. "
    southLook = "To the south is a swinging door with the word
		 <q>Laundry</q> written on it."
    westLook = "The hallway opens out into the brightly-lit lobby. "
;

+hallwayToLaundryDoor : ThroughPassage 'south southern laundry swinging s/south/door/doorway*doors' 'swinging door to the laundry'
    "The understated hallway wallpaper is interrupted by a worn
     swinging door to the south. The door is scuffed and dull, and
     the carpet at its base is lightly soiled and traffic-worn. "
    dobjFor(Open) {
	verify() {}
	check() {
	    "You don\'t need to open the swinging door. Just walk through it. ";
	    exit;
	}
    }
    dobjFor(Close) {
	verify() {
            if( !isOpen )
                illogicalNow('The door is already closed (and closes by
                    itself). ');
        }
	check() {
	    "The door to the south swings shut (eventually) by itself, so there
            is no need to close it. ";
	    exit;
	}
    }
    dobjFor(Push) {
	verify() {}
	action() {
	    "You give the door a shove and it swings back and forth,
	     the waving slowly decreasing until the door is closed
	     again. Between swings you spy a dull, concrete laundry
	     beyond. ";
	}
    }
    dobjFor(Pull) {
	verify() {}
	check() {
	    "The swinging door to the south has no handles. Anyway, the door
	     swings both ways so all you need to do is walk through. ";
	    exit;
	}
    }
    dobjFor(Punch) {
	verify() {}
	check() {
	    if(laundryToHallwayDoor.hasBeenPunched) {
		"After the stinging hand you received last time, you
		 decide not to punch the door again. ";
		exit;
	    }
	}
	action() {
	    "You punch the door with your palm. It swings violently
	     for a while before stopping. It looks you came off more
	     worse for wear than it did. ";
	    laundryToHallwayDoor.hasBeenPunched = true;
	}
    }
    dobjFor(Kick) {
	verify() {}
	check() {
	    if(laundryToHallwayDoor.hasBeenKicked) {
		"You still feel pangs of guilt from your last
		 assault on the door. ";
		exit;
	    }
	}
	action() {
	    "Holding the doorframe for support, you take a short
	     step backwards and rocket a kick into the middle of the
	     door. It flies back, banging loudly into the wall and
	     shuddering back. As it swings back and forth, pained,
	     you feel a bit guilty. Memories of a naughty childhood
	     moment whispers in your ear. You grab the swinging door
	     and steady it, unconsciously giving it a apologetic
	     pat. ";
	    laundryToHallwayDoor.hasBeenKicked = true;
	}
    }
    dobjFor(Attack) remapTo(Kick,self)
;

+groundHallwayToStairwellDoor : LockableWithKey, TimedAutoClosingDoor
    'locked stairwell east e eastern emergency fire door/doorway/east/e/lock*doors' 'door to the stairwell'
    "The hallway ends here at the blue-green reinforced door. In the middle of
     the door is a large, clear sign reading: <BLOCKQUOTE><font
     face='Arial,Geneva,TADS-Sans' color=#ff0000><B>EMERGENCY
     STAIRWELL</B></FONT></BLOCKQUOTE> "
    initiallyOpen = nil
    initiallyLocked = true
    lockStatusObvious = nil
    okayUnlockMsg {
	if(gIobj == hairPin)
	    return 'Though you\'re not sure how to do it, you try
		    picking the lock. To your surprise, after a bit
		    of jiggling and twisting, the door unlocks!
		    ';
	else
	    return '{You/he} unlock{s} the stairwell door. ';
    }
    keyList = [janitorKey,oldFolksHouseKey,hairPin]
    openStatus {
	if(isOpen)
	    return 'It is currently opening, slowly swinging shut';
	else
	    return 'It is closed';
    }
    dobjFor(Read) remapTo(Read, groundHallwayToStairwellDoorSign)
    dobjFor(Kick) {
        check() {
            if(!isOpen) {
                "You kick the door, but it stays solid. Your shins hurt from the
                impact. ";
                exit;
            }
            else {
                "You need not kick the door --- it\' already open. ";
                exit;
            }
        }
    }
    dobjFor(Push) asDobjFor(Open)
    dobjFor(Pull) asDobjFor(Close)
;

++groundHallwayToStairwellDoorSign : Component, Readable '(door) large clear emergency sign/notice' 'sign on the stairwell door'
    readDesc = "The sign on the door reads: <BLOCKQUOTE><font
		face='Arial,Geneva,TADS-Sans'
		color=#ff0000><B>EMERGENCY
		STAIRWELL</B></FONT></BLOCKQUOTE>"
    hideFromAll(action) { return true; }
;

+Decoration
    vocabWords = 'left west western w vaguely familiar familar
		  magritte pipe painting/reproduction/picture/pipe/magritte'
    name = 'picture of a pipe'
    desc = "You think you\'ve seen this picture somewhere famous,
	    but you\'re guessing this one is a reproduction. It is a
	    painting of a pipe with the words <Q>Ceci n\'est pas une
	    pipe</Q>. Your French is too rusty to translate it. "
    initNominalRoomPartLocation = groundHallwayNorthWall
    collectiveGroup = groundHallwayPictureGroup
;

+Decoration
    vocabWords = 'unfamiliar odd plain right east eastern e abstract
		  painting/picture/purgatory/hell/heaven'
    name = 'abstract painting'
    desc = "This painting seems to be the work of an unknown artist.
	    The canvas is a long rectangle with a simple wooden
	    frame. The left of the image is seething reds and
	    oranges, slowly transitioning into cold, unfeeling blues
	    as it passes to the right, finally ending in glorious
	    gold and white. The three sections are labelled
	    <q>Inferno</q>, <q>Purgatorio</q>, <q>Paradiso</q>. The
	    lettering in <q>Inferno</q> is jagged and angular, in
	    <q>Purgatorio</q> it is regular and unadorned, and
	    <q>Paradiso</q> the letters are suitably
	    calligraphic.<.p>If you peer closely, you can see three
	    abstract human forms walking towards the right: one
	    beating his breast, the next sulking and shuffling
	    along, and the final one bounding joyously. A small
	    copper plaque in the bottom of the frame reads:
	    <q>Rivelare Il Futuro</q> You have no idea what it means."
    initNominalRoomPartLocation = groundHallwayNorthWall
    collectiveGroup = groundHallwayPictureGroup
;

groundHallwayPictureGroup : CollectiveGroup
    vocabWords = 'decorative obligatory scattering paintings/pictures/scattering'
    name = 'decorative paintings'
    desc = "Two paintings hang in the dim hallway, both on the north
	    wall, one at the west end and the other at the east end.
	    The western painting is vaguely familiar while the
	    brightly-coloured, abstract one to the east is not. "
    isCollectiveAction(action,whichObj) {
	return (action.ofKind(ExamineAction));
    }
;

groundHallwayNorthWall : defaultNorthWall
    vocabWords = 'north n northern wall/north/n*walls'
    name = 'north wall'
    desc = "The north wall is covered in a cheap pin-striped cream
	    wallpaper. A few obligatory paintings have been hung
	    along the wall, in an effort to convey the image of
	    style. "
;

groundHallwaySouthWall : defaultSouthWall
    vocabWords = 'south s southern wall/south/s*walls'
    name = 'south wall'
    desc = "The pin-striped cream wall to the south is more plain
	    than the one to the north. The only interesting feature
	    is a swinging door. "
;

groundHallwayCarpet : defaultFloor
    vocabWords = 'ground/carpet/floor/down/d'
    name = 'carpet'
    desc = "UNIMPLEMENTED YET."
;

groundHallwayCeiling : defaultCeiling
    vocabWords = 'ceiling/roof/up/u'
    name = 'ceiling'
    desc = "UNIMPLEMENTED YET."
;




groundStairwell : StairwellRoom
    name = 'Ground Floor Stairwell'
    destName = 'ground floor stairwell'
    desc = "The stairwell is your usual spartan concrete fire
	    escape, lit with cold fluorescent lights. The stairs
	    only lead up (as indicated by the sign). Alternatively,
	    you can walk out into the hallway to the west. "
    west = groundStairwellToHallwayDoor
    up = groundStairwellUp
    east asExit(up)
;

// I removed Lockable from the door so you didn't have to unlock it to go through it.

+groundStairwellToHallwayDoor : Door ->groundHallwayToStairwellDoor
    'out west w western hallway door/doorway/out/west/w/exit' 'door to the ground floor'
    "This blue-green reinforced door seems to be the way out to the
     ground floor, as indicated by the sign on it. It has a standard
     bar handle that you can just lift up to unlock the door. "
    initiallyOpen = nil
    initiallyLocked = true
    dobjFor(Read) remapTo(Read,groundStairwellToHallwayDoorSign)
;

++groundStairwellToHallwayDoorSign : Component, Readable
    '(door) large clear emergency sign/notice' 'sign on the stairwell door'
    readDesc = "The sign on the door reads: <BLOCKQUOTE><font
		face='Arial,Geneva,TADS-Sans'><B>GROUND FLOOR
		</B></FONT></BLOCKQUOTE>"
;

++Component
    '(door stairwell) standard metal bar handle/bar' 'metal bar handle for the stairwell door'
    "The metal bar handle is easy to operate - just pull up and the
     door is opened. "
    dobjFor(Pull) remapTo(Open,groundStairwellToHallwayDoor)
    dobjFor(Push) remapTo(Open,groundStairwellToHallwayDoor)
    dobjFor(Open) remapTo(Open,groundStairwellToHallwayDoor)
;

+groundStairwellSign : Readable, Fixture 'shiny metal sign/arrow' 'sign'
    desc = "A shiny metal sign indicating that this is the ground
	    floor. From here you can go up the stairs to the first
	    floor or out onto the ground floor. "
    readDesc = "An arrow points up the stairwell with the label:
		<Q>First</Q> while another points west indicating
		<Q>Ground</Q>."
;

+groundStairwellFluoro : Fixture
    vocabWords = 'stairwell fluoro fluorescent flouro flourescent light/lights/fluoro/fluoros/flouro/flouros'
    name = 'fluorescent lights'
    desc = "It's just standard fluorescent lighting. Bright lights
	    ceased being entertaining for you many years ago. "
    brightness = 4
;

++groundStairwellFluoroHum : SimpleNoise 'hum/humming/buzz/buzzing' 'hum of the fluorescent lights'
    desc = "The fluorescent lights buzz softly. "
    isQualifiedName = true
;

+groundStairwellUp : StairwayUp, TravelMessage 'east/e/u/up/stairway/stairwell/stairs/stair' 'stairs leading up'
    "The simple concrete stairs lead up to the first floor. "
    travelDesc = "You slowly make your way up the concrete stairs,
		  the clopping of your footsteps echoing throughout
		  the stairwell."
;
