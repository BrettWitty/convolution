#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// The Library of Convolution
// This is inspired greatly by Jorges Luis Borges' the Library of Babel
// The architecture is more relevant to Convolution, but the idea is similar.
// Instead of a combinatorial enumeration of books using a certain alphabet
// this has a tree-based enumeration of initial transcripts of Convolution. Wow.

libraryOfConvolution : Room
    name = 'A Gigantic Library'
    desc = "UNIMPLEMENTED YET. "
    destName = 'a gigantic library'
;

+ LibraryBookcase;


// A Volume from the Library
class LibraryVolume : Dispensable, Readable
    vocabWords = 'some shelf volume/book/encyclopaedia/encyclopedia/transcript/script*books*volumes*scripts*transcripts'
    name = 'book from the shelf'
    disambigName = 'some book from the shelf'
    desc = "The volume, like all of its kind, are leather-bound and
	    just shy of an inch thick. The face is perhaps
	    six-by-ten inches across. Other than the curious label
	    reading <q><<volumeName>></q>, the covers have a square
	    gilding with stepped corners. The book is quite weighty,
	    probably due to the thick, crisp pages. "
    readDesc { volumeDecipher.transcript(volumeNumber,volumeName); }

    // To keep the shelf book separate from the others
    hideFromAll(action) {
	if(location.ofKind(LibraryBookcase))
	    return true;
	return inherited(action);
    }
    isProperName = true
    volumeName = ''
    volumeNumber = 0
    myDispenser = nil
    isEquivalent = nil
    pluralOrder = (volumeDecipher.maxVolumes)
    isListedInContents = (!isIn(myDispenser))
    bulk = 25
    weight = 30
    initializeVolume(origin) {

	// My dispenser is the bookcase I came from
	myDispenser = origin;

	// Ask the bookcase for a name
	local tmp = myDispenser.getRandomVolumeNumber();
	volumeNumber = tmp;
	volumeName = volumeDecipher.volumeNameFromNumber(volumeNumber);
	
    }
    changeName() {

	// Add in the specific volume name so we can disambig volumes for greedy players
	name = 'Volume ' + volumeName;
	cmdDict.addWord(self, volumeName, &noun);
	cmdDict.addWord(self, volumeName, &adjective);
	cmdDict.removeWord(self, 'some', &adjective);
	cmdDict.removeWord(self, 'shelf', &adjective);
	isProperName = true;
	disambigName = (name);

	// Gives a nice ordering to the disambiguation, but only if
	// the volumes are numbered
	pluralOrder = volumeNumber;

    }
    dobjFor(Take) {
	verify() {
	    if(location != myDispenser)
		logicalRank(100, 'prefer bookcase books');
	}
    }
    dobjFor(PutOn) {
	action() {
	    if(gIobj != myDispenser)
		inherited();
	    else {
		moveInto(nil);
		myDispenser.takenVolumes -= self;
	    }
	}
    }
;

class LibraryBookcase : Dispenser, Heavy
    vocabWords = 'bookcase/bookshelf/shelf/shelves/case/bookshelves'
    name = 'bookcase'
    desc = "Densely-packed bookshelves line the walls, reaching up
	    from the marble floors to the hazy infinitudes above.
	    There is very little space in any of the shelves,
	    although this seems more like design than coincidence
	    --- all of the books are identical so building a
	    bookshelf around them is no tricky task. But creating
	    endless cliffs of them... "
    specialDesc = "Huge bookshelves line the walls. "
    canReturnItem = true
    myItemClass = LibraryVolume
    takenVolumes = []
    maxSingleBulk = 25
    maxSingleWeight = 30
    notifyRemove(obj) {

	inherited(obj);

	// Create a new temp book if we need it
	if(contents.length() <= 1) {
	    local cur = new LibraryVolume;
	    
	    // Initialize the volume (name and so on)
	    // We tell it that it came from our shelves
	    cur.initializeVolume(self);

	    // Move a new book into the shelves
	    cur.moveInto(self);
	}

	// Add it to the taken volumes
	takenVolumes += obj;

	// Change it from an ambiguous name to a specific one
	obj.changeName();


    }
    notifyInsert(obj, newCont) {

	inherited(obj, newCont);

	// Remove it from our takenVolumes
	//takenVolumes -= obj;

	// Destroy the volume
	//obj.moveInto(nil);
    }
    initializeThing() {

	if(contents == []) {

	    local cur = new LibraryVolume;

	    // Initialize the volume (name and so on)
	    // We tell it that it came from our shelves
	    cur.initializeVolume(self);
	    takenVolumes += cur;

	    // Move a new book into the shelves
	    cur.moveInto(self);

        }

	inherited();
    }
    getRandomVolumeNumber() {

	return rand(volumeDecipher.maxVolumes);

    }
    iobjFor(PutIn) {
	verify() {
	    if(gDobj == nil) {
		if(gTentativeDobj.ofKind(myItemClass))
		    logicalRank(140,'books can be returned');
	    }
	    else {
		if(gDobj.ofKind(myItemClass))
		    logicalRank(140,'books can be returned');
		else
		    inherited();
	    }
	}
    }
    iobjFor(PutOn) asIobjFor(PutIn)
