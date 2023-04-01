//
// My super-special room modifications.
// Possibly kludgy, but allows "smell" to give the room's smelldesc etc.
modify Room
    smellaround(actor, verbose) = {
	local tot, locn;
	locn := [] + self;
	tot := listcontents(self, actor, nil, nil, nil, nil, nil, nil, &cansmell, locn);
	if (tot = 0) {
		self.smelldesc;
	}
    }
    listenaround(actor, verbose) = {
	local tot, locn;
	locn := [] + self;
	tot := listcontents(self, actor, nil, nil, nil, nil, nil, nil, &canhear, locn);
	if (tot = 0) {
		self.listendesc;
	}
    }
    feelaround(actor, verbose) = {
	local tot, locn;
	locn := [] + self;
	tot := listcontents(self, actor, nil, nil, nil, nil, nil, nil, &cantouch, locn);
	if (tot = 0) {
		self.touchdesc;
	}
    }
    smelldesc = "You don\'t smell anything unusual. "
    listendesc = "You don\'t hear anything unusual. "
    touchdesc = "You don\'t feel anything unusual. "
;

//
// The alleyway class is designed so the few outdoor areas are consistently (and compactly) coded.
//
class Alleyway: Room
  ground = true
  walls = true
  ceiling = nil
  sky = true
  skydesc = "Far above you is the sky. Clouds lazily drift across aimlessly. "
;

//
// My slightly modified Door class. Adds tap as a synonym of knock.
//
modify Door
    doSynonym('Knockon') = 'Tapon'
;

//
// A special window class. This is a heavily specialized version of Door.
//
class Window: Obstacle
    sdesc = "window"
    adesc = "a window"
    ldesc = "An ordinary window."
    thedesc = "the <<self.isbroken ? "broken" : "">> window"
    iswindow = true
    isopen = nil
    islocked = nil
    isbroken = nil
    opendesc = {
	"\^<<self.subjprodesc>> <<self.is>> ";
	if (self.isopen) "open";
	else { "closed"; if (self.islocked) " and locked"; }
	".";
    }
    setIsopen(setting) = {
	self.isopen := setting;
	if (self.otherside and self.otherside.isopen <> setting) 
	    self.otherside.setIsopen(setting);
    }
    setIslocked(setting) = {
	self.islocked := setting;
	if (self.otherside and self.otherside.islocked <> setting) 
	    self.otherside.setIslocked(setting);
    }
    destination(actor) = {
	if (self.isopen)
	    return self.windowdest;
	else if (not self.islocked and not self.noautoopen) {
	    local err;
	    "(Opening <<self.objthedesc(nil)>>)\n";
	    err := execCommand(actor, openVerb, self, nil, nil, EC_HIDE_SUCCESS);
	    if (err = EC_SUCCESS)
		return self.windowdest;
	    else
		return nil;
	}
	else {
	    "\^<<actor.youll>> have to open <<self.objthedesc(actor)>> first.";
	    setit(self);
	    return nil;
	}
    }
    verDoOpen(actor) = {
	if (self.isopen)
	    "\^<<self.subjthedesc>> <<self.is>> already open.";
	else if (self.islocked)
	    "\^<<actor.youll>> have to unlock <<self.objthedesc(actor)>> first.";
    }
    doOpen(actor) = {
	self.setIsopen(true);
	self.openmessage(actor);
    }
    verDoClose(actor) = {
	if (not self.isopen)
	    "\^<<self.subjthedesc>> <<self.is>> already closed.";
    }
    doClose(actor) = {
	self.setIsopen(nil);
	self.closemessage(actor);
    }
    verDoLock(actor) = {
	if (self.islocked)
	    "\^<<self.subjthedesc>> <<self.is>> already locked.";
	else if (not self.islockable)
	    "\^<<self.subjthedesc>> can't be locked.";
	else if (self.isopen)
	    "\^<<actor.youll>> have to close <<self.objprodesc(actor)>> first.";
    }
    doLock(actor) = {
	if (self.key = nil)
	    self.doLockwith(actor, nil);
	else
	    askio(withPrep);
    }
    verDoUnlock(actor) = {
	if (not self.islocked)
	    "\^<<self.subjthedesc>> <<self.is>> not locked.";
    }
    doUnlock(actor) = {
	if (self.key = nil)
	    self.doUnlockwith(actor, nil);
	else
	    askio(withPrep);
    }
    verDoLockwith(actor, io) = {
	if (self.islocked)
	    "\^<<self.subjthedesc>> <<self.is>> already locked.";
	else if (not self.islockable)
	    "\^<<self.subjthedesc>> can't be locked.";
	else if (self.key = nil)
	    "\^<<actor.subjthedesc>> <<actor.doesnt>> need anything to lock <<self.objprodesc(actor)>>.";
	else if (io <> self.key)
	    "\^<<io.subjthedesc>> <<io.doesnt>> fit the lock.";
	else if (self.isopen)
	    "\^<<actor.youll>> have to close <<self.objprodesc(actor)>> first.";
    }
    doLockwith(actor, io) = {
	self.setIslocked(true);
	self.lockmessage(actor);
    }
    verDoUnlockwith(actor, io) = {
	if (not self.islocked)
	    "\^<<self.subjthedesc>> <<self.is>> not locked.";
	else if (self.key = nil)
	    "\^<<actor.subjthedesc>> <<actor.doesnt>> need anything to unlock <<self.objthedesc(actor)>>.";
	else if (io <> self.key)
	    "\^<<io.subjthedesc>> <<io.doesnt>> fit the lock.";
    }
    doUnlockwith(actor, io) = {
	self.setIslocked(nil);
	self.unlockmessage(actor);
    }
    verDoTapon(actor) = {
	if (self.isopen)
	    "%You% can\'t tap on <<self.objthedesc(actor)>> - it is open! ";
	else {
	    if (self.isbroken)
		"You can\'t tap on the broken window. ";
	}
    }
    doTapon(actor) = {
	"%You% <<tapVerb.desc(actor)>> <<self.objthedesc(actor)>>. "; 
    }
    verDoEnter(actor) = { }
    doEnter(actor) = {
	actor.travelto(self.destination);
    }
    verDoBreak(actor) =
    {
	if (self.isbroken) "\^<<self.subjthedesc>> <<self.isplural ? "are" : "is">> already broken! ";
    }
    doBreak(actor) =
    {
	"%You% <<breakVerb.desc(actor)>> <<self.objthedesc(actor)>>. ";
	self.isbroken := true;
    }
    verDoLookthrough(actor) = { }
    doLookthrough(actor) = { "You gaze through <<self.thedesc>> and see the world beyond. "; }
    doSynonym('Enter') = 'Gothrough'
    doSynonym('Tapon') = 'Knockon'
    openmessage(actor) = { "Open."; }
    closemessage(actor) = { "Closed."; }
    lockmessage(actor) = { "Locked."; }
    unlockmessage(actor) = { "Unlocked."; }	    
