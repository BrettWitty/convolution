#charset "utf-8"
#include <adv3.h>
#include <en_us.h>

// Books! Books! Books!
// The book list:
// - Simulations and Simulacra
// - Plato's Parable of the Cave?
// - Mathematics text ("Potter's Mathematical Encyclopaedia")
// - Some quantum book?
// - Some books on art and aesthetics

jeanBaudrillard : Actor
    vocabWords = 'jean baudrillard'
    name = 'Jean Baudrillard'
    pcKnows = (simulacraBook.pcKnows)
    pcSeen = (simulacraBook.pcSeen)
;
    
simulacraBook : Book
    vocabWords = 'simulacra simulations simulation simulacra/book*books'
    name = 'Jean Baudrillard\'s Simulacra and Simulation'
    location = lockedStudyDesk
    subLocation = &subSurface
    author = 'Jean Baudrillard'
    bookTitle = 'Simulacra and Simulation'
    owner = jeanBaudrillard
    desc = "This green leather-bound copy of <Q>Simulacra et
	    Simulations</Q> is plain, but reasonably impressive.
	    However, upon opening the book, it is evident that the
	    original copy was a paperback, rebound to fit in with
	    the decor of the library. The fine taste in presentation
	    makes way for bitter irony. "
    isQualifiedName = true
    readDesc { standardSections.doScript(); }
    standardSections : StopEventList {
	eventList = ['Glancing through the book, the author seems to
		      talk about sign and signified, simulacra,
		      simulation, realism and all these other
		      philosophic words. You\'re not sure if you\'re
		      able to read it without your head exploding.
		      But, as they say, you only live once. ',
		     'You turn to some page near the front, and
		      read: <BQ><Q>So it is with simulation, insofar
		      as it is opposed to representation. The latter
		      starts from the principle that the sign and
		      the real are equivalent (even if this
		      equivalence is utopian, it is a fundamental
		      axiom). Conversely, simulation starts from the
		      <i>utopia</i> of this principle of
		      equivalence, <I>from the radical negation of
		      the sign as value</I>, from the sign as
		      reversion and death sentence of every
		      reference. Whereas representation tries to
		      absorb simulation by interpreting it as false
		      representation, simulation envelops the whole
		      edifice of representation as itself a
		      simulacrum.</Q></BQ> Huh?', 
		     'You flick through randomly, finding some
		      passage that catches your eye: <BQ><Q>The
		      great simulacra constructed by man pass from a
		      universe of natural laws to a universe of
		      force and tensions of force, today to a
		      universe of structures and binary oppositions.
		      After the metaphysic of being and appearance,
		      after that of energy and determination, comes
		      that of indeterminancy and the
		      code...</Q></BQ>You have no idea what he\'s
		      saying, but it sounds impressive. ',
		      'You read a little further... <BQ><Q>At this
		       level the question of signs, of their
		       rational destination, their real or
		       imaginary, their repression, their deviation,
		       the illusion they create or that which they
		       conceal, or their parallel meanings&mdash;all
		       of that is erased. We have already seen signs
		       of the first order, complex signs and rich in
		       illusion, change, with the machines, into
		       crude signs, dull, industrial, repetitive,
		       echoless, operational and
		       efficacious...</Q></BQ> Reading this is
		       starting to hurt your head.',
		       'You riffle through the pages to somewhere
			near the end. You read: <BQ><Q>The hyperreal
			represents a much more advanced phase, in
			the sense that even this contradiction
			between the real and the imaginary is
			effaced. The unreal is no longer that of
			dream or of fantasy, of a beyond or a
			within, it is that of a <I>hallucinatory
			resemblance of the real with itself.</I> To
			exist from the crisis of representation, you
			have to lock the real up in pure
			repetition...</Q></BQ>',
			'You don\'t think you can take this stuff
			 any more. The stream-of-consciousness
			 writing, the fractured and overly dramatic
			 sentences... And there wasn\'t even a ninja
			 in it to liven things up! ']
	 }
;

mathsBook : Book, Consultable
    vocabWords = 'calculus calc math maths mathematics text book/textbook*books'
    name = 'calculus textbook'
    location = lockedStudyDesk
    subLocation = &subSurface
    desc = "This huge paperback tome could well be about voodoo
	    quantum astrophysics for all you know. The two-inch
	    thick block of paper is filled with equations, squiggly
	    symbols and graphs, but is devoid of enlightenment (for
	    you at least). At least it has a human-like index so if you wanted
	    to consult the book on a topic, you could do so. "
    readDesc { say(randomSections.getNextValue()); }
    randomSections : ShuffledList {
	valueList = ['You find a page of diagrams corresponding to equations (so it seems). They\'ve been drawn in 3D: planes, hills, spheres, bumpy plains, weird donuts twisted in on itself... ',
		     'Flicking through, a few bits seem to remind you of highschool. Derivatives and fractions and cosines... Scary stuff. ',
		     'To your surprise, there is a section labelled <q>Just for fun</q>. The diagrams and equations following it make you wary. Upon closer inspection, it seems to be talking about fractals. They use a picture that you swear you\'ve seen on TV before: they zoom into some wiggly picture to find another wiggly picture, and so on <i>ad nauseum</i>, producing endless parades of wiggly pictures. Interesting, but not really within your scope of <q>fun</q>.',
		     'You turn to a random page full of symbols. The notation hurts your head, so you close the book. ',
		     '<q>Substituting <i>u</i> for <i>x<sup>2</sup></i>, we obtain the...</q> You can\'t read any more without falling asleep. ']
		     }
    hasReadConvolution = nil
;

+ConsultTopic @convolutionTopic
    topicResponse {
	if(!mathsBook.hasReadConvolution) {
	    "With anything else, you wouldn\'t take this too
	     seriously, but for some strange reason, something
	     inside burns with desire to find this damned word. You
	     hunt through the index and find it. Your fingers
	     shakingly flick to the page and you read: <BQ>There is
	     another kind of multiplication of functions called the
	     <i>convolution</i>. In general terms the convolution of
	     two functions <i>f</i> and <i>g</i>, denoted
	     <i>f &bull; g</i>, is the amount of overlap between the
	     two functions. It is used in synthesis imaging and we
	     define it as...</BQ>A bunch of complicated equations
	     follow. You don\'t feel especially enlightened after
	     reading that, but your eager subconscious is starting
	     to weird you out. ";
	    mathsBook.hasReadConvolution = true;
	}
	else
	    "Again you find the section (but without the burning
	     intent) and read: <bq>There is another kind of
	     multiplication of functions called the
	     <i>convolution</i>. In general terms the convolution of
	     two functions <i>f</i> and <i>g</i>, denoted
	     <i>f &bull; g</i>, is the amount of overlap between the
	     two functions. It is used in synthesis imaging and we
	     define it like...</bq>";
    }
