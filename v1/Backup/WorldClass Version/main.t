Me: Player
  noun = 'me' 'self' 'myself'
  location = StartRoom
//  location = TestRoom
  starvationcheck = nil
  dehydrationcheck = nil
  sleepcheck = nil
  ldesc = "You look like ordinary ol' you."
;

modify global
  score = 0
  maxscore = 1000
  full_score = true
  lastactor = Me
  playtesting = true       // Don't forget to change this before distribution!
  verbose = true
  searchisexamine = nil
  toldaboutnotify = nil
;

/* at game startup, turn on HTML mode */
replace commonInit: function
{
    /* display the special code sequence to turn on HTML recognition */
   "\H+";
}

replace userinit: function
{
  /* Print the intro unless we're restarting */
  if (global.restarting = nil) {
    versioninfo(); "\n<hr>\n";
    "\(Convolution\)\n";
    if (global.playtesting)
	"[DEBUG VERSION!]\n";
    "By Brett Witty.\n";
    "Copyright (c) 2004 Brett Witty.\b\b";
    "Warning: This game may contain subject matter that some players may find disturbing or confrontational.\b";
    "For instructions and hints on how to play, consult the readme or use \"help\" or \"instructions\"
    in-game. To play Convolution, press space.";
    morePrompt();
  }

  intro();

  /* Set global.lastactor */
  global.lastactor := parserGetMe();

  /* Move player to starting location */
  parserGetMe().location.enter(parserGetMe());
}

replace intro: function
{
  clearscreen();
  "\b\b\b\b";
  "You suddenly snap out of a train of thought, your head throbbing with pain
   and flashes of something you can't quite catch hold of (or maybe
   understand). Now what was that you were thinking of?\b Despite your best
   and desperate attempts, you can't quite remember... You stop and look
   around. Wait up, where the heck are you? You find yourself leaning against
   some crumbling wall, surrounded by delivery boxes. A cursory inspection
   suggests that this is a basement... But of what? And where?\b You knuckle
   your head in confusion, suddenly noticing a scrap of paper in your fist.
   You stand up straight, take a cautious breath and a better look
   around...\b\b\b";
  morePrompt();
}

//
// New format for the score in status bar (i.e. no turns shown)
//
replace showscore: function(s, t)
{
  return ( s=0 ? ' ' : cvtstr(s));
}

//
// Added a small hack to give players a notice about "notify"
//
replace incscore: function(amount)
{
  if (not global.silentincscore) {
    "\b";
    if (amount > 1)
      "*** Your score just went up by <<amount>> points. ***";
    else if (amount < -1)
      "*** Your score just went down by <<-amount>> points. ***";
    else if (amount = 1)
      "*** Your score just went up by a point. ***";
    else if (amount = -1)
      "*** Your score just went down by a point. ***";
    if (not global.toldaboutnotify)
	{ "\n[You can turn off score notification by typing \'notify\'.]";
	  global.toldaboutnotify := true;
        }
  }
  global.score += amount;
  score_statusline();
}


//
// Implementation of a Insertion Sort. This is okay for small lists (complexity is O(n^2)).
//
Sort: function(list)
{
  local i,j,index,len;
  for (len := length(list), i := 2 ; i < len ; i++)
  {
    index := list[i];
    j := i;
    while ( (j > 0) and (list[j-1] > index))
    {
      list[j] := list[j-1];
      j := j-1;
    }
    list[j] := index;
  }
  return list;
}


