#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

vern : Person
    vocabWords = 'cleaner/janitor/caretaker'
    name = 'the janitor'
    properName = 'Vern'
    isProperName = true
    nameIsKnown = nil
    desc = "{The janitor/he} is your typical hard-working,
	    underpaid, underappreciated custodian. He has a big
	    bushy moustache that gives him an air of seriousness, or
	    more likely, it muffles his occasional muttered curses.
	    He wears a wearied set of (once) blue overalls
	    discoloured with hundreds of exotic stains - the product
	    of years of custodial service. Across the chest pocket
	    you see the name <q>Vern</q> smudged over with grease.
	    <<makeProper>> "
    location = lunchRoomChair
    posture = sitting
    isHim = true
    globalParamName = 'janitor'

    isDoingJob = (vernCleanPlantAgenda.isReady || vernFixBoilerAgenda.isReady)
    
    cleanPlant() {
	vernCleanPlantAgenda.isReady = true;
	vern.addToAgenda(vernCleanPlantAgenda);
    }
    fixBoiler() {
	vernFixBoilerAgenda.isReady = true;
	vern.addToAgenda(vernFixBoilerAgenda);
    }
    beforeAction() {

	if( gActionIs(Feel) && gDobj == self ) {
	    "{The janitor/he} moves away from your wandering hands.
	     He eyes you warily. ";
	    exit;
	}

	if( gActionIs(Take) && gDobj == vernMobilePhone && vernMobilePhone.isIn(self) ) {
	    "{The janitor/he} covers his phone with his hand and
	     grunts, <q>No</q> at you. ";
	    exit;
	}
    }
;

+ AskTopic @me
    "<q>So,</q> you say, <q>What do you know about me?</q><.p> {The
     janitor/he} looks at you querulously. When you press him for an
     answer, he shrugs. "
;

+ TellTopic @me
    "You try to tell {the janitor/him} about yourself (well, as much
     as you know). Almost immediately he begins gazing absently at
     the walls, barely putting in an effort to even pretend that he
     is listening. You frown and stop midsentence. "
;

+ AskTopic, SuggestedAskTopic @vern
    name = 'himself'
    topicResponse = "<q>So tell me about yourself,</q> you
		     remark.<.p> {The janitor/he} shifts his weight
		     nervously. He mumbles something that sounds
		     like, <q>I\'m Vern, the caretaker
		     here.</q><<vern.makeProper>>"
;

+ DefaultGiveTopic, ShuffledEventList
    [
     '{The janitor/he} peers at {the dobj/him} and mumbles, <q>No
      thanks.</q><.p>',
     '{The janitor/he} takes {the dobj/him}, gives it a brief
      inspection and hands it back to you, shrugging his
      shoulders.',
     '{The janitor/he} waves his hand at {the dobj/him}. He doesn\'t
      want {it/him}.'
     ]
;

+ DefaultShowTopic, ShuffledEventList
    [
     '{The janitor/he} looks briefly at {the dobj/him} and then back
      at you, as if to ask, <q>So?</q>',
     '{The janitor/he} suddenly explodes in a bout of coughing. Over
      the barks and his dirty hand muffling them, he peers at {the
      dobj/him}. After a short while, he stops and wipes his eyes,
      and waves away {the dobj/him}. You don\'t think he
      <i>really</i> looked at it, but you feel reluctant to bug him
      about it again after that worrying coughing fit. ',
     'After a cursory glance, {the janitor/he} shrugs at you. '
     ]
;

// Vern "doing nothing" states. Has some custom hellos.

+ vernTalkingIdleState: InConversationState
    stateDesc = "{The janitor/he} is listening to you. "
    specialDesc = "{The janitor/he} is standing around, looking at you morosely. "
;

++ vernIdleState : ConversationReadyState
    stateDesc = "{The janitor/he} is standing off to the side, momentarily idle and quiet. "
    specialDesc = "{The janitor/he} is standing off to one side, momentarily idle and quiet "
;

+++ HelloTopic, StopEventList
    [
     'You peer at the janitor and mumble, <q>Um... Excuse me.</q><.p> He looks up at you
     with sighing eyes, wearily awaiting for you to continue interrupting his
     work. You gulp and introduce yourself, offering your hand. He looks down
     at your hand and then slowly matches your gaze. In his eyes you don\'t
     see arrogance, but years of being ignored whilst tirelessly cleaning and
     repairing for the endless parade of residents of this place. You take
     your hand back and shuffle your feet nervously. ',
     vern.nameIsKnown ? '<q>Hey Vern!</q> you say, waving at him.' : '<q>Hi!</q> you say to the
     janitor. ' + '{The janitor/he} nods at you. You catch a whisper of a
     smile underneath his bushy moustache and you grin to yourself. ' ] ;

+++ ByeTopic
    "<q>Well, I\'ll be seeing you,</q> you say cheerfully.<.p> {The
     janitor/he} gives an abrupt nod goodbye and returns to his
     work. "
