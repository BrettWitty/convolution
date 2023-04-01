#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// A mix-in to handle Yin redirected conversation.
// Basically the topic will have to explain Yang stepping in, but it
// will set the current conversationalist as him.
// This is great because you can still use scripts (so show Yang's
// increasing impatience)

yinRedirectToYang : object
    redirect() {
	gPlayerChar.lastInterlocutor = yang;
    }
    handleTopic(fromActor, topic) {
	inherited(fromActor, topic);
	redirect();
    }
;

yinYangTestRoom : Room
    name = 'Yin and Yang Test Room'
    desc = "This is a test room for Yin and Yang. "
;

yin : Person
    vocabWords = 'yin/girl/woman/chick/female'
    name = 'Yin'
    desc = "A tomboyish girl with short hair. "
    isHer = true
    isProperName = true
    location = yinYangTestRoom
;

+yinRedirectToYang, ShowTopic @testCard
    "She looks it over and returns it without a word. "
;

+yinRedirectToYang, AskTopic @me
    "She shrugs her shoulders. Yang steps in, <q>That is not for us to discuss.</q> "
;

yang : Person
    vocabWords = 'yang/guy/man/dude/male'
    name = 'Yang'
    desc = "A guy with long hair. "
    isHim = true
    isProperName = true
    specialDescOrder = (yin.specialDescOrder + 1) // Yin always comes before Yang
    location = yinYangTestRoom
;

+ShowTopic @testCard
    "He looks at it and nods sagely. "
;

+AskTopic @me
    "He says, <q>That is not for us to discuss.</q> "
;