;

class SealedWindow: Window
    iscleared = nil
    autoclear = nil
    replace destination(actor) = {
	if (not self.isbroken)
	    "The window is sealed, preventing entry. ";
	else {
	    if (not self.iscleared and self.autoclear) {
		local err;
		"(Clearing away the broken glass first)\n";
		err := execCommand(actor, clearVerb, self, nil, nil, EC_HIDE_SUCCESS);
		if (err = EC_SUCCESS)
		    return self.windowdest;
		else
		    return nil;
	    }
	    else {
		if (not self.iscleared) {
		    "You should clear away the broken glass first. ";
		    return nil;
		}
		else
		    return self.windowdest;
	    }
	}
    }
    verDoOpen(actor) = { "You can\'t open a sealed window! "; }
    doOpen(actor) = {}
    verDoClose(actor) = { "You can\'t close a sealed window! "; }
    doClose(actor) = {}
    verDoLock(actor) = { "You cannot lock this kind of window. "; }
    doLock(actor) = {}
    verDoUnlock(actor) = { "You cannot unlock this kind of window. "; }
    doUnlock(actor) = {}
    verDoLockwith(actor,io) = { "You cannot lock this kind of window. "; }
    doLockwith(actor, io) = {}
    verDoUnlockwith(actor,io) = { "You cannot unlock this kind of window. "; }
    doUnlockwith(actor,io) = {}
    verDoClear(actor) = {
	if(not self.isbroken) "There is nothing to clear away!";
    }
    doClear(actor) = {
	"You pull your hand inside your jacket arm and sweep away the broken
	 glass, leaving a relatively safe passage through the window.";
	self.iscleared := true;
    }
    verDoEnter(actor) = {
	if (self.isbroken and not self.iscleared)
	    "You are wary about sliding through the window with so much broken glass about. Maybe you should clear it away first. ";
	if (not self.isbroken)
	    "You can\'t go through the window as it is sealed shut. ";
    }
    doBreak(actor) = {
	addword(self, &adjective, 'broken');
	addword(self, &adjective, 'smashed');
	addword(self, &adjective, 'shattered');
	pass doBreak;
    }
