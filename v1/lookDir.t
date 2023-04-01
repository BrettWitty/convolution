#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

ModuleID
{
    name = 'LookDir'
    byline = 'by Eric Eve'
    htmlByline = 'by <a href="mailto:eric.eve@hmc.ox.ac.uk">Eric Eve</a>'
    version = '3.0'    
    listingOrder = 72
}



/*************************************************************************** 
 *    LookDir  (TADS 3 Libary Extension)
 *    by Eric Eve
 *    Version 3.0 (April 2005)
 *
 *  To use this extension, simply include it in the list of your project\'s source
 *  files after the standard adv3 libary files. This extension
 *  allows commands such as LOOK NORTH and LOOK DOWN (i.e. Look + direction)
 *  To use, add dirLook properties (e.g. northLook, downLook) to room definitions
 *  as required: e.g.:
 *
 *  entryWay : Room 'Entrance Hall'
 *    "This imposing entrance hall continues to the north. The front
 *     door is directly to the south and a series of fusty old portraits
 *     hang on the west wall. "
 *
 *   northLook = "The hall continues some way in that direction. "
 *   southLook = "That way lies the front door. "
 *   westLook = "There\'s not much there except some fusty old portraits. "
 *   north = hall
 *   south = frontDoor
 *  ;
 *
 *  N.B. There is no need define these properties on locations where you don\'t want them to be
 *  used. There is only ever a need to define one of these properties as nil if you want to
 *  override an xxxLook property defined on a superclass; alternatively you may want to define
 *  an xxxLook property as a method that returns nil under certain conditions.
 */

 /*
  *  Version 3 (April 2005) adds a check for there being enough light to see by,
  *  and various forms of handling for LOOK DIR in a dark location.
  *
  *  It also adds code to map looking in a direction to examining the appropropriate room
  *  part (e.g. LOOK EAST becomes EXAMINE EAST WALL if no eastLook property is defined)
  *
  *  It also adds a defaultLook(dir) method to provide a default message for looking in directions
  *  not dealt with by xxxLook properties or room parts. This may be overridden as desired on
  *  individual rooms. 
  *
  *  It also adds appropriate handling for NestedRooms.
  *
  *  It adds describeRemoteRoom() and listRemoteContents() methods to allow an xxxLook
  *  property to describe a remote location visible through a SenseConnector.
  *
  *  Finally, it incorporates support for Michel Nizette\'s pasttense extension.
  */


property pastTenseExtensionPresent;

enum showRoomPart;

