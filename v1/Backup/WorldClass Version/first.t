// First floor stuff

StairwellFirst: Room
    sdesc = "First Floor Stairwell"
    ldesc = "The first floor stairwell is much the same as the ground floor. In
	     fact, you're willing to bet they're all like that. Architects and
	     their interest in repetition... When will they learn? There is a
	     small sign on the wall and a doorway to the west opening up into a
	     hallway."
    grounddesc = "The ground is nicely smoothed concrete. Very professional once
		  laid, dangerous when wet. "
    goDown = StairwellGround
    goWest = FirstHallway1
;

StairwellFirstSign: Readable, Decoration
    location = StairwellFirst
    noun = 'sign' 'arrow'
    adjective = 'small' 'metal' 'shiny'
    sdesc = "sign"
    ldesc = "A shiny metal sign indicating that this is the first floor. You can
	     go up the stairs to the second floor and down to the ground floor.
	     Ingenious!"
    readdesc = "An arrow points up the stairwell with the label: \"Second\".
		Another points down with the label: \"Ground\". A third and
		final arrow points out to the hallway to the west indicating
		\"First\"."
;

StairwellFirstFluro: Decoration, Listablesound
    location = StairwellFirst
    noun = 'light' 'fluoro' 'lights' 'fluoros'
    adjective = 'fluorescent' 'hum' 'humming' 'buzz' 'buzzing' 'stairwell'
    sdesc = "fluorescent lights"
    ldesc = "It's just standard fluorescent lighting. Bright lights ceased being
	     entertaining for you many years ago."
    listendesc = "The fluorescent lights buzz softly. "
    listlistendesc(actor) = "hum single-mindedly"
    isplural = true
;

FirstHallway1: Room
    sdesc = "First floor hallway"
    ldesc = {"This is the east end of the first floor's hallway. The hallway
	      continues westwards with its chalky grey paint and wearied
	      rust-coloured carpet before turning northwards to much of the
	      same, presumably. There are two doorways here, leading west and
	      north. The doorway to the west leads into a concrete stairwell.
	      The fluorescent lighting isn't particularly elegant or inviting. ";
	     FirstHallway1LunchDoor.isopen ? "Almost correspondingly, the room to
					      the north is lit in a dreary green-grey fluorescence. It seems
					      to be a lunch room. The ordinary lighting in the hallway is cosy in comparison. " :
	     "In comparison, the ordinary hallway lighting is strangely
	      comforting. The plain blue-grey door to the north is closed. ";
	 }
    grounddesc = "The light rust-coloured carpet here is of the tough, compacted
		  kind. It seems to be in good shape, discounting the usual wear
		  and tear due to traffic. "
    wallsdesc = "The hallway has been painted a pale, chalky grey. You guess
		 this wasn't a well-intentioned choice by the architect, more a
		 \"just the usual, thanks\" decision. Periodically along the
		 walls there are circular lights that illuminate the hallway.
		 Despite being rather plain, the hallway is well-maintained, to
		 its credit."
    ceilingdesc = "You stare at the ceiling for a while, trying to find
		   inspiration amongst the plain white paint. You find nothing. "
    goEast = StairwellFirst
    goWest = FirstHallway2
    goNorth = FirstHallway1LunchDoor
    goIn = FirstHallway1LunchDoor
;

LunchRoom: Room
    sdesc = "Lunch room"
    ldesc = {"You guess this must be for the lower-rung employees. The room is
	      almost entirely made of drab linoleum and has a faint artificial
	      lemon-scented floor cleaner smell to it. The single light above is
	      so old that it emits a weird green-grey light, not helping the
	      atmosphere at all. The door to the south is "; if (LunchRoomDoor.isopen) {"held open by a hook
											 latching it to the wall";} else {"closed, revealing a poster"; LunchRoomDoorPoster.isseen := true;} "."; }
    grounddesc = "The floor is made out of grey and brown flecked linoleum
		  tiles. A few smudges and stains hide in nooks and crannies
		  where the cleaners couldn't (or couldn't be bothered to) get
		  to. "
    smelldesc = "The stale linoleum smell is almost saturated in the
		 lemon-scented floor cleaner that they obviously use here. "
    issmellable(actor) = { return true; }
    goSouth = LunchRoomDoor
    goOut = LunchRoomDoor
;

LunchRoomDoor: Door
    location = LunchRoom
    noun = 'door'
    adjective = 'lunch' 'lunch room'
    sdesc = "lunch room door"
    ldesc = "A plain wooden door. It is covered in some cheap grey-blue paint
	     that hasn't started to flake yet, but threatens to. There is a
	     small sign in the center of the door. <<self.opendesc>> "
    opendesc = "\^<<self.subjprodesc>> <<self.is>> <<self.isopen ? " wide open" : " closed, revealing a poster">>."
    doordest = FirstHallway1
    otherside = FirstHallway1LunchDoor
    isopen = true
    openmessage(actor) = { "You open the door. It swings wide open with little effort on your behalf. ";}
    closemessage(actor) = { "You shut the door with a light push. You notice a poster stuck on the back of the door. "; }
    setIsopen(setting) = {
	if (setting)
	    LunchRoomDoorSign.setpartof(LunchRoomDoor);
	else
	    LunchRoomDoorSign.setpartof(FirstHallway1LunchDoor);
	pass setIsopen;
    }
