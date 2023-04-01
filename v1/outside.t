#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//----------------//
//  The Alleyway  //
//----------------//


//
// Western alleyway
//

westernAlleyway: Alleyway
    name = 'End of the Alleyway'
    destName = 'the end of the alleyway'
    desc = "The alleyway ends abruptly here as the building to the
	    south (where you have come from) turns north to nestle
	    itself between two other buildings. There isn't as much
	    rubbish here as the rest of the alleyway to the east,
	    but that\'s relative. However, there is enough grime to
	    make up for it. <.p> To the south and west the base of the
	    walls are dirty windows, although the southern ones are
	    so short to be almost useless. "
    east = centralAlleyway
    west = westernAlleywayWindows
;

+westernAlleywayWindows: Window, TravelMessage
    vocabWords = 'dirty grimy west western w window/windows/windowsill/sill/glass'
    name = 'windows to the west'
    desc {
	if (!isBroken) {
	    "Set into the base of the western wall are a set of
	     <<isClean ? '' : 'dirty,'>> scratched windows. A
	     crack squiggles across one of the panes.<.p> ";
	    if (isClean)
		"Peering through them reveals only murky shapes that
		 lie in the underground room beyond. ";
	    else
		"You can\'t see much through the grime encrusted on
		 the window. ";
	}
	else {
	    if (isCleared)
		"The windows set into the base of the western wall
		 have been smashed and cleared out. You still can\'t
		 see much in the room beyond, but you can smell a
		 certain staleness above the odours of the alleyway.";
	    else
		"The windows to the west have been smashed and the
		 broken shards of glass litter the window sill and
		 the surrounding ground. The facade of broken glass
		 and darkness beyond is a little creepy. ";
	}
    }
    cannotTravel() { reportFailure(cannotGoThatWayMsg); }
    cannotGoThatWayMsg = 'You\'re no David Copperfield --- you\'ll
			  need to break the glass or something to
			  get through. '
    isClean = nil
    isOpen = (isBroken)
    isCleared = nil
    isBroken = nil
    /*isConnectorApparent(origin, actor)
    {
        if (isOpen) {
	    return inherited(origin, actor);
        }
        else
        {
            return nil;
        }
    }*/
    travelDesc = "Watching carefully for any more broken glass, you
		  slide yourself through the window into the dark
		  room below. "
    breakMsg = "You look along the empty alleyway, and once you are
		sure you are still alone, you quickly smash open the
		window with the toe of your boot. Most of the glass
		falls into the room beyond with a muffled crash and
		tinkle. The alleyway grows quiet again. Apparently
		no-one heard it. "
    //travelBarrier = [alleywayWesternWindowBarrier]
    dobjFor(Kick) asDobjFor(Break)
    dobjFor(Clean) {
	verify() {}
	check() {
	    if(isClean) {
		"{You/he} do{es}n\'t think {you/he} can get the
		 window any cleaner (given the surroundings). ";
		exit;
	    }
	    if(isBroken) {
		replaceAction(Clear,gDobj);
	    }
	}
	action() {
	    "{You/he} vigorously rub{s} the window clean of the
	     grime and muck. {Your/his} hand ends up with all the
	     gunk, so {you/he} wipe{s} them on the wall. ";
	    isClean = true;
	}
    }
    dobjFor(TravelVia) {
	check() {

	    // To stop weirdos carting the bin around
	    if(outsideTrashCan.isIn(gPlayerChar)) {
		tryImplicitAction(Drop,outsideTrashCan);
		"The garbage bin will never fit through the window,
		 so you leave it in the alleyway. ";
	    }
	    inherited();
	}
	action() {
	    if(!isCleared)
		tryImplicitActionMsg(&announceImplicitAction,Clear,gDobj);
	    // If we failed this implicit action, jump out
	    if(!isCleared)
		exit;
	    inherited();
	}
    }
    dobjFor(Clear) {
	verify() { logical; }
	check() {
	    if(!isBroken) {
		"{You/he} cannot clear away the windows when they
		 are still in their frames. ";
		exit;
	    }
	    if(isCleared) {
		"The broken glass has already been sufficiently cleared away. ";
		exit;
	    }
	}
	action() {
	    mainReport('You fling a few large pieces of glass away and with
	     your jacket sleeve, you clear a small, safe path
	     through the window. ');
	    isCleared = true;
	}
    }
;


+ westernAlleywaySmallWindows: Decoration
    vocabWords = 'south s southern small narrow short basement windows/window'
    name = 'narrow windows to the south'
    desc = "The sealed windows sunk deep into the base of the
	    southern wall are barely a few inches high and are
	    terribly dirty. You wonder why someone would bother
	    installing them. Actually, those grimy windows look a
	    lot like the windows in the basement where you came
	    to... "
    dobjFor(Break) {
	verify() { logicalRank(60,'is breakable'); }
	check() {
	    "The windows are so small, it\'d be not worth your while. ";
	    exit;
	}
    }
    dobjFor(Clean){
	verify() { logicalRank(90,'is cleanable but we like the other window more'); }
	check() {
	    "The windows to the south are so small and dirty, you
	     hardly see the point. ";
	    exit;
	}
    }
;

//
// Central alleyway
//

centralAlleyway: Alleyway
    name = 'Dirty Alleyway'
    destName = 'the alleyway'
    desc = "You find yourself in a slightly broad alleyway running
	    east-west. The soot-stained brick walls are streaked
	    with rust stains and mould, decorated with a few
	    obligatory spritzes of graffiti. A jumbled pile of
	    garbage sits against the north wall, and reeks of a
	    diverse array of mixed unpleasant odours. Water from
	    various drainpipies and the occasional rain storm has
	    soaked through the refuse, creating an ooze that has
	    creeped across the alleyway making the ground underfoot
	    slippery. Some of the slime has trickled into a few
	    small drains near the base of the walls. Above you hangs
	    a fire escape, and to the south three steps lead up to a
	    reinforced steel door. Otherwise this mess of an
	    alleyway continues both east and west."
    roomParts = [alleywaySlimyGround,centralAlleywayNorthWall,centralAlleywaySouthWall,theSky]
    east = centralAlleywayToEast
    west = centralAlleywayToWest
    south = reinforcedAlleywayDoor
    up = alleywayCatwalk
;

+ SimpleOdor 'smelly reeking garbage/refuse/trash/odors/odours' 'smell of the garbage'
    "The overpowering stench of the garbage hangs in the air here. "
;

+ SimpleNoise 'occasional dripping trickle drain/trickle' 'dripping drain'
    "You can hear the occasional dripping drain amidst the quiet
     trickle of one particular drain that opens over the garbage.
     Other than that, there is an uneasy silence. "
;

+ centralAlleywayToEast : Passage 'eastern east e east/e/alleyway' 'eastern alleyway'
    desc = "The alleyway continues eastwards for a short while
	    before terminating at a fence. "
    destination = easternAlleyway
    hideFromAll(action) { return true; }
    dobjFor(TravelVia) {
	action() {
	    /* Do default stuff */
	    inherited();

	    /* Set slimy ground footprints */
	    alleywaySlimyGround.hasGoneEast = true;
	}
    }
;

+ centralAlleywayToWest : Passage 'western west w west/w/alleyway' 'western alleyway'
    desc = "The alleyway continues westwards before ending in a brick wall. "
    destination = westernAlleyway
    hideFromAll(action) { return true; }
    dobjFor(TravelVia) {
	action() {
	    /* Do default stuff */
	    inherited();

	    /* Set slimy ground footprints */
	    alleywaySlimyGround.hasGoneWest = true;
	}
    }
;

+ reinforcedAlleywayDoor: Door
    vocabWords = 'reinforced steel south southern s huge old big rusted rusty door/doorway/exit/entrance/south/s'
    name = 'reinforced steel door'
    desc = "The huge steel door to the south looks very much like
	    the other side of the door you saw in the back room.
	    This side has its share of rust blotches and cracked
	    blue paint. Someone has recently spray-painted a gang
	    sign on the door, over all the discolorations and
	    cracks. "
    feelDesc = "Chips of blue paint crumble beneath your fingers.
		The cold metal frame is abrasive from the peeling
		paint and the dried rust.\b You look at your fingers
		and brush the junk off."
    tasteDesc = "Didn\'t your mother tell you about eating paint
		 chips?"
    smellDesc = "You gingerly sniff the door, accidentally inhaling
		 a tiny paint fleck. You stagger backwards, trying
		 to sneeze. After thrashing about for a little
		 while, you blow it out and stand back, rubbing your
		 nose. "
    isLocked = true
    isOpen = nil
    hasBeenKnockedOn = 0
    keyList = []
    dobjFor(Open) {
	check() {
	    "You try to push open the door but it barely rattles in
	     response.";
	    exit;
	}
    }
    dobjFor(UnlockWith) {
	check() {
	    "Even if that could actually unlock the door, the lock
	     has been plugged up with a decades-old, rock-hard piece
	     of chewing gum. Nevertheless, you have little faith
	     that you have, or even could have, the appropriate key.
	     ";
	}
    }
    dobjFor(KnockOn) {
	action() {
	    switch(hasBeenKnockedOn) {
	      case 0:
		"You knock on the metal door, hurting your knuckles.
		 What's worse it that you doubt anyone heard it. ";
		hasBeenKnockedOn += 1;
		break;
	      case 1:
		"Being more careful this time, you bash on the door
		 with your fist. The dull thumps go unanswered. ";
		hasBeenKnockedOn += 1;
		break;
	      case 2:
		"You thump on the door with your fist. The echoes
		 die away, yet no-one answers the door. ";
		hasBeenKnockedOn = rand(2)+1;
		break;
	      case 3:
		"You slap on the door several times, to no avail. ";
		hasBeenKnockedOn = rand(2)+1;
		break;
	    }
	}
    }
    dobjFor(Kick) {
	verify() {}
	check() {}
	action() {
	    "The reinforced steel door shrugs off the kick. You\'re
	     thinking maybe you need to escalate to thermonuclear
	     approaches to get through. ";
	}
    }
;

++Decoration 'gang sign' 'gang sign'
    "The gang sign comprises of two interlinked figure-eights
     painted in plain black. To the lower-right is the initials
     <q>TS</q> in the popular angular balloon style. "
;

+ centralAlleywaySlime: Decoration
    vocabWords = 'oozing garbage rubbish slimy slime/muck/ooze/gunk/concrete'
    name = 'slime'
    desc = alleywaySlimyGround.desc
    tasteDesc = "Dear God, no! You have more sense than to lick
		 <I>the slime off the ground!</I> "
    feelDesc = "You warily slide your fingertips through the slime.
		The greyish-brown sludge sticks to your fingers and
		you twist your mouth in revulsion. You hurriedly
		shake the slime off your finger and wipe the
		residual on the wall. "
    smellDesc = "You're not sure you can differentiate between the
		 stink of the slime and the garbage. After all, the
		 slime is just the liquid form of the garbage. "
    soundDesc = "Try as you might, you cannot hear the slow march
		  of the slime across the alleyway. "
    dobjFor(Clean) {
	verify() {}
	check() {
	    "There are more futile activities around, but not many. ";
	    exit;
	}
    }
    dobjFor(Eat) {
	preCond = [touchObj]
	verify() {}
	check() {
	    "Have you gone completely mad?! This is <I>slime</I>, on
	     the <I>ground</I>, in a <I>disgusting alleyway!</I> ";
	    exit;
	}
    }
    dobjFor(Drink) {
	preCond = [touchObj]
	verify() {}
	check() {
	    "Even though the slime is sloppy enough to try to drink,
	     you think you better not. ";
	    exit;
	}
    }
    dobjFor(Wear) {
	verify() {}
	check() {
	    "Scooping up the slime and slathering it all over
	     yourself doesn\'t seem like the smartest idea at the
	     moment. ";
	    exit;
	}
    }
;

+ centralAlleywayDrain: Decoration
    vocabWords = 'drain drain/drainpipe/pipe/drains/drainage/drainpipes/pipes'
    name = 'drainpipes'
    desc = "The pipes that collect runoff from above and drain out
	    into the alleyway are more suggestions of drainage than
	    actual examples of such. They are attached to the brick
	    by a few bolts and a prayer. Some have rusted through,
	    whilst others have buckled in places. "
    isPlural = true
    smellDesc = "The drain\'s smell is a unique blend of mould,
		 muddy water and sharply metallic rust. "
    feelDesc = "The rusty metal is slightly rough. After you remove
		your fingers from the drain, it suddenly shifts and
		you back away before it collapses on you. "
    tasteDesc = "You prefer to guess that it tastes metallic rather
		 than test that theory. "
    soundDesc = "You hear an interesting mix of echoing drips,
		  trickles and the wind whipping past the end of the
		  drain. "
    dobjFor(Climb) {
	verify() {}
	check() {
	    "Although your fall would probably be softened by the
	     garbage piles, you don\'t want to risk climbing the
	     frail pipes. ";
	    exit;
	}
    }
    dobjFor(Pull) {
	verify() {}
	check() {
	    "You think it unwise to pull down the drains. It\'d ruin
	     the whole aesthetic! ";
	    exit;
	}
    }
    dobjFor(LookIn) {
	action() {
	    mainReport('You peer inside the drain, but only see the
			trickle of dirty water. ');
	}
    }
    dobjFor(Drink) {
	verify() {}
	check() {
	    "You look at the dirty water dribbling from the drain
	     and decide not to. ";
	    exit;
	}
    }
    dobjFor(Enter) {
	verify() {}
	check() {
	    "You\'ve seen too many movies involving magic
	     leprechauns... ";
	    exit;
	}
    }
    dobjFor(Detach) remapTo(Pull,self)
    dobjFor(Unfasten) remapTo(Pull,self)
    dobjFor(GetIn) remapTo(Enter,self)
;

+ centralAlleywayGarbage: Immovable
    vocabWords = 'pile mound smelly dirty garbage/trash/rubbish/refuse/junk'
    name = 'pile of garbage'
    desc = "For whatever reason, someone chose this area to dump
	    their refuse and everyone else has followed suit. The
	    mound of garbage consists of table scraps, plastic bags
	    spilling out their junky insides, torn up boxes, smashed
	    up furniture and mind-bogglingly unidentifiable other
	    stuff. The whole mess is sodden with water spilled onto
	    it by the drains. A vacation site only Oscar the Grouch
	    could love. "
    isMassNoun = true
    hasBeenSearched = nil
    smellDesc = "You take a big whiff of the garbage and are
		 rewarded with nothing either unexpected or
		 appealing. "
    feelDesc = "Just as you expected - it feels like squishy, slimy,
		dirty garbage. "
    tasteDesc = "You wouldn\'t taste the garbage on a dare. "
    soundDesc = "You put your ear near the garbage, expecting to
		  hear the ocean. No wait, that\'s seashells. "
    dobjFor(Climb) {
	verify() {}
	check() {
	    "This is one mountain you wouldn\'t want to conquer.";
	    exit;
	}
    }
    dobjFor(Eat) {
	preCond = [touchObj]
	verify() {}
	check() {
	    "You are neither a goat nor a contestant on a reality TV
	     show. You leave the garbage uneaten. ";
	    exit;
	}
    }
    dobjFor(Clean) {
	verify() {}
	check() {
	    "Although your civic pride is admirable, you doubt you
	     could do much better than relocating the garbage from
	     here to somewhere nearby. It isn\'t worth the effort. ";
	    exit;
	}
    }
    dobjFor(Take) {
	verify() {}
	check() {
	    "Seriously, you can\'t possibly want to carry around any
	     of this junk. It doesn\'t even have sentimental value! ";
	    exit;
	}
    }
    dobjFor(Search) {
	verify() {}
	check() {
	    if (self.hasBeenSearched)
		"You have searched through the garbage as much as
		 you can stomach. ";
	}
	action() {
	    mainReport('You gingerly poke through the refuse, hoping
			to find something worthwhile. You were too
			hopeful. ');
	    self.hasBeenSearched = true;
	}
    }
    dobjFor(Poke) {
	verify() {}
	action() {
	    mainReport('You prod the garbage with your shoe but you
			don\'t uncover anything interesting (or
			appetising). ');
	}
    }
    dobjFor(Kick) {
	verify() {}
	action() {
	    mainReport('You give the garbage a hefty booting, but
			are rewarded only with a dull squish. You
			wipe a piece of junk off your shoe onto the
			wall. ');
	}
    }
    dobjFor(Punch) {
	verify() {}
	check() {
	    "You think about giving the garbage a bunch of fives,
	     but figure it\'d probably give you tetanus in return. ";
	    exit;
	}
    }
    dobjFor(Attack) remapTo(Kick,self)
    dobjFor(Enter) {
	verify() {}
	check() {
	    "Even if there was some hidden pathway underneath all
	     that rubbish (which there isn\'t), you feel that
	     burying yourself in the garbage is A Bad Thing(tm). ";
	    exit;
	}
    }
    dobjFor(Wear) {
	verify() {}
	check() {
	    "You already have a fine set of clothes and don\'t need
	     to resort to wearing slimy, rotten plastic bags. ";
	    exit;
	}
    }
    dobjFor(SitOn) {
	verify() {}
	check() {
	    "The squishy garbage might be comfortable, but you
	     figure you wouldn\'t want an embarrassing smudge on the
	     seat of your pants. ";
	    exit;
	}
    }
    dobjFor(Clear) remapTo(Clean,self)
    dobjFor(LookThrough) remapTo(Search,self)
    dobjFor(GetIn) remapTo(Enter,self)
    dobjFor(SitIn) remapTo(Enter,self)
    dobjFor(GetUnder) remapTo(Enter,self)
    dobjFor(StandOn) remapTo(Climb,self)
    dobjFor(Push) remapTo(Poke,self)
;

+ centralAlleywayGraffiti: Readable, Decoration
    vocabWords = 'spritz spray various scattered graffiti/graffitti/grafiti/grafitti/writing'
    name = 'graffiti'
    desc = "In the usual weird style of the <q>street-artist</q>, the
	    graffiti is made up of various <q>tags</q>, some readable
	    some not. A few of the pieces of graffiti look to be
	    quite old and have faded substantially. "
    readDesc { say(graffitiList.getNextValue()); }
    graffitiList : ShuffledList {
	valueList = [ 'One slapdash effort in red looks like it
		       says, <q>murder.com</q>. ',
		     'In one corner someone has painted a doped-up
		      looking smiley face with suggestive
		      lackadaisical soft lines. ',
		     'In several little nooks and crannies, someone
		      has used a marker to write their tag but you
		      have no idea what it says. Maybe the guy\'s
		      name is <q>Wiggly line</q>? ',
		     'Someone has prominently sprayed <q>FACK</q> on
		      the south wall. Weird. ',
		     'An immature someone has spray-painted a woman
		      near the garbage in a very unsubtle pose. ',
		     'The number <q>777</q> has been sprayed up high
		      in Kermit the Frog green. ',
		     'On a large piece of piping you barely make out
		      some small, rambling essay written on with a
		      marker. You think it\'s something about the
		      government and other scoundrels. '] }
    feelDesc = "The graffiti (unsurprisingly) feels like the surface
		it was painted on. Some of the paint is smeared on
		your fingertips but you rub it off. "
    tasteDesc = "If you find yourself in a back alley licking old
		 paint, you may want to take stock of your life. "
    smellDesc = "The paint smell is long gone and would still be
		 overpowered by the garbage even if it hadn\'t."
    soundDesc = "You listen to what the graffiti has to say
		  (metaphorically) but decide not to follow up on
		  its crude directions. "
    dobjFor(Clean) {
	verify() {}
	check() {
	    "Your civic pride is admirable, but cleaning up one
	     scrap of graffiti here would leave countless more
	     unassailed. Plus, if you want to be do something for
	     your community you should do it where everyone can see
	     you doing it. ";
	    exit;
	}
    }
    dobjFor(Attack) {
	verify() {}
	action() {
	    mainReport('<q>Mess up my buildings, eh? Take that!</q> you shout,
			assailing the wall. The graffiti seems unaffected by
			your well-intentioned attack. ');
	}
    }
    dobjFor(Kick) remapTo(Attack,self)
    dobjFor(Punch) remapTo(Attack,self)
;

+ Platform, Decoration
    vocabWords = 'three 3 small squat concrete few stairs/steps'
    name = 'small steps leading up to the door'
    desc = "Three squat concrete steps lead up to the reinforced
	    door to the south. The stairs themselves are
	    unremarkable - their most interesting features are the
	    scuff marks and chips in the concrete. "
    isQualifiedName = true
    feelDesc = "You run your fingers along the rough surface of the
		stairs, leaving a (relatively) clear line through
		the dust. "
    soundDesc = "You wait patiently for the steps to make some
		  noise. You eventually stop, disappointed but
		  unsurprised. "
    tasteDesc = "Alleyway stairs are a delicacy you choose to be
		 ignorant of. "
    smellDesc = "You can\'t smell anything over the pungent aroma of
		 the garbage. "
;

// The catwalk (kinda)

+alleywayCatwalk : OutOfReach, TravelWithMessage, Passage ->firstCatwalkLadderDown
    vocabWords = 'fire catwalk/up/escape/ladder'
    name = 'fire escape'
    desc = "A solid fire escape hangs off the main building,
	    <<alleywayCatwalk.isLadderDown ? 'dangling a ladder
	    within your reach. ' : 'many metres beyond your reach.
	    You\'ll have to find another way upstairs. '>> "
    specialDesc {
	if(isLadderDown)
	    "The ladder to the fire escape hangs off to one side of
	     the alleyway, next to the reinforced door to the south.
	     ";
	else
	    "Three steps lead southwards to a reinforced steel door.
	     Many metres above it hangs a fire escape with a
	     drawn-up ladder. ";
    }
    isLadderDown = (firstCatwalkLadderDown.isLadderDown)
    isOpen = isLadderDown
    travelDesc = "With the assistance of the brick wall, you hoist
		  yourself onto the ladder and clamber up to the
		  first floor fire escape. "
    feelDesc = "The ladder is made out of heavy-duty, rust-proof
		steel. The rough surface is cold to the touch. "
    tasteDesc = "Hmm... An interesting combination of dirt and metal
		 with just a hint of--- wait a second... This ladder
		 tastes exactly as you\'d expect: awful! "
    smellDesc = "It smells... laddery. "
    travelBarrier = alleywayCatwalkBarrier
    canObjReachSelf(obj) { return isLadderDown;}
    hideFromAll(action) { return action not in (ExamineAction,LookAction,SmellAction,FeelAction,TasteAction); }
    iobjFor(ThrowAt) {
	verify() { logical; }
	check() {
	    if(gDobj == gPlayerChar && !isLadderDown) {
		"Even if you could get around the logistical paradox in launching yourself, you
		 couldn\'t throw something as heavy as yourself at
		 the ladder. ";
		exit;
	    }
	    if(gDobj == gPlayerChar) {
		"Knocking yourself out is probably the least useful
		 thing you could do here. And the least sane. ";
		exit;
	    }
	}
	action() {
	    if(isLadderDown)
		'';
	    else
		if(gDobj.weight > 5)
		    firstCatwalkLadderDown.isLadderDown = true;
	}
    }
    dobjFor(Climb) asDobjFor(TravelVia)
    dobjFor(ClimbUp) asDobjFor(Climb)
    dobjFor(GetOn) asDobjFor(Climb)
;

alleywayCatwalkBarrier : TravelBarrier
    canTravelerPass(traveler) {
	// The "You can't do that" method
	//return !outsideTrashCan.isIn(traveler);

	// The implicit drop action method
	if(outsideTrashCan.isIn(traveler))
	    tryImplicitActionMsg(&announceImplicitAction,Drop,outsideTrashCan);
	return true;
    }
    explainTravelBarrier(traveler) { "It would be dangerous (and
				      nigh on impossible) to try to
				      ascend the ladder whilst
				      holding the garbage can. "; }
;

//
// Eastern alleyway
//

easternAlleyway: Alleyway
    name = 'Fenced end of the alleyway'
    destName = 'the alleyway'
    desc = "This section of the backstreet is a little less
	    rubbish-ridden than the areas to the west, mostly
	    because it is not quite a pocket for garbage to collect
	    in, and partly because of luck. The alleyway continues
	    on to the east before turning south to somewhere
	    brighter, to the main street you guess. But you may find
	    out because a high chain-link fence cuts across the
	    alleyway to your immediate east. Alternatively, to the
	    north is the rear entrance of some building, or you can
	    revisit the refuse to the west."
    smellDesc = "Sporadic breezes wending their way from the east
		 whisk away the stench of the rubbish, but replace
		 it with the cold, lifeless smell of concrete. "
    soundDesc = "Other than faint dripping to the west and the
		  gentle whistle of wind through the fence, this
		  place is oddly quiet. Not even a whisper of
		  traffic or the commotion of the city. Weird. "
    west = centralAlleyway
    east : NoTravelMessage { "You can\'t venture eastwards with that fence blocking your way! "; }
    north {
	if(!alleywayToSmallRoomDoor.isLocked)
	    return alleywayToSmallRoomDoor;
	else {
	    if(alleywayWindow.isOpen)
		return alleywayWindow;
	    else
		return nil;
	}
    }
;

+ chainlinkFence: Fixture
    vocabWords = 'steel chain chain-link chainlink wire eastern east e fence/barrier/enclosure/east/e'
    name = 'chain-link fence'
    desc = "The fence spreads from wall to wall with no gaps either
	    side. The chain-links have been weathered somewhat, but
	    remain resilient. They all remain strongly welded to the
	    metal frame and give no opportunity to squeeze through.
	    What\'s worse is the menacing rows of barbed wire strung
	    across the top. The definite impassability of the whole
	    fence is disheartening. "
    smellDesc = "You catch a whiff of some of the breezes whistling
		 through the fence. All smell like bland, cold
		 concrete."
    soundDesc = "The breeze whistles through the fence as though it
		  had nothing better to do. The fence clinks as it
		  sways in the occasional stronger gusts. "
    tasteDesc = "You cautiously and quickly lick to a seemingly
		 clean section of the fence. The steel taste is
		 unsatisfying and you feel foolish. "
    pullMsgs : ShuffledList { valueList = ['You shake the fence to only dramatic effect. ',
					   'The fence merely rattles at your attempts to get through. ',
					   'The fence is unaffected by your passionate assault. ',
					   'Try as you might, the fence will not yield to your might and fury. '] }
    dobjFor(LookThrough) {
	verify() {}
	action() {
	    mainReport('The backstreet continues eastwards for about
			thirty feet before turning south to the
			sunshine of the main street. ');
	}
    }
    dobjFor(LookBehind) remapTo(LookThrough,self)
    dobjFor(Pull) {
	verify() {}
	action() {
	    say(pullMsgs.getNextValue());
	}
    }
    dobjFor(Attack) remapTo(Pull,self)
    dobjFor(Kick) remapTo(Pull,self)
    dobjFor(Punch) remapTo(Pull,self)
    dobjFor(Push) remapTo(Pull,self)
    dobjFor(Climb) {
	verify() {}
	check() {
	    "You could easily climb the fence, if it weren\'t for
	     the vicious barbed wire at the top. ";
	    exit;
	}
    }
    dobjFor(GetUnder) {
	verify() {}
	check() {
	    "The gap underneath the fence is barely an inch high,
	     and let\'s be honest, your attempts at dieting haven\'t
	     been <I>that</I> successful. ";
	    exit;
	}
    }
    dobjFor(LookUnder) {
	verify() {}
	action() {
	    mainReport('Between the metal frame and the concrete
			there is a gap of about an inch high. ');
	}
    }
    dobjFor(Unscrew) {
	verify() {}
	check() {
	    "The fence has been bolted onto the brick wall,
	     preventing any attempt to remove it. ";
	    exit;
	}
    }
    dobjFor(UnscrewWith) remapTo(Unscrew,self)
    dobjFor(Remove) remapTo(Unscrew,self)
    dobjFor(Detach) remapTo(Unscrew,self)
    dobjFor(DetachFrom) remapTo(Unscrew,self)
    iobjFor(PutUnder) {
	verify() {}
	check() {
	    "Even if {the dobj/him} could fit underneath the fence,
	     you wouldn\'t be able to get it back, so you decide
	     against it. ";
	    exit;
	}
    }
    iobjFor(PutBehind) {
	verify() {}
	check() {
	    "Even if that could fit through the fence, you wouldn\'t
	     be able to retrieve it. You decide to keep
	     {the dobj/him}. ";
	    exit;
	}
    }
    iobjFor(ThrowThrough) remapTo(PutBehind,DirectObject,self)
    iobjFor(ThrowBehind) remapTo(PutBehind,DirectObject,self)
    iobjFor(PutIn) remapTo(PutBehind,DirectObject,self)
    dobjFor(Break) {
	verify() {}
	check() {
	    "Maybe if you were The Hulk then you could smash down
	     the fence, but we wouldn\'t want to see you when
	     you\'re angry. ";
	    exit;
	}
    }
;

+alleywayWindow : Window, TravelMessage
    vocabWords = 'side glass window/glass'
    name = 'window'
    desc {
	if(isBroken)
	    "Immediately to the right of the back door is a
	     now-smashed window. Through the remaining shards, you
	     can see a murky room beyond. ";
	else
	    "Immediately to the right of the back door is a dusty
	     window, presumably to the same room beyond. ";
    }
    travelDesc = "Careful of the broken glass, you clamber through
		  the window into the room beyond. "
    isBroken = nil
    breakBehaviour = breakRemain
    breakMsg = 'Using {your/his} sleeve as protection, {you/he}
		smash{es} the window open with {your/his} elbow. '
    throwThroughables = [outsideTrashCan,statuette]
    iobjFor(ThrowAt) {
	verify() { logical; }
	check() {
	    if(gDobj == me) {
		"As often as you\'ve seen it done in the movies,
		 you\'d be best playing it safe and not hurling
		 yourself headlong through the window. ";
		exit;
	    }
	    else {

		// Add more heavy objects to V
		if(!throwThroughables.indexOf(gDobj) && !isBroken) {
		    "Throwing that at the window would be
		     ineffectual. ";
		    exit;
		}
	    }
	}
    }
    getHitFallDestination(thrownObj, path){
        if(throwThroughables.indexOf(thrownObj)) {
	    return smallBackRoom.getDropDestination(thrownObj,path);
	}
	else
	    return inherited(thrownObj,path);
    }
    dobjFor(Clean) {
	verify() {}
	action() {
	    "Despite your best efforts, the dust and dirt on the
	     window refuses to be wiped clean, but is quite content
	     on smudging further. ";
	}
    }
;

+outsideTrashCan : RestrictedContainer
    vocabWords = 'battered steel trash garbage rubbish can/bin/tin/receptacle'
    name = 'garbage bin'
    desc {
	if(gActor.location is in (easternAlleyway, centralAlleyway, westernAlleyway))
	    "Considering all the rubbish floating about the
	     alleyway, it seems a bit ironic that the bin is mostly
	     empty. Nevertheless, it is a nice steel garbage
	     receptacle that Oscar the Grouch would find
	     pleasurable. ";
	else
	    "Although a bit battered and dirty, the garbage bin is
	     still going solidly. Oscar the Grouch would be glad to
	     call it his. ";
    }
    initSpecialDesc = "A garbage bin rests on its side underneath
		       the window next to the rear entrance. "
    specialDesc = "A battered garbage bin lies
		   <<location.getNominalDropDestination().inRoomName(true)>>. 
		   "
    okayTakeMsg = 'Grunting slightly, you heft the bin onto your
		   shoulder. '
    okayDropMsg = 'You drop the bin to the ground with a clang. '
    // Stop any Oscar the Grouch shenanagins. Better to patch iobjFor(PutIn) though (for the msgs).
    canPutIn(obj) { return !obj.ofKind(Actor); }
    bulk = 150
    bulkCapacity = 125
    weight = 10
    weightCapacity = 1000
    maxSingleBulk = 50
    throwHitFallMsg(projectile, target, dest) {
        gMessageParams(projectile, target);
	if(target == alleywayWindow) {
	    if(!alleywayWindow.isBroken) {
		alleywayWindow.makeBroken(true);
		return 'You fling {the dobj/him} through the window,
			resulting in a satisfying crash of glass.
			{The dobj/he} continued all the way through
			to the room beyond, leaving the glass to
			tumble and shatter behind it. You
			instinctively look around, expecting the
			cops or angry residents to come chasing
			after you, but only a cold wind drifts
			through the alleyway, sending a scrap of
			paper skipping along like a tumbleweed.
			';
	    }
	    else
		return 'You fling {the dobj/him} through the broken
			window. It sails through, clipping a finger
			of glass on the way through, snapping it
			off. You hear {it/him} bounce and clatter
			along the floor inside. ';
	    }
	else {
	    if(target == smallBackRoomWindow) {
		if(!smallBackRoomWindow.isBroken) {
		    smallBackRoomWindow.makeBroken(true);
		    return 'With a malicious grin, you fling the
			    garbage bin at the window. It punches
			    through with a tremendous shattering of
			    glass, followed by the crash and clatter
			    of the bin landing on the concrete
			    outside. Some primal thirst inside you has
			    been slaked. ';
		}
		else
		    return 'You fling {the dobj/him} through the
			    broken window. It sails through the
			    window, crashing loudly on the alleyway
			    concrete outside. ';
	    }
	    else {
		if(target == westernAlleywayWindows || target == westernAlleywaySmallWindows)
		    return '{The target/he} is too small to hit with
			    {the dobj/him}, but bounces off the
			    nearby wall, crashing noisily to the
			    ground. ';
		else {
		    if(target == alleywayCatwalk)
			return 'Like an Olympic hammer thrower, you
				spin the trash can round and round,
				slowly gaining momentum. At the
				right moment you release it and it
				sails through the air, colliding
				with the fire escape. The whole
				structure clangs and shudders,
				accompanied by the tremendous crash
				of the trash can hitting the ground.
				The fire escape rattles around so
				much that the ladder jumps out of
				its lock and drops down screeching
				and crashing to a halt at the
				bottom. You are still wincing as the
				reverberations echo down the
				alleyway. High above you you hear
				some Italian yell, <q>Shaddup you
				stupid kids!</q>';
		    else
			return '{The projectile/he} hit{s} {the
				target/him}, bounces off and crashes
				noisily ' +	dest.putInName + '. ';
		}
	    }
	}
    }
;

+alleywayToSmallRoomDoor : IndirectLockable, Door
    vocabWords = '(back) metal unpainted alcove/door/doorway/north/n'
    name = 'door to the back room'
    desc = "Sunken into a shallow brick alcove is an unpainted metal door
	    alongside a window, both presumably leading into the
	    same place. Patches of rust fringe the door, streaking
	    down the face where the rain probably trickled down. "
    initiallyLocked = true
    shouldntPunchMsg = 'Punching the metal door wouldn\'t be
			worthwhile, and could be injurious. '
    dobjFor(Kick) {
	verify() {
	    if(isOpen)
		illogicalNow('The door is already open. ');
	    if(!isLocked)
		illogicalNow('{You/he} need not kick the door down - it\'s unlocked already.');
	}
	check() {}
	action() {
	    "You steady yourself and kick at the door. It shudders
	     slightly but breaks open under your second kick. The
	     door flings back, cracking into the wall inside and
	     kicking up clouds of dust that churn and eventually
	     settle. ";
	    makeLocked(nil);
	    makeOpen(true);
	}
    }
    dobjFor(KnockOn) {
	verify() {}
	
	action() {
	    "You pound on the door, but the thumps echo emptily. ";
	}
    }
    dobjFor(Punch) asDobjFor(KnockOn)
    dobjFor(LookThrough) {
	verify() {}
	check() {
	    if(!isOpen) {
		"The door is closed, so you cannot see through it. ";
		exit;
	    }
	}
	action() {
	    "Through the door is a shadowy, empty back room. ";
	}
    }
;

SenseConnector, Intangible
    transSensingThru(sense) {
	if(sense==sound && alleywayWindow.isOpen)
	    return obscured;
	else
	    return opaque;
    }
    locationList = [easternAlleyway,smallBackRoom]
    checkMoveThrough(obj, dest) {
	if(alleywayWindow.throwThroughables.indexOf(obj))
	    return checkStatusSuccess;
	else
	    return new CheckStatusFailure(&cannotMoveThroughMsg, obj, self);
    }
; 


//
// The "Fight Club" room
//

smallBackRoom : Room
    name = 'Small back room'
    destName = 'a back room'
    desc {
	if(smallBackRoomWindow.isBroken)
	    "Sunlight streams through the broken window, washing out
	     the gloom. Motes of dust and shards of glass play with
	     the light. Through squinted eyes you glance over the
	     room. It seems twice as long as it is wide, but filled
	     with not a lot of interest. ";
	else
	    "A murky light drifts through the window, lightening the
	     gloom just a little. Once your eyes adjust to the dim
	     light, you survey the room. It seems twice as long as
	     it is wide, but filled with not a lot of interest. ";
    }
    south = smallRoomToAlleywayDoor
;

+smallBackRoomWindow : Window, TravelMessage ->alleywayWindow
    vocabWords = 'side glass window/glass'
    name = 'window'
    desc {
	if(isBroken)
	    "Immediately to the right of the back door is a
	     now-smashed window. Through the remaining shards, you
	     can see a murky room beyond. ";
	else
	    "Immediately to the right of the back door is a dusty
	     window, presumably to the same room beyond. ";
    }
    travelDesc = "Wary of stray glass shards, you grab the window
		  frame with both hands, put a foot on it, and pull
		  yourself through. "
    throwThroughables = (otherSide.throwThroughables)
    isBroken = (otherSide.isBroken)
    nothingThroughMsg = 'With the dust on the window and the
			 darkness of the room beyond, you can\'t see
			 much. '
    makeBroken(val) { otherSide.makeBroken(val); }
    getHitFallDestination(thrownObj, path){
        if(throwThroughables.indexOf(thrownObj))
	    return easternAlleyway;
	else
	    return inherited(thrownObj,path);
    }
    iobjFor(ThrowAt) {
	verify() { logical; }
	check() {
	    if(gDobj == me) {
		"As often as you\'ve seen it done in the movies,
		 you\'d be best playing it safe and not hurling
		 yourself headlong through the window. ";
		exit;
	    }
	    else {

		// Add more heavy objects to V
		if(!throwThroughables.indexOf(gDobj) && !isBroken) {
		    "Throwing that at the window would be
		     ineffectual. ";
		    exit;
		}
	    }
	}
    }
    dobjFor(Clean) {
	verify() {}
	action() {
	    "Despite your best efforts, the dust and dirt on the
	     window refuses to be wiped clean, but is quite intent
	     on smudging further. ";
	}
    }
;

+smallRoomToAlleywayDoor : Lockable, Door ->alleywayToSmallRoomDoor
    vocabWords = '(back) door/doorway/south/s'
    name = 'door to a back room'
    desc {
	if(isOpen)
	    "The rust-streaked door lies open, letting in the light from the alleyway";
	else
	    "The cold metal door is streaked with rust and mottled
	     with grime. You notice a peculiar dark brown spray at
	     about head-height";
    }
    openStatus() { }
    initiallyLocked = true
    lockedDesc = ""
    lockStatusObvious = nil
    dobjFor(LookThrough) {
	verify() {}
	check() {
	    if(!isOpen) {
		"The door is closed, so you cannot see through it. ";
		exit;
	    }
	}
	action() {
	    "A dirty, rubbish-strewn alleyway lies outside. ";
	}
    }
;

++Decoration 'dark brown dried blood spray/splatter/blood' 'dark brown spray'
    desc {
	if(name == 'dark brown spray') {
	    "You aren\'t sure what this spray is. A few small
	     splatters of the same stuff can be found on the wall
	     and in spots on the ground. You peer at it closely. It
	     is crystalline and breaks away at a touch. Actually...
	     it looks like dried blood. You quickly wipe your hand on
	     your shirt and look over the room with distaste. ";
	    name = 'dried blood';
	}
	else
	    "Dried blood has crystallized in various nooks around
	     this room. You wonder what this place is used for. ";
    }
    tasteDesc = "You\'d be best not licking the dried blood. "
    smellDesc = "It doesn\'t have a particularly strong smell. "
    feelDesc = "The crystalline surface breaks away under your fingers. "
;
