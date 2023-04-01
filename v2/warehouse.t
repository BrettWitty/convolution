#include <convolution.h>

/*
 *   The initial room for Convolution.
 *
 *   It's meant to be a stark, uninviting place. There is a chair in the 
 *   center of the room, a crate near the door behind you, and a headless 
 *   corpse next to the door. The corpse is actually you from a previous 
 *   incarnation - a previous Convolute - beheaded by a shotgun blast.
 */    
     

warehouseBasement : Room
    roomName = 'a basement somewhere'
    desc = "Everything about this place suggests this is a basement hidden away
        from the world, perhaps for dark motives. The dusty, crumbling brick
        wall. The lone, bare lightbulb throwing harsh shadows. The cement floor
        mottled with stains that make you uneasy. "
    
    roomParts = [warehouseBasementFloor, warehouseBasementNorthWall,
        defaultCeiling]
    
    roomBeforeAction() {
        if( gActionIs( TravelVia ) ) {
            if( !trenchcoat.isIn( gPlayerChar ) ) {
                if( trenchcoat.described )
                    "Before you leave, you grab your trenchcoat and put it on. ";
                else
                    "Just before you leave, your eyes catch on the trenchcoat
                    by the door. Hey, that\'s <em>your</em> trenchcoat! You
                    snatch it up, put it on and make your way out. ";
                
                nestedAction(Wear, trenchcoat);
                
            }
            else {
                if( !trenchcoat.isWornBy( gPlayerChar ) ) {
                   "As you leave, you put on your trenchcoat. It feels more
                   comfortable over your shoulders than in your hands. ";
                   nestedAction(Wear, trenchcoat);
                }
            }
        }
        
    }
    
    roomAfterAction() {
        
        if( gActionIn(Stand, StandOn, GetOut, GetOutOf) ) {
            
            // Annoying hack because sight knowledge is tricky to schedule
            if( !warehouseDeadBody.beenShocked ) {
                mainReport('You jolt as you turn to see a blood-soaked corpse
                    slumped against the wall. ');
                warehouseDeadBody.beenShocked = true;
            }
        }
    }
   
    north = warehouseBasementToStairwayDoor
;

+warehouseBasementToStairwayDoor : Door
    vocabWords = 'wooden north door/exit/doorway*doors doorways exits'
    name = 'wooden door'
    desc = "A plain wooden door leads to a stairway to the outside. You notice
        a few flecks of blood on the frame. "
    
    feelDesc = "Apart from the few flecks of blood, the door feels old and dry.
        You dare not touch the blood. "
    
    disambigName = 'wooden door to the north'

    initiallyOpen = nil
;

+warehouseBasementFloor : Floor
    vocabWords = 'smooth concrete cement dusty gritty bare
        floor/ground/dust/grit/down/d'
    name = 'concrete floor'
    
    desc = "This place is purely utilitarian. The floor is bare concrete,
        mottled with oil stains, scuff marks and something else you dare not
        recognize. "
    
    feelDesc = "The concrete floor is smooth save for dust and grit. "
    smellDesc = "The floor smells of stale sweat... and something else. "
    tasteDesc = "You\'d rather not lick at the grit and dirt on the floor. "
;

+warehouseBasementNorthWall : defaultNorthWall
    vocabWords = '(grey) (gray) n north crumbling brick wall*walls'
    name = 'north wall'
    
    desc = "The north wall is the same crumbling grey brick as the other walls.
        Scrape marks cut across the wall near a bunch of wooden crates. To the
        right, a slightly ajar door shows the faint glow of outside. "
    
    feelDesc = "Speckles of grey bricks come off on your fingers as you feel
        along the wall. You flick the dust from your hands. "
;

   
+ warehouseCrate : Heavy, Surface
    vocabWords = 'wooden packing crate/box/cube'
    name = 'crate'
    
    desc = "The wooden packing crate looks like it hasn\'t been moved in years.
        It stands about waist-height and is plain save for a spray-painted \'8\'
        on one side. "
    
    bulkCapacity = 100
    weightCapacity = 1000
    
;

++ Readable, Decoration
    vocabWords = 'spray painted eight/8/insignia/infinity'
    name = 'spray-painted \'8\''
    
    desc = "This is just a spray-painted number 8. Although, curiously, the
        paint seems to have dripped to the right. "
;

+ warehouseChair : Chair, Heavy
    vocabWords = '(metal) chair/seat'
    name = 'chair'
    
    desc = "More an array of folded metal bars with the utility of a seat than
        anything anyone would want to sit in. "
;

+ warehouseLight : LightSource, Fixture
    vocabWords = 'lone bare light bulb/lightbulb/light'
    name = 'lightbulb'
    
    desc = "A lone, bare lightbulb hangs over the metal chair. "
    
    feelDesc = "The bulb is quite hot. You figure it\'s been on for a while. "
;

+ warehouseDeadBody : Actor, Heavy
    vocabWords = 'bloody dead headless decapitated
        body/corpse/guy/person/thug/gore'
    name = 'dead body'
    desc = "With an understanding that churns your stomach, this corpse's head
        is the blast pattern of blood and flesh across the wall. Looking at the
        thick smear of gore down the wall you guess that after its explosive
        decapitation the body toppled backwards, smacked against the wall and
        dragged its shoulders along the wall down to where it lies now. Er, his
        body. His decapitation.
        <.p>You shiver. This object has arms and legs and most of the bits that
        make it a person. But without a head, it remains an object to you. "
    specialDescBeforeContents = true
    
    cannotTakeMsg = '{The dobj/he} {is} too heavy, but your bigger concern is
        that it\'s <em>a dead body</em>. Moreover, you\'re sure it\'s not your
        dead body so you better just leave it here and get the hell away. '
    cannotMoveMsg = 'While you could probably shove the body around, the best
        plan is to leave it the hell alone. '
    
    feelDesc = "It takes a tremendous amount of effort, but you risk touching
        the body on the arm. There is a faint warmth to the skin, but a
        disturbing absence of life. You pull your hand away quickly. "
    
    isHim = true
    beenSearched = nil
    beenShocked = nil

    dobjFor(Search) {
        verify() { logical; }
        check() {
            if( beenSearched ) {
                "You already searched him. There\'s nothing. ";
                exit;
            }
        }
        action() {
            "Whispering your apologies, you gingerly search through the dead
            guy\'s pocket. Nothing. No ID. No wallet. Not even pocket lint. The
            way his trouser pockets were pulled out suggest someone\'s got there
            before you. ";
            beenSearched = true;
        }
    }   
   
;

++ HermitActorState
    specialDesc = "Most disturbing of all, a body lies slumped at the base of a
        blood-blasted wall. A thick smear draws down to the headless
        shoulders. "
    specialDescBeforeContents = true
    
    noResponse = "This guy is definitely dead. You try not to look but the
        bloody fragments of his head scream loud in your mind. "
    isInitState = true
;

// The occluder for when you're in the chair
+ warehouseOccluder : Occluder, SecretFixture
    objOccluded = [ warehouseCrate, warehouseDeadBody, warehouseBasementToStairwayDoor,
        warehouseBasementNorthWall ]
    occludeObj(obj, sense, pov) {
        
        if( pov.isIn( warehouseChair ) && (pov.posture == sitting) ) {
            if( objOccluded.indexOf(obj) )
                return true;
        
            if( obj.isIn( warehouseCrate ) )
                return true;
        }
        
        return nil;
    }
;


//------------------------
// The warehouse stairway

warehouseStairwayRoom : Room
    roomName = 'basement stairway'
    desc = "A cement stairway leads up to the light. You stand on a small
        level at the bottom. "
    
    up asExit(north)
    north = warehouseStairway
    south = warehouseStairwayToBasementDoor
;

+ warehouseStairwayToBasementDoor : Door ->warehouseBasementToStairwayDoor
    vocabWords = 'dull wooden south door/exit/doorway'
    name = 'wooden door'
    desc = "A dull, wooden door leading back to the basement. "
;

+ warehouseStairway : StairwayUp, Surface ->alleywayDoorToWarehouse
    vocabWords = 'cement concrete stairs/stair/stairway/step/steps/up'
    name = 'stairs'
    
    desc = "Plain cement stairs climb to the brightness outside. "
    
;