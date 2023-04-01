BackRoom: Room
  sdesc = "Some back room"
  ldesc = "You find yourself in a cramped, back room lying north from
	   <<Reception.isknown ? "what seems to be a" : "the">>
	   reception area. The hastily-stacked boxes and abandoned furniture
	   strewn about the place gives the impression that someone has been
	   using this place as a temporary storage area. Not effectively,
	   clearly.\b Just beyond a few boxes correctly placed to trip an
	   unwary traveller lies a set of stairs heading west, down into the
	   basement. A fortified emergency exit lies to the north."
  goWest(actor) = {
    "You step cautiously down the stairs into the basement. It takes
     a while for your eyes to adjust.\b ";
    return(Basement);
  }
  goSouth = Reception
  goNorth = BackRoomDoor
;

BackRoomBoxes: Fixture
  location = BackRoom
  noun = 'boxes' 'box' 'packages'
  adjective = 'hastily-stacked' 'stacked' 'cardboard'
  sdesc = "pile of boxes"
  ldesc = "The arrangement of these boxes is clearly the product of hastiness
	   or laziness. Or both. Some boxes are stacked askew, arranging
	   themselves according to gravity. Others seem to be stacked with
	   good intention - one box has its \"This way up\" arrow pointing
	   directly down, a small box supports a larger and heavier one...
	   You're sure that in the right gallery this would be an avante-garde
	   centerpiece of great distinction. Lying in this back room they have
	   been demoted to \"clutter\". "
  verDoTake(actor) = { "The boxes that immediately catch your eye do
			not keep your interest - you do not feel you
			need to take them. "; }
  verDoPush(actor) = { "Pushing any of the boxes around would be like
			navigating a carpark in post-Christmas sales time:
			more effort than it's worth. Knocking any of the piles
			over would exacerbate this (and your ability to move)
			moreso. "; }
;

BackRoomBustedChair: Fixture
  location = BackRoom
  noun = 'chair'
  adjective = 'abandoned' 'busted' 'broken' 'bent' 'crooked' 'twisted'
  sdesc = "busted-up chair"
  ldesc = "Some things in this world sure get the rough end of the
	   stick in terms of their existence: mayflies, dung
	   beetles, New Coke(tm) and this chair. It began its life
	   as one of those dime-a-dozen, plastic-backed, unergonomic
	   chairs that they often use for school assemblies or town
	   meetings. They are produced en masse with cheap (foreign)
	   labour; they only require screwing two bent pieces of
	   metal to the plastic seat. Unfortunately, their cheap
	   manufacture seems to induce enraged people to hurl them
	   at walls, lazy people to snap their backs via creative
	   posturing and the morbidly obese to accidentally crush them. This
	   specimen has had its seat warped and its legs bent and
	   snapped off. It lies in a tangle heap of plastic and
	   metal in one corner of the room. If it wasn't just a
	   stupid chair, you might shed a tear for its beleaguered
	   existence. "
  verDoTake(actor) = { "You think about taking this tangle of
			plastic and metal, but it doesn't serve its
			intended purpose - you couldn't possibly sit
			on it - nor does it lend itself to
			convenient carrying. You are sure your
			creativity stops well short of being able to
			make this busted-up chair useful. "; }
;

BackRoomDoor: Door
  location = BackRoom
  noun = 'door' 'exit'
  adjective = 'fortified' 'locked' 'back' 'emergency' 'reinforced'
  sdesc = "the emergency exit"
  ldesc = "Whoever runs this place must have forgotten the purpose of this
	   emergency exit. The doorway is fairly wide so you guess they may
	   have used this as the main delivery point - scratches of paint and
	   blunt gouges in the metal frame seem to confirm this theory.
	   However they must have found a better way and subsequently locked
	   this door permanently. It looks solid enough to shrug off any
	   axe-wielding maniac, and even seems to be doing a good job against
	   the occasional rust stain. Trying to shove this door open would be
	   a recipe for a broken shoulder. You dread to think what the fire
	   safety inspectors would make of it. "
  islocked = true
  isdetermined = true
  key = DummyItem
  verDoOpen(actor) = { "You rattle the door bar, but the door doesn't even
			make a pretence of being able to open. "; }
  verDoUnlockwith(actor) = { "You would probably need a special key and an
			      unbelievable amount of strength to open this
			      door. You have neither. ";}
  destination(actor) = { "\^<<actor.youll>> run smack into
			  <<self.objthedesc(actor)>>. Maybe you should try
			  opening it first.";}
  doKnockon(actor) = {
    "You <<knockonVerb.desc(actor)>> <<self.objthedesc(actor)>> to little
     effect - the door bar rattles a little, but the door itself seems too
     strong to let your knocking through. "; 
  }
;

Reception: Room
  sdesc = "The Reception"
  ldesc = "The reception office seems to be rarely used. It has the usual
	   assortment of administrative stuff strewn about, but has that
	   \"I'll be right back in a month or so\" look to it. Between the
	   mess and the filing cabinets is an important-looking door to the
	   east. Otherwise, a plain-looking door to the north leads out the
	   back and you spot the main lobby to the south."
  goSouth = Lobby
  goNorth = BackRoom
  goEast = ReceptionToManagerDoor
;

Lobby: Room
  sdesc = "The Lobby"
  ldesc = "You swear you\'ve seen this lobby a million times before - most
	   likely in countless movies from the Eighties. The thin tan
	   carpeting suggests that this is an apartment lobby; an office
	   building or hotel would buy a bit more dignity with marble or tiled
	   flooring.\n Steel elevator doors lie to the west with a lonely
	   \"up\" button to its right. To the north there is
	   <<ReceptionRollerDoorsOuter.isopen ? "the open but empty reception
	   window" : "a closed set of roller-blinds with a \"Reception\" sign above it">>
	   and a small doorway to the right leading into the reception office. Other than
	   this you can go to the east down a short hallway or towards the
	   shadowy entrance to the south. "
  goNorth = Reception
  goSouth = Entrance
  goEast = GroundHallway
;

ReceptionRollerDoorsOuter: Decoration
    location = Lobby
    noun = 'blinds' 'blind' 'roller-blind' 'roller-blinds' 'north' 'bars'
    adjective = 'roller' 'reception'
    sdesc = "set of <<self.isopen ? "" : "closed">> roller-blinds"
    ldesc = {
	if(self.isopen)
	    "Through the thin metal security bars you can see a cluttered but
	     deserted office area. Tucked in the right-hand corner of the room
	     is <<ReceptionToManagerDoor.isopen ? "an open " : "a">> door
	     leading east. The north-east corner of the room leads into a small
	     room full of boxes. ";
	else
	    "The reception window to the north has been shut. The smoothly
	     painted white roller-blinds are down and the thin security bars
	     enclose them. You can\'t see through the window (obviously) but
	     the door to the left of the window offers a chance to pursue
	     this. ";
    }
;

Entrance: Room
  sdesc = "The Entrance"
  ldesc = "The entrance area is only lit by the light coming in off the street
	   and some of the fluoros in the lobby to the north. It would
	   probably give the residents a glum welcoming as they checked their
	   mail. Nevertheless, the janitor keeps the place presentable,
	   despite the bad architectural design. There is a set of closed
	   glass doors to the south that lead out to the street. "
  goNorth = Lobby
  goSouth(actor) = {
    "To your surprise, the doors have been chained shut! ";
    return nil;
  }
;

EntranceDoors: Door, Qcontainer
  location = Entrance
  noun = 'doors' 'door'
  adjective = 'front' 'entrance' 'chained'
  sdesc = "the front doors"
  ldesc = {
    "The doors are slightly more impressive than you expected - the frames are
     constructed out of expensive oak that hold large glass panes stencilled
     with an elaborate insignia. Surprisingly, the handles are wrapped with a
     massive set of chains locked with a large, heavy-duty padlock. ";
    if( Envelope.isin(EntranceDoors))
      {"An envelope has been tucked between the chains. "; self.seenenvelope := true; };
  }
  isdetermined = true
  islocked = true
  isplural = true
  key = DummyItem
  seenenvelope = nil
  doInspect(actor) = { self.seenenvelope := true; pass doInspect;}
;

DoorInsignia: Part
  partof = EntranceDoors
  noun = 'insignia' 'crest' 'emblem' 'symbol' 'stencil'
  adjective = 'door' 'stencilled' 'big' 'glass'
  sdesc = "insignia on the door"
  ldesc = "The insignia stencilled on the door is an elaborate Celtic knot. It
	   is woven in a maddening way - you can't figure out if there is a
	   beginning or an end, or even if there are more than one distinct
	   strand! In an elegant calligraphic font below the design are the
	   initials CT. The whole thing is very expensive and elaborate, but
	   of no use to anybody!"
;

/*Mailboxes: Container, FixedItem
    location = entrance
    noun = 'box' 'mailbox' 'letterbox'
    adjective = 'letter' 'mail' '#'
    sdesc = "several mailboxes"
    validmailboxes = [101 102 103 104]
;*/

GroundHallway: Room
  sdesc = "Ground floor hallway"
  ldesc = "This hallway slinks off to the side of the lobby. Some effort has
	   been made to jazz up the hallway with the an obligatory scattering
	   of paintings and so forth, but it does feel a little underachieved.
	   At the eastern end of the hallway there is a stairwell leading up
	   and immediately to the south is a swinging door labelled
	   \"Laundry\". Alternatively you can return to the lobby to the west."
  goWest = Lobby
  goEast = StairwellGround
  goSouth(actor) = {"NEEDS TO BE IMPLEMENTED!"; return nil;}
;

StairwellGround: Room
  sdesc = "Ground floor stairwell"
  ldesc = "The stairwell is your usual spartan concrete fire escape, lit with
	   cold fluorescent lights. The stairs only lead up (as indicated by
	   the sign). Alternatively, you can walk out into the hallway to the
	   west. The hallway seems to lead out into the lobby. "
  goWest = GroundHallway
  goUp = StairwellFirst
  grounddesc = "Good ol\' fashioned concrete."
;

StairwellGroundSign: Readable, Decoration
  location = StairwellGround
  noun = 'sign' 'arrow'
  adjective = 'small' 'metal' 'shiny'
  sdesc = "sign"
  ldesc = "This standard-issue metal sign tells you are on the ground floor.
	   It also informs you that the first floor can be found upstairs. "
  readdesc = "The sign points diagonally upwards and informs you matter-of-factly: \"First\". "
  doTake(actor) = {
    "The sign is firmly glued to the wall. ";
  }
;

StairwellGroundFluro: Decoration
  location = StairwellGround
  noun = 'light' 'fluoro' 'lighting'
  adjective = 'fluoro' 'fluorescent' 'hum' 'humming' 'buzz' 'buzzing' 'stairwell'
  sdesc = "fluorescent light"
  ldesc = "It's just your run-of-the-mill fluorescent lighting. "
;

ReceptionToManagerDoor: Door
  location = Reception
  noun = 'door' 'east'
  adjective = 'east' 'manager' 'manager\'s'
  sdesc = "the door to the manager\'s office"
  ldesc = "By all rights, this door should be the same as all the other
	   standard wooden doors about the place. But as the little
	   gold-plated sign in the center of the door indicates that this is
	   the door to the Manager\'s office, standard isn't good enough. You
	   guess he would have wanted to install a grand oak door with
	   intricate and powerful carvings, but budget and space was tight so
	   all he got has an extra coat of shellac on the door (plus the
	   spiffy gold-plated sign). <<self.isopen ? "Surprisingly, the door is open, inviting like the mouth of a venus fly trap." : "Nevertheless it is firmly shut, clearly
          demonstrating the line between the power and the plebs.">> "
  isopen = nil
  isdetermined = true
  islocked = true
  islockable = true
  doordest = ManagersOffice
  otherside = ManagerToReceptionDoor
  key = DummyItem
  noautoopen = nil
  opendesc = "\^<<self.subjprodesc>> <<self.is>> <<self.isopen ? " strangely left open" : "firmly shut">>. "
  openmessage(actor) = { "The door creaks softly, almost as though it gasped
			  at your intention to enter into The Forbidden Zone. ";}
  closemessage(actor) = { "With a sigh, the door closes and clicks shut. ";}
  lockmessage(actor) = { "The door locks with a definitive <I>click!</I>. "; }
  unlockmessage(actor) = { "With a slightly resistive click, the door unlocks. "; }
  doClose(actor) = {
    self.closemessage(actor);
    self.isopen := nil;
    if (self.otherside) self.otherside.isopen := nil;
    self.lockmessage(actor);
    self.islocked := true;
    if (self.otherside) self.otherside.islocked := true;
  }
  smelldesc = ShellacRTMDoor.smelldesc
  touchdesc = ShellacRTMDoor.touchdesc
  tastedesc = ShellacRTMDoor.tastedesc
;

ManagerSign: Part, Fixture
  partof = ReceptionToManagerDoor
  noun = 'sign' 'manager'
  adjective = 'gold' 'gold-plated' 'spiffy'
  sdesc = "sign saying \"Manager\""
  ldesc = "This stylish, gold-plated wasn't from any ol\' hardware store; it
	   looks like it has been professionally machined and fitted. It\'s
	   even been polished recently, judging from your golden reflection."
;

ShellacRTMDoor: Part, Fixture
  partof = ReceptionToManagerDoor
  noun = 'shellac' 'paint' 'varnish'
  adjective = 'glossy' 'shiny' 'extra' 'coating'
  sdesc = "shellac on the Manager\'s door"
  ldesc = "The door is thickly covered in glossy shellac. It must be new (or
	   so very thick) because it hasn't started to crack yet. It's
	   disconcerting to see something wood being so reflective. At least
	   it smells nice. "
  smelldesc = "Ah... the soothing aromas of liquified synthetic insect resin.
	       Not as wholesome as the old-fashioned bug pulp they used to use
	       but hey, synthetic varnish is basically the same. Right?"
  touchdesc = "Smooth and velvety like a beautiful women, but hard and cold like a manager. "
  tastedesc = "The door is a crappy substitute for icecream. Well at least you know now... "
;

ManagerToReceptionDoor: Door
  location = ManagersOffice
  noun = 'door' 'west' 'out'
  adjective = 'west' 'manager' 'manager\'s'
  sdesc = "the door leading out of the manager\'s office"
  ldesc = "This door would be the only thing keeping the manager safe from the
	   outside world, if of course the manager were actually here. At the
	   moment, the door is <<self.isopen ? "wide open, letting any old trash
	   from the outside wander in (so it seems)" : "firmly closed, preserving
	   this sanctuary of organization">>. "
  isopen = nil
  isdetermined = true
  islocked = true
  islockable = true
  doordest = ManagersOffice
  otherside = ReceptionToManagerDoor
  key = DummyItem
  noautoopen = nil
  opendesc = "\^<<self.subjprodesc>> <<self.is>> <<self.isopen ? " strangely left open" : "firmly shut">>. "
  openmessage(actor) = { "With a click and a slight creak of protest, the door opens for you. ";}
  closemessage(actor) = { "You push the door and it closes with a satisfied click shut. ";}
  lockmessage(actor) = { "The door locks with a definitive <I>click!</I>. "; }
  unlockmessage(actor) = { "With a slightly resistive click, the door unlocks. "; }
  doClose(actor) = {
    self.closemessage(actor);
    self.isopen := nil;
    if (self.otherside) self.otherside.isopen := nil;
    self.lockmessage(actor);
    self.islocked := true;
    if (self.otherside) self.otherside.islocked := true;
  }
;

ManagersOffice: Room
;

