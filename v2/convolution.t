#charset "us-ascii"

#include <adv3.h>
#include <en_us.h>

#include <convolution.h>

versionInfo: GameID
    IFID = '3f6e3ae2-7398-9c9b-6a66-0c67655e3a91'
    name = 'Convolution'
    byline = 'by Brett Witty'
    htmlByline = 'by <a href="mailto:brettwitty@brettwitty.net">
                  Brett Witty</a>'
    version = '1.0'
    authorEmail = 'Brett Witty <brettwitty@brettwitty.net>'
    desc = 'Convolution is a game of exploration---exploration of location and of self. '
    htmlDesc = 'Convolution is a game of exploration---exploration of location and of self. '
    
    genreName = 'Mystery'
    forgivenessLevel = 'Polite'
    licenseType = 'Freeware'
    copyingRules = 'At-Cost Only; Compilations Allowed'
    presentationProfile = 'Multimedia'
    
    showCredit() {
        /* show our credits */
        "<b>Convolution</b>\n By Brett Witty\n Version
	 <<versionInfo.version>>\n (see ABOUT for more information
	 about the game)\b "; 

        "\b";
    } 
    showAbout() {
	"<b>Convolution</b>\n By Brett Witty\n
	 Version <<versionInfo.version>>
        
        <.p>TODO: More info.";
    }

    
;

gameMain: GameMainDef
    /* the initial player character is 'me' */
    initialPlayerChar = nihilismMan
    
    showIntro() {
        
        versionInfo.showCredit();
	initAboutBox();
	"*** Press any key to begin ***\b\b";
	morePrompt();
	cls();
       	initAboutBox();
        
	"<.p>The world around you roars and swirls as you are flung from your
        train of thought. Flashing glimpses, words on top of words cascade and
        crash over your mind. In the darkness you rake the air, trying to grab
        something, anything, to keep steady. To stop falling. The thoughts whip
        by you like leaves in a gale. You snatch desperately at the whirl, at
        blurs of hallways, a bloodied fist descending, subway trains
        screeching, a leg in a cast, a gunshot to the face and plains of pure
        whiteness. You lose balance and fall backwards.
        
        <.p>Piece by piece, your body emerges into your consciousness. A
        singing pain behind your eyes quietens to reveal the full chorus:
        aching gums threatening to buckle inwards, burning cheekbones, a mashed
        stomach. Soon your face comes completely into being and you can feel it
        slick with sweat. Your shoulders are hunched up, your hands locked
        behind you. They suddenly bounce free and you slump forward.
        
        <.p>When you dare open your eyes, you find yourself slumped in a chair
        in a dirty pool of light. Behind you, wood clacks on metal and shoes
        scraping up a cement set of stairs. The footsteps stop. You hold your
        breath. They continue upwards and away.
        
        <.p>With no explanation, you\'ve been left in a spartan basement. The
        crumbling bricks betray no real location, but there is an uneasy
        feeling of familiarity or some sort of subliminal understanding pooled
        in your gut.
                
        <.p>You knuckle your head in confusion and then wipe your brow on your
        fist. Wait. You turn your fist over revealing a scrap of paper caught
        between your fingers. <i>What the?</i> You stare at the caught piece of
        paper as you rise on weak, unstable legs. The exertion aggravates your
        brain with a taut pain. These visions, this headache, this place.
        Something\'s not right. And to top it all off, you feel like you\'ve
        taken a ride inside a cement mixer.
        
        <.p>You stand up straight, take a cautious breath and a better look
        around...\ <.p>";
	    
	inputManager.pauseForMore(true);
        setPlayer(pc);

       
    }
    
    showGoodbye() {
        "<.p>Thank you for contributing to <b>Convolution</b>!\b";
        inputManager.pauseForMore(true);
    }

    initAboutBox() {
	"<ABOUTBOX><body bgcolor=black>
        <H2 align=center><font color=white face='TADS-Sans'>Convolution</font></H2>
        <center>
        <font color=white>A game of exploration by Brett Witty, 2010.</font>
	 <BR><BR><BR>

	 <P><IMG SRC=\"yinyang.png\">
        </center>
        </AboutBox>";
    }

;


nihilismMan : Actor
    location = nowheresVille
;

nowheresVille : Room
    name = ''
    destName = ''
;