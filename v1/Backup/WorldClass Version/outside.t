WesternAlleyway: Alleyway
    sdesc = "End of the Alleyway"
    ldesc = "The alleyway ends abruptly here as the building to the south
	     (where you have come from) turns north to nestle itself between
	     two other buildings. There isn't as much rubbish here as the rest
	     of the alleyway to the east, but that\'s relative. However, there
	     is enough grime to make up for it. \n To the south and west the
	     base of the walls are dirty windows, although the southern ones
	     are so short to be almost useless. "
    goEast = CentralAlleyway
    goWest = WesternAlleywayWindows
;

WesternAlleywayWindows: SealedWindow
    location = WesternAlleyway
    noun = 'window' 'windows' 'windowsill' 'sill' 'window sill' 'glass'
    adjective = 'dirty' 'grimy' 'west' 'western'
    sdesc = "<<self.isbroken ? "broken " : "">>windows to the west"
    ldesc = {
	if (not self.isbroken) {
	    "Set into the base of the western wall are a set of <<self.isclean
	     ? "" : "dirty,">> scratched windows. A crack squiggles across one of the panes.\n ";
	    if (self.isclean)
		"Peering through them reveals only murky shapes that lie in the underground room beyond. ";
	    else
		"You can\'t see much through the grime encrusted on the window. ";
	}
	else {
	    if (self.iscleared)
		"The windows set into the base of the western wall have been
		 smashed and cleared out. You still can\'t see much in the
		 room beyond, but you can smell a certain staleness above the
		 odours of the alleyway.";
	    else
		"The windows to the west have been smashed and the broken
		 shards of glass litter the window sill and the surrounding
		 ground. The facade of broken glass and darkness beyond is a
		 little creepy. ";
	}
    }
    isclean = nil
    windowdest = OldStorageSouth
    verDoClean(actor) = {
	if (self.isclean)
	    "You don\'t think you can get the window any cleaner (given the surrroundings).";
    }
    doClean(actor) = {
	"You vigorously rub the window clean of the grime and muck. Your hand
	 ends up with all the gunk, so you wipe them on the wall. ";
	self.isclean := true;
    }
    doEnter(actor) = {
	"Watching carefully for any more broken glass, you slide yourself through the window into the dark room below.";
	pass doEnter;
    }
;

WesternAlleywaySmallWindows: Decoration
    location = WesternAlleyway
    noun = 'window' 'windows'
    adjective = 'south' 'southern' 'small' 'narrow' 'short' 'basement'
    sdesc = "narrow windows to the south"
    ldesc = "The sealed windows sunk deep into the base of the southern wall
	     are barely a few inches high and are terribly dirty. You wonder
	     why someone would bother installing them. Actually, those grimy
	     windows look a lot like the windows in the basement you woke up in... "
    verDoClean(actor) = { "The windows are so small and dirty, you hardly see the point. "; }
;

CentralAlleyway: Alleyway
    noun = 'alleyway'
    sdesc = "Dirty Alleyway"
    ldesc = "You find yourself in a slightly broad alleyway running east-west.
	     The soot-stained brick walls are streaked with rust stains and
	     mould, decorated with a few obligatory spritzes of graffiti. A
	     jumbled pile of garbage sits against the north wall, and reeks of
	     a diverse array of mixed unpleasant odours. Water from various
	     drainpipies and the occasional rain storm has soaked through the
	     refuse, creating an ooze that has creeped across the alleyway
	     making the ground underfoot slippery. Some of the slime has
	     trickled into a few small drains near the base of the walls.
	     Above you there is a fire escape, and to the south three steps
	     lead up to a reinforced steel door. Otherwise this mess of an
	     alleyway continues both east and west."
    grounddesc = {
	local track;
	track := 0;
	"The slime from the garbage has oozed its way across the alleyway and
	 trickled down a small drain. ";
	if (self.hasgoneeast)
	    track += 1;
	if (self.hasgonewest)
	    track += 2;
	switch(track) {
	    case 1:
	        "A set of footprints leading eastward have tracked through the
		 slime. ";
		break;
	    case 2:
		"A set of footprints leading westward have tracked through the
		 slime. ";
		break;
	    case 3:
		"The slime has been muddled up with footprints going in all
		 directions. ";
		break;
	    }
    }
    hasgoneeast = nil
    hasgonewest = nil
    wallsdesc = "The crumbling brick walls are coated with grime and mould.
		 Rust streaks down the wall from the joins of the metal
		 brackets holding the drains and fire escape up. A few
		 splashes of graffiti complete the wall\'s grotty appearance."
    smelldesc = "The overpowering stench of the garbage hangs in the air here. "
    listendesc = "You can hear the occasional dripping drain amidst the quiet
		  trickle of one particular drain that opens over the garbage.
		  Other than that, there is an uneasy silence. "
    goEast(actor) = {
	self.hasgoneeast := true;
	return EasternAlleyway;
    }
    goWest(actor) = {
	self.hasgonewest := true;
	return WesternAlleyway;
    }
    goSouth(actor) = ReinforcedAlleywayDoor
