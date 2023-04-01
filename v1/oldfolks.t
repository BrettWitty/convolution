#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//------------------------//
//  The Old Folks' Place  //
//------------------------//

oldFolksLounge : Room
    name = 'Lounge Room'
    destName = 'the lounge room'
    desc = "An apartment. TO BE COMPLETED. "
    north = oldFolksToHallwayDoor
    out asExit(north)
    east = oldFolksLoungeToBedroom
    south = oldFolksLoungeToKitchen
;

+ oldFolksToHallwayDoor : Door, Lockable ->firstHallwayToOldFolksDoor 'north n northern n/north/door/doorway/out' 'doorway out to the main hallway'
    "The maroon-coloured door seems out of place with the dull greys
     and pinks of this lounge room. But other than that, it is a
     normal door. "
    initiallyOpen = nil
    initiallyLocked = true
;

+oldFolksLoungeToKitchen : Passage 'south southern s south/s/kitchen' 'kitchen'
    "The serenity of the lounge room breaks into the brightly-lit
     kitchen to the south. "
    destination = oldFolksKitchen
;

+oldFolksLoungeToBedroom : Passage 'east e eastern east/e/bedroom/doorway/eastwards' 'doorway to the bedroom'
    "A small doorway nudges the side of the ornamental shelves,
     leading eastwards to the bedroom. "
    destination = oldFolksBedroom
;

+oldFolksTV : TV
    vocabWords = 'old television/tv/telly/tele'
    name = 'old television'
    desc = "This TV is how they used to make `em: heavy, chunky, and
	    out of wood. The panels surrounding the screen take up
	    more space than the screen itself. "
    specialDesc = "A TV from the seventies is nestled in the corner
		   of the room, flanked by a shelf full of
		   ornaments."
    owner = rose
    roseKnown = true
    charlieKnown = true
    curSetting = '6'
    channelDesc {
	if(curSetting == '6')
	    say(soapOperaChannel.getNextValue());
	else
	    staticDesc;
    }
    soapOperaChannel : ShuffledList {
	valueList = []
    }
    tvPowerSocket = oldFolksLoungePowerSocket
;

+oldFolksLoungePowerSocket : PowerSocket
    isOn = true
    attachedObjects = [oldFolksTV]
    maxConnections = 1
;

+oldFolksLoungeChair : Chair, Heavy
    vocabWords = 'old arm fabric armchair/chair/recliner/seat'
    name = 'armchair'
    owner = rose
    roseKnown = true
    desc = "This stuffed armchair is a relic from before the IKEA
	    invasion. It is made out of lumpy grey-brown cushioning
	    and pine. After all these years, it\'s probably
	    dangerously comfortable. "
    allowedPostures = [sitting]
;

+oldFolksLoungeShelf : Surface, Heavy
    vocabWords = '(ornaments) (wall) decorative wooden shelf/shelves/unit/bookcase/case'
    name = 'decorative shelf'
    owner = rose
    roseKnown = true
    desc = "Adjacent to the TV is a stately wooden shelf. There are
	    various ornamental knick-knacks on it, but surprisingly
	    no dust. "
;

+SimpleOdor 'old folk person people smell/odor/odour/stink' 'old person smell'
    "You hate to admit it, but this place has that pungent, old-person
     smell. You politely try to ignore it. "
;

//
// The Kitchen
//

stuffOnTheOldFolksFridge : ListGroupCustom
    showGroupMsg(lst) {

	if(lst.length() > 1)
	    "Two things have been attached to the fridge with
	     magnets: a letter, and (more worryingly) a key card. "; //"
    }
;

oldFolksKitchen : Room
    name = 'Kitchen'
    destName = 'the kitchen'
    desc = "This could very well be the only kitchen in the world
	    that could be described as <q>cosy</q> without being
	    deceitful. Though there isn\'t much space, the old folk
	    have found enough niches along the age-worn benches to
	    cram with random utensils and cooking ingredients.
	    Countless tasty baked treats would have been born here,
	    and delivered with a warm, lonely smile. "
    north = oldFolksLounge
    out asExit(north)
