     h option(*NOSHOWCPY) nomain
      /copy cpy,u6msg_h
      /copy cpy,u6screen_h
      /copy cpy,u6screen_s
      /copy cpy,u6tree_h
      //‚--------------------------------------------------------------------
      //‚set new action
      //‚--------------------------------------------------------------------
     pscreen_setAction...
     p                 b                   export
     dscreen_setAction...
     d                 pi
     d lActions                        *
     d ID                             1a   const
     d fControl                        n   const
     d pProc                           *   const procptr
     d text_                         30a   const varying options(*nopass)
      *
     d text            s             30a         varying inz('')
     d action          ds                  likeds(tAction) based(pAction)
       if lActions=*null;
         lActions=tree_getNewLink(*null);
       endIf;
       if %parms()=5;
         text=text_;
       endIf;
       pAction=tree_getNewItem(%addr(tAction):%size(tAction));
       Action.ID=ID;
       Action.fControl=fControl;
       Action.text=text;
       Action.pProc=pProc;
       tree_LinkToParent(lActions:tree_getNewLink(pAction));
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get function key entitle
      //‚-----------------------------------------------------------------------
     p screen_getfkentitle...
     p                 b                   export
     d screen_getfkentitle...
     d                 pi           100a   varying
     d lActions                        *   const
      *
     d lAction         s               *
     d action          ds                  likeds(tAction) based(pAction)
     d wFK             s            100a   varying inz('')
       lAction=tree_getFirst(lActions);
       dow lAction<>*null;
         pAction=tree_getItem(lAction);
         if Action.text<>'';
           wFK+=Action.text+'  ';
         endIf;
         lAction=tree_getNext(lAction);
       endDo;
       return wfk;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get action from key pressed
      //‚-----------------------------------------------------------------------
     p screen_getActionfromkey...
     p                 b                   export
     d screen_getActionfromkey...
     d                 pi              *   procptr
     d  lActions                       *   const
     d   kp                           1a   const
     d   fControl                     1n
      *
     d lAction         s               *
     d Action          ds                  likeDs(tAction) based(pAction)
       lAction=tree_getFirst(lActions);
       dow lAction<>*null;
         pAction=tree_getItem(lAction);
         if Action.ID=kp;
           fControl=Action.fControl;
           return Action.pProc;
         endIf;
         lAction=tree_getNext(lAction);
       endDo;
       return *null;
     p                 e
      //‚--------------------------------------------------------------------
      //‚set new option
      //‚--------------------------------------------------------------------
     pscreen_setOption...
     p                 b                   export
     dscreen_setOption...
     d                 pi
     d lOptions                        *
     d ID                             2a   const
     d pChkProc                        *   const procptr
     d pValProc                        *   const procptr
     d text_                         30a   const varying options(*nopass)
      *
     d text            s             30a         varying inz('')
     d option          ds                  likeds(tOption) based(pOption)
       if lOptions=*null;
         lOptions=tree_getNewLink(*null);
       endIf;
       if %parms=5;
         text=text_;
       endIf;
       pOption=tree_getNewItem(%addr(tOption):%size(tOption));
       Option.ID=ID;
       Option.pChkProc=pChkProc;
       Option.pValProc=pValProc;
       Option.text=text;
       tree_LinkToParent(lOptions:tree_getNewLink(pOption));
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get options entitle
      //‚-----------------------------------------------------------------------
     p screen_getChoicesEntitle...
     p                 b                   export
     d screen_getChoicesEntitle...
     d                 pi           100a   varying
     d lOptions                        *   const
      *
     d lOption         s               *
     d option          ds                  likeds(tOption) based(pOption)
     d wEntitle        s            100a   varying inz('')
       lOption=tree_getFirst(lOptions);
       dow lOption<>*null;
         pOption=tree_getItem(lOption);
         if Option.text<>'';
           wEntitle+=Option.text+'  ';
         endIf;
         lOption=tree_getNext(lOption);
       endDo;
       return wEntitle;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get option from choice
      //‚-----------------------------------------------------------------------
     p screen_GetOptionfromChoice...
     p                 b                   export
     d screen_GetOptionfromChoice...
     d                 pi              *
     d  lOptions                       *   const
     d  choice                        2a   const
      *
     d lOption         s               *
     d option          ds                  likeDs(tOption) based(pOption)
       lOption=tree_getFirst(lOptions);
       dow lOption<>*null;
         pOption=tree_getItem(lOption);
         if Option.ID=choice;
           return pOption;
         endIf;
         lOption=tree_getNext(lOption);
       endDo;
       return *null;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get check procedure from option
      //‚-----------------------------------------------------------------------
     pScreen_GetCheckProcFromOption...
     p                 b                   export
     dScreen_GetCheckProcFromOption...
     d                 pi              *   procptr
     d  pOption                        *   const
      *
     d option          ds                  likeDs(tOption) based(pOption)
       return Option.pChkProc;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get validation procedure from option
      //‚-----------------------------------------------------------------------
     pScreen_GetValidationProcFromOption...
     p                 b                   export
     dScreen_GetValidationProcFromOption...
     d                 pi              *   procptr
     d  pOption                        *   const
      *
     d option          ds                  likeDs(tOption) based(pOption)
       return Option.pValProc;
     p                 e
      //‚--------------------------------------------------------------------
      //‚control FK and eventualy perform action tied
      //‚--------------------------------------------------------------------
     pscreen_processFK...
     p                 b                   export
     d screen_processFK...
     d                 pi
     d  pgmID                        10a   const
     d  lActions                       *   const
     d  FK                            1a   const
     d  pControl                       *   const procptr
      *
     d lAction         s               *
     d action          ds                  likeDS(tAction) based(pAction)
     d control         pr              n   extproc(pControl)
     d actionproc      pr                  extproc(action.pProc)
       //‚Check if the function key is allowed                               -
       lAction=tree_getItemFromList(lActions:kAction:FK);
       if lAction=*null;
         msg_SndPM(pgmID:'Function key invalid.');
         return;
       endIf;
       //‚get the action from function key                                   -
       pAction=tree_getItem(lAction);
       //‚if control needed process it                                       -
       if Action.fControl and control();
         return;
       endif;
       //‚no erros : perform the action tied to function key                 -
       actionProc();
     p                 e
      //‚--------------------------------------------------------------------
      //‚set sflend
      //‚--------------------------------------------------------------------
     pscreen_setSflend...
     p                 b                   export
     d screen_setSflend...
     d                 pi
     d  sflEnd                        7a
     d  atEnd                          n   const
       if atEnd;
         SflEnd='Bottom';
       else;
         SflEnd='More...';
       endIf;
     p                 e