;

volumeDecipher : object
    // The maximum number of volumes in the collection
    maxVolumes = 10000000000
    transcript(volumeNumber, volumeName) {

	// Initialize the transcript state and the initial node
	local transcriptState = [];
	local transcript = 'You open the book to the first page. The
			    whole thing is written in a plain
			    computer font but it makes no sense to
			    you. It reads: <bq> You suddenly snap
			    out of a train of thought, your head
			    throbbing with pain and flashes of
			    something you can\'t quite catch hold of
			    (or maybe understand). You tap the side
			    of your head with the heel of your palm.
			    Now what <i>were</i> you thinking of? \b
			    Despite your best and desperate
			    attempts, you can\'t quite remember...
			    You stop suddenly and let the pained
			    squint fade from your eyes. Not
			    breathing, you peer cautiously at the
			    surroundings. With no explanation, you
			    find yourself leaning against some
			    crumbling wall, surrounded by delivery
			    boxes. A cursory inspection suggests
			    that this is a basement... But of
			    what?<.p> You knuckle your head in
			    confusion, suddenly noticing a scrap of
			    paper in your fist. You stand up
			    straight, take a cautious breath and a
			    better look around...\ \b';
	local curVertex = BabelVertexBehindBoxes;

	// Convert the decimal volume number into a list of integers
	local transcriptList = [];
	local i = 0;
	while (volumeNumber != 0) {

	    i = volumeNumber % 10;
	    transcriptList += i+1;   // To make the indices work out
	    volumeNumber = (volumeNumber-i)/10;

	}

	// Pop the first item off the transcript list, add the relevant text
	// to the transcript and keep going.
	local t = 0;
	local curEdge;
	while (transcriptList != nil && transcriptList != []) {

	    // I may have an invalid list index, so wrap it around
	    t = transcriptList[1];
	    if(t > curVertex.edges.length())
		t = (t % curVertex.edges.length()) +1;

	    // Pick that edge t and traverse it
	    curEdge = curVertex.edges[t];

	    // If the edge is a loop, we'll be going back to our current vertex
	    // so init the object's curState with the transcript's
	    //node.curState = transcriptState;

	    // Add the gameCommand
	    transcript += '\b<b>&gt; ' + curEdge.gameCommand + '</b>\b';

	    // Add the gameScript
	    // We had to modify functionality to get strings to return correctly
	    transcript += curEdge.gameScript(transcriptState);

	    // Add/remove any state tokens
	    transcriptState += curEdge.addState;
	    transcriptState -= curEdge.removeState;

	    // Set the new node if we're not a BabelLoop
	    if(! curEdge.ofKind(BabelLoop) )
		curVertex = curEdge.toVertex;

	    // Now that we've done all for this node, pop it off the list and begin again
	    transcriptList = transcriptList.cdr();
	}

	// Cap off the quoted part of the transcript
	transcript += '</bq>\b This goes on for pages and pages. It
		       is eerily familiar but alien at the same
		       time. ';

	say(transcript);

    }
    volumeNameFromNumber(num) {

	// We convert a decimal number to a string via
	// turning it into a 27-ary number and looking
	// up the usual alphabet (plus the hyphen).
	local alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ-';

	// My output string
	local str = '';
	local i = 0;

	while (num != 0) {

	    i = num % 27;
	    str += alphabet.substr(i+1,1);
	    num = (num-i)/27;

	}

	return str;

    }