;

+SimpleOdor '(kitchen) smell/odor/odour/air' 'kitchen smell'
    "The ripe must from the rest of the house is (surprisingly)
     drowned out by the years of baked goods soaked into everything
     here. "
;

+oldFolksBench : Surface, Fixture
    vocabWords = '(kitchen) thin white linoleum lino lineolum bench bench/surface/top'
    name = 'bench'
    desc = "A white linoleum bench lines the walls of this little
	    nook of a kitchen. The surface itself is clean, but
	    wearied. "
    tasteDesc = "When no-one\'s looking, you take a quick,
		 mischievious lick of the bench. It has a taste of
		 the cooking section of a supermarket mashed
		 together, drowned in butter and flour, washed over
		 with weak detergent. "
    smellDesc = "The bench smells like a lifetime of baked treats. "
    feelDesc = "The linoleum has a wearied softness, broken up by
		the occasional deep scratch or chip. "
    bulkCapacity = 10000
    maxSingleBulk = 10000
    weightCapacity = 10000
    maxSingleWeight = 10000
;

++ Decoration
    vocabWords = '(kitchen) assorted random food cooking misc
		  miscellaneous jar jars
		  junk/stuff/ingredients/things/utensils/ingredients/herbs/decorations/jar/jars'
    name = 'assorted kitchen stuff'
    desc = "Tidy little arrays of ingredients, cooking utensils and
	    random kitchen stuff dot the bench. Little sections at a
	    time, you can understand the organization, but as a
	    whole, it smacks of a scheme that was adopted for no
	    real reason years ago and raw routine has established
	    it. "
    specialDesc = "Here and there on the bench are little caches of
		   ingredients and utensils. "
    useSpecialDescInRoom(room) { return nil; }
    tasteDesc = "The menagerie of herbs and spices provide little
		 taste discoveries, some amazing, some regrettable. "
    smellDesc = "The utensils have that <q>grandmother\'s
		 kitchen</q> smell that can only come from decades
		 of baking and cooking, and the herbs and spices
		 tickle your nose with their motley fragrances. "
    feelDesc = "The jars are cool glass; the utensils smooth with use. "
    isPlural = true
    isMassNoun = true
    notImportantMsg = 'The ingredients and utensils are of no use to you. '
    isListed = nil
    dobjFor(Search) {
	verify() { logicalRank(70, 'decoration'); }
	action() {
	    defaultReport('{You/he} poke{s} around, but find nothing
			   important in between the jars of herbs
			   nor behind the various dull
			   decorations.');
	}
    }
;

+oldFolksFridge : Refrigerator
    vocabWords = 'old dated bombproof square squarish fridge/refrigerator/refridgerator/cooler'
    name = 'refrigerator'
    desc = "Though a little dated, you expected this refrigerator to
	    be old and bombproof<<hasSeen(codyRefrigerator) ? ',
	    much like the one next door' : '.'>> It has that
	    squarish look from the seventies or eighties, and with
	    all the rattling it is making, you\'re guessing most of
	    its parts come from then too. "
    specialDesc = "A refrigerator stands proudly against the wall, rattling away. "
    dobjFor(PutOn) remapTo(PutOn,DirectObject,oldFolksFridgeDoor)
;

+SimpleNoise '(fridge) (refrigerator) (refridgerator) (cooler) sound/noise/rattling/rattle/hum' 'the refrigerator rattling'
    "The refrigerator hums and rattles with strong determination
     grown from years of faithful service. "
    isQualifiedName = true
;
	       
+NameAsOther, SecretFixture
    targetObj = oldFolksFridge
;

++oldFolksFridgeDoor : ContainerDoor
    vocabWords = 'fridge refrigerator cooler door/front'
    name = 'refrigerator door'
    desc = "The door is the same enamel white as the rest of the
	    fridge. Despite having some age, it seems to be in good
	    condition. "
    subContainer = oldFolksFridge
;

+++ Note
    vocabWords = 'letter/note'
    name = 'letter'
    desc = "Someone (possibly a relative or friend of the old
	    couple) has written a short, dutiful letter. From a
	    brief glance, it looks more like business than pleasure,
	    though it endeavours to be familiar. "
    initDesc = "A short, dutiful letter has been attached to the
		fridge by a magnet. "
    readDesc = "The crisp writing reads:<bq><p>Dear
		Mother,</p><p>Things are fine here. It is a little
		new and confusing, but soon I shall call this place
		home. Work is okay, but aimless. I wish I knew what
		they want me to do. I manage to get by doing odd
		jobs. The people on my level are friendly, although
		I\'ve heard rumours about those upstairs. But you
		know how these things are...</p><p>I hope you and
		Dad are going well. I\'m sorry I haven\'t paid you
		back. It\'ll be soon, honest. Not much else to talk
		about. Oh, ask Dad if he remembers any of his old
		German. I have some words I would like translated
		and I can\'t find anyone here who knows any
		German.</p><p>Fondly,</p><p>Your son</p></bq> "
    initSpecialDesc = "An unfolded letter has been pinned to the
		       front of the fridge with a magnet. "
    isListed = nil
    useSpecialDescInRoom(room) { return nil; }
    // My kludgy fix to make these items visible on the fridge
    useSpecialDescInContents(cont) {
	return useSpecialDesc() && (cont == oldFolksFridgeDoor);
    }
    specialDescListWith = [ stuffOnTheOldFolksFridge ]
    beenMoved = nil
    okayTakeMsg {
	if(beenMoved)
	    return 'Taken. ';
	else {
	    beenMoved = true;
	    return '{You/he} slide{s} the note out from under the magnet and put it in {your/his} pocket. ';
	}
    }
    hideFromAll(action) { return !(oldFolksFridge.described || oldFolksFridgeDoor.described); }
