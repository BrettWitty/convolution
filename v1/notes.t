#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

initialScrapOfPaper : Note, Crumpleable
    vocabWords = '(up) piece scrap crumpled crumpled-up initial paper/scrap/note'
    name = 'crumpled-up scrap of paper'
    disambigName = 'initial scrap of paper'
    location = me
    readDesc = "The writing looks to be dashed off quickly. <<isRead
		? 'You read it again: ' : 'It reads: '>> <q>Get out!
		Save yourself!</q> <.reveal get-out>
		<<hasBeenRead>> "
    hasBeenRead {
	if(isRead)
	    return '';
	else {
	    isRead = true;
	    return 'Ooookaay... ';
	}
    }
    isRead = nil
    isCrumpled = true
    hasBeenCrumpled = true
    isFolded = nil
    isFoldable = true
    crumpledDesc = "It is a ball of torn paper. <<isRead ? '' : 'Snippets of
		    words between the crevices suggest it may have something
		    written on it.'>> "
    postCrumpledDesc = "It appears to be a scrap of paper, hastily torn from a
		    notebook and then crumpled up. There is some scribbled
		    writing on one side."
;

backRoomCard : CreepyNote 'plain cardboard card packing piece note/card/cardboard' 'plain piece of cardboard'
    location = nil
    leadInMsg = "On the plain piece of packing cardboard, written
		 with permanent marker is a curious note: <BQ>"
    leadOutMsg = "</BQ> "
    messageText = "<FONT FACE=TADS-Sans><B>I think the Mafia are in
		   on this. Gotta play it straight - be set
		   free.</B></FONT>"
    unfoldedDesc = (readDesc)
    foldedDesc = "The card is a torn-off piece of packing cardboard,
		  folded in two. "
    isFolded = true
    newName = 'note about the mafia'
    newVocabWords = 'mafia note'
;

receptionMessage : CreepyNote 'random yellow memo/note/paper/memorandum' 'yellow memo'
    location = nil
    leadInMsg = "A message has been written on a yellow <q>While You Were Out</q> memo. The writing is not the same loopy style as the rest of the papers in the reception area, but is angular, almost as if written with a calligraphy pen. It reads: <BQ>"
    leadOutMsg = "</BQ> "
    messageText = "I am not an adventurer by choice but by fate.<BR>\t\t\t\t--- Vincent van Gogh "
    unfoldedDesc = (readDesc)
    foldedDesc = "The thin, yellow memo has been folded over for easy safekeeping. "
    isFolded = nil
    newName = 'Vincent van Gogh quote'
    newVocabWords = 'vincent van gogh quote/memo'
;

receptionFilingCabinetNote : CreepyNote
    vocabWords = 'piece sheet loose paper/note/sheet'
    name = 'sheet of paper'
    disambigName {
	if(!hasBeenTaken)
	    return 'loose sheet of paper';
	else
	    return name;
    }
    location = receptionFilingCabinets.subContainer
    leadInMsg = "In dashed off writing, the <<hasBeenCrumpled ?
		 'crumpled' : 'crisp'>> piece of paper reads: <BQ>"
    leadOutMsg = "</BQ> The rest of the sheet is blank. <.p>" //"
    messageText = "They are hidden everywhere! Find them. They are
		   your only hope! "
    okayTakeMsg {
	if(!hasBeenTaken) {
	    hasBeenTaken = true;
	    cmdDict.removeWord(self,'loose',&adjective);
	    return 'You pull out the errant piece of paper and pocket it.';
	}
	else
	    return playerActionMessages.okayTakeMsg;
    }
    isListedInContents = (location != receptionFilingCabinets.subContainer)
    isListed = (location != receptionFilingCabinets.subContainer)
    hasBeenTaken = nil
    unfoldedDesc = (readDesc)
    foldedDesc = (readDesc)
;

