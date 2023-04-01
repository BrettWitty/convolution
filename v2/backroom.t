#include <convolution.h>

/*
 *   Back room
 *
 *   This is a dense junction and is our first steps into Convolution Tower. 
 *   To the west is storage, the east an office, the south the foyer and the 
 *   north the alleyway.
 *
 *   There's a hidden note behind the shelf and some flavour objects.
 */

// TODO:
// Doors - North, south, east and west.

backRoom : Room
    roomName = 'Some back room'
    
    desc = "With the precarious pillars of boxes and discarded furniture
        scattered about the room, you guess this room is a temporary storage
        area for someone. Well, more aptly, it was probably used for storage
        one day but never relinquished of this task, and the clutter has built
        up over time. Strangely, no-one thought to put any of the boxes in the
        shelf that now stands empty against the east wall or moreover, behind
        the door marked <q>Storage</q> to the west. Laziness reigns supreme,
        you guess. <.p>In any case, there is a way out --- to a foyer to the
        south --- as well as an office door to the east and out to the alleyway. "
    
    west = storageEast
    east = office
    north = alleywayEast
    south = foyer
    
;

+Immovable
    vocabWords = 'hastily stacked hastily-stacked cardboard delivery pile
        pillar/boxes/box/pile/clutter'
    name = 'pile of boxes'
    desc = "The arrangement of these boxes is clearly the product of hastiness
        or laziness. Or both. Some boxes are stacked askew, arranging
        themselves according to gravity. Others seem to be stacked with good
        intention but poor execution - one box has its <q>This way up</q> arrow
        pointing directly down, a small box supports a larger and heavier
        one... You're sure that in the right gallery this would be an
        avante-garde centerpiece of great distinction. Lying in this back room
        they have been demoted to <q>clutter</q>. "
    hideFromAll(action) { return true; }
    cannotTakeImmovableMsg = 'The boxes that catch your eye do not keep your
        interest---you do not feel you need to take them. '
    cannotMoveImmovableMsg = 'Moving any of the boxes around would risk having
        them collapse and you have no pressing urge to be knee deep in boxes. '
    cannotPutImmovableMsg = (cannotMoveImmovableMsg)
;

+Immovable
    vocabWords = 'abandoned busted up busted-up broken bent crooked twisted chair/stool/seat/furniture'
    name = 'busted-up chair'
    desc = "Some things in this world sure get the rough end of the stick in
        terms of their existence: mayflies, dung beetles, New Coke(tm) and this
        chair. It began its life as one of those dime-a-dozen, plastic-backed,
        unergonomic chairs that they often use for school assemblies or town
        meetings. They are produced en masse with cheap (foreign) labour; they
        only require screwing two bent pieces of metal to the plastic seat.
        Unfortunately, their cheap manufacture seems to induce enraged people
        to hurl them at walls, lazy people to snap their backs via creative
        posturing and the morbidly obese to accidentally crush them. This
        specimen has had its seat warped and its legs bent and snapped off. It
        lies in a tangle heap of plastic and metal in one corner of the room,
        just near the entrance to the foyer. If it wasn't just a stupid chair,
        you might shed a tear for its beleaguered existence. "
    cannotTakeImmovableMsg = 'You think about taking this tangle of plastic and
        metal, but it doesn\'t serve its intended purpose --- you couldn\'t
        possibly sit on it --- nor does it lend itself to convenient carrying.
        You are sure your creativity stops well short of being able to make
        this busted-up chair useful. '
    cannotMoveImmovableMsg = (cannotTakeImmovableMsg)
    cannotPutImmovableMsg = (cannotTakeImmovableMsg)
    uselessToAttackMsg = 'The chair has taken enough abuse without you taking
        out your anger on it. '
    hideFromAll(action) { return true; }
    dobjFor(Throw) {
	preCond = []
	verify() { illogical('{The dobj/he} has taken enough punishment. Leave it be. '); }
    }
    dobjFor(ThrowAt) remapTo(Throw)
    dobjFor(SitOn) { verify() { illogical('The broken chair is beyond being
        able to accommodate you. '); } }
;

+Heavy
    vocabWords = 'abandoned furniture/shelves/shelf'
    name = 'abandoned bookcase'
    desc = "A broken bookcase has been pushed into a corner here,
	    near the door. The fallen shelves house only dust. "
    foundCard = nil
    hideFromAll(action) { return true; }
    dobjFor(LookBehind) {
	verify() {}
	check() {
	    if(foundCard) {
		"There is nothing else behind the shelf except for the wall. ";
		exit;
	    }
	}
	action() {
	    mainReport( 'You lean towards the shelf, carefully stepping over a
                box in the process. You pull the shelf back and suddenly a
                piece of card slides down the back, which you reflexively
                catch. The shelf claps back against the wall as you peer at the
                card. The card is a folded piece of packing cardboard, with
                some writing inside. You shrug and put it in your jacket. ');
	    backRoomCard.moveInto(trenchcoat);
	    foundCard = true;
	}
    }
    dobjFor(Pull) asDobjFor(LookBehind)
    dobjFor(Search) asDobjFor(LookBehind)
;
