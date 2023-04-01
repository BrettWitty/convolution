// New verbs


helpVerb: Soloverb
  verb = 'help'
  sdesc = "help"
  soloaction(actor) = {
    "This has not been implemented yet! Harrass Brett!";
    abort;
  }
;

modify dieVerb
    soloaction(actor) = { "You can't get out that easily! Take it like a man! ";}
;

//
// The infamous XYZZY verb
//
xyzzyVerb: Soloverb
  sdesc = "xyzzy"
  verb = 'xyzzy'
  soloaction(actor) = {
      // if near programmer
      //
      // or if near God
      //
      // do something special (and funny)
      // otherwise
      "You inhale deeply and fearfully squeak out the word \"XYZZY\".\b You
       pause.\b Nothing happens. Perhaps you\'re not pronouncing it correctly?";
  }
;

plughVerb: Soloverb
    sdesc = "plugh"
    verb = 'plugh'
    soloaction(actor) = {
	"For some whimsical reason, you try to say \"plugh\" a few times. You
	 end up saying something more like \"blergh\". Nevertheless it comes out hollow. ";
    }
;

ploverVerb: Soloverb
    sdesc = "plover"
    verb = 'plover'
    soloaction(actor) = {
	"Unexpectedly, you find yourself thinking about short-billed wading
	 birds which are typically found near water but sometimes frequent
	 grasslands. Now what brought <I>that</I> on?";
    }
;

swearsVerb: Soloverb
    sdesc = "cursing"
    verb = 'fuck' 'shit' 'cunt' 'bastard' 'damn' 'darn'
    soloaction(actor) = {
	// Modify when you're near people.
	"You curse loudly. Somewhere far away, your mother\'s ears are tingling. ";
    }
;

burpVerb: Soloverb
    sdesc = "burp"
    verb = 'burp' 'belch'
    soloaction(actor) = {
	"You build up a great reserve of intestinal power and then release it in an almighty belch.";
    }
;

//
// My modified Knock verb, adding the requirement of being able to touch the object
modify knockonVerb
    dorequires = [[&cansee, &cantouch]]
;

//
// My Tap verb that allows you to add "tapping" to windows.
//
tapVerb: Verb
    verb = 'tap' 'tap on'
    sdesc = "tap on"
    desc(obj) = {
	if (obj.isplural)
	    self.sdesc;
	else
	    "taps on";
    }
    allok = nil
    doAction = 'Tapon'
    dorequires = [[&cansee, &cantouch]]
;

clearVerb: Verb
    verb = 'clear' 'clear away' 'sweep' 'brush' 'wipe'
    sdesc = "clear"
    allok = nil
    doAction = 'Clear'
    dorequires = [[&cantouch]]
;

kissVerb: Verb
    verb = 'kiss' 'smooch' 'snog'
    sdesc = "kiss"
    allok = nil
    doAction = 'Kiss'
    dorequires = [[&cansee, &cantouch]]
;

shakeVerb: Verb
    verb = 'shake' 'rattle' 'jiggle'
    sdesc = "shake"
    allok = nil
    doAction = 'Shake'
    dorequires = [[&cantouch]]
;