noteFromCreator : CrumpleableNote
    location = glassDoorHandles
    vocabWords = 'pale professional looking stylish note/letter/message/paper*notes'
    name = 'professional-looking letter'
    initSpecialDesc = "A pale, folded piece of paper balances on top
		       of the handles of the glass doors. "
    foldedDesc = "This letter is quite stylish but ominous. It
		  consists of a onion-skin paper, closed with three
		  sharp folds. On the front is an intricate embossed
		  design. The intense precision suggests it means
		  business and the excessive professionalism
		  suggests the business will not be friendly. "
    unfoldedDesc = "Something is definitely off-putting about the open
		    letter. It has been printed immaculately (almost
		    mechanically) on professional onion-skin paper,
		    closed with three sharp, neat folds. The letter
		    itself is as deliberate as the presentation ---
		    three punchy lines of text with no signature.
		    Most intriguingly, it's addressed to you. "
    readDesc = "Casting your eyes over the letter, you notice
		immediately it has been addressed to you. You read
		further:\b\b\b\t Now that you are up and about, you
		are invited to see us upstairs to try again to
		resolve this matter.\b\t Room 777.\b\b\b What the
		hell? Resolve what matter? Why don't they just let
		you out of here? You fold up the letter and put it
		away, shaking your head in disbelief.
		<<makeFolded(true)>><<gSetKnown(room777Topic)>>" // '
    isFolded = true
    hideFromAll(action) { return true; }
    foldMe {
	makeFolded(true);
    }
    foldMsg {
	local obj = self;
	gMessageParams(obj); "{You/he} neatly refold{s} {the obj/him}. ";
    }
;

abandonedKitchenNote : CreepyNote 'neat square paper/note/memo' 'neat square of paper'
    location = abandonedKitchenBench
    initDesc = "A smooth piece of paper lies quietly on the bench. "
    leadInMsg = "In very deliberate block letters the note reads: <BQ>"
    leadOutMsg = "</BQ> <.p>"
    messageText = "Sadly, you never can really abandon this place. "
    unfoldedDesc = "The note consists of plain square of paper with some writing on it. "
    foldedDesc = "The note has been neatly folded in two. "
    newName = 'abandonment note'
    newVocabWords = 'abandon abandonment note'
;

abandonedFloorboardNote : CreepyNote 'roughly folded bunch scrap scrap/paper/note/memo' 'folded bunch of paper'
    location = abandonedFloorboard
    leadInMsg = "The piece of paper reads: <BQ>"
    leadOutMsg = "</BQ> The paper has been torn off here, leaving the sentence unfinished. "
    messageText = "YOU MUST BE\b WARNED ABOUT"
    unfoldedDesc = "The thin scrap of paper has rough fold creases and a roughly ripped bottom. "
    foldedDesc = "This scrap of paper is folded over roughly into an careless V shape. "
    isListedInContents = nil
    isListed = nil
    newName = 'unfinished warning'
    newVocabWords = 'unfinished warning'
;

dudeUnderBedNote : CreepyNote 'curious plain white sticky card/note/memo/cardboard' 'plain white piece of card'
    location = nil
    leadInMsg = "The plain piece of card has simply the phrase <BQ>"
    leadOutMsg = "</BQ> written on it. <.p>"
    messageText = "Who are you? "
    unfoldedDesc = "The card is simply a plain piece of card with sticky
		    residue on one side and the single, insistent
		    question: <Q>Who are you?</Q> on the other. "
    foldedDesc = "The white piece of card has been folded with a single crease. Inside the fold is some writing. "
;


lockedStudyHiddenNote : CreepyNote 'lime green business card/note' 'green business card'
    location = nil
    leadInMsg = "This green piece of card is the usual size of a business card but it has only the curious text <BQ>"
    leadOutMsg = "</BQ> written on it. <.p>"
    messageText = "TTXESSETEIDSCWEIN"
    unfoldedDesc = "The lime green business card has a single line of sharp black type on it. "
    foldedDesc = "The folded business card is bright lime green. A single line of text lies inside the fold. "
    newName = 'cryptic green business card'
    newVocabWords = 'cryptic curious strange TTXESSETEIDSCWEIN green business card'
;


managerCardReaderNote : Note
    vocabWords = 'safe post-it sticky yellow note/memo/memorandum/paper'
    name = 'safe sticky note'
    desc = "The bright yellow sticky note reads: <q>Find out who stole swipe card reader</q> "
    readDesc = (desc)
    initSpecialDesc = "Stuck to the floor of the safe is a yellow sticky note. "
    location = managerSafe
;