;


		
//
// Handy dandy DVD case.
// NEEDS: Knowledge of DVD before opening it, reveal dvd inside when opening, only take DVDs.
//
class DVDCase: Qcontainer, Openable, Readable, Item
    sdesc = "DVD case for <<self.DVDtitle>>"
    readdesc = "Long and interesting review of the DVD <<self.DVDtitle>>. "
    openmessage(actor) = { "\^<<self.thedesc>> clicks open. "; }
    closemessage(actor) = { "You click <<self.thedesc>> closed. "; }
    mydvd = nil
    DVDtitle = {return self.mydvd.DVDtitle; }
;

//
// Handy dandy DVD disc. Compatible with the DVD case.
// NEEDS: Throw code
//
class DVDDisc: Readable, Item
    sdesc = { "DVD of <<self.DVDtitle>> ";}
    DVDtitle = 'Blank CD'
    isclean = true
    isscratched = nil
    smudgedmessage(actor) = { "\^<<self.thedesc>> is horribly smudged. "; }
    scratchedmessage(actor) = { "Oh no! It's scratched!"; }
    readdesc = {"\(<<self.DVDtitle>>\)"; }
    touchdesc = { self.isclean := nil; "You glide your fingers across the perfectly uniform surface of the disc. Oops, smudges. "; }
    smelldesc = "You inhale deeply, and only barely detect the plastic processing plant scent on the DVD. "
    tastedesc = { self.isclean := nil; "You lick the DVD, and ponder the taste. Hmmm... tastes like <<self.DVDtitle>>. ";}
    verDoClean(actor) = {}
    doClean(actor) = {
	self.isclean := true;
	"Using a soft part of your shirt you clean <<self.thedesc>>";
    }
    verDoBreak(actor) = {}
    doBreak(actor) = { "You think it'd be bad karma to break someone else's <<self.DVDtitle>> DVD. Do unto others... "; }
    verDoEat(actor) = { "You have neither the chewing ability nor the stomach to eat <<self.thedesc>>. ";}
    verDoFlip(actor) = {}
    doFlip(actor) = { "You flip <<self.thedesc>> in the air, and fumble to
		       catch it. They might offer superior visuals and sound,
		       but they sure aren't aerodynamic. "; }
    verDoHit(actor) = { "You promised yourself when you were younger that you\'d never hit a girl or compact multimedia sources. You wouldn't mind smashing up a BetaMax(tm) tape, though. "; }
    verDoPoke(actor) = {}
    doPoke(actor) = { self.isclean := nil; "You poke idly at <<self.thedesc>>, leaving only oily smudges."; }
    verDoScrew(actor) = { "\^<<self.thedesc>> is something that cannot be screwed. In all senses of the word. "; }
    verDoSiton(actor) = { "DVDs are compact, not comfortable! "; }
    verDoWear(actor) = { "As avant garde you may consider yourself to be, DVDs are not fashion accessories. ";}
    doDrop(actor) = { self.isscratched := true; pass doDrop;}
;

Sky: Everywhere, Distant
    noun = 'sky' 'firmament' 'up'
    sdesc = "the sky"
    isdetermined = true
    roomprop = &sky
    roomdescprop = &skydesc
    allowedverbs = [inspectVerb throwVerb shootVerb kissVerb]
    kissedtimes = 0
    verDoKiss(actor) = {}
    doKiss(actor) = {
	self.kissedtimes := (self.kissedtimes + 1) % 2;
	switch(self.kissedtimes) {
	    case 1:
	    "From somewhere far away the wind carries along the electrifying sounds of Jimi Hendrix. ";
	    break;
	    case 0:
	    "Kiss which guy? ";
	}
    }
;