;



// The tree objects

// A vertex is a (rough) state, basically corresponding to being in a place
class BabelVertex : object
    edges = []
    curStates = []
;

class BabelEdge : object
    toVertex = nil
    fromVertex = nil
    gameCommand = 'UNDEFINED'
    gameScript(curState) { return gameText; }
    gameText = ''
    addState = []
    removeState = []
;

// A BabelLoop is a special edge that works like a multi-loc, although it can vary its
// gameScript
class BabelLoop : BabelEdge
    //toVertex = (fromVertex)
;

// The collection of standard loops
BabelExamineMe : BabelLoop
    gameCommand = 'EXAMINE ME'
    gameText = 'You\'re decked out in your usual street clothes:
		hard leather boots, a worn pair of jeans, a t-shirt
		and your favourite soft leather trenchcoat. All your
		appendages seem to be there, thankfully. '
;

BabelInventory : BabelLoop
    gameCommand = 'INVENTORY'
    gameText = 'You are carrying a crumpled-up scrap of paper, and
		you\'re wearing your trenchcoat. '
;

BabelReadScrap : BabelLoop
    gameCommand = 'READ SCRAP OF PAPER'
    gameText = 'The writing looks to be dashed off quickly. It
		reads: <q>Get out! Save yourself!</q> ' //'
;

// All the states
BabelStateBoxesDown : object ;
BabelFoundShelfNote : object ;

// Base vertex
BabelVertexBehindBoxes : BabelVertex
    edges = [BabelExamineMe, BabelInventory, BabelReadScrap, BabelExamineBoxes,
	     BabelExamineBeam, BabelKickBoxes,BabelClearBoxes,
	     BabelBasementEast, BabelReadBoxes]
    curStates = []
;

// Edges from the base vertex
BabelExamineBoxes : BabelLoop
    gameCommand = 'EXAMINE BOXES'
    gameScript(curState) {
	if(curState.indexOf(BabelStateBoxesDown))
	    return 'A tumbled stack of boxes lie at your feet, a
		    result of your devastating attack. ';
	else
	    return 'The boxes surrounding you seem to be unopened
		    delivery boxes, piled high in vaguely ordered
		    way. Surprisingly, they all seem very generic;
		    the packaging is professional, smooth cardboard,
		    but nondescript, and all of the boxes you\'ve
		    read have incredibly mundane names and
		    addresses, almost boilerplate. ';
    }
;

BabelExamineBeam : BabelLoop
    gameCommand = 'EXAMINE BEAM OF LIGHT'
    gameText = 'As if it were orchestrated that way, the boxes block
		out some of the light to form a solid beam
		illuminating the entrance of the passage leading
		out. Blurry bars of light shine through the cracks
		between the boxes, breaking up over others. '
;

BabelKickBoxes : BabelLoop
    gameCommand = 'KICK BOXES'
    gameText = 'A stack of boxes look like they\'re trying to stick
		out, so you take aim and swing your boot into them.
		They tumble down, bumping other stacks on the way.
		You stand over the collapsed pile, victorious. '
    addState = [BabelStateBoxesDown]
;

BabelClearBoxes : BabelLoop
    gameCommand = 'CLEAN UP BOXES'
    gameScript(curState) {
	if(curState.indexOf(BabelStateBoxesDown))
	    return 'With a twinge of guilt, you stack the boxes back neatly. ';
	else
	    return 'You wouldn\'t know how to clean those. ';
    }
    removeState = [BabelStateBoxesDown]
;

BabelBasementEast : BabelEdge
    toVertex = BabelVertexMainBasement
    fromVertex = BabelVertexBehindBoxes
    gameCommand = 'EAST'
    gameText = 'Careful not to knock over any of the boxes, you
		shuffle through the tight
		passage.\b<b>Basement</b>\nThe main area of the
		basement is much less cluttered than the stack of
		boxes to the west. In fact, there is little here
		save for spiderwebs and dust. It seems like the
		owners of this place had pushed all the boxes to the
		back of the room to make it easier to get to the
		small metal door to the south and the small opening
		in the brick wall to the north. A shaft of light
		penetrates the dim, dusty basement air, illuminating
		the stairs leading up to the east. '
