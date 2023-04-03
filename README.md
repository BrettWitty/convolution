This is an archive of the entire code, planning and artifacts for the abandoned game "Convolution" by Brett Witty (brettwitty@brettwitty.net). It is preserved so people can learn from the code for working example, and the design documents as cautionary examples.

I'll take PRs for the externals of the project, but not anything in `v1`, `v2` or `archives`. Feel free to contact me about the project.

## How to play

Any of the versions in `archives` can be run with a multimedia TADS 3 interpreter like [QTads](https://realnc.github.io/qtads/).

You can also play it via Parchment: [(last version)](https://iplayif.com/?story=https%3A%2F%2Fgithub.com%2FBrettWitty%2Fconvolution%2Fraw%2Fmain%2Farchives%2Fconvolution-v1.30-2005-04-04.t3)

Note that the game is far from finished. You might be able to get to the first and second floors, but that's about it. There will be bugs. It is extremely unlikely that I will fix them.

## History

I began writing Convolution on 18th of January, 2004. It began initially as an ADRIFT game, the TADS 2, then in WorldClass (an updated TADS 2 library by Dave Baggett). At the end of March 2004 it started as a TADS 3 game.

I worked on it extensively until the 12th of September 2004. I took a hiatus until January 2005, and then worked on it solidly until late June 2005. Between June and October 2005 I worked on my IF Comp game [Mix Tape](https://ifdb.org/viewgame?id=lfydav1zsoftnwm4). I returned briefly to the game in October 2005, then nothing until March 2006. I worked on it for a month, then broke again until August 2004.

After that the work kinda frittered out into other projects. I restarted Convolution afresh in 2009-2010 but abandoned it again soon after. Following the less-than-stellar results of Mix Tape, I became dispirited with interactive fiction and left for about a decade. I'm back now, and happy to put my old projects out into the sunlight for others to poke at.

At some point in the project I had beta-testers lined up, and have notes from a nice alpha tester called Ronald.

## The Idea

During the development of *Convolution*, I was a single, unburdened maths PhD student with casual interests in philosophy, having entered adulthood during *The Matrix*, *Being John Malkovich* and *Fight Club*. I was a weird combination of smart and clueless, creative and clumsy. This comes through in the game.

*Convolution* is a game rooted in philosophical themes. You wake up in an urban garage with shattered, contradictory memories of violence and confusion. You are driven to enter an apartment complex ("Convolution Towers") and make your way as high as you can. There are puzzles and residents to interact with.

But Convolution Towers is a weird space. You have done this journey before and have left yourself notes and warnings hidden about the place. You appear to be pursued by a lurking horror. As you go higher, the world becomes more abstract and fantastical.

Thematically the game was me riffing on Buddhist reincarnation, virtual reality, a simplistic understanding of Gille Deleuze, and interactive fiction. It started as an aimless lark, grew some themes and metastasised into a bizarre series of puzzles, references and stories.

## Guide to The Code

This code predates git, and I wasn't into other version control software. All code is as it was finally saved.

I have done some minor surgery to the original archive. The first attempt in 2004 is moved to [`v1`](v1/). The second, shorter (also incomplete) rewrite is in [`v2`](v2/). Previously the code in `v1` was a subdirectory of `v2` (as a primitive form of source control).

I moved the project diary [`Timeline.txt`](Timeline.txt) to the top directory as it is an interesting reflection on the project. It is a changelog and development diary of sorts.

I moved the code for the [website](website/) up near the top directory. It is mostly a guide on how not to write a webpage about a project.

I moved all game builds to [`archives`](archives/). These are playable snapshots of development, renamed to include their version and compile date.

I removed all secondary build artifacts (`.t3o` files etc). I've kept the TADS 3 workbench file `convolution.t3m` because it can be used to build the project anew.

The code was all created on Windows machines, predominantly in TADS 3 Workbench, but also in XEmacs for some time.

### Files in `v1`

  * [`amusing.txt`](v1/amusing.txt) is a list of Easter eggs I had implemented.
  * [`Bulk and weight list.txt`](v1/Bulk and weight list.txt) and [`Bulks and weights.sxc`](v1/Bulks and weights.sxc) contain inventory management constants.
  * [`Checklist.txt`](v1/Checklist.txt) is a TO-DO list for things that needed to be implemented. Not a complete or accurate list.
  * [`classes.t`](v1/classes.t) has code for:
    * Foldable and crumpleable notes.
    * Heat as a new sense
    * A Mailbox implementation
    * Swipe cards
    * Timed Autoclosing doors
    * Breakable objects, including windows that can only be opened by breaking them
    * Electrical plug attachments and power sockets
    * A TV
    * Wettable objects
    * Coins
    * Books
    * Appliances like refrigerators, sinks and pay laundry machines
    * Door locks with keyholes
  * [`convactor.t`](v1/convactor.t) has some modifications to expand conversations, including insulting people.
  * [`convhint.t`](v1/convhint.t) contains a fleshed-out example of a hints system.
  * [`convmain.h`](v1/convmain.h) has a PreinitObject that provides a count of rooms, Things and general objects.
  * [`convmisc.t`](v1/convmisc.t) has some custom grammar.
  * [`convolution ideas.txt`](v1/convolution ideas.txt) is a scrapbook of random ideas.
  * [`Convolution notes.txt`](v1/Convolution notes.txt) is the original concept with some notes and ideas.
  * [`conv_str.txt`](v1/conv_str.txt) is a strings output from the latest compile.
  * [`crazy_ramble.txt`](v1/crazy_ramble.txt) is a bit of free association/subconscious writing intended for "The Prisoner".
  * [`Design Rules I Used.txt`](v1/Design Rules I Used.txt) contains some general design rules for the implementation.
  * [`elevator.t`](v1/elevator.t) is an elaborate implementation of an elevator.
  * [`headwound.t`](v1/headwound.t) is a diary that you find detailing your adventures following a gunshot wound to the head.
  * [`Hidden_notes.txt`](v1/Hidden_notes.txt) is a list of thematically-resonating ideas, secret notes and random insanity. These were intended to be hidden EVERYWHERE in the game.
  * [`Level plan.txt`](v1/Level plan.txt) is a rough map of the game.
  * [`library.t`](v1/library.t) is the Library of Convolution, a Borgesian infinite library with books that record different potential starts to the same game that you've been playing. There's a procedural grammar that creates random books.
  * [`lookdir.t`](v1/lookdir.t) is Eric Eve's look direction library.
  * [`mood.t`](v1/mood.t) contains an attempt to track mood with your karma ([`karma.t`](v1/karma.t))
  * [`Objects.txt`](v1/Objects.txt) attempts to list and not explain all the puzzle-relevant objects.
  * [`Old Puzzles.txt`](v1/Old Puzzles.txt) lists puzzles that were removed, or thought of without implementing.
  * [`phone.t`](v1/phone.t) an extremely over-engineered lobby phone that rang randomly, could be used, and tracked whether you had hung up the receiver or not
  * [`props.t`](v1/props.t) a trenchcoat of holding, lockpicking hair pins, some aspirin and an object called "The Tuba Mensch"
  * [`purpose.txt`](v1/purpose.txt) dialogue from Matrix Reloaded from Agent Smith to Neo. A strong inspiration for a number of ideas.
  * [`Puzzles.txt`](v1/Puzzles.txt) is an attempt to write the main puzzle flow for the game.
  * [`Readme.txt`](v1/Readme.txt) was the intended Readme file for the game, if it were to be released.
  * [`Testers.txt`](v1/Testers.txt) is a list of potential betatesters. Only half of this list mean anything to me.
  * [`Todo.txt`](v1/Todo.txt) a list of random things to do, with a vague priorization.
  * [`verbs.t`](v1/verbs.t) contains many custom verbs.

The `.t` files are TADS 3 source for the game, whether connected to the main implemented section or not.

### Files in `v2`

These are mostly rewritten or refactored from `v1`. The world map is condensed and rearranged. Certain large classes are brought out into their own file.

This code is nowhere near as implemented as `v1`.

## Notes on the game

Honestly, it was a grab-bag of incredibly detailed rooms that allowed a few ways to progress up the tower. There is no strong rhyme nor reason to much of it. The last chunk of the game is intended to be akin to *Being John Malkovich* or *Monsters Inc*, and you crash through several *very* disparate areas before meeting your AI creator God.

The theme of "convolution" plays out in a number of ways:
  * Echoes are convolutions of sound with its environment. There are a lot of real and metaphorical echoes.
  * The world is your run through it, but compounded in complicated ways by your predecessors.
  * Your world is neither past nor future of other versions of you. It's like a quantum superposition.
  * Nietszche's Eternal Return is referenced a few times.
  * The storyline and philosophy is nearly intentionally "convoluted"
