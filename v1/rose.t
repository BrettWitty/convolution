#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// Character notes
// - Has a big, gummy smile
// - Very gentle, kind lady
// - Always has a nice word for everything, even if she really thinks otherwise
// - Sometimes pretends not to hear something if she'd rather not deal with it.
// - Loves "Time After Time", but mostly because the TV is broken and
// Charlie hasn't gotten anyone over to fix it.




rose : Person 'old gentle nice little lady/woman/wife/spouse' 'little old lady'
    location = oldFolksLoungeChair
    desc = "UNIMPLEMENTED YET. "
    // To allow "Rose's husband"
    owner = charlie
    isHer = true
    properName = 'Rose'
    posture = sitting
    nameIsKnown = nil
    globalParamName = 'rose'
    seenProp = &roseSeen
    knownProp = &roseKnown
    charlieKnown = true
    roseKnown = true
;

+roseApartmentTopic : Topic 'her rose\'s apartment/home/house/place/abode/unit';

+roseSittingInChair : ConversationReadyState
    specialDesc {
	if(!nameIsKnown)
	    "Directly opposite the TV a little old lady has settled
	     into an equally old armchair. <<gSetKnown(charlie)>>";
	else
	    "Rose is perched in her armchair, watching TV. ";
    }
    stateDesc = "{rose/she} is currently watching TV. "
    isInitState = true
    inConvState = roseChattingInChair
;

+roseChattingInChair : InConversationState
    stateDesc = "{Rose/she} is looking absently in your direction. A
		 gentle, wrinkled smile is fixed to her face. "
    specialDesc = "{Rose/she} stares at you, gently smiling. "
;

// Tell her about meeting Charlie
+TellTopic @charlie
    "<q>So,</q> you remark. <q>I met your husband. Not a
     particularly happy guy, is he?</q><.p> {The rose/she} stares at
     you for a little while and smiles. <q>Charlie<<charlie.makeProper>> is
     a good husband. Always has.</q>"
    isActive = (gActor.hasSeen(charlie))
;

// Ask her about Charlie
+AskTopic, SuggestedAskTopic @charlie
    "<q>So where is your husband?</q> you ask tentatively.<.p>
     <q>Oh, he\'s in the bedroom, I think,</q> she replies, nodding
     eastwards. "
    name = 'her husband'
    isActive = (!gActor.hasSeen(charlie))
;

++AltTopic
    "<q>So, what\'s your husband like?</q> you ask.<.p> {The
     rose/she} rubs her chin with a finger and says, <q>He loves
     collecting things from the war. He never got to go, you know,
     but he likes learning about it anyway.</q><.p> You try to
     clarify your question but her warm, absent eyes deter you. "
    name = 'her husband'
    isActive = (gActor.hasSeen(charlie))
;

// Ask her about Cody
+AskTopic @cody
    "UNIMPLEMENTED YET. "
;

// Ask her about her neighbours
+AskTopic, SuggestedAskTopic @neighboursTopic
    "UNIMPLEMENTED YET. "
    name = 'her neighbours'
;

// Ask her about the residents
+AskTopic, SuggestedAskTopic @residentsTopic
    "UNIMPLEMENTED YET. "
    name = 'the residents'
;

// Ask her about the building
+AskTopic, SuggestedAskTopic @buildingTopic
    "UNIMPLEMENTED YET. "
    name = 'the building'
;

// Ask her about her apartment
+AskTopic, SuggestedAskTopic, StopEventList @roseApartmentTopic
    ['<q>What do you think about your apartment?</q> you
      ask.<.p>{The rose/she} scrunches her face a few times and
      says, <q>Oh, it\'s nice. Very quiet and Charlie can take care
      of me. We\'re saving up for a nice place at Circular Quay.</q>
      She leans towards you and whispers, <q>It\'s what all my
      friends talk about.</q> ',
     '<q>So you like this place?</q> <.p> Rose smiles and says,
      <q>Oh my, yes!</q> but something in her eyes seem to indicate
      otherwise. ']
    name = 'her apartment'
;

// Ask her about death
+AskTopic, StopEventList @deathTopic
    ['You shuffle your feet and ask, <q>Do you have any thoughts on... well... death?</q><.p>{The rose/she} smiles at you, seemingly ignoring you, although you notice a slight quiver in her lips. You swallow hard. ',
     '<q>Er, so I was thinking about death...</q> you start. {The rose\'s/her} face tightens and she focusses intently on the TV. ',
     'You try to ask her about death again, but she can already sense your apprehension, and thus the question. You don\'t think you\'ll get through to her. ']
;

// Default Ask
+DefaultAskTopic, ShuffledEventList
    [{:"You try to ask her what she knows about <<gTopic.getTopicText>> She simply responds with a soft smile below blankly staring eyes. "},
     {:"Drawing her attention from the TV, you ask her whether she knows about <<gTopic.getTopicText>> <q>Oh my word, yes,</q> she replies with a smile before her gaze slowly drifts back towards the TV. Rather convenient senility, you think. "},
     {:"You try to bring up the subject of <<gTopic.getTopicText>>. She just tilts her head to one side and mumbles, <q>That\'s nice dear.</q>"} ]
;