;

BabelReadBoxes : BabelLoop
    gameCommand = 'READ BOXES'
    gameScript(curState){

	local name = rand('A. Jones', 'Mr. Smith', 'Dr. Brown', 'Miss Johnson');
	local address = rand('Park Avenue', 'Main Street', 'First Street', 'Samsara Court');
	return 'You peer at the label of a nearby box. It reads ' + name + ' living on ' + address + '. There are so many labels here... so many invisible people... ';
    }
;

//============
// Edges for the main basement vertex
BabelVertexMainBasement : BabelVertex
    edges = [BabelExamineMe, BabelInventory, BabelMainBasementWest,
	     BabelMainBasementNorth, BabelMainBasementOpenDoor,
	     BabelMainBasementExamineCobwebs, BabelMainBasementExamineDoor,
	     BabelMainBasementSouth, BabelMainBasementEast]
;

BabelMainBasementWest : BabelEdge
    toVertex = BabelVertexBehindBoxes
    fromVertex = BabelVertexMainBasement
    gameCommand = 'WEST'
    gameText = 'You squeeze through the boxes, and shuffle into the
		small clearing inside.\b<b>Behind a bunch of
		boxes</b>\bApart from the dry brick wall next to
		you, this little nook is almost all boxes. Every
		stack comprises of uniformly-sized, painfully
		generic delivery boxes, piled high in some places to
		the ceiling, in other places, only a box or two
		high. Murky light filters through the boxes from a
		thin, dusty row of windows near the ceiling to the
		north. A larger beam shines across what seems to be
		a break in the boxes to the east - a windy passage
		disappearing behind the boxes, but presumably
		leading out. '
;

BabelMainBasementNorth : BabelEdge
    toVertex = BabelVertexBoiler
    fromVertex = BabelVertexMainBasement
    gameCommand = 'NORTH'
    gameText = '<b>The Boiler Room</b>\bBuried deep underneath the
		building, carved into some nook, is the boiler room.
		There are no windows and the single entryway to the
		south hasn\'t even been given the honour of a door.
		The only decorations to the room are a few small
		vents high in the east wall and the pipes leading
		from the cantankerous old boiler that occupies most
		of this hollow.\bIn the northwest corner of the room
		is an industrial metal closet. '
;

BabelMainBasementOpenDoor : BabelLoop
    gameCommand = 'OPEN DOOR'
    gameText = 'The small metal door seems to be locked. '
;

BabelMainBasementExamineCobwebs : BabelLoop
    gameCommand = 'EXAMINE COBWEBS'
    gameText = 'Wispy strands of web dangle loosely between the
		rafters, seemingly abandoned by their makers. '
;

BabelMainBasementExamineDoor : BabelLoop
    gameCommand = 'EXAMINE DOOR'
    gameText = 'The sturdy metal door is shut. Scratched into the
		middle of it is the word <q>Janitor</q>. No prizes
		for whose room lies beyond.\b It\'s closed. '
;

BabelMainBasementSouth : BabelLoop
    gameCommand = 'SOUTH'
    gameText = '(first trying to open the small metal door)\nThe
		small metal door seems to be locked. '
;

BabelMainBasementEast : BabelEdge
    toVertex = BabelVertexBackRoom
    fromVertex = BabelVertexMainBasement
    gameCommand = 'UP'
    gameText = 'Shading your eyes from the bright light, you stomp
		up the stairs.\b<b>Some Back Room</b>\bWith the
		precarious pillars of boxes and discarded furniture
		scattered about the room, you guess this room is a
		temporary storage area for someone. Well, more
		aptly, it was probably used for storage one day but
		never relinquished of this task, and the clutter has
		built up over time. Strangely, no-one thought to put
		any of the boxes in the bookcase that now stands
		empty against the east wall.\bAs if the pillars of
		boxes weren\'t enough of an obstacle, someone has
		left a busted-up tangle of a plastic chair near the
		entrance to the stairs that lead west, down into the
		basement. This whole room seems to be in sheer
		defiance of safety, capped off with the fortified
		emergency exit to the north. \bThose responsible
		probably use what looks like an office to the south.
		\bYou can hear a phone ringing somewhere to the
		south. '
