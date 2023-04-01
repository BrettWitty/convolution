#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// Character notes
// - In every line of speech he says the word "dude"
// - Was a literature major
// - Is unemployed
// - Has a friend named Felix
// - Has had an unending tiff with Charlie
// - His Dad is the authoritarian type
// - Had an insane ex-gf who took an axe to his door
// - Has chilled out with the ravers when they've come home drunk and got off at the wrong level
// - "I'll get onto it" is his usual response to his messy place
// - Loves pizza


sprawled : Posture
    msgVerbI = 'sprawled out'
    msgVerbT = 'sprawl{s}'
    participle = 'sprawled out'
    tryMakingPosture(loc) { return tryImplicitAction(LieOn); }
    setActorToPosture(actor, loc) { nestedActorAction(actor, LieOn); }
;

cody : Person 'slovenly lazy surfer dude/guy/man' 'guy'
    //location = dudeSofaSprawled
    location = dudeSofa
    desc = "UNIMPLEMENTED YET. "
    isHim = true
    properName = 'Cody'
    posture = sprawled
    nameIsKnown = nil
    globalParamName = 'cody'
    seenProp = &codySeen
    knownProp = &codyKnown
    charlieKnown = true
    checkTakeFromInventory(actor,obj) {
	if(obj.ofKind(Wearable)) {
	    "As you move towards him, he says, <q>Dude, what the
	     hell are you doing?</q> ";
	    exit;
	}
	else
	    return inherited(actor,obj);
    }
;

// His clothes
+ codyShirt : Wearable
    vocabWords = 'shirt/t-shirt'
    name = 'his shirt'
    desc = "{The cody/he} is wearing a faded shirt that looks like a
	    t-shirt for a band. You can just make out the title:
	    <q>The Last Man</q> "
    isQualifiedName = true
    owner = cody
    wornBy = cody
    isListedInInventory = nil
;

+ codyJeans : Wearable
    vocabWords = 'jeans/trousers/pants'
    name = 'his jeans'
    isQualifiedName = true
    owner = cody
    wornBy = cody
    isListedInInventory = nil
;


// Some special topics

+codysName : Topic 'his name'
    owner = cody
    pcSeen = true
    pcKnown = true
;

+felixTopic : Topic 'felix';

+codyCollegeTopic : Topic 'lit literature university/college/uni/degree/major';

+codyDadTopic : Topic 'the major/dad/father/pop/pa/soldier/general/captain';

+codyNeighboursTopic : Topic 'next-door next door neighbour/neighbours/neighbor/neighbors'
    owner = cody
    pcSeen = true
    pcKnown = true
;

+codyDudeTopic : Topic 'use using usage dude/usage/use/dood'
    owner = cody
    pcSeen = true
    pcKnown = true
;

// Just chillin'

+codySprawledOnSofaTalking : InConversationState
    specialDesc = "\^{The/he cody} is sitting up on the couch, looking in your direction. "
    stateDesc = "He\'s looking at you expectantly. "
;

++codySprawledOnSofa : ConversationReadyState
    specialDesc = "\^<<cody.nameIsKnown ? cody.name : cody.aName>>
		   is sprawled out on the couch with a goofy
		   expression on his face. "
    stateDesc = nil
    isInitState = true
;

+++HelloTopic "<q>Hello again,</q> you say.<.p> {The cody/he} cocks his head and smiles. <q>Hey, dude. Wassup?</q>";

+++ImpHelloTopic "{The cody/he} notices you beginning to make conversation and he turns towards you, grinning. ";

+++ByeTopic "<Q>Well I better keep moving...</Q> you say.<.p> Cody gives you a flick of a salute, <Q>Catcha later, dude!</Q>";

+++ImpByeTopic "{The cody/he} sinks back into the couch saying, <q>Later, dude!</q>" ;

++++AltTopic "{The cody/he} shrugs at you and sinks back into the couch. ";

