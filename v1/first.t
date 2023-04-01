#charset "us-ascii"
#include "adv3.h"
#include "en_us.h"

//-------------------//
//  The First Floor  //
//-------------------//

// define the '+' property
// (we need this only once per source file)
+ property location;

firstStairwell : StairwellRoom
    name = 'First Floor Stairwell'
    destName = 'the first floor stairwell'
    desc = "The first floor stairwell is much the same as the ground floor. In
	    fact, you're willing to bet they're all like that. Architects and
	    their interest in repetition... When will they learn? There is a
	    small sign on the wall and a doorway to the west opening up into a
	    hallway. "
    west = firstStairwellToHallwayDoor
    out asExit(west)
    east : AskConnector {
	promptMessage = "There are two stairways to the east. "
	travelObjs = [firstStairwellUp, firstStairwellDown]
	travelObjsPhrase = 'one of them'
	isConnectorListed = nil
	}
    down = firstStairwellDown
    up = firstStairwellUp
;

+firstStairwellToHallwayDoor : ThroughPassage 'west w door/doorway/out/west/w/exit' 'door to the first floor'
    "The doorway to the first floor is merely a frame. It looks like the door
     and its hinges have been removed and the frame painted over to lend some
     presentability. "
;

+firstStairwellDown : StairwayDown, TravelMessage ->groundStairwellUp 'd/down/stairway/stairwell/stairs/stair' 'stairs going down'
    "The simple concrete stairs lead down to the ground floor. "
    travelDesc = "The lonely echo of your footsteps reverberate around the
		  stairwell as you make your descent. "
;

+firstStairwellSign : Readable, Fixture 'shiny metal sign/arrow' 'sign'
    desc = "A shiny metal sign indicating that this is the first floor. You
	    can go up the stairs to the second floor and down to the ground
	    floor. Ingenious!"
    readDesc = "An arrow points up the stairwell with the label: <Q>Second</Q>.
		Another points down with the label: <Q>Ground</Q>. A third and
		final arrow points out to the hallway to the west indicating
		<Q>First</Q>."
;

+firstStairwellFluoro : Fixture
    vocabWords = 'stairwell fluoro fluorescent flouro flourescent light/lights/fluoro/fluoros/flouro/flouros'
    name = 'fluorescent lights'
    desc = "It's just standard fluorescent lighting. Bright lights ceased being
	   entertaining for you many years ago. "
    brightness = 4
;

++firstStairwellFluoroHum : SimpleNoise 'hum/humming/buzz/buzzing' 'hum of the fluorescent lights'
    desc = "The fluorescent lights hum single-mindedly. "
    isQualifiedName = true
;

+firstStairwellUp : StairwayUp 'up u second level stairwell/stairway/stair/stairs/up/u' 'stairs leading up to the second level'
    desc = "The stairs leading up are much the same as all the
	    others, except that they are covered in water. You guess
	    there might be a leak upstairs. Anyway, walking up these
	    smooth concrete stairs would be downright dangerous
	    whilst still wet. "
    travelBarrier = [firstStairwellUpSlippery]
;

++firstStairwellWater : Component 'puddles stairwell wet water/puddle/puddles' 'puddles of water on the stairs'
    "For some reason, the stairs to the second level are covered in
     a thin sheet of water. The sporadic drips indicate there might
     a leak or something upstairs, but from here, you can\'t tell.
     The smooth concrete and the water would make ascending the
     staircase difficult, if not dangerous. "
;

+++firstStairwellDrippingNoise : Noise 'water drip/dripping/plink'
    sourceDesc = "Sporadically, a drop of water falls from the level
		  above with a resonant <I>plink!</I>. "
    descWithSource = "The water drips from the level above onto the
		      concrete stairs, adding to the puddles. "
    descWithOutSource = "The droplets splatter on the stairs with a
			 soft, dull <I>plunk</I>. "
    hereWithSource = "Sporadic drips of water splash onto the
		      concrete. "
    hereWithoutSource = "Periodic drips of water echo about the
			 stairwell. " 
    displaySchedule = [1,2,2,3]
;