;

FirstHallway1LunchDoor: Door
    location = FirstHallway1
    noun = 'door'
    adjective = 'lunch' 'lunch room'
    sdesc = "lunch room door"
    ldesc = "A plain wooden door. It is covered in some cheap grey-blue paint
	     that hasn't started to flake yet, but threatens to. There is a
	     small sign affixed to the center of the door. <<self.opendesc>> "
    opendesc = {
	"\^<<self.subjprodesc>> <<self.is>> ";
	if (self.isopen) " wide open";
	else {" closed"; }
	".";
    }
    doordest = LunchRoom
    otherside = LunchRoomDoor
    isopen = { return LunchRoomDoor.isopen;}
    openmessage(actor) = { "You twist the knob and the door swings open easily. ";}
    closemessage(actor) = { "Leaning into the lunch room, you grab the door and pull it shut. ";}
    setIsopen(setting) = {
	if (setting)
	    LunchRoomDoorSign.setpartof(FirstHallway1LunchDoor);
	else
	    LunchRoomDoorSign.setpartof(LunchRoomDoor);
	pass setIsopen;
    }
;

LunchRoomDoorPoster: Part, Decoration
    partof = LunchRoomDoor
    noun = 'poster' 'calendar' 'notice' 'sheet'
    sdesc = "poster"
    ldesc = "Stuck to the back of the door is a motivational poster for the
	     cleaners. It looks like it survived the Cold War. The poster is
	     divided into two pictures top and bottom, divided by a line of bold
	     text. The top picture is a beautiful, enthusiastic young woman
	     merrily pushing a mop around. Below it is a frumpy old woman
	     slouching over a cup of coffee, a crumpled cigarette hanging from
	     her sour mouth. The big block letters between them asks, \"What is
	     your purpose here?\" \b You wouldn\'t be surprised to see a little
	     line saying \"Brought to you by the Nazi Work Ethics Committee.\" "
    isvisible(actor) = {
	return (not LunchRoomDoor.isopen);
    }
;

LunchRoomDoorSign: Part, Decoration
    partof = LunchRoomDoor
    noun = 'sign'
    adjective = 'plastic' 'door'
    sdesc = "plastic sign on door"
    ldesc = "Written in a stock signage font, the little plastic sign says tersely: \"Lunch room. Employees only.\" "
;

FirstHallway2: Room
    sdesc = "First floor hallway"
    ldesc = "THIS HAS NOT BEEN COMPLETED. ADD IN DESC, CARPET FLOOR...\b Go east
	     to hallway, west to more hallway, south to oldies, north to abandoned apartment. "
    goEast = FirstHallway1
    goWest = FirstHallway3
    goSouth = OldPeopleLounge
    goNorth = AbandonedLounge
;

FirstHallway3: Room
    sdesc = "Bend in hallway"
    ldesc = "INCOMPLETE. Go east to hallway, west to elevator, north to more hallway, south to Dude's room."
    goEast = FirstHallway2
    goNorth = FirstHallway4
    goSouth = DudeLounge
;

FirstHallway4: Room
    sdesc = "OH NO NOT MORE HALLWAY"
    ldesc = "INCOMPLETE. Go south to hallway/elevator, west to Jack n Jill, east to Locked Apartment."
    goSouth = FirstHallway3
    goWest = JJEntry
;

OldPeopleLounge: Room
    sdesc = "An apartment"     	// Have a variable sdesc with knowledge of old lady
    ldesc = "UNIMPLEMENTED YET. North hallway, east bedroom, south kitchen."
    smelldesc = "" 		// Some old people smell
    goNorth = FirstHallway2
    goEast = OldPeopleBedroom
    goSouth = OldPeopleKitchen
    goOut = FirstHallway2
;

OldPeopleBedroom: Room
    sdesc = "The bedroom"
    ldesc = "UNIMPLEMENTED YET. West to lounge, south to bathroom."
    smelldesc = ""		// Some old people smell
    goWest = OldPeopleLounge
    goSouth = OldPeopleBathroom
;

OldPeopleBathroom: Room
    sdesc = "The bathroom"
    ldesc = "UNIMPLEMENTED YET. North to bedroom."
    goNorth = OldPeopleBedroom
;

OldPeopleKitchen: Room
    sdesc = "The kitchen"
    ldesc = "UNIMPLEMENTED YET. North to lounge."
    goNorth = OldPeopleLounge
;

AbandonedLounge: Room
    sdesc = "Abandoned Lounge Room"
    ldesc = "UNIMPLEMENTED YET. South to hallway. East to closet. "
    goSouth = FirstHallway2
    goEast = AbandonedCloset
    goWest = AbandonedKitchen
;

AbandonedKitchen: Room
    sdesc = "Abandoned kitchen"
    ldesc = "UNIMPLEMENTED YET. East to lounge. "
    goEast = AbandonedLounge
;

