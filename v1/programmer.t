#charset "us-ascii"
#include "adv3.h"
#include "en_us.h"

//----------------//
//  Programmer's  //
//      Room      //
//----------------//

class Ramen : CustomImmovable
    initializeThing() {

	inherited();

	foreach( local x in myFlavours) {
	    cmdDict.addWord(targetobj, x, &adjective);
	}

    }
    cannotTakeMsg = 'It would be downright rude to raid the guy\'s ramen stash. '
    vocabWords = 'instant microwave flavour flavor flavoured flavored ramen/flavour/flavor/noodles/packet*noodles*packets'
    myFlavours = []
    isMassNoun = true
    desc = "UNIMPLEMENTED YET."
    collectiveGroup = lotsaRamen
    owner = programmer
;

programmerLounge : Room
    name = 'Lounge'
    destName = 'the lounge'
    desc = "UNIMPLEMENTED YET. "
    west = programmerBedroom
    east = programmerKitchen
;

programmerKitchen : Room
    name = 'Kitchenette'
    destName = 'the kitchenette'
    desc = "UNIMPLEMENTED YET. "
    west = programmerLounge
;

+OpenableContainer
    vocabWords = 'food storage cupboard/pantry/storage/store'
    name = 'cupboard'
    desc = "To your amazement, this cupboard is completely full of
	    different varieties of ramen noodles. There is nothing
	    else inside but rows and rows of stacked instant
	    noodles. "
    lookInDesc = (desc)
;

++lotsaRamen : CollectiveGroup,SecretFixture
    vocabWords = 'instant microwave *ramen*noodles'
    desc = "The guy who lives here must subsist solely on this
	    stuff. There must be over twenty different varieties
	    here: original, chicken, beef, vegetable, roast pork,
	    spicy chicken, Mexican, prawn, chicken and corn, spicy
	    laksa, Italian, pizza, fish, cheese, English, barbeque,
	    tomato, prawn and corn, oyster, curry, honey sesame,
	    creamy chicken, miso tofu, teriyaki chicken, chicken
	    mushroom, jalape\u00f1o... Crazy."
    isCollectiveAction(action, whichObj) {
	if (action.ofKind(ExamineAction))
	    return true;
	else
	    return nil;
    }
;

++Ramen myFlavours = ['original', 'normal', 'plain'] name = 'original flavour ramen';

++Ramen myFlavours = ['chicken', 'chick', 'chook'] name = 'chicken-flavoured ramen';

++Ramen myFlavours = ['beef', 'beefy'] name = 'beef-flavoured ramen';

++Ramen myFlavours = ['vegetable', 'veg', 'vegie', 'vege']  name = 'vegetable-flavoured ramen';

++Ramen myFlavours = ['pork', 'roast']  name = 'roast pork-flavoured ramen';

++Ramen myFlavours = ['spicy', 'chicken', 'chick', 'chook'] name = 'spicy chicken-flavoured ramen';

++Ramen myFlavours = ['Mexican', 'mex', 'spicy']  name = 'Mexican ramen';

++Ramen myFlavours = ['prawn', 'shrimp']  name = 'prawn-flavoured ramen';

+chickenAndCornRamen : Ramen myFlavours = ['chicken and corn', 'chicken', 'corn', 'cc']  name = 'chicken and corn ramen';

++Ramen myFlavours = ['spicy', 'lahksa', 'laksa'] name = 'spicy laksa ramen';

++Ramen myFlavours = ['Italian', 'italy']  name = 'Italian ramen';

++Ramen myFlavours = ['pizza', 'piza']  name = 'pizza-flavoured ramen';

++Ramen myFlavours = ['fish', 'fishy']  name = 'fish-flavoured ramen';

++Ramen myFlavours = ['cheesy', 'cheese']  name = 'cheesy ramen';

++Ramen myFlavours = ['English', 'British', 'Eng', 'Brit', 'UK']  name = 'English-flavoured ramen';

++Ramen myFlavours = ['BBQ', 'barbeque', 'barbecue', 'barbie']  name = 'BBQ ramen';

++Ramen myFlavours = ['tomato', 'tomatoe', 'tomatoes', 'tomatoes']  name = 'tomato-flavoured ramen';

