#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// This gives all the details for the PC

me : Actor
    location = behindBunchOfBoxes
    //location = abandonedLounge
    desc {
	"You\'re decked out in your usual street clothes: hard leather boots, a
        worn pair of jeans, a t-shirt and your favourite soft leather
        trenchcoat. It\'s your attempt to present a dashing but casual handsome
        guy persona without getting too involved. It's timeless style. ";

	if( !doneLimbsCheck) {
	    if( hasHeadache )
		"<.p>All your appendages seem to be there and undamaged,
                although you have a killer headache. ";
	    else
		"<.p>All your appendages seem to be there and undamaged,
                thankfully. ";
	    doneLimbsCheck = true;
	}
	else {
	    if(hasHeadache)
		"<.p>You seem to be okay, save for the nail driven through your
                skull that is your headache. Aspirin would be awesome. ";
	}

    }
    seenProp = &pcSeen
    knownProp = &pcKnown
    bulkCapacity = 300
    weightCapacity = 300
    maxSingleBulk = 150
    maxSingleWeight = 150
    
    hasHeadache = true
    hasAspirin = (aspirinBottle.isIn(me) || aspirin.isIn(me))
    doneLimbsCheck = nil

    nothingInsideMsg = 'You\'ve tried telling the ladies that you are full of
        lovely, gooey goodness. Success rate: 0% '
    naughtyMsgs : ShuffledList {
		valueList = ['This is neither the time, nor the place. But then
                    again, with the right lighting and music... ',
                    'You decide not to, but nevertheless indulge yourself in a
                    wicked giggle. ',
                    'You\'ll go blind! And think of the children! Won\'t
                    someone <i>please</i> think of the children!',
                    'Exercise some self-control man!',
                    'You can go visit the Palmer sisters later --- when it\'s
                    more private. At the moment you have better (and more
                    important) things to do. ' ]
		suppressRepeats = true
    }
    naughtyOtherMsgs : ShuffledList {
	valueList = ['{The dobj/he} look{s} at you and slowly creeps away. ', '{The dobj/he} just stare{s} at you blankly. Perhaps you\'re a bit too forward. ', '{The dobj/he} laughs nervously and tries not to look you in the eye. ', '{The dobj/he} looks at you blankly, completing this perfectly embarrassing Kodak moment. ' ]
	suppressRepeats = true
    }

    // Special inventory addition to include the handset if you're carrying it.
    showInventoryWith(tall, inventoryLister) {
		inherited(tall, inventoryLister);
		if(hasHeadache)
		    "You currently have a monster headache. ";
		if(lobbyPhoneHandset.isIn(gPlayerChar))
			"You are currently holding the phone handset to your ear. ";
    }
    
    dobjFor(Search) {
		verify() {}
		action() { mainReport('Don\'t look at me, I\'m just a
                    parser. '); }
    }

    dobjFor(TurnOn) {
	preCond = []
	verify() {}
	action() {
	    say(gActor == self ? naughtyMsgs.getNextValue : naughtyOtherMsgs.getNextValue);
	}
    }

    dobjFor(Feel) asDobjFor(TurnOn)
; 
