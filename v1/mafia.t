#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//------------------//
//  The mafia room  //
//------------------//

mafiaDoor : Door
    vocabWords = 'door/doorway/east/204'
    name = 'door to apartment 204'
    desc = "UNIMPLEMENTED YET. "
    location = secondHallway3
    initiallyOpen = nil
    noEntryMsg : ShuffledEventList {
	[ 'You jiggle the doorknob, but the door is locked. From
	   inside a cranky Brooklyn accent yells, <q>Hey,
	   scram!</q>',
	 'You try to open the door, but it is locked tight. Someone
	  inside yells, <q>Beat it! We\'re... busy!</q> Another deep
	  voice echoes him, <q>Yeah, we\'re busy! Scram!</q>',
	 'As you try to open the door, a rich Brooklyn voice
	  bellows, <q>Freakin\' hell! Don\'t make me come out
	  there an\' beat da crap outta ya!</q> ',
	 'The door won\'t budge. Inside two voices mumble back and
	  forth, ending with something that sounds like
	  <q>Forgeddaboudit...</q>',
	 'Just as you try the doorknob, you hear a loud
	  crash-and-tumble inside, followed by moans underneath
	  barked threats. You don\'t think they heard you, but you
	  can\'t get in. And with that commotion, you don\'t really
	  want to. ' ]
	 }
    noKnockMsg : ShuffledEventList {
	[ 'You knock sharply on the door. Someone exclaims from
	   inside, <q>There ain\'t nobody home! Capiche?</q> ',
	 'You rap on the door. A bear-like voice roars from inside:
	  <q>Beat it, ya jerks!</q> ',
	 'You tap politely on the door. Someone barks, <q>Beat it!
	  Can\'t you see we\'re busy?</q> You\'d think about
	  snappily replying that you can\'t see them at all, but for
	  some reason you think these aren\'t the folks you should
	  mess with. ',
	 'Just as you go to knock on the door, you hear a muffled
	  voice, pleading desperately and gasping loudly. There is a
	  sharp <i>crack!</i> and the sound of furniture clattering
	  on the floor. You carefully take back your hand --- you
	  don\'t want to get involved. ']
	 }
    listenMsg : ShuffledEventList {
	['UNIMPLEMENTED YET. ']
    }
    dobjFor(Open) {
	check() {

	    // The player is not allowed to go through this door
	    // but we will give responses from inside to liven things
	    // up.
	    noEntryMsg.doScript();
	    exit;
	}
    }
    dobjFor(KnockOn) {
	action() {

	    // Have some smart-alecky remark from the mafia goons inside
	    noKnockMsg.doScript();

	}
    }
    soundDesc { listenMsg.doScript(); }
;
