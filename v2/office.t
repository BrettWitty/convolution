#include <convolution.h>

/*
 *   Office
 *
 *   An office tucked away in the back of Convolution Towers. It is 
 *   necessarily messy with a bunch of flavour objects and clues/red herrings.
 *
 *   To do:
 *   - Put stuff in the safe
 *   - Put stuff in the table
 *   - Descs
 */

office : Room
    roomName = 'Office'
    
    desc = "Office. "
    
    west = backRoom
    
;

+ officeDesk : Heavy, ComplexContainer
    vocabWords = 'office desk/table'
    name = 'desk'
    
    desc = "Office desk. "
    
    inRoomDesc = "An office desk sits in the middle of the room. "
    
    subSurface : ComplexComponent, Surface {}
    subUnderside : ComplexComponent, Underside {
    
        allowPutUnder = nil
        
        dobjFor(LookUnder) {
            action() {
                
                if( russianNote.discovered )
                    mainReport( 'There is nothing else under the desk of
                        note. ' );
                else {
                    mainReport( 'You duck down below the desk and look up. To
                        your surprise, you see a scrap of memo paper stuck to
                        the underside of the desk. You peel it off and put it in
                        your pocket. ' );
                    russianNote.discover();
                    russianNote.moveInto( gActor );
                }
            }
        }
    }
    subContainer : ComplexComponent, OpenableContainer {
        vocabWords = 'desk drawer'
        name = 'desk drawer'
        
    }
    
;

// filing cabinet

+ filingCabinet : Surface, Heavy
    vocabWords = 'filing cabinet'
    name = 'filing cabinet'
    
    desc = "Tucked up against the corner is a standard-issue, two-drawer metal
        filing cabinet. \^<<myOpenStatus>>. "
    
    myOpenStatus() {
        local top = filingCabinetTopDrawer.isOpen();
        local bottom = filingCabinetBottomDrawer.isOpen();
        
        if( top && bottom )
            return 'both drawers are open';

        if( top )
            return 'the top drawer is open';
            
        if( bottom )
            return 'the bottom drawer is open';
        
        return 'both drawers are closed';
        
    }
    
    drawers = [ filingCabinetTopDrawer, filingCabinetBottomDrawer ]
    openObjPhrase = 'drawer'
    
    dobjFor(Open) {
        preCond = []
        verify() { logical; }
        check() {}
        action() {
            
            OpenAction.retryWithAmbiguousDobj( gAction, drawers, self,
                                              openObjPhrase );
            
        }
    }
    
;

++ filingCabinetTopDrawer : OpenableContainer, Component
    vocabWords = 'top drawer'
    name = 'top drawer'
    
    desc = "Top drawer. "
    
    owner = filingCabinet
    
    initiallyOpen = nil
    
;

++ filingCabinetBottomDrawer : OpenableContainer, LockableWithKey, Component
    vocabWords = 'bottom drawer'
    name = 'bottom drawer'
    
    desc = "Bottom drawer. "
    
    owner = filingCabinet
    
    initiallyOpen = nil
    initiallyLocked = true
    
;

// Planning board

+ planningBoard : Readable
    vocabWords = 'planner planning white erasable board/planner/whiteboard'
    name = 'planning board'
    
    desc = "Planning board. "
    
    readDesc = "There is a lot of stuff written on this board...
        <.p><<msgList.doScript()>>"
    
    msgList : ShuffledEventList {
        firstEvents = [
            '\"Move crap in back room to storage\" is written here in faded
            marker.',
            'In angry writing: \"<b>CODY RENT+++++</b>\"'
        ]
        eventList = [
            '\"Move crap in back room to storage\" is written here in faded
            marker.',
            'In amongst a list of random maintenance junk, someone has hidden:
            \"3rd perfect is safe\"',
            'Someone has written: <b><font face=\"Arial,Geneva,TADS-Sans\"
            color=#ff0000>Fix doors!!!</font></b>',
            'Across the middle of the board, someone has written \"204 nuisance
            again. Blocked stairwell?\"',
            'It says: \"Reminder: Gifts for Asian couple.\"',
            'You almost overlooked it, but in the corner, written in tiny,
            secretive writing is a note: \"They are hidden everywhere! Find
            them. They are your only hope!\" Weird.',
            'The words: \"Janitor payrise\" are struck through a few times.
            Looks like someone isn\'t getting their raise. '
        ]
    }
        
    
;

// picture hiding safe
+ officePainting : Openable, Thing
    vocabWords = 'framed painting/picture'
    name = 'painting'
    
    desc = "Office painting. "
    
    descContentsLister = officePaintingContentsLister
    
    makeOpen(x) {
        inherited(x);
        
        officeSafe.makePresentIf( x );
        
        reportAfter('Moving the painting aside reveals a safe. ');
        
    }
    
    dobjFor(Pull) asDobjFor(Open)
    dobjFor(Move) asDobjFor(Open)
    
    dobjFor(Push) asDobjFor(Close)
;

+ officeSafe : PresentLater, ComplexContainer
    vocabWords = '(wall) safe/lockbox/vault/coffer'
    name = 'wall safe'
    
    desc = "Set into the wall behind the painting is an old-school wall safe.
        The front face is a rough black metal with an array of buttons in the
        middle. The buttons go from 0 to 9, and have a button with a dash on it
        and another with a key on it. "
    
    inRoomDesc = "Hidden away behind the painting is a<<subContainer.isLocked()
          ? ' locked' : ''>> safe. "
    
    subContainer : ComplexComponent, IndirectLockable, OpenableContainer {
    
        initiallyOpen = nil
        initiallyLocked = true
        
        makeOpen( val ) {
            
            inherited( val );
            if( val == nil ) {
                makeLocked(true);
                reportAfter('The safe door whirrs and locks. ');
            }
        }
        
        
    }
    
    safeCombo = [ 4, 9, 6 ]
    
    safeProgress = []
    
    doReset() {
        safeProgress = [];

        reportAfter('The button pad makes a solid <i>click!</i> sound. ');
        
    }
    
    doDigit(x) {
        
        // If we've entered too many numbers it will reset
        if( safeProgress.length() == safeCombo.length() ) {
            doReset();
        }
        
        safeProgress = safeProgress.append( x );
        
    }
    
    doCheckCombo() {
        
        if( safeProgress == safeCombo ) {
            reportAfter( 'From inside the safe you hear a small whirring. The
                safe door pops open! ');
            officeSafe.subContainer.makeLocked(nil);
            officeSafe.subContainer.makeOpen(true);
        }
        else
            doReset();
        
    }
        
    
;

+ officeSafeDoor : ContainerDoor '(safe) (front) door/panel/face' 'safe door'
    "The front face is a rough black metal with an array of buttons in the
    middle. The buttons go from 0 to 9, and have a button with a dash on it and
    another with a key on it. "

    subContainer = (officeSafe.subContainer)
;

SafeButton    digit = 0;
SafeButton    digit = 1;
SafeButton    digit = 2;
SafeButton    digit = 3;
SafeButton    digit = 4;
SafeButton    digit = 5;
SafeButton    digit = 6;
SafeButton    digit = 7;
SafeButton    digit = 8;
SafeButton    digit = 9;

officeSafeKeyButton : Button, Component
    vocabWords = 'key unlock open button*buttons'
    name = 'unlock button'
    
    location = officeSafeDoor
    
    desc = "This button is marked with a little key. You guess it's the button
        to confirm the code. "
    
    dobjFor(Push) {
        
        action() {
            
            officeSafe.doCheckCombo();
            
        }
        
    }
;

Button, Component
    vocabWords = 'R/reset/dash/-/button*buttons'
    name = 'reset button'
    
    location = officeSafeDoor
    
    desc = "This button is marked with a dash. You guess it's a reset button. "
    
    dobjFor(Push) {
        
        action() {
            
            officeSafe.doReset();
            
        }
        
    }
;



officePaintingContentsLister: thingContentsLister
    showListEmpty(pov, parent)
    {
        "";
    }
    showListPrefixWide(itemCount, pov, parent)
    {
        "";
    }
;