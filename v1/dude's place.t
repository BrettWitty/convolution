#charset "us-ascii"
#include "adv3.h"
#include "en_us.h"

//----------------//
//  Dude's place  //
//----------------//

// define the '+' property
// (we need this only once per source file)
+ property location;

// Set up some generics first.

dudeRoom : Room
    roomParts = [dudeCarpet, dudeCeiling, dudeNorthWall, dudeSouthWall, dudeWestWall, dudeEastWall]
;

dudeCarpet : defaultFloor
    vocabWords = 'floor/carpet/ground/down/d'
    name = 'carpet'
    desc = "You\'re not quite sure what colour the carpet used to be, but at
	    the moment it\'s a greasy grey. Well, aside from the splotches of
	    dropped food (you guess) and the scorch marks. And the oil
	    splashes. And the curious hardened pool of varnish near the
	    corner. "
;

dudeCeiling : defaultCeiling
    vocabWords = 'up/u/ceiling'
    name = 'ceiling'
    desc = "The ceiling looks pretty ordinary until you notice that it is
	    actually supposed to be white, but is now a cigarette-stained
	    yellow. Oh and the single footprint... Weird... "
;

dudeGenericWall : DefaultWall
    desc = "The walls of this apartment have quite a historical touch to them.
	    At some point they were covered in wallpaper which was
	    half-heartedly torn off, painted over, repainted and left like
	    that for many years. Sticky ghosts of posters and bumper stickers
	    break up this texture, adding to the scratches, scuffs and various
	    small holes. It has a very organic feel to it. "
;

dudeNorthWall : dudeGenericWall
    vocabWords = 'north n northern north/n/wall*walls'
    name = 'north wall'
;

dudeSouthWall : dudeGenericWall
    vocabWords = 'south s southern south/s/wall*walls'
    name = 'south wall'
;

dudeEastWall : dudeGenericWall
    vocabWords = 'east e eastern east/e/wall*walls'
    name = 'east wall'
;

dudeWestWall : dudeGenericWall
    vocabWords = 'west w western west/w/wall*walls'
    name = 'west wall'
;

// The Lounge Room

dudeLounge : dudeRoom
    name = 'Messy Apartment'
    destName = 'the messy apartment'
    desc = "Buried under a bewildering variety of junk are the
	    makings of a lounge room. A clear track winds through
	    the mess to skirt a makeshift shelf before ending at a
	    slightly ragged, stained sofa. A few empty patches act
	    like stepping stones to
	    <<gActor.hasSeen(dudeBedroom) ? 'the bedroom' :
	    'what looks to be a bedroom'>> to the west and a
	    particularly grungy-green bathroom to the southwest. If
	    you take a short skip, you can reach the kitchenette to
	    the south. "
    
    west = dudeLoungeToBedroom
    north = dudeToHallwayDoor
    out asExit(north)
    south = dudeLoungeToKitchen
    southwest = dudeLoungeToBathroom
    in : AskConnector {
	isConnectorListed = nil
	promptMessage = "There are two doorways you can enter. "
	travelAction = GoThroughAction
	travelObjs = [dudeLoungeToBedroom, dudeLoungeToBathroom]
	travelObjsPhrase = 'one'
    }
    enteringRoom(traveler) {
	if(!cody.nameIsKnown)
	    cody.initiateConversation(codySprawledOnSofaTalking,'barged in');
    }
    travelerArriving(traveler, origin, connector, backConnector) {
        foreach (local actor in traveler.getTravelerMotiveActors) {
            if (actor.posture != defaultPosture)
                actor.makePosture(defaultPosture);
	}
	// I've swapped these two lines because it throws Cody off in the original way.
        traveler.describeArrival(origin, backConnector);
        enteringRoom(traveler);
    }
;

+dudeLoungeToKitchen : Passage
    vocabWords = 'south/s/kitchen'
    name = 'kitchen area'
    desc = "Unsurprisingly, the mess doesn\'t stop when it reaches
	    the kitchen. From here you can see the mould and mildew
	    creeping up the walls. If you want to brave it, you can
	    enter the kitchen via the small opening to the south. "
;

+dudeLoungeToBedroom : ThroughPassage, TravelMessage
    vocabWords = 'west western w door/doorway/west/w/bedroom'
    name = 'doorway to bedroom'
    desc = "Just before the lounge room breaks into the kitchen,
	    there are two doorways, one to the west and one to the
	    southwest. The western one you are interested in
	    <<gActor.hasSeen(dudeBedroom) ? 'leads to the bedroom' :
	    'seems to lead to a bedroom'>>. "
    bedroomTravelMsgs : ShuffledList {
	valueList = [ 'You try not to notice patches of the ground squishing underfoot as you make your way to the bedroom. ', 'Something crunches loudly as you mistep slightly. You quickly recover and leap through the bedroom doorway.', 'Just before you put your foot down you notice something small scurry away. You peer around warily before continuing to the bedroom.']
		     }
    travelDesc { say(bedroomTravelMsgs.getNextValue()); }
    cannotOpenMsg = 'There is no door to open---it is just a doorway. '
;

+dudeLoungeToBathroom : ThroughPassage, TravelMessage
    vocabWords = 'far beaded southwest southwestern sw door/doorway/southwest/sw/swest/bathroom/curtain/beads'
    name = 'doorway to bathroom'
    desc = "Just before the lounge room breaks into the kitchen,
	    there are two doorways, one to the west and one to the
	    southwest. The far one you are interested in
	    <<gActor.hasSeen(dudeBathroom) ? 'goes southwest through a beaded curtain, into the bathroom' :
	    'looks like it goes southwest, through a beaded curtain, into some place that looks like a bathroom'>>. "
    bathroomTravelMsgs : ShuffledList {
	valueList = [ 'You take a short leap over a pile of mess and stumble into the damp room beyond. ', 'Skirting the mess on the floor as much as possible, almost kicking your foot on the sofa, you finally make your way into the bathroom. ',  'Steadying yourself with the makeshift bookcase, you manage to avoid most of the junk on the floor and make your way into the bathroom. ', 'After navigating your way through the junk on the lounge room floor, you part the beaded curtain leading into the bathroom. ']
		     }
    travelDesc { say(bathroomTravelMsgs.getNextValue()); }
;