;

+ ConsultTopic @mathIndex
    "The index is too long for you to read through line-by-line,
     although you could try to find particular topics if you had one
     in mind. "
;

+ DefaultConsultTopic
    "Maybe your mathematics abilities (or those of information
     location) are rusty, but you can\'t find that in the textbook. "
;

+ mathIndex : Component, Readable
    vocabWords = '(math) (maths) (mathematics) index'
    name = 'index'
    desc = "The index is full of weird terms that look like the
	    regular fare from your highschool days (or what little
	    you can remember of them). "
    readDesc = "The index is too long for you to read through
		line-by-line, although you could try to find
		particular topics if you had one in mind. "
    owner = mathsBook
    dobjFor(ConsultAbout) remapTo(ConsultAbout,mathsBook,IndirectObject)
;


republicBook : Book
    vocabWords = 'plato republic republic/book*books'
    name = 'Plato\'s The Republic'
    location = nil
    author = 'Plato'
    bookTitle = 'The Republic'
    desc = "It\'s been a while since you\'ve seen a book with
	    old-school bindings like this. The Republic is a solid,
	    but not heavy, five-by-three inch book bound in thin
	    leather. Your eyes trace the decorative trim,
	    complicated yet confined within simple hollow
	    rectangles. The spine simply reads <q>The Republic</q>
	    with Plato\'s name in a separate box below it. They sure
	    don\'t make books like this any more. "
    isQualifiedName = true
    readDesc { standardSections.doScript(); }
    standardSections : StopEventList {
	eventList = [ ]
	}
