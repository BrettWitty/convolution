#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// First infinite hallway

// Add in the physiological effects of this weirdness as an aftertraveller

// Do a thing where you try IN three times before getting a hit. This is achieved by a programmatic in = 

infiniteHallway1 : Room
    name = 'Infinite Hallway'
    destName = 'the infinite hallway'
    desc = "Your eyes report but your brain refuses to
	    comprehend---the hallway of doors in front of you
	    stretches off to infinity in both directions. The dark,
	    chalky teal-coloured marble floor travels unerringly
	    east-west, not a soul, shadow or speck of dust to
	    decorate it. An unending array of exactly duplicate
	    turquoise doors break up the white walls to either side
	    of you.<.p>Behind you, the hallway terminates with the
	    door that you previously came through. "
    in = infiniteHallwayToAmazon
    west = terminatingDoor
;

+infiniteHallwayToAmazon : Door, TravelMessage
    vocabWords = 'turquoise random door/doorway/in'
    name = 'door'
    desc = "UNIMPLEMENTED YET. "
    destination = amazonHut
;

+terminatingDoor : LockableWithKey, Door
    vocabWords = 'turquoise previous previously last entered door/doorway/west/w/back'
    name = 'previously entered door'
    disambigName = 'previously entered door'
    desc = "UNIMPLEMENTED YET. "
    keyList = []
    initiallyLocked = true
    initiallyOpen = nil
;

amazonHut : Room
    name = 'Hut'
    destName = 'a hut'
    desc = "UNIMPLEMENTED YET. "
;

smokyRoom : Room
    name = 'Smoky room'
    destName = 'a smoky room'
    desc = "UNIMPLEMENTED YET. "
;