+dudeToHallwayDoor : Door ->firstHallwayToDudeDoor
    vocabWords = 'front north n northern door/doorway/north/n/out/exit'
    name = 'front door'
    desc = "This side of the door hasn\'t fared any better than the
	    other. It too is covered in stickers and scratches.
	    There is even a pen-tattoo of some cartoon character
	    near the door handle. Near the center of the door
	    splinters have burst outwards, as though they had been
	    struck from the other side. You wonder what the landlord
	    thinks about this. <.reveal hackedDoor>"
    initiallyOpen = true
    initiallyLocked = nil
    keyList = []
;

++dudeDoorStickers : Component, Readable
    vocabWords = 'various bumper stickers/banners/stick/bumper/comic/cartoon/stamps'
    name = 'stickers'
    desc {
	if(!described)
	    "Like a college student\'s suitcase gone mad, the door
	     has hundreds of random stickers stuck all over it in a
	     chaotic pattern reminiscent of a shotgun blast. Maybe
	     they deserve a read? ";
	else
	    readDesc;
    }
    readDesc {
	"You cast your gaze over the stickers, trying to find an interesting one.\b ";
	say(stickersDesc.getNextValue());
    }
    stickersDesc : ShuffledList {
	suppressRepeats = true
	valueList = [ 'A round little sticker proclaims: <blockquote><Q>Fugitives and Refugees<BR>-<BR>Portland, OR.</Q></blockquote> ',
		     'On one sticker a jovial black cartoon guy in a beanie yells: <Q>WASSUP!</Q> ',
		     'A tiny little sticker reads: <blockquote>Why are you reading my stickers?</blockquote> ',
		     'A classic Bugs Bunny sticker has been stuck at an odd angle near the splintered center of the door. ',
		     'A mail-out sticker of some anonymous politician hides amongst the other crazy additions. Someone has given him a moustache and devil horns. Someone else has drawn a speech bubble saying: <Q>Moooo!</Q> ',
		     'One of the stickers is an advertisement for a theme park. It reads: <Q><font face=TADS-Sans><font color=PURPLE>Co</font>me a<font color=PURPLE>n</font>d <font color=PURPLE>v</font>isit <font color=PURPLE>o</font>ur <font color=PURPLE>l</font>atest f<font color=PURPLE>u</font>n<font color=PURPLE>t</font>ast<font color=PURPLE>i</font>c ride: the <font color=PURPLE>On</font>slaught!</font></Q> ',
		     'A cute little cherub stands to one side, holding a bloodstained axe. Underneath it reads: <Q>I\'ve been a bad wittle boy</Q> ',
		     'A banner reads: <blockquote><font face=TADS-Script>Thanks for visiting Jeb\'s Steakhouse and Buddhist Monastery, TX</font></blockquote> ',
		     'A cartoon blonde beach bimbo stands naked, cleverly covered by the surfboard she holds under one arm. ',
		     'Near the ceiling is a picture of a comical Jesus riding a skateboard with the caption: <Q>Fo\' sheezy, my Jeezy!</Q> ',
		     'Adjacent to one of the hinges is a stylistic skull and cross-bones. ',
		     'In the lower half of the door is a pair of classic Star Wars stickers rearranged into suggestively lewd positions. ',
		     'Almost hidden by a <Q>VOTE #1 FOR ANARCHY!</Q> bumper sticker is a picture of a wild-eyed pirate above the phrase: <Q>Just a pirate looking for some booty!</Q>',
		     'Your eyes light up when you see what looks to be an authentic sticker from Woodstock! Unfortunately, someone has defaced it by scratching out the \'TO\' with \'U\'. ',
		     'Along the far edge of the door someone has superglued an array of ticket stubs to Crusty Demons \'04. ',
		     'Near the top corner of the door a  bunch of classic smiley faces stickers have been arranged to create a larger frowny face. Weird. ',
		     'Next to a rainbow-coloured peace symbol someone has stuck a stencil of a cannabis leaf.' ]
		     }
    isPlural = true
    codyKnown = true
    owner = cody
;

++dudeDoorCutInside : Component
    vocabWords = 'splintered deep neat wide hack axe hack/wound/cut/hole/splinters/gouge'
    name = 'splinters in the door'
    desc = "Though there should be a better explanation, it looks
	    like someone has punched a narrow hole in the door. The
	    hole doesn\'t go all the way through the door, but
	    rather this thin section has been knocked out and
	    splintered. Weird. <.reveal hackedDoor>"
    codyKnown = true
    owner = dudeToHallwayDoor
;

// I need this special wall for the power socket.
+dudeLoungeNorthWall : dudeNorthWall
    desc = "The lounge room\'s north wall is as dirty and
	    beleaguered as the other walls. The only noticable
	    difference is that it has a (visible) power socket which
	    has the TV has been plugged into it. "
;

++dudeLoungePowerSocket : PowerSocket 'wall electrical power point/socket/plug/outlet' 'electrical socket'
    desc = "This is a standard power outlet. It\'s a little dusty
	    and has a curious scorch mark, but it otherwise
	    functional. It is current switched <<onDesc>>. "
    isOn = true
    attachedObjects = [dudeTV]
    codyKnown = true
    owner = cody
;