;

+++ ImpByeTopic
    "{The janitor/he} sighs in your general direction and returns to
     work. "
;



//
// The lobby phone connection convnode
+ConvNode 'vernTakingEmergencyCall'
    npcGreetingMsg = "You dial the number and wait. A short while
		      later a gruff voice answers. <q>Yeah?</q> "
    noteLeaving() {
	lobbyPhone.disconnectCall();
	endConversation(vern,endConvBye);
    }
;

++TellTopic, SuggestedTellTopic @lobbyFern
    "<q>Yeah, hi,</q> you say. <q>Um, I need the janitor to come
     downstairs.</q><.p> The voice at the other end mumbles
     something that sounds like: <q>What for?</q><.p>You look around
     nervously and notice the fern you pushed over. <q>Erm, I
     accidentally knocked over the fern in the lobby. Seriously, it
     was an accident. Can you please send someone down to clean it
     up?</q><.p>The person at the other end of the line grumbles
     affirmatively and hangs up.
     <<endConversation(vern,endConvBye)>> <<vern.cleanPlant()>> "
    name = 'the knocked-over fern'
    isActive = (lobbyFern.hasFallenOver)
;

+++AltTopic
    "<q>Hi, is that the janitor?</q> you ask.<.p>The voice at the
     other end mumbles affirmatively.<.p><q>Well, um... The fern
     needs... um... watering or something...</q><.p>There is a long
     pause followed by a sigh, and then a dial tone.
     <<lobbyPhone.hangUp()>> <<endConversation(vern,endConvBye)>> "
    isActive = (!lobbyFern.hasFallenOver)
;

++TellTopic, SuggestedTellTopic @boiler
    "<q>Hi, I was just in the basement and the boiler was going
     crazy! It\'s spitting out steam everywhere! You\'ve gotta
     help!</q> you cry into the phone.<.p>The voice at the other end
     of the line sighs and grumbles affirmatively.
     <<endConversation(vern,endConvBye)>>"
    name = 'the broken boiler'
    isActive = (boiler.isBroken)
;

+++AltTopic
    "You try your best to sound concerned. <q>Hey, erm, the boiler
     was making weird noises. You should, erm, check it out.</q>
     <.p>After a long pause, the person at the other end huffs at
     you and hangs up. You don\'t think he bought it. "
    isActive = (!boiler.isBroken)
;

