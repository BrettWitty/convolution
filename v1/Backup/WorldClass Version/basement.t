//////////////////
// Bunch of boxes

StartRoom: Room
    sdesc = "Behind a bunch of boxes"
    ldesc = {
	if (BunchOfBoxes.ispiled)
	    "You find yourself surrounded by hundreds and hundreds of boxes. This
	     storage area seems to be tucked away in some mouldy corner of a
	     basement somewhere. Murky light seeps in from the small, dusty window
	     near the ceiling. ";
	else
	    "The boxes lie in neat stacks around you, except for a few small random
	     piles near the cleared way to the north. <<NailedShutDoor.adesc>>";
    }
    goEast(actor) = {
	"You deftly weave a way through the cardboard boxes out into... \b";
	return Basement;
    }
;

BunchOfBoxes: Fixture, Readable, Stool
    location = StartRoom
    noun = 'boxes'
    adjective = 'bunch' 'bunch of' 'delivery' 'hundreds' 'unopened' 'reject'
    sdesc = "the boxes"
    ldesc = "The boxes seem to be unopened delivery boxes, piled high in vaguely
	     ordered way. They surround you in a creepy \"fort of postal
	     rejects\" way."
    heredesc = {
	if (self.ispiled)
	    "Except for a small passage to the east, the boxes surround you.";
	else
	    "The delivery boxes are piled up all around you, except for a tight
	     passage to the east and a small cleared way to a door to the north.";
    }
    readdesc = "Hundreds of names are scribbled on the delivery boxes - some
		that sound vaguely familiar, others that definitely don't and
		many more that you can't even read (unless their names contain
		very few vowels...)"
    ispiled = true
    standable = true
    isdetermined = true
    isplural = true
    verGeton(actor) = {
	if(actor = Me)
	    "As much as your heart desires to stand gloriously atop these Boxes Of
	     Delivery, vanquishing them with your magnificent mountaineering skills,
	     the ceiling is way too low and you doubt whether they could hold you
	     (reliably). ";
    }
    verDoLieon(actor) = {
	switch(rnd(3))
	{
	  case 1:
	    "Try as you might, you can't seem to stack any boxes flat enough to be
	     appropriate for lying on!";
	    break;
	  case 2:
	    "You try lying on a few boxes that don't look too bad...
	     Unfortunately, one of them make a horrible crunch sound when you put
	     your weight on it. You roll away and figure you'd be better off in
	     your current position.";
	    break;
	  case 3:
	    "Figuring you have nothing better to do, you start getting ready for a
	     good ol' lie down, but then you realize, you DO have something better
	     to do!";
	    break;
	}
    }
    doSiton(actor) = {
	"You sit on one of the boxes and ponder your predicament. ";
	pass doSiton;
    }
    doEnter(actor) = {
	if (actor.moveon(self)) {
	    actor.position := 'sitting';
	}
    }
    verDoPush(actor) = {
	"You prepare to give the boxes a solid shove, when then the word
	 \"avalanche\" comes to mind. You can think of more glamorous ways to
	 die and so leave the boxes be.";
    }
;

NailedShutDoor: Door
    
;

BasementMould: Unimportant
    location = StartRoom
    noun = 'mould' 'corner'
    adjective = 'mouldy'
    sdesc = "mould"
    ldesc = "Upon closer inspection, there seems to be no substantial mould,
	     although this place certainly suggests that there should be."
;

Kazakhstan: Unimportant, Readable
    location = StartRoom
    noun = 'kazakhstan' 'kazakh' 'kaz' 'kazak'
    sdesc = "kazakhstan"
    ldesc = "If you squint you think you can see the name \"Nazarbayev\" who
	     lives somewhere in Kazakhstan. "
;

StartRoomWindow: Unimportant
    location = StartRoom
    noun = 'window'
    adjective = 'small' 'dusty'
    sdesc = "small, dusty window"
    ldesc = "The window seems to be completely covered in grime from the
	     outside. There is no way to open the window. Anyway, it's too small
	     to squeeze through."
;

