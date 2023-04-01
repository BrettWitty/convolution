#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

//
// The dryer
//

// This has been moved from laundry.t for simplicity.

laundryDryer : GenericLaundryMachine
    vocabWords = '(laundry) dryer drying clothes dryer/machine/drier'
    name = 'dryer'
    location = laundry
    disambigName = 'drying machine'
    desc = "The solid, solitary, steel dryer sits next to the two
	    washing machines. Like its neighbours, the dryer is
	    coin-operated, the rectangular block holding the slot
	    jutting out the side. "
    hideFromAll(action) { return true; }

    subContainer : ComplexComponent, OpenableContainer {
	bulkCapacity = 75
	weightCapacity = 100
	okayOpenMsg = 'You pop the lid of the dryer open. '
	okayCloseMsg = 'The dryer lid clangs shut. '
	lookInDesc = "The insides of the dryer is just a tarnished steel mesh cage that holds the clothes. "
	openStatus() {
	    if(isOpen)
		return 'The lid stands open, resting on the wall behind the dryer';
	    else {
		if(machineDaemon == nil)
		    return 'The lid is currently closed';
		else
		    return 'The lid is currently closed and the suds inside climb halfway up the glass';
	    }
	}
	iobjFor(PutIn) {
	    verify() {
		if(gDobj == me)
		    illogical('You can\'t get in the dryer! ');
	    }
	}
    }

    subSurface : ComplexComponent, Surface {
	bulkCapacity = 30
	weightCapacity = 100
    }

    mySlot = laundryDryerSlot
    machineDaemonID = nil
    machineProcess : EventList {
	[&dryerSpinUp,&dryerUsualProcess,&dryerUsualProcess,&dryerUsualProcess,&dryerUsualProcess,&dryerSpinDown]
    

    dryerSpinUp() {
	"The dryer groans as it slowly gathers speed. The rumbling accelerates until it finds a steady rhythm. ";
    }

    dryerUsualProcess() {
	if((laundryDryer.subContainer).getBulkWithin() > 0)
	    say(dryerSpinFull.getNextValue());
	else
	    say(dryerSpinEmpty.getNextValue());
    }

    dryerSpinDown() {
	if(lexicalParent.machineDaemonID != nil)
	    lexicalParent.machineDaemonID.removeEvent;
	lexicalParent.machineDaemonID = nil;

	// Process the things to change state
	foreach(local cur in lexicalParent.contents)
	    if(cur.ofKind(Wettable))
		cur.makeWet(nil);
	"With a whine and a clatter, the dryer slowly spins down and falls silent. ";
    }

    dryerSpinFull : ShuffledList {
	valueList = ['You hear the dryer rumble and rattle away. ', 'The dryer clunks and thumps as it turns its contents over and over in endless circles. ', 'Suddenly, the dryer shudders and bangs against the wall. But just as soon as it starts, it dies away, resuming its mindless rumble. ']
	}
    dryerSpinEmpty : ShuffledList {
	valueList = ['The dryer mumbles hollowly to itself. ', 'You hear the dryer shake and clatter, its voice empty and purposeless. ', 'The dryer jitters about, empty. ']
	}
    }
    iobjFor(DryWith) {
        preCond = []
	verify() {}
	action() {
	    nestedAction(PutIn,gDobj,self);
	    nestedAction(TurnOn,self);
	}
    }
;

laundryDryerButton : Fixture, Button
    vocabWords = '(dryer) "on" \'on\' on switch/button/knob'
    name = 'dryer\'s \'on\' button'
    location = laundry
    owner = laundryDryer
    desc = "This is a simple <q>on</q> button. Once you\'ve put your
	    money in the machine, press this to start the dryer. "
    hideFromAll(action) { return true; }
    dobjFor(Push) remapTo(TurnOn,laundryDryer)
    dobjFor(TurnOn) remapTo(TurnOn,laundryDryer)
;

