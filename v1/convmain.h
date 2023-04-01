#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// define the '+' property
// (we need this only once per source file)
+ property location;

// For the Breakable object, the following enums are defined.

// When broken, send the object to nil.
enum breakDestroy;

// When broken, replace the object with the value in breakReplacement.
enum breakReplace;

// When broken, do nothing. This is for custom modifications.
enum breakRemain;


// Some debug code to track room counts.
#ifdef  __DEBUG
PreinitObject
    execute {
	local roomCount = 0;
	local cur = firstObj(Room);
	while(cur != nil)
	{
	    roomCount++;
	    cur = nextObj(cur, Room);
	}
	local thingCount = 0;
	cur = firstObj(Thing);
	while(cur != nil) {
	    thingCount++;
	    cur = nextObj(cur,Thing);
	}
	local objectCount = 0;
	cur = firstObj();
	while(cur != nil) {
	    objectCount++;
	    cur = nextObj(cur);
	}
	"<p>This game contains <<roomCount>> rooms, <<thingCount>> Things and <<objectCount>> general objects.<p> ";
    }
execBeforeMe = [adv3LibPreinit]
;
#endif
