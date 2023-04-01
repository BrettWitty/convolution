#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//-----------------------//
//  Miscellaneous stuff  //
//-----------------------//

// define the '+' property
// (we need this only once per source file)
+ property location;

stringLister : object 
  showList(lst) 
  { 
    local lstLen = lst.length; 
    for(local i=1; i<= lstLen; i++) 
    { 
      if(i not in (1, lstLen)) ","; 
      if(i == lstLen && lstLen > 1) " and"; 
      if(i>1) " "; 
      say(lst[i]);       
    } 
  } 
; 

objectLister : object
    showList(lst)
  { 
    local lstLen = lst.length; 
    for(local i=1; i<= lstLen; i++) 
    { 
      if(i not in (1, lstLen)) ","; 
      if(i == lstLen && lstLen > 1) " and"; 
      if(i>1) " "; 
      say(lst[i].listName);
    } 
  } 
;

knowJackAndJill() {
    local jjPlaces = [jjEntrance, jjBathroom, jjLounge, jjBedroom, jjKitchen];
    local jjThings = [jjFrontDoorToHallway];
    foreach(local x in jjPlaces) {
	x.name = x.jjName;
	x.destName = x.jjDestName;
    }
    foreach(local x in jjThings) {
	x.name = x.jjName;
    }
}

// Dangerous ledge stuff

catwalkFloor : defaultFloor
    vocabWords = 'down/d/ground/floor/mesh'
    name = 'mesh floor of the catwalk'
    desc = "You have some faith in the hardy metal mesh that keeps
	    you above the alleyway below. It\'s certainly seen some
	    weather, but is resilient nonetheless. "
;

upperBrickWallSouth : defaultSouthWall
    vocabWords = 'south southern s crumbling brick wall/south/s/rear'
    name = 'crumbling brick wall'
    desc = "The brick wall behind you is slightly rough but somewhat
	    brittle. You wouldn\'t want to lose your balance here
	    and grab the wall since you\'d only end up falling with
	    fistfuls of broken brick. "
;

upperBrickWallWest : defaultWestWall
    vocabWords = 'west western w crumbling brick wall/west/w/rear'
    name = 'crumbling brick wall'
    desc = "The brick wall behind you is slightly rough but somewhat
	    brittle. You wouldn\'t want to lose your balance here
	    and grab the wall as you\'d only end up falling with
	    fistfuls of broken brick. "
;

dangerousLedgeFloor : defaultFloor
    vocabWords = 'down d dangerous precarious ledge/sill'
    name = 'thin concrete ledge'
    desc = "They always make them like this: thin and smooth. There
	    always seems to be a few small chunks of broken brick
	    lying about, just to make your shuffle across the ledge
	    that much more nervous. The alleyway lies about a floor
	    below, but doesn\'t offer any suitable soft spots to
	    fall onto. "
;

// Stairwell stuff

stairwellFloor : defaultFloor
    vocabWords = 'concrete concrete/down/d/ground/floor'
    name = 'concrete floor'
    desc = "The ground is nicely smoothed concrete. Very professional once
	    laid, dangerous when wet. "
;

stairwellWalls : DefaultWall
    vocabWords = 'west w east e south s north n concrete wall/west/east/south/north/w/e/s/n*walls'
    name = 'stairwell walls'
    desc = "The walls here are made out of featureless, monotonous concrete. "
;

stairwellCeiling : defaultCeiling
    vocabWords = 'ceiling/roof'
    name = 'stairwell ceiling'
    desc = "The ceiling is plain and uninteresting, much like the rest of the stairwell. "
;

class StairwellRoom : Room
    roomParts = [stairwellFloor, stairwellWalls, stairwellCeiling]
;

// First floor hallway stuff

firstHallwayCarpet : defaultFloor
    vocabWords = 'carpet rust rusty rust-coloured coloured worn carpet/ground/floor'
    name = 'hallway carpeting'
    desc = "The light rust-coloured carpet here is of the tough,
	    compacted kind. It seems to be in good shape,
	    discounting the usual wear and tear due to traffic. "
;

firstHallwayWall : DefaultWall
    vocabWords = 'chalky grey gray wall'
    name = 'the wall'
    desc = "The hallway has been painted a pale, chalky grey. You
	    guess this wasn\'t a well-intentioned choice by the
	    architect, more a <Q>just the usual, thanks</Q>
	    decision. Periodically along the walls there are
	    circular lights that illuminate the hallway. Despite
	    being rather plain, the hallway is well-maintained, to
	    its credit. "
;

firstHallwayNorth : firstHallwayWall
    vocabWords = 'chalky grey gray north northern n north/n/wall'
    name = 'north wall'
;

firstHallwaySouth : firstHallwayWall
    vocabWords = 'chalky grey gray south southern s south/s/wall'
    name = 'south wall'
;

