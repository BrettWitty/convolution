/* The Zippo Lighter */
/* Nifty little beastie of style and pyromania. */
// ISSUES:
// - If you give another character the lit lighter (or make them light it) and it gets too hot, then the
//   character doesn't drop it.
// - You can't drop the lit lighter in an attempt to start a fire.
// - Should impress folk when you open it in front of them. (Hook into ActorState?)
// - The specialDesc is set even if another actor is holding it. (hook into specialdesc)
// - Add in a shake action so you can feel how much fuel is left.
// - Be careful if putting it in your pocket!!!
// - Fix LIGHT LIGHTER so it doesn't ask for an iObj.
// - Works underwater at the moment!

zippoLighter : FireSource, FueledLightSource '(your) trusty zippo zippo(tm) tm (tm) lighter' 'your trusty Zippo(tm) lighter'
    desc {
	"Your trusty Zippo lighter is simple yet elegant. You think you have the
	 suave flick-open-and-ignite move perfected. (Always a hit with the
	 ladies!) ";
	if(isLit)
	    "It is currently burning with a long, narrow, but gentle flame. ";
	if(isIn(gPlayerChar))
	    say(fuelLevelMsg);
    }
    isProperName = true
    isLit = nil
    specialDesc {
	"Your trusty lighter lies forlornly on the ground";
	if(isLit)
	    ", its flame flickering madly. ";
	else
	    ". ";
    }
    bulk = 2
    weight = 5
    fuelLevel = 100
    maxHotness = 10
    hotness = 0
    tooHotDropMsg = 'Suddenly you notice that the lighter has become very hot and you instinctively drop it in pain. It bounces on the ground and closes. '
    tooHotDistantMsg = 'The lighter as one of its safety features slowly clicks shut by itself. '
    funkyLightMsg : ShuffledList { valueList = ['With a little grin, you suavely flick the lighter open. ',
						'With all the style of a Golden Age private eye, you flick the lighter open, presenting a long, warm flame. ',
						'Like a stage magician, you quickly snap the lighter open and pause on the long, dancing flame. '] }
    makeLit(lit) {

	/* Do the usual things */
	inherited(lit);

	/* Make the lighter cold when unlit */
	if(!lit)
	    hotness = 0;
    }
    burnDaemon() {

	/* Do the usual stuff */
	inherited();

	/* Make the lighter hotter from use */
	hotness += 1;

	/* Check if too hot */
	if(isTooHot())
	    tooHotSoDrop();
    }
    isTooHot() {
	if (hotness >= maxHotness)
	    return true;
	else
	    return nil;
    }
    tooHotSoDrop() {

	/* The lighter has gotten far too hot so we want to drop it if */
        /* we're carrying it. Of course check for holding etc.         */
	if(self.isIn(me)) {

	    /* I'm probably holding it so drop it. */
	    say(tooHotDropMsg);
	    moveInto(me.location);
	    /* Turn me off as well. */
	    makeLit(nil);
	}
	/* It's too hot, but maybe it's been dropped elsewhere. Flick it off for safety. */
	else {

	    /* If the player is in the room, say the lighter flicks off. */
	    if(gPlayerChar.canSee(self))
		say(tooHotDistantMsg);
	    makeLit(nil);
	}
    }
    fuelLevelMsg() {
	if(fuelLevel < 20)
	    return 'It seems almost empty. ';
	if(fuelLevel < 40)
	    return 'There seems to be a little fuel left. ';
	if(fuelLevel < 60)
	    return 'The lighter feels about halfway full. ';
	if(fuelLevel < 80)
	    return 'You think it\'s mostly full of fuel, though not completely. ';
	else
	    return 'It seems to be full of fuel. ';
    }
    dobjFor(Open) {
	preCond = [objHeld]
	verify() {
	    if(!isLit)
		logicalRank(120,'open lighter');
	    else
		illogical('The lighter is already lit!');
	}
	check() {
	    
	    /* What to do if the lighter is flicked open, but is empty. */
	    if(fuelLevel == 0) {
		"You flick open the lighter, but it doesn't light.
		 You shake it a little and it feels like there is no
		 more fuel left in it. ";
		exit;
	    }
	}
	action() {

	    /* Do the funky flick-light open. */
	    say(funkyLightMsg.getNextValue());
	    makeLit(true);
	}
    }
    dobjFor(Close) {
	preCond = [objHeld]
	verify() {
	    if(isLit)
		logicalRank(120,'close lighter');
	    else
		illogical('The lighter is already closed and extinguished. ');
	}
	action() {

	    /* Snap it shut. */
	    say('You shake the lighter swiftly, snapping it shut. ');
	    makeLit(nil);
	}
    }
;