Basement: Room
    sdesc = "The Basement"
    ldesc = "Quite obviously, this is a basement. Even more clearly, the place
	     isn't regularly used - dust and spiderwebs decorate the place.
	     Cardboard boxes are stacked high to the west and you think you can
	     see a narrow path through them. There is a small metal door to the
	     south and stairs leading upwards to the east."
    grounddesc = "The floor is quite dusty, except for the clear track from the
		  stairs to the door to the south. Other than that, it's
		  unremarkable, worn cement."
    goWest(actor) =
    { say('You squeeze through the boxes.\b ');
      return(StartRoom);
  }
    goSouth(actor) =
    { if ( JanitorDoorA.isopen )
      {
	  return(JanitorRoom);
      }
    else
    {
	JanitorDoorA.islocked ? "The door seems very much locked. " : "You need to open the door first.";  // FIX THIS TO AUTOOPEN!
	return(nil);
    }
  }
    goEast(actor) = {
	say('You walk up the stairs into the light.\b ');
	return(BackRoom);
    }
;

BasementLight: Unimportant
    location = Basement
    noun = 'light'
    sdesc = "basement light"
    ldesc = "There are a few cased lights embedded in a few spots around the
	     ceiling. They seem to be those industrial-grade lights that are
	     turned on once and stay on for half a century or so. You see no way
	     to turn them on or off, or even fiddle with them."
;

BasementDust: Unimportant
    location = Basement
    noun = 'dust'
    sdesc = "dust"
    ldesc = "The dust seems well-settled in here, except for a clear track from
	     the stairs to the metal door to the south. "
;

BasementWebs: Unimportant
    location = Basement
    noun = 'web' 'webs' 'spiderwebs'
    adjective = 'spider'
    sdesc = "spiderwebs"
    ldesc = "You are surprised there aren't more spiderwebs hanging about. Maybe
	     there aren't enough bugs down here."
;

JanitorDoorA: Door
    location = Basement
    key = JanitorKey
    doordest = JanitorRoom
    otherside = JanitorDoorB
    noun = 'door' 'janitor' 'closet'
    adjective = 'metal' 'small' 'janitor\'s' 'janitor'
    sdesc = "small metal door"
    ldesc = {
	if ( self.isopen )
	    "The door to the janitor\'s room is open. ";
	else
	    "The sturdy metal door is shut. Scratched into the middle of it is
	     the word \"Janitor\". No prizes for whose room lies beyond.\b ";
    }
    islocked = true
    islockable = true
;

JanitorDoorB: Door
    location = JanitorRoom
    key = JanitorKey
    doordest = Basement
    otherside = JanitorDoorA
    noun = 'door' 'janitor' 'closet'
    adjective = 'metal' 'small' 'janitor\'s' 'janitor'
    sdesc = "small metal door"
    ldesc =
    { if ( self.isopen )
	  "The door to the janitor\'s room is open. ";
    else
	"The sturdy metal door is shut. Scratched into the middle of it is the
	 word \"Janitor\". No prizes for whose room lies beyond.\b ";
  }
    islocked = true
    islockable = true
;

JanitorRoom: Room
    sdesc = "The Janitor's Room"
    ldesc = {"Typical for someone employed to do all the hard work - the
	      supervisor's room is tiny. It's very utilitarian (ironic for a
	      utility closet). A bare light bulb illuminates the room in a harsh
	      light. The door leading out is currently "; JanitorDoorA.isopen ? "wide open" : "shut"; ". ";}
    goNorth(actor) =
    { if ( JanitorDoorA.isopen )
      {
	  return(Basement);
      }
    else
    {
	JanitorDoorA.islocked ? "The door seems very much locked. You'll
				 have to find a way around that. Or maybe
				 not. " : "You need to
					   open the door first.";     //FIX TO AUTOOPEN!!!
	return(nil);
    }
  }
;

JanitorCloset: Openable, Fixture
    location = JanitorRoom
    noun = 'closet' 'cupboard' 'storage'
    sdesc = "storage closet"
    ldesc =
    { "A sizable storage closet. ";
      pass ldesc;
  }
    heredesc = {
	"There is a sizable storage closet against the side wall. ";
	pass ldesc;
    }
    isopen = nil
;

OldStorageSouth: Room
;

OldStorageNorth: Room
;