AbandonedCloset: Room
    sdesc = "Abandoned Closet"
    ldesc = "UNIMPLEMENTED YET. South to kitchen."
    goWest = AbandonedLounge
;

Catwalk1: Room
    sdesc = "Catwalk over alleyway"
    ldesc = "UNIMPLEMENTED YET. South to Abandoned Lounge."
    goSouth = AbandonedLounge
;

DangerousLedge1: Room
    sdesc = "Dangerous Ledge"
    ldesc = "UNIMPLEMENTED YET. East to Catwalk, North to Dangerous Ledge."
    goEast = Catwalk1
    goNorth = DangerousLedge2
;

DangerousLedge2: Room
    sdesc = "Dangerous Ledge"
    ldesc = "UNIMPLEMENTED YET. South to Dangerous Ledge, North to Catwalk outside Locked Apartment bedroom."
    goSouth = DangerousLedge1
    goNorth = Catwalk2
;

Catwalk2: Room
    sdesc = "Catwalk over alleyway"
    ldesc = "UNIMPLEMENTED YET. South to Dangerous Ledge, west to Locked Apartment Bedroom."
    goWest = LockedApartmentBedroom
    goSouth = DangerousLedge2
;

DudeLounge: Room
    sdesc = "Dude's Lounge"
    ldesc = "Dude's lounge. Add in junk, dude etc North to hallway, west to
	     bedroom, southwest to bathroom, south to kitchen"
    goNorth = FirstHallway3
    goSouthwest = DudeBathroom
    goSouth = DudeKitchen
    goWest = DudeBedroom
;

DudeBedroom: Room
    sdesc = "Dude's Bedroom"
    ldesc = "Dude's bedroom. Add in junk, bed, decorations. East to lounge."
    goEast = DudeLounge
    goOut = DudeLounge
;

DudeBathroom: Room
    sdesc = "Dude's Bathroom"
    ldesc = "Dude's bathroom. Add in shower, sink, junk, toilet. Northeast to lounge."
    goNorth = DudeLounge
    goNortheast = DudeLounge
    goOut = DudeLounge
;

DudeKitchen: Room
    sdesc = "Dude's Kitchen"
    ldesc = "Dude's kitchen. Add in usual crazy stuff. North to lounge."
    goNorth = DudeLounge
    goOut = DudeLounge
;


JJEntry: Room
    sdesc = "Jack & Jill Entry"
    ldesc = "Jack & Jill's entrance. Add in coat rack, etc. West to bathroom,
	     south to kitchen, north to bedroom, northwest to lounge, east to
	     hallway."
    goEast = FirstHallway4
    goWest = JJBathroom
    goSouth = JJKitchen
    goNorth = JJBedroom
    goNorthwest = JJLounge
    goOut = FirstHallway4
;

JJBathroom: Room
    sdesc = "Jack & Jill Bathroom"
    ldesc = "Jack & Jill's bathroom. Maybe untravelable. East to J & J entrance. "
    goEast = JJEntry
    goOut = JJEntry
;

JJKitchen: Room
    sdesc = "Jack & Jill Kitchen"
    ldesc = "Jack & Jill's kitchen. Maybe nest in with entry. Add bench,
	     paraphenalia. East to J & J entrance. "
    goNorth = JJEntry
    goOut = JJEntry
;

JJBedroom: Room
    sdesc = "Jack & Jill Bedroom"
    ldesc = "Jack & Jill bedroom. Usual trimmings. South to entrance."
    goSouth = JJEntry
    goOut = JJEntry
;

JJLounge: Room
    sdesc = "Jack & Jill Lounge"
    ldesc = "Jack & Jill lounge. Add Jack, TV, couch, TV table. Southeast to entrance."
    goSoutheast = JJEntry
    goOut = JJEntry
;

LockedApartmentLounge: Room
    sdesc = "Locked apartment lounge"
    ldesc = "Lounge for locked apartment. North to kitchen, south to study, east to bedroom, west to hallway."
    goNorth = LockedApartmentKitchen
    goSouth = LockedApartmentStudy
    goEast = LockedApartmentBedroom
    goWest = FirstHallway4
    goOut = FirstHallway4
;

LockedApartmentKitchen: Room
    sdesc = "Locked apartment kitchen"
    ldesc = "Kitchen for locked apartment. South to lounge."
    goSouth = LockedApartmentLounge
    goOut = LockedApartmentLounge
;

LockedApartmentStudy: Room
    sdesc = "Locked Apartment Study"
    ldesc = "Study for locked apartment. North to lounge."
    goNorth = LockedApartmentLounge
    goOut = LockedApartmentLounge
;

LockedApartmentBedroom: Room
    sdesc = "Locked Apartment Bedroom"
    ldesc = "Bedroom for locked apartment. West to lounge, east to catwalk, north to bathroom."
    goWest = LockedApartmentLounge
    goEast = Catwalk2
    goNorth = LockedApartmentBathroom
;

LockedApartmentBathroom: Room
    sdesc = "Locked Apartment Bathroom"
    ldesc = "Bathroom for locked apartment. South to bedroom."
    goSouth = LockedApartmentBedroom
    goOut = LockedApartmentBedroom
;