// His skis
++AskTopic, SuggestedAskTopic, StopEventList [codySkis, codySkiing]
    ['<Q>So why do you have a pair of skis under your bed?</Q><.p>
      {The/he cody} becomes quiet and stares off into space, his eyes glistening. <.topics>',
     'You venture again, <Q>Are you a skier?</Q><.p>
      {The/he cody} inhales deeply and sighs. <Q>No, dude. Well, not any more.</Q> <.topics>',
     '<Q>What happened?</Q> you ask.<.p>
      <Q>Well, many years ago, I used to be the gnarliest skier ever. Some dudes were even checking me out, trying to get me in the Winter Olympics. Most righteous. But then, like, one fateful day, it all went downhill...</Q><.p>
      You grin to yourself, not pointing out the pun.<.p>
      <Q>So dude, I was carving some gnarly lines down the slopes when, like, I saw this awesome babe.</Q> You raise your eyebrows at {the cody/him}. <Q>Nah, dude, she was like, Helen of Troy, and I\'ve seen her as I\'m, like, zooming past, pulling some wicked G\'s. So I like turn my head to check her out and dude, before you know it, I\'m skiing the wide blue yonder. I ended up bouncing down a wickedly rocky hill, busting myself up something major. Most awesome crash (my buddy got it on tape) but, like, my legs never were the same. Total bummer, dude.</Q> <.topics>',
     '<Q>So about skiing...<Q> you start.<.p>
      <Q>Dude, I told you, I can\'t ski any more. Leave it.</Q> ']
    name {
	if(talkCount < 1)
	    return 'his skis';
	else
	    return 'his skis again';
    }
    isActive = (cody.nameIsKnown && gPlayerChar.hasSeen(codySkis))
    timesToSuggest = (eventList.length() -1)
;

// His name
++AskForTopic, StopEventList @codysName
    ['<q>So, what\'s your name?</q> you ask.<.p> Cody chuckles at you. <q>Dude, I knew this guy just like you. Spending too much time with Mary Jane, if you get me.</q>',
      '<q>No really, what\'s your name?</q> you press.<.p> <q>Dude, seriously, you need to, like, remember stuff.</q> As if he were talking to a dull child, he says slowly, <q>Dude... I am... Cody...</q>',
     '<q>And your name was?</q> you ask.<.p>Cody slaps his forehead. <q>Dude! You\'re going senile or something! You should shack up next door.</q> ']
;

