#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// The lunch room

lunchRoom : Room
    name = 'Lunch Room'
    destName = 'the lunch room'
    desc = "You guess this must be for the lower-rung employees -
	    cleaners and the like. The room is almost entirely made
	    of drab linoleum and has a faint artificial
	    lemon-scented floor cleaner smell to it. The single
	    light above is so old that it emits a weird green-grey
	    light, not helping the atmosphere at all. The door
	    leading out to the south is <<lunchRoomDoor.openDesc>>. "
    south = lunchRoomToHallwayDoor
    out asExit(south)
;

+ SimpleOdor 'faint artificial linoleum lemon scented lemon-scented floor cleaner smell/odor/odour/scent' 'linoleum smell'
    "The stale linoleum smell is almost saturated in the
     lemon-scented floor cleaner that they obviously use here."
;

+ lunchRoomToHallwayDoor : Door ->lunchRoomDoor 'door leading s south out/door/doorway/south/s' 'door leading out'
    "A plain wooden door. It is covered in some cheap grey-blue
     paint that hasn't started to flake yet, but threatens to. "
    initiallyOpen = true
    openDesc = ( isOpen ? 'wide open' : 'closed, revealing a poster')
    makeOpen(val) {
	inherited(val);
	lunchRoomPoster.makeVisible(!val);
    }
    okayOpenMsg = 'The door swings open easily. It continues gliding all the way to the wall where it stops with a light bump. '
    okayCloseMsg = 'You shut the door with a light push. You notice a poster stuck to the back of the door. '
    contentsLister = surfaceContentsLister
    descContentsLister = surfaceDescContentsLister
    lookInLister = surfaceLookInLister
    dobjFor(LookThrough) { verify() { logicalRank(75, 'not preferred'); } }
;

++ lunchRoomPoster : Component, Readable
    vocabWords = 'motivational cold war poster/picture/notice/sign'
    name = 'motivational poster'
    desc = "Stuck to the back of the door is a motivational poster
			for the cleaners. It looks like it survived the Cold
			War. The poster is divided into two pictures top and
			bottom, divided by a line of bold text. The top picture
			is a beautiful, enthusiastic young woman merrily pushing
			a mop around. Below it is a frumpy old woman slouching
			over a cup of coffee, a crumpled cigarette hanging from
			her sour mouth. The big block letters between them asks,
			<q>What is your purpose here?</q> \b You wouldn\'t be
			surprised to see a little line saying <q>Brought to you
			by your local Friendly Fascist Work Ethics
			Committee.</q> "
    makeVisible(val) {
	isListed = val;
	sightPresence = val;
    }
    isListed = nil
    sightPresence = nil
    initNominalRoomPartLocation = lunchRoomToHallwayDoor
;


+lunchRoomTable : ComplexContainer, CustomImmovable '(lunch) blue drab linoleum vinyl table' 'lunch room table'
    "Sitting smack-dab in the middle of the lunch room is the lunch
     table. The drab blue-speckled linoleum surface reminds you of a
     card table you used to own, only bigger and evidently heavier. "
    specialDesc = "The middle of the room is occupied by a drab linoleum table. "
    cannotTakeMsg = '{You\'re/he\'s} not too sure how they got the
		     table in here, but {you/he} {is} sure that
		     it\'d be difficult to get it out, especially by
		     yourself. At any rate, the table is far from
		     travel-handy. '
    subSurface : ComplexComponent, Surface { }
    subUnderside : ComplexComponent, Underside { }
;

+lunchRoomChair : Chair, Fixture 'chair/seat' 'chair'
    "This unassuming plastic chair sits quietly behind the chunky
     lunch room table. "
    cannotTakeMsg = 'The management would probably disapprove of you
		     stealing their furniture, regardless of how
		     worthless it is. '
;

+lunchRoomBench : Surface 'cold grey gray linoleum vinyl bench/surface' 'lunch room bench'
    "A narrow grey bench abuts most of the walls in this room. It is
     covered with stains, cigarette burns, coffee rings, scratches
     and the occasional gouging. The vinyl surface itself is clean -
     just not in good shape. "
    specialDesc = "A cold grey bench rings most of the room. The
		   only interesting things on it are a microwave and
		   a coffee machine. "
    listWith = [lunchRoomMainFixturesGroup]
    specialDescListWith = [lunchRoomMainFixturesGroup]
    contentsListed = nil
    contentsListedInExamine = true
    contentsLister : ContentsLister, lunchRoomBenchBaseSurfaceContentsLister {}
    descContentsLister : DescContentsLister, lunchRoomBenchBaseSurfaceContentsLister {}
    lookInLister : DescContentsLister, lunchRoomBenchBaseSurfaceContentsLister {
	showListEmpty(pov, parent) {
	    gMessageParams(parent);
	    defaultDescReport('{You/he} see{s} nothing on {the parent/him}. ');
	}
    }
