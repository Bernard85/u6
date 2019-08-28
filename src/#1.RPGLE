     h OPTION(*NODEBUGIO:*SRCSTMT:*noshowcpy)

      /If Defined(*CRTBNDRPG)
     h DFTACTGRP(*NO) BndDir('#':'U6') actgrp('X6')
      /endif
      //‚copy
      /copy cpy,#_H
      /copy cpy,u6fmt_H
      /copy cpy,u6ibm_H
      /copy cpy,u6int_H
      /copy cpy,u6screen_H
      /copy cpy,u6tree_H
      /copy cpy,u6xml_H
      *
     d  lFKs           s               *
     d  lFormats       s               *
     d  lForms         s               *
     d  w2000          s           2000a
     d  fmtLen         s              5u 0
     d  format         ds                  likeDs(tFormat) based(pFormat)
     d #1              pi
     d  dtaaraID                     20a   const
     d  fmtID                        10a   const
     d  formID                       10a   const
     d  update                        1a   const
       //‚1) Load procedure for the interpreter
       int_loadProcs();

       //‚2) load standard actions
       #_loadFKs(lFKs);

       //‚3) Specific functions
       if update='Y';
         screen_setFK(lFKs:x'36':*On:%pAddr(F6):'F6=Validation');
       endif;

       //‚4) format
       #_loadFmt(lFormats:%trim(fmtID):%addr(w2000):fmtLen);

       //‚5) form
       #_loadForm(lForms:%trim(formID):lFormats);

       //‚5) Get data from dtaara
       qxxrtvda(dtaaraID:1:fmtLen:w2000);

       //‚6) Display the result
       #_display(pgmID:lForms:%trim(formID):update);

       *inlr=*on;
      //‚-----------------------------------------------------------------------
      //‚F6=Valid
      //‚-----------------------------------------------------------------------
     pF6               b
     d F6              pi
       qxxchgda(dtaaraID:1:fmtLen:w2000);
       #_screen=-1;
     p                 e
