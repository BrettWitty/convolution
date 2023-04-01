#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//---------------//
//  The storage  //
//---------------//

newStorageRoom : Room
    name = 'Storage Room'
    destName = 'the storage room'
    desc = "Although this room has no natural lighting, fresh air or
	    space to move, it makes up for it with wall-to-wall
	    shelves crammed full of boxes and assorted knick-knacks.
	    The door to freedom lies to the west. "
    roomDarkDesc {
	if(storageToLaundryDoor.isOpen) {
	    if(laundryLight.isOn)
		"With only the light from the door illuminating the
		 room, you are surrounded by shadowy, strange shapes
		 that feel like they creep closer with each passing
		 breath. ";
	    else
		"Even if you let your eyes adjust, you can\'t see
		 much at all but dark, murky shapes. ";
	}
	else {
	    if(laundryLight.isOn)
		"Between gaps in the shelf you can see the small ray
		 of light from underneath the door, but very little
		 else. ";
	    else
		"Even if you let your eyes adjust, you can\'t see
		 much at all but dark, murky shapes. ";
	}
    }
    roomParts = [newStorageRoomWall, newStorageRoomFloor, newStorageRoomCeiling]
    west = storageToLaundryDoor
    northwest asExit(west)
    out asExit(west)
;

+storageToLaundryDoor : Door ->laundryToStorageDoor 'dull red west door/doorway' 'door to the laundry'
    "The door out is wedged into the northwest corner of the room.
     When open, it barely misses the shelves and surrounding clutter"
    openStatus() {isOpen ? ". At the moment, it is tucked behind a box overhanging from a nearby shelf. " : ". It is currently closed, adding a little bit of extra space to the room. ";}
;

+Heavy, Surface 'industrial grade storage rack shelf/ledge/rack/shelving/shelves/racks' 'storage shelf'
    "All four walls, from floor to ceiling, boxes and assorted
     knick-knacks have been packed into industrial shelves. The
     shelves themselves are made out of hardwood, supported by a
     sturdy frame of thick gauge steel. "
    hideFromAll(action) { return true; }
    dobjFor(Pull) {
	check() {
	    "Even if the shelves weren\'t bolted to the wall, the
	     heavy contents would make it difficult (and dangerous)
	     to pull on the shelves. ";
	    exit;
	}
    }
    initDesc = "The four walls are lined with industrial-grade
		shelves packed to the brim with boxes and other
		junk. "
    bulkCapacity = 100
;

+newStorageRoomWall : DefaultWall 'n s e w north south east west concrete north/south/east/west/wall*walls' 'wall'
    "You can barely see the concrete walls through all the boxes and
     junk. "
;

+newStorageRoomFloor : defaultFloor 'floor/ground/down/d' 'floor'
    "The storage room floor is dusty, rough and completely
     unremarkable. "
;

+newStorageRoomCeiling : defaultCeiling 'ceiling/roof/up' 'ceiling'
    "The ceiling is just a thin strip between the towers of shelves
     flanking the room. The surface is relatively smooth, and only
     interrupted by the basic light fixture. "
;

+newStorageRoomLight : Decoration 'light light/fixture' 'light fixture' @newStorageRoom
    "The sole light in this room is a no-nonsense circular fixture.
     The plastic casing induces a warm orange light to illuminate
     the room and soft shadows to shroud the stuff on the shelves. "
    brightness = 3
    hideFromAll(action) { return true; }
    dobjFor(TurnOn) remapTo(TurnOn,newStorageLightSwitch)
    dobjFor(TurnOff) remapTo(TurnOff,newStorageLightSwitch)
;    

+newStorageLightSwitch : Switch, Fixture '(small) glowing plastic light switch/control/controls/button' 'light switch' @newStorageRoom
    "The plastic light switch is unremarkable and merely functional. <<isOn ?
     nil : 'The switch glows slightly, probably so people can find it in the
     dark. '>> " //"
    makeOn(val) {
	newStorageRoomLight.brightness = ( val ? 3 : 1);
	"With a click <<val ? ' the lights come on. ' : 'the room is plunged into darkness. '>> ";
	inherited(val);
    }
    hideFromAll(action) { return true; }
    brightness = 1
    isOn = true
    specialDesc { isOn? nil : "Almost hidden by dark shapes is a
			       small glowing light switch near the
			       door. "; }
    dobjFor(Push) remapTo(Switch,self)
;

+Decoration 'assorted stored knick junk/rubbish/stuff/knick-knacks/knick/knacks/possessions' 'assorted stored possessions' @newStorageRoom
    "Hundreds of random objects have been stored away in this room.
     Most are packed away into boxes, but others are just strewn
     across a shelf, or wedged behind some other storage box. All of
     this junk was deemed valuable at some point to one of the
     residents who now cannot bring themselves to throw the stuff
     away. Junk like memories---things you want to let go, leave
     behind, throw away, but cannot. "
    hasBeenSearched = nil
    dobjFor(Search) {
	preCond = [objVisible]
	verify() {
	    logical;
	}
	check() {
	    if(hasBeenSearched)
		failCheck('You poke around a little more but you
			   can\'t find anything else of note. ');
	}
	action() {
	    
	    hasBeenSearched = true;

	    mainReport('You poke through the shelves. A few things
			catch your eye: a rusty tuba; a small,
			locked, metal box; a cordless hair dryer;
			and a dusty journal jammed behind some
			boxes. The rest of it is miscellaneous junk
			that even their owners might not find
			valuable. ');

	    // Trigger the above objects being listed.
	    // tuba.isListed = true
	    // hairDryer.isListed = true
	    // 
	}
    }
;
