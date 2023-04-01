#include <adv3.h>
#include <en_us.h>
#include <charset.h>

+ property location;

Room template 'roomName' 'destName'? 'name'? "desc"?; 

Thing template 'vocabWords' 'name' @location? "desc"?;

Passage template ->masterObject inherited;