#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// The Amazing Lobby Phone

// To Do:
// - Make the hook pushable, which finishes a call.
// - Make it know when the handset is removed from the hook
// - If left dangling for a while, make the handset emit a "hangup" beep


lobbyPhone : Heavy, PermanentAttachment
    location = lobby
    vocabWords = 'small lobby old pay phone/telephone/payphone'
    name = 'the lobby phone'
    desc { (getCurrentState()).desc; }
    feelDesc = (getCurrentState().feelDesc)
    soundDesc = (getCurrentState().soundDesc)
    specialDesc = (getCurrentState().specialDesc)
    //initDesc = (getCurrentState().initDesc)
    inRoomDesc = (getCurrentState().inRoomDesc)
	    
    isDetermined = true
    isQualifiedName = true
    attachedObjects = [lobbyPhoneHandset]
    isMajorItemFor(obj) { return obj==lobbyPhoneHandset; }

    // Our state handlers
    currentState = lobbyPhoneIdle
    usualState = lobbyPhoneIdle
    changeState(state) {
	currentState.finishState();
	currentState = state;
	currentState.initiateState();
    }
    getCurrentState() { return (currentState == nil ? usualState : currentState); }

    // A modification to get Vern in scope during a call
    getExtraScopeItems(actor) {
	if(currentState == lobbyPhoneInConversation && currentCaller == vern)
	    return [vern];
	else
	    return nil;
    }

    // Our daemon handlers
    daemonID = nil
    fuseID = nil
    curNumberRings = 0
    maxNumberRings = 8
    
    // Make the phone ring
    doPhoneRing() {
	if(curNumberRings == maxNumberRings) {
	    changeState(lobbyPhoneIdle);
	    curNumberRings = 0;
	    callWithSenseContext(self, sound, {: "The ringing phone suddenly falls silent. "});
	    currentCaller = nil;
	}
	else {
	    curNumberRings++;
	    lobbyPhoneRingEvent.triggerEvent(self);
	}
    }

    // The person on the other end
    // nil corresponds to a dial-tone
    currentCaller = nil

    // Hang up the phone
    // On hook means we've hung up properly. Otherwise we've just pushed the hook down.
    hangUp(onHook) {
	if(onHook) {
	    changeState(lobbyPhoneIdle);
	    if(lobbyPhoneHandset.location != lobbyPhoneHook)
		// Causes infinite loop!
		//tryImplicitActionMsg(&announceImplicitAction,PutOn,lobbyPhoneHandset,lobbyPhoneHook);
		lobbyPhoneHandset.moveInto(lobbyPhoneHook);
	}
	else
	    changeState(lobbyPhoneHangingIdle);
    }

    // Switch to dial-tone
    dialTone() {
	if(fuseID != nil) {
	    fuseID.removeEvent;
	    fuseID == nil;
	}
	if(currentState == lobbyPhoneInConversation) {
	    currentCaller = nil;
	    changeState(lobbyPhoneInConversation);
	}
    }

    // Text to display if we've dialled something outside of our limited phonebook
    invalidNumber : ShuffledList {
	valueList = ['A recorded voice states: <q>The number you
		      have dialled is unavailable.</q> For some
		      strange reason you feel that somehow the
		      person speaking this message was holding back
		      a wide grin, despite the voice sounding okay.
		      Weird.',
		     'The phone tries to respond with an engaged
		      signal but stutters and beeps sporadically,
		      eventually breaking into the dial tone again.
		      ',
		     'The call seems to be going through. However
		      after umpteen many rings, they don\'t pick up.
		      You sigh and click the receiver down,
		      obtaining a dial tone again. ',
		     'As if caught in some crazy interference the
		      phone states: <q>The numb---is
		      unavail---dialled---out of---lution... Please
		      hang up and try again--ag--ag--again--again...
		      </q> You stare at the handset, confused. You
		      jam the phone hook down, returning to the dial
		      tone. ']
		      }

    // My phone book.
    // All possible phone numbers are listed here.
    emergencyNumbers = ['911','000','111','110','999','17']
    myPhoneBook = (['101'] + emergencyNumbers)

    // The magic dialing procedure
    dobjFor(Dial) {
	verify() {
	    if(currentState == lobbyPhoneInConversation && currentCaller != nil)
		illogicalNow('{You/he} are already in the middle of a call. ');
	    if(currentState == lobbyPhoneRinging)
		illogicalNow('{The dobj/he} is ringing. Answer the call or hang up on it before dialing. ');
	}
	check() {
	    if(!myPhoneBook.indexOf(gLiteral)) {
		say(invalidNumber.getNextValue());
		exit;
	    }
	}
	action() {

	    if(emergencyNumbers.indexOf(gLiteral))
		"You call <<gLiteral>>. No-one answers. ";
	    else {
		if(gLiteral == '101') {
		    // Set the caller
		    currentCaller = vern;
		    // Start the call
		    changeState(lobbyPhoneInConversation);
		}
	    }
	}
    }
    
    dobjFor(Take) remapTo(Take,lobbyPhoneHandset)
    dobjFor(Drop) remapTo(Drop,lobbyPhoneHandset)
    dobjFor(HangUp) remapTo(HangUp,lobbyPhoneHandset)
;

lobbyPhoneHook : Fixture, RestrictedContainer
    vocabWords = 'hook/cradle'
    name = 'hook'
    desc = "A small metal hook is embedded in the front-left side of the phone. "
    validContents = [lobbyPhoneHandset]
    owner = lobbyPhone
    location = lobby

    // To make it more component-like
    verifyMoveTo(newLoc)
    {
        /* it's never possible to do this */
        illogical(&cannotMoveComponentMsg, location);
    }

    // This replacement is so it says: "It holds a handset. "
    // rather than "It contains a handset. "
    descContentsLister : DescContentsLister, BaseThingContentsLister {
	showListPrefixWide(itemCount, pov, parent)
        { "\^<<parent.itVerb('hold')>> "; }
    }

    dobjFor(HangUp) {
	preCond = [touchObj]
	verify() {
	    if(lobbyPhoneHandset.isIn(lobbyPhoneHook))
		illogicalNow('The phone has already been hung up. ');
	}
	check() {
	    // If the phone is already on the hook, warn the silly player.
	    if(lobbyPhone.currentState == lobbyPhoneIdle) {
		"The phone has already been hung up. ";
		exit;
	    }
	}
	action() {

	    "You click the phone hook down, disconnecting the call. ";
	    lobbyPhone.hangUp(nil);
	    
	}
    }
	    

    dobjFor(Push) remapTo(HangUp,self)
    dobjFor(Pull) remapTo(HangUp,self)
    dobjFor(Move) remapTo(HangUp,self)
    dobjFor(Poke) remapTo(HangUp,self)
    iobjFor(PutOn) {
	verify() { logical; }
	check() {
	    // You can't put really big (i.e. bulky) things on the hook
	    if(gDobj.bulk > 2) {
		"That is too big to balance on the phone hook! ";
		exit;
	    }
	}
	action() {
	    if(gDobj == lobbyPhoneHandset)
		replaceAction(HangUp,lobbyPhoneHandset);
	    else {

		// If it's superlight, let it just fall to the ground.
		if(gDobj.weight < 2)
		    mainReport('{The dobj/he} simply falls off the hook to the ground. ');
		else
		    mainReport('You place {the dobj/him} on the phone hook. The hook is pushed down, before angling enough to drop {the dobj}. You try to catch it, but it just falls through your hands. ');

		// Should really use Drop code for this, but what the heck.
		nestedAction(Drop,gDobj);
	    }
	}
    }
;

+lobbyPhoneHandset : PermanentAttachment, Thing
    vocabWords = '(phone) handset/receiver'
    name = 'handset'
    desc = "The handset for the phone is made out of hard, black
	    plastic that has begun to wear. It has the dull sheen
	    that comes from passing through hundreds of greasy
	    hands and being stuck next to sweaty heads. "
    attachedObjects = [lobbyPhone]
    isListed = nil
    owner = lobbyPhone
    okayTakeMsg = 'You pick up the handset and listen. '
    okayDropMsg = 'You let the receiver fall from your hands. It
		   dangles from the phone, rocking back and forth,
		   colliding every so often, sending itself into a
		   spin. '
    
    travelWhileAttached(movedObj, traveler, connector) {
	"Before you leave, you put the handset back on the hook. ";
	moveInto(lobbyPhoneHook);
	lobbyPhone.hangUp(true);
    }
    
    moveWhileAttached(movedObj,newCont) {
	
	// Only allow people to hold the receiver in their hands
	// but not their pockets or backpacks.
	/*if(!newCont.ofKind(Actor) && !newCont.ofKind(Room) ) {
	    "The phone cord won\'t reach that far! ";
	    exit;
	}*/
    }

    dobjFor(PutOn) {
	action() {

	    if(gIobj == lobbyPhoneHook)
		replaceAction(HangUp,lobbyPhoneHook);
	    else
		inherited();
	}
    }
    dobjFor(ThrowAt) {
	verify() { logical;}
	check() {}
	action() {
	    // We could be tricky and catch certain objects (like the nearby wall)
	    // but how about just keeping it simple.
	    mainReport('You fling the telephone handset at {the
			iobj/him} but it jerks in midair and crashes
			beside the phone, swinging and shaking by
			its cord. ');

	    // Make me hanging
	    if(lobbyPhone.currentState is in (lobbyPhoneIdle, lobbyPhoneHangingIdle))
		lobbyPhone.changeState(lobbyPhoneHangingIdle);
	    //else
		// NEED CUSTOM CODE FOR MID-CALL THROWS!!!
	}
    }
    dobjFor(Drop) {
	
	// Added code to change the state of the phone
	// YOU NEED TO REDIRECT THIS ACCORDING TO WHETHER
	// WE ARE ACTIVE OR NOT.
	action() {
	    inherited();
	    lobbyPhone.changeState(lobbyPhoneHangingIdle);
	}
    }
    dobjFor(HangUp) {
	preCond = [objHeld]
	verify() { logical;}
	check() {
	    // If the phone is already on the hook, warn the silly player.
	    if(lobbyPhone.currentState == lobbyPhoneIdle && lobbyPhoneHandset.isIn(lobbyPhoneHook)) {
		"The phone has already been hung up. ";
		exit;
	    }
	}
	action() {

	    // If the phone is already ringing, do a quick hangup
	    if(lobbyPhone.currentState == lobbyPhoneRinging) {
		"You quickly lift the receiver and drop it back down, cutting dead the ringing. ";
		lobbyPhone.hangUp(true);
	    }
	    // Otherwise, do the usual
	    else{
		"You put the handset back on the hook. ";
		lobbyPhone.hangUp(true);
	    }
	    
	}
    }
    dobjFor(Take) {
	action() {
	    inherited();
	    lobbyPhone.changeState(lobbyPhoneInConversation);
	}
    }
;

lobbyPhoneObserver : SecretFixture
    location = lobby
    notifySoundEvent(event, source, info) {
	if(source==lobbyPhone)
	    callWithSenseContext(self, sound, {: giveRingDistance});
    }

    // Figures out the distance between the phone and the player, and
    // gives an appropriate message.
    giveRingDistance {
	local info;

	info = gPlayerChar.senseObj(sound,self).trans;

	if(info is in (obscured, distant)) {

	    if(gPlayerChar.isIn(backRoom))
		"You can hear a phone ringing somewhere to the south. ";

	    if(gPlayerChar.isIn(reception))
		"Over the front counter to the south you spy a small phone. It rings loudly. ";

	    if(gPlayerChar.isIn(entrance))
		"A phone to the north rings insistently. ";

	    if(gPlayerChar.isIn(groundHallway))
		"The ring of the phone to the west reverberate through the hallway. ";

	}
	else
	    "The lobby phone rings incessantly. ";
    }
;

lobbyPhoneRingEvent : SoundEvent;



// Much like ActorStates, here are a bunch of lobby phone states to handle things elegantly.
// ThingState isn't quite what we want here.

class lobbyPhoneState : object
    
    // Custom descriptions
    desc = nil
    specialDesc = nil
    inRoomDesc = nil

    // Custom feel description
    feelDesc = nil

    // Custom listen description
    soundDesc = nil

    // (taste and smell aren't needed for the phone)

    // Is this state active?
    isActive = true

    // Do stuff when we are initiated
    initiateState() {}

    // Do stuff when we finish being this state
    finishState() {}
;

lobbyPhoneIdle : lobbyPhoneState
    desc = "The management has installed a squat, black plastic
	    phone adjacent to the reception window. They probably
	    call it a <q>courtesy phone</q> but <q>courtesy</q>
	    should read <q>purely utilitarian</q>. Screwed into the
	    wall above it hangs a small sign listing various phone
	    numbers. "
    feelDesc = "The worn black plastic is not too appealing, but
		you\'ve certainly seen much worse in the realm of
		public phones. "
    soundDesc = nil
    inRoomDesc = "\b Nestled in a corner by the reception desk is a small pay phone. "
    initiateState() {
	lobbyPhone.currentCaller = nil;
    }
;

lobbyPhoneRinging : lobbyPhoneState
    // Add a slight variation when the phone is ringing.
    desc { lobbyPhoneIdle.desc; "The phone is currently ringing loudly. "; }
    feelDesc = "Your fingers tingle as they touch the vibrating lobby phone. "
    soundDesc = "The phone rings intently. "
    inRoomDesc = "\b Nestled in a corner by the reception desk is a small pay phone. "
    initiateState() {
	lobbyPhone.daemonID = new Daemon(lobbyPhone, &doPhoneRing, 1);
    }
    finishState() {
	lobbyPhone.daemonID.removeEvent;
	lobbyPhone.daemonID = nil;
    }
;

lobbyPhoneHangingIdle : lobbyPhoneState
    desc { lobbyPhoneIdle.desc; "The phone receiver dangles in the air, swinging gently. "; }
    soundDesc = "You can hear the timid dial tone mumbling out from
		  the dangling phone receiver. "
    feelDesc = (lobbyPhoneIdle.feelDesc)
    inRoomDesc = (lobbyPhoneIdle.inRoomDesc)
;

// This one is the tricky one.
lobbyPhoneInConversation : lobbyPhoneState

    desc { lobbyPhoneIdle.desc; }
    feelDesc = (lobbyPhoneIdle.desc)
    inRoomDesc = (lobbyPhoneIdle.inRoomDesc)
    specialDesc = "You\'re standing by the phone with the handset to your ear. "

    doConversation(caller) {

	if(caller == creepyCallers) {
	    "For a moment you hear nothing. You give the handset an
	     incredulous look and put it back to your ear, listening
	     intently. All of a sudden you make out a subtle,
	     hissing whisper. Voices - one, two, many? - trade faint
	     secrets and low mutters. Someone giggles. The handset
	     trembles in your palm. A rough, throaty, pulsating
	     breath slowly slides in from the silence, growing
	     louder in each exhalation, drowning out everything
	     else. Your muscles tense, yearning to throw the handset
	     away but remain frozen in trepidation. The breathing is
	     almost roaring, close as if it were across the nape of
	     your neck. Suddenly it stops and the dial tone pounds
	     in your ear. You catch yourself gulping down lungsful
	     of air, shake your head and grin nervously. You loosen
	     your grip on the phone. ";
	    lobbyPhone.fuseID = new Fuse(lobbyPhone,&dialTone,1);
	}
	else {

	    if(caller == vern) {
		vern.initiateConversation(nil, 'vernTakingEmergencyCall');
	    }
	    else {
		if(caller == nil) {

		    // If the player has been tricky and hasn't put the phone back on the hook...
		    if(!lobbyPhoneHandset.isIn(lobbyPhoneHook))
			"The phone stutters out a faint dial tone. ";
		}
	    }
	}

    }

    initiateState() {
	// Start the call
	doConversation(lobbyPhone.currentCaller);
    }

    finishState() {
	lobbyPhone.currentCaller = nil;
    }

;




//*****************************//
// PHONE CONVERSATION STUFF!!! //
//*****************************//

// The current plan is to set up a variable conduit between the PC and Vern (if you've called him)
// Hopefully the conversation code will account for this stuff.

phonePathway : SenseConnector, SecretFixture
    transSensingThru(sense) {
	if( sense == sound && lobbyPhone.currentState == lobbyPhoneInConversation && lobbyPhone.currentCaller == vern)
	    return transparent;
	else
	    return opaque;
    }
    locationList = [lobby,vern]
;


creepyCallers : object;