DefineIAction(LookDir)
  execAction()
  {
     local dirn = dirMatch.dir;
     local prop = dirLook.dirTab[dirn];
     local loc = gActor.roomLocation.lookLocation(dirn);
     local hasDisplayed = nil;
     local rPart;
     
     
     /* 
      * If the player simply types LOOK IN treat it as an incomplete
      * form of the library\'s LookInAction, and redirect the command
      * accordingly.
      */
      
     if(dirn == inDirection)
        askForDobj(LookIn);
        
        
     /* 
      *  If it\'s too dark to see, diplay a failure message to that effect.  But allow
      *  this to be overridden for special cases (e.g. the player char may be able to see
      *  a distant light in the dark).      
      *
      *  There are three ways you can go about this. The easiest, and generally
      *  preferred, way is simply to define an xxxxLookDark property on the location
      *  where you want a custom message displayed in the dark. For example, if
      *  you have a dark cave with an entrance to the west, you may want to display
      *  a message about light coming in from tbe west when an actor LOOKS WEST in the cave.
      *  In which case define a westLookDark property on the cave thus:
      *
      *     westLookDark = "{You/he} see{s} a small amount of light seeping in through 
      *                       the cave entrance. "
      *       
      *  The second is to override
      *  tooDarkForDirLook(dirn) on the appropriate location so that it returns
      *  nil. The location will then be treated as if it were lit for the purposes
      *  of processing the LOOK DIR command.
      *
      *  The third is to override lookDirInDark(dirn) on the
      *  appropriate location to display whatever custom messages(s) you want
      *  displayed when an actor looks to dirn in the dark.
      *        
      */
      
      if(!gActor.isLocationLit && loc.tooDarkForDirLook(dirn))
      {              
         return;
      }
      
     /* 
      * Otherwise, if the current location defines the appropriate
      * dirLook property (or method), let that handle the action.  
      */  
     if(prop != nil && loc.propDefined(prop) && loc.propType(prop) != TypeNil)
     {
       /* 
        *  Even if prop is defined and is non-nil, it may fail to display anything,
        *  so we test to ensure it does. Failure to display may occur because prop
        *  is a method or expression that evaluates to nil, or because it evaluates
        *  to a single-quoted string.
        */ 
        
       local val;
       hasDisplayed = mainOutputStream.watchForOutput( {: val = loc.(prop) } );       
       
       /* 
        *  If we displayed something, we\'re done, unless we returned showRoomPart 
        *  The test for returning showRoomPart is a special case to allow us to display
        *  a custom message followed by a description of the appropriate room part.
        *  e.g.:
        *
        *  northLook { "You look north across the room. "; return showRoomPart; }
        *
        *  This would display "You look north across the room. " followed by the description
        *  of the north wall, if there is one (or else display the defaultLook message,
        *  which probably wouldn\'t be what you want). 
        */ 
       
       if(hasDisplayed && val != showRoomPart)
         return;
       
       /* 
        *  If we didn\'t display something, perhaps loc.(prop) evaluated to a
        *  single-quoted string; in which case display the string and return.
        */
       if(dataType(val) == TypeSString)
       {
          say(val);
          return;
       }       
     }
       
     /* 
      * If no outLook was defined, treat LOOK OUT as an incomplete LOOK THROUGH
      * command. 
      */  
     if(dirn == outDirection)
       askForDobj(LookThrough);
       
     /*
      * Otherwise, if the player specified a shipboard direction (e.g. LOOK PORT) and
      * we\'re not in a shipboard room, display the standard 'not aboard ship' message.
      *
      * Note that putting this check *after* the previous one allows an author to
      * define a portLook, starboardLook, aftLook or foreLook even on a non-shipboard
      * room; whether this is useful is left to authors to decide, not dictated by
      * this extension.
      * 
      */  
     else if(dirn.ofKind(ShipboardDirection) && !loc.isShipboard)
         libMessages.notOnboardShip();
         
     
     /* 
      * Otherwise see if we can find a room part matching the compass direction name, and, if
      * so, examine it, provided this location allows it.
      */
     
     else if(loc.lookDirToRoomPart(dirn) && (rPart = findRoomPart(dirn)) != nil)
     {
       /* If we found an appropriate room part, examine it */     
       
          replaceAction(Examine, rPart);         
                     
     }
     
        /*
         *  Otherwise print the default message "You see nothing remarkable by looking <<dir>>. ",         
         *  unless we previously displayed something else.
         */
     else if(!hasDisplayed)
        loc.defaultLook(dirn);              
  }
  
  /*
   *  This is made a separate method in case it needs to be customised for
   *  languages other than English.
   */
  findRoomPart(dirn)
  {
     local loc = gActor.getOutermostRoom; 
        /* If the command was LOOK DOWN try looking at the current room's floor object */
     if(dirn == downDirection)
        return loc.roomFloor;
           
        /* If the command was LOOK UP try to find the sky or ceiling object */   
     if(dirn == upDirection)
         return loc.roomParts.valWhich(
          { x: nilToList(x.noun).indexOf(dirLook.sky) != nil
           || nilToList(x.noun).indexOf(dirLook.ceiling) != nil } );
            
        /* Otherwise try to find a wall (or other room part) with an adjective that matches our direction name */    
     
     return loc.roomParts.valWhich(
         {x: nilToList(x.adjective).indexOf(dirn.name) != nil });     
     
  }
    
;


   /* 
    *  Set up dirLook properties for all directions except 'in', since the library
    *  already defines a 'look in x' verb.
    */

