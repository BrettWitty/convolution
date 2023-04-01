#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// Abandoned apartment
mailbox101 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/101'
    disambigName = 'mailbox 101'
    resident = ''
    initiallyOpen = nil
    initiallyLocked = true
;

// Rose and Charlie's mailbox
// Because of some specifics, we need a custom mailbox
mailbox102 : ComplexContainer, Fixture
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/102'
    name = 'somebody\'s mailbox'
    desc = "This mailbox looks like all the others: compact, black,
	    and metallic. The label on the front indicates that this
	    is <<resident>>\'s mailbox. <<changeName>>"
    disambigName = 'mailbox 102'
    resident = 'C & R Erant'
    isQualifiedName = true
    location = entrance
    hideFromAll(action) { return true; }
    subContainer : ComplexComponent, KeyedContainer {
	bulkCapacity = 10
	weightCapacity = 100
	keyList = [oldFolksMailboxKey]
	initiallyOpen = true
	initiallyLocked = nil
    }
    changeName() {
	name = resident + '\'s mailbox';
	cmdDict.removeWord(self, 'somebody', &adjective);
	initializeVocabWith(resident);
    }
;

+mailbox102Door : ContainerDoor
    vocabWords = '(mailbox) 102 door'
    name = 'door on mailbox 102'
    hideFromAll(action) { return true; }
    dobjFor(Examine) { verify() { nonObvious; } }
;

// Dude's apartment
mailbox103 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/103'
    disambigName = 'mailbox 103'
    resident = 'C. Preston (Sex Machine) '
    initiallyOpen = nil
    initiallyLocked = true
;

// Locked apartment
mailbox104 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/104'
    disambigName = 'mailbox 104'
    resident = ''
;

// Jack & Jill
mailbox105 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/105'
    disambigName = 'mailbox 104'
    resident = 'J & J Hill'
;

// Programmer
mailbox201 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/201'
    disambigName = 'mailbox 201'
;

// Ravers
mailbox202 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/202'
    disambigName = 'mailbox 202'
;

// Recluse
// Andrei Rabin (as a reference to the Chekov story Ward No 6)
mailbox203 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/203'
    disambigName = 'mailbox 203'
    resident = 'A.\ Rabin'
;

// Mafia
mailbox204 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/204'
    disambigName = 'mailbox 204'
;

// Prisoner
mailbox205 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/205'
    disambigName = 'mailbox 205'
;

mailbox301 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/301'
    disambigName = 'mailbox 301'
;

mailbox302 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/302'
    disambigName = 'mailbox 302'
;

mailbox303 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/303'
    disambigName = 'mailbox 303'
;

mailbox304 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/304'
    disambigName = 'mailbox 304'
;

mailbox400 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/400'
    disambigName = 'mailbox 400'
;

mailbox500 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/500'
    disambigName = 'mailbox 500'
;

mailbox600 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/600'
    disambigName = 'mailbox 600'
;

mailbox777 : Mailbox
    vocabWords = '(mail) mailbox somebody mailbox/box/letterbox/777'
    disambigName = 'mailbox 777'
;

mailboxOffice : Mailbox
    vocabWords = '(mail) mailbox office mailbox/box/letterbox/office'
    name = 'the office\'s mailbox'
    resident = 'the Office'
    baseDesc = "This mailbox is different from the others. It is about twice
		as large as any of the others and has professional-looking
		plastic sign on it reading <q>Office</q>. You guess it is for the
		manager and caretakers. "
;
