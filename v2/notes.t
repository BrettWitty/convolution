#include <convolution.h>

class Note : Readable, Thing
    weight = 1
    bulk = 1
    
    newName = (name)
    newVocabWords = (vocabWords)
    newDisambigName = (disambigName)
    dobjFor(Read) {
        preCond = (inherited() + objHeld);
	action() {
	    inherited();

	    // Do name change things to make life easier
	    name = newName;
	    disambigName = newDisambigName;
	    initializeVocabWith(newVocabWords);

	}
    }
;

initialScrapOfPaper : Note
    vocabWords = 'initially initial torn scrap paper/scrap/note'
    name = 'scrap of paper'
    disambigName = 'scrap of paper you had initially'
    location = pc
    
    desc = "A scrap of paper, torn from some notebook. <<readDesc>> "
    
    readDesc { 
        "The writing on it looks to be dashed off quickly. ";
        
        if( isRead )
            "You read it again: <q>Get out! Save yourself!</q> ";
        else
            "It reads: <q>Get out! Save yourself!</q> ";

        isRead = true;
    }
        
    isRead = nil
;

letterFromGod : Note
    vocabWords = 'professional stylish formal clean fancy onion skin onion-skin
        letter/note/message/paper/card'
    name = 'fancy letter'
    
    location = alleywaySouth
    
    desc = "On a single piece of professional onion-skin card is a note,
        curiously addressed to you. It reads: <q>You are, again, in my debt
        more than you know. Come pay me a visit to sort out this whole
        business. Room 1, Level 7.</q> The only other marking on the card is
        some sort of corporate logo on the top-right corner of the page:
        <center><img src=\"EndlessKnot.png\" width=64 height=64></center> "
    
    initSpecialDesc = "In stark contrast to the grime and junk of the alleyway
        around it stands a clean, professional card. "
    
    isOnGround = true
    
    okayTakeMsg {
        if( isOnGround ) {
            isOnGround = nil;
            return '{You/he} {bend[s]|bent} over and {pick[s]|picked} up {the
                dobj/him}. ';
        }
        else
            return '{You/he} {take[s]|took} {the dobj/him}. ';
    }
    
;

backRoomCard : Note
    vocabWords = 'plain cardboard card packing piece note/card/cardboard'
    name = 'plain piece of cardboard'
    location = nil
    
    desc = "On the plain piece of packing cardboard, written with permanent
        marker is a curious note: <BQ><FONT FACE=TADS-Sans><B>I think the Mafia
        are in on this. Gotta play it straight - be set free.</B></FONT></BQ>"

    newName = 'note about the mafia'
    newVocabWords = 'mafia note'
;

russianNote : Hidden, Note
    vocabWords = 'torn piece russian scrap/memo/paper/note'
    name = 'torn scrap of memo paper'
    disambigName = 'torn scrap of paper with Russian on it'
    
    location = officeDesk.subUnderside
    
    desc = "On this torn piece of memo paper is a short phrase, probably in
        Russian. Just below it is something more English-looking:
        \"<<russianBit>>\" Too bad you can\'t make sense of either. "
    
    russianBit = 'V tikhom omute cherti vodyatsa.'
    
    isListedInContents = (discovered)
    
    newName = 'some Russian phrase'
    newDisambigName = 'the Russian phrase'
    newVocabWords = 'torn piece russian cyrillic
        scrap/paper/note/phrase/proverb/message'
    
;

vanGoghNote : Note
    vocabWords = 'yellow sticky note/memo/paper*notes*papers'
    name = 'yellow sticky note'
    
    desc = "A message has been written on a yellow <q>While You Were Out</q>
        memo. The writing is not the same angular style as the rest of the papers
        in the office, but is loopy, almost as if written with a
        calligraphy pen. It reads: <bq>I am not an adventurer by choice but by
        fate.<BR>\t\t\t\t--- Vincent van Gogh</bq>"
    
    newName = 'Vincent van Gogh quote'
    newVocabWords = '(yellow) (sticky) vincent van gogh
        quote/memo/note*notes*papers*quotes'
    newDisambigName = 'Vincent van Gogh quote'
;