+prawnAndCornRamen : Ramen myFlavours = ['prawn and corn', 'prawn', 'shrimp', 'corn']  name = 'prawn and corn ramen';

++Ramen myFlavours = ['oyster']  name = 'oyster-flavoured ramen';

++Ramen myFlavours = ['curry', 'indian']  name = 'curry ramen';

++Ramen myFlavours = ['honey', 'sesame'] name = 'honey sesame ramen';

++Ramen myFlavours = ['creamy', 'chicken'] name = 'creamy chicken ramen';

++Ramen myFlavours = ['miso', 'tofu'] name ='miso tofu ramen';

++Ramen myFlavours = ['teriyaki', 'chicken', 'chook'] name = 'teriyaki chicken ramen';

++Ramen myFlavours = ['chicken', 'mushroom'] name = 'chicken mushroom ramen';

++Ramen myFlavours = ['Jalapeno', 'jalape\u00f1o'] name = 'jalape\u00f1o ramen';

programmerBedroom : Room
    name = 'Bedroom'
    destName = 'the bedroom'
    desc {
	if(isGloomy)
	    "More a crypt than a bedroom, this place is where soiled
	     t-shirts, soda cans and folded-up cardboard cartons
	     come to rest their weary bones. Meagre fingers of light
	     forces themselves around the closet to the north, while
	     light from the much brighter room to the east splashes
	     in through the door. There's a peculiar, worrying funk
	     to this room. ";
	else		
	    "A pale glow intrudes in from the window, illuminating
	     crevices unaccustomed to light and emphasising the
	     sheer predominance of junk strewn about the room.
	     Crumpled-up t-shirts, empty soda cans, and
	     unidentifiable miscellanea shiver naked in the cold
	     light of day. <.p>A single door leads out to somewhere
	     brighter and more inhabited. ";
    }
    isGloomy = (!programmerCloset.moved)
    east = programmerLounge
    eastLook = "A brighter, more airy room lies beyond the east
		door. "
    northLook {
	if(isGloomy)
	    "Persistant splinters of light push in around the
	     corners of the closet. ";
	else
	    "The cold light of the alleyway and the fire escape lie
	     beyond the window. ";
    }
;

+programmerCloset : Heavy
    vocabWords = 'wooden closet/cupboard/armoire'
    name = 'closet'
    desc {
	if(moved)
	    "The closet is a large, boxy, <q>economy-styled</q>
	     fixture that is only bought by students. There is no
	     decoration on it, save for some wrinkled t-shirts hung
	     off the sides. ";
	else
	    "The big box of a closet stands in front of the window.
	     Thin shafts of light peer around the edges where the
	     closet doesn\'t quite sit flush with the wall.<.p>The
	     closet itself is rather plain. It is most likely an
	     <q>economy</q> version, specially made for students. Or
	     more aptly, accidentally made inadequately, but
	     specially marketed to students. ";
    }
    moved = nil
    specialDesc {
	if(moved)
	    "A closet stands askew, next to the window. ";
    }
    dobjFor(Push) {
	verify() { logical; }
	action() {
	    if(moved) {
		moved = nil;
		mainReport('{You/he} slide{s} the closet back in
			    front of the window, blocking out most
			    of the light. ');
	    }
	    else {
		moved = true;
		mainReport('{You/he} slide{s} the closet off to the
			    side, clearing the window. ');
	    }
	}
    }
    dobjFor(Pull) {
	verify() { logical; }
	action() {
	    if(moved) {
		moved = nil;
		mainReport('{You/he} pull{s} the closet back in
			    front of the window. The room becomes
			    gloomy again. ');
	    }
	    else {
		moved = true;
		mainReport('{You/he} shift{s} the closet away from
			    the window, letting in a wash of light. ');
	    }
	}
    }
;



//////////////////////////////////////////////////////////////////////

// ASK ABOUT FIRE ESCAPE : "Why does the fire escape stop at your level? Isn't that dangerous?" The programmer looks up querulously at the ceiling and says, "You know, I've never thought about that. Poor bastards."

programmer : Person
    vocabWords = 'programmer/guy/man/dude/coder/hacker/nerd/geek'
    name = 'programmer'
    desc = "UNIMPLEMENTED YET. "
    isHe = true
;
