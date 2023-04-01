#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//---------------//
//  The laundry  //
//---------------//

// I went a bit overboard in the customization of the laundry, so I made it into another file.
// This also includes the (new) storage room.

laundryWest : RoomPart 'w west western w/west/western/wall*walls' 'west wall'
    "The western wall is more of the undecorative smooth concrete. A
     ledge has been bolted into the wall and near the southern end
     they have installed a standard sink. "
;

laundrySouth : RoomPart 's south southern s/south/southern/wall*walls' 'south wall'
    "Drab and unadorned, the south wall is completely unremarkable. "
;

laundryNorth : RoomPart 'n north northern n/north/northern/wall*walls' 'north wall'
    "The northern section of wall has only one notable feature: the
     swinging door set in the middle, giving the wall the illusion
     of narrowness compared to the blank south wall. "
;

laundryFloor : Floor 'floor/ground/down/d' 'floor'
    "The smooth concrete floor is mottled with various stains from
     spills, long dried-up puddles and the usual mistreatment. It
     angles ever-so-slightly in towards the small drain in the
     middle of the room. "
;

+laundryDrain : Openable, RestrictedContainer, Decoration  '(laundry) floor small drain/hole' 'drain' @laundry
    "Embedded into the middle of the floor is a medium-sized drain,
     designed to take care of the splashes and spills expected in
     such a laundry. The drain cover is only a few inches in
     diameter and is made out of cheap stainless steel"
    lookInDesc = "The drain is coated in rust and laundry chemicals,
		  and shrouded in darkness an inch or two from the
		  edge. "
    bulkCapacity = 2
    disambigName = 'drain in the laundry floor'
    openStatus {
	if(isOpen)
	    ". The cover has been taken off, leaving the drain open";
	else
	    ". Beyond the grille you can see a mottled pale something
	     hiding in the shadows";
    }
    canPutIn(obj) { return nil; }
    notAContainerMsg = 'If {you/he} put anything down the drain,
			{you/he}\'d probably lose it forever, so
			{you/he} figure {you/he} should just keep
			{the dobj/him}. '
    initNominalRoomPartLocation = laundryFloor
;

++laundryDrainNote : CreepyNote
    vocabWords = '(laundry) scrap mottled rusty rust-coloured rust-stained rust stained note/letter/paper/card/scrap'
    name = 'rust-stained note'
    desc = "This rust-stained, bent piece of card has the remnants
	    of a poem (or something) scratched inside. "
    leadInMsg = "This rust-stained, bent piece of card has the
		 remnants of a poem scratched inside: <BQ>"
    leadOutMsg = "</BQ> <.p>"
    messageText = "endless cascades\n \u2003 \u2003 driving me
		   down\n \u2003 want to die\n \u2003 \u2003
		   \u2003 \u2003 \u2003 \u2003 ...can\'t"
    initSpecialDesc = "A mottled scrap of card has been stuffed into the drain. "
;

laundryCeiling : RoomPart 'ceiling/roof/up/u' 'ceiling'
    "The ceiling is monotonously smooth concrete, punctuated only by
     the light fixtures and the occasional cable housing. "
;

laundryEast : RoomPart 'e east eastern e/east/eastern/wall*walls' 'east wall'
    "The eastern wall consists of an array of washing machines and
     dryers. Near the northern end is an unassuming dull red door
     and next to that, a small light switch is set in the middle of
     a section of plain concrete. "
;

laundry : Room
    name = 'Communal laundry'
    destName = 'the laundry'
    desc = "A stark contrast to the tacky hallway, the laundry is a
	    smooth concrete, windowless box. It is only a few paces
	    wide, but reasonably long. An array of washing machines
	    and dryers line up against the east wall. A long wooden
	    ledge is bolted into the opposite wall, terminating in a
	    sink. The cold, grey light from the pale fluorescent
	    light fixtures bleaches the surroundings.\b Tucked into
	    the northeast corner of the laundry is a dull red door
	    with a small sign affixed to it. The only other way out
	    in to through the swinging door to the north, back out
	    into the hallway. "
    roomParts = [laundryFloor, laundryCeiling, laundryNorth, laundrySouth, laundryEast, laundryWest]
    north = groundHallway
    east = laundryToStorageDoor
    northeast asExit(east)
    in asExit(east)
    out asExit(north)
    brightness = 0
