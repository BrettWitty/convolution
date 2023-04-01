#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//---------------//
//  Old Storage  //
//      South    //
//---------------//

oldStorageRoom : Room
    name = 'Old Storage Room'
    destName = 'old storage room'
    desc = "Murky light plays off the dusty surroundings,
	    overemphasising some areas and neglecting others. "
    out = oldStorageToAlleywayWindow
    in asExit(northeast)
    up asExit(out)
    northeast = oldStorageToBoilerDoor
    east : AskConnector {
	promptMessage = "There are two ways to the east. "
	travelAction = GoThroughAction
	travelObjs = [oldStorageToBoilerDoor, oldStorageToAlleywayWindow]
	travelObjsPhrase = 'of them'
	isConnectorListed = nil
    }
;

+oldStorageToBoilerDoor : Door ->boilerToOldStorageDoor
    vocabWords = 'east e boiler door/east/e'
    name = 'door'
    desc = "UNIMPLEMENTED YET. "
    inRoomDesc = "In the northeast corner you can make out a small, unassuming door. "
    inRoomDescOrder = 999
    sightPresence = true
    travelBarrier = oldStorageBarrier
    cupboardInWayMsg = 'The door bangs against something heavy and
			metallic on the other side. It prevents you
			from opening the door more than an inch or
			so. '
    dobjFor(Open) {
	check() {
	    if(!boilerRoomCupboard.isToppled) {
		reportFailure(cupboardInWayMsg);
		exit;
	    }
	}
    }
    dobjFor(Push) {
	verify() {}
	check() {
	    if(!boilerRoomCupboard.isToppled) {
		reportFailure(cupboardInWayMsg);
		exit;
	    }
	}
	action() {
	    replaceAction(Open,self);
	}
    }
;

++oldStorageBarrier : TravelBarrier
    canTravelerPass(traveler) { return boilerRoomCupboard.isToppled; }
    explainTravelBarrier(traveler) { "There seems to be something heavy blocking the other side of the door. "; }
;

