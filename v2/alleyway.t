#include <convolution.h>

/* 
 *   The alleyway.
 *
 *   This is a L-shaped alleyway behind Convolution Towers. The purpose of 
 *   these rooms is to give a bit of atmosphere, hide a few Easter eggs, 
 *   provide a way to the first level and space out the first room from the 
 *   Towers itself.
 */

// TODO
// Door to back room
// Fire escape?
// More props

alleywaySouth : OutdoorRoom
    roomName = 'Southern end of an alleyway'
    
    desc = "You find yourself at the end of a slightly broad alleyway that heads
        north before zagging east. The alleyway itself is a tangle of pipes and
        graffiti, fringed with a damp sludge of refuse, ending with a plain
        white doorway leading down to the basement where you came to. "
    
    east = alleywayEast
    north asExit(east)
    northeast asExit(east)
    south = alleywayDoorToWarehouse
    down asExit(south)
    
;

+ alleywayDoorToWarehouse : ThroughPassage
    vocabWords = 'doorway/door/passage/entrance/down/south'
    name = 'doorway'
    
    desc = "A plain doorway leading to a set of stairs going down. "
;

+ SimpleNoise 'trickle/trickling/drip/drips/dripping' 'dripping drain'
    "You can hear the occasional dripping drain amidst the quiet
     trickle of one particular drain that opens over the garbage.
     Other than that, there is an uneasy silence. "
;

+ SimpleOdor 'stench/smell/air' 'stench'
    "The air here is drenched with the smell of garbage kept soggy by a
    dripping drain. "
;

+ Decoration
    vocabWords = 'damp soggy wet junk/garbage/trash/refuse/muck/gunk'
    name = 'garbage'
    
    desc = "Garbage collects against the base of the alleyway walls here. It's
        unidentifiable muck, kept damp by dripping downpipes. "
    
    smellDesc = "The air here is drenched with the smell of garbage kept soggy
        by a dripping drain. "
    
;

+ Fixture
    vocabWords = 'down downpipes/pipes/drain/drains/drainage'
    name = 'pipes'
    
    desc = "A crazy weave of pipes hang off the buildings here. The pipes that
        collect runoff from above and drain out into the alleyway are more
        suggestions of drainage than actual examples of such. They are attached
        to the brick by a few bolts and a prayer. Some have rusted through,
        whilst others have buckled in places. "
    
    smellDesc = "The drains smell of a unique blend of mould, muddy water and
        sharply metallic rust. "
    feelDesc = "The rusty metal is slightly rough. After you remove
		your fingers from the drain, it suddenly shifts and
		you back away before it collapses on you. "
    tasteDesc = "You prefer to guess that it tastes metallic rather
		 than test that theory. "
    soundDesc = "You hear an interesting mix of echoing drips,
		  trickles and the wind whipping past the end of the
		  drain. "
    
    isPlural = true
;