;

+laundryToHallwayDoor : ThroughPassage ->hallwayToLaundryDoor 'n north northern swinging door/n/north/doorway*doors' 'swinging door leading out'
    "To help residents with armsful of laundry, they have installed
     a swinging door. Naturally the door has no handle, because all
     you need to do is push the door as you walk through. Scuff
     marks in the lower part of the door suggests people kick it
     open instead. "
    hasBeenPunched = nil
    hasBeenKicked = nil
    dobjFor(Open) {
	verify() {}
	check() {
	    "You don\'t need to open the swinging door. Just walk through it. ";
	    exit;
	}
    }
    dobjFor(Close) {
	verify() {}
	check() {
	    "The door swings shut (eventually) by itself, so there is no need
	     to close it. ";
	    exit;
	}
    }
    dobjFor(Push) {
	verify() {}
	action() {
	    "You give the door a shove and it swings back and forth, the
	     waving slowly decreasing until the door is closed again. ";
	}
    }
    dobjFor(Pull) {
	verify() {}
	check() {
	    "The swinging door has no handles. Anyway, the door swings both
	     ways so all you need to do is walk through. ";
	    exit;
	}
    }
    dobjFor(Punch) {
	verify() {}
	check() {
	    if(hasBeenPunched)
		"After the stinging hand you received last time, you decide
		 not to punch the door again. ";
	}
	action() {
	    "You punch the door with your palm. It swings violently for a
	     while before stopping. It looks you came off more worse for wear
	     than it did. ";
	    hasBeenPunched = true;
	}
    }
    dobjFor(Kick) {
	verify() {}
	check() {
	    if(hasBeenKicked)
		"You still feel pangs of guilt from your last assault on the
		 door. ";
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
	    hasBeenKicked = true;
	}
    }
    dobjFor(Attack) remapTo(Kick,self)
;

