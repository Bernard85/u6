     h option(*NOSHOWCPY) nomain
      /copy cpy,u6msg_h
      /copy cpy,u6screen_h
      /copy cpy,u6screen_s
      /copy cpy,u6tree_h
      //‚--------------------------------------------------------------------
      //‚set new function key
      //‚--------------------------------------------------------------------
     pscreen_setFK     b                   export
     d screen_setFK    pi
     d  lFKS                           *
     d  key                           1a   const
     d  fControl                       n   const
     d  pfunction                      *   const procptr
     d  libel0                       30a   const varying options(*nopass)
     d  libel1                       30a   const varying options(*nopass)
     d  libel2                       30a   const varying options(*nopass)
      *
     d FK              ds                  likeds(tFK) based(pFK)
     d lFK             s               *
     d FKC             ds                  likeds(tFKC) based(pFKC)
       if lFKs=*null;
         lFKs=tree_getNewLink(*null);
       endIf;
       pFK=tree_getNewItem(%addr(tFK):%size(tFK));
       FK.key=key;
       FK.fControl=fControl;
       FK.pFunction=pFunction;
       lFK=tree_getNewLink(pFK);
       tree_LinkToParent(lFKs:lFK);
       if %parms>=%parmnum(libel0);
         pFKC=tree_getnewitem(%addr(tFKC):%size(tFKC));
         FKC.NO=0;
         FKC.libel=libel0;
         tree_LinkToParent(lFK:tree_getNewLink(pFKC));
       endif;
       if %parms>=%parmnum(libel1);
         pFKC=tree_getnewitem(%addr(tFKC):%size(tFKC));
         FKC.NO=1;
         FKC.libel=libel1;
         tree_LinkToParent(lFK:tree_getNewLink(pFKC));
       endif;
       if %parms>=%parmnum(libel2);
         pFKC=tree_getnewitem(%addr(tFKC):%size(tFKC));
         FKC.NO=2;
         FKC.libel=libel2;
         tree_LinkToParent(lFK:tree_getNewLink(pFKC));
       endif;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get function key context
      //‚-----------------------------------------------------------------------
     pscreen_getFKcontext...
     p                 b                   export
     d screen_getFKcontext...
     d                 pi             3i 0
     d  lFKs                           *   const
     d  key                           1a   const
      *
     d lFK             s               *
     d FK              ds                  likeDs(tFK) based(pFK)
     d lFKC            s               *
     d FKC             ds                  likeDs(tFKC) based(pFKC)
       lFK=tree_getItemFromList(lFKs:kFK:key);
       if lFK=*null;
         return -1;
       endIf;
       lFKC=tree_getFirst(lFK);
       if lFKC=*null;
         return -1;
       endIf;
       pFKC=tree_getItem(lFKC);
       return FKC.NO;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚set function key context
      //‚-----------------------------------------------------------------------
     pscreen_setFKcontext...
     p                 b                   export
     d screen_setFKcontext...
     d                 pi
     d  lFKs                           *   const
     d  key                           1a   const
     d  context                       3u 0 const
      *
     d lFK             s               *
     d FK              ds                  likeDs(tFK) based(pFK)
     d lFKC            s               *
     d FKC             ds                  likeDs(tFKC) based(pFKC)
       lFK=tree_getFirst(lFKs);
       dow lFK<>*null;
         pFK=tree_getItem(lFK);
         if FK.key=key;
           lFKC=tree_getFirst(lFK);
           dow lFKC<>*null;
             pFKC=tree_getItem(lFKC);
             if FKC.NO=context;
               tree_setFirst(lFKC);
               return;
             endIf;
             lFKC=tree_getNext(lFKC);
           endDo;
         endIf;
         lFK=tree_getNext(lFK);
       endDo;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚screen need to be refreshed
      //‚-----------------------------------------------------------------------
     pscreen_toRefresh...
     p                 b                   export
     d screen_toRefresh...
     d                 pi              n
       return screen_flagTorefresh;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get function key entitle
      //‚-----------------------------------------------------------------------
     pscreen_getfkentitle...
     p                 b                   export
     d screen_getfkentitle...
     d                 pi           100a   varying
     d lFKs                            *   const
      *
     d lFK             s               *
     d FK              ds                  likeds(tFK) based(pFK)
     d wFK             s            100a   varying inz('')
     d FKC             ds                  likeds(tFKC) based(pFKC)
     d lFKC            s               *
       lFK=tree_getFirst(lFKs);
       dow lFK<>*null;
         lFKC=tree_getFirst(lFK);
         if lFKC<>*null;
           pFKC=tree_getItem(lFKC);
           wFK+=FKC.libel+'  ';
         endIf;
         lFK=tree_getNext(lFK);
       endDo;
       screen_FlagtoRefresh=*off;
       return wfk;
     p                 e
      //‚--------------------------------------------------------------------
      //‚control FK and eventualy perform action tied
      //‚--------------------------------------------------------------------
     pscreen_processFK...
     p                 b                   export
     d screen_processFK...
     d                 pi
     d  pgmID                        10a   const
     d  lFKs                           *   const
     d  key                           1a   const
     d  pControl                       *   const procptr
      *
     d lFK             s               *
     d FK              ds                  likeDS(tFK) based(pFK)
     d lFKC            s               *
     d control         pr              n   extproc(pControl)
     d function        pr                  extproc(FK.pFunction)
       //‚Check if the function key is allowed                               -
       lFK=tree_getItemFromList(lFKs:kFK:key);
       if lFK=*null;
         msg_SndPM(pgmID:'Function key invalid.');
         return;
       endIf;
       //‚get the action from function key
       pFK=tree_getItem(lFK);
       //‚if control needed process it
       if FK.fControl and control();
         return;
       endif;
       //‚Change context/libel on FK
       if tree_getFirst(lFK)<>tree_getLast(lFK);
         lFKC=tree_getFirst(lFK);
         lFKC=tree_getNextInLoop(lFKC);
         tree_setFirst(lFKC);
         screen_FlagtoRefresh=*on;
       endIf;
       //‚no erros : perform the action tied to function key
       if FK.pFunction<>*null;
         function();
       endIf;
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
