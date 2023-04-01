/*
 *  THE DUMMY OBJECT
 *  You can't get it, you'll never see it. Good for being a surrogate key for doors that should remain locked.
 */
DummyItem: Thing
  noun = 'DUMMYITEM'
  sdesc = "dummy item"
  ldesc = "If you're reading this, you are making Baby Jesus cry."
;


/*
 *  Floor waxer
 *  Needs code to run when turned on
 */
FloorWaxer: Item, Switch
  location = JanitorCloset
  noun = 'waxer' 'buffer' 'machine'
  adjective = 'floor' 'waxing'
  sdesc = "floor waxing machine"
  ldesc = "This is the exceptionally fine WaxMaster 9000, as seen on TV!"
;

/*
 *  The Janitor\'s Key
 *  Should I add a keyring: Part ?
 */
JanitorKey: Key, Item
  location = Vern
  noun = 'key'
  adjective = 'janitor' 'janitor\'s' 'steel'
  sdesc = "<<self.isdetermined ? "a key" : "the janitor\'s key">>"
  ldesc = "The key is a small, steel key on a keyring. There is a tag with the
	   words \"Vern (Janitor)\". "
  isdetermined = nil
  islistable(actor) = {
    if (self.isin(Vern))
      return nil;
    else
      return true;
  }
  doInspect(actor) = {
    self.isdetermined := true;
    pass doInspect;
  }
;

/*
 *  Creepy little scrap of paper given to you initially.
 *  Add tear/rip and crumple verbs?
 */
Scrap1: Readable, Item
  location = Me
  noun = 'scrap' 'paper' 'note' 'memo'
  adjective = 'scrap' 'crumpled' 'crumpled up'
  sdesc = "crumpled up scrap of paper"
  ldesc = "It appears to be a scrap of paper, hastily torn from a notebook and
	   then crumpled up. There is some scribbled writing on one side."
  readdesc = { "The writing looks to be dashed off quickly. It reads: \"Get out!
	      Save yourself!\"\b <<self.isread ? "" : "Ooookaay.">> "; self.isread := true;}
  isread = nil
;

/*
 *  Bowl of fruit
 *  The bowl of fruit that looks like a samurai's helmet under the right lighting
 */
BowlOfFruit: Container
  location = Reception
  noun = 'bowl' 'bowl of fruit' 'fruit'
  adjective = 'metal'
  sdesc = "bowl of fruit"
  ldesc = 
  {

      "The bowl does what its meant to - hold fruit, that is. However, under
       the right light, it has a pseudo-militaristic/Japanese style to it. ";

      pass ldesc;
  }
;


/*
 *  Banana
 *  Add a peel verb which effectively spoils the banana after a short while?
 */
Banana: Edible
  location = BowlOfFruit
  noun = 'banana' 'nana'
  adjective = 'ripe' 'yellow'
  sdesc = "ripe banana"
  ldesc = "Stuffed full of healthy Vitamin B, this banana would be a great
	   snack! "
  eatdesc(actor) = "Mmmm... That was delicious! "
  doEat(actor) = {

    if (actor = Me)
	self.eatdesc(actor);
    else ;

    // Spawn the banana peel
    BananaPeel.moveInto(self.location);
    self.movein(nil);
  }
;


/*
 *  Banana peel
 *  Pulled in to replace an eaten banana
 */
BananaPeel: Item
  noun = 'peel' 'skin' 'banana'
  adjective = 'banana'
  sdesc = "banana skin"
  ldesc = "Devoid of any banana-goodness, this skin may have no use at all. "
;


/*
 *  Apple
 *  An ordinary ol' apple
 */