;

lockedPad : Readable
    vocabWords = '(note) scratch scribbled pad/notes/notepad/scribbles/scribblings*books'
    name = 'notepad'
    desc = "Notepads like these are a staple in any office (pardon
	    the pun). This thin pad of paper holds the scribblings
	    of whoever lives here. The handwriting has a measured
	    feel to it, but the actual content looks rather choppy
	    and random. If you cared to, you could read through some
	    of the writing to see what you can make of it. "
    location = lockedStudyDesk
    subLocation = &subContainer
    readDesc { pages.doScript(); }
    pages : CyclicEventList {
	eventList = ['Apart from some intricate doodles in the
		      margin, the only thing written on the front
		      page is: <bq><font face=tads-sans>The growth
		      of understanding follows an ascending spiral
		      rather than a straight line.\n\t Joanne
		      Field</font></bq> ',
		     'This page has a rough pencil drawing of a
		      fantastical stairway that seems to connect to
		      itself in a mind-bending infinite loop. You
		      recall seeing some weird pictures like these,
		      but the name of the artist eludes you. ',
		     'Apart from a column of little square tables of
		      numbers, this page has the following notes
		      jotted down: <bq><font face=tads-sans>Img
		      Conv: <.p><ul><li>detect edges</li>
		      <li>filter. imgry</li> <li>recursive &rarr
		      simplicity</li></ul></font></bq> ', //'
		      'On the next page, someone has written the
		       words <q>Dukkha, Samudaya, Nirodha, Marga</q>
		       in a column. The last word is underlined
		       heavily. It makes no sense to you. ', //'
		       'The next page consists of doodles: spirals,
			chains of dots with arrows between them,
			tree diagrams... Amidst this random
			scribbling you notice an equation:
			<i>z<sub>n+1</sub> =
			z<sub>n</sub><sup>2</sup> + C. </i> Makes about as
			much sense to you as the doodlings. ',
		     'In precise handwriting starting from the top
		      left part of the next page is a quote:<bq><font face=tads-sans>A
		      jeremiad of thoughts, scattered about this
		      place...</font></bq>',
                 'There is no more writing in the pad, so you flip it back to the start. ']
    }
    dobjFor(LookThrough) remapTo(Read,self)
;





