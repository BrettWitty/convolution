#charset "us-ascii"
#include "adv3.h"
#include "en_us.h"

// This is the grand-master list of miscellaneous topics, referenced globally.

GlobalTopic : Topic
    pcKnown = true
;

// Random threads
codySkiing : Topic 'skiing';
mafiaTopic : Topic 'mafia/mafioso/goon/goons/hitmen/hitman/Vizioso/Canino/gangsters';
moneyTopic : GlobalTopic 'money/cash/moolah/dosh/pounds/dollars/dollar/cents/sterling/bread/loot/bucks';
sexTopic : GlobalTopic 'sex/lust/intercourse';
creepyPhoneCallTopic : Topic 'creepy phone call';

// Meta-world and philosophical topics
convolutionTopic : GlobalTopic 'convolution';
godTopic : GlobalTopic 'God/yahweh/jesus/lord/deity';
deathTopic : GlobalTopic 'death/dying/dead';
creatorTopic : GlobalTopic 'the creator';
gameTopic : GlobalTopic 'this game';
purposeTopic : GlobalTopic 'purpose';
fateTopic : GlobalTopic 'fate/destiny/predestination';
meaningOfLifeTopic : GlobalTopic 'life meaning/life';
realityTopic : GlobalTopic 'reality/universe/world';

// Convolution tower topics
neighboursTopic : GlobalTopic 'neighbours/neighbors/neighbour/neighbor';
residentsTopic : GlobalTopic 'residents/tenants';
buildingTopic : GlobalTopic 'apartment building/block/apartments';
apartmentTopic : GlobalTopic 'apartment/house/unit/flat/place';
managerTopic : GlobalTopic 'manager/landlord/landlady';
// Vern is already a topic
room777Topic : Topic 'room apartment place 777';
keycardsTopic : Topic '(key) security swipe keycard/card';
elevatorTopic : Topic 'elevator';

// Various reveal keys:
// codyCharlieWar : The animosity between Cody and Charlie
// hackedDoor : The psycho ex-girlfriend's souvenir.
