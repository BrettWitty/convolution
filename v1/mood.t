#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// This has some mood controls that affect descriptions only. This is
// distinct from the Karma engine.

// Basically it's used for the initial section where you can be
// spooked out a lot, so we don't get suddenly jovial or exploratory
// while you're still in a spooked mood.

// The different moods
enum moodSpooked, moodExploratory;

// The different mood increase types
enum moodIncreaseLinear, moodIncreaseMultiplicative, moodIncreaseExponential;

#define gGameMood (moodDaemon.curMood)

moodDaemon : InitObject

    execute() {
	// Initialize the PromptDaemon
	daemonID = new PromptDaemon(moodDaemon, &doMood);
    }

    // My daemonID
    daemonID = nil

    // We start off spooked as per the intro.
    curMood = moodSpooked

    // The default mood is exploratory
    defaultMood = moodExploratory

    // The mood increase type tells us how the mood increases. The
    // decrease is assumed to be linear.
    moodIncreaseType = moodIncreaseLinear

    // The current mood length
    moodCounter = 10

    // We run this every round.
    doMood() {

	// This function monitors the current game mood and changes
        // it if need be.
	if( moodCounter == 1) {

	    // Keep the counter at zero.
	    moodCounter = 0;

	    // We revert the mood to default
	    curMood = defaultMood;

	}
	else {

	    // Reduce the counter
	    moodCounter--;

	}

    }

    // Increase the mood in the given mood by n
    increaseMood(mood, n) {

	// If the current mood isn't the mood we want to increase, we
        // change to it.
	if(curMood != mood)
	    resetMood(mood);

	switch(moodIncreaseType) {

	    case moodIncreaseLinear:
	    moodCounter = moodCounter + n;

	    case moodIncreaseExponential:
	    moodCounter = moodCounter * 2^n;

	    case moodIncreaseMultiplicative:
	    moodCounter = moodCounter * n;

	    default:
	    moodCounter = moodCounter + n;

	}
	
    }

    // Reset the mood to the one given. This zeroes the counter and
    // changes the mood.
    resetMood(mood) {

	moodCounter = 0;
	curMood = mood;

    }

;
