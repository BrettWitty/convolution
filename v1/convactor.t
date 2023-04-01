#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>
#include <convmain.h>

// Modified Actor
// For properName replacements
modify Actor
    nameIsKnown = nil
    makeProper() {
	if(properName != nil) {
	    name = properName;
	    cmdDict.addWord(self,properName,&noun);
	    isProperName = true;
	    nameIsKnown = true;
	}
//	return name;
    } 
;

class InsultTopic : MiscTopic
    includeInList = [&miscTopics]
    matchList = [insultTopicObj] 
; 

insultTopicObj : object;

/*modify DefaultCommandTopic
    handleTopic(fromActor, action) {
	actionPhrase = action.getInfPhrase;

	actionPhrase = actionPhrase.findReplace(' you ', ' me ', ReplaceAll);
	if(actionPhrase.endsWith(' you'))
	    actionPhrase = actionPhrase.findReplace(' you', ' me', ReplaceOnce,
						    actionPhrase.length-5);
	currentAction = action;
	inherited(fromActor, action);
    }
    actionPhrase = nil
    currentAction = nil 
;*/

// Actor insult code
modify Actor 
  dobjFor(Insult) {
      preCond = [canTalkToObj]
      verify() {
	  /* Don't demean yourself */
	  if (gActor == self)
	      illogical('You could insult yourself, but you\'re sure to come up with a clever response, or be humiliated. You\'d win, but also lose. It\'s best not to play at all. ');
      }

      action(){
	  /* note that the issuer is targeting us with conversation */
	  gActor.noteConversation(self);


	  /* let the state object handle it */
	  curState.handleConversation(gActor, insultTopicObj, insultConvType);
      }
  } 

  defaultInsultResponse(actor) { "\^<<theName>> ignores your clumsy insults. "; } 
;

insultConvType : ConvType
    unknownMsgType = 'No-one\'s listening. '
    topicListProp = &miscTopics
    defaultResponseProp = &defaultInsultResponse
    defaultResponse(db, other, topic)
    { db.defaultInsultResponse(other); } 
;

modify SuggestedTopic 
    timesToSuggest = (ofKind(EventList) ? eventList.length() : 1) 
; 


modify DefaultAskForTopic
    handleTopic(fromActor, topic) {
	/* note the invocation */
	noteInvocation(fromActor);

	/* set pronoun antecedents if possible */
	setTopicPronouns(fromActor, topic);

	obj = topic.getBestMatch;
	if(obj == nil)
	    inherited(fromActor, topic);
	else if(obj.ofKind(Thing))
	    handleThing(fromActor);
	else if(obj.ofKind(Topic))
	    topicMsg;
    }
    /* The object (if any) matched by this topic */
    obj = nil

    handleThing(fromActor) {
	if(obj.isIn(fromActor))
	    alreadyHaveMsg;
	else if(obj.isIn(getActor))
	    refuseMsg;
	else if(obj == getActor)
	    askForOtherMsg;
	else if(obj == fromActor) 
	    askForSelfMsg; 
	else if(getActor.canSee(obj)) 
	    pointOutMsg; 
	else 
	    dontHaveMsg;
    } 

    /* The message to display if the player character asks for something he already has.  
     If the player character is carrying the asked-for object in another container, 
     the NPC points this out. */
    alreadyHaveMsg = "<q>You already have <<obj.theName>>,</q>
		      <<getActor.theName>> points
		      out<<obj.isDirectlyIn(gActor) ? '.' : ', <q>'+
		      obj.itIsContraction + ' in that ' +
		      obj.location.name + ' you\'re carrying.</q>'>>
		      " 

    /* The message to display if the requested actor has the object asks for but declines  to hand it over */
    refuseMsg = "<q>No, I need <<obj.itObj>> myself.</q> <<getActor.itNom>> replies. "
    
    /* The message to display if neither the asker nor the askee has the object but the askee can see where it is */ 
    pointOutMsg = "<q>\^<<obj.itIsContraction>> just over there,</q>
		   <<getActor.itNom>> observes, pointing at
		   <<obj.location.ofKind(Room) ? 'the ground' :
		   obj.location.theName>>. "
    
    /* The message to display if neither the asker nor the askee has the object and the askee can't see it */ 
    dontHaveMsg = "<q>I'm afraid I don't have <<obj.itObj>>,</q>
		   <<getActor.itNom>> tells you. " 

    /* The message to display if the player asks for the NPC */
    askForOtherMsg = "<q>That's me - here I am.</q> <<getActor.itNom>> tells you. "
   
    /* The message to display if the player asks for himself/herself */ 
    askForSelfMsg = "<q>You\'re right there,</q> <<getActor.itNom>> point{s} out. " 
   
    /* By default we use the standard handling for a defined topic, but this can be overridden if desired. */ 
    topicMsg() {
	if(ofKind(Script)) doScript;
	else topicResponse;
    }  
; 