// The stickers on his door
++AskTopic, SuggestedAskTopic, StopEventList [dudeDoorStickers, outsideDudeDoorStickers]
    [{:"<q>So what\'s with all the stickers on your door?</q> you
     ask.<.p> Cody grins and rubs his bristled cheek. <q>Well, many
     moons ago, my buddies dropped by to crash. Felix
     <<gSetKnown(felixTopic)>> was chomping on an apple and he stuck
     the sticker on the door. So every time the dudes dropped by they
     had a thing of whacking stickers on my door. Landlord hasn\'t
     visited yet, so everything\'s cool. You should read the
     stickers, dude. I keep finding righteous ones I\'ve never seen
     before.</q>" },
     '<q>Is there any more to the sticker story?</q> you ask<.p>
      <q>Nuh. It was just my friends sticking them on like some
      sort of ritual. Sorry there isn\'t any more to it, dude.</q>']
     name = 'the stickers on the door'
     isActive = (gPlayerChar.hasSeen(outsideDudeDoorStickers) && gPlayerChar.hasSeen(dudeDoorStickers))
;

// Felix
++AskTopic, StopEventList @felixTopic
    [{:"Though it seems rather irrelevant, you ask Cody who Felix
      is.<.p><q>Oh, no biggie, dude. He\'s just one of my bros from
      college.</q> <<gSetKnown(codyCollegeTopic)>>"},
     {:"You ask Cody again about this Felix character. <q>Dude, I
	told ya, he\'s just a buddy from college.
	<<gSetKnown(codyCollegeTopic)>></q> "}]
     isActive = (felixTopic.isKnown)
;

// College
++AskTopic, SuggestedAskTopic, StopEventList @codyCollegeTopic
    ['Your interest peaked, you ask, <q>You mentioned you went to
      college. What did you do there?</q><.p> Cody spreads his arms
      famously. <q>Dude, you are looking at one totally kickass
      lit.\ major!\</q><.p> <q>Gee,</q> you say. <q>You sound just
      like one.</q> Cody just grins goofily. ',
     '<q>So no really, you\'re a literature major?</q> you ask
      incredulously. <.p> In his most grave voice, he replies,
      <q>Most seriously, dude.</q> ' ]
      name = 'college'
      isActive = (gPlayerChar.knowsAbout(codyCollegeTopic))
;

// God
++AskTopic, StopEventList @godTopic
    ['You shuffle your feet and then look up at Cody. <q>What do you
      reckon about, well, you know, God?</q><.p>Cody\'s eyes light
      up. <q>Oh, <i>dude</i>... I had the best...</q> Midsentence
      his attention is grabbed by the television. His voice drifts
      off and you snap your fingers to try to bring him back. With a
      dazed expression on his face he looks back at you. <q>Oh,
      totally dude.</q> You scratch your head at him. ',
     'You try again, more directly. <q>So, Cody, what\'s your
      opinion on God?</q><.p>He grins and says, <q>Dude, JC was the
      coolest! Like hanging ten across the Sea of Gallilee...</q>
      Cody\'s smile and surfer pose drops when he notices he\'s not
      getting through your stern frown. <q>Oh, sorry, dude. Nah man,
      God is cool. Way cool.</q> ']
;

// Cody's Dad (The Major)
++AskTopic, SuggestedAskTopic, StopEventList @codyDadTopic
    [{:"<q>Who is <q>The Major</q>?</q> you ask, imagining the
	sergeant from Full Metal Jacket.<.p>Cody looks down at his
	belly, flicking it nervously. <q>He\'s my dad. I think he\'s
	actually a sergeant, but we all called him <q>The Major</q>
	when I was a teenager. He totally came down on me like a
	dictator, always saying he\'d send me off to military
	college.</q> You grin at this. <q>But I managed to avoid
	that and get into college<<gSetKnown(codyCollegeTopic)>>.
	And dude,</q> he says, beaming. <Q>Look at me now!</q>" },
      '<q>Who was <q>The Major</q> again?</q> you ask.<.p> Cody
      sighs and says, <q>Dude, like I said before, it\'s my Dad.
      He\'s an army nut.</q> ']
    name = 'The Major'
    isActive = (gPlayerChar.knowsAbout(codyDadTopic))
;

// Showing yourself to Cody
++ThingMatchTopic, StopEventList @me
    ['You open your arms out and say, <q>Whaddya think?</q><.p> Cody
      looks at your stylish leather trenchcoat and replies, <q>Nice threads,
      dude. With some killer shades and an AK you could be a cool
      Neo... You know, from the Matrix.</q> ',
     'You strike a pose and ask Cody what he thinks. He just smiles and turns away, rolling his eyes. ',
     '<q>So what do you think of me?</q> you ask.<.p> Cody groans. <q>Dude, tame that wild ego.</q> ']
     includeInList = [&tellTopics, &showTopics]
;

// Showing the initial scrap of paper
++ShowTopic @initialScrapOfPaper
    "<q>Hey, what do you make of this?</q> you ask, handing over
      the scrap of paper.<.p> As Cody reads it, his eyebrows rise.
      <q>Whoa, dude... Creepy stuff. How did you get it?</q>
      <.convnode cody-discuss-start>"
;

+++AltTopic
    "You pass {the dobj/him} to Cody, but he blocks it, saying, <q>Dude, I\'ve already seen it.</q> "
    isActive = (location.talkCount > 0)
;

// Asking about the Mafia
++AskTopic, SuggestedAskTopic, StopEventList @mafiaTopic
    ['<q>Do you know anything about the Mafia? Are they hanging
      about here?</q><.p>Cody crinkles his nose up and says, <q>Not
      sure, dude. Sometimes I see some scary-looking dudes get in
      the elevator, maybe going somewhere upstairs. But, like, I\'m
      not sure.</q> ',
     'You frown, the Mafia thing playing on your mind. <q>You can\'t
      think of anything else about the mafia?</q><.p> Cody shrugs at
      you. <q>Nope.</q> ']
      name = 'the mafia'
      isActive = (gPlayerChar.knowsAbout(mafiaTopic) )
;

// Asking about his neighbours
++AskTopic, StopEventList @codyNeighboursTopic
    "<q>What do you know about your neighbours?</q> you ask, trying
     to make it sound more like casual inquiry than prying.<.p>
     <q>Hmmm...</q> Cody says, following it with a mild belch. He
     points northwards, down the hall: <q>Those dudes, I don\'t see
     too often. The chick in the left apartment is pretty cool, but
     um... yeah. The dude in the other apartment, I don\'t think
     I\'ve ever seen him. The other guys down the hall... Well that
     one dude moved out ages ago, and then there\'s the old folks.
     The old lady is sweet. She sometimes bakes me cookies and
     stuff... But the old dude... He\'s got it in for me. Hates my
     guts. <.reveal codyCharlieWar> "
;

// Asking about the hole in his door
++AskTopic, SuggestedAskTopic, StopEventList [dudeDoorCutInside,dudeDoorCutOutside]
    ['<q>Okay, I have to ask,</q> you say. <q>Why is there a huge gouge in the
      door?</q><.p>Cody laughs nervously. <q>Dude, about a year ago I
      was going out with this chick. And, um, you see, she didn\'t
      take the break-up too well.</q> He pushes a shaking hand
      through his hair and adds, <q>She <i>did</i> take an axe to
      the door pretty well, though. Dude, true story.</q>',
     '<q>Is there any further story to the door?</q> you
      ask.<.p><q>Nah, dude. Just a psycho ex-girlfriend who likes
      axes and not me.</q>' ]
    isActive = (gRevealed('hackedDoor'))
    name = 'the gouge in the door'
;

// Ask him about his mailbox
++AskTopic, SuggestedAskTopic, StopEventList @mailbox103
    ['<q>I saw your mailbox downstairs. What\'s the deal with the
      <q>Sex Machine</q> thing?</q><.p>Cody laughs and rolls his
      eyes. <q>My friends thought it would be a funny prank. Those
      dudes are always like that. F\'rexample, the stickers on my
      door.</q>',
     '<q>So are you really a sex machine?</q> you ask.<.p><q>Dude,
      that\'s a bit personal. And it\'s quality, not quantity,</q>
      he remarks, giving you a sly wink.']
;

// Ask him about his usage of dude
++AskTopic, StopEventList @codyDudeTopic
    ['<q>Okay, why do you keep using <q>dude</q>?</q> <.p><q>Dude, I
      do what now?</q> he asks. ',
     '<q>Why do you keep saying <q>dude</q>?</q> you ask again.<.p>
      Cody thinks for a second and says, <q>Hmm... Dunno, dude.
      It\'s just natural.</q><.p><q>It\'s a little annoying,
      actually.</q><.p>Scratching his face, he replies, <q>Oh, sorry, dude. Won\'t happen
      again.</q>',
     '<q>Can you stop saying <q>dude</q>?</q> you plead.<.p>Cody
      shakes his head. <q>Sorry, I can\'t help it, dude.</q>']
;

// Ask him about the smell in his room
++AskTopic, SuggestedAskTopic, ShuffledEventList @dudeBedroomSmell
    ['<q>Hey, what\'s that smell in your bedroom?</q> you
      ask.<.p>Cody goes red and waves you away. <q>Nah... nothing,
      dude. There\'s no smell. Hey, check out the TV!</q> he says,
      distractingly. ',
     '<q>Did you notice that weird smell in your bedroom?</q> you
      ask.<.p><q>Dude, you know the rules: Whoever smelt it, dealt
      it.</q>',
     '<q>Hey, Cody. Are you aware that your bedroom smells
      funny?</q><.p>Cody frowns at you. <q>Hey dude, leave me alone.
      And stop being so rude. </q>' ]
      isActive = (gPlayerChar.hasSeen(dudeBedroom))
      name = 'the smell in his bedroom'
      timesToSuggest = 1
;

//#########
// DEFAULTS
//#########

// The Default Command Topic
++DefaultCommandTopic, ShuffledEventList
    ['Cody looks at you with suspicion. <q>Dude, you do it!</q>',
    { : "Cody frowns at you. <q>Dude, you sound just like The Major<<gSetKnown(codyDadTopic)>>.</q>" },
    'Cody just raises his eyebrows at you.',
    {: "Cody stares at you and replies, <q>How about <q>No</q>, dude.</q>" } ]
;

// The Default AskFor Topic
++DefaultAskForTopic, ShuffledEventList
    ['{The dobj/he} scratches his chin and then shrugs his shoulders. ',
    '<q>Sorry, dude, I got no idea,</q> {the dobj/he} replies. ',
    'In a mumbled stream of words, he replies <q>I dunno, dude</q>']
    alreadyHaveMsg = "<q>Dude, you already have <<obj.theName>>,</q> remarks
		      {the dobj/him}."
    refuseMsg = "<q>Get your own, dude!</q> {the dobj/he} replies. "
    pointOutMsg = "<q>Dude, it\'s just over there,</q> {the dobj/he} remarks. "
    dontHaveMsg = "{The dobj/he} shrugs his shoulders showing you his empty palms. "
    askForOtherMsg = "<q>Yup! Whatcha want, dude?</q> {the dobj/he} asks. "
    askForSelfMsg = "{The dobj/he} giggles. <q>Dude, you gotta lay off the wacky tobacky.</q> "
;

// Default AskAbout Topic
++DefaultAskTopic, ShuffledEventList
   ['{The dobj/he} mumbles, <q>I dunno, dude...</q> shrugging his shoulders. ',
    '{The dobj/he} looks at you querulously, and asks <q>Dude, say what?</q> ',
    '<q>Erm... No idea, dude,</q> he replies. ',
    '<q>Can\'t help you, buddy,</q> he says. ']
;

// Default Give Topic
++DefaultGiveTopic, ShuffledEventList
   ['You hand ' + gDobj.theName + ' to {the iobj/him}. He looks it over and hands it back, <q>Cool stuff, dude, but no thanks.</q> ',
   'You try to hand ' + gDobj.theName + ' to {the iobj/him}, but he stops you, <q>Nah, you keep it, dude.</q> ',
   '<q>{The iobj/him}, do you want this?</q> you ask, offering him ' + gDobj.theName + '. {The iobj/he} glances at it and shakes his head. ']
;

// Default Show Topic
++DefaultShowTopic, ShuffledEventList
   ['{The iobj/him} glances at {the dobj/him} and says, <q>Heh.</q> ',
   '<q>That\'s cool, dude,</q> {the iobj/he} says, peering at {the dobj/him}. ',
   '{The iobj/he} says, <q>Nice...</q> ']
;

// Default Tell Topic
++DefaultTellTopic, ShuffledEventList
    ['You begin to tell {the dobj/him} about ' + getTopicName() + ' but he looks like he\'s phasing out already, so you stop. ',
    'As you tell {the dobj/him} about ' + getTopicName() + ' he says, <q>Uh huh... Mmm... Yep...</q> in an absent sort-of-way. You frown at him. ',
    'You tell {the dobj/him} all about ' + getTopicName() + '. At the end of your spiel he just replies with, <q>Uh-huh.</q> ']
    getTopicName() {
        if(gTopic.getBestMatch() != nil) {
	    if(gTopic.getBestMatch() == me)
		return 'yourself';
	    else
		return gTopic.getBestMatch().theName;
	}
	else
	    return gTopic.getTopicText;
	}
;

//#########################################
// Someone just barged in, so try to say hi
//
+ConvNode 'barged in'
    npcGreetingList : StopEventList {
	[ '<.p>The guy on the sofa suddenly wakes up, and wearily says, <Q>Hey dude. Wassup?</Q> ',
	 '<.p><Q>Yo dude, back again?</Q> asks the guy on the sofa. ']
	 }
    npcContinueList : ShuffledEventList {
	[ 'Not bothering to actually get up off the sofa, {the/he cody} calls after you, <Q>Dude! Yo dude!</Q> ',
	 '<Q>Hey dude!</Q> calls {the/he cody}. <Q>Are you, like, deaf, dude?</Q> ',
	 '<Q>Duuuuude...</Q> calls {the/he cody}, trying to grab your attention. ',
	 '<Q>Hey! Yo! Dude! What\'s doing?</Q> asks {the/he cody}. ']
	 }
    limitSuggestions = true
;

++SpecialTopic, HelloTopic 'introduce yourself' ['introduce', 'intro', 'yourself', 'myself', 'me', 'self', 'say','hello','hi']
    "<Q>Er, hi...</Q> you say.\b Sitting up in the sofa, {the/he
     cody} extends his hand. <Q>Wassup dude!</Q> You go to shake his
     hand but he suddenly slaps and taps your hand in some
     complicated greeting ritual in which you clumsily try to mimic. <<cody.setKnowsAbout(gPlayerChar)>>
     <Q>So what can I do for you, most righteous dude?</Q><.p> You
     take your hand back and cast your gaze over the apartment.
     <Q>I\'m not quite sure... But anyway, what\'s your name?</Q><.p>
     The guy\'s whiskered cheeks twist into a beaming grin.
     <Q>M\'name\'s Cody<<cody.makeProper>>. But now that you mention it dude, I don\'t know
     if it\'s my real name. I think my parents just made it up.</Q> <.topics>"
;

++DefaultAnyTopic, ShuffledEventList
    [ '{The cody/he} cuts you off and says, <q>Dude, don\'t be rude... Intro yourself!</q> <.convstay>',
     '{The cody/he} cuts you off. <q>Wait up, dude. Have we met?</q> <.convstay>',
     '{The cody/he} interrupts you. <q>Dude, I don\'t think I even know you. Intro yourself!</q> <.convstay>' ]
;

//#############################
// Discuss your weird beginning
+ConvNode 'cody-discuss-start';

++TellTopic, SuggestedTellTopic @initialScrapOfPaper
    "You feel a bit weird telling Cody, but it might help you
     anyway. <q>So a while ago, I came to in the basement. I had a
     headache and was tucked behind those delivery boxes. I had this
     scrap of paper clutched in my hand, but it\'s not mine, nor in
     my writing. I don\'t understand any of it. What do you
     reckon?</q><.p>Cody rubs the stubble on his cheek. <q>Dude, if
     you ask me, it sounds like a Mafia
     hit.<<gSetKnown(mafiaTopic)>> But it is totally weird.</q> <.convstay>"
    isActive = (initialScrapOfPaper.isRead)
    name = 'the initial scrap of paper'
;

++AskTopic, SuggestedAskTopic, StopEventList @pilesOfBoxes
    ['<q>Why are there hundreds of delivery boxes in the
      basement?</q><.p><q>Not sure, dude,</q> Cody replies. <q>I
      think they were here before I moved in.</q> For some reason,
      Cody\'s eyes flick about nervously. Maybe it\'s just your
      imagination. <.convstay>',
     '<q>You <i>sure</i> you don\'t know anything about the
      boxes?</q> you ask, staring at him. <.p>He seems more composed
      this time and says, <q>Seriously, dude. I think it\'s just
      extra storage. Don\'t stress about them.</q> <.convstay>',
     '<q>Are you absolutely sure...</q><.p>Cody cuts you off.
      <q>Dude, listen. I don\'t know anything about them.</q> <.convstay>']
      name = 'the delivery boxes in the basement'
      timesToSuggest = 1
;

