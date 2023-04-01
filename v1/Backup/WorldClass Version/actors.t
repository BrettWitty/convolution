
// Vern the Janitor

Vern: Male, Actor
  noun = 'vern' 'janitor' 'vern the janitor'
  location = LunchRoom
  sdesc = "Vern the Janitor"
  ldesc = "Vern is your typical hard-working, underpaid, underappreciated janitor. He has a big bushy moustache that gives him
           an air of seriousness, or more likely, it muffles his occasional muttered curses. He wears a wearied set of (once) blue overalls
           discoloured with hundreds of exotic stains - the product of years of custodial service. "
  actorDesc = "Vern the Janitor mills about, fixing this or that. "
  verIoGiveTo( actor ) = {}
  ioGiveTo ( actor, dobj ) = 
  {
    "Vern mumbles, \"No thanks.\" ";
  }
  isdetermined = true
;

VernsOveralls: Part
  partof = Vern
  noun = 'overalls' 'trousers' 'smock'
  adjective = 'worn' 'wearied' 'blue' 'stained' 'discoloured' 'discolored'
  sdesc = "Vern's overalls"
  ldesc = "Vern's denim overalls look tough, well-worn and have seen a lot of janitorial action. You guess that some of the muck he
           deals with just won't wash out all that easily. "
  isplural = true
  isdetermined = true
;

VernsOverallsStains: Part
  partof = VernsOveralls
  noun = 'stains' 'muck'
  adjective = 'overall' 'overalls' 'exotic'
  sdesc = "the stains on Vern's overalls"
  ldesc = { "The number and variety of stains on Vern's overalls astounds you. There are the various brown-black splotches on the chest,
          a couple of chemical discolorations here and there, and the legs are a darker, sedimentary colour from the knees down
         (as though he had done some muck-wading on occasions). You even notice the occasional mustard stain down the front.\b ";

         switch(rnd(3))
	 {
	   case 1:
	     "Vern gives you a querulous look in response to your staring. ";
	     break;
	   case 2:
	     "Vern looks down at his overalls, wondering if you'd spotted something embarrassing that he hadn't. ";
	     break;
	   case 3:
	     "Vern shifts slightly and puts his hands in front of him, trying to break your intrusive staring. ";
	     break;
	 }
  }
  isplural = true
  isdetermined = true
;