+ Readable, Decoration
    vocabWords = 'spritz spray various scattered graffiti/graffitti/grafiti/grafitti/writing'
    name = 'graffiti'
    desc = "In the usual weird style of the <q>street-artist</q>, the graffiti
        is made up of various <q>tags</q>, some readable some not. A few of the
        pieces of graffiti look to be quite old and have faded substantially. "
    readDesc { say(graffitiList.getNextValue()); }
    graffitiList : ShuffledList {
	valueList = [ 'One slapdash effort in red looks like it says,
            <q>murder</q>. ',
		     'In one corner someone has painted a doped-up looking
                     smiley face with suggestive lackadaisical soft lines. ',
		     'In several little nooks and crannies, someone has used a
                     marker to write their tag but you have no idea what it
                     says. Maybe the guy\'s name is <q>Wiggly line</q>? ',
		     'Someone has prominently sprayed <q>FACK</q> on the south
                     wall. Weird. ',
		     'An immature someone has spray-painted a woman near the
                     garbage in a very unsubtle pose. ',
		     'The number <q>777</q> has been sprayed up high in Kermit
                     the Frog green. ',
		     'On a large piece of piping you barely make out some
                     small, rambling essay written on with a marker. You think
                     it\'s something about the government and other
                     scoundrels. '] }
    feelDesc = "The graffiti (unsurprisingly) feels like the surface it was
        painted on. Some of the paint is smeared on your fingertips but you rub
        it off. "
    tasteDesc = "If you find yourself in a back alley licking old paint, you
        may want to take stock of your life. "
    smellDesc = "The paint smell is long gone and would still be overpowered by
        the garbage even if it hadn\'t."
    soundDesc = "You listen to what the graffiti has to say (metaphorically)
        but decide not to follow up on its crude directions. "
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

/*
 *   The eastern part of the alleyway.
 *
 *   This finishes up behind Convolution Towers.
 *
 */

alleywayEast : OutdoorRoom
    roomName = 'East end of an alleyway'
    
    desc = "This section of the backstreet is a little less rubbish-ridden than
        the areas to the west, mostly because it is not quite a pocket for
        garbage to collect in, and partly because of luck. Here the soot-stained
        brick walls are streaked with rust stains and mould, decorated with a
        few obligatory spritzes of graffiti.  The alleyway continues on to the
        east before turning south to somewhere brighter, to the main street you
        guess. But you may never find out because a high chain-link fence cuts
        across the alleyway, blocking the way out. Alternatively, to the south
        is the rear entrance of some building, or you can revisit the refuse to
        the west. "
    
    smellDesc = "Sporadic breezes wending their way from the east whisk away
        the stench of the rubbish, but replace it with the cold, lifeless smell
        of concrete. "
    
    soundDesc = "Other than faint dripping from around the corner and the
        gentle whistle of wind through the fence, this place is oddly quiet.
        Not even a whisper of traffic or the commotion of the city. Weird. "
    
    roomAfterAction() {
	if(!haveDoneCreepyCallers) {
	    officePhone.connectCall( creepyCallers );
	    haveDoneCreepyCallers = true;
	}
    }
    haveDoneCreepyCallers = nil
    
    west = alleywaySouth
    southwest asExit(south)
    east : NoTravelMessage { "You can\'t venture eastwards with that fence
        blocking your way! "; }
    
    south = backRoom
    
;

+ chainlinkFence: Fixture
    vocabWords = 'steel chain chain-link chainlink wire eastern east e
        fence/barrier/enclosure/east/e'
    name = 'chain-link fence'
    desc = "The fence spreads from wall to wall with no gaps either side. The
        chain-links have been weathered somewhat, but remain resilient. They
        all remain strongly welded to the metal frame and give no opportunity
        to squeeze through. What\'s worse is the menacing rows of barbed wire
        strung across the top. The definite impassability of the whole fence is
        disheartening. "
    smellDesc = "You catch a whiff of some of the breezes whistling through the
        fence. All smell like bland, cold concrete."
    soundDesc = "The breeze whistles through the fence as though it had nothing
        better to do. The fence clinks as it sways in the occasional stronger
        gusts. "
    tasteDesc = "You cautiously and quickly lick to a seemingly clean section
        of the fence. The steel taste is unsatisfying and you feel foolish. "
    pullMsgs : ShuffledList {
        valueList = ['You shake the fence to only dramatic effect. ',
            'The fence merely rattles at your attempts to get through. ',
            'The fence is unaffected by your passionate assault. ',
            'Try as you might, the fence will not yield to your might and fury. '] }
    dobjFor(LookThrough) {
	verify() {}
	action() {
	    mainReport('The backstreet continues eastwards for about thirty
                feet before turning south to the sunshine of the main
                street. ');
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
	    "You could easily climb the fence, if it weren\'t for the vicious
            barbed wire at the top. ";
	    exit;
	}
    }
    dobjFor(GetUnder) {
	verify() {}
	check() {
	    "The gap underneath the fence is barely an inch high, and let\'s be
            honest, your attempts at dieting haven\'t been <I>that</I>
            successful. ";
	    exit;
	}
    }
    dobjFor(LookUnder) {
	verify() {}
	action() {
	    mainReport('Between the metal frame and the concrete there is a gap
                of about an inch high. ');
	}
    }
    dobjFor(Unscrew) {
	verify() {}
	check() {
	    "The fence has been bolted onto the brick wall, preventing any
            attempt to remove it. ";
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
	    "Even if {the dobj/him} could fit underneath the fence, you
            wouldn\'t be able to get it back, so you decide against it. ";
	    exit;
	}
    }
    iobjFor(PutBehind) {
	verify() {}
	check() {
	    "Even if that could fit through the fence, you wouldn\'t be able to
            retrieve it. You decide to keep {the dobj/him}. ";
	    exit;
	}
    }
    iobjFor(ThrowThrough) remapTo(PutBehind,DirectObject,self)
    iobjFor(ThrowBehind) remapTo(PutBehind,DirectObject,self)
    iobjFor(PutIn) remapTo(PutBehind,DirectObject,self)
    dobjFor(Break) {
	verify() {}
	check() {
	    "Maybe if you were The Hulk then you could smash down the fence,
            but we wouldn\'t want to see you when you\'re angry. ";
	    exit;
	}
    }
    dobjFor(JumpOver) {
        verify() {}
        check() {
            "The fence is way too high for you to jump over, especially with the
            angry tangle of barbed wire at the top. ";
            exit;
        }
    }
;