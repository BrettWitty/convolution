#charset "us-ascii"
#include "adv3.h"
#include "en_us.h"

//------------------//
//  The Prisoner's  //
//       Place      //
//------------------//

prisonerMainRoom : Room
    name = 'Deconstructed room'
    destName = 'the deconstructed room'
    desc = "A rage has swept through this apartment, tearing off the
	    wallpaper, pulling up the carpet, shattering the
	    furniture and piling it in the back of the room, like a
	    mass grave for furnishings. A bare bulb hangs from the
	    ceiling throwing its harsh light over the aftermath.<.p>
	    The dust has now settled, and the surroundings are now
	    dull and aging. A cold air hangs still here in the
	    windowless, lifeless room. A dim glint from the back of
	    the room suggests a padlocked door. "
    west = prisonerMainToBackRoomDoor
;

+prisonerMainToBackRoomDoor : LockableWithKey, Door
    vocabWords = 'dim west w back door/doorway/glint/west/w'
    name = 'back door'
    desc = "Ragged scratch marks tear down the middle of the door,
	    now caked with the dust that also collects on the
	    skirtings. Despite the neglect and gougings, the door
	    looks rather solid. It is kept shut with a heavy-duty
	    padlock. Curious for an interior door... "
    initiallyOpen = nil
    initiallyLocked = true
    keyList = [prisonerKey,hairPin]
;

+Immovable
    vocabWords = 'abandoned shattered smashed pile trashed broken furniture/furnishings/table/chair/wood/pile/trash/rubbish'
    name = 'pile of broken furniture'
    desc = "UNIMPLEMENTED YET."
;

+Unthing 'rolled-up removed carpet' 'carpet'
    notHereMsg = 'The carpet has been completely removed as far as
		  you can see. '
;

prisonerBackRoom : Room
    name = 'Back room to the demolished apartment'
    destName = 'the back room'
    desc = "You can\'t imagine what this dust-laden, stale room used
	    to be. It seems a little too big for a bedroom but not
	    functional enough for anything else. Light streaks in
	    through haphazardly boarded-up windows, just enough so
	    you can make out the abandoned furniture. "
    west = prisonerBackRoomToMainDoor
;

+prisonerBackRoomToMainDoor : Door ->prisonerMainToBackRoomDoor
    vocabWords = 'east e main door/doorway/east/e'
    name = 'door to the main room'
    desc = "UNIMPLEMENTED YET."
;

+prisonerTable : Surface, Heavy
    vocabWords = 'table'
    name = 'table'
    desc = "UNIMPLEMENTED YET."
;


//----------------//
//  The Prisoner  //
//----------------//

prisoner : Person
    vocabWords = 'pale thin skinny mad crazy imprisoned chained emaciated prisoner/man/guy/nutcase/madman'
    name = 'prisoner'
    desc = "UNIMPLEMENTED YET. "
    posture = sitting
    location = prisonerMainRoom
;

+prisonerKey : Key, Wearable
    vocabWords = 'key key/chain'
    name = 'key on a chain'
    desc = "UNIMPLEMENTED YET."
    owner = prisoner
    wornBy = prisoner
;

// This is the prisoner's neck lock
// Strangely, this is both plural and singular
// (a lock, shackles)
+prisonerLock : LockableWithKey, Wearable
    vocabWords = 'lock/chain/shackles'
    name = 'shackles'
    desc = "UNIMPLEMENTED YET. "
    isPlural = true
    owner = prisoner
    wornBy = prisoner
    initiallyLocked = true
    aName = (name)
    keyList = [prisonerKey]
;

+prisonerSittingTalking : InConversationState
    specialDesc = "The emaciated man sits cross-legged on the floor
		   and fixes you with a wild-eyed stare. "
    stateDesc = "He is currently listening to you, though he hisses
		 through clenched teeth. His wild-eyed gaze never
		 wavers. "
;

++prisonerSittingIdle : ConversationReadyState
    specialDesc = "An emaciated man in a loincloth sits cross-legged
		   in the middle of the floor, his head bowed. "
    stateDesc = "He is sitting cross-legged on the floor with his
		 head bowed, clothed in shadows. "
;