+laundryLightSwitch : Switch, Fixture 'light switch/control/controls/button' 'light switch'
    "The plastic light switch is unremarkable and merely functional. <<isOn ?
     nil : 'The switch glows slightly, probably so people can find it in the
     dark. '>> "
    makeOn(val) {
	laundryLight.brightness = ( val ? 3 : 1);
	"With a click <<val ? 'and a stutter, the lights come on. ' : 'the room is plunged into darkness. '>> ";
	inherited(val);
    }
    hideFromAll(action) { return true; }
    initNominalRoomPartLocation = laundryEast
    brightness = 1
    isOn = true
    specialDesc { isOn ? nil : "The only thing you can see is a
				small glowing light switch within
				arms\' reach. ";}
;

+laundryToStorageDoor : Door '(east eastern) dull red storage door/doorway*doors' 'red door to the storage room'
    "Set into the northern section of the east wall is a unassuming
     dull red door. A small sign is affixed to the door"
    openStatus {
	if(isOpen)
	    ". The door hangs open, revealing a cramped storage room beyond";
    }
;

++laundryToStorageDoorSign : Component, Readable '(small) (door) storage room sign' 'storage room door sign'
    desc = readDesc
    readDesc = "In small block letters the sign reads: <q>The
		<strike> \ (New) \ </strike> \ Storage Room</q> "
    hideFromAll(action) { return true; }
    dobjFor(LookBehind) {
	verify() {
	    illogical('The sign is stuck to the door, so you can\'t look behind it. ');
	}
    }
;

+laundryLight : Fixture 'pale grey gray light fluorescent fluoro flourescent light/fixture/fluorescent' 'fluorescent light fixture'
    desc {
	if(brightness == 3)
	    "The pill-shaped, fluorescent light fixture illuminates
	     the room in a pale grey light, washing out all the
	     colours. Quite ironic, really. ";
	else
	    "The light is currently off but glows faintly, probably
	     due to bad wiring. Anyhow, the glow is barely enough to
	     illuminate the light itself than anything else in the
	     room. ";
    }
    hideFromAll(action) { return true; }
    initNominalRoomPartLocation = laundryCeiling
    dobjFor(TurnOn) remapTo(TurnOn,laundryLightSwitch)
    dobjFor(TurnOff) remapTo(TurnOff,laundryLightSwitch)
    brightness = 3
;

+Bed, Fixture 'bolted bolted-on wooden ledge/surface/table/bench' 'wooden bench'
    "A sturdy vinyl-coated wooden bench has been bolted onto the
     western wall. Currently there is little on the bench apart from
     dust, lint and scuff marks. Towards the end of the bench, near
     the south wall, they have installed a twin-tub sink. "
    bulkCapacity = 50
    hideFromAll(action) { return true; }
    initNominalRoomPartLocation = laundryWest
    allowedPostures = [sitting, lying]
    obviousPostures = [sitting]
;

++Sink, Decoration 'metal twin-tub twin sink/basin/washbasin/handbasin' 'laundry sink'
    "For the usual reasons, the builders have installed a twin-tub
     sink at the end of the ledge skirting the western wall. The
     sink is made out of stainless steel and has a single tap. The
     whole thing is set into a concrete block jutting out from the
     wall"
;

+++Component, Decoration 'metal water tap/faucet' 'tap for the sink'
    "The faucet is an elongated U-shaped tube of stainless steel,
     used to dispense water into the sink once one turns the taps
     on. Nothing surprising, actually. "
;

+Decoration 'wires wire cable cable/housing' 'cable housing'
    "Cables for the washing machines snake up from the ground,
     through the bench near the west wall, across the ceiling and
     then back down behind the machines. They have been protected by
     a plain square aluminium housing. Other than breaking up the
     monotony of the laundry walls, they aren\'t terribly
     interesting. "
;

+CollectiveGroup, SecretFixture 'washing array*machines*washers' 'washing machines'
    "Along the east wall, adjacent to the sole dryer, sits two
     washing machines. The one to the right has a note indicating
     that it is out of order, but the other one seems fine. "
;

+laundryRightMachine : Surface, Heavy
    vocabWords = '(laundry) broken out order out-of-order right washing clothes washer/machine'
    name = 'right washing machine'
    location = laundry
    disambigName = 'right washing machine'
    desc = "UNIMPLEMENTED YET. "
    bulkCapacity = 75
    weightCapacity = 100
    cannotOpenMsg = 'The lid has been taped down, probably because
		     the machine is broken. '
    cannotTurnOnMsg = 'The washing machine is out of order, so it is
		       useless to try turning it on. '
    lookInMsg = 'The machine has been taped shut with heavy-duty
		 electrical tape, so you can\'t open it to look
		 inside. '
    hideFromAll(action) { return true; }
;

++Readable
    vocabWords = 'out out-of-order note/sign/order'
    name = 'out-of-order sign'
    disambigName = 'out-of-order sign from washing machine'
    desc = "A plain plastic sign reads simply: <b>OUT OF ORDER.</b> "
    bulk = 1
    weight = 1
    hasSeenBack = nil
    hideFromAll(action) { return true; }
    dobjFor(LookBehind) {
	preCond = [touchObj]
	verify() {
	    logicalRank(80,'not obvious but not non-obvious');
	}
	action() {
	    if(!hasSeenBack) {
		"Out of curiosity, you flip the sign over to see the
		 back. To your surprise, someone has scratched a
		 message in the back. Fringed with thin curls of
		 gouged-out plastic is the message: <Q>BEWARE
		 VIZIOSO</Q> ";
		hasSeenBack = true;
	    }
	    else
		"On the back of the sign, fringed with thin curls of
		 gouged plastic is the message: <Q>BEWARE
		 VIZIOSO</Q> ";
	}
    }
    dobjFor(Examine) {
	verify() {
	    if( !moved )
		logicalRank(110,'more obvious');
	    else
		inherited();
	}
    }
;


