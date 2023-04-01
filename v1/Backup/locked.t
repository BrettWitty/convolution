#charset "us-ascii"
#include "adv3.h"
#include "en_us.h"

//--------------------//
//  Locked Apartment  //
//--------------------//

// define the '+' property
// (we need this only once per source file)
+ property location;

lockedLounge : Room
    name = 'Lounge Room'
    destName = 'the lounge room'
    desc = "Compared to the other rooms you\'ve seen so far, this
	    room is quite impressive. The entrance is a small
	    polished wood platform extending from the west wall,
	    leading into the sunken lounge room. The layout is
	    simple but elegant. A neatly arranged open-style
	    kitchenette lies to the north. A platform skirts the
	    south and east walls, capped with a small set of stairs
	    leading east into
	    <<gPlayerChar.knowsAbout(lockedBedroom) ? 'the bedroom'
	    : 'some room'>>, and south into
	    <<gPlayerChar.knowsAbout(lockedBedroom) ? '' : 'what
	    seems to be '>> a study area. "
    north = lockedKitchen
    south = lockedLoungeToStudy
    east = lockedLoungeToBedroomDoor
    west = lockedLoungeToHallwayDoor
    up = lockedLoungeEntrancePlatform
;

+ lockedLoungeToKitchen : Passage
    vocabWords = 'neatly arranged open-style north northern n kitchen/kitchenette/north/n'
    name = 'kitchenette'
    desc = 'Although not particularly spacious, the kitchenette area seems to be well-designed and well-stocked. '
    destination = lockedKitchen
;

+ lockedLoungeEntrancePlatform : NestedRoom
    vocabWords = 'entrance platform/entrance'
    name = 'entrance platform'
    desc = "UNIMPLEMENTED YET."
    exitDestination = lockedLounge
    down = lockedLounge
    west = lockedLoungeToHallwayDoor
;

+ lockedLoungeToHallwayDoor : Lockable, Door ->firstHallwayToLockedApartmentDoor
    vocabWords = 'west western w front door/west/w'
    name = 'front door'
    desc = "UNIMPLEMENTED YET."
    initiallyOpen = nil
    initiallyLocked = true
;

+ lockedLoungeToBedroomDoor : Door
    vocabWords = 'east eastern e east/e/door'
    name = 'door to the east'
    desc = "UNIMPLEMENTED YET."
    initiallyOpen = true
;

+ lockedLoungeToStudy : Passage
    vocabWords = 'south southern s study door/doorway/south/s/study'
    name = 'doorway to the study'
    desc = "UNIMPLEMENTED YET."
    destination = lockedStudy
;

lockedKitchen : Room
    name = 'Kitchenette'
    destName = 'the kitchen area'
    desc = "In stark contrast to the rest of the building, someone
	    has put a lot of time, money and effort into the design
	    of this kitchenette. The walls are predominantly glossy
	    black tiles embedded periodically with a single white
	    tile in the shape of a diamond. A speckled marble bench
	    borders most of the walls, stopping short at the north
	    wall to leave some space for the refrigerator to nestle
	    in. The top half of the south wall has been removed,
	    opening up the kitchen to the lounge. You imagine a
	    stylish guy living in this apartment, making dinner for
	    some pretty young thing reclining in the lounge, and
	    laying on the smooth small-talk over the half-wall.
	    Bastard. "
    south = lockedKitchenToLounge
;

+ lockedKitchenToLounge : Passage
    vocabWords = 'stylish stylishly decorated lounge south southern s lounge/room/south/s'
    name = 'lounge'
    desc = 'A stylishly decorated lounge room lies to the south. '
    destination = lockedLounge
;

lockedBedroom : Room
    name = 'Bedroom'
    destName = 'the bedroom'
    desc = 'UNIMPLEMENTED YET'
    north = lockedBedroomToBathroomDoor
    west = lockedBedroomToLoungeDoor
;

+ lockedBedroomToLoungeDoor : Door ->lockedLoungeToBedroomDoor
    vocabWords = 'west western w west/w/door'
    name = 'door to the lounge room'
    desc = "UNIMPLEMENTED YET."
    initiallyOpen = true
;

+ lockedBedroomToBathroomDoor : Door
    vocabWords = 'north n northern bathroom north/n/bathroom/door'
    name = 'door to the bathroom'
    desc = "UNIMPLEMENTED YET."
    initiallyOpen = true
;

lockedBathroom : Room
    name = 'Bathroom'
    destName = 'the bathroom'
    desc = "UNIMPLEMENTED YET."
    south = lockedBathroomToBedroomDoor
;

+ lockedBathroomToBedroomDoor : Door ->lockedBedroomToBathroomDoor
    vocabWords = 'south s southern bedroom south/s/bedroom/door'
    name = 'door to the bedroom'
    desc = "UNIMPLEMENTED YET."
    initiallyOpen = true
;

lockedStudy : Room
    name = 'Study'
    destName = 'the study'
    desc = "UNIMPLEMENTED YET."
    north = lockedStudyToLounge
;

+ lockedStudyToLounge : Passage, TravelMessage
    vocabWords = 'north northern n lounge door/doorway/north/n/lounge'
    name = 'doorway to the lounge room'
    desc = "UNIMPLEMENTED YET."
    destination = lockedLounge
    travelMessage = "{You/he} step slowly down the steps to the
		     lounge, hearing your steps on the wooden steps
		     echo about the apartment. "
;

+lockedStudyBookcases : Surface, Heavy
    vocabWords = '(book) oak bookcase/bookcases/case/cases/shelves/shelf'
    name = 'bookcases'
    desc = "Along two of the walls stand stately oak bookcases lined
	    neatly with a variety of books. Each are several shelves
	    high, each shelf packed tightly with rows of unsullied
	    books. Many of the books have no title, or don't catch
	    your eye. "
    specialDesc = "Two of the walls are lined with a set of elegant bookcases, neatly arranged. "
    isPlural = true
    contentsListed = nil
    descContentsLister : DescContentsLister, BaseSurfaceContentsLister {
	showListPrefixWide(itemCount, pov, parent){
	    "The one<<itemCount == 1 ? '' : 's'>> that do<<itemCount == 1 ? 'es' : ''>> <<itemCount == 1 ? 'is' : 'are'>> ";
	}
	showListSuffixWide(itemCount, pov, parent){
	    ". ";
	}
	showListPrefixTall(itemCount, pov, parent){
	    "The one<<itemCount == 1 ? '' : 's'>> that do<<itemCount == 1 ? 'es' : ''>> <<itemCount == 1 ? 'is' : 'are'>>:";
	}
	showListContentsPrefixTall(itemCount, pov, parent){
	    "<<parent.aName>>, on which <<itemCount == 1 ? 'is' : 'are'>>:";
	}
    }
;