;

ReinforcedAlleywayDoor: Door
    location = CentralAlleyway
    noun = 'door' 'doorway' 'exit' 'entrance' 'south'
    adjective = 'reinforced' 'steel' 'south' 'huge' 'old' 'big' 'rusted' 'rusty'
    sdesc = "the reinforced steel door"
    ldesc = "The huge steel door to the south looks very much like the other
	     side of the door you saw in the back room. This side has its
	     share of rust blotches and cracked blue paint. Someone has
	     recently spray-painted a gang sign on the door, over all the
	     discolorations and cracks. "
    touchdesc = "Chips of blue paint crumble beneath your fingers. The cold
		 metal frame is abrasive from the peeling paint and the dried
		 rust.\b You look at your fingers and brush the junk off."
    tastedesc = "Didn\'t your mother tell you about eating paint chips?"
    smelldesc = "You gingerly sniff the door, accidentally inhaling a tiny
		 paint fleck. You stagger backwards, trying to sneeze. After
		 thrashing about for a little while, you blow it out and stand
		 back, rubbing your nose. "
    isdetermined = true
    islocked = true
    isopen = nil
    hasknockedon = 0
    key = DummyItem
    verDoOpen(actor) = { "You try to push open the door but it barely rattles in response."; }
    verDoUnlockWith(actor) = {
	"Even if that could actually unlock the door, the lock has been
	 plugged up with a decades-old, rock-hard piece of chewing gum.
	 Nevertheless, you have little faith that you have, or even could
	 have, the appropriate key. "; }
    destination(actor) = { "Despite your best attempts, the door will not open. ";}
    verDoKnockon(actor) = {}
    doKnockon(actor) = {
	switch(self.hasknockedon) {
	    case 0:
		"You knock on the metal door, hurting your knuckles. What's worse it that you doubt anyone heard it. ";
		self.hasknockedon += 1;
		break;
	      case 1:
		"Being more careful this time, you bash on the door with your fist. The dull thumps go unanswered. ";
		self.hasknockedon += 1;
		break;
	      case 2:
		"You thump on the door with your fist. The echoes die away, yet no-one answers the door. ";
		self.hasknockedon := rnd(2)+1;
		break;
	      case 3:
		"You slap on the door several times, to no avail. ";
		self.hasknockedon := rnd(2)+1;
		break;
	    }
    }
;

CentralAlleywaySlime: Decoration
    location = CentralAlleyway
    noun = 'slime' 'muck' 'ooze' 'gunk' 'concrete'
    adjective = 'oozing' 'garbage' 'rubbish' 'trash'
    sdesc = "slime"
    ldesc = CentralAlleyway.grounddesc
    tastedesc = "Dear God, no! You have more sense than to lick <I>the slime
		 off the ground!</I> "
    touchdesc = "You warily slide your fingertips through the slime. The
		 greyish-brown sludge sticks to your fingers and you twist
		 your mouth in revulsion. You hurriedly shake the slime off
		 your finger and wipe the residual on the wall. "
    smelldesc = "You're not sure you can differentiate between the stink of
		 the slime and the garbage. After all, the slime is just the
		 liquid form of the garbage. "
    listendesc = "Try as you might, you cannot hear the slow march of the
		  slime across the alleyway. "
    verDoClean(actor) = { "There are more futile activities around, but not many. "; }
    verDoEat(actor) = { "Have you gone completely mad?! This is <I>slime</I>,
			 on the <I>ground</I>, in a <I>disgusting
			 alleyway!</I> "; }
    verDoDrink(actor) = { "Even though the slime is sloppy enough to try to
			   drink, you think you better not. "; }
    verDoWear(actor) = { "Scooping up the slime and slathering it all over
			  yourself doesn\'t seem like the smartest idea at the
			  moment. "; }
    verDoTake(actor) = { }
;

CentralAlleywayDrain: Decoration
    location = CentralAlleyway
    noun = 'drain' 'drainpipe' 'drainage' 'pipe' 'drains' 'drainpipes' 'pipes'
    adjective = 'drain'
    sdesc = "drainpipes"
    ldesc = "The pipes that collect runoff from above and drain out into the
	     alleyway are more suggestions of drainage than actual examples of
	     such. They are attached to the brick by a few bolts and a prayer.
	     Some have rusted through, whilst others have buckled in places. "
    isdetermined = true
    isplural = true
    smelldesc = "The drain\'s smell is a unique blend of mould, muddy water
		 and sharply metallic rust. "
    touchdesc = "The rusty metal is slightly rough. After you remove your
		 fingers from the drain, it suddenly shifts and you back away
		 before it collapses on you. "
    tastedesc = "You prefer to guess that it tastes metallic rather than test that theory. "
    listendesc = "You hear an interesting mix of echoing drips, trickles and
		  the wind whipping past the end of the drain. "
    verDoClimb(actor) = { "Although your fall would probably be buffeted by
			   the garbage piles, you don\'t want to risk climbing
			   the frail pipes. "; }
    verDoPull(actor) = { "You think it unwise to pull down the drains. It'd
			  ruin the whole aesthetic! "; }
    verDoLookin(actor) = {}
    doLookin(actor) = { "You peer inside the drain, but only see the trickle
			 of dirty water. "; }
    verDoDrink(actor) = { "You look at the dirty water dribbling from the
			   drain and decide not to. ";}
    verDoEnter(actor) = { "You\'ve seen too many movies involving magic
			   leprechauns... "; }
    doSynonym('Pull') = 'Detach' 'Unfasten'
    doSynonym('Enter') = 'Getin'
;

CentralAlleywayGarbage: Decoration
    location = CentralAlleyway
    noun = 'garbage' 'trash' 'rubbish' 'refuse' 'junk'
    adjective = 'pile' 'mound' 'smelly' 'dirty'
    sdesc = "pile of garbage"
    ldesc = "For whatever reason, someone chose this area to dump their refuse
	     and everyone else has followed suit. The mound of garbage
	     consists of table scraps, plastic bags spilling out their junky
	     insides, torn up boxes, smashed up furniture and mind-bogglingly
	     unidentifiable other stuff. The whole mess is sodden with water
	     spilled onto it by the drains. A vacation site only Oscar the
	     Grouch could love. "
    isplural = true
    hasbeensearched = nil
    smelldesc = "You take a big whiff of the garbage and are rewarded with
		 nothing either unexpected or appealing. "
    touchdesc = "Just as you expected - it feels like squishy, slimy, dirty garbage. "
    tastedesc = "You wouldn\'t taste the garbage on a dare. "
    listendesc = "You put your ear near the garbage, expecting to hear the
		  ocean. No wait, that\'s seashells. "
    verDoClimb(actor) = { "This is one mountain you wouldn\'t want to conquer."; }
    verDoEat(actor) = { "You are neither a goat nor a contestant on a reality
			 TV show. You leave the garbage uneaten. "; }
    verDoClean(actor) = { "Although your civic pride is admirable, you doubt
			   you could do much better than relocating the
			   garbage from here to somewhere nearby. It isn\'t
			   worth the effort. "; }
    verDoTake(actor) = { "Seriously, you can\'t possibly want to carry around
			  any of this junk. It doesn\'t even have sentimental
			  value! "; }
    verDoSearch(actor) = { if (self.hasbeensearched)
			       "You have searched through the garbage as much as you can stomach. "; }
    doSearch(actor) = {
	"You gingerly poke through the refuse, hoping to find something
	 worthwhile. You were too hopeful. ";
	self.hasbeensearched := true;
    }
    verDoPoke(actor) = {}
    doPoke(actor) = { "You prod the garbage with your shoe but you don\'t
		       uncover anything interesting (or appetising)."; }
    verDoKick(actor) = {}
    doKick(actor) = { "You give the garbage a hefty booting, but are only
		       rewarded with a dull squish. You wipe a piece of junk
		       off your shoe onto the wall. "; }
    verDoHit(actor) = { "You think about giving the garbage a bunch of fives,
			 but figure it\'d probably give you tetanus in return.
			 "; }
    verDoEnter(actor) = { "Even if there was some hidden pathway underneath
			   all that rubbish (which there isn\'t), you feel
			   that burying yourself in the garbage is A Bad
			   Thing(tm). "; }
    verDoWear(actor) = { "You already have a fine set of clothes and don\'t
			  need to resort to wearing slimy, rotten plastic
			  bags. "; }
    verDoSiton(actor) = { "The squishy garbage might be comfortable, but you
			   figure you wouldn\'t want an embarrassing smudge on
			   the seat of your pants. "; }
    doSynonym('Clean') = 'Clear'
    doSynonym('Search') = 'Lookthrough'
    doSynonym('Enter') = 'Getin' 'Getunder' 'Sitin'
    doSynonym('Climb') = 'Standon' 'Stand'
;

CentralAlleywayGraffiti: Readable, Decoration
    location = CentralAlleyway
    noun = 'graffiti' 'graffitti' 'grafiti' 'grafitti'
    adjective = 'spritz' 'spray'
    sdesc = "graffiti"
    ldesc = "In the usual weird style of the \"street-artist\", the graffiti
	     is made up of various \"tags\", some readable some not. A few of
	     the pieces of graffiti look to be quite old and have faded
	     substantially. "
    readdesc = {
	local i;
	if (length(self.templist) = 0)
	    self.templist := self.graffitilist;
	i := rnd(length(self.templist));
	say(self.templist[i]);
	self.templist := self.templist - self.templist[i];
    }
    graffitilist = [ 'One slapdash effort in red looks like it says, \"murder.com\". ' 'In one corner someone has painted a doped-up looking smiley face with suggestive lackadaisical soft lines. ' 'In several little nooks and crannies, someone has used a marker to write their tag but you have no idea what it says. Maybe the guy\'s name is \"Wiggly line\"? ' 'Someone has prominently sprayed \"FACK\" on the south wall. Weird. ' 'An immature someone has spray-painted a woman near the garbage in a very unsubtle pose. ' 'On a large piece of piping you barely make out some small, rambling essay written on with a marker. You think it\'s something about the government and other scoundrels. ']
    templist = [ 'One slapdash effort in red looks like it says, \"murder.com\". ' 'In one corner someone has painted a doped-up looking smiley face with suggestive lackadaisical soft lines. ' 'In several little nooks and crannies, someone has used a marker to write their tag but you have no idea what it says. Maybe the guy\'s name is \"Wiggly line\"? ' 'Someone has prominently sprayed \"FACK\" on the south wall. Weird. ' 'An immature someone has spray-painted a woman near the garbage in a very unsubtle pose. ' 'On a large piece of piping you barely make out some small, rambling essay written on with a marker. You think it\'s something about the government and other scoundrels. ']
    touchdesc = "The graffiti (unsurprisingly) feels like the surface it was
		 painted on. Some of the paint is smeared on your fingertips
		 but you rub it off. "
    tastedesc = "If you\'re trying to get high by licking old paint, you may
		 want to reconsider your life. "
    smelldesc = "The paint smell is long gone and would still be overpowered
		 by the garbage even if it hadn\'t."
    listendesc = "You listen to what the graffiti has to say (metaphorically)
		  but decide not to follow up on its crude directions. "
    verDoClean(actor) = { "Your civic pride is admirable, but cleaning up one
			   scrap of graffiti here would leave countless more
			   unassailed. Plus, if you want to be do something
			   for your community you should do it where everyone
			   can see you doing it. ";
		      }
    verDoKick(actor) = { "\"Mess up my buildings, eh? Take that!\" you shout,
			  assailing the wall. The graffiti seems unaffected by
			  your well-intentioned attack. ";
		     }
    doSynonym('Kick') = 'Hit'
;

CentralAlleywayStairs: Stool, Decoration
    location = CentralAlleyway
    noun = 'stairs' 'steps'
    adjective = 'three' '3' 'small' 'few'
    sdesc = "small steps leading up to the door"
    ldesc = "Three squat concrete steps lead up to the reinforced door to the
	     south. The stairs themselves are unremarkable - their most
	     interesting features are the scuff marks and chips in the
	     concrete. "
    touchdesc = "You run your fingers along the rough surface of the stairs,
		 leaving a (relatively) clear line through the dust. "
    listendesc = "You wait patiently for the steps to make some noise. You
		  eventually stop, disappointed but unsurprised. "
    tastedesc = "Alleyway stairs are a delicacy you choose to be ignorant of. "
    smelldesc = "You can\'t smell anything over the pungent aroma of the garbage. "
    reachable = [ CentralAlleywaySlime ReinforcedAlleywayDoor Sky Ground Walls]
;

EasternAlleyway: Alleyway
    sdesc = "Fenced end of the alleyway"
    ldesc = "This section of the backstreet is a little less rubbish-ridden
	     than the areas to the west, mostly because it is not quite a
	     pocket for garbage to collect in, and partly because of luck. The
	     alleyway continues on to the east before turning south to
	     somewhere brighter, to the main street you guess. But you may
	     find out because a high chain-link fence cuts across the alleyway
	     to your immediate east. Alternatively, to the north is rear
	     entrance, or you can revisit the refuse to the west."
    smelldesc = "Sporadic breezes wending their way from the east whisk away
		 the stench of the rubbish, but replace it with the cold,
		 lifeless smell of concrete. "
    listendesc = "Other than faint dripping to the west and the gentle whistle
		  of wind through the fence, this place is oddly quiet. Not
		  even a whisper of traffic or the commotion of the city.
		  Weird. "
    goWest = CentralAlleyway
    goEast(actor) = { "You can\'t venture eastwards with that fence blocking your way! "; }
;

ChainlinkFence: Fixture
    location = EasternAlleyway
    noun = 'fence' 'barrier' 'enclosure' 'east'
    adjective = 'steel' 'chain' 'chain-link' 'chainlink' 'wire' 'eastern'
    sdesc = "chain-link fence"
    ldesc = "The fence spreads from wall to wall with no gaps either side. The
	     chain-links have been weathered somewhat, but remain resilient.
	     They all remain strongly welded to the metal frame and give no
	     opportunity to squeeze through. What\'s worse is the menacing
	     rows of barbed wire strung across the top. The definite
	     impassability of the whole fence is disheartening. "
    smelldesc = "You catch a whiff of some of the breezes whistling through
		 the fence. All smell like bland, cold concrete."
    listendesc = "The breeze whistles through the fence as though it had
		  nothing better to do. The fence clinks as it sways in the
		  occasional stronger gusts. "
    tastedesc = "You cautiously give a quick lick to a seemingly clean section
		 of the fence. The steel taste is unsatisfying and you feel
		 foolish. "
    verDoLookthrough(actor) = {}
    doLookthrough(actor) = { "The backstreet continues eastwards for about thirty feet before turning south to the sunshine of the main street. "; }
    verDoPull(actor) = {}
    doPull(actor) = {
	switch(rnd(4)) {
	    case 1:
	    "You shake the fence to only dramatic effect. ";
	    break;
        case 2:
	    "The fence merely rattles at your attempts to get through. ";
	    break;
	case 3:
	    "The fence is unaffected by your passionate assault. ";
	    break;
	case 4:
	    "Try as you might, the fence will not yield to your might and fury. ";
    }
    }
    verDoClimb(actor) = { "You could easily climb the fence, if it weren\'t for the vicious barbed wire at the top. "; }
    verDoGetunder(actor) = { "The gap underneath the fence is barely an inch high, and let\'s be honest, your attempts at dieting haven\'t been <I>that</I> successful. "; }
    verDoLookunder(actor) = {}
    doLookunder(actor) = { "Between the metal frame and the concrete there is a gap of about an inch high. "; }
    verDoUnscrew(actor) = { "The fence has been bolted onto the brick wall, preventing any attempt to remove it. "; }
    verIoUnscrewwith(actor,io) = { "The fence has been bolted onto the brick wall, preventing any attempt to remove it. "; }
    verIoPutunder(actor,io) = { "Even if that could fit underneath the fence, you wouldn\'t be able to get it back, so you decide against it. "; }
    verIoPutthrough(actor,io) = { "Even if that could fit through the fence, you wouldn\'t be able to retrieve it. You decide to keep <<io.objthedesc>>. ";}
    verDoBreak(actor) = { "Maybe if you were The Hulk then you could smash down the fence, but we wouldn\'t want to get you angry. "; }
    doSynonym('Pull') = 'Push' 'Shake' 'Hit' 'Kick' 'Poke'
    doSynonym('Lookthrough') = 'Lookbehind'
    doSynonym('Unscrew') = 'Detach' 'Unfasten' 'Remove'
    doSynonym('Unscrewwith') = 'Detachfrom'
    doSynonym('Putunder') = 'Throwunder'
    doSynonym('Putthrough') = 'Putbehind' 'Throwthrough' 'Throwbehind'
;

