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
       if lFKs=*null;
         lFKs=tree_getNewLink(*null);
       endIf;
       pFK=tree_getNewItem(%addr(tFK):%size(tFK));
       FK.key=key;
       FK.fControl=fControl;
       FK.pFunction=pFunction;
       lFK=tree_getNewLink(pFK);
       tree_LinkToParent(lFKs:lFK);
       screen_setFKC(lFK:%parms():%parmnum(Libel0):'0':libel0);
       screen_setFKC(lFK:%parms():%parmnum(Libel1):'1':libel1);
       screen_setFKC(lFK:%parms():%parmnum(Libel2):'2':libel2);
     p                 e
      //‚--------------------------------------------------------------------
      //‚set new function key
      //‚--------------------------------------------------------------------
     pscreen_setFKC    b
     d screen_setFKC   pi
     d  lFK                            *   const
     d  parms                         3u 0 const
     d  parmnum                       3u 0 const
     d  ID                            1a   const
     d  libel                        30a   const varying options(*nopass)
      *
     d FKC             ds                  likeds(tFKC) based(pFKC)
       if parms<parmnum;
         return;
       endif;
       pFKC=tree_getnewitem(%addr(tFKC):%size(tFKC));
       FKC.ID=ID;
       FKC.libel=libel;
       tree_LinkToParent(lFK:tree_getNewLink(pFKC));
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get function key context
      //‚-----------------------------------------------------------------------
     pscreen_getFKcontext...
     p                 b                   export
     d screen_getFKcontext...
     d                 pi             1a
     d  lFKs                           *   const
     d  key                           1a   const
      *
     d lFK             s               *
     d FK              ds                  likeDs(tFK) based(pFK)
     d lFKC            s               *
     d FKC             ds                  likeDs(tFKC) based(pFKC)
       lFK=tree_getLinkFromList(lFKs:kFK:key);
       if lFK=*null;
         return '';
       endIf;
       lFKC=tree_getFirst(lFK);
       if lFKC=*null;
         return '';
       endIf;
       pFKC=tree_getItem(lFKC);
       return FKC.ID;
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
     d  context                       1a   const
      *
     d lFK             s               *
     d FK              ds                  likeDs(tFK) based(pFK)
     d lFKC            s               *
     d FKC             ds                  likeDs(tFKC) based(pFKC)
       lFK=tree_getLinkFromList(lFKs:kFK:key);
       if lFK=*null;
         return;
       endif;
       lFKC=tree_getLinkFromList(lFK:kFKC:context);
       if lFKC=*null;
         return;
       endif;
       tree_setFirst(lFKC);
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
     d                 pi           123a   varying
     d lFKs                            *   const
      *
     d lFK             s               *
     d FK              ds                  likeds(tFK) based(pFK)
     d wFK             s            123a   varying inz('')
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
       lFK=tree_getLinkFromList(lFKs:kFK:key);
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
     d text                          30a   const varying options(*nopass)
      *
     d option          ds                  likeds(tOption) based(pOption)
       if lOptions=*null;
         lOptions=tree_getNewLink(*null);
       endIf;
       pOption=tree_getNewItem(%addr(tOption):%size(tOption));
       Option.ID=ID;
       if %parms()=%parmnum(text);
         Option.text=text;
       endIf;
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