Apple: Edible
  location = BowlOfFruit
  noun = 'apple'
  adjective = 'red'
  sdesc = "juicy, red apple"
  ldesc = "What a gorgeously red and crisp-looking apple. It looks so
	   inviting... (Wait, didn't that get someone into trouble before?) "
  doEat(actor) = {

    if (actor = Me)
      "You crunch your way through the delicious apple to the core. ";
    else ;

    // Spawn the apple core
    AppleCore.moveInto(self.location);
    self.moveInto(nil);
  }
;


/*
 *  Apple Core
 *  Replaces the apple if eaten
 */
AppleCore: Item
  noun = 'core' 'apple'
  adjective = 'apple'
  sdesc = "apple core"
  ldesc = "The remains of a once-juicy apple. "
  adesc = "an apple core"
;


/*
 *  Crowbar
 *  Used for various jimmying things. Add in verbs pry, jimmy? Modify open with, pull with?
 */
Crowbar: Item
  location = JanitorCloset
  noun = 'crowbar' 'bar'
  adjective = 'iron'
  sdesc = "iron crowbar"
  adesc = "an iron crowbar"
  ldesc = "The strong sense of solidity, weight and purpose gives the crowbar
	   an aura that most other bars of metal don't. Some people go their
	   whole lives without hefting one of these guys in their hands and
	   feeling that tingle of criminal power. You will not be one of them."
;

/*
 *  Envelope
 *  Found between the chains of the front door, and contains a creepy letter.
 */
Envelope: Openable, Item
  location = EntranceDoors
  noun = 'envelope'
  adjective = 'creepy' 'stylish' 'elegant' 'ivory' 'bone'
  sdesc = "stylish envelope"
  ldesc = "It is a very elegant envelope. It is made out of an ivory-hued card
	   (or is that bone-white?) On the front there is an embossed design
	   and the back is plain with <<self.isopen ? " the envelope flap left open" : " the envelope flap tucked
           neatly in">>. The whole package feels very refined and crisp in your hands. "
  verDoTake(actor) = {

    // So very kludgy... If they haven't seen the envelope, make them check out the doors first.
    if (EntranceDoors.seenenvelope = nil)
      "You see no envelope here. ";
  }
;

/*
 *  Design on the envelope
 *  The famous Celtic knot design with C.T.
 */
EnvelopeDesign: Part
  partof = Envelope
  noun = 'design' 'crest' 'emblem' 'symbol' 'knot'
  adjective = 'envelope' 'embossed' 'paper' 'small' 'maddening'
  sdesc = "the embossed design on the envelope"
  ldesc = "The embossed design is an intricate Celtic knot framing the
	   initials \"CT\". The knot has a maddening complexity to it - the
	   strands weave over and under and you don't know if there is one
	   strand or many, nor if the knot has any ends that you can see. "
  isdetermined = true
;

/*
 *  The maddening letter
 *  A letter to help the plot along
 */
Letter: Readable, Item
  location = Envelope
  noun = 'letter' 'paper' 'message'
  adjective = 'elegant'
  sdesc = "<<self.beenread ? "letter addressed to you" : "professional-looking letter">>"
  ldesc = "Something is definitely off-putting about the letter. It has been
	   printed immaculately (almost mechanically) on professional
	   onion-skin paper, closed with three sharp, neat folds. The letter
	   itself is as deliberate as the presentation --- three punchy lines
	   of text with no signature. Most intriguingly, it's addressed to
	   you. "
  readdesc = "You unfold the letter and notice immediately it has been
	      addressed to you. You read further:\b\b\b\t Now that you are up
	      and about, you are invited to see us upstairs to try again to
	      resolve this matter.\b\t Room 808.\b\b\b What the hell? Resolve
	      what matter? Why don't they just let you out of here? You fold
	      up the letter and put it away, shaking your head in disbelief. "
//
// I wanted some variation on "You try to swallow the bitter taste in your mouth." and something about a sinking feeling in your stomach.
//
  doRead(actor) = {
    self.readdesc;
    if (self.beenread = nil)
      fullAdd(5,'reading the weird letter');
    self.beenread := true;
  }
  beenread = nil
;

/*
 *  The old folk's mail
 *  Found in one of the mailboxes
 */

/*
 *  Opened package
 *  Initially holds the hint box.
 */
HintBookPackage: Readable, Qcontainer, Item
    location = StartRoom
    noun = 'box' 'package'
    adjective = 'open' 'opened'
    sdesc = "opened package"
    adesc = "an opened package"
    hdesc = {
	if (HintBook.isin(self))
	    "An opened parcel, alone from the others, sits near your feet. A hint book seems to be sticking out of it. ";
	else
	    "A lonely, empty, and opened parcel lies to one side. ";
    }
    ldesc = {
	"The <<self.isoverturned ? "overturned" : "">> package is a sturdily built cardboard box emblazoned with the \"HintCo\" logo. ";
	if (HintBook.isin(self))
	    "A futuristic-looking book is half buried amongst the polystyrene packing peanuts. ";
	if (self.isoverturned)
	    { if (HintBook.location = self.location)
		  "Amongst the spray of polystyrene peanuts lies an electronic notebook, face-down. ";
	      else
		  "A spray of polystyrene peanuts lie scattered around the box. ";
	  }
    }
    isoverturned = nil
;

// Old folks' keys



// Door chock


// Swipe card


// Cookies


// Jill's wet towel


// Black towel


// White towel


// Green towel


// Key to level 3 & 4


// TRS-80


// Masterpieces of Infocom


// IF Hint manual


// Love note from Jill


// Hammer


// Nutcracker


// Crowbar


// Locked metal box


// Coins


// Big wad of cash


// Bunch of bananas


// Oil can


// Mannequin


// Shotgun shells


// Samurai jacket


// Ham


// Cheese


// Lettuce


// HCL sandwich


// Beer can


// Hairdryer


// Extension cord


// Antique statuette


// Autumn leaf picture


// Noodles


// Pizza


// Fork


// Phony police badge
