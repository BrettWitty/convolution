#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>
#include <convmain.h>

// The Hints for Convolution

Hint template 'hintText' [referencedGoals]? ;

topHintMenu: TopHintMenu 'Hints';

+ HintMenu 'Questions about the game and the author' topicOrder = 0;

++ Goal 'About Convolution'
    ['Some time in January of 2004, I decided to get involved in
      interactive fiction, especially in the creation side of
      things. I picked up ADRIFT and the then-unnamed Convolution
      began life there. The vague idea was a random collegiate-type
      game that happened in a huge building. It was meant to be a
      private project, just-for-kicks. Then I struck a great idea
      and developed the game as a serious piece of work rather than
      a hodge-podge of random elements. I kept to my goal of writing
      the game I always like to play, but I focussed on the literary
      and programming side of things. Since Convolution would be my
      first IF game, I wanted it to be a serious contribution.
      Because of this, I rewrote the sucker many times, each
      iteration removing the zany humour and grab-bag of elements. I
      hope to have delivered a solid game with some merit.\bAs I
      mentioned, the game began in ADRIFT, but it wasn\'t
      programmatic enough for me and I wasn\'t willing to shell out
      for a full licence. Soon after beginning in ADRIFT, I started
      anew in TADS 2. Because of some limitations in the standard
      library, I started once again in WorldClass. This was great
      until even that didn\'t have enough flexibility for me. I
      eventually made the move to the then-beta TADS 3, and I\'ve
      never looked back. <.p><i>Convolution</i> was quite an
      ambitious project for me, so much that it took me a few years
      to actually finish it. In the meantime, I wrote <i>Mix
      Tape</i> for IF Comp 2005. So although <i>Mix Tape</i> was my
      first publicly-released game, in actuality, <i>Convolution</i>
      was my real first.']
    goalState = OpenGoal
    topicOrder = 1
;

++ Goal 'About the author'
    ['I\'m a 23 year old PhD student in mathematics in Australia,
      studying in computational algebra. If you\'re not scared
      already, I\'m also an avid writer and programmer, which is why
      I have an interest in interactive fiction. I enjoy IF as a
      form of literature and hope to contribute both with
      Convolution and with further projects. If you\'d like to drop
      me a line, email me at shorokin@hotmail.com']
    goalState = OpenGoal
    topicOrder = 2
;

++ Goal 'About the hints'
    ['The hints provided in <i>Convolution</i> are generally divided into
    geographical areas. There are also general hints about who you are and
    what you should be doing. Hints start off vague to give you an idea of what
    to think about, without giving it all away, progressively becoming more and
    more prescriptive until the actual commands are supplied. Hints are often
    sensitive to your position and knowledge of the game world, so you can
    check back on past hints to get more information. ']
    goalState = OpenGoal
    topicOrder = 3
;


+ HintMenu 'General problems and questions' topicOrder = 1;

++ Goal 'Where am I?' ['UNIMPLEMENTED YET. ']
    goalState = OpenGoal
    topicOrder = 1
;

++ Goal 'What should I do?'
    ['You don\'t know where you are, and the surroundings give you a sense of
    unease. Maybe you should just get out while you can. ']
    topicOrder = 2
    openWhenSeen = behindBunchOfBoxes
    closeWhenSeen = backRoom  
;

++ Goal 'How do I get rid of this headache?'
    [aspirinHint]
    topicOrder = 10
    openWhenTrue = gPlayerChar.hasHeadache
    closeWhenTrue = !gPlayerChar.hasHeadache
;

+++ aspirinHint : Hint
    'You\'ll have to look around for some aspirin or something like that.'
    [aspirinGoal]
;

++ aspirinGoal : Goal 'Where can I find some aspirin for this headache?'
    ['There are no pain-killers in the basement. There are some on the ground level.',
     'Specifically, there are some in the reception. ',
     'If you examine the filing cabinets, you\'ll find a bottle of aspirin. ',
     'GET ASPIRIN. EAT ASPIRIN. ']
    topicOrder = 11
    closeWhenTrue = (gPlayerChar.hasAspirin || !gPlayerChar.hasHeadache)
;

+ HintMenu 'Basement Level' topicOrder = 2;

++ Goal
    'What\'s the deal with all these boxes? '
    [
     'The boxes are stacks of postal boxes, stacked high in a basement. Other
     than being there for general storage, they seem to be stacked up so that
     you are hidden behind them when you come to. ',
     'The boxes themselves don\'t seem to have a purpose. Nevertheless you can
     EXAMINE or READ them. ']
     openWhenSeen = pilesOfBoxes
     topicOrder = 1
;

++ Goal
    'What is in the basement area? '
    [
        'West of the main basement there is an area set aside for a large
        number of postal packages. ',
        'There is a boiler room to the north of the main basement. ',
        'The Janitor has a room down here (but it is locked). ',
        'Otherwise there are the stairs to the east leading up. '
    ]
    openWhenSeen = mainBasement
    topicOrder = 2
;

++ Goal
    'What should I do in the boiler room? '
    [
        'For now, don\'t worry about the boiler room. You can examine the boiler
        itself or the cabinet in the corner. '
    ]
    openWhenSeen = boilerRoom
    topicOrder = 3
;

++ Goal
    'How do I get into the Janitor\'s room? '
    [
        'UNIMPLEMENTED YET. '
    ]
    openWhenSeen = basementToJanitorDoor
    topicOrder = 4
;

// The Ground floor

+ HintMenu 'Ground Floor' topicOrder = 3;

++ HintMenu 'Getting Out' topicOrder = 1;

+++ Goal 'How do I get out?'
    ['There\'s no obvious exits in the basement area. Try upstairs. ',
     'Have you tried the door in the back room?',
     'Hmm... That is no good. Did you find the lobby?',
     'Go SOUTH twice from the back room to get to the lobby. SOUTH
      from here is the entrance. ',
     'The doors in the entrance seem to be chained up. Maybe that
      suggests further inspection. ',
     'Well the chains look solidly in place, but there does seem to
      be a letter on the door handles. ',
     '(In the Entrance) GET ENVELOPE. READ LETTER. ']
     openWhenRevealed = 'get-out'
;

++ HintMenu 'Getting to the first level' topicOrder = 2;

+++ Goal 'I found the letter. How do I get to Room 777?'
    ['By guesswork (or checking out the mailboxes) it seems that
      Room 777 would be on level 7, which is a fair way up from the
      ground floor. ',
     'The most straightforward idea would be to take the elevator in
      the lobby. ',
     'Hmm... The elevator doesn\'t seem to work. ',
     'Inspecting the controls might suggest why. ',
     'The elevator is activated with a security swipe card. ',
     'If you can\'t find a swipe card (see the hint under <q>General
      problems and questions</q>), you might want to explore other
      alternatives. ' ]
      openWhenKnown = room777Topic
;

+++ Goal 'How do I get the elevator to work?'
    ['If you PRESS THE BUTTON in the lobby and ENTER the elevator,
      you can inspect the controls. ',
     'The elevator buttons don\'t seem to work, but there is another
      component to the controls. ',
     'The controls are activated by a security swipe card. ']
     openWhenSeen = (elevator)
;

+++ Goal 'What other ways are there to get upstairs?'
    ['In case of fires, you can\'t use the elevator. What is the
      usual alternative? ',
     'Bingo! Fire escapes! Try to find the stairwell. <.reveal
      stairwell-hint>',
     'In this building, the stairwell is east of the lobby. ']
     openWhenKnown = room777Topic
;

+++ Goal 'I can\'t get into the stairwell! '
    ['There are a few ways to get through the locked stairwell door. ',
     openStairwellHint]
     openWhenRevealed = 'stairwell-hint'
     closeWhenSeen = groundStairwell
;

++++ openStairwellHint : Hint
    'The obvious solution is to find a key. Another way is to get
     someone else to open the door for you. '
    [stairwellKeyGoal, stairwellSomeoneOpenGoal]
;

+++ stairwellKeyGoal: Goal 'Where can I find a key to open up the stairwell? '
    ['Thinking about this logically, the only reason why they lock
      the door is so that non-residents (like yourself) can\'t break in. ',
     'Or the other way around, only residents can get in. ',
     'The place is pretty deserted, so you won\'t be able to
      convince a resident to let you in. ',
     'Perhaps someone has left a key lying around? ',
     'Keys are only lost by forgetfulness. ',
     'An absent-minded resident may have left their keys in a place
      where they\'d be likely to use them, or accidentally dropped
      them doing something else. ',
     'The only things a resident would be on the ground floor for
      would be checking their mail or doing their laundry. ',
     'A set of keys has been left in the mailbox to Apartment 102.
      Another key has been lost in one of the washing machines in
      the laundry. If you find the right implement, you can also
      pick the lock. ']
      closeWhenSeen = groundStairwell
;

+++ stairwellSomeoneOpenGoal : Goal 'How can I get someone to open the door for me? '
    ['There doesn\'t seem to be anyone around on the ground floor
      and certainly no-one in the basement. ',
     'Someone from upstairs should be a help (if there is anyone). ',
     'Contacting a person would be tough without ESP or... ',
     'A telephone! ',
     'There is a telephone in the lobby. But who to call? ',
     'You can try different numbers, but only one looks likely. ',
     'The janitor should be contactable. ',
     'RING JANITOR. <.reveal get-janitor-downstairs>']
     closeWhenSeen = groundStairwell
;

+++ Goal 'How can I get the janitor to come downstairs? '
    ['Surely your charming wit would suffice? ',
     'RING JANITOR. ',
     'Apparently not. Hmm... We need to lure him. ',
     'Janitors have jobs to do, perhaps you could trap him this way? ',
     'Janitors (or as they are otherwise known, custodial engineers)
      are employed to fix things and clean things up. ',
     getJanitorDownstairsHint]
     openWhenRevealed = 'get-janitor-downstairs'
;

++++ getJanitorDownstairsHint : Hint
    'Try <q>creating</q> a job for him and then ring him back.'
    [janitorFixGoal, janitorCleanGoal]
;

+++ janitorFixGoal : Goal 'What can I break for the janitor to fix? '
    ['You need to find a suitable object to vent your destructive
      tendencies. ',
     'Have you looked in the laundry?',
     'Perhaps he could check out that broken washing machine in the
      laundry? ',
     'Hmm... No luck. Is there anything else? Perhaps something more
      critical? ',
     'There is something rather critical to the building in the
      basement (no, not the foundations). Specifically, the temperature. ',
     'The boiler! ',
     'ATTACK THE BOILER. (You can also KICK it) Then SOUTH, EAST,
      SOUTH, SOUTH, RING JANITOR.' ]
;

+++ janitorCleanGoal : Goal 'What can I get the janitor to clean? '
    ['There isn\'t a lot around to make a mess with. ',
     'Have you noticed the video camera in the lobby? ',
     'Perhaps this is for security reasons, but you could use this
      to your advantage. ',
     'Now you need something in the lobby to mess up. ',
     'That plant looks rather conspicuous. ',
     'PUSH PLANT. RING JANITOR. ']
;

+++ Goal 'Okay the janitor is coming, but how is that going to help? '
    ['You could just ask him to let you into the stairwell. ',
     'Nope? Maybe you need to be a bit sneakier. ',
     'There are two ways about this problem: being swift of feet or
      swift of hand. ',
     'When the janitor comes through the stairwell door, you can
      duck through it before it closes. Alternatively, you can steal
      his keys while he is working. ']
      openWhenTrue = (vern.isDoingJob)
      closeWhenTrue = !(vern.isDoingJob)
;

++ HintMenu 'The Back Room' topicOrder = 3;

+++ Goal 'What\'s there to do in the back room?'
    ['Flirt with some attractive receptionist? Just kidding. You can
      investigate the emergency exit, the boxes or the bookcase. ',
     'Specifically, SEARCH THE BOOKCASE for a hidden surprise. ']
     openWhenSeen = backRoom
;

+++ Goal 'The door in the back room is locked! '
    ['Perhaps this is intentional. Folks have to worry about
      security, after all. ',
     'There is an alternate route to where the back door leads, but
      you need to explore further to find it. ']
      openWhenDescribed = backRoomDoor
      openWhenRevealed = 'back-door-locked'
;

++ HintMenu 'The Reception Area' topicOrder = 4;

+++ Goal 'How do I get into the Manager\'s office?'
    ['UNIMPLEMENTED YET. ']
    openWhenSeen = receptionToManagerDoor
    closeWhenSeen = managerOffice
;

++ HintMenu 'The Manager\'s Office' topicOrder = 5;

++ HintMenu 'The Lobby' topicOrder = 6;

+++ Goal 'The phone was ringing and I answered it but there was only
	 creepy noises on the other end. Who was that? '
    ['You don\'t know. ',
     'Kinda. ']
     openWhenRevealed = 'creepy-phone-call'
;

+++ Goal 'How do I use the phone?'
    ['Firstly you have to be in the lobby (you can\'t reach the
      phone from the reception area. ',
     'You can ANSWER PHONE if it is ringing. You can DIAL [number]
      to call a specific number. HANG UP when you\'re done. ']
     openWhenSeen = lobbyPhone
;

+++ Goal 'How do I get the elevator to work?'
    ['If you PRESS THE BUTTON in the lobby and ENTER the elevator,
      you can inspect the controls. ',
     'The elevator buttons don\'t seem to work, but there is another
      component to the controls. ',
     'The controls are activated by a security swipe card. ']
     openWhenSeen = (elevator)
;


++ HintMenu 'The Entrance' topicOrder = 7;

++ HintMenu 'The Laundry and Store Room' topicOrder = 8;


// The Alleyway

+ HintMenu 'The Alleyway' topicOrder = 4;

// First level

+ HintMenu 'First Level' topicOrder = 5;

++ HintMenu 'The Lunch Room';

++ HintMenu 'Abandoned Apartment (apartment 101)';

+++ Goal 'What\'s the deal with the abandoned apartment?'
    ['Someone must have recently moved out. There is very little
      left behind, but can always poke around. You could even check
      out the window to the north. ']
    openWhenTrue = (gPlayerChar.hasSeen(abandonedLounge) || gPlayerChar.hasSeen(abandonedKitchen) || gPlayerChar.hasSeen(abandonedLounge))
;

++ HintMenu 'The old folks (apartment 102)';

++ HintMenu 'Cody (apartment 103)';

++ HintMenu 'Apartment 104';

++ HintMenu 'Apartment 105';

++ HintMenu 'The catwalk';

// Second level

+ HintMenu 'Second Level' topicOrder = 6;

++ HintMenu 'The programmer (apartment 201)';

++ HintMenu 'Ravers (apartment 202)';

++ HintMenu 'The recluse (apartment 203)';

++ HintMenu 'The prisoner (apartment 204)';


// Third level

+ HintMenu 'Third Level' topicOrder = 7;

// Fourth level

+ HintMenu 'Fourth Level' topicOrder = 8;

// Fifth level

+ HintMenu 'Fifth Level' topicOrder = 9;

// Infinite Hallway

+ HintMenu 'Infinite Hallway' topicOrder = 10;

+ HintMenu 'The Amazon' topicOrder = 11;

+ HintMenu 'The Subway' topicOrder = 12;

+ HintMenu 'The Beach' topicOrder = 13;

+ HintMenu 'The Final Meeting' topicOrder = 14;