++DefaultAskTopic, ShuffledEventList
    ['You try to ask them about ' + gTopic.getTopicText + ' but you just can\'t make it sound believable. They hang up on you. ',
     '<q>Er, hi... Um... Can you, um...</q> you stammer, trying to
      gain composure.<.p>The voice on the other end sighs and hangs
      up. ',
     '<q>So, well... erm, I was wondering if...</q> you begin. The person at
      the other end grunts impatiently and hangs up. ']
    scriptDone() {
	inherited();
	endConversation(vern,endConvBye);
    }
;

++DefaultTellTopic, ShuffledEventList
    ['You begin to tell the other person about ' + gTopic.getTopicText + ' but they just grumble impatiently and hang up on you. ',
     'You try telling the other person all about ' + gTopic.getTopicText + ' but they just interrupt with a mumbled, <q>Do you need me?</q>.<.p>You say, <q>Well...</q> and end up listening to a dial tone. ']
     scriptDone() {
	inherited();
	endConversation(vern,endConvBye);
    }
;

//
// Vern goes to work
+vernCleanPlantAgenda : AgendaItem, ExternalEventList
    isReady = nil
    agendaOrder = 10
    initiallyActive = nil
    invokeItem {
	doScript;
    }
    eventList = [&getMoving, &doTravel, &grumble, &cleanPlant, &advanceState, &goHome]
    getMoving() {
	"{The janitor/he} grumbles, packs up his tools and begins to move out the door. ";
	vern.setCurState(vernMovingState);
	if(vern.isIn(lunchRoomChair))
	    nestedActorAction(vern,GetOutOf,lunchRoomChair);
	advanceState();
    }
    doTravel() {

	local destlist = [lunchRoom, firstHallway1, firstStairwell, groundStairwell, groundHallway, lobby, nil];

	local x = destlist.indexOf(vern.location);

	// If something's wrong, we'll just teleport
	if(x == nil)
	    vern.moveIntoForTravel(lobby);
	else {
	    // Move to the next point in the chain
	    if(destlist[x+1])
		vern.scriptedTravelTo(destlist[x+1]);
	    else
		// We're there so cue the next stuff.
		advanceState();
	}
	
    }
    grumble() {

	vern.setCurState(vernCleaningUpPlantState);
	"{The janitor/he} produces a dustpan and brush and kneels
	 down next to the fallen plant. He mutters something but
	 it\'s muffled by his bushy moustache. You guess it wasn\'t
	 anything happy. ";
	vern.makePosture(kneeling);
	advanceState();

    }
    cleanPlant() {

	local myState = vern.curState;

	// Assume we are in the right state and check our cleanCounter
	myState.cleanCounter++;

	// If it's all clean, then pack up and go home
	if(myState.cleanCounter >= myState.cleanCounterMax) {

	    "{The janitor/he} finally lifts the tree back on its
	     base and tips the last handful of potting mixture back
	     into the pot. ";

	    // Set the lobby fern to fixed
	    lobbyFern.hasFallenOver = nil;

	    // Stand back up
	    vern.makePosture(standing);

	    // Be idle for a little while
	    vern.setCurState(vernIdleState);
	    advanceState();

	}

    }

    goHome() {

	// Set the "go home" agenda and finish up this agenda.
	"{The janitor/he} brushes himself off, reattaches his dustpan to his belt and pauses for a second. ";
	vern.addToAgenda(vernGoToLunchRoom);
	isDone = true;
	isReady = nil;

    }
	
;

// Vern fixes the boiler
+vernFixBoilerAgenda : AgendaItem, ExternalEventList
    isReady = nil
    agendaOrder = 10
    initiallyActive = nil
    invokeItem {
	doScript;
    }
    eventList = [&getMoving,&doTravel,&grumble,&fixBoiler,&advanceState,&goHome]
    
    getMoving() {
	"{The janitor/he} grumbles, packs up his tools and begins to
	 move out the door. ";
	vern.setCurState(vernMovingState);
	if(vern.isIn(lunchRoomChair))
	    nestedActorAction(vern,GetOutOf,lunchRoomChair);
	advanceState();
    }
    
    doTravel() {

	local destlist = [lunchRoom, firstHallway1, firstStairwell, groundStairwell, groundHallway, lobby, reception, backRoom, mainBasement, boilerRoom,nil];

	local x = destlist.indexOf(vern.location);

	// If something's wrong, we'll just teleport
	if(x == nil)
	    vern.moveIntoForTravel(boilerRoom);
	else {
	    // Move to the next point in the chain
	    if(destlist[x+1])
		vern.scriptedTravelTo(destlist[x+1]);
	    else
		// We're there so cue the next stuff.
		advanceState();
	}
	
    }
    
    grumble() {
	"{The janitor/he} stands on his back foot and looks at the
	 broken pipes, stroking his chin. He pulls his wrench out of
	 his utility belt and plunges into the steam. ";
	vern.setCurState(vernFixingBoilerState);
	advanceState();
    }
    fixBoiler() {

	local myState = vern.curState;

	// Assume we are in the right state and check our fixCounter
	myState.fixCounter++;

	// If it's all clean, then pack up and go home
	if(myState.fixCounter >= myState.fixCounterMax) {

	    "{The janitor/he} pops the pipe back into place and
	     tightens the nut around the end. The steam dissipates
	     and {the janitor/he} begins to pack up his tools. ";

	    // Set the lobby fern to fixed
	    boilerBrokenPipe.fixUp();

	    // Be idle for a little while
	    vern.setCurState(vernIdleState);
	    advanceState();

	}

    }

    goHome() {

	// Set the "go home" agenda and finish up this agenda.
	"{The janitor/he} brushes himself off, looks back over his handiwork and begins to leave. ";
	vernGoToLunchRoom.isReady = true;
	vern.addToAgenda(vernGoToLunchRoom);
	vern.setCurState(vernMovingState);
	isDone = true;
	isReady = nil;

    }
;

+vernGoToLunchRoom : AgendaItem
    isReady = nil
    agendaOrder = 10
    initiallyActive = nil
    invokeItem {

	// This could be done via path-finding, but Vern is fairly limited, so we stick with this method.

	local destlist = [boilerRoom, mainBasement, backRoom, reception, lobby, groundHallway, groundStairwell, firstStairwell, firstHallway1, lunchRoom, nil];

	local x = destlist.indexOf(vern.location);

	// If something's wrong, we'll just teleport
	if(x == nil)
	    vern.moveIntoForTravel(lunchRoom);
	else {
	    // Move to the next point in the chain
	    if(destlist[x+1])
		vern.scriptedTravelTo(destlist[x+1]);
	    else {
		// We're back in the lunch room, so get situated and finish up
		if(gPlayerChar.canSee(vern))
		    "{The janitor/he} slides back wearily  into his chair. ";
		nestedActorAction(vern,SitOn,lunchRoomChair);
	    }
	}
    }
;

+vernCleaningUpPlantState : HermitActorState
    specialDesc = "{The janitor/he} is kneeling next to the tipped
		   plant, sweeping potting mixture back into the pot. "
    noResponse() {
	responseList.doScript();
    }
    responseList : ShuffledEventList {
	['{The janitor/he} blatantly ignores you, preferring to continue sweeping up the mess you made. ',
	 'Every time you try to interrupt him, he just sweeps more briskly, drowning out your voice. ',
	 'You try to get his attention, but he just grunts impatiently, ignoring you. ']
    }

    // Our little counter for how long we've been cleaning
    cleanCounter = 0
    cleanCounterMax = 3

    deactivateState(actor, newState) {

	inherited(actor,newState);

	// Regardless of what we are moving to, reset the clean counter
	// This is okay wrt conversations as we are in a hermit state
	cleanCounter = 0;

    }
;

+vernFixingBoilerState : HermitActorState
    specialDesc = "Somewhere amongst the thick steam {the
		   janitor/he} is fixing the broken pipe. "
    noResponse = "You can\'t see {the janitor/he} through the steam,
		  but you think he\'s ignoring you anyway. "

    // Our little counter for how long we've been cleaning
    fixCounter = 0
    fixCounterMax = 4

    deactivateState(actor, newState) {

	inherited(actor,newState);

	// Regardless of what we are moving to, reset the clean counter
	// This is okay wrt conversations as we are in a hermit state
	fixCounter = 0;

    }
