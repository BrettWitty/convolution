#charset "us-ascii"
#include "adv3.h"
#include "en_us.h"

// I've replaced attack with three verbs: attack, kick and punch. I want these to be fundamentally different commands.

replace VerbRule(Attack)
    ('attack' | 'kill' | 'hit') singleDobj
    : AttackAction
    verbPhrase = 'attack/attacking (whom)'
    askDobjResponseProd = singleNoun
;

replace VerbRule(AttackWith)
    ('attack' | 'kill' | 'hit' | 'strike')
        singleDobj
        'with' singleIobj
    : AttackWithAction
    verbPhrase = 'attack/attacking (whom) (with what)'
    askDobjResponseProd = singleNoun
    askIobjResponseProd = withSingleNoun
;

DefineTAction(Kick);

VerbRule(Kick)
    ('kick' | 'stomp' | 'boot') singleDobj
    : KickAction
    verbPhrase = 'kick/kicking (whom)'
    askDobjResponseProd = singleNoun
;

DefineTAction(Punch);

VerbRule(Punch)
    ('punch' | 'biff' | 'pound' | 'thump' | 'whack' | 'sock' ) singleDobj
    : PunchAction
    verbPhrase = 'punch/punching (whom)'
    askDobjResponseProd = singleNoun
;

// Kiss
// Added some extra synonyms.
// You can extend this to GIVE KISS TO blah but it requires extra trickiness
replace VerbRule(Kiss)
    ('kiss' | 'smooch' | 'snog' ) singleDobj
    : KissAction
    verbPhrase = 'kiss/kissing (whom)'
;

// Clear
// As in clearing a path, or sweeping mess off a desk.
DefineTAction(Clear);

VerbRule(Clear)
    ( ('clear' | 'sweep' | 'shift') | ('clear' | 'sweep' | 'move' | 'shift') 'away' ) singleDobj
    : ClearAction
    verbPhrase = 'clear/clearing (what)'
    askDobjResponseProd = singleNoun
;

// Fold
// Specifically for notes, fold them in half.
DefineTAction(Fold);

VerbRule(Fold)
  ( 'fold' | 'fold up' ) singleDobj
  : FoldAction
  verbPhrase = 'fold/folding (what)'
  askDobjResponseProd = singleNoun
;

// Unfold
// Specifically for notes, unfold them in half.
DefineTAction(Unfold);

VerbRule(Unfold)
  ( 'unfold' | ('open' | 'spread') 'out' ) singleDobj
  : UnfoldAction
  verbPhrase = 'unfold/unfolding (what)'
  askDobjResponseProd = singleNoun
;

// Crumple
// Specifically for notes, scrunch them into a ball.
DefineTAction(Crumple);

VerbRule(Crumple)
  ( 'crumple' | 'crush' | 'scrunch' | ('crumple' | 'scrunch' | 'screw') 'up' ) singleDobj
  : CrumpleAction
  verbPhrase = 'crumple/crumpling up (what)'
  askDobjResponseProd = singleNoun
;

// Flatten
// Flatten something. Intended for notes, but could be used elsewhere.
DefineTAction(Flatten);

VerbRule(Flatten)
  ( 'flatten' | 'smooth' | ('flatten' | 'smooth') 'out' ) singleDobj
  : FlattenAction
  verbPhrase = 'flatten/flattening (what)'
  askDobjResponseProd = singleNoun
;

// Tear
// Tear something up. Intended for notes, but could be used elsewhere.
DefineTAction(Tear);

VerbRule(Tear)
  ( 'tear' | 'rip' | 'shred' | ('tear' | 'rip') 'up' ) singleDobj
  : TearAction
  verbPhrase = 'tear/tearing (what)'
  askDobjResponseProd = singleNoun
;

// Knock On
// Mostly for doors. This is treated differently to the "tap" or "rap" verb because that is for windows.
DefineTAction(KnockOn);