// The diary tome of the prisoner
prisonerBook : Book
    vocabWords = 'black diary/tome/notebook/book'
    name = 'diary tome'
    location = prisonerTable
    owner = prisoner
    desc = "UNIMPLEMENTED YET. "
    readDesc = "You flick open the book to a random page and begin
		reading. Soon your eyes are entranced by the words.
		<BQ>Golden tresses float terribly over hubris,
		destined for greatness. Cycles parallel the eaten
		fortitude, decay ripping stone into chunks, sizzling
		fires in her eyes. Golden Michael, angel, casts swords
		across their shoulders, feeling desperate,
		annihilating nothing. Murky, sweet, sticky
		rosewater. Firebrand of honour, valour of angels,
		harbinger... My lives of luxury. Hatred bounded,
		broken seals shattered on the tiled floor. Cycles
		parallel the screaming resonance. Limpid swamp,
		draggling slush. Weeds wrapping spindles around my
		calves, clouds bearing down on me. Rain. Rain. Rain.
		Freedom awaits but under no impression are lucky
		stars such. Talismans are no protection from them.
		In the darkness, glowing, it waits. Burning
		buildings, crumbling bricks, popping like balloons.
		Furious visages, belting their flames out, screaming
		screaming screaming. Triplets play forthwards.
		Heralds gurgle on the broken bridges, crying blood.
		Knives fence in the rest, fear personified. Violence
		molten, searing the streets, bringing it closer. The
		firebrand is nothing to the enraptured pleas.
		Courage chokes, hacking, shuddering, falling into
		filth. Understand these writings my friend. Cyclic
		parallels endanger fabrics, but weave the ribbons
		together. Sharp shards slicing eyeballs. Evil lurks
		underneath but is drowned. Airless breaths, fog
		bubbling upwards. Illness? No. Waterflow, churning
		crowds. Borne crossbearer, pummelling the lord, foot
		on his head, eyes and brains and juices and blood
		and blood and blood. Justice meaty. Flaying circles
		cry out: <q>Dante! Dante!</q> but are silenced with
		the slice-crack of the whip. Resonance echoes
		redundancy, rippling through the firmaments, shaking
		the very steps of the Seraphim. Under cities the
		Thrall waits, coarse breaths terrifying the stone
		itself. Dirt, rock and stone heave and sigh, valleys
		alive. Trees gnarled, branches alight. Birds
		streaming through the air, arrows in the night,
		plunging as ashen spray. I cannot escape this. I
		tear and scratch, clawing wet wood and dry bone.
		Persephone, Helen, Beatrice; emergent, glorious,
		landmark. My heart pleads, pulsates, thunderous.
		Waxen effigies slipping to the ground, freeing me.
		Above the putrid rage disassociating, perfumed
		censers draw steps, handholds. I melt upwards,
		honey-like. Darkness prevails, but light envelopes.
		Ceaselessly, the cyclic parallels scream the
		resonance, slicing, mending, weaving.</BQ> You
		wrench your eyes free from the page, but a faint
		mote of this madness floats idly to the back of your
		mind. You clap the book shut and shake your head,
		trying to free it from this burrowing speck. "
    hasBeenRead = nil
    hasBeenDusted = nil
    cannotTearMsg {
	if(hasBeenRead)
	    return 'With your eyes closed, you try to tear the pages
		    out. No matter how hard you will it, your hands
		    refuse to comply. You clap the book shut again
		    in frustration. ';
	else {
	    hasBeenRead = true;
	    return 'You open the first page, your eyes following
		    your hand as it goes to tear the page out.
		    Suddenly your eyes are caught on words,
		    cascading words, entrancing words, gnawing
		    words. Fearful, you shut the book. ';
	}
    }
    okayTakeMsg {
	if(!hasBeenDusted) {
	    hasBeenDusted = true;
	    return 'You gingerly pick up the book and blow the dust
		    off it, putting it in your trenchcoat when you
		    think it is sufficiently cleaned. ';	    
	}
	else
	    return playerActionMessages.okayTakeMsg;
    }
    dobjFor(Read) {
	check() {
	    if(hasBeenRead) {
		"Hell no. That book is too... unsettling. You\'re
		 ashamed to admit it, but you don\'t want it sinking
		 into your brain. ";
		exit;
	    }
	}
	action() {
	    inherited();
	    hasBeenRead = true;
	}
    }
    dobjFor(Clean) {
	preCond = [touchObj]
	verify() {
	    if(hasBeenDusted)
		illogicalNow('The book is clean enough. ');
	}
	action() {
	    "You blow on the book, sending dust flying. You take a
	     step back to avoid it and then wipe the remaining stuff
	     off with your hand. ";
	    hasBeenDusted = true;
	}
    }
    dobjFor(Clear) asDobjFor(Clean)
;


