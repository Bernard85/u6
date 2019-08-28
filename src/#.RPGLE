     h OPTION(*NODEBUGIO:*SRCSTMT:*noshowcpy) nomain BndDir('U6')
      //‚Screen
     f#d        cf   e             WORKSTN infds(wsds) sfile(sfl1:SFLRRN)
      /copy cpy,u6env_h
      /copy cpy,u6fmt_h
      /copy cpy,u6form_h
      /copy cpy,u6ibm_h
      /copy cpy,u6ifs_h
      /copy cpy,u6int_h
      /copy cpy,u6msg_h
      /copy cpy,u6screen_h
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h

      /copy cpy,#_s
      //‚for refresh the screen
     d #_refresh       s               n   export inz(*off)
      //‚Screen NO
     d #_screen        s              3i 0 export
      //‚Structures for screen process
     d tRow            ds                  qualified template
     d  lControl                       *
     d  NO                            5U 0
      //‚Global fields
     d g               ds                  qualified
     d  lForm                          *
     d  row                                likeds(tRow) dim(22)
     d  Row1                               likeds(tRow) inz
     d  Row1_b4                            likeds(tRow) inz
     d  Row9                               likeds(tRow) inz
     d  Row9_b4                            likeds(tRow) inz
     d  change                         n
     d  editable                      1a
     d  lFKs                           *
     d  title                       130a   varying
      //‚--------------------------------------------------------------------
      //‚init
      //‚--------------------------------------------------------------------
     p#_loadFKs        b                   export
     d #_loadFKs       pi
     d  lFKs                           *
       //‚Load standard function keys                                        -
       screen_setFK(lFKs:x'33':'0':%pAddr(F3):'F3=Exit');
       screen_setFK(lFKs:x'3a':'1':%pAddr(f10):'F10=Move to top');
       screen_setFK(lFKs:x'3b':'1':*null:'F11=Formula   ':'F11=No Formula');
       screen_setFK(lFKs:x'f1':'1':%pAddr(Enter));
       screen_setFK(lFKs:x'f4':*ON :%pAddr(rollUP  ));
       screen_setFK(lFKs:x'f5':*ON :%pAddr(rolldown));
       g.lFKs=lFKs;
     p                 e
      //‚--------------------------------------------------------------------
      //‚load format
      //‚--------------------------------------------------------------------
     p#_loadFmt        b                   export
     d #_loadFmt       pi
     d  lFormats                       *
     d  formatID                     10a   const varying
     d  pBuffer                        *   const
     d  fmtLen                        5u 0 options(*nopass)
      *
     d  lFormat        s               *
     d format          ds                  likeDs(tFormat) based(pFormat)
       lFormat=fmt_getFormat(lFormats:formatID);
       if lFormat<>*null;
         pFormat=tree_getItem(lFormat);
         format.pBuffer1=pBuffer;
         //‚Length of the format if requested                                  -
         if %parms>=%parmnum(fmtlen);
           fmtLen=format.len;
         endif;
       endIf;
     p                 e
      //‚--------------------------------------------------------------------
      //‚load form
      //‚--------------------------------------------------------------------
     p #_loadForm      b                   export
     d  #_loadForm     pi
     d  lForms                         *
     d  formID                       10a   const varying
     d  lFormats                       *
      *
     d lX              s               *
     d label           ds                  likeds(tLabel) based(pLabel)
       //‚Load form
       g.lForm=form_getForm(lForms:formID);
       //‚Resolve formula
       lX=tree_getFirst(g.lForm);
       dow lX<>*null;
         if tree_isOfTheKind(kLabel:lX:pLabel);
           label.lFormula=int_loadFormula(label.formula:lFormats);
         endIf;
         lX=tree_getNextToDisplay(lX);
       endDo;
     p                 e
      //‚--------------------------------------------------------------------
      //‚display screen
      //‚--------------------------------------------------------------------
     p #_display       b                   export
     d  #_display      pi
     d  pgmid_                       10
     d  lForms                         *   const
     d  FormID                       10A   varying const
     d  editable                      1a   const options(*nopass)
     d  title                       130a   varying const options(*nopass)
      *
     d lForm           s               *
     d label           ds                  likeds(tLabel) based(pLabel)
       if %parms>=%parmnum(title);
         g.title=title;
       else;
         g.title='';
       endif;
       if %parms>=%parmnum(editable);
         g.editable=editable;
       else;
         g.editable='';
       endif;
       pgmid=pgmid_;
       lForm=tree_getItemFromList(lForms:kForm:formID);
       //
       #_refresh=*on;
       #_Screen=1;
       g.row1.lControl=tree_GetFirstToDisplay(g.lForm);
       g.Row1.NO=0;
       dow #_screen>0;
         if #_screen=1;
           Screen1();
         endif;
       endDo;
     p                 e
      //‚--------------------------------------------------------------------
      //‚Screen 1 - display form
      //‚--------------------------------------------------------------------
     p Screen1         b
      *
     d RowY            ds                  likeDs(tRow)
     d fkProcess       pr                  extproc(pAction)
     d pAction         s               *   procptr
     d fcontrol        s               n
       if g.row9<>g.row9_b4;
         g.row1=Sync(g.row9);
       endIf;
       //‚Load rows
       if g.row1<>g.row1_b4 or #_refresh or screen_toRefresh();
         zFK=screen_getfkentitle(g.lFKs);
         loadRows();
         g.row1_B4=g.row1;
         #_refresh=*off;
       endIf;
       //‚more item or bottom of list
       rowY=getNextRow(g.row9);
       if rowY.lControl=*null;
         mySflEnd='Bottom';
       else;
         mySflEnd='More...';
       endIf;
       //‚write and read screen formats
       write msgctl;
       write hdr1;
       if SflRRN=0;
         write sfl0;
       else;
         *in88=*on;
       endif;
       *in89=*off;
       write ctl1;
       read ctl1;
       //‚Clear messages
       msg_RmvPM(pgmID);
       //‚PROCESS OF FUNCTION KEYS BEFORE CONTROL
       screen_processFK(pgmID:g.lFKs:wsds.kp:%paddr(control));
     p                 e
      //‚-----------------------------------------------------------------------
      //‚Enter
      //‚-----------------------------------------------------------------------
     penter            b
     d enter           pi
       if not g.change;
         msg_SndPM(pgmID:'Type a function key to continue.');
       endIf;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚F3=Exit
      //‚-----------------------------------------------------------------------
     pf3               b
     d f3              pi
       #_screen=-1;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚F10=Move to top
      //‚-----------------------------------------------------------------------
     pf10              b
     d f10             pi
       if SFLCSRRRN=0;
         msg_SndPM(pgmID:'Wrong cursor position.');
       else;
         g.row1=g.row(sflcsrrrn);
       endIf;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚ROLLup
      //‚-----------------------------------------------------------------------
     prollUp           b
     d rollUp          pi
       if g.row1.lControl=tree_GetFirstToDisplay(g.lForm)
       and g.row1.NO=0;
          msg_SndPM(pgmID:'You have reached the top of the list.');
       else;
          g.row9=getPrevRow(g.row1);
       endIf;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚ROLLDOWN
      //‚-----------------------------------------------------------------------
     prolldown         b
     d rollDown        pi
       if mySflEnd='Bottom';
        msg_SndPM(pgmID:'You have reached the bottom of the list.');
       else;
        g.row1=getNextRow(g.row9);
       endif;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚load rows
      //‚-----------------------------------------------------------------------
     ploadRows         b
     d  form           ds                  likeds(tForm) based(pForm)
     d  Rowx           ds                  likeds(tRow)
     d panel           ds                  likeds(tPanel) based(pPanel)
     d label           ds                  likeds(tLabel) based(pLabel)
     d pLabel$         s               *   inz(*null)
     d lenToSee        s              3u 0
     d i               s              3u 0
     d pX              s               *
     d string          s          32000a
       //‚*) load title
       pForm=tree_getItem(G.lForm);
       if g.title<>'';
         ztitle=g.title;
       else;
         zTitle=Form.text;
       endif;
       *in88=*off;
       *in89=*on;
       WRITE ctl1;
       //‚*) clear work area                                                 s
       clear g.row;
       //‚*) Load parent panel                                               s
       rowx.lControl=tree_getParent(g.row1.lControl);
       if RowX.lControl<>g.lForm;
         Rowx.NO=0;
         g.row(1)=Rowx;
       endIf;
       //‚*) Load next                                                       s
       Rowx=g.row1;
       for i=tree_getlevel(g.row1.lControl) to 22;
          g.row(i)=Rowx;
          Rowx=getNextRow(Rowx);
          if Rowx.lControl=*null;
            leave;
          endIf;
       endFor;
       //‚*) Load subfile
       for SflRRN=1 to 22;
         clear sfl1;
         %subArr(*in:1:71)=*off;
         if g.row(SflRRN).lControl=*Null;
           leave;
         endIf;
         Rowx=g.row(sflRRN);
         g.row9=RowX;
         //‚item is label
         if tree_isoftheKind(kLabel:RowX.lControl:pLabel);
           //‚Out label text
           if pLabel<>pLabel$;
             pLabel$=pLabel;
             xText=int_AddSpaceDot('  '+Label.text:52);
             //‚formula
             if screen_getFKContext(g.lFKs:x'3b')=1;
               %subst(xtext:60-%len(label.formula))
               =x'22'+label.formula+x'20';
             endIf;
             string=int_getStringFromArg(label.lFormula);
           endif;
           //‚Out label/field value
           lentosee=int_getmin(70:label.maxWidth-rowX.NO*70);
           if isEditable(label) ;
             *in71=*on;
             *in(lenToSee)=*on;
             pX=pXIN(lenToSee);
           else;
             pX=%addr(xout);
           endif;
           ifs_memCpy(pX
                     :%addr(String)+70*rowX.NO
                     :lenToSee);
         elseif tree_isoftheKind(kPanel:RowX.lControl:pPanel);
           xText=Panel.text;
         endIf;
         write sfl1;
       endFor;
       g.row9_b4=g.row9;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get next row to display
      //‚-----------------------------------------------------------------------
     pgetNextRow       b
     d getNextRow      pi                  likeDs(tRow)
     d RowX                                likeDs(tRow) const
      *
     d RowY            ds                  likeDs(tRow)
     d label           ds                  likeDS(tLabel) based(pLabel)
     d field           ds                  likeDS(tField) based(pField)
       If tree_isOfTheKind(kLabel:rowx.lControl:pLabel);
         if (1+rowX.NO)*70<label.maxWidth;
           rowY=rowX;
           rowY.NO+=1;
           return rowY;
         endif;
       endIf;
       RowY.lControl=tree_getNextToDisplay(rowx.lControl);
       RowY.NO=0;
       return rowY;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚is editable ?
      //‚-----------------------------------------------------------------------
     pisEditable       b
     d isEditable      pi              n
     d  label                              likeDs(tLabel) const
      *
     d field           ds                  likeds(tField) based(pField)
       //‚not editable at global level
       if g.editable='N';
         return *off;
       endif;
       //‚Elaborate formula not editable
       if not tree_isOfTheKind(kField:label.lFormula:pField);
         return *off;
       endif;
       //‚only alpha field editable
       if field.type<>'A';
         return *off;
       endif;
       //‚The label must be editable
       return label.input;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get previous row to display
      //‚-----------------------------------------------------------------------
     pgetPrevRow...
     p                 b
     d getPrevRow...
     d                 pi                  likeDs(tRow)
     d RowX                                likeDs(tRow) const
      *
     d RowY            ds                  likeDs(tRow) inz
     d label           ds                  likeDS(tLabel) based(pLabel)
     d field           ds                  likeDS(tField) based(pField)
     d len             s              5u 0 inz(%len(xout))
       if tree_getKind(rowx.lControl)=kLabel and rowx.NO>0;
         rowY=rowX;
         rowY.NO-=1;
         return rowY;
       endIf;

       rowY=rowX;
       RowY.lControl=tree_getPrevtoDisplay(rowx.lControl);
       if tree_getkind(rowY.lControl)=kPanel;
         rowY.NO=0;
       elseif tree_isoftheKind(kLabel:rowy.lcontrol:pLabel);
         rowY.NO=%int((label.maxWidth-1)/70);
       endIf;
       return rowY;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚control
      //‚-----------------------------------------------------------------------
     pcontrol          b
     d control         pi              n
      *
     d lField          s               *
     d rowx            ds                  likeds(tRow)
     d label           ds                  likeds(tLabel) based(pLabel)
     d format          ds                  likeds(tFormat) based(pFormat)
     d field           ds                  likeds(tField) based(pField)
     d lenToSee        s              3u 0
       readc sfl1;
       dow not %eof();
         rowx=g.row(sflRrn);
         tree_isoftheKind(kLabel:RowX.lControl:pLabel);
         lentosee=int_getmin(70:label.maxWidth-rowX.NO*70);
         lField=label.lFormula;
         pField=tree_getItem(lField);
         pFormat=tree_getItem(tree_getParent(lField));
         ifs_memCpy(format.pBuffer1+field.posinbuffer+70*rowX.NO
                   :pXIN(lenToSee)
                   :lenToSee);
         readc sfl1;
       enddo;
       return *off;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚sync
      //‚-----------------------------------------------------------------------
     psync             b
     d sync            pi                  likeDs(tRow)
     d  rowX                               likeDs(tRow) const
      *
     d NO              s              3u 0
     d level           s              3u 0
     d  rowY           ds                  likeDs(tRow)
     d  rowZ           ds                  likeDs(tRow)
       rowY=RowX;
       rowZ=RowX;
       for NO=22 downto 1;
         if rowZ.lControl=*null;
           leave;
         endIf;
         level=tree_getLevel(rowz.lControl);
         if level=0 or level>NO;
           leave;
         endIf;
         RowY=rowZ;
         rowZ=getPrevRow(rowY);
       endfor;
       return rowY;
     p                 e