++firstStairwellUpSlippery : TravelBarrier
    canTravelerPass(traveler) {return !isStairsSlippery(); }
    explainTravelBarrier(traveler) { "The wet stairs are currently too slippery to climb! "; }
    isStairsSlippery() { return true; }
;



firstHallway1 : FirstHallwayRoom
    desc = "This is the east end of the first floor's hallway. The
	    hallway continues westwards with its chalky grey paint
	    and wearied rust-coloured carpet before turning
	    northwards to much of the same, presumably. There are
	    two doorways here, leading east and north. The doorway
	    to the east leads into a concrete stairwell. Its
	    fluorescent lighting isn\'t particularly elegant or
	    inviting. <<lunchRoomDoor.isOpen ? 'Almost
	    correspondingly, the room to the north is lit in a
	    dreary green-grey fluorescence. It seems to be a lunch
	    room. The ordinary lighting in the hallway is cosy in
	    comparison. ' : 'In comparison, the ordinary hallway
	    lighting is strangely comforting. The plain blue-grey
	    door to the north is closed. '>> "
    roomParts = inherited + firstHallwaySouth + firstHallwayNorth
    east = firstHallwayToStairwell
    west = firstHallway2
    north = lunchRoomDoor
    in asExit(north)
;

+ firstHallwayToStairwell : ThroughPassage ->firstStairwellToHallwayDoor 'stairway stairwell stairway/stairwell/doorway/door/e/east' 'doorway to the stairwell'
    "The plain metal doorframe punctuates the end of this hallway.
     Through it you see the emergency stairwell. "
;

+ lunchRoomDoor : Door 'n north northern lunch room n/north/door/doorway' 'door to the lunch room'
    "A plain wooden door. It is covered in some cheap grey-blue
     paint that hasn't started to flake yet, but threatens to. There
     is a small sign in the center of the door. "
    initiallyOpen = true
    openStatus {
	if(isOpen)
	    "wide open";
	else
	    "closed";
    }
;

firstHallway2 : FirstHallwayRoom
    desc = "The hallway continues with its worn-dull carpet and its
	    uninspiring chalky-grey walls, bending northwards about
	    five metres west from where you stand. It also proceeds
	    eastwards for a short while, terminating in a plain
	    doorway leading to the stairwell. The only notable
	    things in this section are the two doors leading north
	    and south respectively. <<descTheDoors>> "
    descTheDoors {
	local text;
	if(firstHallwayToOldFolksDoor.isOpen) {
	    if(firstHallwayToAbandonedDoor.isOpen)
		text = 'The open door to the south reveals a cosy little
			apartment, while the northern door opens to a darkened, bare room. ';
	    else
		text = 'The open door to the south reveals a cosy little
			apartment, whereas the door to the north is closed. ';
	}
	else {
	    if(firstHallwayToAbandonedDoor.isOpen)
		text = 'The closed door to the south offers nothing, but to
			the north you can see an empty apartment. ';
	    else
		text = 'However, both are closed. ';
	}
	return text;
    }
    roomParts = inherited + firstHallwaySouth + firstHallwayNorth
    east = firstHallway1
    north = firstHallwayToAbandonedDoor
    south = firstHallwayToOldFolksDoor
    west = firstHallway3
;

+ firstHallwayToOldFolksDoor : LockableWithKey, Door 'south southern s s/south/door/doorway/102' 'door to apartment 102'
    "The southern door is painted in a thick, ruddy brown colour. It
     is fairly plain, and adorned only with the number \'102\'. "
    initiallyOpen = nil
    initiallyLocked = true
    keyList = [oldFolksHouseKey]
;

+ firstHallwayToAbandonedDoor : LockableWithKey, Door 'north n northern n/north/door/doorway/101' 'door to apartment 101'
    "Apart from an errant skid mark along the bottom of the door,
     the door to the north is fairly plain. It is covered in a
     maroon paint and simple metal numerals have been screwed to the
     door, reading \'101\' . "
    initiallyOpen = true
    initiallyLocked = nil
    keyList = []
;