// The Easter egg notepad of the programmer
programmerTrackIdeas : Readable
	vocabWords = 'ideas notepad/pad/notes/book'
	name = 'notepad of ideas'
	// location = programmerDesk
	location = nil
	owner = programmer
	desc = "This notepad seems to be chock-full of songs names, some starred, some crossed out. The pad reads:
			<BQ><center><u>Track ideas</u></center>Shortlist:
			<ul><li>Crowded House - Don't Dream It's Over (exploring an island) </li>
			<li>P Funk Allstars - Give up the funk (funny) </li>
			<li>Ben Folds Five - Brick (story in the lyrics)</li>
			<li>The Streets - Don't Mug Yourself (the lads act up at breakfast)</li>
			<li>Goo Goo Dolls - Iris (love story?)</li>
			<li>Veruca Salt - Seether (confrontation with a raving, dangerous Veruca)</li>
			<li>Dire Straits - Brothers in Arms (quiet/nostalgic) </li>
			<li>Aquabats - Lovers of Loving Love (a goofy fun day at the beach with your girlfriend)</li>
			<li>Gary Jules - Mad World (a disillusioned boy wanders through high school)</li>
			<li><strike>Gorillaz - Clint Eastwood</strike></li>
			<li>Amiel - Lovesong (a guy falls across his perfect moment, which is lost in the sands of time)</li>
			<li>Blessid Union of Souls - That's the girl I've been telling you about (guys talking about a chick and interacting with her)</li>
			<li>Foo Fighters - Everlong (popstar)</li>
			<li>Jason Wade - You Belong To Me</li>
			<li>Something classical? Liszt? Grieg?</li>
			<li>Jewel - Foolish Games (rainy apartment)</li>
			<li>K\'s Choice - Not An Addict</li>
			<li>Buffseeds - Barricade (tense/horror) <b>*</b></li>
			<li>Mark Seymour - Last Ditch Cabaret</li>
		        <li>Little Birdy - Baby Blue <b>*</b></li>
			<li>Paul Mac - The Sound of Breaking Up</li>
			<li>Pearl Jam - Better Man</li>
			<li>Smashing Pumpkins - Bullet With Butterfly Wings/Disarm/Zero/<strike>Perfect</strike></li>
			<li>No Doubt - Don't Speak (sad) <b>*</b></li>
			<li><strike>Stranglers - Golden Brown</strike></li>
			<li>Some goofy Britney song interpreted strangely</li>
			<li>Tal Bachman - She\'s So High (much like Iris)</li>
			<li>They Might Be Giants - New York City</li>
			<li>Vanessa Carlton - A Thousand Miles</li>
			<li>Tenacious D - ?</li> </ul></bq>";
;