;

// To reduce bloat
++lunchRoomBenchBaseSurfaceContentsLister : Lister
    showListPrefixWide(itemCount, pov, parent) { "Spaced vaguely regularly along <<parent.theNameObj>> <<itemCount == 1 ? 'is' : 'are'>> a few things, namely "; }
    showListSuffixWide(itemCount, pov, parent) { ". "; }
    showListPrefixTall(itemCount, pov, parent) { "Spaced vaguely regularly along <<parent.theNameObj>> <<itemCount == 1 ? 'is' : 'are'>>:"; }
    showListContentsPrefixTall(itemCount, pov, parent) { "<<parent.aName>>, on which <<itemCount == 1 ? 'is' : 'are'>>:"; }
;

++lunchRoomSink : Sink 'basin/sink' 'sink'
    "A tarnished steel sink has been installed in the bench, at the
     far end of the room. "
    descContentsLister : thingDescContentsLister {
	showListPrefixWide(itemCount, pov, parent) {"At the bottom of the sink is ";}
    }
;

++ lunchRoomMicrowave : Electrical, ComplexContainer, CustomImmovable 'modern microwave nuke-cycle nuke cycle dual microwave/oven/nuker' 'microwave'
    "Surprisingly, the microwave in here is relatively new. It has
     all the fancy settings you\'d ever want, heralding a new era in
     microwave cookery (or so the label says). The sleek white
     exterior is disappointed by the depressing lighting in here. "
    cannotTakeMsg = 'Stealing bulky appliances is the realm of a
		     cash-starved crack addict. You are not one of
		     them, nor should you want to be. '
    // Include cannotMoveMsg etc???
    subContainer : ComplexComponent, OpenableContainer {
	material = glass
        lookInDesc = "Peering through the grille window on the door
		      you see the rather spartan insides of the
		      microwave. "
	contentsListed = nil
	descContentsLister : thingContentsLister {
	    showListEmpty(pov, parent)
	    {
		"\^<<parent.openStatus>>. ";
	    }
	    showListPrefixWide(itemCount, pov, parent)
	    {
		if(parent.isOpen)
		    "\^<<parent.openStatus>>, revealing ";
		else
		    "\^<<parent.openStatus>>. Through the grille you can see ";
	    }
	}
	openStatus() { return openDesc;}
	openDesc = (isOpen ? 'The door hangs open lightly' : 'The door is shut')
	okayOpenMsg = 'You push the <q>open</q> button and the microwave does so with a plastic <i>clunk!</i> '
	okayCloseMsg = 'The microwave door clicks shut. '
    }
    dobjFor(Read) remapTo(Read, lunchRoomMicrowaveLabel)
    // Include change if you've been disconnected?
    isListedAsAttachedTo(obj) { return nil;}
    isListedInContents = true
;

+++ ContainerDoor '(microwave) door' 'microwave door'
    "The microwave door is made out of a sleek moulded plastic and
     has the usual grille window. Stuck on the window is a bright
     blue and yellow sticker, advertising the product. "
    material = glass
    owner = lunchRoomMicrowave
    subContainer = lunchRoomMicrowave.subContainer
    dobjFor(Read) remapTo(Read, lunchRoomMicrowaveLabel)
    dobjFor(LookThrough) asDobjFor(LookIn)
    dobjFor(Examine) { verify() { inherited(); logicalRank(75, 'not preferred'); } }
;

++++ lunchRoomMicrowaveLabel : Component, Readable '(microwave) label/sign/sticker' 'sticker on the microwave'
   "The bright blue and yellow sticker on the microwave door
    exclaims:\b <bq><font face='Impact, TADS-Sans'
    size=+2><CENTER>HERALDING A NEW ERA IN MICROWAVE COOKERY!\b
    <font color=#666699><b>NUKE-CYCLE DUAL!!!</b></font>\b Now with
    defrost, reheat, melt, boil and <font
    color=#FFCC66><i>ultra-nuke</i></font> \n settings controlled*
    by a fuzzy logic cyber interface.\b <font face='TADS-Sans'
    size=-4>* May malfunction if used with metallic objects.
    Nukrowave Corp. waives all responsibility in the event of
    improper use.</font></CENTER></font></bq>"
