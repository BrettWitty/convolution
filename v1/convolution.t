#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>
#include <convmain.h>

gameMain : GameMainDef
    //initialPlayerChar = me
    initialPlayerChar = nihilismMan
    showExitsInStatusline = true
    verboseMode : BinarySettingsItem {
        /* VERBOSE mode is on by default */
        isOn = true

        /* our configuration file variable ID */
        settingID = 'adv3.verbose'

        /* show our description */
        settingDesc = (libMessages.shortVerboseStatus(isOn))
    }
    showIntro() {
        //#ifdef  __DEBUG
	randomize();
        //#endif
	versionInfo.showCredit();
	"*** Press any key to begin ***\b\b";
	morePrompt();
	clearScreen();
	initAboutBox();

	"<.p>The world around you roars and swirls as you are flung from your
        train of thought. Flashing glimpses, words on top of words cascade and
        crash over your mind. In the darkness you rake the air, trying to grab
        something, anything, to keep steady. To stop falling. The thoughts whip
        by you like leaves in a gale. You snatch desperately, at blurs of
        hallways, of a gunshot to the face, of subway trains screeching, of a
        broken leg in a cast, of plains of pure whiteness. You lose balance and
        fall backwards.
        
        <.p>Your back, then skull, strikes something hard and gritty behind you
        and the howling wind dies down, leaving a singing pain in behind your
        eyes. You keep them closed as you breathe hard and try to pull yourself
        together. The razor-slice of pain in your head dulls to a red
        throbbing. Part by part, your body fades into your consciousness. You
        can feel your face, slick with sweat. You can feel your shoulders heavy
        under your trenchcoat. You can feel your arms ending in tight fists.
        You can feel your shaky legs wedging you against a wall. You knuckle
        your brow --- what <i>was</i> that?
        
        <.p>Despite your best and desperate attempts, you can\'t quite make
        sense of it. You stop suddenly and let the pained squint fade from your
        eyes. You hold your breath. No sound. You peer at the surroundings.
        With no explanation, you find yourself leaning against some crumbling
        wall in a basement somewhere, surrounded by delivery boxes. You don\'t
        know where you are but, paradoxically, there is an uneasy feeling of
        familiarity. The fusion of these two feelings bubble inside, boiling
        over into the thought: <q>I gotta get out of here...</q>
        
        <.p>You knuckle your head in confusion again and then wipe your brow on
        your fist. Wait. You turn your fist over revealing a scrap of paper
        caught between your fingers. <i>What the?</i> You stare at the crumpled
        piece of paper as you rise on weak, unstable legs. The exertion
        aggravates your brain with a taut pain. These visions, this headache,
        this place. Something\'s not right.
        
        <.p>You stand up straight, take a cautious breath and a better look
        around...\ <.p>";
	    
	inputManager.pauseForMore(true);

	setPlayer(me);
	    
    }

    showGoodbye() {
        "<.p>Thank you for contributing to <b>Convolution</b>!\b";
    }

    initAboutBox() {
	"<ABOUTBOX><body bgcolor=black>
        <H2 align=center><font color=white face='TADS-Sans'>Convolution</font></H2>
        <center>
        <font color=white>A game of exploration by Brett Witty, 2004.</font>
	 <BR><BR><BR>

	 <P><IMG SRC=\"yinyang.png\">
        </center>
        </AboutBox>";
    }
;

// Game credits
versionInfo: GameID
    name = 'Convolution'
    byline = 'by Brett Witty'
    htmlByline = 'by <a href="mailto:shorokin@hotmail.com">
                  Brett Witty</a>'
    version = ('1.30 - ' + versionType + ' version')
    versionType = 'Alpha'
    authorEmail = 'Brett Witty <shorokin@hotmail.com>'
    desc = 'Convolution is a game of exploration---exploration of location and of self. '
    htmlDesc = '<b>Convolution</b> is a game of exploration---exploration of
        location and of self. '
    IFID = 'cdef7b8d-8aea-789d-5bf7-77b5e9f4b87e'

    showCredit() {
        /* show our credits */
        "<b>Convolution</b>\n By Brett Witty\n Version
	 <<versionInfo.version>>\n (see ABOUT for more information
	 about the game)\b "; 

        "\b";
    } 
    showAbout() {
	"<b>Convolution</b>\n By Brett Witty\n
	 Version <<versionInfo.version>>"
;

nihilismMan : Actor
    location = nowheresVille
;

nowheresVille : Room
    name = ''
    destName = ''
;