firstHallway3 : FirstHallwayRoom
    name = 'First Floor Hallway Junction'
    destName = 'the bend in the first floor hallway'
    desc = "The hallway bends northwards here. The dull
	    rust-coloured carpet goes both north and east. A few
	    plain doors regularly break up the hallway in both
	    directions. A sticker-strewn apartment door lies
	    directly to the south from here and a set of elevator
	    doors are set into the west wall. "
    roomParts = inherited + firstHallwaySouth + firstHallwayWest
    east = firstHallway2
    north = firstHallway4
    south = firstHallwayToDudeDoor
    west = firstElevatorDoors
    in : AskConnector {
	promptMessage = "There are two doors you can enter. "
	travelObjs = [firstHallwayToDudeDoor, firstElevatorDoors]
	travelObjsPhrase = 'one of them'
	isConnectorListed = nil
	}
;

+firstElevatorDoors : ElevatorDoors
    myCallButton = firstElevatorCallButton
;

+firstElevatorCallButton : ElevatorExteriorButton, Fixture
    myFloor = 1
;

+ElevatorSounds
    openMsg = 'There is a <i>ding!</i> and the elevator doors to the west open. '
    closeMsg = 'With a sigh and a few clanks, the elevator doors slowly close. '
    stopMsg = 'You hear the elevator whine to a halt. '
    movingMsg = 'You hear the elevator rattle past your floor. '
    startMsg = 'The elevator sighs and moves onto another floor. '
;

+firstHallwayToDudeDoor : LockableWithKey, Door 'south s southern s/south/door/doorway/103' 'door to apartment 103'
    "This wooden door has a look of shell-shock to it. It is
     decorated liberally with various fascinating stickers and
     graffiti. The door has a deep cut in the middle of it, the
     wound splintering and cracking. <.reveal hackedDoor>"
    initiallyOpen = true
    initiallyLocked = nil
    keyList = []
;

