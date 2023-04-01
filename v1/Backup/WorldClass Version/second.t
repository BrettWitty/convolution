// The Second Floor

StairwellSecond: Room
  sdesc = "Second Floor Stairwell"
  ldesc = "The first floor stairwell is much the same as the first two floors.
	   In fact, you're willing to bet they're all like that. Architects
	   and their interest in repetition... When will they learn? There is
	   a small sign on the wall and a doorway to the west opening up into
	   a hallway."
  grounddesc = "The ground is nicely smoothed concrete. Unfortunately there
		seems to be a few scuff marks on the landing which spoils the
		uniformity. "
  soundDesc = "The fluorescent lights hum quietly. Otherwise, nothing."
  goDown = StairwellGround
  goWest = FirstHallway1
;

StairwellSecondSign: Readable, Decoration
  location = StairwellSecond
  noun = 'sign' 'arrow'
  adjective = 'small' 'metal' 'shiny'
  sdesc = "sign"
  ldesc = "A shiny metal sign indicating that this is the first floor. You can
	   go up the stairs to the second floor and down to the ground floor.
	   Ingenious!"
  readdesc = "An arrow points up the stairwell with the label: \"Second\".
	      Another points down with the label: \"Ground\". A third and
	      final arrow points out to the hallway to the west indicating
	      \"First\"."
;

StairwellSecondFluro: Unimportant
  location = StairwellSecond
  noun = 'light' 'fluoro' 'lighting'
  adjective = 'fluoro' 'fluorescent' 'hum' 'humming' 'buzz' 'buzzing' 'stairwell'
  sdesc = "fluorescent light"
  ldesc = "It's just standard fluorescent lighting. "
;
