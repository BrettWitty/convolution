// The credits

convolutioncredits: object
  sdesc = "the credits"
  ldesc = {
    "\(Convolution\)\n";
    "By Brett Witty\b";
    "This is my maiden effort, although not my first exposure to IF programming (look for Shorokin on LambdaMOO). Convolution began
    in January of 2004 and ended some time after that. The game was mapped out and plotted before being committed to code. It originally
    began in a shareware version of ADRIFT, but obviously needed a better system. Some of the locations were produced in vanilla TADS,
    but I soon switched over to WorldClass and haven't looked back since.\b";
    "Playtesters:\n";
    "\t None yet.\b";
    "Thanks go to:\n";
    "\t My friends\n";
    "\t Michael J.\ Roberts for TADS\n";
    "\t David M.\ Baggett and David Haire for WorldClass\n";
    "\t My usual sources of inspiration: Alan Watts, The Wachowski Brothers, Douglas Adams, Monkey Punch and the rest.\n";
    "\t William Shakespeare, for his insistence on appearing in almost every project I undertake, despite my best attempts to shake him.\n";
    "\t My thesaurus and dictionary (of the good ol\' paper variety). Thanks for the suggestions.\n";
    "\t The IF community for supporting the art form so thoroughly.\b";
    "And now for the serious credits:\b";
  }
;

replace creditsVerb: Systemverb, Soloverb
  verb = 'credits' 'credit'
  sdesc = "credits"
  desc = self.sdesc
  soloaction(actor) = {
    local o, ap;
    local alist := [];
    local flist := [];
    convolutioncredits.ldesc;
    "\b";
    for (o := firstobj(versionTag); o <> nil; o := nextobj(o, versionTag)) {
      if (proptype(o, &author) = 3 and proptype(o, &func) = 3) {
        ap := find(alist, o.author);
        if (ap = nil) {
          alist += o.author; flist += o.func;
        }
        else { flist[ap] += ', ' + o.func; }
      }
    }
    if (car(alist)) {
      self.credit_header;
      self.credit_list(alist, flist);
      self.credit_trailer;
    }
    abort;
  }
  credit_header = "The following modules were provided by TADS developers who were prepared to share their work with others:"
  credit_trailer = "\bIf you are a TADS developer, please consider doing the same. All the above mentioned modules should be available for ftp from the interactive fiction archive maintained by \(Volker Blasius\) on \(ftp.gmd.de\)."
  credit_list(alist, flist) = {
    local modules, f, l, p;
    while (car(alist)) {
      f := car(flist); flist := cdr(flist); l := 0;
      modules := '';
      while (true) {
        p := find(f, ', ');
        if (p <> nil) {
          if (l++ > 0) modules += ', ';
          modules += substr(f, 1, p-1);
          f := substr(f, p+1, length(f));
          continue;
        }
        if (l++ > 0) modules += ' and ';
        modules += f;
        break;
      }
      self.credit_entry(car(alist), modules, l);
      alist := cdr(alist);
    }
  }
  credit_entry(author, modules, n) =
    "\b\^<<modules>> <<n > 1 ? "were" : "was">> provided by \(<<author>>\).\n"
;