VerbRule(KnockOn)
  'knock' 'on' singleDobj
  : KnockOnAction
  verbPhrase = 'knock/knocking (on what)'
  askDobjResponseProd = singleNoun
;

// Tap On
// Specifically designed for windows and the like. It works similarly to "knock" unless otherwise specified.
DefineTAction(TapOn);

VerbRule(TapOn)
  'tap' 'on' singleDobj
  : TapOnAction
  verbPhrase = 'tap/tapping (on what)'
  askDobjResponseProd = singleNoun
;

// Poke
// Yet another minimal-use verb. This one pokes stuff.
DefineTAction(Poke);

VerbRule(Poke)
  ('poke' | 'prod' | 'jab' | 'nudge') singleDobj
  : PokeAction
  verbPhrase = 'poke/poking (what)'
  askDobjResponseProd = singleNoun
;

// Fix/adjust/repair
DefineTAction(Fix);

VerbRule(Fix)
  ('fix' | 'repair' | 'adjust') singleDobj
  : FixAction
  verbPhrase = 'fix/fixing (what)'
  askDobjResponseProd = singleNoun
;

// Flush. Used almost exclusively for toilets.
DefineTAction(Flush);

VerbRule(Flush)
  ('flush' ) singleDobj
  : FlushAction
  verbPhrase = 'flush/flushing (what)'
  askDobjResponseProd = singleNoun
;

// Hang up. Used almost exclusively for telephones.
DefineTAction(HangUp);

VerbRule(HangUp)
  ('hang' 'up' | 'disconnect' | 'terminate' | 'hangup' ) singleDobj
  : HangUpAction
  verbPhrase = 'hang/hanging up (what)'
  askDobjResponseProd = singleNoun
;

// Answer phone
DefineTAction(Answer);

VerbRule(Answer)
    'answer' singleDobj
    : AnswerAction
    verbPhrase = 'answer/answering (what)'
    askDobjResponseProd = singleNoun
;

// Dial on a phone.
DefineTopicTAction(DialOn, DirectObject);

VerbRule(DialOn)
    ( 'dial' | 'call' | 'ring') ( 'up' |  ) singleTopic ('on' | 'with') singleDobj
    : DialOnAction
    verbPhrase = 'dial/dialling (what) (on what)'
    askDobjResponseProd = singleNoun
;

VerbRule(DialOnWhat)
    ( 'dial' | 'call' | 'ring' ) ( 'up' |  ) singleTopic
    : DialOnAction
    verbPhrase = 'dial/dialling (what) (on what)'
    construct()
    {
        dobjMatch = new EmptyNounPhraseProd();
        dobjMatch.responseProd = onSingleNoun;
    }
;


// Insult your favourite NPC
DefineTAction(Insult); 

VerbRule(Insult)
    ('insult' | 'abuse' | 'make' 'fun' 'of' | 'slander' | 'denigrate' | 'offend' | 'bad' 'mouth' | 'cast' 'aspersions' 'on' | 'malign') singleDobj
  : InsultAction
  verbPhrase = 'insult/insulting (whom)' 
; 

// Agree/disagree modification
modify VerbRule(Yes)
    'yes' | 'affirmative' | 'say' 'yes' | 'agree' | 'yep' | 'yup'
    :
;

modify VerbRule(No)
    'no' | 'negative' | 'say' 'no' | 'disagree' | 'negatory' | 'nope' | 'nah'
    :
;


// ThrowThrough, for really only a few special cases
DefineTIAction(ThrowThrough);

VerbRule(ThrowThrough)
    ('throw' | 'hurl' | 'chuck' | 'fling' | 'toss' ) singleDobj 'through' singleIobj
    : ThrowThroughAction
    verbPhrase = 'throw/throwing through (what)'
;

// Lower & Raise
// Specifically for ladders
DefineTAction(Lower);
DefineTAction(Raise);

VerbRule(Lower)
    ('lower' | ( 'move' | 'let') 'down') singleDobj
     : LowerAction
     verbPhrase = 'lower/lowering (what)'
