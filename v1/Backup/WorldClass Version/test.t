////////////////////
// THE TEST STUFF

TestRoom: Room
    sdesc = "The Test Room"
    ldesc = {
	if (not global.playtesting)
	    "\([You really shouldn't be here! Scream at Brett.]\)";
	"This is the test room. Test stuff goes here. Wow.";
    }
;

TestActor: Actor
    location = TestRoom
    noun = 'dummy' 'test' 'guy'
    adjective = 'test'
    sdesc = "test guy"
    ldesc = "Man, he looks just like a crash test dummy!"
    verDoAskabout(actor,io) = {}
    doAskabout(actor, io) = {
	switch(io) {
	case Me:
	    "The crash test dummy goes, \"Um, I woulda thought you were the one to ask about that.\"";
	    break;
	case GodTopic:
	    "\"Whoa dude, cut to the metaphysical stuff, don\'t you?\" mocks the crash test dummy.";
	    break;
	case SexTopic:
	    "The dummy grins widely. \"A bit of how\'s-your-mother, eh?\"";
	    break;
	case TestActor:
	    "You really wanna talk about me? Here, have a crowbar.";
	    Crowbar.movein(actor);
	    break;
	default:
	    "The crash test dummy shrugs his shoulders.";
	}
    }
;
