#include <convolution.h>

// Hang up. Used almost exclusively for telephones.
DefineTAction(HangUp);

VerbRule(HangUp)
  ('hang' 'up' | 'disconnect' | 'terminate' | 'hangup' ) singleDobj
  : HangUpAction
  verbPhrase = 'hang/hanging up (what)'
  askDobjResponseProd = singleNoun
;

// Answer phone
DefineTAction(Answer);

VerbRule(Answer)
    'answer' singleDobj
    : AnswerAction
    verbPhrase = 'answer/answering (what)'
    askDobjResponseProd = singleNoun
;

// Dial on a phone.
DefineTopicTAction(DialOn, DirectObject);

VerbRule(DialOn)
    ( 'dial' | 'call' | 'ring') ( 'up' |  ) singleTopic ('on' | 'with') singleDobj
    : DialOnAction
    verbPhrase = 'dial/dialling (what) (on what)'
    askDobjResponseProd = singleNoun
;

VerbRule(DialOnWhat)
    ( 'dial' | 'call' | 'ring' ) ( 'up' |  ) singleTopic
    : DialOnAction
    verbPhrase = 'dial/dialling (what) (on what)'
    construct()
    {
        dobjMatch = new EmptyNounPhraseProd();
        dobjMatch.responseProd = onSingleNoun;
    }
;
