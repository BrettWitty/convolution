#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//-------------------//
//  The Boiler Room  //
//-------------------//

boilerRoom : Room
    name = 'The Boiler Room'
    destName = 'the boiler room'
    desc = "Buried deep underneath the building, carved into some
	    nook, is the boiler room. There are no windows and the
	    single entryway to the south hasn\'t even been given the
	    honour of a door. The only decorations to the room are a
	    few small vents high in the east wall and the pipes
	    leading from the cantankerous old boiler that occupies
	    most of this hollow. The air is thick with heat and
	    dust. "

    roomAfterAction() {

	if(!mentionedHeadache && gPlayerChar.hasHeadache) {
	    "The heat here makes your headache balloon out, pushing
	     tight against the inside of your skull. You close your
	     eyes and try to mentally flatten it down to something
	     more manageable. ";
	    mentionedHeadache = true;
	}
    }

    mentionedHeadache = nil
    
    west = boilerToOldStorageDoor
    northwest asExit(west)
    in asExit(west)
    south = boilerRoomToBasementDoorway
    out asExit(south)
;

+ boilerRoomToBasementDoorway : ThroughPassage, TravelMessage, ShuffledEventList
    vocabWords = 's/south/opening/entryway/exit/entrance'
    desc = "The darker, cooler main basement lies through the
	    opening to the south. "
    hideFromAll(action) { return true; }
    destination = mainBasement
    eventList = ['The hairs on the back of {your/his} head roast, as
		  {you/he} step{s} out into the cooler main
		  basement. ',
		 '{You/he} sigh{s} as {you/he} step{s} into the
		  cooler air of the main basement. ']
;

+boiler : Fixture
    vocabWords = 'huge old large metal hot steel boiler/heater'
    name = 'the boiler'
    desc {
	"Most of this old boiler seems to come from The Depression.
	 The original frame is made out of the thick, heavy
	 cast-iron that they don\'t make anything out of any more.
	 Here and there someone has patched up pieces with newer
	 strips of aluminium or steel. It looks like it should fall
	 apart under any decent pressure, but Depression-era
	 construction has that way of looking unstable but actually
	 being impervious to anything weaker than an atomic bomb
	 blast (or the machinations of a devious Communist).";
	if(boilerBrokenPipe.location == boilerRoom)
	    "<.p>One of the pipes leading from the boiler is broken,
	     thick steam gushing out, making the heat in the room
	     even more oppressive than usual. The boiler clatters
	     and hacks, its main artery torn open. ";
	else
	    "<.p>Nevertheless it rumbles away obediently, bubbles of
	     heat rattling through the pipes. The heat radiating
	     from it is a bit oppressive, but then again, this
	     <i>is</i> the boiler room. ";
    }
    isQualifiedName = true
    cannotTakeMsg = 'Now really, taking a boiler away with you is a
		     bit ambitious! '
    cannotMoveMsg = 'You see three problems to this plan: (1) The
		     boiler is fixed to the ground; (2) Even if it
		     wasn\'t it would weigh several tonnes, well
		     beyond your pushing capabilities; (3) Even
		     then, it\'s hard to push such things when your
		     hands would be burning. Discarding this plan is
		     The Smart Thing To Do(tm). '
    cannotPutMsg = 'Moving a heavy, fixed, and incredibly hot boiler
		    is impossible. '
    cannotKissMsg = 'Not if you want to keep your lips! '
    shouldntPunchMsg = 'A burnt, broken hand for... let\'s see...
			nothing! That\'s a bad swap in anybody\'s
			books. '
    feelDesc = "You <i>could</i> feel the boiler, or you could
		keep your hand unscarred, capable of feeling very many
		other things, for the rest of your life. You choose
		the latter. "
    soundDesc {
	if(boilerBrokenPipe.location == boilerRoom)
	    "Steam hisses and gushes out of the broken pipe. The
	     boiler coughs, rattles and grumbles, trying to deal
	     with its broken artery. The vents join it, sputtering
	     and hammering. ";
	else
	    "The boiler bubbles and rumbles to itself, the vents
	     breathing out humid air. ";
    }
    tasteDesc = "Though you aren\'t game to try, you\'re guessing it
		 tastes hot, and not in a curry way. "
    smellDesc = "The boiler smells of stagnant steam and burnt dust. "
    dobjFor(Kick) {
	verify() {}
	action() {
	    mainReport('You grit your teeth and kick the boiler, but
			it shrugs it off with barely a dull
			<i>thunk</i> in return.');
	}
    }
    dobjFor(Attack) asDobjFor(Kick)
    dobjFor(Break) asDobjFor(Kick)
;

++Component 'metal aluminium aluminum steel strip/strips/patch/patches' 'strips of steel'
    "Here and there on the boiler someone has patched up sections
     with strips of aluminium and steel. Some strips have been
     welded on, whereas others are bolted on, or wrapped around
     various seals or pipes. "
    hideFromAll(action) { return true; }
    dobjFor(Kick) remapTo(Kick,boiler)
    dobjFor(Punch) remapTo(Punch,boiler)
    dobjFor(Attack) asDobjFor(Kick)
    dobjFor(Pull) {
	verify() {}
	check() {
	    "It would be useless to try---most are securely attached
	     and they are too hot to handle anyway. ";
	    exit;
	}
    }
    dobjFor(Break) asDobjFor(Pull)
    dobjFor(Remove) asDobjFor(Pull)
    dobjFor(Tear) asDobjFor(Pull)
;

+boilerPipes : Fixture
    vocabWords = 'metal steam exhaust boiler unbroken other pipe/pipes/piping'
    name = 'pipes'
    disambigName = 'other pipes'
    desc {
	"A complicated network of pipes enter and leave the boiler,
	 eventually disappearing into the wall. They seem the least
	 resilient part of the whole boiler. While the boiler itself
	 might shrug off a nuclear explosion, the pipes couldn\'t
	 survive a well-swung boot";

	if( boilerBrokenPipe.location == location )
	    ", as you\'ve already discovered. ";
	else
	    ". ";
    }
    feelDesc = (boiler.feelDesc)
    isPlural = true
    hasBeenFixedByVern = nil
    dobjFor(Kick) {
	verify() {
	    if(boilerBrokenPipe.location == boilerRoom)
		illogicalNow('You\'ve done enough damage already. ');
	}
	check() {
	    if(vern.location == boilerRoom) {
		"The janitor fixes you with his eyes. You\'re
		 guessing you\'d cop a wrench to the head before
		 your foot even connected with the pipes. ";
		exit;
	    }
	    if(hasBeenFixedByVern) {
		"You\'ve caused enough trouble already. If the
		 boiler was broken again, the janitor would probably
		 kill you and you guess he knows some great hiding
		 places for bodies. ";
		exit;
	    }
	}
	action() {
	    "You stomp hard on an accessible pipe. After a few solid
	     kicks, the pipe breaks open, thick, gushing steam
	     erupting from the open end. You leap back from the hot
	     cloud, your inner vandal satiated. ";
	    boilerBrokenPipe.makePresent();
	}
    }
    dobjFor(Fix) maybeRemapTo(boilerBrokenPipe.location == boilerRoom,Fix,boilerBrokenPipe);
;

+Distant 'array exhaust boiler vents/vent/exhaust' 'vents'
    isPlural = true
    desc {
	if(boilerBrokenPipe.location == boilerRoom)
	    "The array of exhaust vents in the east wall splutter
	     and rattle, probably because of the broken pipe. ";
	else
	    "High up on the east wall, a small array of vents spew
	     out exhaust air in a soft rumble. ";
    }
    soundDesc {
	if(boilerBrokenPipe.location == boilerRoom)
	    "The vents rattle and splutter. ";
	else
	    "You can just make out the low rumble of the vents over
	     the bubbling boiler and hammering pipes. ";
    }
;

+SimpleNoise 'bubbling vent boiler rattling hacking clattering sputtering hammering bubbling rattling/hacking/clattering/sputtering/hammering/bubbling/sounds' 'boiler sounds'
    desc {
	if(boilerBrokenPipe.location == boilerRoom)
	    "Steam hisses and gushes out of the broken pipe. The
	     boiler coughs, rattles and grumbles, trying to deal
	     with its ruptured artery. The vents join it, sputtering
	     and hammering.";
	else
	    "The boiler bubbles away obediently. Every so often a
	     hammering will pound through the pipes, shaking them in
	     their sockets, and disappear in the wall. Adding to
	     this symphony of indoor heating, the vents breathe out
	     hot air in a low rumble. ";
    }
;

// TODO: Find a way to make it work.
//
//+SensoryEmanation 'bubbles oppressive sweltering hot heat/hotness' 'heat'
//    sourceDesc {
//        if( boilerBrokenPipe.location == boilerRoom )
//            "The heat coming from the broken pipe fills the air oppressively. ";
//        else
//            "Waves of heat roll off the boiler. Your clothes feel sticky and
//            tight. ";
//    }
//    touchPresence = (isEmanating)
//    isEmanating = true
//    isAmbient = true
//    dobjFor(Feel) asDobjFor(Examine)
//    dobjFor(Examine) {
//        preCond = [touchObj]
//    }
//;

+SimpleOdor 'smell' 'boiler room smell'
    desc {
	if(boilerBrokenPipe.location == boilerRoom)
	    "The air is full of the hot fart smell of steam and dust. ";
	else
	    "The humid, stale air smells only of roasted dust. ";
    }
;

+boilerBrokenPipe : PresentLater, Fixture
    vocabWords = '(boiler) broken pipe'
    name = 'broken pipe'
    desc = "The broken pipe is gushing with thick steam which
	    spreads over the room. You gulp guiltily. "
    feelDesc = "You\'d probably burn your hand off! "
    tasteDesc = "Mmm... Tastes just like steamed copper pipe... Wait
		 up... Are you mad?! "
    soundDesc = "The broken pipe hisses angrily. "
    specialDesc = "A broken pipe spews thick steam into the air. "
    fixUp() {
	moveInto(nil);
	boilerBurstSteam.moveInto(nil);
	boilerPipes.hasBeenFixedByVern = true;
    }
    makePresent() {
	inherited();
	boilerBurstSteam.makePresent();
    }
    dobjFor(Fix) {
	verify() { illogical('You don\'t have the tools, the
			      expertise or the guts to fix the
			      broken pipe. '); }
    }
    dobjFor(Kick) {
	verify() {
	    illogicalNow('You\'ve done enough damage for now.
			  Standing near the plume of steam is also
			  probably dangerous. ');
	}
    }
    dobjFor(Break) asDobjFor(Kick)
    dobjFor(Tear) asDobjFor(Kick)
    dobjFor(Punch) asDobjFor(Kick)
    dobjFor(Pull) asDobjFor(Kick)
    dobjFor(Push) asDobjFor(Fix)
;

+boilerBurstSteam: PresentLater, Vaporous
    vocabWords = '(boiler) (pipe) billowing gushing hissing plume/steam/gas/smoke'
    name = 'gushing steam'
    desc = "A soft spray of steam gushes out of the broken pipe,
	    spreading over the room. "
    lookInVaporousMsg(obj) {
	return 'Through the billowing steam, you can see the broken pipe responsible for all of this chaos. ';
    }
    initiallyPresent = nil
;

+boilerRoomCupboard : Heavy, KeyedContainer
    vocabWords = 'heavy bulky metal steel industrial cupboard/closet/cabinet'
    name = 'heavy industrial cabinet'
    desc {
	if(isToppled)
	    "The bulky metal cabinet lies on its side, out of the way
	     of the hidden alcove to the west. ";
	else
	    "A bulky metal cabinet stands against the northern end of
	     the west wall. It has a small solid lock set into the
	     doors, and a thin space between it and the north wall. ";
    }
    specialDesc {
	if(isToppled)
	    "An industrial cabinet lies on its side, revealing a
	     hidden alcove in the west wall. ";
	else
	    "In the northwest corner of the room is an industrial
	     metal cabinet. ";
    }
    initiallyLocked = true
    isToppled = nil
    cannotPushMsg = 'The cabinet is flush against the corner and cannot be pushed. '
    cannotMoveMsg = 'The cabinet is too heavy to shift from its place on the floor. '
    nothingBehindMsg {
	if(!isToppled)
	    return 'There is a sliver of space between the
			cupboard and the wall, and it seems like
			there is some recess in the bricks. Odd. ';
	else
	    return 'There isn\'t anything behind the toppled cabinet
		    except for a large scrape along the bricks. ';
    }
    dobjFor(Push) { action() { reportFailure(cannotPushMsg); } }
    dobjFor(Move) asDobjFor(Pull)
    dobjFor(Pull) {
	verify() {}
	check() {
	    if(gPlayerChar.hasHeadache)
		failCheck('You wedge your fingers between the cabinet
			   and the wall and pull hard on the cabinet.
			   Unfortunately the strain exacerbates your
			   monster headache and you give up. If you
			   could get rid of the headache then you
			   might be able to try again without giving
			   yourself brain damage.');
	    
	    if(isToppled)
		failCheck(cannotMoveMsg);
	}
	action() {
	    "Wedging your fingers between the cabinet and the wall,
	     and putting a foot up on the wall, you pull hard on the
	     cabinet. You grunt and strain and finally the cabinet
	     kicks up on one side, hanging momentarily above the
	     fulcrum of the opposite edge, before loudly scraping
	     along the wall and crashing on the ground with a
	     cataclysmic, metallic boom. <.p>As the dust and sound
	     settles, you brush yourself off, stopping to notice a
	     previously hidden alcove behind where the cabinet used
	     to be. ";
	    isToppled = true;
	    // NOTIFY VERN IF HE IS AROUND
	}
    }
;

+ NameAsOther, SecretFixture
    targetObj = boilerRoomCupboard
;

++ ContainerDoor
    vocabWords = '(small) solid lock'
    name = 'small lock'
    desc = "The cabinet is locked with a small lock welded into the
	    door. "
    subContainer = boilerRoomCupboard
    dobjFor(Unlock) remapTo(Unlock, boilerRoomCupboard)
    dobjFor(Lock) remapTo(Lock, boilerRoomCupboard)
;

+boilerToOldStorageDoor : Door
    vocabWords = 'hidden secret old west w alcove/door/west/w'
    name = 'hidden alcove'
    desc = "UNIMPLEMENTED YET. "
    initiallyOpen = nil
    okayOpenMsg = 'The door slowly creaks open, dust trickling from the hinges. '
    okayCloseMsg = 'The door clicks shuts wearily. '
    sightPresence = (boilerRoomCupboard.isToppled)
    isConnectorApparent(origin, actor)
    {
        if (sightPresence) {
	    return inherited(origin, actor);
        }
        else
        {
            return nil;
        }
    }
;
