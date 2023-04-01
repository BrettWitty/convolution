// The Magical Hint book

// Implement reading of other sections, turning pages (2, "two" and "how to")

// Implement sensing of objects, hooks for puzzles to update text

// I'd like to disable "rotate" "twist" etc synonyms for "turn to"

// Modify doTurnto to &canusealphanum

// Redirect TurnOff from HintBook to HummingSwitch (same as TurnOn)

HintBook: Readable, Sensor, Item
  location = HintBookPackage
  noun = 'book' 'hints' 'guide' 'cheats' 'help'
  adjective = 'hint' 'guide' 'cheat' 'weird' 'nifty' 'futuristic-looking' 'futuristic'
  sdesc = "the hint book"
  ldesc = {"A nifty looking hint book. ";
    if (self.isopen)
      {"It is opened to a section entitled \""; say(self.sections[self.currentsection]); "\". ";}
    "You notice a <<self.automaticreading ? "illuminated" : "darkened">> red button discreetly set into the corner of the book. Below it
    is a tiny switch that is set to <<self.humming ? "on" : "off">>. ";
  }
  isdetermined = true

  // When we turn the book to a section, this keeps a virtual bookmark.
  // It is reset if we close the door.
  currentsection = 1

  // The section headings for the different hints.
  sections = [ 'Contents' 'How To Use This Guide' 'Purpose']

  // The available section headings at the given time. These must correspond
  // with the sections property.
  available = [ 1 2 ]

  // Sets whether the book is held open at the current time.
  isopen = nil

  // Automatically read when you turn to a new section?
  automaticreading = nil

  // Hum when we get a new hint?
  humming = true

  // Overrides the standard doOpen etc verbs.
  verDoOpen(actor) = {
    if (self.isopen)
      "\^<<self.subjthedesc>> <<self.is>> already open.";
  }
  doOpen(actor) = {
    self.isopen := true;
    self.openmessage(actor);
  }
  verDoClose(actor) = {
    if (not self.isopen)
      "\^<<self.subjthedesc>> <<self.is>> already closed.";
  }
  doClose(actor) = {
    self.isopen := nil;
    self.currentsection := 1;
    self.closemessage(actor);
  }
  openmessage(actor) = "You open <<self.subjthedesc>> to the contents page. "
  closemessage(actor) = "You close <<self.subjthedesc>>. "


  // Make the custom doRead
  doRead(actor) = {
    if (not self.isopen)
      {"(first opening <<self.sdesc>>.)"; self.isopen := true;}
    available := Sort(available);
    if (currentsection = 1)
      self.CustomContents(actor);
    else
      self.doReadSection(actor,currentsection);
  }

  // The custom index function
  CustomContents(actor) = {
    local i,len,x;
    "<CENTER><U>Table of Contents.</U></CENTER>\b\b";
    for (len := length(self.available),i := 1 ; i <= len ; i++)
    {
      "\t\t ";
      say(i);
      ". ";
      x := self.sections[available[i]];
      say(x);
      ".\n";}
  }

  doReadSection(actor,section) = { say(self.hinttext[section]); }

  verDoTurnto(actor,io) = { }

  doTurnto(actor,io) = {
    local n;
    if (isclass(io,Number))
      n := io.value;
    else
      if (isclass(io,String))
      {
        switch(io.value)
        {
           case 'one':
           n := 1; break;
           case 'two':
           n := 2; break;
           default:
           n := 1; break;
        }
      }
    self.currentsection := self.available[n];
    self.turntomessage(actor,n);
    if (self.automaticreading)
      self.doRead(actor);
  }

  doTurnon(actor) = {

  }

  // Messages to help the VR.
  turntomessage(actor,section) = "You turn <<self.thedesc>> to Section <<section>>. "
  turnonmessage(actor) = "You flick the little switch on <<self.thedesc>>. "
		hinttext = [ 'BLANK' 'This hint book is designed to be a
		portable way of receiving hints without breaking the virtual
		reality. It works like a book. Use the \'turn hint book to n\' to
		go to Section n. Enter n as a number like 1 or 6. To read the
		current section, type \'read hint book\'.\b The book does not
		automatically (by default) read the page when you turn to a
		new section, so you don\'t accidentally see hints if you
		mistype the section number. If you want the book to
		automatically read the section, type \'push automatic reading
		button\'. Push the button again to revert to the default
		behaviour. The red light on the book indicates the current
		setting.\b You can open and close the book. Closing it loses
		your place (reopening the book brings you to the contents
		page).\b Every so often, the hint book will hum if it has
		added a new hint. You can turn off the hum by \'turn off hint
		book\'. If you miss the humming, use \'turn on hint book\'.\b Don\'t
		worry about losing this book. You can use \'summon hint book\' to
		magically bring it to your person (regardless of where it
		was). You can\'t break the hint book though you can try if you
		like. ' ] ;

AutomaticReader: Part
    partof = HintBook
    noun = 'button'
    adjective = 'automatic' 'reading' 'red'
    sdesc = "automatic reading button on hint book"
    ldesc = "The button is discreetly set into one corner of the book. <<HintBook.automaticreading ? "It is illuminated by a small LED,
           indicating that automatic reading is enabled." : "It is currently dark, but if it were lit up, that would mean automatic reading
           is enabled. Clearly this option is currently disabled.">> "

  verDoPush(actor) = {
    if( not self.istouchable(actor))
      "You need to be near <<HintBook.thedesc>> to do that!";
  }

  doPush(actor) = {
    // Negate the current value.
    HintBook.automaticreading := not HintBook.automaticreading;
    // It currently is true, so it must have been nil before.
    if (HintBook.automaticreading)
       "You push the button and it lights up in a dull red.\b (Automatic reading is now ON) ";
    else
       "You push the button and watch the red LED slowly fade out.\b (Automatic reading is now OFF) ";
  }
;

HummingSwitch: Part
  partof = HintBook
  noun = 'switch'
  adjective = 'tiny' 'humming'
  sdesc = "tiny switch on hint book"
  ldesc = "This switch is set into the cover of the hint book. It controls
	   whether the book hums or not. Currently <<HintBook.humming ? "the switch is set to \"on\"" : "the switch is off, stopping any humming">>. "

  verDoPush(actor) = {
    if( not self.istouchable(actor))
      "You need to be near <<HintBook.thedesc>> to do that!";
  }

  doPush(actor) = {
    // Negate the current value.
    HintBook.humming := not HintBook.humming;
    // It currently is true, so it must have been nil before.
    if (HintBook.humming)
       "You flick the switch up and <<HintBook.thedesc>> responds with a
	gentle beep.\b (Humming is now ON) ";
    else
       "You flick the switch down and <<HintBook.thedesc>> responds with an
	abrupt bloop.\b (Humming is now OFF) ";
  }
;