; //"

++Component 'occasional gouging/gouge/gouges/scratch/scratches/mark/marks/dint/dints/scrape/scrapes' 'scratches'
    "The bench has sustained many scratches and dints over the
     years, though a little more than expected. You guess the bleak
     surroundings make for careless workers (or ones with displaced
     anger). "
    owner = lunchRoomBench
    isPlural = true
;

++Component 'cigarette burn/burns' 'cigarette burns on the bench'
    "Here and there you can see where someone has mistakenly stubbed
     out a cigarette on the vinyl bench top. Then again, it could be
     intentional. "
    owner = lunchRoomBench
    isPlural = true
;

++Component 'coffee rings/stains' 'stains on the bench'
    "Near the sink the vinyl has been stained with a technicolour of
     food splotches. Correspondingly, near the coffee machine there
     are coffee rings on the bench, making a chaotic pattern of
     interconnected circles. "
    owner = lunchRoomBench
    isPlural = true
;


// ADD A SEPARATE NOTE OBJECT AND REMAP
++CustomImmovable 'broken automatic coffee machine' 'coffee machine'
    "A bulky grey automatic coffee machine fills in some of the
     space between the sink and the microwave. The grey plastic is
     sickly under this light. A small scrap of paper has been taped
     to the machine, reading: <BQ><q>Machine broke. Mngmt order new
     one.</q></BQ>Tough break..."
    isListedInContents = true
    cannotTakeMsg = 'The machine is too bulky to carry away with you, and it\'s broken. '
    dobjFor(Kick) {
        preCond = [touchObj]
        verify() {}
	action() {
	    defaultReport('You\'re sure a few caffeine-starved workers have thought about it from time to time, so you should leave the pleasure to them. After all, they deserve it. ');
	}
    }
    dobjFor(Attack) asDobjFor(Kick)
    dobjFor(Punch) asDobjFor(Kick)
    iobjFor(PutIn) {
        preCond = []
	verify() {}
	check() {
	    if(gDobj.ofKind(Coin))
		"The machine is broken. You wouldn\'t want to waste your coin. ";
	    else
		"{You/he} can\'t put anything in {the iobj/him}. ";
	    exit;
	}
    }
;

+lunchRoomMicrowavePowerSocket : PowerSocket 'wall electrical power point/socket/plug/outlet' 'electrical socket'
    desc = "Tucked behind the microwave is a simple power socket for
	    the microwave itself. It\'s currently <<isOn ? 'on' :
	    'off'>>. "
    isOn = true
    attachedObjects = [lunchRoomMicrowave]
;


// The refrigerator
// ADD an autoclose to it.
+lunchRoomFridge : Refrigerator
    vocabWords = 'square white wan sickly mundane uncheerful refrigerator/fridge/chiller/icebox'
    name = 'refrigerator'
    desc = "The lunch room has been supplied with an ordinary white
	    refrigerator. However, the wan lighting degrades its
	    mundane appearance even further. And the workers are
	    suggested to leave their lunches in this uncheerful
	    appliance... "
    specialDesc = "A square, white refrigerator has been wedged
		   between the end of the bench and the wall. "
    lookInDesc = "The interior of the fridge is as uninspiring as
		  the outside. The walls are a pallid white, made
		  more dull by the orange light inside. The racks
		  are old-style thin metal bars rather than
		  transparent plastic. You crinkle your nose when
		  notice the cold, stale smell emanating from the
		  fridge. The whole thing is not unexpected for
		  communal refrigeration, but still is unpleasant. "
    listWith = [lunchRoomMainFixturesGroup]
    specialDescListWith = [lunchRoomMainFixturesGroup]
    descContentsLister : thingContentsLister {
	showListEmpty(pov, parent)
	{
	    "\^<<parent.openStatus>> ";
	}
	showListPrefixWide(itemCount, pov, parent)
	{
	    if(parent.isOpen)
		"\^<<parent.openStatus>>. Inside you can see ";
	}
    }
    openStatus() { return openDesc;}
    openDesc = (isOpen ? 'The fridge door hovers open.' : '')
    okayOpenMsg = 'The fridge gently breaks the suction of its seal as you open it. '
    okayCloseMsg = 'The refrigerator door closes with the kiss of its seal against the frame. '
    okayPutInMsg = 'You slide {the dobj/him} onto one of the shelves in the refrigerator. '
;


lunchRoomMainFixturesGroup : ListGroupCustom
    showGroupMsg(lst) {

	foreach(local i in lst) {

	    i.specialDesc;

	}
    }
;
