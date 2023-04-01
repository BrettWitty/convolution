#include "convolution.h"

class SafeButton : Button, Component, PreinitObject
    
    vocabWords = 'button*buttons'
    name = ''
    
    location = officeSafeDoor
    
    desc = "This button of the safe is marked '<<intToDecimal(digit,0)>>'. "
    
    digit = 0
    
    execute() {
        
        name = spellInt(digit) + ' button';
        
        cmdDict.addWord( self, spellInt(digit), &noun );
        cmdDict.addWord( self, intToDecimal(digit, 0), &noun );
        
    }
    
    dobjFor(Push) {
        action() {
            
            officeSafe.doDigit( digit );
            mainReport('The button makes a soft click when you press it. ');
            
        }
        
    }
;


modify Room 
    roomDesc() { inherited; extras; finalDesc;} 
    extras() { 
        if(contents.length==0) return; 
        local cur; 
        local vec = new Vector(10); 
        foreach(cur in contents) 
            if(cur.propType(&inRoomDesc) is in (TypeDString, TypeCode)) 
                vec.append(cur); 
        if(vec.length==0) return;   
   
        vec = vec.sort(nil, {a, b: a.inRoomDescOrder - b.inRoomDescOrder }); 
        
        foreach(cur in vec)    
            if(gPlayerChar.canSee(cur)) 
                cur.inRoomDesc; 
    } 
    finalDesc = nil 
; 

modify Thing 
    /*   Text to add to the description of the room I'm immediately in. If 
     *   inRoomDesc is a double-quoted string or a method that displays a 
     *   string, this is added to the description of the enclosing room. 
     */ 
    inRoomDesc = nil 
   
    /* If several objects in the same room have an inRoomDesc, the inRoomDesc 
     * property can be used to define the order in which they are described. 
     * To have objects included in the room description in the order in which 
     * they are defined in the source file, define inRoomDescOrder = (sourceTextOrder) 
     */ 
    inRoomDescOrder = 100   
;