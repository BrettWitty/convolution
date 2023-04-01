#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>
#include <convmain.h>

  //-------------------//
 // Standard classes  //
//-------------------//

/*
 * Generic foldable class
 *
 * Creates a thing that is foldable. Typically a paper-like thing would be foldable. We have the following features:
 * - Examining the object when it is folded gives foldedDesc. When unfolded, uses unfoldedDesc.
 */

class Foldable: Thing
    initializeThing() {
	inherited();
	makeFoldedVocab(isFolded);
    }
    desc {
	isFolded ? foldedDesc : unfoldedDesc;
    }
    isFolded = nil
    isFoldable = true
    isUnfoldable = true
    foldedDesc { return libMessages.foldableFoldedDesc; }
    unfoldedDesc { return libMessages.foldableUnfoldedDesc; }
    foldMsg { return libMessages.foldableFoldMsg(self); }
    unfoldMsg { return libMessages.foldableUnfoldMsg(self); }
    makeFolded(val) {
	isFolded = val;
	makeFoldedVocab(val);
    }
    makeFoldedVocab(val) {
	if(val)
	    foreach(x in foldedVocab) {
		cmdDict.addWord(self, x, &adjective);
	    }
	else
	    foreach(x in foldedVocab) {
		cmdDict.removeWord(self, x, &adjective);
	    }
    }
    foldedVocab = ['folded']
    dobjFor(Fold) {
	preCond = [touchObj]
	verify() {
	    if(!isFoldable)
		illogical('{The dobj/him} cannot be folded. ');
	    else {
		if(isFolded)
		    illogicalNow('{The dobj/him} has already been folded. ');
		else
		    logicalRank(150,'is foldable');
	    }
	}
	action() {
	    defaultReport(foldMsg);
	    makeFolded(true);
	}
    }
    dobjFor(Unfold) {
	preCond = [touchObj]
	verify() {
	    if(!isUnfoldable)
		illogical('{The dobj/him} cannot be unfolded. ');
	    else {
		if(isFolded)
		    logicalRank(150,'is unfoldable');
		else
		    illogicalNow('{The dobj/him} has already been unfolded. ');
	    }
	}
	action() {
	    defaultReport(unfoldMsg);
	    makeFolded(nil);
	}
    }
    dobjFor(Open) remapTo(Unfold,self)
    dobjFor(Close) remapTo(Fold,self)
    dobjFor(Read) {
	preCond = (inherited() + objHeld + objUnfolded);
    }
;

objUnfolded: PreCondition
    checkPreCondition(obj, allowImplicit)
    {
        // if the object is already folded, there's nothing we need to do
        if (obj == nil || !obj.isFolded)
            return nil;
        
        // Try implicitly unfolding it
        if (allowImplicit && tryImplicitAction(Unfold,obj))
        {
	    if(obj.isFolded)
		exit;

            /* tell the caller we executed an implicit command */
            return true;
        }

	reportFailure(&cannotBeFoldedMsg, obj);

        /* make it the pronoun */
        gActor.setPronounObj(obj);

        /* abort the command */
        exit;
    }

    /* lower the likelihood rating for anything not being held */
    verifyPreCondition(obj)
    {
        /* if the object isn't folded, reduce its likelihood rating */
        if (obj != nil && !obj.isFolded)
            logicalRankOrd(80, 'implied unfold', 150);
    }
;

/*
 * Crumpleable
 *
 * An extension of the Foldable class so that you can scrunch the thing up. This interacts with the foldability.
 */

