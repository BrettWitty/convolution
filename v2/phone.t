#include <convolution.h>

officePhone : Thing, PermanentAttachment
    vocabWords = 'phone/telephone'
    name = 'telephone'
    
    desc = "Phone. "
    
    location = officeDesk.subSurface
    
    contentsListed = nil
    
    // Attachments
    attachedObjects = [ officePhoneHandset ]
    isMajorItemFor(obj) { return obj == officePhoneHandset; }
    
    // Behaviour constants
    maxNumberRings = 20
    curNumberRings = 0
    myHandset = officePhoneHandset
    myHook = self
    ringDaemonID = nil   // For any timed behaviour for phone ringing
    fuseID = nil
    
    // Sound settings
    ringingNoises = [ ]
    
    // Caller constants
    currentCaller = nil // nil is dial tone
    myPhoneBook = [ janitorTopic, emergencyPhoneCall ]

    isInPhoneBook(obj) {
	return myPhoneBook.indexOf(obj) != nil;
    }
    
    invalidNumberMsg : ShuffledList {
	valueList = ['A recorded voice states: <q>The number you have dialled
            is unavailable.</q> For some strange reason you feel that somehow
            the person speaking this message was holding back a wide grin.
            Weird. ',
		     'The phone tries to respond with an engaged signal but
                     stutters and beeps sporadically, eventually breaking into
                     the dial tone again. ',
		     'The call seems to be going through. However after umpteen
                     many rings, they don\'t pick up. You sigh and click the
                     receiver down, obtaining a dial tone again. ',
		     'As if caught in some crazy interference the phone states:
                     <q>The numb---is unavail---dialled---out of---lution...
                     Please hang up and try again--ag--ag--again--again... </q>
                     You stare at the handset, confused. You jam the phone hook
                     down, returning to the dial tone. ']
    }
    
    // A modification to get Vern in scope during a call
    getExtraScopeItems(actor) {
	if( amTalkingToVern() )
	    return [ vern ];
	else
	    return inherited(actor);
    }

    // Make the phone ring or not
    makeRing(val) {

	// If we are stopping the ringing, cancel the daemon too
	//if( isRinging() ) {
	    if(!val && ringDaemonID != nil) {
		ringDaemonID.removeEvent;
		ringDaemonID = nil;
	    }
	//}
    }

    // Disconnect a call
    disconnectCall() {
	
	// Notify Vern that we have ended the conversation
	if(amTalkingToVern())
	    endConversation(vern,endConvBye);

	// Nullify the caller
	currentCaller = nil;

	// Make sure it isn't ringing any more
	makeRing(nil);

	// Cue the dialtone sound
	fuseID = new Fuse(self, &cueDialtone, 1);

    }

    // Connect a call
    connectCall(toWho) {

	if( toWho == creepyCallers ) {
	    currentCaller = creepyCallers;
	}

	if( toWho == vern ) {
	    currentCaller = vern;
	    vern.initiateConversation(nil, 'vernTakingEmergencyCall');
	}

	if( toWho == emergencyPhoneCall ) {
	    currentCaller = nil;
	    emergencyPhoneCall.answerCall();
	}

	// If someone is ringing in, cue the ringing daemon
	if( isRinging() ) {
	    ringDaemonID = new Daemon(self, &doPhoneRing,1);
	}
    }

    // Make the phone ring
    doPhoneRing() {

	if(curNumberRings == 0) {
	    makeRing(true);
	}

	curNumberRings += 1;
        officePhoneRingEvent.triggerEvent(self);

	// If we have rung too many times, then disconnect and let
        // the player know about the end of the ringing.
	if(curNumberRings >= maxNumberRings) {

	    // Tests if the player could hear the end of the ringing
            // and tells them if so.
	    if( (ringingNoises.mapAll({x : gPlayerChar.canHear(x)})).countOf(true) > 0 )
		"The ringing phone suddenly falls silent. ";
	    disconnectCall();
	    curNumberRings = 0;
	}
	
    }

    // Cue dialtone
    cueDialtone() {
	makeDialtone(true);
    }

    // Do dialtone buzzing
    makeDialtone(val) {

	if(val) {

	    // Tell the noisemaker to do a dialtone but not if we are busy doing something else
	    if( doDialtone() ) {
	        officePhoneDialtoneSound.isEmanating = true;
	    }
	}
	else
	    officePhoneDialtoneSound.isEmanating = nil;
    }

    // Do we do a dialtone?
    doDialtone() {
        return currentCaller == nil && !isHandsetOnHook();
    }

    // Am I already in a conversation with someone?
    alreadyConversing() {

	// If the phone is on dialtone, we aren't talking to anyone (and no-one is ringing)
	if(currentCaller == nil)
	    return nil;
	// Otherwise we are already talking, or the phone is ringing
	else
	    return true;
    }

    // Am I pending a call and ringing?
    isRinging() {

	// If no caller, then we're dial-toning
	if(currentCaller == nil)
	    return nil;
	else {
	    // If I'm on the hook, then yes I'm ringing
	    if(myHandset.location == myHook)
		return true;
	    // Otherwise no (hanging or in the player)
	    else
		return nil;
	}
    }

    // Is the handset actually on the hook?
    isHandsetOnHook() { return myHandset.location == myHook; }

    // Are we talking to Vern?
    amTalkingToVern() { return currentCaller == vern; }

    // Verbs
    dobjFor(DialOn) {
	preCond = [handsetHeldPreCondition]
	verify() {

	    // If the phone is ringing, no go
	    if(isRinging())
		illogicalNow('The dobj/he} is ringing. Answer the
			      call or hang up on it before dialing. ');
	    else {
		// The phone isn't ringing but we're talking (or the phone is dangling)
		if(alreadyConversing())
		    illogicalNow('{You/he} {is} already in the middle of a call. ');
		else
		    logicalRank(150,'is dialable');
	    }
	}
	check() {
	    // Is the phone number dialled legit? (in our phonebook)
	    if(!isInPhoneBook(gTopic.getBestMatch()) ) {
		// Give em an invalid number response
		say(invalidNumberMsg.getNextValue());
		// All invalid numbers hang up the call, so disconnect the call
		disconnectCall();
		exit;
	    }
	}
	action() {
	    connectCall(gTopic.getBestMatch().caller );
            defaultReport('You dialled ' + gLiteral);
	}
    }

    dobjFor(Take) remapTo(Take,myHandset)

    dobjFor(HangUp) {
	preCond = [touchObj]
	verify() {

	    // If handset is already on the hook and the phone is not ringing, silly player
	    if(myHandset.location == myHook && !isRinging())
		illogicalNow('The phone has already been hung up. ');
	    else
		logicalRank(140,'can hang up');

	}
	action() {

	    // If the phone is ringing, we do a quick hang-up
	    if(isRinging()) {
		mainReport('You quickly lift the receiver and drop it back down. The phone stops ringing. ');
		disconnectCall();
	    }
	    else {
		mainReport('{You/he} put{s} the handset back on the hook with a <i>click!</i>. ');
		disconnectCall();
		myHandset.moveInto(myHook);
	    }
	}
    }

    dobjFor(Answer) {
	preCond = [handsetHeldPreCondition]
	verify() {
	    // Are we already holding the handset?
	    //if(alreadyConversing() && !isRinging())
		//illogicalNow('You are already holding the phone. ');
	}
	action() {
	    if(currentCaller != nil) {
		// DO THE CALLER SETUP CODE
		currentCaller.answerCall();

		// Cancel any ringing
		if(isRinging() ) 
		    makeRing(nil);
	    }
	    else {
		if(fuseID == nil)
		    defaultReport('All {you/he} can hear is the pulsing dial tone. ');
	    }
	}
    }

    dobjFor(Drop) remapTo(Drop, officePhoneHandset)
;
  

+officePhoneHandset : Thing, PermanentAttachment
    vocabWords = '(phone) handset/receiver'
    name = 'handset'
    desc = "The handset for the phone is made out of hard, black plastic that
        has begun to wear. It has the dull sheen that comes from passing
        through hundreds of greasy hands and being stuck next to sweaty
        heads. "
    
    attachedObjects = [ officePhone]
    isListed = nil
    isListedInContents = nil
    isListedInInventory = nil
    owner = officePhone
    
    okayTakeMsg = 'You pick up the handset and listen. '
    okayDropMsg = 'You let the receiver fall from your hands. It dangles from
        the phone, rocking back and forth, colliding every so often, sending
        itself into a spin. '
    hideFromAll(action) { return true; }
    travelWhileAttached(movedObj, traveler, connector) {

	if(movedObj == self)
	    tryImplicitAction(HangUp,self);
    }

    dobjFor(Take) {
	verify() {}
	action() {
	    inherited();
	    if(officePhone.currentCaller != nil)
		nestedAction(Answer,officePhone);
	}
    }
    
;



phonePathway : SenseConnector, SecretFixture
    transSensingThru(sense) {
	if( sense == sound && officePhone.currentCaller == vern)
	    return transparent;
	else
	    return opaque;
    }
    locationList = [office,vern]
;

creepyCallers : object
    answerCall() {
	mainReport('For a moment you hear nothing. You give the
		    handset an incredulous look and put it back to
		    your ear, listening intently. All of a sudden
		    you make out a subtle, hissing whisper. Voices -
		    one, two, many? - trade faint secrets and low
		    mutters. Someone giggles. You think you hear:
		    <q>He\'s here.</q> The handset trembles in your
		    palm. A rough, throaty, pulsating breath slowly
		    slides in from the silence, growing louder in
		    each exhalation, drowning out everything else.
		    Your muscles tense, yearning to throw the
		    handset away but remaining frozen in
		    trepidation. The breathing is almost roaring,
		    close as if it were across the nape of your
		    neck. Suddenly it stops and the dial tone pounds
		    in your ear. You catch yourself gulping down
		    lungsful of air. You shake your head, grin
		    nervously and loosen your grip on the phone. <.reveal creepy-phone-call>');

	officePhone.disconnectCall();
    }
;

emergencyPhoneCall : Topic
    vocabWords = '911/000/111/110/999/17'
    answerCall() {
	emergencyResponse.doScript();
	officePhone.disconnectCall();
    }
    emergencyResponse : ShuffledEventList {
	firstEvents = ['You call the emergency hotline. The other
			end picks up silently. <.p><q>Hello,
			emergency services?</q><.p>To your surprise
			they play back exactly what you said.
			<.p><q>Hello?</q> <.p><q>Hello?</q> <.p><q>Is
			anyone there?</q> <.p><q>Is anyone
			there?</q> <.p>Frustrated, you hang up the
			phone. Darn kids or whoever that was.',
		       'You call the emergency hotline. A female
			voice answers, <q>Hello?</q> <.p><q>Hello,
			emergency services? You\'ve gotta help
			me.</q> <.p>There is a pause. She says
			quietly, <q>Um, sir, where do you think you
			are?</q> <.p><q>Huh? What?</q> <.p>The voice
			sighs and says, <q>Sorry, Sir,</q> and hangs up.
			What the hell was that?',
		       'You dial emergency services and wait. After a few
                       rings, the other line picks up to the sound of a
                       struggle. Two similar male voices mutter and grunt,
                       fighting over the phone. It clatters loudly and the
                       grunts and muffled slaps continue. Someone falls close
                       to the phone and shouts out, <q>Go up---</q> before the
                       line cuts out. Weird.' ]
	eventList = ['<q>The number you have called is not available. Emergency
            services has been discontinued because of you. Good day.</q>',
		     '<q>The number you have called is not available. Emergency
                     services has been disconnected due to
                     indistinguishability. Good day.</q>',
		     '<q>The number you have called is not available. Emergency
                     services only deals with singular organisms. Please voice
                     your complaints with the relevant high authorities. </q>',
		     '<q>The number you have called is unavailable. Asato Ma
                     Sat Gamayo.</q> ']
    }
    isKnown = true
    pcKnown = true
    caller = self
;

janitorTopic : Topic
    vocabWords = 'janitor/custodian/cleaning/cleaner/vern'
    answerCall() {}
    caller = vern
    isKnown = (gPlayerChar.knowsAbout(vern))
    pcKnown = (isKnown)
;
    

// These are the noises that make the ringing noises in the appropriate rooms.

officePhoneRingEvent : SoundEvent;

class OfficePhoneRingObserver : SoundObserver, SecretFixture
    notifySoundEvent(event, source, info) {

        if( source == officePhone && officePhoneRingEvent == event &&
           gActor.location == location)
            callWithSenseContext(self, sound, {: ring});
        
    }
    
    ring = "You hear a phone ringing somewhere. "
;

OfficePhoneRingObserver
    location = office
    ring = "The phone here rings insistently. "
;

OfficePhoneRingObserver
    location = backRoom
    ring = "You hear a phone ringing in the office to the east. "
;

OfficePhoneRingObserver
    location = foyer
    ring = "You can hear a phone ringing somewhere to the north. "
;

OfficePhoneRingObserver
    location = storageEast
    ring = "You can hear a phone ringing out near the back room. "
;

SenseConnector, Intangible
    connectorMaterial = paper
    locationList = [ office, backRoom, foyer, storageEast ] 
;



// The dialtone sound
officePhoneDialtoneSound : Noise
    location = office
    vocabWords = 'dial tone/dialtone/dial-tone'
    name = 'dial tone'
    isEmanating = nil
    isAmbient = ( !isPhoneClose() )
    isPhoneClose(){
	return officePhoneHandset.isIn(gPlayerChar);
    }
    displaySchedule = [1,nil]
    soundSize = ( isPhoneClose() ? medium : small)
    hereWithSource {
	if(!officePhone.isHandsetOnHook) {
	    if( isPhoneClose() )
		"The dial-tone drums into your ear. ";
	    else
		"The phone faintly stutters out its dial-tone. ";
	}
    }
;







handsetHeldPreCondition : PreCondition
    checkPreCondition(obj, allowImplicit) {

	/* check to see if the actor is holding the handset - if so, we're done */
	if (( officePhone.myHandset).isHeldBy(gActor))
	    return nil; 
  
	/* the actor isn't holding the handset, try a "take handset" command */ 
	if (allowImplicit && tryImplicitAction(Take, officePhone.myHandset)) { 
	    if (!(officePhone.myHandset).isHeldBy(gActor))
		exit; 
              
	    /* indicate that we executed an implicit command */ 
	    return true; 
	} 
          
	/* we can't take the handset implicitly - report the problem and exit */ 
	reportFailure('You don\'t have access to the phone. '); 
	exit; 
    } 
; 
