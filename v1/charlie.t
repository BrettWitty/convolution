#charset "us-ascii"
#include "adv3.h"
#include "en_us.h"

charlie : Person 'old cranky angry recalcitrant man/fellow/bloke/guy/husband' 'old guy'
    location = oldFolksBedroom
    desc = "UNIMPLEMENTED YET. "
    // To allow "Rose's husband"
    owner = rose
    isHim = true
    properName = 'Charlie'
    nameIsKnown = nil
    globalParamName = 'charlie'
    seenProp = &charlieSeen
    knownProp = &charlieKnown
    roseKnown = true
    charlieKnown = true
    codyKnown = true
;