;

// The Boiler Room
BabelVertexBoiler : BabelVertex
    edges = [BabelExamineMe, BabelInventory, BabelBoilerSouth,
	     BabelBoilerExamineBoiler, BabelBoilerExamineCloset,
	     BabelBoilerPullCloset, BabelBoilerKickBoiler,
	     BabelBoilerListen, BabelBoilerOpenCloset]
;

BabelBoilerSouth : BabelEdge
    toVertex = BabelVertexMainBasement
    fromVertex = BabelVertexBoiler
    gameCommand = 'SOUTH'
    gameText = '<b>Basement</b>\nThe main area of the basement is
		much less cluttered than the stack of boxes to the
		west. In fact, there is little here save for
		spiderwebs and dust. It seems like the owners of
		this place had pushed all the boxes to the back of
		the room to make it easier to get to the small metal
		door to the south and the small opening in the brick
		wall to the north. A shaft of light penetrates the
		dim, dusty basement air, illuminating the stairs
		leading up to the east. '
;

BabelBoilerExamineBoiler : BabelLoop
    gameCommand = 'EXAMINE BOILER'
    gameText = 'Most of this old boiler seems to come from The
		Depression. The original frame is made out of the
		thick, heavy cast-iron that they don\'t make
		anything out of any more. Here and there someone has
		patched up pieces with newer strips of aluminium or
		steel. It looks like it should fall apart under any
		decent pressure, but Depression-era construction has
		that way of looking unstable but actually being
		impervious to anything weaker than an atomic bomb
		blast (or the machinations of a devious Communist).
		\bNevertheless it bubbles away obediently. The heat
		radiating from it is a bit oppressive, but then
		again, this <i>is</i> the boiler room. '
;

BabelBoilerExamineCloset : BabelLoop
    gameCommand = 'EXAMINE CLOSET'
    gameText = 'Against the northern end of the west wall stands a
		bulky metal closet. It has a small solid lock set
		into the doors, and a thin space between it and the
		north wall. It\'s closed. '
;

BabelBoilerPullCloset : BabelLoop
    gameCommand = 'PULL CLOSET'
    gameText = 'Wedging your fingers between the closet and the
		wall, and putting a foot up on the wall, you pull
		hard on the closet. You grunt and strain and finally
		the closet kicks up on one side, hanging momentarily
		above the fulcrum of the opposite edge, before
		loudly scraping along the wall and crashing on the
		ground with a cataclysmic, metallic boom.\bAs the
		dust and sound settles, you brush yourself off,
		stopping to notice a previously hidden alcove behind
		where the closet used to be. '
;

BabelBoilerKickBoiler : BabelLoop
    gameCommand = 'KICK BOILER'
    gameText = 'You grit your teeth and kick the boiler, but it
		shrugs it off with barely a dull <i>thunk</i> in
		return. '
;

BabelBoilerListen : BabelLoop
    gameCommand = 'LISTEN'
    gameText = 'The boiler bubbles away obediently. Every so often a
		hammering will pound through the pipes, disappearing
		in the wall. Adding to this symphony of indoor
		heating, the vents breathe out hot air in a low
		rumble. '
;

BabelBoilerOpenCloset : BabelLoop
    gameCommand = 'OPEN CLOSET'
    gameText = 'The heavy industrial closet seems to be locked. '
;

// The Back Room
BabelVertexBackRoom : BabelVertex
    edges = [BabelExamineMe, BabelInventory, BabelBackRoomWest,
	     BabelBackRoomExamineBoxes, BabelBackRoomLookBehindShelf,
	     BabelBackRoomOpenDoor, BabelBackRoomKnockDoor, BabelBackRoomExamineChair,
	     BabelBackRoomReadNote, BabelBackRoomListen]
;

BabelBackRoomWest : BabelEdge
    gameCommand = 'DOWN'
    gameText = 'You step cautiously down the stairs into the
		basement. It takes a while for your eyes to
		adjust.\b<b>Basement</b>\bThe main area of the
		basement is much less cluttered than the stack of
		boxes to the west. In fact, there is little here
		save for spiderwebs and dust. It seems like the
		owners of this place had pushed all the boxes to the
		back of the room to make it easier to get to the
		small metal door to the south and the small opening
		in the brick wall to the north. A shaft of light
		penetrates the dim, dusty basement air, illuminating
		the stairs leading up to the east. '
