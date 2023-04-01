#charset "us-ascii"
#include <adv3.h>
/*

Tads-3 Knowledge
Steve Breslin, 2004
(email: versim@hotmail.com)

License:

You can use this material however you want, but if you decide to
publicize anything that uses, #include's or otherwise borrows from
this material, please make your improvements publicly available,
and advertise them to the IF community.

====

The purpose of this module is to make knowledge tracking more intuitive,
and adds extra support for NPC knowledge. If you're doing anything with
knowledge, you should probably use this extension.

The library makes the questionable decision to use the *objects* to
track knowledge and "sight-knowledge," rather than using the Actor
objects themselves to keep track of their own knowledge. (This is an odd
artifact of the now-obsolete notion that NPC's have no knowledge.)

Besides this being rather counterintuitive (my chair doesn't know that I
know it; I do), this also makes iterating over an actor's knowledge base
or otherwise working with an actor's total knowledge quite inefficient.

We correct all this, centering knowledge in lookup-tables associated
with the Actor.

This module is normalizes knowledge and "sight-knowledge" for NPC's and
the PC. An Actor should glean the same knowledge, given the same
unfolding environment, whether it is an NPC or the PC.

We automate NPC sight-knowledge by forcing a silent look around
after each turn. This simulates the player 'look', which updates
sight-knowledge for the PC.

This extension is entirely consistent with the standard Tads-3 library;
you can plug this in to an ongoing work, no problems.

====

To use this module, just include this file in your project
window in workbench, or otherwise include it in your build
directives.

*/

modify Actor

    /* knownObjs and seenObjs:
     *
     * knownObjs and seenObjs are lookup-tables which track knowledge
     * by adding known objects as keys in the tables.
     *
     * We allow object-defined knowledge for knowledge initialization,
     * that is, knowledge which the Actors have at the beginning of the
     * game. But we provide an alternate mechanism for initializing
     * Actor knowledge, so you can entirely dispense with
     * object-defined knowledge and with the Actor.seenProp and
     * Actor.knownProp properties.
     *
     * Note that isSeen and isKnown indicate the object "is seen/known
     * by ALL Actors who do not have specially defined seenProps and
     * knownProps." If you want to use the deprecated object-defined
     * knowledge initialization to give the PC special knowledge,
     * override its seenProp and knownProp, like you do for NPC Actors.
     * Or better yet, use the Knowledge module's new knowledge
     * initialization technique (detailed below), and dispense with
     * object-defined knowledge altogether.
     */
    knownObjs = nil  // these two will be initialized during
    seenObjs = nil   // Actor.initializeActor

    /* initiallySeen and initiallyKnown:
     *
     * for initializing Actor knowledge easily. Note that you can still
     * set the properties explicitly on the objects without causing
     * conflicts (that's what the main library does); or do things
     * half one way and half the other. This module is designed to let
     * you do things the library's way if you like, but you may find it
     * convenient to keep all the initially known stuff in the same
     * list, rather than spread throughout your game in object
     * properties.
     */
    initiallySeen = []
    initiallyKnown = []

    /* Initialize the two lookup tables with the deprecated
     * object-defined knowledge initialization, and with the new
     * initially seen/known lists, and then perform the first silent
     * lookaround, to record in the sight-knowledge base the visible
     * objects in our starting location.
     */
    initializeActor() {
        local obj; // to iterate through the game's vocab objects.

        /* We initialize our knowledge tables. */
        knownObjs = new LookupTable(); // to do: optimize this
        seenObjs = new LookupTable();  // to do: optimize this

        /* First, we cycle through all vocab objects and make sure
         * that if the object is defining our knowledge of it
         * (which is the deprecated library technique for tracking
         * knowledge), we record this knowledge in the appropriate
         * lookup table.
         */
        obj = firstObj(VocabObject);
        while (obj) {
            if (obj.(&seenProp))
                seenObjs[obj] = true;
            else if (obj.(&knownProp))
                knownObjs[obj] = true;
            obj = nextObj(obj, VocabObject);
        }

        /* Now add to our knowledge base what we're supposed to know
         * already at the beginning of the game.
         */
        foreach (local obj in initiallySeen)
            setHasSeen(obj);
        foreach (local obj in initiallyKnown)
            setKnowsAbout(obj);

        /* Last, look around our initial location, so we'll know by
         * sight-knowledge all the visible objects there.
         */
        location.silentLook(self, self);

        inherited();
    }

    /* We alter the library service methods to update knownObjs and
     * seenObjs appropriately, and to use these lookup tables to check
     * knowledge.
     *
     * If you want a list of all the objects Bob has seen, you can use:
     * bob.seenObjs.keysToList
     */
    setKnowsAbout(obj) {
        knownObjs[obj] = true;
    }
    setHasSeen(obj) {
        seenObjs[obj] = true;
    }
    hasSeen(obj) {
        return seenObjs[obj];
    }
    knowsAbout(obj) {
        return (knownObjs[obj] || hasSeen(obj));
    }

    /* Do a "silent look" to record sight-knowledge of any newly
     * visible objects, after each action execution in our environment.
     *
     * Depending on the needs of your game, you may wish to put a call
     * to location.silentLook() in travelTo instead. This would not be
     * the most complete means of recording knowledge, but it would be
     * faster or more efficient than updating all actors every turn.
     *
     * We're erring on the side of completeness here, but if there's
     * a situation where an object passes into and back out of an
     * actor's scope during a single action routine, you will have to
     * update the actor's knowledge specially. (This should only happen
     * with customized action routines.)
     */
    afterAction() {
        if (self != gPlayerChar)
            location.silentLook(self, self);
        inherited();
    }
;

/* Modify Thing to implement a "silent look" mechanism which we can
 * call to update Actors' sight-knowledge. (The problem is that
 * Actor's don't automatically look around when they move between
 * locations, and don't notice when things are moved into their
 * visible environment.)
 */
modify Thing
    silentLook(actor, pov) {
        if (location != nil && actor.canSee(location))
            location.silentLook(actor, pov);
        else {
            local infoTab = actor.visibleInfoTableFromPov(pov);
            local info = infoTab[pov];
            if (info != nil && info.ambient > 1)
                actor.setHasSeen(self);
            setContentsSeenBy(infoTab, actor);
        }
    }
;

KnowledgeModuleID: ModuleID
{
    name = 'TADS 3 Knowledge'
    byline = 'Copyright (c) 2004 by Steve Breslin\n'
    htmlByline = 'Copyright (c) 2002 by
                 <a href="mailto:versim@hotmail.com">Steve Breslin</a>\n'
    version = '1.1'
}

