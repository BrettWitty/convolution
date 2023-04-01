#include <convolution.h>

trenchcoat : Wearable, Container, BagOfHolding
    vocabWords = 'leather trench coat/jacket/trenchcoat/clothes*clothes'
    name = 'trench coat'
    
    initDesc = "The trench coat lies folded on the crate. Hey! That\'s your
        trench coat! What\'s it doing here?"
    desc = "You forget when and where you bought this fine leather trenchcoat,
        but you know it\'ll be tough to replace it. The leather is thin and
        buttery, but it\'s damn durable. The workmanship is old-school -- tough
        and reliable -- but it somehow remains permanently stylish.
        Nevertheless, it wasn\'t the style you bought it for, but the pockets.
        Every so often you surprise yourself by finding a new pocket or one
        that you\'d forgotten about. In short, you want to be buried in this
        wondrous coat. "
    
    smellDesc = "Your trench coat has a rich, buttery smell with a slight
        undertone of sweat. "
    feelDesc = "The leather is soft and thin. This is high-quality stuff with
        trustworthy old-school workmanship. "
    
    location = warehouseCrate
    owner = pc
    
    bulk = 5
    weight = 0
    bulkCapacity = 1000
    maxSingleBulk = 30

    specialDescOrder = 10
    
    contentsListed = isWorn()
    
    affinityFor(obj)
    {
        if( obj == self )
            return 0;
        
        if( isWornBy(pc) )
            return 100;
        else
            return 0;
        
    }
    
    dobjFor(LookIn) remapTo(LookIn,trenchCoatPockets)
    dobjFor(Doff) {
	check() {
	    failCheck('It\'s much easier if you just wear the trenchcoat than
                carry it --- you also don\'t want to lose it. ');
	}
    }
;

+trenchCoatPockets : Component, Container 'pocket/pockets' 'trenchcoat pockets'
    "There are so many of these guys, it\'s a wonder you remember where you
    store things. "
    hideFromAll(action) { return true; }
    isPlural = true
    dobjFor(LookIn) remapTo(Inventory)
    iobjFor(PutIn) remapTo(PutIn, DirectObject, trenchcoat)
    iobjFor(Take) remapTo(Take, DirectObject, trenchcoat)
    iobjFor(TakeFrom) remapTo(TakeFrom, DirectObject, trenchcoat)
;