dirLook : PreinitObject
  
  dirTab = nil
  dirDarkTab = nil
  
  execute()
  {
    /* Make the LookUpTable values a bit bigger that strictly necessary in case
     * an author wants to add custom directions (even though it would work well
     * enough even if we didn\'t do this).
     *
     * e.g.
     *
     *  modify dirLook
     *    execute()
     *    {
     *      inherited;
     *       dirTab[fooDirection} = &fooLook;
     *    }
     *  ;
     */
     
    dirTab = new LookupTable(20, 20);
    
    dirTab[northDirection] = &northLook;
    dirTab[eastDirection] = &eastLook;
    dirTab[southDirection] = &southLook;
    dirTab[westDirection] = &westLook;
    dirTab[northeastDirection] = &northeastLook;
    dirTab[southeastDirection] = &southeastLook;
    dirTab[southwestDirection] = &southwestLook;
    dirTab[northwestDirection] = &northwestLook;
    dirTab[upDirection] = &upLook;
    dirTab[downDirection] = &downLook;
    dirTab[portDirection] = &portLook;
    dirTab[starboardDirection] = &starboardLook;
    dirTab[foreDirection] = &foreLook;
    dirTab[aftDirection] = &aftLook;
    dirTab[outLook] = &outLook;
    
    /* Equivalent lookupTable for looking in the dark */
    
    dirDarkTab = new LookupTable(20, 20);
    
    dirDarkTab[northDirection] = &northLookDark;
    dirDarkTab[eastDirection] = &eastLookDark;
    dirDarkTab[southDirection] = &southLookDark;
    dirDarkTab[westDirection] = &westLookDark;
    dirDarkTab[northeastDirection] = &northeastLookDark;
    dirDarkTab[southeastDirection] = &southeastLookDark;
    dirDarkTab[southwestDirection] = &southwestLookDark;
    dirDarkTab[northwestDirection] = &northwestLookDark;
    dirDarkTab[upDirection] = &upLookDark;
    dirDarkTab[downDirection] = &downLookDark;
    dirDarkTab[portDirection] = &portLookDark;
    dirDarkTab[starboardDirection] = &starboardLookDark;
    dirDarkTab[foreDirection] = &foreLookDark;
    dirDarkTab[aftDirection] = &aftLookDark;
    dirDarkTab[outLook] = &outLookDark;
        
  }
  /*
   *  We use this rather roundabout way of specifying the words for
   *  'sky' and 'ceiling' to make it a bit easier for a non-English
   *  language version specify what it needs.
   */
  
  sky = static defaultSky.name
  ceiling = static defaultCeiling.name
    
;