+oldStorageToAlleywayWindow : Window, TravelMessage ->westernAlleywayWindows
    vocabWords = 'dirty grimy high window/windows/windowsill/sill/glass/out/up/u'
    name = 'grimy windows to the outside'
    desc {
	if (!isBroken) {
	    "High on the eastern wall are a set of <<isClean ?
	     'smudged' : 'dirty'>> windows. Bright light <<isClean ?
	     nil : 'filtered through the grime'>> streams through,
	     illuminating the room somewhat. ";
	    if(isClean)
	         "The world outside is blurry and still. ";
	}
	else {
	    if (isCleared)
		"High on the eastern wall, an open windowsill opens
		 up to the ground of what looks like an alleyway.
		 Pieces of broken glass lie scattered about the
		 window, but it is safe to pull yourself through. ";
	    else
		"The windows to the east are a jagged portal to an
		 alleyway outside. Shards of glass lie strewn about,
		 but the sill is still littered with sharp remnants.
		 You should clear it away before pulling yourself
		 through. ";
	}
    }//"
    cannotTravel() { reportFailure(cannotGoThatWayMsg); }
    cannotGoThatWayMsg = 'You\'re no David Copperfield --- you\'ll
			  need to break the glass to get through. '
    isClean = (otherSide.isClean)
    isOpen = (isBroken)
    isCleared = (otherSide.isCleared)
    isBroken = (otherSide.isBroken)
    travelDesc = "Careful of any stray shards, you pull yourself up
		  through the window into the alleyway outside. "
    breakMsg = 'First pulling your arm into your coat sleeves, you
		leap up and punch the window. As you land you
		quickly spin away, cowering from the cascade of
		broken glass. '
    makeBroken(state) {
	otherSide.makeBroken(state);
    }
    dobjFor(Kick) {
	verify() { illogical('The window is too high and you\'re no Bruce Lee. '); }
    }
    dobjFor(Attack) asDobjFor(Punch)
    dobjFor(Punch) asDobjFor(Break) //"
    dobjFor(Clean) {
	verify() {
	    if(!isBroken)
		illogical('The glass is clean on this side and most of the grime is on the outside. ');
	}
	action() {
	    replaceAction(Clear,self);
	}
    }
    dobjFor(TravelVia) {
	action() {
	    if(!isCleared)
		tryImplicitActionMsg(&announceImplicitAction,Clear,gDobj);
	    inherited();
	}
    }
    dobjFor(Clear) {
	verify() { logical; }
	check() {
	    if(!isBroken) {
		failCheck('{You/he} cannot clear away the windows when they are still in their frames. ');
	    }
	    if(isCleared) {
		failCheck('The broken glass has already been sufficiently cleared away. ');
	    }
	}
	action() {
	    mainReport('You fling a few large pieces of glass away
			and with your jacket sleeve, you clear a
			small, safe path through the window. ');
	    otherSide.isCleared = true;
	}
    }
;


+oldStorageStatueTable : Heavy, Surface
    vocabWords = 'old solid dusty bulky wooden table/surface'
    name = 'solid table'
    desc = "Way back in the old days, tables were flat surfaces with
	    legs. None of these fancy trims or decorations. This
	    solid, wooden relic is of this school. The most
	    decoration it has on it are bevelled edges and a thin
	    layer of dust. "
    inRoomDesc {
	if(statuetteCloth.isIn(self) && !statuette.discovered)
	    "Immediately under the beam of light is a wooden table,
	     covered in a peaked white sheet. ";
	else {
	    if(!statuette.moved)
		"The green hem of a statuette\'s gown is half
		 illuminated by the beam of light pooling on the
		 table\'s surface. ";
	    else
		"Immediately under the beam of light is a solid wooden table. ";
	}
    }
    inRoomDescOrder = 50
;

++statuette : Hidden, Thing
    vocabWords = 'beautiful small pale female porcelain galatea moulded statue/statuette/figure/figurine/sculpture/woman/lady/galatea'
    name = 'statuette'
    desc = "There is something unreal about the statuette. It is a
	    elegant woman about a foot and a half high. Pale hair
	    cascades over paler skin, washing into the back of her
	    emerald-green gown that drops from one shoulder to pool
	    around her feet in soft ripples. Her arms are held
	    demurely against her sides, her hands angled slightly
	    upwards in a suggestion of a model\'s pose. Her
	    smoky-grey eyes look away to the ground at her side,
	    more an attempt to avoid a gaze than to have one. When
	    it catches the light just right, the skin sparkles as if
	    the porcelain had been glazed with tiny crystals. "
    initDesc = "Halfway along the table, half-struck by a beam of
		sunlight stands a porcelain statuette. It faces away
		from you and all you can see is a rippled
		emerald-green gown falling from its thin waist,
		pooling around its feet. "
    initSpecialDesc {
	if(oldStorageToAlleywayWindow.isOpen)
	    "The beam of light blazes off the emerald-green gown of
	     a statuette on the table. Reflected light lightens the
	     rest of it, revealing a pale figure facing away from
	     you. ";
	else
	    "In the middle of the table stands a porcelain
	     statuette, its lower half gleaming in the faint
	     sunlight from the window. The upper half is cloaked in
	     shadows. ";
    }
    beenMoved = nil
    okayTakeMsg {
	if(beenMoved)
	    return '{You/he} take{s} a bit of care and gently
		    lift{s} {the dobj/her}. ';
	else {
	    beenMoved = true;
	    return 'After first blowing off a light layer of dust,
		    {you/he} carefully tilt{s} {the dobj/her} into
		    {your/his} other hand. It is a little bulky, but
		    {you/he} store{s} it away safely. ';
	}
    }
    okayPutOnMsg {
	return '{You/he} carefully place{s} {the dobj/her} onto ' + self.location.theName + '. ';
    }
    okayDropMsg = '{You/he} carefully place{s} {the dobj/her} on the ground. '
    shouldNotBreakMsg = '{You/he} cannot bring {yourself/himself} to
			 break this beautiful sculpture. '
    dobjFor(ThrowAt) {
	check() {
	    "You hold the statue back, ready to throw it. Out of the
	     corner of your eye, its sublime beauty strikes you
	     straight through the heart. You peer at it and sigh
	     resignedly, putting it away. ";
	    exit;
	}
    }
    dobjFor(TalkTo) {
	verify() {
	    logicalRank(70,'talkable');
	}
	check() {
	    "Although expertly crafted, the statuette isn\'t
	     well-made enough to converse with you. That would take
	     an artist of exquisite talent. ";
	    exit;
	}
    }
;

++statuetteCloth : Thing
    vocabWords = 'dusty old white off-white once-white cloth/blanket/sheet/covering'
    name = 'dusty white sheet'
    initSpecialDesc = "A dusty old sheet hangs over the table,
		       peaked high in the middle. "
    initDesc = "The dusty once-white sheet hangs off something tallish on the table. "
    desc = "The sheet is soft and discoloured with dust and age. "
    specialDesc = "An off-white sheet lies in a heap to the side. "
    dobjFor(Take) {
	action() {
	    if(!statuette.discovered) {
		statuette.discover();
		mainReport('You pull on the sheet and it slips
			    noiselessly over whatever it is
			    covering. With a little cough of dust,
			    it slides all the way off, revealing a
			    small porcelain statue. ');
		inherited();
	    }
	    else {
		mainReport('{You/he} gather{s} up the sheet and put{s} it away. ');
		inherited();
	    }
	}
    }
    dobjFor(LookUnder) {
	verify() {
	    logical;
	}
	action() {
	    if(!statuette.discovered) {
		statuette.discover();
		"You lift the edge of the sheet and peek under. Due
		 to the gloom you can\'t see much, so you whip off
		 the sheet and throw it aside. A previously-covered
		 statuette now stands in a
		 <<oldStorageToAlleywayWindow.isOpen ? 'dazzling' :
		 'gloomy'>> pool of light; everything above its
		 hips shrouded in shadow. ";
		moveInto(oldStorageRoom);
	    }
	    else
		inherited();
	}
    }
;

+oldStorageShelves : Heavy, Surface
    vocabWords = 'decrepit old timber dusty dry shelf/shelves/slats'
    name = 'shelves'
    desc = "Dry, dusty timber slats lie across the shelves\' frame.
	    The only decoration on the frame is a contoured top, now
	    cracked with age. The bottom slat has collapsed on one
	    end and all of its items squeeze on top of each other in
	    the corner. <<oldStorageShelvesBottomShelf.discover>> "
    inRoomDesc = "A distressed wooden cabinet and the wearied
		  remains of a set of shelves stand against the
		  south wall. "
    inRoomDescOrder = 100
    isPlural = true
;

++oldStorageShelvesBottomShelf : Component, Surface, Hidden
    vocabWords = 'bottom collapsed broken slat/shelf/surface'
    name = 'bottom slat'
    desc = "The bottom slat of the shelves has collapsed at one end,
	    wedging all its miscellaneous items into the corner. At
	    the higher end, the wood has splintered around the
	    sturdy nails holding the slat to the shelves. "
    cannotTakeComponentMsg = '{You/he} cannot take {the dobj/him};
			      it is firmly wedged in the shelves. '
;

+++Decoration
    vocabWords = 'some miscellaneous junk/stuff/things/items'
    name = 'miscellaneous junk on the bottom shelf'
    desc = "Boxes, random mechanical parts, empty bottles and other
	    assorted junk gathers in the collapsed corner of the
	    bottom shelf. Nothing seems to be of interest. "
;

+oldStorageCupboard : Heavy, OpenableContainer
    vocabWords = 'distressed old worn wooden cupboard/cubpoard/closet/wardrobe/cabinet/armoire'
    name = 'wooden cabinet'
    desc = "The once-lacquered surface of this cabinet is now
	    cracked and distressed with age. Given a decade or so
	    more, and the cabinet will collapse in on itself with a
	    crack and a sigh"
    openStatus { if(isOpen) ". The cabinet is currently open, the doors barely hanging by the hinges"; }
    hasBrokenHinge = nil
    okayOpenMsg {
	if(hasBrokenHinge)
	    return '{You/he} open{s} the cabinet doors. One of them hangs precariously by one hinge. ';
	else {
	    hasBrokenHinge = true;
	    return '{You/he} open{s} the stiff cabinet doors with a
		    jerk. To {your/his} shock, one of the doors
		    suddenly snaps off a hinge and hangs
		    precariously off the remaining one. ';
	}
    }
    okayCloseMsg = '{You/he} push{es} the cabinet doors closed,
		    resting the broken door against the edge of the
		    other. '
;