;

// Vern is on the move, but is okay to stop and chat

+vernStopMovingToTalkState : InConversationState
    specialDesc = "{The janitor/he} stands before you, listening but
		   eager to continue onwards. "
    stateDesc = "He has stopped to chat with you, but by his little
		 shifts of weight you think he wants to get back to
		 work. "
;

++vernMovingState : ConversationReadyState
    specialDesc = "{The janitor/he} shuffles along, simultaneously
		   pushed along and burdened by his duties. "
    stateDesc = "He is shuffling towards some chore. His whole gait
		 says weariness though he moves forward dutifully. "
;

+++ HelloTopic
    "As {the janitor/he} passes by you, you stop him. <q>Er, hi. How
     are you going?</q><.p>{The janitor/he} coughs affirmatively and
     waits for you to keep talking. "
;

+++ ImpHelloTopic, StopEventList
    [
     'You step in front of {the janitor/he} and say, <q>Hi.</q> He stops and peers at you with tiny, tired eyes. ',
     vern.nameIsKnown ? '<q>Hey Vern!</q> you say, stopping him.' : '<q>Hi!</q> you say to the
     janitor. ' + 'He stops in his tracks and nods at you. You catch a whisper of a
     smile underneath his bushy moustache and you grin to yourself. ' ]
;

+++ ByeTopic
    "<q>Well, I\'ll let you keep going,</q> you say cheerfully.<.p> {The
     janitor/he} nods abruptly and continues on his way. "
;

+++ ImpByeTopic
    "{The janitor/he} sighs in your general direction and shuffles off. "
;



//
// Vern's amazing mobile phone
//
vernMobilePhone : Thing
    vocabWords = 'mobile cellular portable phone/mobile/telephone'
    name = 'mobile phone'
    desc = "Hanging from the janitor\'s belt is a trendy mobile phone. It
	    looks quite out-of-place amidst the grease stains and
	    hardware. "
    location = vern
    owner = vern
    hideFromAll(action) { return true; }
;


// The kneeling posture
kneeling : Posture
    msgVerbI = 'kneeling'
    msgVerbT = 'kneel{s}'
    participle = 'kneeling'
    tryMakingPosture(loc) { return tryImplicitAction(SitOn); }
    setActorToPosture(actor, loc) { nestedActorAction(actor, SitOn); }
;