class Crumpleable: Foldable
    desc {
	(isCrumpled ? crumpledDesc : ( hasBeenCrumpled ? postCrumpledDesc : preCrumpledDesc )) ;
    }
    isCrumpled = nil
    hasBeenCrumpled = nil
    preCrumpledDesc { isFolded ? foldedDesc : unfoldedDesc; }
    crumpledDesc { return libMessages.crumpleableCrumpledDesc(self); }
    postCrumpledDesc { return libMessages.crumpleablePostCrumpledDesc(self); }
    crumpleMsg { return libMessages.crumpleableCrumpleMsg(self); }
    flattenMsg { return libMessages.crumpleableFlattenMsg(self); }
    dobjFor(Crumple) {
	preCond = (inherited())
	verify() { }
	action() {
	    defaultReport(crumpleMsg);
	    isCrumpled = true;
	    hasBeenCrumpled = true;
	}
    }
    dobjFor(Flatten) {
	preCond = (inherited())
	verify() { }
	action() {
	    defaultReport(flattenMsg);
	    isCrumpled = nil;
	    isFolded = nil;
	}
    }
;

class CrumpleableNote: Readable, Crumpleable
    readDesc = "There is nothing written on the note. "
    whenDestroyed = nil
    noteTearMsg { return libMessages.noteTearMsg(); }
    noteVanishMsg { return libMessages.noteVanishMsg(); }
    dobjFor(Tear) {
	verify() { dangerous; }
	action() {
	    defaultReport(noteTearMsg);
	    // If whenDestroyed is nil, then we make it vanish.
	    if (whenDestroyed == nil) {
		extraReport(noteVanishMsg);
		self.moveInto(nil);
	    }
	    // Otherwise replace this object with the object in whenDestroyed
	    else {
		whenDestroyed.moveInto(self.location);
		self.moveInto(nil);
	    }
	}
    }
;

class Note : Foldable, Readable
    readDesc = "There is nothing written on the note. "
    whenDestroyed = nil
    noteTearMsg { return libMessages.noteTearMsg(); }
    noteVanishMsg { return libMessages.noteVanishMsg(); }
    dobjFor(Tear) {
	verify() { dangerous; }
	action() {
	    defaultReport(noteTearMsg);
	    // If whenDestroyed is nil, then we make it vanish.
	    if (whenDestroyed == nil) {
		extraReport(noteVanishMsg);
		self.moveInto(nil);
	    }
	    // Otherwise replace this object with the object in whenDestroyed
	    else {
		whenDestroyed.moveInto(self.location);
		self.moveInto(nil);
	    }
	}
    }
    dobjFor(Read) {
	preCond = (inherited() + objUnfolded);
    }
    bulk = 1
    weight = 1
;

/*
 * Creepy note class
 *
 * The secret notes that lie about.
 */

class CreepyNote: Note
    desc = (readDesc)
    readDesc {
	leadInMsg;
	messageText;
	leadOutMsg;
    }
    leadInMsg = "Written on the note is a message. It reads: <BQ>"
    leadOutMsg = "</BQ> <.p>"
    messageText = nil
    newName = (name)
    newVocabWords = (vocabWords)
    newDisambigName = (disambigName)
    dobjFor(Read) {
	action() {
	    inherited();

	    // Do name change things to make life easier
	    name = newName;
	    disambigName = newDisambigName;
	    initializeVocabWith(newVocabWords);

	}
    }
;

class CrumpleableCreepyNote : CrumpleableNote
    readDesc {
	leadInMsg;
	messageText;
	leadOutMsg;
    }
    leadInMsg = "Written on the note is a message. It reads: <BQ>"
    leadOutMsg = "</BQ> <.p>"
    messageText = nil
;


/*
 * Heat class
 *
 * This is a hack of Odor/Noise that allows you to include an ambient heat/coldness.
 *
 */

class Heat : SensoryEmanation
    touchPresence = true
    isTouchListedInRoom = (!isAmbient)
    touchHereDesc() { emanationHereDesc(); }
    cannotSeeSource(obs) { obs.cannotSeeSoundSource(self); }
    hideFromAll(action)
    {
        /* if the command is LISTEN TO, include me in ALL */
        if (action.ofKind(FeelAction))
            return nil;

        /* use inherited behavior */
        return inherited(action);
    }

    /* treat "feel" the same as "examine" */
    dobjFor(Feel) asDobjFor(Examine)

    /* "examine" requires that the object is audible */
    dobjFor(Examine)
    {
        preCond = [touchObj]
    }