modify BasicLocation
  
  /*
   *  By default allow mapping LOOK DIR to examining the corresponding room part
   *  (e.g. LOOK NORTH = EXAMINE NORTH WALL if we have a north wall and if northLook isn\'t
   *  already defined). If I\'m a nested room, then by default pick up the value of this
   *  property from my enclosing location.
   */
  lookDirToRoomPart(dirn)  { return location == nil ? true : location.lookDirToRoomPart(dirn); }
  
  /* 
   *  By default, delegate a LookDir command to my immediate container
   *  if I have one, unless I define the appropriate xxxLook property,
   *  in which case use me.
   *
   *
   *
   *  Note that defining an xxxLook property on a NestedRoom to anything other than nil,
   *  a double-quoted or single-quoted string, or a routine that prints a string or returns
   *  a single-quoted string will cause the NestedRoom\'s defaultLook method to be used.
   *  If you want this effect you can, for example, define northLook = true on a NestedRoom
   *  to force LOOK NORTH to use the NestedRoom\'s defaultLook rather than the enclosing room\'s
   *  northLook, north wall or defaultLook (as the case may be).
   */
  
  lookLocation(dirn) 
  {
    local prop = dirLook.dirTab[dirn];
    
    /* 
     *  If I have no location, or if I define the appropriate xxxLook property
     *  and it\'s not simply nil, or if my enclosing location can\'t be seen by
     *  the actor, or if the actor is looking in a direction occluded by me,
     *  then let me handle the lookDir command. Otherwise, pass it up the
     *  chain to my enclosing location.       
     */
     
    /*
     *  We want to test if the actor could see out if there was enough light,
     *  regardless of whether there is or not, so that we don\'t lose any of
     *  the enclosing location\'s xxxLook properties which are meant to be visible
     *  in the dark. So we turn the lights on for the purposes of checking the
     *  lookAroundCeiling, and then restore the light level to what it was before.
     *
     *  In any case, if we\'re in the dark on a chair, bed or platform, it makes
     *  sense for our enclosing location to deal with the 'too dark' situation,
     *  so by default we won\'t make absence of light a reason for not being able
     *  to see out.
     */ 
        
     
    try
    {
     lookDirTestProbe.baseMoveInto(self);
     
     return  isLookAroundCeiling(gActor, gActor)
           || (propDefined(prop)  && propType(prop) != TypeNil)            
           || lookDirOccluded(dirn)
           
           ? self : location.lookLocation(dirn);    
    }
    finally
    {
      lookDirTestProbe.baseMoveInto(nil);
    }
  }
  
  /*
   *   The message to display if nothing else matches.
   *   This can be overridden on individual rooms if required;
   *   it can also be made to vary by direction.
   */  
  
  defaultLook(dirn)   {  defaultReport(&nothingRemarkable, dirn) ;  }
  
  /*
    *  By default we check whether the direction the actor is trying to look
    *  in is one that is in the list of directions occluded by the NestedRoom.
    *  In some cases it may be easier to override this method than the
    *  occludedDirs list; e.g. if the only direction an actor can see out
    *  of the NestedRoom is north, then override this method thus:
    *
    *  lookDirOccluded(dirn) { return dirn != northDirection; }
    *
    *  This check is most likely to be relevant for Booths, but may be applied
    *  to any NestedRoom. It has no effect on a top-level room, since if this
    *  BasicLocation has no enclosing room, this test will never be applied.
    */
   lookDirOccluded(dirn)
   {
      return occludedDirs.indexOf(dirn) != nil;
   }
   
   /*
    *  A list of directions occluded by the NestedRoom (i.e. directions in which the actor
    *  would not be able to see out of the NestedRoom because the NestedRoom wall is in the way).
    *  This must be defined by game authors on individual NestedRooms, since this library
    *  extension has no way of knowing the configuration of individual NestedRooms.
    *
    *  e.g. occludedDirs = [northDirection, northeastDirection, eastDirection]
    *
    *  This is most likely to be relevant for Booths. Note that this list has no effect on
    *  Rooms, since these have no enclosing location which might be viewed in any case.
    */
   
   occludedDirs = []   
   
   /* 
    *  This method is called if a LOOK DIR command is issued in a dark location.
    *  It should not normally be necessary to override it; override lookDirInDark()
    *  instead to change the behaviour.
    *
    *  By default, this method displays the standard tooDarkTooSeeThatWayMsg,
    *  but this is only displayed if lookDirInDark() does not display anything.
    *
    *  To allow LOOK DIR to work in the dark as if it were light, override this
    *  method to return nil.
    */
   
   tooDarkForDirLook(dirn)
   {
      if(!mainOutputStream.watchForOutput( {: lookDirInDark(dirn)  }) )
         reportFailure(&tooDarkToSeeThatWayMsg, dirn);
        
      return true;  
   }
   
   /*
    *  Override this method to customize the effect of trying to LOOK DIR in the dark.
    *  You could display an alternative "too dark" message, or you could display a message
    *  appropriate to the situation when something can be seen in a particular direction.
    *
    *  For example, an actor in a dark location might still be able to see a distant light
    *  elsewhere, or light coming down a passage. 
    *
    *  By default this method checks for an xxxLookDark property, and, if it finds
    *  it, displays its message, so you can just define any xxxLookDark properties you need.
    */
    
    
   lookDirInDark(dirn)
   {
      local prop = dirLook.dirDarkTab[dirn];      
      if(propDefined(prop) && propType(prop) != TypeNil)
      {
        local val = self.(prop);
        if(dataType(val) == TypeSString)
          say(val);
      }
   }
  
  /*
   *  The describeRemoteRoom method is provided to enable looking towards another location
   *  joined to the first by a SenseConnector (typically a DistanceConnector). This method
   *  assumes that the remote location has a suitable roomRemoteDesc method defined to
   *  described how it looks from where the actor is standing.
   *   
   *  For example if you had a large hall divided into two rooms, northHall and southHall,
   *  joined by a DistanceConnector, and northHall provided a suitable roomRemoteDesc
   *  method, you could define:
   *
   *  southHall : Room 'South End of Hall' 'the south end of the hall'
   *     "This large hall continues to the north. "
   *     north = northHall
   *     northLook { describeRemoteRoom(northHall); }
   *   ;
   *  
   *  The advantage of this is that the contents of northHall will also be appropriately
   *  listed when the player issues the command LOOK NORTH.
   */
  
  
  describeRemoteRoom(loc)  {  describeRemoteRoomPov(loc, gActor, gActor);  }
  
  describeRemoteRoomPov(loc, actor, pov)
  {
    loc.roomRemoteDesc(actor);
    listRemoteContentsPov(loc, actor, pov);
  }
  
  /*
   *  You can use the listRemoteContents method as an alternative to describeRemoteRoom
   *  when you want your xxxLook property to give its own description of the other location
   *  but you still want to list the contents of the other location; e.g.
   *  southHall : Room 'South End of Hall' 'the south end of the hall'
   *     "This large hall continues to the north. "
   *     north = northHall
   *     northLook 
   *      { 
   *         "You look north towards the far end of the hall.<.p>";
   *         listRemoteContents(northHall); 
   *      }
   *   ;
   *  
   *  listRemoteContents(otherRoom) lists the contents of otherRoom as seen from the perspective
   *  of the actor doing the looking; thus, for example, if the looking is being done through a
   *  DistanceConnector, the objects in otherRoom will be listed using any distant or remote
   *  properties that have been defined, such as distantDesc or remoteInitSpecialDesc(pov), and
   *  they will be listed as being present in otherRoom rather than the actor\'s immediate location.
   */
  
  
  listRemoteContents(otherLocation) { listRemoteContentsPov(otherLocation, gActor, gActor); }
  
  /*
   *  In order to achieve the desired effect of listing the contents of the other room
   *  as they appear from the current actor\'s location, we have to lookAround the actor\'s
   *  current location, but exclude everything from the list of objects that is not in
   *  the other location.
   */
  
  listRemoteContentsPov(otherLocation, actor, pov )
  {
    /*
     *  We can\'t pass otherLocation to adjustLookAroundTable as a parameter, since there\'s
     *  no such parameter defined on this method. Instead we pass it through a property.
     */
     
    listLocation_ = otherLocation;
    try
    {
      lookAroundPov(actor, pov, LookListSpecials | LookListPortables);
    }
    finally
    {
      /* Restore listLocation_ to nil so that lookAround will function normally in other contexts */  
      listLocation_ = nil;
    }
  }
  
  /*
   *  If listLocation_ is not nil, then remove everything from the table of objects
   *  to be listed apart from objects in listLocation_. This will cause lookAround() to
   *  list only the objects in that location. 
   */
  
  adjustLookAroundTable(tab, pov, actor)
  {
    inherited(tab, pov, actor);
    if(listLocation_ !=  nil)
    {
      local lst = tab.keysToList();
      foreach(local cur in lst)
      {
        if(!cur.isIn(listLocation_))
          tab.removeElement(cur);
      }
    }
  }

  /* 
   *   Internal property for passing a value to adjustLookAroundTable. This should NOT
   *   be overridden by game authors without very good reason.
   */
   
  listLocation_ = nil 
   
