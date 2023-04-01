#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

/* The amazing trenchcoat of holding
 * This trenchcoat is worn by the player (hopefully throughout the whole game).
 * It is a weird mix-in of Wearable, BagOfHolding and should contain
 * customizations for whatever neat effect.
 *
 *  TO DO:
 *  - Bugtest it.
 *  - Add Wettability?
 */

trenchCoat : Container, BagOfHolding, Wearable 'my trench trenchcoat/coat/clothes/jacket' 'your trenchcoat' @me
    "You forget when and where you bought this fine leather trenchcoat, but
     you know it\'ll be tough to replace it. The leather is thin and buttery,
     but it\'s damn durable. The workmanship is old-school - tough and
     reliable - but it somehow remains permanently stylish. However, it
     wasn\'t the style you bought it for, but the pockets. Every so often you
     surprise yourself by finding a new pocket or one that you\'d forgotten
     about. In short, you want to be buried in this wondrous coat. "
    wornBy = me
    isProperName = true
    maxSingleBulk = 10

    // We have an affinity for notes, but nothing special.
    affinityFor(obj) {

	if( obj.ofKind(Note) )
	    return 150;
	else {
	    if(obj.getWeight() < 10)
		return 150;
	    else
		inherited(obj);
	}
    }
    
    dobjFor(LookIn) remapTo(LookIn,trenchCoatPockets)
    dobjFor(Doff) {
	check() {
	    failCheck('It\'s much easier if you just wear the
		       trenchcoat than carry it --- you also don\'t
		       want to lose it. ');
	}
    }
;

+trenchCoatPockets : Component, Container 'pocket/pockets' 'trenchcoat pockets'
    "There are so many of these guys, it\'s a wonder you remember
     where you store things. "
    hideFromAll(action) { return true; }
    isPlural = true
    dobjFor(LookIn) remapTo(Inventory)
    iobjFor(PutIn) remapTo(PutIn, DirectObject, trenchCoat)
    iobjFor(Take) remapTo(Take, DirectObject, trenchCoat)
    iobjFor(TakeFrom) remapTo(TakeFrom, DirectObject, trenchCoat)
;



janitorKey : Key
    vocabWords = '(small) metal vern janitor janitor\'s key'
    //location = me
    name = 'janitor\'s key'
    desc = "A small, worn, metal key with the word <q>Janitor</q> stamped on it."
;



// The old folks' keyring, found initially in the mailbox door.
oldFolksKeyring : Keyring
    vocabWords = '(small) metal keyring/ring/keys'
    name = 'small metal keyring'
    desc = "The worn keyring is a simple round band of metal with a tag reading <q>103</q>. "
    location = mailbox102Door
    owner = charlie
    beenTaken = nil
    okayTakeMsg {
	if(!beenTaken) {
	    beenTaken = true;
	    return '{You/he} pull{s} the keyring out of the mailbox and pocket{s} it. ';
	}
	else
	    return '{You/he} pick{s} up {the dobj/him}. ';
    }

    // This is my custom inline keyring view
    contentsListed {
	if(isIn(mailbox102Door))
	    return nil;
	else
	    return inherited();
    }

    // To get rid of the pesky "the door of mailbox 102 has a keyring"
    isListed {return (mailboxes.described || mailbox102.described || mailbox102Door.described); }
    
    isMyKey(key) { return (key is in (oldFolksMailboxKey, oldFolksHouseKey )); }

    hideFromAll(action) {
	if(location == mailbox102Door)
	    return true;
	else
	    return nil;
    }
;

// The key to the old folks' mailbox
+oldFolksMailboxKey : Key '(small) metal round steel mailbox mail key' 'round mailbox key'
    "The small, round key is a typical design for a mailbox key. You
     recall having some key similar to this once before. "
    hideFromAll(action) {
	if(oldFolksKeyring.location == mailbox102Door && location == oldFolksKeyring)
	    return true;
	else
	    return nil;
    }
    dobjFor(Take) maybeRemapTo(isIn(oldFolksKeyring),Take,oldFolksKeyring)
;

+oldFolksHouseKey : Key 'steel metal square squarish house apartment key' 'square key'
    "The squarish steel key is of solid design.
     <<firstHallwayToOldFolksDoor.isKeyKnown(self) ? 'It is the key
     to apartment 102, the old folks\' place. ' : 'It looks like it
     might be a house key or something. '>> "
    hideFromAll(action) {
	if(oldFolksKeyring.location == mailbox102Door && location == oldFolksKeyring)
	    return true;
	else
	    return nil;
    }
    dobjFor(Take) maybeRemapTo(isIn(oldFolksKeyring),Take,oldFolksKeyring)
;



// The hairpin that can be used to pick several locks.
hairPin : Key
    vocabWords = 'hair bobby pin/clip/clasp/wire/hairpin'
    name = 'hair pin'
    desc = "This little crimped piece of wire is designed to hold
	    back hair. In the movies they are an integral part of
	    your do-it-yourself spy kit. "
    location = laundryLeftMachine
    subLocation = &subContainer
    initDesc = "A hairpin lies lonesome in the washing machine basket. "
    iobjFor(UnlockWith) {
	verify() { nonObvious;}
    }
;

// The hairdryer
hairDryer : OnOffControl, RestrictedContainer
    vocabWords = 'hair portable dryer/drier/blower/heater'
    name = 'portable hair dryer'
    desc = "Some no-name brand manufacturer made this portable hair
	    dryer (probably to appease those parts of the community
	    who want to dry their hair in the shower, or to kill
	    such people). It is made out of bright red plastic with
	    black trim. A small dial allows you to set the heat to
	    LOW or HIGH, for supreme hair-drying control. <<specialOnDesc>>"
    location = nil
    curSetting = (hairDryerSetting.curSetting)
    specialOnDesc {
	if(isOn) {
	    if(curSetting == 'low')
		"The dryer is currently whirring away, blowing out warm air. ";
	    else
		"The dryer is currently blasting out a wave of firey heat. ";
	}
	else {
	    if(curSetting == 'low')
		"The dryer is currently off, and set to low. ";
	    else
		"The dryer is currently off, and set to high. ";
	}
    }
    soundPresence = (isOn)
    soundHereDesc() {
	if(curSetting == 'low')
	    "The hair dryer <<isIn(me) ? 'in your hands' : nil>> is whirring away to itself. ";
	else
	    "The hair dryer <<isIn(me) ? 'in your hands' : nil>> is blasting out a wave of firey heat. ";
    }
;

+hairDryerSetting : Component, LabeledDial
    vocabWords = '(heat) (small) setting/dial/switch'
    name = 'hair dryer heat dial'
    desc = "The little switch on the side of the dryer allows you to set the heat to LOW or HIGH. "
    validSettings = ['low', 'high']
    curSetting = 'low'
    owner = hairDryer
;


testCard : SwipeCard
    vocabWords = 'swipe key security card/keycard'
    name = 'key card'
    desc = "TEST KEY CARD"
    location = me
    isValid = true
    accessibleFloors = [0, 1, 2, 7]
;

managerCard : SwipeCard
    vocabWords = 'spare swipe key security card/keycard'
    name = 'spare key card'
    desc = "It looks a lot like a credit card, but without the
	    indentations. On the front someone has written
	    <q>SPARE</q> with a marker, and the back has just the
	    magnetic strip. There are no other clues to help you
	    figure out what this card is used for. "
    location = managerSafe
    isValid = true
    accessibleFloors = [0, 1, 2]
;


masterpieceGames : Thing
    vocabWords = 'masterpiece if interactive fiction computer game/games/CD/disc/disk'
    name = 'Masterpiece Games CD'
    desc = "The CD sits inside a thin paper jacket with the words
	    <q>MASTERPIECE GAMES</q> scribbled on the front in black
	    marker. There is nothing else remarkable about the CD.
	    Maybe the CD means something to someone else, it just
	    means nothing to you. "
;

masterpieceGamesHintBook : Readable
    vocabWords = 'masterpiece if interactive fiction game computer hint book/hintbook/hints'
    name = 'the hints to Masterpiece Games'
    desc = "UNIMPLEMENTED YET. "
    readDesc = "UNIMPLEMENTED YET. "
;


// Add in name-changing like "an open bottle of aspirin" and "an open, empty bottle of aspirin"

aspirinBottle : Openable, RestrictedContainer, Readable
    vocabWords = '(small) aspirin panadol headache tablets/bottle/container/drugs/pills/medication/pharmaceuticals'
    /*name {
	if(isOpen)
	    if(contents == [])
		return 'open, empty bottle of aspirin';
	    else
		return 'open bottle of aspirin';
	else
	    if(contents == [])
		return 'empty bottle of aspirin';
	    else
		return 'bottle of aspirin';
    }*/
    name = 'bottle of aspirin'
    location = receptionFilingCabinets.subSurface
    desc {
        "They keep making aspirin bottles barely larger than a few
	 pills. You wonder if they expect you to eat the whole
	 thing, child-proof cap and all. No way would you try. Those
	 caps are tough enough to open usually, and you don\'t think
	 your innards would be much better than the rest of you. ";

	 if( !aspirin.isIn(self) ) {
	     "There are no more aspirin left. ";
	 }
    }
    readDesc = "The label clearly reads: <q>Aspirin</q> "
    contentsListed = (isOpen)
    validContents = [aspirin]
    initiallyOpen = nil
    bulkCapacity = 1
    weightCapacity = 1
    notifyRemove(obj) {
	cmdDict.addWord(self, 'empty', &adjective);
    }
    dobjFor(Empty) {
	preCond = [objHeld, objOpen]
	verify() {
	    if( !aspirin.isIn(self) )
		illogicalNow('{The dobj/he} is already empty. ');
	}
	check() {}
	action() {
	    replaceAction(Take, aspirin);
	}
    }
    dobjFor(Open) {
	action() {
	    cmdDict.addWord(self, 'open', &adjective);
	    inherited();
	}
    }
    dobjFor(Close) {
	action() {
	    cmdDict.removeWord(self, 'open', &adjective);
	    inherited();
	}
    }
    dobjFor(Eat) {
        preCond = [objOpen]
	verify() {
	    if(aspirin.isIn(nil))
		illogical('There are no more tablets to consume. ');
	}
	action() {
	    nestedAction(Eat,aspirin);
	}
    }
;

+ aspirin : Food
    vocabWords = 'aspirin panadol tablets/tablet/pill/pills/drugs/medication/pharmaceuticals'
    name = 'aspirin tablets'
    desc = "UNIMPLEMENTED"
    isPlural = true
    isMassNoun = true
    weight = 1
    bulk = 1
    dobjFor(Eat) {
	check() {
	    if(!gPlayerChar.hasHeadache)
		failCheck('You don\'t need to take these at the moment. ');
	}
	action() {

	    mainReport('You gulp down the aspirin. These must be
			pretty potent because in only thirty seconds
			the chemicals dissolve into your blood, rush
			to your brain and douse the blazing fire
			within. You smile, relieved. ');

	    gActor.hasHeadache = nil;

	    moveInto(nil);

	}
    }
;


// This is a pun: The Tuba-Mensch. The date on the inscription is the
// publication date of the entirety of Thus Spake Zarathustra
tuba : Thing
    vocabWords = 'rusty tarnished musical tuba/mensch/instrument'
    name = 'tuba'
    desc = "Tarnished, rusted and broken, this tuba has seen better
	    days. Other than a few small dints, the only other thing
	    it has on it is a small inscription. "
;

+ Component, Readable
    vocabWords = 'inscription/plaque/writing'
    name = 'inscription'
    desc = "The inscription reads simply: <q>Made in Mensch by Friedrich N, 1892.</q> "
;