+dudeTV : TV
    vocabWords = 'television tv tv/television/box/screen/telly/set'
    name = 'television'
    desc = "Teacher, mother, secret lover. Despite being quite old,
	    the TV holds some sort of respect in this apartment as
	    it seems to be less drowned in junk than the other
	    pieces of furniture. It sits squarely before the sofa,
	    and about a foot or so away from the north wall, where
	    it is plugged in. <<dudeTVAerials.onTVDesc>>
	    <<statusDesc>> "
    initSpecialDesc = "Rising above the clutter of the room is the TV, currently turned <<onDesc>>. "
    specialDesc = "An old-school TV sits here proudly, currently <<onDesc>>. "
    statusDesc {
	if(isOn)
	    "\bCurrently the TV is on channel <<curSetting>>, <<channelName>>. <<channelDesc>> ";
	else
	    "The TV is currently off. ";
    }
    tvPowerSocket = dudeLoungePowerSocket
    attachedObjects = [tvPowerSocket]
    isListedAsAttachedTo(obj) { return nil; }
    isTurnedOn = true
    codyKnown = true
    owner = cody
    curSetting = '2'
    channelName {
	if(!dudeTVAerials.isFixed && !(curSetting == '0'))
	    staticDesc;
	else {
	    switch(curSetting) {

		// The video game/AV channel
		case '0':
		    say('the AV channel');
	            break;

	        // The cooking channel
	        case '1':
	            say('the cooking channel');
	            break;
	    
	        // The sports channel
	        case '2':
	            say('the sports channel');
	            break;
	    
	        // A static channel
	        case '3':
	            say('an untuned channel of static');
	            break;
	    
	        // The news channel
	        case '4':
	            say('the news channel');
	            break;
	    
	        // A static channel
	        case '5':
	            say('an untuned channel of static');
	            break;
	    
	        // A soap opera
	        case '6':
	            say('the soap opera channel showing a Time onto Time marathon');
	            break;
	    
	        // Reality TV channel
	        case '7':
	            say('the reality TV channel');
	            break;
	    
	        // Comedy channel
	        case '8':
	            say('the comedy channel');
	            break;
	    
	        // A static channel
	        case '9':
	            say('an untuned channel of static');
	            break;

		default:
		    say('an untuned channel of static');
		}
	}
    }
    channelDesc {

	// The aerials are all messed up (and we're not on the AV channel). Display static.
	if(!dudeTVAerials.isFixed && !(curSetting == '0'))
	    staticDesc;
	else {
	    switch(curSetting) {

		// The video game/AV channel
		case '0':
		    avChannelDesc;
	            break;

	        // The cooking channel
	        case '1':
	            say(cookingChannel.getNextValue());
	            break;
	    
	        // The sports channel
	        case '2':
	            say(sportsChannel.getNextValue());
	            break;
	    
	        // A static channel
	        case '3':
	            staticDesc;
	            break;
	    
	        // The news channel
	        case '4':
	            say(newsChannel.getNextValue());
	            break;
	    
	        // A static channel
	        case '5':
	            staticDesc;
	            break;
	    
	        // A soap opera
	        case '6':
	            say(soapOperaChannel.getNextValue());
	            break;
	    
	        // Reality TV channel
	        case '7':
	            say(realityTVChannel.getNextValue());
	            break;
	    
	        // Comedy channel
	        case '8':
	            say(comedyChannel.getNextValue());
	            break;
	    
	        // A static channel
	        case '9':
	            staticDesc;
	            break;

		default:
		    staticDesc;
		}
	}
    }

    avChannelDesc = "This channel seems to be for AV. At the moment it is just pure blue. "

    cookingChannel : ShuffledList {
	valueList = ['On it, there is an advertisement for a set of
		      knives that can cut through tables. You wonder
		      if that\'s really what you want in a
		      kitchen... ',
		     'At the moment, some French guy is combining
		      baby octopi, tomatoes, an assortment of
		      mushrooms and some red wine into what he calls
		      <Q>an extravagant surprise for your
		      friends</Q>. ',
		     'At the moment, a guy who looks more crazy
		      scientist than chef extraordinaire is mixing a
		      big bowl of goo saying, <Q>This circular
		      motion is what makes the whole thing
		      worthwhile!</Q> ',
		     'A vacant but pretty young thing is
		      demonstrating the new revolution in blender
		      technology. She smiles famously, but reads
		      like <Q>I turned down Time onto Time for
		      this?</Q> ',
		     'Currently some cockney-English chef is
		      throwing fistfuls of salt into some soup,
		      trying to reassure the viewers that the
		      flavour is worth the heart-attack. ',
		     'Some boxing champion that you\'ve swear
		      you\'ve never heard of is flogging the latest
		      in breakfast conveniences: Toaster Steaks!
		      ']
		 }
    sportsChannel : ShuffledList {
	valueList = ['You see some bleached blonde surfer glide
		      through the aquamarine curl of a tremendous
		      wave, all in slow motion and set to cool
		      music. ',
		     'On it, two muscle-bound boxers mash each other
		      while a drunken crowd scream for murder. ',
		     'The sports presenters take a break from
		      commenting on the 500 lap car race to show
		      some hot women in bikinis. ',
		     'You see a NASCAR racer accidentally swerve too
		      hard and end up in a Hollywood-worthy
		      spectacular accident. ',
		     'At the moment, a bunch of faded sports-stars
		      are discussing the minutiae of a proposed
		      female hockey league. ',
		     'There is a close-up of a furrowed-browed
		      tennis player, awaiting a monster serve. The
		      audience is silent in anticipation. ',
		     'They are showing highlights of the last
		      week\'s football. Some guy takes a tackle that
		      would have felled a lesser man, but he bounced
		      back and dashed back into the play. ' ]
		     }
    newsChannel : ShuffledList {
	valueList = ['Some South American country has been flooded
		      by recent monsoon rains. They show a sad but
		      cute shot of a kid sitting on the roof of his
		      house, surrounded by water. ',
		     'The news presenter remarks, <Q>So if you\'ve
		      ever experienced deja vu, please ring
		      555-8888. And coming up after the break,
		      researchers find a puzzling explosion of deja
		      vu experiences...</Q> ',
		     'In the middle of a dry financial report you
		      catch the reporter saying, <Q>Go to Room
		      777.</Q> When you snap to attention, he is
		      continuing as normal, but you notice a weird
		      glint in his eye that might just be the
		      lighting. ',
		     'On it, you see a report on a recent house
		      fire. The house is utterly engulfed in flames,
		      but there seems to be commotion as someone has
		      been reported to be moving around inside.
		      Creepy. ',
		     'Two news presenters laugh and sigh after the
		      wrap-up from the human interest story. You
		      just raise your eyebrows. ',
		     'At the moment, some slimy politician is
		      denying all wrong-doing while another
		      unashamedly scores a few political points on a
		      touchy issue. ',
		     'The weatherman remarks about chaotic weather
		      to come, influenced by localized conditions.
		      Whatever that means. ']
		     }
    soapOperaChannel : ShuffledList {
	valueList = ['You didn\'t catch the recent development, but
		      two viper-eyed women take turns glaring at
		      each other in close-up. Dramatic music plays.
		      ',
		     'After some shock revelation, the Time after
		      Time logo plays before seguing into some
		      advertisements. ',
		     'On the screen at the moment is a lantern-jawed
		      man lying on a hospital bed. He explains that
		      he had amnesia and didn\'t know what he was
		      doing yesterday. One busty woman forgives him
		      while an evil-looking doctor (complete with
		      greying goatee) frowns in the background.
		      ',
		     'Currently, two women are having a catfight
		      whilst screaming accusations like, <Q>Well at
		      least my illegitimate hermaphrodite child
		      wasn\'t spawned by your Satanic doctor former
		      lover!</Q> You don\'t know what\'s more
		      amazing: the fact that they can sprout such
		      convoluted sentences mid-fight, or that they
		      can keep beautiful and mostly neat despite all
		      the hair pulls, scratches and slaps. ', //'
		      'At the moment, two characters are sharing a
		       romantic evening together on a balcony
		       overlooking a phony night-time cityscape. ',
		     'You see a make-up-drenched middle-aged woman
		      scheming something presumably diabolical. They
		      seem to hold the shot too long and the actress
		      is left in a goofy <Q>evil plot</Q> pose for a
		      beat too long.']
		     }
    realityTVChannel : ShuffledList {
	valueList = ['At the moment a bunch of housemates are
		      sitting around a table discussing something
		      uninteresting. ',
		     'You didn\'t quite catch the intro, but you
		      think some guy is daring random people in the
		      street to eat raw egg. ',
		     'You notice some scene that could be from any
		      reality TV show. Under the overbright lighting
		      and shaky framing, two people try to have a
		      natural-sounding argument whilst ignoring the
		      camera crew. ',
		     'Currently a woman is standing in front of a
		      row of men, trying to look like she is making
		      a very serious decision. ',
		     'Some person is currently waxing philosophical
		      about the fact that he is confined to a house
		      and that his life has become unreal, a facade.
		      It sounds very pseudo-intellectual, but he
		      doesn\'t follow through on any of his thoughts.
		      The beer in his hand probably isn\'t helping. ',
		     'You watch two teams of contestants scramble up
		      a fabricated wooden tower in order to grab
		      some phony-looking statue. The host is
		      commentating as though it was an event at the
		      Life-or-Death Olympics. ',
		     'At the moment, the screen shows an
		      out-of-focus close-up on someone looking
		      decidedly stressed. ']
		     }
    comedyChannel : ShuffledList {
	valueList = ['Someone is trying to impersonate Sean Connery
		      before he is hit in the face with a cream pie. ',
		     'They are showing excerpts from a stand-up
		      routine. The comedian begins with the
		      well-worn, <Q>Didja ever notice how...</Q> ',
		     'A bunch of comedians sit around a table,
		      sharing witty repartee about current events.
		      They close-in on one of the presenters who
		      laughs and stares into the camera, saying,
		      <Q>But seriously, shouldn\'t you be doing
		      something instead of standing around?</Q> Your
		      heart stops for a beat as he glares at you.
		      You blink and the comedians are suddenly
		      chatting up a storm again. ',
		     'Currently a nerdy-looking guy is typing
		      comically on a typewriter as someone slowly
		      sneaks up behind him, wielding a gigantic
		      cartoon mallet. You can see where this one is
		      going. ',
		     'They are showing a sitcom where a bunch of
		      neurotic misfits shack up with their exact
		      opposites. Twenty years ago, this was a comedy
		      goldmine. Nowadays this is stale, but they
		      seem to always try to give it an edge by
		      adding in one or more gay people. You look for
		      better things to check out. ',
		     'The screen shows an empty white hallway. An
		      English businessman enters through a door,
		      peers around and leaves through another door.
		      Moments later, he arrives through yet another
		      door, and then another, becoming increasingly
		      puzzled as he winds a complicated path through
		      the doors. Ah, good ol\' English oddball
		      comedy. ',
		     'At the moment, an overweight, balding man is
		      starring in a parody of some recent pop
		      starlet\'s music video. You don\'t think a
		      short skirt is quite the clothing you\'d
		      prescribe to the guy. ',
		     'A classic cartoon is playing. The Road Runner
		      is being pursued by Wile E. Coyote. The Road
		      Runner suddenly stops and opens a door for
		      Wile E, who promptly shoots through the door
		      in a billow of smoke. A beat later, he looks
		      down and notices the amazing lack of ground
		      beneath his feet. With the appropriate sound
		      effects and stretchy limbs, he falls to a
		      painful end at the bottom of a canyon. ']
		     }
;

++dudeTVAerials : Component
    vocabWords = '(tv) two pointy antenna/antennae/antennas/aerial/aereal/aireal'
    name = 'TV aerials'
    desc = "The TV antenna is pretty old-school; instead of plugging
	    the TV into the wall into one main antenna, you had to
	    use these spindly pieces of metal that had to be
	    adjusted to millimeter precision, or you'd get a fuzzy
	    reception. <<adjustedDesc>> "
    onTVDesc = "Two pointy aerials stick up from the top, <<isFixed
		? 'probably' : 'once'>> aligned to perfection. "
    codyKnown = true
    owner = cody
    adjustedDesc {
	if(isFixed)
	    "They seem to be perfectly aligned at the moment. Try
	     not to make any sudden movements. ";
	else
	    "Someone (who shall go nameless) has messed the
	     reception up. Perhaps you could fix it up. ";
    }
    isFixed = true
    makeFixed(state) {

	isFixed = state;
    }
    dobjFor(Fix) {
	verify() {
	    if(isFixed)
		illogical('The aerials are fine right now. Don\'t mess it up! ');
	}
	action() {

	    // There is a one in three chance of getting it right.
	    if(rand(3)==2) {
		makeFixed(true);
		mainReport('With the gentlest of touches, you adjust the aerial and suddenly the TV comes back to life.');
	    }
	    else {
		makeFixed(nil);
		mainReport('You tweak the aerial up, down, back, and forward, to no avail. You could try again, or be crueal and just leave {the cody/he} to fix it himself. ');
	    }

	    // Add Cody noticing the change
	}
    }
    dobjFor(Feel) {
	verify() {}
	check() {
	    if(!isFixed) {
		"You\'ve messed the reception up enough! ";
		exit;
	    }
	}
	action() {
	    mainReport('You run your hand along the aerial. It suddenly dips and the TV screen erupts into hissing static. You pull your hand back reflexively. ');
	    // Inform Cody
	    makeFixed(nil);
	}
    }
;

+dudeSofa : Chair, Heavy 'blue grey gray blue-gray blue-grey lounge sofa/couch/seat/lounge/chair' 'sofa'
    desc = "Like a rocky outcrop in the middle of the ocean, the
	    sofa juts out of the mess covering the floor. The
	    blue-grey upholstery hasn\'t avoided the stains and
	    damage that the rest of the room has suffered.
	    Nevertheless, the sofa is still in one piece and looks
	    reasonably comfy (if you can align yourself to the
	    ready-made butt grooves). "
    codyKnown = true
    owner = cody
;

/*++dudeSofaSprawled : VNominalPlatform
    name = 'sofa'
    actorInPrep = 'out on'
    postureName = 'sprawled'
;*/

+dudeMakeshiftShelf : Surface, Heavy 'makeshift make shift crappy plain shelf/bookcase/book case/shelves' 'makeshift shelves'
    desc = "This inelegant two-tier shelving unit is the height of
	    makeshift student furnishings.
	    Not-quite-legally-obtained planks of wood are supported
	    by similarly acquired cinder-blocks, creating the
	    perfect storage space for your budget-conscious young
	    resident. \b The shelves are home to tightly packed rows
	    of CDs, a few records and a motley assortment of books. "
    isPlural = true
    codyKnown = true
    owner = cody
    bulkCapacity = 20
    weightCapacity = 20
;

++Decoration 'CD collection compact rows discs/cd/cds/music/collection' 'CD collection'
    desc = "<<cody.nameIsKnown ? 'Cody' : 'This guy'>>\'s CD
	    collection is a grab-bag of recent artists. Flicking
	    through quickly you notice names like CKY, Dub Pistols,
	    Aqua Bats, Reel Big Fish and... oh my golly gosh... an
	    embarrassingly complete collection of Guns `n\' Roses
	    albums! "
    notImportantMsg {
	if(cody.nameIsKnown)
	    return 'Cody wouldn\'t appreciate you making
		       off with his CD collection. Anyway, you don\'t
		       dig his kind of music. ';
	else
	    return 'The guy who lives here wouldn\'t appreciate you making off with his CD collection. Anyway, you don\'t dig his kind of music. ';
    }
;

++Decoration 'few old collectors collection vinyl collection/records/record/vinyl/vinyls/EP/LP/EPs/LPs' 'bunch of records'
    desc {
	"At the far end of the top shelf, a small collection of
	 vinyl records have been propped up against the mini-library
	 of books. You flick through the records, only recognizing
	 one or two of the bands - old classics like Deep Purple and
	 Pink Floyd. ";
	if(!described)
	    "You almost finish looking through them when you notice
	     one sleeveless LP tucked away in between two others, as
	     though it was purposely hidden. You take it out and
	     read the title: <Q>The Weather Girls - It\'s Raining
	     Men</Q>. ";
	else
	    "The conspicuous copy of <Q>It\'s Raining Men</Q> sits at the end of the shelf. ";
    }
;

// The Kitchen

dudeKitchen : dudeRoom
    name = 'Messy Kitchen'
    destName = 'the kitchen'
    desc = "Before <<cody.nameIsKnown ? 'Cody' : 'the guy here'>>
	    moved in, this would have been a small but servicable
	    kitchenette. Over years, he has managed to destroy both
	    of these properties by covering any flat surface in
	    empty pizza boxes and creepy, fuzzy, multi-coloured
	    messes. You swear the fuzzy patch of mould in the corner
	    is watching you.\b Aside from the usual sets of drawers
	    and the sink laden with dirty dishes, a goliath of a
	    refrigerator stands against the back wall, where several
	    more sentient mould could live. If you don\'t want to
	    take any chances, you could make your way to the less
	    organic confines of the lounge room to the north. "
    north = dudeKitchenToLounge
;

+dudeKitchenToLounge : Passage
    vocabWords = 'lounge/north/n/out'
    name = 'lounge room'
    desc = "The lounge room is as messy as the kitchen, but far less organic. Though with enough junk food scraps, stale air and determination, the mould might end up annexing this region to the north. "
    masterObject = dudeLoungeToKitchen
;

+Decoration 'old empty discarded cardboard pizza boxes/box/pizza' 'discarded pizza boxes'
    desc = "Here and there, someone<<cody.nameIsKnown ? ',
	    presumably Cody, ' : ' '>> has scattered a few pizza
	    boxes about the kitchenette. They aren\'t even in a
	    pile, or even uniformly closed. The open ones present
	    artifacts of once-present pizzas: rubbery cheese,
	    splotches of sauce and a roughly circular print of
	    grease. You couldn\'t guess how long they have been
	    hanging around, but you never were a forensic historian.
	    "
    notImportantMsg = 'For safety reasons, it\'s best to leave the pizza boxes alone. '
;

+Decoration 'sentient fuzzy green multi-coloured coloured colored mouldy living thinking creepy spots/patch/mould/mildew/mess/messes' 'mould'
    desc = "If this wasn\'t a place of food preparation (at least in
	    intention), then the spots of fuzzy mould could almost
	    be decorative. But since it theoretically <i>is</i> a kitchen,
	    these <q>decorations</q> are revolting. You feel uneasy
	    being surrounded by these patches of growth. You
	    wouldn\'t be surprised if they conspired together at
	    night, hatching evil schemes of apartment domination. "
;

//********
// IMPLEMENT AN INSIDE TO THE FRIDGE!
// ALSO ADD FLAVOUR TEXT WHEN OPENING DOOR!

+codyRefrigerator : Refrigerator
    vocabWords = 'goliath massive big heavy large bomb-proof bomb proof fridge/refrigerator/refridgerator/cooler'
    name = 'refrigerator'
    desc = "<<cody.nameIsKnown ? 'Cody' : 'The guy who lives here
	    '>> must have picked up this old relic at a garage sale
	    or improperly acquired it from a junkyard; it seems to
	    be one of those bomb-proof goliaths from the Sixties.
	    You imagine an advertisement explaining that in the
	    event of an atomic bomb attack from those Sneaky Reds,
	    you should get in the refrigerator for safety.
	    Ironically, there is a nuclear hazard sticker plastered
	    to the fridge door. This is the only decoration on the
	    door, unless you count scratches, chipped paintwork and
	    rust stains as decorations. "
    lookInDesc = "The fridge\'s motor whines tiredly with the burden
		  of the open door letting out the only slightly
		  cool air inside. Three wire racks would hold food
		  if there were any. "
    codyKnown = true
    owner = cody
;

++ ContainerDoor '(refrigerator) (fridge) (refridgerator) door' 'refrigerator door' "The refrigerator door is almost two inches thick and is made out of bulky, curved steel. The handle protrudes out sharply and squarely. Running into the handle could be quite dangerous. Ah... they don\'t make them like this any more... "
    hideFromAll(action) { return true; }
;

++Component '(door) square sharp handles/handle' 'door handle to the refrigerator' "Jutting out of the fridge door is a steel handle, all sharp, straight lines and corners. It\'s a very Sixties design. "
    hideFromAll(action) { return true; }
    dobjFor(Pull) remapTo(Open,self.location)
    dobjFor(Push) remapTo(Close,self.location)
;


// The Bathroom

dudeBathroom : dudeRoom
    name = 'Bathroom'
    destName = 'the bathroom'
    desc = "Although it doesn\'t have any of the clutter of the
	    other rooms, the bathroom is nonetheless covered in a
	    thin film of brown-green grime and mildew. It has been
	    outfitted with usual bathroom additions: a shower/bath
	    combination, a toilet, a sink and a medicine cabinet.
	    Everything is speckled with grime and condensation. The
	    place isn\'t disgusting - it just needs a few hours of
	    elbow grease and commercial-grade cleaning products. \bA
	    beaded curtain leads north to the lounge room. "
    brightness = 0
    enteringRoom(traveler) {

	// Automatically turn on the lights
	if(dudeBathroomLight.isOn)
	    "You peer through the curtains and adjust your gaze to
	     the garish bleached light of the bathroom. ";
	else {
	    "Squinting in the dark, you pat the wall looking for a
	     light switch. Soon enough, you find it and are
	     assaulted by the harsh white light reflecting off
	     grime-caked tiles. ";
	    dudeBathroomLight.makeOn(true);
	}
    }
    north = dudeBathroomToLounge
    out asExit(north)
    northeast asExit(north)
;

+dudeBathroomToLounge : ThroughPassage ->dudeLoungeToBathroom
    vocabWords = 'north/n/out/lounge/ne/northeast'
    name = 'doorway to the lounge room'
    desc {
	if(dudeBathroomLight.isOn)
	    "Beyond the grunge and bleached light of this room,
	     through the doorway to the north, lies the much more
	     sedate and cluttered lounge. ";
	else
	    "Stale grey light wafts in from the lounge to the north. ";
    }
;

+dudeBathroomLight : Fixture '(bathroom) harsh bleached white ceiling light/lights/fixture/bulb' 'bathroom light'
    desc {
	if(brightness == 3)
	    "The light fixture doesn\'t have a cover and so the
	     harsh light from the over-powerful bulb is painful,
	     especially in a room full of white tiles. Luckily the
	     grime absorbs some of the light. ";
	else
	    "For some odd reason, the wire in the light bulb is
	     still glowing faintly. You guess faulty wiring or
	     something. ";
    }
    dobjFor(TurnOn) remapTo(TurnOn,dudeBathroomLightSwitch)
    dobjFor(TurnOff) remapTo(TurnOff,dudeBathroomLightSwitch)
    brightness = 3
;
    
+dudeBathroomLightSwitch : Switch, Fixture 'light switch/control/controls/button' 'light switch'
    "The bathroom light switch is one of those old-style switches
     with the tiny knob set in a round doorbell-like casing. It is
     currently switched <<isOn ? 'on' : 'off'>>. "
    makeOn(val) {
	dudeBathroomLight.brightness = ( val ? 3 : 1);
	if(val)
	    "You switch on the lights and are immediately drenched in the harsh bathroom light. ";
	else
	    "With a click the room is plunged into darkness. ";
	inherited(val);
    }
    isOn = true
;

+Decoration 'beaded curtain/doorway/beads' 'beaded curtain'
    "You thought beaded curtains died out when they rounded up the
     last hippies and declared the Cold War over. These beads are
     dull brown beads of alternating sizes, but you\'ve seen more
     psychedelic colour schemes used elsewhere. "
;

+dudeMedicineCabinet : Fixture 'medicine cabinet/cupboard/chest/mirror' 'medicine cabinet'
    "UNIMPLEMENTED YET. "
;

+dudeToilet : Chair, Fixture
    vocabWords = 'toilet/dunny/potty/john/lav/lavatory/latrine/loo/can'
    name = 'toilet'
    codyKnown = true
    owner = cody
    desc {
	if(described)
	    "Having to live to tell the tale last time, you inhale
	     and inspect <<cody.nameIsKnown ? 'Cody\'s ' : 'the '>>
	     toilet again. You\'re thankful <<cody.nameIsKnown ? 'he
	     hasn\'t left any revolting surprises for you. ' : 'it
	     doesn\'t contain any revolting surprises for you. '>>
	     Nevertheless, the toilet needs to be attacked by
	     someone with a good scrubbing brush and a brave heart.
	     There is no way that you are that guy. ";
	else
	    "Taking curiosity to an extreme sports level, you take
	     an apprehensive but hasty look at <<cody.nameIsKnown ?
	     'Cody\'s ' : 'the'>> toilet. Surprisingly, it\'s not
	     too bad. In the flash inspection you noticed the
	     build-up of grime creeping up the bowl, yellowed by the
	     stale, unclean water washed over it. You are thankful
	     that there wasn\'t anything else in the bowl, but
	     still, you have to swallow the distaste a few times
	     before you can press on. ";
    }
    smellDesc = "Though you don\'t pursue it too far, the toilet
		 doesn\'t smell like anything but stale. "
    feelDesc = "The tank area of the toilet is dusty and cold. You
		dare not touch any other part. "
    tasteDesc = "One of the things you have agreed with yourself is
		 that you wish to die a noble death. Tempting fate
		 by licking the toilet is in disagreement with this
		 maxim. "
    dobjFor(Clean) {
	verify(){}
	check(){
	    "You peer at the dusty toilet brush to the side and then
	     at the toilet. The words, <q>Not for a thousand
	     dollars</q> come to mind. ";
	    exit;
	}
    }
    dobjFor(SitOn) {
	verify() {}
	check() {
	    "Given the state of the toilet, you decide to wait for a
	     better option. ";
	    exit;
	}
    }
    dobjFor(Flush) {
	verify() {
	    logicalRank(150,'is flushable');
	}
	action() {
	    "You apprehensively push the button down on the toilet
	     and step back, just in case. The toilet hisses and
	     gurgles but doesn\'t seem any cleaner. ";
	    // Notify Cody
	}
    }
    iobjFor(PutIn) {
	verify() {}
	check() {
	    if(gDobj == me)
		"Matyring yourself in this way is completely
		 unnecessary and fruitless. ";
	    else
		"You\'d prefer to keep {that dobj/him} rather than
		 sacrifice it to this porcelain grime-beast. ";
	    exit;
	}
    }
;

++Component '(toilet) seat/lid' 'toilet seat'
    "The toilet seat itself looks okay, although your stomach tells
     you not to test that theory with detailed inspection. "
    isUp = true
    dobjFor(Lower) {
	verify() {
	    if(!isUp)
		illogicalNow('The seat is already down. ');
	}
	action() {
	    mainReport('Reluctant to actually touch it, you try
			tapping the seat briefly to make it fall.
			Only after many gentler attempts do you
			actualy hook it and pull it closed. You pull
			your finger back in digust and try to shake
			the germs off it. ');
	    isUp = nil;
	}
    }
    dobjFor(Raise) {
	verify() {
	    if(isUp)
		illogicalNow('The seat is already up. ');
	}
	action() {
	    mainReport('Using just the tip of a fingernail, you
			flick the toilet seat up. It clacks against
			the back of the toilet, but luckily does not
			fall back down. Your finger feels
			contagiously dirty, so you wipe it roughly
			against your shirt. ');
	    isUp = true;
	}
    }
    dobjFor(Clean) {
	verify() {}
	check() {
	    "Your inner germaphobe strongly disagrees.<.p>It\'s probably safer
	     to go with him. ";
	    exit;
	}
    }
;

+Decoration '(toilet) brush/cleaner/wand' 'toilet brush'
    "Like a rifle stored away after the war is lost, the toilet
     brush hides behind the toilet, covered in dust and drooping
     with embarrassment. "
    notImportantMsg = 'You have no need (or desire) for the toilet brush. Leave it be. '
    codyKnown = true
    owner = cody
;

+Fixture '(bathroom) grimy grimey dirty grime/tiles' 'bathroom tiles'
    "Originally, the tiles adorning the walls were plain, white
     squares with bleached white mortar, with half-inch tiles
     coloured in various shades of blue across the floor. Now the
     wall tiles are slightly grey with dust set with condensation,
     mottled with the occasional creeping grime. In places near
     water pipes, the mortar has turned a dark orange from rust
     leaks. The floor tiles have moved towards a more homogeneous
     charcoal-blue, the original colours only shining through along
     the traffic marks. "
;

+dudeBathroomSink : Fixture
    vocabWords = '(bathroom) wash sink/faucet/basin/washbasin/tap/taps'
    name = 'bathroom sink'
    desc = "Directly underneath the medicine cabinet, a sink sits
	    (in the traditional manner). The sink itself is
	    unremarkable, decorated only with stray shaven facial
	    hairs and a dribble of rusty water from one of the taps.
	    "
    turnedOnBefore = nil
    codyKnown = true
    owner = cody
    dobjFor(TurnOn) {
	verify() {}
	check() {}
	action() {
	    if (!turnedOnBefore) {
		mainReport('You twist the faucet and suddenly the whole sink
		 groans and vibrates, stuttering and spitting out a
		 dirty spray of water. Reflexively, you rush to turn
		 it off. It settles down and the shuddering
		 disappears into the wall through the pipes. You
		 peer warily at the sink and decide to leave it
		 alone, just in case it takes the building with it
		 next time. ');
		turnedOnBefore = true;
	    }
	    else
		mainReport('After the drama last time, you think it\'s best to
		 leave the sink alone. ');
	}
    }
;

++Decoration 'stray shaven facial hairs/hair' 'facial hair'
    "Scattered about the sink and gathered around its crevices, are
     a few light sprinklings of hair (from shaving you assume). They
     only add to the <q>grotty single man</q> motif in this place."
;

+dudeShower : Openable, Booth, Fixture
    vocabWords = 'shower shower/bath/cubicle'
    name = 'shower'
    desc = "A simple cubical shower sits in the corner. The sides
	    are (mildewy) frosted glass. "
    interiorDesc = "The narrow shower is extremely utilitarian. And
		    in need of a clean. Patches of mildew creep out
		    from the grout in the tiles and spread out over
		    the frosted glass. Above you is a shower head,
		    and below it (as expected) there are two taps. "
    openStatus = (isOpen ? "The shower door is open" : "The shower door is currently closed" )
    roomName = ('In ' + theName)
    allowedPostures = [sitting, standing]
    obviousPostures = [sitting, standing]
    defaultPosture = standing
    codyKnown = true
    owner = cody
    okayOpenMsg = 'With a little bit of jiggling, the door swings open. '
    okayCloseMsg = 'You push the glass door shut, forcing it over a rough patch in the frame. '
    basicExamine() 
    { 
      if(gActor.isIn(self) && gActor.canSee(self)) 
        interiorDesc; 
      else 
        inherited;        
    }
;

++Fixture 'shower head/outlet' 'shower head'
    desc {
	"The shower head is the standard adjustable metal head that
	 you can buy at your hardware store for a few dollars. ";
	if(hasBeenAdjusted)
	    "It is now at your head height. ";
	else
	    "It has been set a little low, compared to your height. ";
	if(dudeShowerTaps.hasBeenTightened)
	    "Someone hasn\'t turned it off properly so it drips occasionally. ";
    }
    hasBeenAdjusted = nil
    dobjFor(Fix) {
	verify() {}
	check() {
	    if(hasBeenAdjusted) {
		"The shower head is at the right height now. Well,
		 right height if you were to have a shower, which
		 you probably won\'t. ";
		exit;
	    }
	}
	action() {
	    "You push the shower head up and tighten the screw at
	     the base so that it is the right height for you. Not
	     that you\'re going to have a shower anyway. ";
	    hasBeenAdjusted = nil;
	}
    }
    dobjFor(TurnOff) remapTo(TurnOff,dudeShowerTaps)
    dobjFor(TurnOn) remapTo(TurnOn,dudeShowerTaps)
;

++dudeShowerTaps: Fixture '(shower) two white plastic taps/faucets/faucet/tap/controls/dials/control/dial' 'shower taps'
    "These two white plastic taps control the flow of water from the
     shower head above, as expected. "
    hasBeenTightened = nil
    dobjFor(TurnOn) {
	verify() {}
	check() {
	    "You don\'t need a shower right now, nor do you need to
	     be slapping about like a sodden mess, so you decide to
	     leave the shower turned off. ";
	    exit;
	}
    }
    dobjFor(TurnOff) {
	verify() {}
	check() {
	    if(hasBeenTightened) {
		"You've tightened this tap as far as you could
		 without running the risk of breaking it. ";
		exit;
	    }
	}
	action() {
	    "You twist the two taps until the shower head stops
	     dripping. You should wear a <Q>Mr Fixit</Q> badge. ";
	    hasBeenTightened = true;
	}
    }
    codyKnown = true
    owner = cody
;

NameAsOther, SecretFixture targetObj = dudeShower location = dudeBathroom; 

+ContainerDoor '(shower) door' 'shower door'
    "The frosted glass door is fringed with a tarnished copper trim.
     A small crack wiggles across the bottom-right part of the
     glass. "
    subContainer = dudeShower
; 

++Component '(shower) thin small wiggly crack' 'crack in the shower door'
    "A thin crack has sliced its way across the bottom-right corner
     of the glass door. The frame prevents the loose glass to fall
     out. "
    owner = (location)
;

// The Bedroom

dudeBedroom : dudeRoom
    name = 'Bedroom'
    destName = 'the bedroom'
    desc = "The lack of natural light coming in and the general
	    messiness lends the room a rather dull appearance. A few
	    scattered posters decorate the walls around the unmade
	    bed. An unpleasant but unplaceable stale smell hangs in
	    the air. "
    east = dudeBedroomToLounge
    out asExit(east)
    southeast asExit(east)
;

+dudeBedroomSmell : SimpleOdor 'unpleasant unplaceable unplacable weird stale smell/odour/odor' 'stale smell'
    "You\'re not sure what it is, but it\'s best you don\'t try to
     find out. Terror leads that way. "
;

+dudeBedroomPosters : Fixture 'scattered rock suicidegirls girl band posters/poster/sign' 'posters on the wall'
    "A handful of posters have been stuck to the walls here at odd
     angles. One is a picture from behind a rock band, staring out
     into a pink-and-purple-lit crowd. Another is a skier hanging in
     mid-air over an icy crevasse. Near the foot of the bed is a
     poster of a scantily-clad punk/goth girl. "
;

+dudeBed : Heavy, ComplexContainer
    vocabWords = 'messy cluttered bed/sheets'
    name = 'messy bed'
    desc = "Unsurprisingly, <<cody.nameIsKnown ? 'Cody\'s ' : 'this
	    guy\'s '>> bed is unmade and looks like it hasn\'t been
	    for quite some time. The sheets have a sweaty yellowness
	    to them. His mother better be dead, because if she saw
	    this... "
    owner = cody
    codyKnown = true
    subUnderside : ComplexComponent, Underside {
	bulkCapacity = 100
	weightCapacity = 1000
    }
    subSurface : ComplexComponent, Surface {
	bulkCapacity = 500
	weightCapacity = 200
    }
;

++Thing 'soft smelly grubby lumpy odoriferous comfortable pillow' 'pillow'
    "This specimen is par for the course - grubby, lumpy and
     odoriferous. Nevertheless, it could easily be a comfortable
     pillow if you were used to it. "
    codyKnown = true
    owner = cody
    subLocation = &subSurface
    initSpecialDesc = "An unwashed pillow lies askew at the end of the bed. "
    feelDesc = "The pillow has a slightly greasy feel to it, as if
		it hadn\'t been washed in ages... Imagine that. "
    smellDesc = "You take a tentative whiff of the pillow. It has a
		 slight sweaty, stale odour to it. For some reason
		 you also notice a musty beer smell. "
    okayTakeMsg {
	if(moved)
	    return 'Summoning up the courage, you pick up the pillow again. ';
	else
	    return 'You cringe and hesitate a moment before quickly grabbing the pillow. ';
    }
    dobjFor(Take) {
	action() {
	    /* Swapped the lines around for my custom okayTakeMsg */
            defaultReport(&okayTakeMsg);
	    moveInto(gActor);
	}
    }
    bulk = 50
    weight = 5
;

++codySkis : Immovable 'dusty sport pair/skis' 'dusty pair of sports skis'
    "<<gActor.setHasSeen(self)>> Wedged in the clutter is a dusty
     pair of sports skis. All the precise bevelling, heavy duty
     grips and detailed construction indicate that these may be a
     professional set. The finish is smooth (if dusty) and it has a
     cool flame motif. But what\'s bewildering is how it seems to be
     firmly (but impossibly) wedged under the bed. It\'s as if they
     had placed the bed down on the positioned skis, intentionally
     trapping them there. Weird. "
    codyKnown = true
    owner = cody
    suppressAutoSeen = true
    hideFromAll(action) { return true; }
    subLocation = &subUnderside
    cannotTakeMsg { return skisStuckMsg.getNextValue(); }
    cannotPutMsg { return skisStuckMsg.getNextValue(); }
    cannotMoveMsg { return skisStuckMsg.getNextValue(); } 
    skisStuckMsg : ShuffledList {
	valueList = [ 'Try as you might, you can\'t seem to wiggle
		       the skis free. ',
		     'You grunt, trying to shift some of junk out of
		      the way and loosen up the skis. They seem
		      stuck fast. ',
		     'Even after shifting junk and jiggling the
		      skis, you just can\'t seem to make them budge.
		      ',
		     'After a few futile attempts, you realize the
		      skis are stuck, doomed to eke out an existence
		      amidst the junk and smelly clothes. ' ]
    }
;

++dudeUnderBedJunk : Immovable 'dirty smelly discarded junk/clothes/stuff' 'junk'
    "Unsurprisingly, underneath <<cody.nameIsKnown ? 'Cody\'s ' :
     'this guy\'s '>> bed is a wasteland of junk and smelly
     clothing. A pair of skis pierce through the grubby mess. In any
     case, most of this stuff is worthless or so revolting, you
     wouldn\'t touch it on a dare! "
    specialDesc = "An assortment of junk sticks out from underneath the bed. "
    subLocation = &subUnderside
    isMassNoun = true
    codyKnown = true
    owner = cody
    dobjFor(Search) {
	verify() {}
	check() {
	    if (dudeUnderBedNote.moved) {
		"Although you haven\'t scrutinized everything under
		 the bed, you feel that the rest is useless and
		 what\'s more, feeling through that mess could be
		 hazardous. In other words, your priority for
		 getting your hand back is much higher than finding
		 another smelly pair of underpants. ";
		exit;
	    }
	}
	action() {
	    "You gingerly poke through the junk, wondering if
	     you\'ll have to heat-treat your hand afterwards, when
	     your roaming hand comes across a piece of card stuck to
	     the underside of the bed. You peer at it for a second
	     and then peel it off. Turning it over in your hands,
	     you notice that it is remarkably clean and undamaged
	     for something braving those depths. One side is
	     completely blank except for a smudge of sticky residue,
	     while the other has a single line of writing on it. ";
	    dudeUnderBedNote.moveInto(gActor);
	}
    }
;

+dudeBedroomToLounge : ThroughPassage ->dudeLoungeToBedroom
    vocabWords = 'lounge east eastern e southeast southeastern se hinges/door/doorway/east/southeast/south-east/se/e/out/lounge'
    name = 'doorway to the lounge'
    desc = "A bare doorway leads out into the lounge room.
	    Curiously, the doorway has no door. You spy imprints of
	    where the hinges used to be, but it appears that someone
	    has completely removed the door. "
    cannotOpenMsg = 'There is no door to open---it is just a doorway. '
;