;

class Mailbox : KeyedContainer, Fixture
    desc {
	baseDesc;
	if(isOpen)
	    descOpen;
	else
	    descClosed;
    }
    vocabWords = '(mail) somebody mailbox/box/letterbox'
    name = 'somebody\'s mailbox'
    baseDesc {
	if( resident != '' )
	    "This mailbox looks like all the others: compact, black,
	     and metallic. The label on the front indicates that
	     this is <<resident>>\'s mailbox. <<changeName>>";
	else
	    "This mailbox looks like all the others: compact, black and metallic. This one doesn\'t have a label indicating who owns it. ";
    }
    descOpen = "The mailbox hangs open"
    descClosed = "The mailbox is closed"
    location = entrance
    resident = ''
    isQualifiedName = true
    hideFromAll(action) { return true; }
    bulkCapacity = 10
    maxSingleBulk = 2
    initiallyOpen = nil
    initiallyLocked = true
    collectiveGroup = mailboxes
    openStatus() {}
    changeName() {
	name = resident + '\'s mailbox';
	cmdDict.removeWord(self, 'somebody', &adjective);
	initializeVocabWith(resident);
    }

    // You can put stuff in it without requiring the mailbox to be open.
    canObjReachThruOpening(obj) { return nil; }
    checkMoveViaPath(obj, dest, op)
    {
        /* 
         *   if were moving the object in or out of me, we must consider
         *   our openness and whether or not the object fits through our
         *   opening
         */
        if (op is in (PathIn, PathOut))
        {
	    /* we can push things in, but not take them out */
	    if (!isOpen && dest == self)
                return new CheckStatusFailure(cannotMoveThroughMsg,
                                              obj, self);
            
            /* if it doesn't fit through our opening, don't allow it */
            if (!canFitObjThruOpening(obj))
                return new CheckStatusFailure(op == PathIn
                                              ? &cannotFitIntoOpeningMsg
                                              : &cannotFitOutOfOpeningMsg,
                                              obj, self);
        }
        
        /* in any other cases, allow the operation */
        return checkStatusSuccess;
    }
    iobjFor(PutIn) {
	preCond = [touchObj]
    }
;