laundryDryerSlot : MachineSlot
    vocabWords = '(dryer) (machine) change pay coin slot/hole'
    name = 'the dryer\'s coin slot'
    desc = "The slot for the dryer indicates that you need to insert
	    a dollar and then push the <q>on</q> button. Sounds
	    simple. "
    location = laundry
    isQualifiedName = true
    owner = laundryDryer
    myMachine = laundryDryer
    hideFromAll(action) { return true; }
;



//
// The working washing machine
//
// Code is identical to the dryer.

laundryLeftMachine : GenericLaundryMachine
    vocabWords = '(laundry) left washing clothes washer/machine'
    name = 'washing machine'
    location = laundry
    disambigName = 'left washing machine'
    desc = "The bold statement from the management is that this
	    machine will suffice to wash your clothes, in purely
	    utilitarian terms. The battered cube is installed next
	    to a similar machine, but this one is in working order
	    (apparently). A coin slot has been welded onto the side
	    of the machine, indicating the machines aren\'t provided
	    <i>gratis</i>. "
    mySlot = laundryWashingMachineSlot
    hideFromAll(action) { return true; }

    subContainer : ComplexComponent, OpenableContainer {
	bulkCapacity = 75
	weightCapacity = 100
	okayOpenMsg = 'The porthole on the front of the washing machine opens with a <i>click</i>. '
	okayCloseMsg = 'You close the door and it clicks wearily into place. '
	lookInDesc = "The smooth metallic interior is pretty much featureless. "
	openStatus() {
	    if(isOpen)
		return 'The door hangs open';
	    else
		return 'The washing machine is currently closed';
	}
	iobjFor(PutIn) {
	    verify() {
		if(gDobj == me)
		    illogical('You can\'t get in the washing machine! ');
	    }
	}
    }
    subSurface : ComplexComponent, Surface {
	bulkCapacity = 30
	weightCapacity = 100
    }

    machineProcess : EventList {
	['Water washes over the machine\'s interior, and it slowly fills up with suds. ',
	 'The washing machine churns away with a slushy and mechanical harmony. ',
	 'With a hiss and a mechanical mumble, the washing machine slows down. ',
	 'The washing machine gurgles as it drains out its suds. Just as soon as it finishes, it begins refilling again. ',
	 'The washing machine continues sloshing its contents around. ',
	 &washerSpinDown]
    
    washerSpinDown() {
	if(lexicalParent.machineDaemonID != nil)
	    lexicalParent.machineDaemonID.removeEvent;
	lexicalParent.machineDaemonID = nil;

	// Process the things to change state
	foreach(local cur in lexicalParent.contents)
	    if(cur.ofKind(Wettable))
		cur.makeWet(true);
	"The washing machine stops with a sigh. The water quickly
	 drains out and the machine falls silent. ";
    }
    }

    dobjFor(Open) {
	check() {
	    if(machineDaemonID != nil) {
		"You can\'t open {the dobj/him} while it is running. ";
		exit;
	    }
	}
	action() {
	    inherited();
	}
    }
    dobjFor(LookIn) {
	verify() { logicalRank(140,'better than the other washing machine'); }
    }
;

laundryWashingMachineButton : Fixture, Button
    vocabWords = '(washing) (machine) round plastic "on" \'on\' on switch/button/knob'
    name = 'washing machine\'s \'on\' button'
    location = laundry
    owner = laundryLeftMachine
    desc = "Pressing the round plastic button starts the machine,
	    once a dollar has been inserted in the coin slot. "
    hideFromAll(action) { return true; }
    dobjFor(Push) remapTo(TurnOn,laundryLeftMachine)
    dobjFor(TurnOn) remapTo(TurnOn,laundryLeftMachine)
;

laundryWashingMachineSlot : MachineSlot
    vocabWords = '(washing) (machine) change pay coin slot/hole'
    name = 'the washing machine\'s coin slot'
    desc = "A simple engraving states, <q>$1</q> indicating a single
	    coin buys you washing power (to the extent that the
	    machine can provide). "
    hideFromAll(action) { return true; }
    location = laundry
    isQualifiedName = true
    owner = laundryLeftMachine
    myMachine = laundryLeftMachine
;
