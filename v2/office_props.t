#include <convolution.h>


bulletsCollectiveGroup : CollectiveGroup
    
    vocabWords = '44 .44 magnum *bullets*shells*ammo'
    name = 'bullets'
    
    isPlural = true
    
    desc = "Judging by the length and caliber of these bullets, they come from
        some hand cannon, maybe a .44. Something that\'d blow your head clean
        off, probably. "
    
;

class Bullet : Thing
    vocabWords = '44 .44 magnum bullet/shell*bullets*ammo*shells'
    name = 'bullet'
    
    location = officeDesk.subContainer
    
    desc = "Judging by the length and caliber of this bullet, they come from
        some hand cannon, maybe a .44. Something that\'d blow your head clean
        off, probably. <.p>You notice that the end of the casing has been
        stamped with \"JUDG MENT\". "
    
    collectiveGroups = [bulletsCollectiveGroup]
    
    isEquivalent = true
;

Bullet;
Bullet;
Bullet;
Bullet;

officeDeskJunk : Decoration
    vocabWords = 'untidy scrap uninteresting strewn scattered mess spread pile
        admin administrative pieces
        papers/paper/mess/stuff/forms/memo/junk/memos/scrap'
    name = 'scattered administrative papers'
    desc = "As if they were trying to hide the desk underneath,
	    various administrative forms, memos, and other assorted
	    scraps of paper cover the desk in a haphazard way. "
    isMassNoun = true
    isPlural = true
    
    location = officeDesk.subSurface

    hideFromAll(action) { return true; }
    dobjFor(Take) {
	verify() {}
	check() {
	    reportFailure('From what you can see, the pieces of paper strewn
                across the desk are uninteresting and thus not worth
                taking. '); }
    }
    dobjFor(Search) {
	verify() {}
	check() {
	    if(vanGoghNote.moved) {
		reportFailure('You sift through the papers, but you don\'t find
                    anything else of interest. ');
		exit;
	    }
	}
	action() {
	    mainReport('You fish around the papers, trying to find anything
                interesting. Tucked under a thick wad of paper is a loose
                yellow memo written with a different handwriting than the rest
                of the administrivia. You tuck it away in your jacket for later
                reference. ');
	    vanGoghNote.moveInto(trenchcoat);
	}
    }
;