class SwipeCard : Readable
    cardID = 0
    isValid = nil
    accessibleFloors = []
    dobjFor(Swipe) {
        verify() {
            //logicalRank(100, 'can swipe cards');
            logical;
        }
        check() {}
        action() {
        
            defaultReport('{You/he} swipe{s} the card pointlessly through the
                air. ');
        
        }
    }
    dobjFor(SwipeThrough) {
        verify() { logical; }
    }
;

/* Timed Autoclosing doors. */
/* This is a different kind of autoclosing door. Upon opening, it sets up a   */
/* fuse to shut the door. Imagine this as a swinging door that slowly slides  */
/* shut. */

class TimedAutoClosingDoor : Door
    closeTime = 3
    closeMsg = "\^<<self.theName>> slowly closes by itself and clicks shut. "
    closeFuseID = nil
    isAutoLocking = true
    autoClose() {
		makeOpen(nil);
		if(canSenseAutoClose )
			closeMsg;
    }
    autoLock() {
		makeLocked(true);
    }
    canSenseAutoClose() {
		return (gPlayerChar.canSee(self) || gPlayerChar.canSee(otherSide) );
    }
    makeOpen(stat) {
		inherited(stat);

		/* Set up the fuse */
		if (stat) {
			if(closeFuseID != nil)
				closeFuseID.removeEvent;
			closeFuseID = new Fuse(self,&autoClose, closeTime);
		}
		else {
			if(closeFuseID != nil)
				closeFuseID.removeEvent;
			closeFuseID = nil;
			if(isAutoLocking)
				autoLock;
		}
    }
    dobjFor(Open) {
		preCond = [touchObj]
		verify() {}
		action() {
			if(isOpen)
				"You catch the door before it closes and open it again. ";
			inherited();
		}
    }
;

/* My modified Door class */
/* Added: knock abilities. */
modify Door
    knockMsg = '{You/he} knock{s} loudly on {the dobj/him}. Nothing happens. '
    dobjFor(KnockOn) {
	verify() {
	    logicalRank(140,'knock on door');
	}
	action() {
	    mainReport(knockMsg);
	}
    }
;

/* Window */
/* This is a modified version of a Door. */
class Window : Breakable, ThroughPassage
    breakBehaviour = breakRemain
    breakMsg = 'Using {your/his} sleeve as protection, {you/he} smash{es} the window open with {your/his} elbow. '
    isOpen = (isBroken)
;

/* Sealed Window */
/* Similar to a normal window, but you can't open it without smashing it */
class SealedWindow : Breakable
    breakBehaviour = breakRemain
    breakMsg = 'Using {your/his} sleeve as protection, {you/he} smash{es} the window open with {your/his} elbow. '
;

/* Breakable class */
/* This is a mix-in that has specialized handling of the Break verb. */
class Breakable : object

    // One of breakDestroy, breakReplace or breakRemain
    // - breakDestroy: Send the object to nil when broken.
    // - breakReplace: Replace the object with breakReplacement
    // - breakRemain: Don't replace or remove. Used for custom changes.
    breakBehaviour = breakDestroy

    // The replacement object when broken under breakReplace behaviour.
    breakReplacement = nil

    // Is it already broken?
    isBroken = nil

    // The message reported when this object is broken
    breakMsg = '{You/he} smash {the dobj/him} on the ground. '

    /* Here we take care of breaking behaviour */
    makeBroken(state) {

	/* We are actually breaking the object */
	if(state) {

	    /* What kind of breaking behaviour? */
	    switch(breakBehaviour) {

		case breakDestroy:
		    self.moveInto(nil);
		    break;

		case breakReplace:
		    breakReplacement.moveInto(self.location);
		    self.moveInto(nil);
		    break;

		case breakRemain:
		    isBroken = true;
		    break;

		default:
		    break;
	    }
	}
    }
    dobjFor(Break) {
	verify() {
	    if(isBroken)
		illogicalAlready('{The dobj/he} is already broken. ');
	    else
		logical;
	}
	action() {
	    makeBroken(true);
	    say(breakMsg);
	}
    }
;


// LobbyPhoneObserver
// This is much like BangObserver in the TADS 3 Tour Guide. It is set up so the phone in the lobby
// can be heard from the surrounding rooms.
class LobbyPhoneObserver : SecretFixture
    notifySoundEvent(event, source, info) {
	if(source == lobbyPhone)
	    callWithSenseContext(lobbyPhone,nil,nil);
    }
;

// Electrical equipment class
// An unobtrusive class that specifies that this thing is electrical, which mostly means you can plug it
// into power socket.
class Electrical : PlugAttachable, Attachable
    
    // What can I plug it into? (only the power socket)
    canAttachTo(obj) { return obj.ofKind(PowerSocket); }
;
    
// Basic TV class
// To cut down the redundant coding, I'll just make a TV class.
class TV : Electrical, OnOffControl, NumberedDial

    // The TV's power socket.
    tvPowerSocket = nil

    // Is the TV on?
    isOn { return (isTurnedOn && (tvPowerSocket).isAttachedTo(self) && (tvPowerSocket).isOn); }

    // Is the button allowing it to be on?
    isTurnedOn = true

    // What happens when the TV is turned on or off?
    makeOn(val) {

	if(val) {
	    say(tvTurnOnMsg);
	    blareFuseID = new Fuse(self,&blareFunction,blareFrequency);
	}
	else {
	    say(tvTurnOffMsg);
	    blareFuseID.removeEvent();
	    blareFuseID = nil;
	}

    }

    // When the TV turns on or off, we display this:
    tvTurnOnMsg = 'With a sharp hiss the TV turns on and the image slowly fades in. '
    tvTurnOffMsg = 'The TV turns off with a electronic gasp. '

    // TV channel settings
    minSetting = 0
    maxSetting = 9
    curSetting = '0'

    // The channel desc describes what is on TV if we are on this channel.
    // It is a function so you can catch static channels easier without redundancy
    // and hook into EventLists easier.
    channelDesc {
	// Fill me in
    }

    // A default static display.
    staticDesc = "The screen is filled with uninteresting static. "

    // Sometimes the TV blares when you hang around in a room long enough.
    // blareFuse is the count-down to the next "broadcast"
    blareFuseID = nil
    // Set a random new blare time from the list of blare frequencies
    blareFrequency {
	return rand(blareFrequencyList);
    }
    blareFrequencyList = [3,3,4]
    blareFunction {
	// Fill me in
    }

    // What happens if we move the TV whilst plugged in?
    travelWhileAttached (movedObj, traveler, connector) {
	if(movedObj==self) {
	    foreach(local cur in attachedObjects)
		tryImplicitAction(DetachFrom, self, cur);
	}
    }

    // What happens when we are disconnected from the power?
    handleDetach(obj) {

	// The power is lost, so kill the TV.
	makeOn(nil);

    }

    canAttachTo(obj) { return obj.ofKind(PowerSocket); }
;

// Power sockets
// Mostly used for TVs, but has other uses.
// Make sure you define the wall as the location for the power socket.
class PowerSocket : Component, PlugAttachable, Attachable, OnOffControl

    // Standard desc for convenience's sake
    desc = "This is a standard power outlet with <<maxConnections>> outlets. It is current switched <<onDesc>>. "

    // Can I plug into this socket? Yes if there is space and you are an electrical appliance.
    canAttachTo(obj) { return (length(attachedObjects) <= maxConnections) && obj.ofKind(Electrical); }

    // Things plug into me
    isMajorItemFor(obj) { return obj.ofKind(Electrical); }

    // How many sockets does this power socket have? (that is, how many things can you plug into it)
    maxConnections = 2

    // Default we are on.
    isOn = true
;

// Wettable objects
// A mix-in that has customization for being wet or dry.
class Wettable : object
    desc {
	inherited();
	if(isWet)
	    wetDesc;
	else
	    dryDesc;
    }
    isWet = nil
    makeWet(val) {
	isWet = val;
    }
    wetDesc = (libMessages.defaultWetDesc)
    dryDesc = (libMessages.defaultDryDesc)
;

// Coin
// To make things easier, the only coins about are 1 dollar coins.
class Coin : Thing
    vocabWords = 'coin/dollar/buck*coins*bucks*dollars'
    name = 'one-dollar coin'
    desc = "This is just a dollar coin. They\'re a dime-a-... erm,
	    well, you get the idea. "
    isEquivalent = true
    bulk = 1
    weight = 1
    collectiveGroup = coinGroup
;

// Coin group
// To make multiple viewings cleaner
coinGroup : CollectiveGroup
    vocabWords = 'some change*coins*dollars*bucks'
    name = 'some change'
    isMassNoun = true
    desc = "These dollar coins are just small change. A dime-a-... erm, you get the idea. "
    isCollectiveAction(action, whichObj) {
	if (action.ofKind(ExamineAction))
	    return true;
	else
	    return nil;
    }
    hideFromAll(action) { return true;}
;

// Book
// This is almost a Readable class, but with some customizations.
class Book : Readable
    bookTitle = ''
    author = ''
    dobjFor(Open) remapTo(Read,self)
    dobjFor(LookIn) remapTo(Read,self)
    dobjFor(LookThrough) remapTo(Read,self)
;

// Refrigerator
// It has nothing exceptional to it.
class Refrigerator : OpenableContainer, Heavy
    bulkCapacity = 75
    weightCapacity = 150
;

// Sink
class Sink : Fixture, Container
    isOpen { return true; }
    openStatus { ". "; }
    bulkCapacity = 30
;

// Generic laundry machine
class GenericLaundryMachine : ComplexContainer, Heavy

    // Some special messages
    cannotTurnOffMsg = '{The dobj/he} cannot be turned off directly.
			Just wait for it to finish by itself. '

    // The associated coin slot
    mySlot = nil

    // Daemon handling
    machineDaemonID = nil
    machineDaemon {
	if(!isOpen)
	    machineProcess.doScript;
    }
    machineProcess = nil

    isRunning() {
	return machineDaemonID != nil;
    }
    
    subContainer : ComplexComponent, OpenableContainer {
	bulkCapacity = 75
	weightCapacity = 100
    }
    subSurface : ComplexComponent, Surface {
	bulkCapacity = 30
	weightCapacity = 100
    }
    dobjFor(TurnOn) {
	preCond = [objClosed]
	verify() {
	    if(mySlot.coinInPurgatory)
		logicalRank(140,'is usable');
	    else
		logicalRank(120,'is usable but with less intent');
	}
	check() {
	    // Need to pay, honey
	    if(!mySlot.coinInPurgatory) {
		failCheck('You press the button on {the dobj/him}
			   but it jams. Perhaps you need to feed a
			   coin into the slot first. ');
		exit;
	    }
	    // If the machine is already running, you don't need to press the button any more.
	    if(isRunning()) {
		failCheck('{The dobj/he} is already running. Wait
			   until it is finished. ');
	    }
	}
	action() {

	    // Gobble up the coin in purgatory
	    mySlot.coinInPurgatory = nil;

	    // Set up the dryer daemon
	    machineDaemonID = new SenseDaemon(self,&machineDaemon,1,self,sound);

	    // Tell the player what's happened
	    mainReport('You press the button and you hear your coin drop
			into the bowels of the machine. The motor slowly starts up. ');

	}
    }
    dobjFor(Open) {
	action() {
	    inherited();
	    if(!isRunning())
		reportAfter('After opening {the dobj\'s/his} lid, the machine quickly comes to a halt. ');
	}
    }
    dobjFor(Close) {
	action() {
	    inherited();
	    if(machineDaemonID != nil)
		reportAfter('You slam the {dobj/him} door shut. It automatically spins back up to speed. ');
	}
    }

    // PUT COIN IN DRYER is assumed to be PUT COIN IN SLOT
    iobjFor(PutIn) {
	verify() {}
	check() {}
	remap = nil
	action() {
	    if (gDobj.ofKind(Coin))
		replaceAction(PutIn, gDobj, mySlot);
	    else
		replaceAction(PutIn, gDobj, subContainer);
	}
    }
;

class MachineSlot : Fixture, RestrictedContainer
    canPutIn(obj) { return obj.ofKind(Coin); }
    coinInPurgatory = nil
    myMachine = nil
    iobjFor(PutIn) {
        check() {
	    if(coinInPurgatory) {
		"There is already a coin in
		 <<myMachine.theNamePossAdj>> slot. All you need to
		 do is press the button. ";
		exit;
	    }
	}
	action() {

	    // Put a coin in purgatory.
	    coinInPurgatory = true;

	    // Whisk the old coin away.
	    gDobj.moveInto(nil);

	    // Tell them what's happened.
	    "With a satifying <i>clink!</i> the coin drops through
	     the slot on <<myMachine.theName>>. Close the machine and press the
	     button when you\'re ready. ";
	}
    }
;

// Door locks
class DoorLock : LockableWithKey, Component
    vocabWords = '(door) (key) lock/keyhole/hole'
    name = 'lock'
    myDoor = nil
    owner = (myDoor)
    keyList = (myDoor.keyList)
    nothingBehindMsg = 'The keyhole is too thin to look through. '
    dobjFor(Unlock) {
	verify() {}
	action() {
	    // We allow short-circuiting with the hair pin (if that
            // is valid for the door)
	    if(hairPin.isIn(gActor) && keyList.indexOf(hairPin))
		replaceAction(UnlockWith,myDoor,hairPin);
	    else
		askForIobj(UnlockWith);
	}
    }
    dobjFor(UnlockWith) remapTo(UnlockWith,myDoor,IndirectObject)
    dobjFor(Lock) {
	verify() {}
	action() {
	    // We allow short-circuiting with the hair pin (if that
            // is valid for the door)
	    if(hairPin.isIn(gActor) && keyList.indexOf(hairPin))
		replaceAction(LockWith,myDoor,hairPin);
	    else
		askForIobj(LockWith);
	}
    }
    dobjFor(LockWith) remapTo(LockWith,myDoor,IndirectObject)
    dobjFor(Open) remapTo(Open,myDoor)
;



// Modified room
// Based on Eric Eve's TADS 3 Tour Guide inRoomDesc.
modify Room
    roomDesc { inherited; extras(); finalDesc; }
    extras() {
	if(contents.length==0) return; 
	local cur; 
	local vec = new Vector(10); 
	foreach(cur in contents) 
	    if(cur.propType(&inRoomDesc) is in (TypeDString, TypeCode)) 
		vec.append(cur); 
	if(vec.length==0) return;   
	
	vec = vec.sort(nil, {a, b: a.inRoomDescOrder - b.inRoomDescOrder }); 
	foreach(cur in vec)    
	    if(gPlayerChar.canSee(cur)) 
		cur.inRoomDesc; 
    }
    finalDesc = nil
; 

// Eric Eve's VNominal Platform
class VNominalPlatform : NominalPlatform
    postureName = 'standing'
    actorInPrep = 'on'
    statusStanding(actor) { " (<<postureName>> <<actorInName>>)";  }
    actorStandingDesc(actor) { "\^<<actor.itIs>> <<postureName>> <<actorInName>>. "; }
    actorStandingHere(actor) { "\^<<actor.nameIs>> <<postureName>> <<actorInName>>. "; }
    listActorStanding(actor) { "\^<<actor.nameIs>> <<postureName>> <<actorInName>>. "; }    
;  

// Modified Thing
// For compatibility with the new Room functionality.
modify Thing
    inRoomDesc = nil
    inRoomDescOrder = 100
;




modify libMessages
    foldableFoldMsg(obj) { /*gMessageParams(obj);*/ return '{You/he} neatly fold{s} {the dobj/him} in two. '; }
    foldableUnfoldMsg(obj) { /*gMessageParams(obj);*/ return '{You/he} unfold{s} {the dobj/him} and smooth it out. '; }
    foldableFoldedDesc(obj) { /*gMessageParams(obj);*/ return 'A folded piece of paper. '; }
    foldableUnfoldedDesc(obj) { /*gMessageParams(obj);*/ return 'An unfolded piece of paper. '; }
    crumpleableCrumpledDesc(obj) { /*gMessageParams(obj);*/ return '{The dobj/he} is crumpled up in a ball. '; }
    crumpleablePostCrumpledDesc(obj) { /*gMessageParams(obj);*/ return '{The dobj/he} is a flattened-out piece of crumpled paper. '; }
    crumpleableCrumpleMsg(obj) { /*gMessageParams(obj);*/ return '{You/he} scrunch {the dobj/him} into a tight ball. '; }
    crumpleableFlattenMsg(obj) { /*gMessageParams(obj);*/ return '{You/he} smooth out {the dobj/him}. '; }
    noteTearMsg() { return '{You/he} rip{s} {the dobj/him} into tiny pieces. '; }
    noteVanishMsg() { return 'Without warning, the torn pieces vanish into nothingness. '; }
    defaultWetDesc = "It is wet. "
    defaultDryDesc = nil
;

modify playerActionMessages
    cannotBeFoldedMsg(obj) {
	/*gMessageParams(obj);*/
	return '{You/he} need to unfold {the obj/him} before {it actor/he} can do that. ';
    }
;