comicBook : Book
    vocabWords = 'detective comic cartoon noir book/comicbook/comic/magazine'
    name = 'comic book'
    desc {
	"What a find! This comic book must have come from the early
	 seventies or something, and it\'s still in one piece.
	 You\'re not one of those creepy comic collectors, but you
	 have (very) vague memories of enjoying a comic or two when
	 you were a kid. ";

	local val = pages.curScriptState;

	// We do special things for the first and last pages.
	if(val == 1 || val == pages.eventList.length) {

	    // We do not mention where we are reading here.
	    if(val == 1) {
		"";
	    }
	    else {
		"\bYou are currently reading the last page of the comic. ";
	    }
	}
	else{
	    "\bYou are currently reading the <<spellIntOrdinal(val)>> page. ";
	}
    }
	
    readDesc { pages.doScript(); }
    pages : CyclicEventList {
	[ 'From what you can gather, this comic is about a
	   time-travelling sci-fi private detective called Rick
	   Repeat. Apparently in the last episode Dr Nihilo
	   (Repeat\'s arch-nemesis) broke into his office and stole
	   the Time Controls. This episode starts with Rick Repeat
	   in his office, promising to help some space-damsel find
	   her kidnapped husband. The blonde, lycra-clad woman sobs
	   into a holographic tissue as Rick Repeat ponders the
	   situation in a close up of his brooding and suspicious
	   eyes. ',
	 'In a few pages, Rick Repeat gets into a fistfight with a
	  seedy-looking alien, eventually overpowering him and
	  interrogating him about the kidnapped husband. The alien
	  blubbers that mobsters took the guy to an abandoned
	  tenement downtown. With a mighty <b><i>KAZOK!</i></b>,
	  Rick knocks out the alien and heads off downtown, the
	  determination in his eyes like primed bullets. ',
	 'Rick sneaks into the bad guy\'s hideout, inner-monologuing
	  the whole way about the never-ending scourge of crime and
	  his beaten-up life devoted to stopping it. When he\'s
	  finished his melodramatic spiel, he chances upon two
	  guards and takes them out with two sharp shots with his
	  laser gun. With the mobsters\' security foundation
	  obliterated, the rest of them stand no chance when Rick
	  Repeat bashes, blasts and <b><i>bakam!</i></b>es his way
	  in. The mob boss dodges Rick\'s onslaught, and makes his
	  way towards a window. Just before Rick can take him out,
	  the mob boss flings a grenade in between Rick and the
	  kidnapped husband, and flees out the window. Taken
	  off-guard, Rick leaps out of the way of the explosion, but
	  unfortunately the husband can not. ',
	 'Back at Dr Nihilo\'s lair, the doctor watches Rick cry in
	  anguish over the dead husband. <q>Rick Repeat, your pain
	  has just begun!</q> booms Dr Nihilo, and he dramatically
	  pushes a Big Red Button(tm). Rick Repeat\'s image blurs
	  out and he finds himself back in his office, earlier that
	  morning. Rick wipes his forehead and looks around,
	  confused. Just then another Rick Repeat walks through the
	  door. They both look at each other, shocked. In dramatic
	  stylised letters the episode ends with <q>Will Rick Repeat
	  discover Dr Nihilo\'s evil plan to trap him in a time
	  vortex, or will he be doomed to his moniker? Find out next
	  issue in <q>Rick Repeat vs Dr Nihilo in: Time Convolution
	  Prime!</q></q> ',
	 'The last few pages of the comic are filled with
	  advertisements for x-ray goggles, rock polishers and
	  <q>Just say NO to Communism</q> badges. There is a little
	  joke comic strip involving a more comical Rick Repeat and
	  some scientist standing on a boat in the middle of a lake.
	  A precocious little girl on the shore narrates: <q>Pete
	  and Repeat are in a boat. Pete falls out. Who is left?</q>
	  As Rick Repeat helps the scientist back into the boat,
	  someone off-frame (presumably the audience) shouts:
	  <q>Repeat!</q> The little girl says, <q>Pete and Repeat
	  are in a boat. Pete falls out. Who is left?</q> This
	  repeats a few more times with the audience (and the
	  bedraggled scientist) becoming increasingly annoyed.
	  Eventually they throw the little girl in the water and
	  everyone is happy. ',
	 'That\'s it for the comic. What do you expect for only 12
	  cents? You can get value for money and reread it if you
	  like. ']
	 }
;



madJournal : Book
    vocabWords = 'journal/diary/book'
    name = 'journal'
    desc = "The slim, faux-leather bound journal looks unremarkable
	    on the outside. Every page is covered in an intense,
	    tiny writing. There is quite a number of entries, but
	    you can read them all if you like. <<pagesDate.eventList[pagesDate.curScriptState]>>"
    readDesc { pages.doScript(); }
    pages : CyclicEventList {
	[' TEST ']
    }
    pagesDate : SyncEventList {
	eventList = ['You are currently at the beginning of the journal. ']
	masterObject = madJournal.pages
    }
;



philosophyFolder : Book
    vocabWords = 'flexible slim philosophy science scientific folder/book/report/article/portfolio'
    name = 'slim folder'
    desc = "A short article, collated with a few miscellaneous note
	    pages, is bound in a slim, flexible folder with a clear
	    plastic front and a glossy black backing.
	    <<pageSynposis.eventList[pageSynposis.curScriptState]>>"
    readDesc { pages.doScript(); }
    pages : CyclicEventList {
	[ 'TEST' ]
    }
    pageSynposis : SyncEventList {
	eventList = [ 'TITLE' ]
	masterObject = philosophyFolder.pages
    }
;