;

BabelBackRoomExamineBoxes : BabelLoop
    gameCommand = 'EXAMINE BOXES'
    gameText = 'The arrangement of these boxes is clearly the
		product of hastiness or laziness. Or both. Some
		boxes are stacked askew, arranging themselves
		according to gravity. Others seem to be stacked with
		good intention - one box has its <q>This way up</q>
		arrow pointing directly down, a small box supports a
		larger and heavier one... You\'re sure that in the
		right gallery this would be an avante-garde
		centerpiece of great distinction. Lying in this back
		room they have been demoted to <q>clutter</q>.\bYou
		can hear a phone ringing somewhere to the south. '
;

BabelBackRoomLookBehindShelf : BabelLoop
    gameCommand = 'LOOK BEHIND SHELF'
    gameScript(curState) {
	if(curState.indexOf(BabelFoundShelfNote))
	    return 'There is nothing else behind the bookcase except
		    for the wall.\bYou can hear a phone ringing
		    somewhere to the south. ';
	else
	    return 'You lean towards the bookcase, carefully
		    stepping over a box in the process. You pull the
		    bookcase back and suddenly a piece of card
		    slides down the back, which you reflexively
		    catch. The bookcase claps back against the wall
		    as you peer at the card. The card is a folded
		    piece of packing cardboard, with some writing
		    inside. You shrug and put it in your
		    jacket.\bYou can hear a phone ringing somewhere
		    to the south. ';
    }
    addState = [BabelFoundShelfNote]
;

BabelBackRoomOpenDoor : BabelLoop
    gameCommand = 'OPEN DOOR'
    gameText = 'You rattle the door bar, but the door doesn\'t even
		give a pretence of being able to open.\bYou can hear
		a phone ringing somewhere to the south. '
;

BabelBackRoomKnockDoor : BabelLoop
    gameCommand = 'KNOCK ON DOOR'
    gameText = 'You knock loudly on the fortified emergency exit.
		Nothing happens.\bYou can hear a phone ringing
		somewhere to the south. '
;

BabelBackRoomExamineChair : BabelLoop
    gameCommand = 'EXAMINE CHAIR'
    gameText = 'Some things in this world sure get the rough end of
		the stick in terms of their existence: mayflies,
		dung beetles, New Coke(tm) and this chair. It began
		its life as one of those dime-a-dozen,
		plastic-backed, unergonomic chairs that they often
		use for school assemblies or town meetings. They are
		produced en masse with cheap (foreign) labour; they
		only require screwing two bent pieces of metal to
		the plastic seat. Unfortunately, their cheap
		manufacture seems to induce enraged people to hurl
		them at walls, lazy people to snap their backs via
		creative posturing and the morbidly obese to
		accidentally crush them. This specimen has had its
		seat warped and its legs bent and snapped off. It
		lies in a tangle heap of plastic and metal in one
		corner of the room, just near the basement stairs.
		If it wasn\'t just a stupid chair, you might shed a
		tear for its beleaguered existence.\bYou can hear a
		phone ringing somewhere to the south. '
;

BabelBackRoomReadNote : BabelLoop
    gameCommand = 'READ NOTE'
    gameScript(curState) {
	if(curState.indexOf(BabelFoundShelfNote))
	    return '(the plain piece of cardboard)\n(first unfolding
		    the plain piece of cardboard)\nYou unfold the
		    plain piece of cardboard and smooth it out.\bOn
		    the plain piece of packing cardboard, written
		    with permanent marker is a curious note:\n
		    <center>I think the Mafia are in on this. Gotta
		    play it straight - be set free.</center>\bYou
		    can hear a phone ringing somewhere to the south. ';
	else
	    return 'The writing looks to be dashed off quickly. It
		    reads: <q>Get out! Save yourself!</q>\bYou can
		    hear a phone ringing somewhere to the south. '; //'
    }
;

BabelBackRoomListen : BabelLoop
    gameCommand = 'LISTEN'
    gameText = 'You can hear a phone ringing somewhere to the south. '
;