++outsideDudeDoorStickers : Component, Readable
    vocabWords = '(door) outside various bumper stickers/banners/stick/bumper/comic/cartoon/stamps'
    name = 'stickers on the outside of the door'
    desc {
	if(!described)
	    "Like a college student\'s suitcase gone mad, the door
	     has hundreds of random stickers stuck all over it in a
	     chaotic pattern reminiscent of a shotgun blast. Maybe
	     they deserve a read? ";
	else
	    readDesc;
    }
    readDesc {
	"You peer at the array of decorations on the door, looking
	 for something interesting...\b ";
	say(stickersDesc.getNextValue());
    }
    stickersDesc : ShuffledList {
	suppressRepeats = true
	valueList = [ 'Tucked into a corner of the door is a sticker
		       of some sexy starlet from a teen TV show that
		       you can\'t quite remember the name of.
		       Someone has taken a pen to it and given her
		       lewd additions. A speech bubble says, <Q>I
		       love you Cody!</Q>',
		     'A rather thick patch of stickers seems to be a
		      bunch of softdrink bottle wrappers stuck one
		      on top the other. It looks like Pepsi is
		      winning that cola war at the moment. ',
		     'One fluorescent orange sticker proclaims:
		      <Q>Save the whales, nuke the hippies!</Q> ',
		     'Someone has torn off most of one sticker, but
		      a speech bubble remains. It says, <Q>Don\'t
		      kick the baby!</Q> ',
		     'A picture of Bruce Lee from <i>Enter The
		      Dragon</i> has been stuck on the door with an
		      added caption, <Q>I\'d hit it!</Q> ',
		     'Half obscured by a sticker from some Irish bar
		      is a phone number: 555-3141',
		     'Someone has scratched <Q>Yin and Yang are
		      waiting for you</Q> in the doorframe. ',
		     'A jovial Santa has been attacked with a felt
		      pen. He has been given a thick Saddam Hussein
		      moustache and on his sack of toys someone has
		      written <q>WMDs</q>. ',
		     'A cartoon zombie-green dope-smoker remarks:
		      <Q>TV will rot your brain!</Q> ',
		     'In a drunken scribble someone began writing
		      <Q>Their once wuz a man from Nantucket</Q>,
		      but lost momentum after that line. ',
		     'An upside-down overly-cute manga character
		      remarks: <Q>Ohayoo!!!</Q> ',
		     'Three differently-styled stickers hidden on
		      the top edge of the doorframe create the number
		      \'777\' followed by an arrow pointing upwards. ',
		      'You spy a tiny sticker from an apple near the
		       door handle. It came from a Red Delicious. ']
		     }
;

++dudeDoorCutOutside : Component
    vocabWords = 'splintered deep neat wide hack axe hack/wound/cut/hole/splinters/gouge'
    name = 'deep, splintered cut in the door'
    desc = "Curiously, the door looks like it has survived a deep
	    hack with an axe. Surely this can\'t be the truth, but
	    it begs the question of what this splintered gouge in
	    the door actually is. <.reveal hackedDoor> "
    owner = firstHallwayToDudeDoor
    codyKnown = true
;

firstHallway4 : FirstHallwayRoom
    desc = "The hallway ends here in two doors to the east and west
	    respectively. The wall to the north is blank, as though
	    it should be decorated with a pot plant or something,
	    but hasn\'t yet. The rest of the hallway lies south
	    where it bends to the east after passing the elevator. "
    roomParts = inherited + firstHallwayWest + firstHallwayEast
    south = firstHallway3
    west = firstHallwayToJJDoor
;

+ firstHallwayToJJDoor : Door ->jjFrontDoorToHallway
    vocabWords = 'west western w door/west/w'
    name = 'door to the west'
    desc = "UNIMPLEMENTED YET"
    initiallyLocked = true
    initiallyOpen = true
;

+ firstHallwayToLockedApartmentDoor : LockableWithKey, Door
    vocabWords = 'east eastern e door/east/e'
    name = 'door to the east'
    desc = "UNIMPLEMENTED YET"
    initiallyOpen = nil
    initiallyLocked = true
;

firstCatwalkSouth : Room
    name = 'Fire escape over the Alleyway'
    destName = 'the fire escape over the alleyway'
    desc = "The hard iron frame of the fire escape hangs a good few
	    metres above the mess of the alleyway below. It feels
	    sturdy enough, although you\'re not confident to jump
	    around too heavily, say. In any case, you keep a hand on
	    the edge of the <<catwalkToAbandonedWindow.isOpen ? 'open' : ''>>
	    window to the south. If you\'re feeling a little daring,
	    you could climb to a higher level of the fire escape.
	    A narrow ledge hugs the wall to the west which offers
	    an even more dangerous option. "
    roomParts = [catwalkFloor, defaultSky]
    hasJumped = nil
    roomBeforeAction() {
	if(gActionIs(Jump)) {
	    if(hasJumped) {
		"Jumping again might be bad for the health of the
		 fire escape, and by extension, bad for yours. ";
		exit;
	    }
	    else {
		"You leap up and land heavily on the mesh floor. The
		 fire escape clangs and shudders --- much more than
		 you expected. You quickly scramble against the
		 brick wall and lie flat against it, your pulse
		 pounding through your head. You close your eyes and
		 a howl of wind whips across your face, quickening
		 your pulse even further. Your eyes snap open and
		 there is no wind, just you standing alone,
		 petrified, above a still alleyway, not even a
		 breeze stirring up the garbage. You soon catch your
		 breath and resolve not to do that again. ";
		hasJumped = true;
		exit;
	    }
	}
    }
    westLook = "A ledge hugs the brick wall overlooking the alleyway
		below. There seems to be just enough room for
		someone to slide along, but it would be rather
		perilous. "
    downLook = "The slick, brown-grey alleyway gazes up at you.
		Pieces of rubbish roll along like tumbleweeds. A
		swirl of vertigo envelopes you, and you stand back
		and compose yourself. "
    upLook = "The fire escape continues another level up, but
	      strangely, not further. "
    eastLook = "The rough brick wall drops off here --- there is no
		ledge. "
    southLook = "<<catwalkToAbandonedWindow.isOpen ? 'An open' :
		 'A'>> window leads into a dark room beyond. You
		 can\'t see much with a cursory glance due to all
		 the glare. "
    northLook = "Ten feet of rancid air lies between the catwalk and
		 the brick wall on the other side of the alleyway. "
    south = catwalkToAbandonedWindow
    in asExit(south)
    west : TravelMessage {
	-> firstLedgeSouth
	"Careful not to look down, you swing yourself over the
	 railing and onto the precarious ledge beyond. "
    }
    down = firstCatwalkLadderDown
;

+firstCatwalkLadderDownBarrier : TravelBarrier
    canTravelerPass(traveler) { return firstCatwalkLadderDown.isLadderDown; }
    explainTravelBarrier(traveler) { "You\'ll need to lower the ladder first. "; }
;

+ Distant
    vocabWords = 'dangerous narrow precarious west w ledge/edge/side/west/w/sill/ridge/overhang'
    name = 'ledge'
    desc = "A ledge hugs the brick wall overlooking the alleyway
	    below. There seems to be just enough room for someone to
	    slide along, but it would be rather perilous. "
;

+ Distant
    vocabWords = 'messy dirty alleyway alleyway/below/down/alley/ground'
    name = 'alleyway below'
    desc = "The slick, brown-grey alleyway gazes up at you. Pieces
	    of rubbish roll along like tumbleweeds. A swirl of
	    vertigo envelopes you, and you stand back and compose
	    yourself. "
;

+catwalkToAbandonedWindow : Door, TravelMessage ->abandonedToCatwalkWindow
    vocabWords = '(small) apartment south southern s window/south/s/in'
    name = 'window to an apartment'
    desc {
	if(isOpen)
	    "A plain, closed window sits in the middle of the brick
	     wall. Glare completely blocks your view into the dark
	     apartment beyond. ";
	else
	    "A plain window opens up the brick wall, revealing a bit
	     of the dark apartment beyond. Your shadow stretches
	     across a dusty wooden floor. ";
    }
    lookThroughDesc {
	if(isOpen)
	    "You duck your head through the window and peer inside.
	     A silhouette of yourself shines onto bare wooden
	     floorboards. The dust sparkles in the light. <.p>The
	     whole apartment looks completely abandoned.";
	else
	    "Blocking out the glare, you squint through the clear
	     pane of the window. The dimly-lit apartment is
	     completely uninhabited. Even the carpet on the floor
	     has been removed, leaving just the floorboards and dust
	     mites. ";
    }
    initiallyOpen = nil
    okayOpenMsg = 'The window slides easily and locks in place at the top. '
    okayCloseMsg = 'The window smoothly slides shut. '
    travelDesc = "You pull yourself through the window, falling into
		  the empty apartment beyond. "
    shouldNotBreakMsg = 'There is no need to break the window, when
			 it is easily openable. '
    dobjFor(LookThrough) {
	preCond = [objVisible]
	verify() {}
	action() {

	    lookThroughDesc;
	    
	}
    }
    dobjFor(LookIn) asDobjFor(LookThrough)
;

+firstCatwalkLadderDown : Fixture, TravelWithMessage, StairwayDown
    vocabWords = 'down ground ladder ladder/down/d'
    name = 'ladder down'
    desc {
	if(isLadderDown)
	    "The ladder to the ground has been lowered. It looks
	     solid so you can easily reach the alleyway below
	     without any drama. ";
	else
	    "The ladder to the ground is folded up to prevent any
	     no-goodniks from climbing it and breaking into the
	     building. You could easily lower it with a good push or
	     kick. ";
    }
    isLadderDown = nil
    //isOpen = (isLadderDown)
    destination = centralAlleyway
    travelBarrier = firstCatwalkLadderDownBarrier
    shouldntPunchMsg = 'You shouldn\'t punch it -- it\'s solid iron. '
    travelDesc = "You carefully check that the ladder is holding
		  solid. It doesn\'t look like it\'ll give way, so
		  you slowly descend. You leap from the bottom of
		  the ladder, landing with a slap of your shoes on
		  the smooth concrete. "
    specialDesc {
	if(isLadderDown)
	    "An opening in the floor allows access to the ladder
	     dangling over the alleyway. ";
	else
	    "The ladder to the alleyway is currently locked and
	     folded up. ";
    }
    dobjFor(Lower) {
	verify() {
	    if(isLadderDown)
		illogicalNow('The ladder has already been lowered. ');
	}
	check() {}
	action() {
	    "With a swift stomp, the ladder jumps out of its lock
	     and slides down to the alleyway below, crashing to a
	     stop. The whole fire escape rings and rattles. ";
	    isLadderDown = true;
	}
    }
    dobjFor(Raise) {
	verify() {
	    if(!isLadderDown)
		illogicalNow('The ladder is already raised. ');
	}
	check() {
	    "You try tugging on the ladder but it stubbornly refuses
	     to budge. It looks like one <i>could</i> raise it, but
	     it looks like a waste of time. ";
	    exit;
	}
    }
    dobjFor(TravelVia) {
	action() {
	    if(!isLadderDown)
		tryImplicitActionMsg(&announceImplicitAction,Lower,self);
	    inherited();
	}
    }
    dobjFor(Push) asDobjFor(Lower)
    dobjFor(Kick) asDobjFor(Lower)
    dobjFor(Move) asDobjFor(Lower)
    dobjFor(Unlock) asDobjFor(Lower)
    dobjFor(Unfold) asDobjFor(Lower)
    dobjFor(Pull) asDobjFor(Raise)
    dobjFor(Climb) asDobjFor(TravelVia)
    dobjFor(ClimbDown) asDobjFor(Climb)
;

+firstCatwalkLadderUp : Fixture, TravelWithMessage, StairwayUp
    vocabWords = 'ladder up ladder/up/u'
    name = 'ladder up'
    desc = "This ladder has been welded onto the fire escape frame,
	    allowing you to climb up, or more likely, someone to get
	    down in case of emergency. The fire escape isn\'t the
	    sturdiest you\'ve seen, so if one part collapsed, the
	    whole welded frame would come tumbling down. Scary. "
    dobjFor(Climb) asDobjFor(TravelVia)
    dobjFor(ClimbUp) asDobjFor(Climb)
    dobjFor(Lower) {
	verify() {
	    illogical('The ladder up is welded onto the fire escape frame. You cannot move it. ');
	}
    }
    dobjFor(Kick) {
	verify() {
	    logicalRank(70, 'prefer the down ladder');
	}
    }
;

firstLedgeSouth : Room
    name = 'Precarious Ledge over the Alleyway'
    destName = 'the ledge'
    desc = "Peering downwards, you can see the cold, wet, hard
	    concrete of the alleyway below. It\'s not a far fall,
	    but you could easily break a leg given the landing
	    surface. You decide not to test this assertion and you
	    keep yourself stuck against to the crumbling brick wall.
	    Instead of sticking around, you can shuffle along the
	    ledge towards the northern fire escape, or just move
	    over to the nearby one to the east. "
    roomParts = [defaultSky, upperBrickWallSouth, dangerousLedgeFloor]
    downLook = "The grimy alleyway lies a good distance below. And
		as you stare downwards, you feel your stomach
		lurching down towards it. "
    northwestLook = "At the end of the ledge is another fire escape.
		     The distance between you and it is a little
		     uncomforting. "
    eastLook = "The safe iron skeleton of the fire escape is a few
		slides to the east. "
    northLook = "Several feet of empty space separate your ledge
		 from the far brick wall. "
    upLook = "The flat brick wall extends up above you for several
	      stories, ending in empty blue sky. "
    down : NoTravelMessage {
	"Are you mad? You could break a leg (or worse) jumping from
	 here. Try to find somewhere softer to land. "
	}
    northwest : NoTravelMessage {
	"You couldn\'t leap from here to the fire escape. Perhaps
	 you should shuffle along the ledge to the south instead. " }
    east : TravelMessage {
	-> firstCatwalkSouth
	"You steady yourself against the fire escape railing and
	 awkwardly roll over it onto the safe landing."
	}
    north : TravelMessage {
	-> firstLedgeNorth
	"Biting your lip, you shuffle along the ledge, turn at the
	 west wall and continue your slide northwards. "
	}
    west asExit(north)
    atmosphereList : ShuffledEventList {
	eventPercent = 25
	eventReduceAfter = 5
	eventReduceTo = 15
	eventList = [ '\nThe wind suddenly whips at you. You tightly
		       hug the wall and wait until it subsides. ',
	 '\nYou accidentally nudge a broken piece of brick off the
	  ledge. It falls silently for a second and shatters with a
	  <i>crack!</i> that echoes down the alleyway.',
	 '\nIgnoring the age-old advice of not looking down, you
	  glance downwards. You suddenly tense and press yourself
	  closer to the wall. You gulp and try to slow your
	  breathing. ',
	 '\nYou hear a piece of paper skip and tumble along the
	  alleyway below. ',
	 '\nYou try your best not to think of Hitchcock\'s
	  <I>Vertigo</I>. Of course, trying to not think about it
	  only results in you thinking about it. Your fingers grip
	  the wall even tighter.',
	 'You glance across the alleyway. You gulp. There sure is a
	  lotta space to the wall across from you. ' ]
	 }
    roomBeforeAction() {
	if(gActionIs(Jump)) {
	    "Whoa, easy there pal. You don\'t want to go and do
	     something crazy like that. ";
	    exit;
	}
    }
;

firstLedgeNorth : Room
    name = 'Precarious Ledge over the Alleyway'
    destName = 'the ledge'
    desc = "This section of the ledge is no more safe than the
	    others. In fact, it is a little more scary with the wind
	    channeled down the alleyway coming to an abrupt halt
	    here. The chill wind jangles your nerves and stiffens
	    your bones. You should probably slide to the fire escape
	    to the north, or brave the rest of the ledge to the
	    south that leads to a catwalk to the southeast. "
    roomParts = [defaultSky, upperBrickWallWest, dangerousLedgeFloor]
    southeastLook = "The other fire escape hangs out of reach from
		     your current position. You could slide around
		     there, though. "
    southLook = "The ledge hugs the alleyway walls, bending around
		 to the east, towards the other fire escape. "
    northLook = "Not far to the north hangs the inviting (relative)
		 safeness of the fire escape. "
    downLook = "The grimy alleyway lies a good distance below. And
		as you stare downwards, you feel your stomach
		lurching down towards it. "
    southeast : NoTravelMessage {
	"You couldn\'t leap from here to the fire escape. Perhaps
	 you should shuffle along the ledge to the south instead. " }
    south : TravelMessage {
	-> firstLedgeSouth
	"Taking a deep breath, you hug the wall and slide southwards
	 along the ledge. "
	}
    north : TravelMessage {
	-> firstCatwalkNorth
	"You desperately grab the rail of the fire escape and swing
	 yourself over to hopefully safer ground. "
	}
    down : NoTravelMessage {
	"Are you mad? You could break a leg (or worse) jumping from
	 here. Try to find somewhere softer to land, or at least a
	 better way down. "
	}
    atmosphereList : ShuffledEventList {
	eventPercent = 25
	eventList = [ '\nThe wind suddenly whips at you. You tightly
		       hug the wall and wait until it subsides. ',
	 '\nYou accidentally nudge a broken piece of brick off the
	  ledge. It falls silently for a second and shatters with a
	  <i>crack!</i> that echoes down the alleyway.',
	 '\nIgnoring the age-old advice of not looking down, you
	  glance downwards. You suddenly tense and press yourself
	  closer to the wall. You gulp and try to slow your
	  breathing. ',
	 '\nYou hear a piece of paper skip and tumble along the
	  alleyway below. ',
	 '\nYou try your best not to think of Hitchcock\'s
	  <I>Vertigo</I>. Of course, trying to not think about it
	  only results in you thinking about it. Your fingers grip
	  the wall even tighter.' ]
	 }
    roomBeforeAction() {
	if(gActionIs(Jump)) {
	    "Whoa, easy there pal. You don\'t want to go and do
	     something crazy like that. ";
	    exit;
	}
    }
;

firstCatwalkNorth : Room
    name = 'Fire escape over the Alleyway'
    destName = 'the fire escape over the west end of the alleyway'
    desc = "Hanging a good many metres above the garbage-strewn
	    alleyway, the rickety fire escape doesn\'t offer much
	    assurance of keeping things that way. The ladder down is
	    completely missing, the ladder up is blocked by a large
	    crate, and if you shift your weight too much, the
	    catwalk groans and squeaks with the load above. Your
	    only alternatives to hanging around in this death-trap
	    is an apartment window lies to the west or a trip back
	    along the thin ledge to the south. "
    roomParts = [catwalkFloor, defaultSky]
    roomBeforeAction() {
	if(gActionIs(Jump)) {
	    if(trickleOfCement.described)
		"Like hell. Bringing down the fire escape and
		 possibly two tonnes of cement on top of yourself is
		 almost the definition of A Bad Idea(tm). ";
	    else
		"No way. The fire escape doesn\'t look that sturdy,
		 and that big crate above... A recipe for disaster. ";
	    exit;
	}
    }
    westLook = "A warmly-lit room lies beyond the window. "
    southLook = "The precarious ledge lies beyond the fire escape
		 railing. "
    upLook = "The entirety of the catwalk above is blocked by a
	      large wooden crate. Weird. "
    eastLook = "The messy alleyway below runs eastward for a while,
		before being blocked off by a chainlink fence. The
		alleyway continues a little while beyond that before
		turning south. "
    northLook = "Just the rough brick wall of the northern building. "
    west = catwalkToLockedWindow
    south = firstLedgeSouth
    up = firstCatwalkNorthLadderUp
;

+catwalkToLockedWindow : Door, TravelMessage ->lockedBedroomToCatwalkWindow
    vocabWords = '(small) apartment west western w window/west/w/in'
    name = 'window to an apartment'
    desc = "Through the window you see a spartan, warmly-lit room.
	    Your shadow stretches across it almost ominously. "
    initiallyOpen = nil
    okayOpenMsg = 'The window slides open easily and locks in place
		   at the top. '
    okayCloseMsg = 'You silently close the window. '
    travelDesc = "You pull yourself through the window, stepping onto
		  a straw mat just below the window. "
    shouldNotBreakMsg = 'There is no need to break the window, when
			 it is easily openable. '
    dobjFor(LookThrough) {
	verify() {}
	action() {

	    desc;
	    
	}
    }
    dobjFor(LookIn) asDobjFor(LookThrough)
;

+firstCatwalkNorthLadderUpBarrier : TravelBarrier
    canTravelerPass(traveler) { return nil; }
    explainTravelBarrier(traveler) {
	"Much of the above catwalk is taken up by a large, heavy
	 crate. More importantly, it completely blocks the ladder.
	 There doesn\'t seem to be a way around it, so you might as
	 well try a different route. "; }
;

+firstCatwalkNorthLadderUp : Fixture, StairwayUp
    vocabWords = 'blocked ladder up ladder/up/u'
    name = 'blocked ladder'
    desc = "An iron ladder ascends to the fire escape above, but is
	    curiously blocked by a large, heavy-looking crate. This
	    suggests the ladder is basically useless to you. "
    travelBarrier = firstCatwalkNorthLadderUpBarrier
;

+Heavy, OutOfReach
    vocabWords = 'heavy large wooden crate/box/block/case/chest/container'
    name = 'large, wooden crate'
    desc = "How the hell they got this big crate up here, you don\'t
	    know. Not to mention why. <.p>Through the mesh floor of
	    the catwalk you can see a faded imprint on the bottom of
	    the box. It reads, <q>Vizioso Removalists, Inc.</q> The top
	    of the box is wedged between it and the brick wall. A
	    trail of <<trickleOfCement.described ? 'cement trickles down the side, reminding you of the impending danger above' : 'rough, grey liquid trickles down the side. Bizarre'>>. "
    lookInDesc = "You can\'t see inside of the crate from down here. "
    canObjReachContents(obj) { return nil; }
    canObjReachSelf(obj) { return true; }
;

+trickleOfCement : Distant
    vocabWords = 'grey gray rough liquid/cement/concrete/trickle'
    name = 'trickle of cement'
    desc = "You closely inspect this grey liquid. It\'s probably
	    cement or something like that. <.p>Your stomach twists
	    as you realize that a trickle of it along the side of
	    that large crate suggests that the whole thing might be
	    full of cement. A few tonnes of wet concrete hovering
	    above your head on this rickety fire escape... frankly,
	    that terrifies you. That window to the west is looking
	    mighty inviting... "
;