;
VerbRule(Raise)
    ('raise' | 'lift' | ( 'raise' | 'move' | 'lift' | 'pull') 'up') singleDobj
    : RaiseAction
    verbPhrase = 'raise/raising (what)'
;

// Empty a container
DefineTAction(Empty);

VerbRule(Empty)
    ('empty') ('out' |) singleDobj
    : EmptyAction
    verbPhrase = 'empty/emptying (what)'
;

// Swipe a keycard
DefineTAction(Swipe);

VerbRule(Swipe)
    ('swipe' | 'scan' | 'wave') ('through' | 'over' |) singleDobj
    : SwipeAction
    verbPhrase = 'swipe/swiping (what)'
;

DefineTIAction(SwipeThrough);

VerbRule(SwipeThrough)
    ('swipe' | 'scan' | 'wave' | 'insert' | 'pass') singleDobj ('through' | 'in'
        | 'into' ) singleIobj
    : SwipeThroughAction
    verbPhrase = 'swipe/swiping (what) (through what)'
;

// The Unlock modification

modify VerbRule(Unlock)
    ('unlock' | 'pick') dobjList
    : 
;

modify VerbRule(UnlockWith)
    ('unlock' | 'pick') singleDobj 'with' singleIobj
    : 
;

modify VerbRule(Break)
    ('break' | 'ruin' | 'destroy' | 'wreck' | 'smash') dobjList
    : 
;

modify VerbRule(Clean)
    ('clean' | 'clean' 'up') dobjList
    : 
;

// Dry
// Mostly for the dryer
DefineTAction(Dry);
DefineTIAction(DryWith);

VerbRule(Dry)
    ('dry' | 'heat') singleDobj
    : DryAction
    verbPhrase = 'dry/drying (what)'
;

VerbRule(DryWith)
    ('dry' | 'heat') singleDobj 'with' singleIobj
    : DryWithAction
    verbPhrase = 'dry/drying (what) (with what)'
    askDobjResponseProd = singleNoun
    askIobjResponseProd = withSingleNoun
;



//
// Modify Thing to incorporate the new verbs
//

modify Thing
    dobjFor(Kick) {
	preCond = [touchObj, actorStanding]
	verify() { }
	action() { mainReport(&shouldntKickMsg); }
    }
    dobjFor(Punch) {
	preCond = [touchObj]
	verify() {}
	action() { mainReport(&shouldntPunchMsg); }
    }
    dobjFor(Clear) {
	preCond = [objVisible, touchObj]
	verify() { illogical(&cannotClearMsg); }
    }
    dobjFor(Fold) {
	preCond = [touchObj, objHeld]
	verify() { illogical(&cannotFoldMsg); }
    }
    dobjFor(Unfold) {
	preCond = [touchObj, objHeld]
	verify() { illogical(&cannotUnfoldMsg); }
    }
    dobjFor(Crumple) {
	preCond = [touchObj, objHeld]
	verify() { illogical(&cannotCrumpleMsg); }
    }
    dobjFor(Flatten) {
	preCond = [touchObj, objHeld]
	verify() { illogical(&cannotFlattenMsg); }
    }
    dobjFor(Tear) {
	preCond = [touchObj, objHeld]
	verify() { illogical(&cannotTearMsg); }
    }
    dobjFor(KnockOn) {
	preCond = [touchObj]
	verify() {}
	check() {}
	action() {
	    mainReport(&basicKnockResponse);
	}
    }

    /* By default, tap on is the same as knock on. */
    dobjFor(TapOn) remapTo(KnockOn,self)

    dobjFor(Poke) {
	preCond = [touchObj]
	verify() {}
	check() {}
	action() {
	    mainReport(&basicPokeResponse);
	}
    }

    dobjFor(Fix) {
        preCond = [touchObj]
	verify() { illogicalNow(&cannotFixMsg); }
	check() {}
	action() {}
    }
    dobjFor(Flush) {
        preCond = [touchObj]
	verify() { illogicalNow(&cannotFlushMsg); }
	check() {}
	action() {}
    }

    dobjFor(Insult) {
	verify() { illogical(&cannotInsultMsg); }
    }

    // Much the same as the library's ThrowAt
    dobjFor(ThrowThrough) asDobjFor(ThrowAt)
    iobjFor(ThrowThrough) asIobjFor(ThrowAt)

    dobjFor(Lower) {
	preCond = [touchObj]
	verify() { illogical(&cannotLowerMsg); }
	check() {}
	action() {}
    }

    dobjFor(Raise) {
	preCond = [touchObj]
	verify() { illogical(&cannotRaiseMsg); }
	check() {}
	action() {}
    }

    dobjFor(Empty) {
	preCond = [touchObj]
	verify() { illogical(&cannotEmptyMsg); }
	check() {}
	action() {}
    }
    
    dobjFor(Swipe) {
        preCond = [objHeld]
        verify() { illogical(&cannotSwipeMsg); }
        check() {}
        action() {}
    }
    
    dobjFor(SwipeThrough) {
        preCond = [objHeld]
        verify() { illogical(&cannotSwipeThroughDobjMsg); }
        check() {}
        action() {}
    }
    
    iobjFor(SwipeThrough) {
        preCond = [touchObj]
        verify() { illogical(&cannotSwipeThroughIobjMsg); }
        check() {}
        action() {}
    }
    
    

    dobjFor(Dry) {
	preCond = [touchObj]
	verify() { illogicalNow(&cannotDryMsg); }
    }
    iobjFor(DryWith) {
	preCond = [objHeld]
	verify() { illogical(&cannotDryWithMsg); }
    }