firstHallwayEast : firstHallwayWall
    vocabWords = 'chalky grey gray east eastern e east/e/wall'
    name = 'east wall'
;

firstHallwayWest : firstHallwayWall
    vocabWords = 'chalky grey gray west western w west/w/wall'
    name = 'west wall'
;

firstHallwayCeiling : defaultCeiling
    vocabWords = 'white ceiling/up/roof/u'
    name = 'ceiling'
    desc = "You stare at the ceiling for a while, trying to find
	    inspiration amongst the plain white paint. You find
	    nothing. "
;

class FirstHallwayRoom : Room
    name = 'First Floor Hallway'
    destName = 'the hallway'
    roomParts = [firstHallwayCarpet, firstHallwayCeiling]
;


// The Sky

theSky : defaultSky
    vocabWords = 'sky'
    name = 'the sky'
    desc = "Clouds lazily tumble over themselves as they cross the azure sky. "
    isQualifiedName = true
    kissMsgs : CyclicEventList { eventList =  ['Kiss which guy? ', 'From somewhere far away the wind carries along the electrifying sounds of Jimi Hendrix. '] }
    dobjFor(Kiss) {
	verify() {}
	action() {
	    say(kissMsgs.doScript());
	}
    }
;


// Alleyway stuff

class Alleyway : Room
    roomParts = [alleywayGround, theSky, alleywaySouthWall, alleywayNorthWall]
;

alleywayGround : defaultGround
    vocabWords = 'ground/floor/down/d'
    name = 'the ground'
    isQualifiedName = true
;

alleywaySlimyGround : alleywayGround
    vocabWords = 'slimy ground/floor/down/d'
    name = 'the slimy ground'
    desc {
	"The slime from the garbage has oozed its way across the alleyway and
	 trickled down a small drain. ";
	if (hasGoneEast) {
	    if(hasGoneWest) {
		"The slime has been muddled up with footprints going in all
		 directions. ";
	    }
	    else {
		"A set of footprints leading eastward have tracked through the
		 slime. ";
	    }
	}
	else {
	    if(hasGoneWest)
		"A set of footprints leading westward have tracked through the
		 slime. ";
	}
    }
    hasGoneEast = nil
    hasGoneWest = nil
    isQualifiedName = true
;

alleywaySouthWall : defaultSouthWall
;

alleywayNorthWall : defaultNorthWall
;

centralAlleywaySouthWall : defaultSouthWall
    desc = "The crumbling brick walls are coated with grime and
	    mould. Rust streaks down the wall from the joins of the
	    metal brackets holding the drains and fire escape up. A
	    few splashes of graffiti complete the wall\'s grotty
	    appearance. "
;

centralAlleywayNorthWall : defaultNorthWall
    desc = "The crumbling brick walls are coated with grime and
	    mould. Rust streaks down the wall from the joins of the
	    metal brackets holding the drains and fire escape up. A
	    few splashes of graffiti complete the wall\'s grotty
	    appearance. "
;


//--------------------//
//  Special grammar!  //
//--------------------//

class SpecialNounPhraseProd: NounPhraseWithVocab
    /* get the list of objects matching our special phrase */
    getMatchList = []

    /* resolve the objects */
    getVocabMatchList(resolver, results, flags)
    {
        /* return all of the in-scope matches */
        return getMatchList().subset({x: resolver.objInScope(x)})
            .mapAll({x: new ResolveInfo(x, flags)});
    }
;

grammar adjWord(chickenAndCorn) :
    'chicken' 'and' 'corn'
    : SpecialNounPhraseProd
    getMatchList = [chickenAndCornRamen]
    getAdjustedTokens =
      ['chicken', &adjective, 'and', &adjective, 'corn', &adjective]
;

grammar adjWord(prawnAndCorn) :
    'prawn' 'and' 'corn'
    : SpecialNounPhraseProd
    getMatchList = [prawnAndCornRamen]
    getAdjustedTokens =
      ['prawn', &adjective, 'and', &adjective, 'corn', &adjective]
;

grammar adjWord(prawnAndCorn2) :
    'shrimp' 'and' 'corn'
    : SpecialNounPhraseProd
    getMatchList = [prawnAndCornRamen]
    getAdjustedTokens =
      ['shrimp', &adjective, 'and', &adjective, 'corn', &adjective]
;

grammar nounPhrase(simulacraAndSimulation) :
    'simulacra' 'and' 'simulation'
    : SpecialNounPhraseProd
    getMatchList = [simulacraBook]
    getAdjustedTokens =
      ['simulacra', &noun, 'and', &adjective, 'simulation', &noun]
;

grammar nounPhrase(vanGogh) :
    'van' 'Gogh'
    : SpecialNounPhraseProd
    getMatchList = [receptionMessage]
    getAdjustedTokens =
      ['van', &adjective, 'Gogh', &adjective]
;