;

+++ oldFolksSwipeCard : SwipeCard 
    vocabWords = '(old) (folks) key swipe security magnetic card/keycard/swipecard'
    name = 'the old folk\'s key card'
    desc = "This simple key card has just the number 102 on the
	    front (accompanied by a knotted emblem in the corner)
	    and a magnetic strip on the back. "
    initSpecialDesc = "To your horror, a key card has been stuck on
		       the refrigerator with a thick magnet. The
		       information on the magnetic strip is almost
		       surely mangled. "
    isListed = nil
    useSpecialDescInRoom(room) { return nil; }
    // My kludgy fix to make these items visible on the fridge
    useSpecialDescInContents(cont) {
	return useSpecialDesc() && (cont == oldFolksFridgeDoor);
    }
    specialDescListWith = [ stuffOnTheOldFolksFridge ]
    cardID = 102
    isValid = nil
    accessibleFloors = []
    // FIXME! Maybe have joint ownership?
    owner = rose
    isQualifiedName = true
    beenMoved = nil
    okayTakeMsg {
	if(beenMoved)
	    return 'Taken. ';
	else {
	    beenMoved = true;
	    return '{You/he} gingerly remove{s} the magnet from the
		    key card. {You/he} wipe{s} the card on
		    {your/his} shirt and put it in {your/his}
		    pocket, carefully putting the magnet back on the
		    fridge, away from anything magnetically
		    sensitive. ';
	}
    }
    hideFromAll(action) { return !(oldFolksFridge.described || oldFolksFridgeDoor.described); }
;

//
// The Bedroom
//

oldFolksBedroom : Room
    name = 'Bedroom'
    destName = 'the bedroom'
    desc = "The bedroom. TO BE COMPLETED. "
    west = oldFolksLounge
    out asExit(west)
    south = oldFolksBathroom
    in asExit(south)
;

oldFolksBathroom : Room
    name = 'Bathroom'
    destName = 'the bathroom'
    desc = "The bathroom. TO BE COMPLETED. "
    north = oldFolksBedroom
    out asExit(north)
;
