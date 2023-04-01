#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

manager : Person
    name = 'the manager'
    isQualifiedName = true
    isHim = true
;

managerNorthWall : defaultNorthWall
    vocabWords = 'north northern n undecorated crumbling brick wall/wallpaper*walls'
    desc = "The north wall is undecorated crumbling brick. You have
	    no idea why they didn\'t at least paint it, but maybe
	    there are severe structural or budget problems you
	    don\'t know about. "
;

managerWestWall : defaultWestWall
    vocabWords = 'west western w bone-white white bone striped-glaze glazed wall/wallpaper*walls'
    desc = "The west wall is clad in the bone-white striped-glaze
	    wallpaper that is on two of the other walls. An
	    elaborately polished door leads out. "
;

managerCeiling : defaultCeiling
    desc = "The ceiling is brushed roughly with white paint,
	    possibly for effect, but it\'s nothing too special. "
;

managerFloor : defaultFloor
    desc = "The manager\'s office is covered in a resilient chalky
	    blue carpet. "
;

managerOffice : Room
    vocabWords = 'manager manager\'s office'
    name = 'Manager\'s Office'
    destName = 'the manager\'s office'
    desc = "Much like most managers, this office is constructed to
	    be shallowly impressive. The altar before which
	    employees must prostrate (the manager\'s mahogany desk)
	    sits proudly before the east wall, framed by typical but
	    tacky glazed wallpaper and surrounded by a moat of
	    chalky blue carpet. "
    roomParts = [managerCeiling, managerFloor, managerEastWall, managerWestWall, managerNorthWall, managerSouthWall]
    west = managerToReceptionDoor
    out asExit(west)
;

+managerToReceptionDoor : Lockable, Door
    vocabWords = 'manager\'s manager w west w/west/out/door/doorway'
    name = 'manager\'s door'
    desc = "This door would be the only thing keeping the manager
	    safe from the outside world, if of course the manager
	    were actually here. "
    owner = manager
    openStatus() {

	if(isOpen)
	    return 'At the moment, the door is wide open, letting
		    any old trash from the outside wander in (so it
		    seems)';
	else
	    return 'At the moment, the door is firmly closed,
		    preserving this sanctuary of organization';
    }
    initiallyOpen = nil
    initiallyLocked = true
    smellDesc = shellacRTMDoor.smellDesc
    feelDesc = shellacRTMDoor.feelDesc
    tasteDesc = shellacRTMDoor.tasteDesc
    soundDesc = shellacRTMDoor.soundDesc
;

+managerDesk : ComplexContainer, Heavy
    vocabWords = 'mahogany wood wooden desk/table'
    name = 'desk'
    desc= "In between scattered pieces of paper and stationery
	   scratches and ink stains riddle the rich mahogany
	   surface, signs that the owner once enjoyed the decadence
	   but willing traded it away for idle clumsiness and abuse.
	   The scratches and marks seem to radiate out from the
	   chair, so it couldn\'t be anyone else. <p>There is a
	   single drawer to one side"
    owner = manager
    hideFromAll(action) { return true;}
    subSurface : ComplexComponent, Surface {
	maxSingleBulk = 100
	bulkCapacity = 200
	maxSingleWeight = 100
	weightCapacity = 300
    }
    subUnderside : ComplexComponent, Underside {
	allowPutUnder = nil
    }
    subContainer : ComplexComponent, OpenableContainer {
	vocabWords = 'desk drawer'
	name = 'desk drawer'
	desc = "The desk drawer is plain, with an old-school flat
		button handle"
	openStatus() {
	    if(isOpen)
		". It hangs open";
	}
    }
    cannotCleanMsg = 'There is no point even trying that: you\'d
		      turn your back for one second and by the
		      magical power that managers have, it would be
		      messy again. '
    cannotClearMsg = (cannotCleanMsg)
;

++ Decoration
    vocabWords = 'scattered paper/papers/stationery/pens/stuff/junk'
    name = 'scattered stationery'
    desc = "Uninteresting letters and records lay across the desk,
	    crisscrossed with the usual assortment of pens and junk. "
    notImportantMsg = 'This junk is neither interested nor useful. '
;

++ Decoration
    vocabWords = 'scratches/stains/scratch/mark/stain/wear/damage'
    name = 'scratches'
    desc = "The stains and scratches across the mahogany surface
	    greatly disrespect the grand trees that died to create
	    this desk. "
    notImportantMsg = 'There is no point worrying about the damage
		       to the desk --- it is already done and is
		       irreparable. '
;

managerEastWall : defaultEastWall
    vocabWords = 'east eastern e bone-white white bone striped-glaze glazed wall/wallpaper*walls'
    desc = "The east wall has an uninteresting bone-white
	    striped-glaze wallpaper, with a gaudy watercolour
	    painting hung in the middle, just behind the manager\'s
	    desk. "
;

+managerSafePicture : Thing
    vocabWords = 'gaudy cheap hack hack-job dull inexpensive imitation imitation/picture/painting/hanging/sketch/watercolor/watercolour/print/canvas/art/artwork'
    name = 'gaudy picture'
    desc = "Somewhere, hidden from the eyes of normal folk, is a
	    store in which interior decorators (and secretaries
	    promoted to such) buy second-rate paintings to adorn
	    office walls. More often than not, these gaudy pieces of
	    <q>art</q> are just there to create a bit of variance in
	    colour without distracting busy people too much. Silly
	    aspirations like <q>touching one\'s soul</q>,
	    <q>divining truth</q>, or even <q>looking good</q> are
	    discarded. This dull watercolour of a house is one such
	    painting. "
    owner = manager
    initNominalRoomPartLocation = managerEastWall
    bulk = 20
    weight = 2
    initSpecialDesc = "A gaudy watercolour of a house hangs on the
		       wall behind the desk. "
    specialDesc = "A cheap painting lies on <<location.getNominalDropDestination().theName>>. "
    okayDropMsg { return '{You/he} place the picture down on ' + gActor.location.getNominalDropDestination().theName + '.'; }
    okayTakeMsg = '{You/he} pull{s} the painting off the wall, revealing a small wall safe. '
    moveInto(newContainer) {
	// To avoid all the messy scripting I tried, we do this to get the custom take message.
	if(moved)
	    okayTakeMsg = 'Taken. ';
	inherited(newContainer);
	managerSafe.discover();
    }
    dobjFor(LookBehind) {
	action() {
	    if(location == initNominalRoomPartLocation) {
		managerSafe.discover();
		defaultReport('{You/he} peer{s} behind the picture and see{s} a wall safe. ');
	    }
	    else
		inherited();
	}
    }
    dobjFor(PutOn) {
	verify() {
	    if(gIobj == managerEastWall) {
		reportFailure('You needn\'t worry about rehanging the picture. ');
		exit;
	    }
	    else
		inherited();
	}
    }
    dobjFor(Move) {
	verify() { logicalRank(100,'is movable'); }
	action() {
	    moved = true;
	    gActor.getDropDestination(self, nil).receiveDrop(self, dropTypeDrop);
	}
    }
;

+managerSafe : Hidden, LockableContainer, IndirectLockable, Fixture
    vocabWords = '(small) (wall) safety safe strong safe/container/box/vault/strongbox/coffer'
    name = 'wall safe'
    desc = "Managers love safes --- they give them a sense of immunity
	    even from those who dare set foot in their
	    fortress---well, office. Ironically, this solid little
	    vault secures untold riches, but is hidden from view by
	    a hack-job landscape framed in cheap faux wood.\b This
	    safe is furnished with a simple dial and handle. "
    specialDesc {
	if(!managerSafePicture.moved)
	    "Behind the picture, embedded in the wall, is a safe. ";
	else
	    "There is a safe embedded in the wall. ";
    }
    owner = manager
;

enum safeTumblerSuccess, safeTumblerOpen, safeTumblerReset, safeTumblerFail;

NameAsOther, SecretFixture targetObj = managerSafe location = managerOffice; 

+ managerSafeDoor : Hidden, ContainerDoor
    subContainer = managerSafe

    // So the door and the dial are hidden when the safe is
    canBeSensed(sense, trans, ambient) {
        if (sense == sight && !managerSafe.discovered)
            return nil;
        else
            return inherited(sense, trans, ambient);
    }
;

++ Dial, Component
    vocabWords = 'dial/turner/control/lock'
    name = 'dial to the safe'
    desc = "The metal dial has a stereotypical shape. The numbers go
	    from 0 to 99. \b [To attempt to open the safe, use TURN
	    DIAL TO n, where n is between 0 and 99 inclusive. For
	    example, TURN DIAL TO 3. This safe does not require you
	    to use left or right spins. Pulling on the handle opens
	    the door, but if the combination is wrong, it will reset
	    the mechanism. ] "
    myCombination = [36,24,36]
    curAttempt = []
    setToInvalidMsg = '{You/he} need{s} to turn to a specific
		       number. {You/he} do{es}n\'t need to specify left or
		       right. '
    // So the door and the dial are hidden when the safe is
    canBeSensed(sense, trans, ambient) {
        if (sense == sight && !managerSafe.discovered)
            return nil;
        else
            return inherited(sense, trans, ambient);
    }
    okaySetToMsg(val,success) {
	switch(success) {

	    case safeTumblerSuccess :
	    return '{You/he} turn{s} the dial to ' + toString(val) + ' and you hear a tumbler click into place! ';

	    case safeTumblerOpen :
	    return '{You/he} turn{s} the dial to ' + toString(val) + ' and there is a sudden, definite click! The lock sounds like it has disengaged. ';
	    
	    case safeTumblerFail :
	    return '{You/he} turn{s} the dial to ' + toString(val) + '. ';

	    case safeTumblerReset :
	    return '{You/he} turn{s} the dial to ' + toString(val) + '. The mechanism inside clicks and slides unwelcomingly --- the tumblers have reset. ';
	    
	}
	return '{You/he} turn{s} the dial to ' + toString(val) + '. ';
    }
    makeSetting(val) {

	// Log the current attempt
	curAttempt = curAttempt.append(val);
	curSetting = val;

	// If we have already tried something, and this one is wrong, trigger a reset

	if(curAttempt.length == 1 && val != myCombination[1])
	    return safeTumblerFail;
	
	// If the list is too long
	if(curAttempt.length() > myCombination.length() ) {
	    curAttempt = [];
	    return safeTumblerReset;
	}
	else {
	    for(local i = 1, local cnt=curAttempt.length(); i <= cnt; ++i) {
		if(curAttempt[i] != myCombination[i]) {
		    curAttempt = [];
		    return safeTumblerReset;
		}
	    }
	    if(curAttempt.length() == myCombination.length())
		return safeTumblerOpen;
	    else
		return safeTumblerSuccess;
	}
    }
    isValidSetting(val) {

	// Only numbers are good
	local tokList = Tokenizer.tokenize(val);

	if(tokList.length() != 1)
	    return nil;

	local token = tokList[1];

	if(getTokType(token) != tokInt)
	    return nil;
	// And between 0 and 99
	else {
	    local i = toInteger(getTokVal(token));
	    return (i >= 0 && i <= 99);
	}
    }
    dobjFor(SetTo) {
	action() {
	    // If the picture is in the way, move it
	    if(managerSafePicture.location == managerSafePicture.initNominalRoomPartLocation)
		tryImplicitAction(Move,managerSafePicture);

	    // Convert the literal into something easier to handle
	    local tokList = Tokenizer.tokenize(gLiteral);
	    local i = 0;

	    i = toInteger(getTokVal(tokList[1]));

	    // Now makeSetting with this new integer
	    // If makeSetting returns true, then we have
	    // hit a tumbler correctly
	    
	    local val = makeSetting(i);
	    defaultReport(okaySetToMsg(i,val));

	    // And if we got the last digit, unlock the safe!
	    if(val == safeTumblerOpen)
		managerSafe.makeLocked(nil);
	    else
		managerSafe.makeLocked(true);
	}
    }
;

managerSouthWall : defaultSouthWall
    vocabWords = 'south southern s bone-white white bone striped-glaze glazed wall/wallpaper*walls'
    desc = "The south wall has been wallpapered with an
	    uninteresting bone-white striped-glaze wallpaper. An
	    unassuming plaque hangs timidly in the middle. "
;

+managerPlaque : RearSurface
    vocabWords = 'unassuming lonely lonesome timid small henry david thoreau plaque/panel/sign/thoreau/quote'
    name = 'small plaque'
    desc = "A poem, written in delicate calligraphy, hangs on the
	    wall: <bq>Every blade in the field,\n Every leaf in the
	    forest,\n Lays down its life in its season,\n As
	    beautifully as it was taken up.\n\t\t\t Henry David
	    Thoreau</bq> Behind the poem is a faint watermark of a
	    thin-petalled flower, half-plucked. " //"
    initSpecialDesc = "A timid, wooden plaque hangs on the south
		       wall, an unenthusiastic attempt to distribute
		       the decorative responsibilities around the
		       room. "
    specialDescOrder = 200
    owner = manager
    initNominalRoomPartLocation = managerSouthWall
    bulk = 5
    weight = 1
    allowPutBehind = nil
    contentsLister : rearContentsLister {
	showListPrefixWide(itemCount, pov, parent) {
	    "Tucked into the back of the frame <<itemCount == 1 ? 'is' : 'are'>> ";
	}
	showListPrefixTall(itemCount, pov, parent) {
	    "Tucked into the back of the frame <<itemCount == 1 ? 'is' : 'are'>> ";
	}
    }
    descContentsLister : rearDescContentsLister {
	showListPrefixWide(itemCount, pov, parent) {
	    "Tucked into the back of the frame <<itemCount == 1 ? 'is' : 'are'>> ";
	}
    }
    lookInLister : rearLookBehindLister {
	showListPrefixWide(itemCount, pov, parent) {
	    "Tucked into the back of the frame <<itemCount == 1 ? 'is' : 'are'>> ";
	}
	showListPrefixTall(itemCount, pov, parent) {
	    "Tucked into the back of the frame <<itemCount == 1 ? 'is' : 'are'>> ";
	}
	showListEmpty(pov, parent) {
	    gMessageParams(parent);
	    defaultDescReport('{You/he} see{s} nothing behind {the
			       parent/him} but the plain wooden
			       frame. ');
	}
    }
    dobjFor(LookBehind) {
	action() {
	    if(!managerPlaqueHiddenNote.discovered)
		managerPlaqueHiddenNote.discover();
	    inherited();
	}
    }
    dobjFor(Flip) remapTo(LookBehind,self)
;

++Component 'wooden frame/framing' 'wooden frame'
    dobjFor(LookBehind) remapTo(LookBehind, managerPlaque)
    dobjFor(Search) remapTo(LookBehind, managerPlaque)
;

++managerPlaqueHiddenNote : Hidden, CreepyNote
    vocabWords = 'torn scrap/paper/corner/piece'
    name = 'torn corner of paper'
    desc = (readDesc)
    leadInMsg = "This scrap of paper looks like it someone tore off
		 a ragged corner from a sheet of paper. It reads
		 simply: <bq> "
    messageText = "Tabula rasa?"
    newName = 'torn corner of paper'
    newVocabWords = 'torn tabula scrap/paper/corner/piece/rasa'
    newDisambigName = '<q>Tabula rasa?</q> corner of paper'
;