;


// HANGUP HAS NO CUSTOM MESSAGES
modify playerActionMessages
    shouldntKickMsg = '{You/he} shouldn\'t kick {that dobj/him}. '
    shouldntPunchMsg = '{You/he} shouldn\'t punch {that dobj/him}. '
    cannotClearMsg = '{You/he} do{es}n\'t know how to clear {that dobj/him} away. '
    cannotFoldMsg = '{You/he} do{es}n\'t know how to fold {that dobj/him}. '
    cannotUnfoldMsg = '{You/he} do{es}n\'t know how to unfold {that dobj/him}. '
    cannotCrumpleMsg = '{You/he} do{es}n\'t know how to scrunch {that dobj/him} up. '
    cannotFlattenMsg = '{You/he} do{es}n\'t know how to flatten {that dobj/him}. '
    cannotTearMsg = '{You/he} do{es}n\'t know how to tear {that dobj/him}. '
    cannotFixMsg = '{You/he} do{es}n\'t know how to fix {that dobj/him}. '
    cannotFlushMsg = '{That dobj/he} {is} not something that can be flushed. '
    cannotInsultMsg = 'Insulting {that dobj/him} is a waste of time. '
    cannotLowerMsg = '{You/he} cannot lower {that dobj/him}. '
    cannotRaiseMsg = '{You/he} cannot raise {that dobj/him}. '
    cannotEmptyMsg = '{You/he} do{es}n\'t know how to empty {that dobj/him}. '
    cannotSwipeMsg = '{You/he} do{es}n\'t know how to swipe {that dobj/him}. '
    cannotSwipeThroughDobjMsg = '{You/he} do{es}n\'t know how to swipe {that dobj/him}. '
    cannotSwipeThroughIobjMsg = '{You/he} do{es}n\'t know how to swipe
        something through {that iobj/him}. '
    cannotDryMsg = '{That dobj/him} do{es}n\'t need to be dried. '
    cannotDryWithMsg = '{The iobj/him} is no good to dry {the dobj/him}. '
    basicKnockResponse = '{You/he} knock{s} on {the dobj/him} to no real effect. '
    basicTapResponse = '{You/he} tap{s} on {the dobj/him}. '
    basicPokeResponse = '{You/he} poke{s} {the dobj/him} to no effect. '
;