;

/*
 *  A test probe to see if we could see into a location were it lit
 */
 
lookDirTestProbe : Thing
  brightness = 3
;

 
/* 
 *  A default room part may give its description in response to a LookDir command; in this
 *  case it needs to name itself rather than refer to itself simply as 'it', since
 *  "You see nothing unusual about it" is a poor response to (e.g.) "LOOK NORTH" 
 */ 
 
modify RoomPart
  desc() {  defaultReport(&nothingUnusualAboutMsg, self);  }
;


/*==========================================================================================
 *  Language-Specific elements
 */


 /* 
  *  A couple of convenience macros for building messages that either use or don\'t
  *  use the pasttense.t library extension according to whether or not it\'s present
  *
  *  We define them here rather than in a header file, firstly because we don\'t need 
  *  them anywhere else, and secondly to avoid any potential clash with any other
  *  extension that may want to define its own macros for compatibility with pasttense.t.
  */
 
#define seesStr (languageGlobals.pastTenseExtensionPresent ? '{sees}' : 'see{s}')
#define itsStr  (languageGlobals.pastTenseExtensionPresent ? 'It{\'s| was}' : 'It\'s')

/* Allow a variety of phrasings from a laconic L N through LOOK NORTH to LOOK TO THE NORTH. */

VerbRule(LookDir)
  ('look' |'l'| 'peer'|'examine'|'x') ('to' ('the' |) |) singleDir
  : LookDirAction
  verbPhrase = 'look/looking {where} '
;
 


 /*
  * English-language specific modifications to playerActionMessages
  */


modify playerActionMessages
  nothingRemarkable(dirn)
  {     
     return '{You/he} ' + seesStr + ' nothing remarkable '+ dirName(dirn) + '. ';
  }
  tooDarkToSeeThatWayMsg(dirn)
  {
     return itsStr + ' too dark to see anything ' + dirName(dirn) + '. ';
  }
  
  nothingUnusualAboutMsg(obj)
  {
     gMessageParams(obj);
     return '{You/he} ' + seesStr + ' nothing unusual about {the obj/him}. ';
  }
  
  dirName(dirn)
  {
    switch(dirn)
     {
       case upDirection:
         return 'above {it actor/him}';
       case downDirection:
         return 'beneath {it actor/him}'; 
       case portDirection:
       case starboardDirection:
         return 'to ' + dirn.name;
       case aftDirection:
       case foreDirection:
         return dirn.name;       
       default:
         return 'to the ' + dirn.name;
     }
  }  
;
