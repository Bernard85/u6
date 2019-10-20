     hoption(*NOSHOWCPY) nomain

      /copy cpy,u6ifs_h
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h
      /copy cpy,u6fmt_h

      /copy cpy,u6int_h
      //‚-----------------------------------------------------------------------
      //‚specific variables
      //‚-----------------------------------------------------------------------
     d lProcs          s               *
      //‚-----------------------------------------------------------------------
      //‚Populate string with variables
      //‚-----------------------------------------------------------------------
     pint_replaceAll...
     p                 b                   export
     d int_replaceAll...
     d                 pi           255a   varying
     d source                       255a   const varying
     d v1                           255a   const varying options(*nopass)
     d v2                           255a   const varying options(*nopass)
     d v3                           255a   const varying options(*nopass)
     d v4                           255a   const varying options(*nopass)
     d v5                           255a   const varying options(*nopass)
     d v6                           255a   const varying options(*nopass)
     d v7                           255a   const varying options(*nopass)
     d v8                           255a   const varying options(*nopass)
      *
     d i               s              3u 0
     d v               s            255a   dim(8) varying
     d result          s            255a   varying
       if %parms()>=2;
        v(1)=v1;
       endif;
       if %parms()>=3;
        v(2)=v2;
       endif;
       if %parms()>=4;
        v(3)=v3;
       endif;
       if %parms()>=5;
        v(4)=v4;
       endif;
       if %parms()>=6;
        v(5)=v5;
       endif;
       if %parms()>=7;
        v(6)=v6;
       endif;
       if %parms()>=8;
        v(7)=v7;
       endif;
       if %parms()>=9;
        v(8)=v8;
       endif;
       result=source;
       for i=1 to %parms()-1;
         result=%scanRpl('%'+%char(i):v(i):result);
       endFor;
       return result;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get string from field
      //‚-----------------------------------------------------------------------
     pint_getpStrFromField...
     p                 b                   export
     d int_getpStrFromField...
     d                 pi              *
     d  lField                         *   const
     d  pBuffer                        *   const
     d  owned                          n
     d  length                        5u 0
      *
     d field           ds                  likeDs(tField) based(pField)
     d pStr            s               *
       pField=tree_getItem(lField);
       if pBuffer=*null;
         pStr=int_allocString(
              int_replaceAll('For the field "%1" buffer is empty'
                                :field.ID):owned:length);
         return pStr;
       endIf;
       If %scan(field.type:'AOZLT')>0;
         owned=*off;
         length=field.len;
         return pBuffer+field.posinbuffer;
       elseIf %scan(field.type:'PS')>0;
         pStr=int_allocString(int_editNumeric(pBuffer:field):owned:length);
       elseIf field.type='B';
         pStr=int_allocString(int_editInteger(pBuffer:field):owned:length);
       else;
         pStr=int_allocString(
          int_replaceAll('Type "%1" of the field "%2" is not supported'
                         :field.type:field.ID):owned:length);
       endIf;
       return pStr;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚ Alloc string
      //‚-----------------------------------------------------------------------
     pInt_allocString  b                   export
     dint_allocString  pi              *
     d  String                     2048a   const varying
     d  owned                          n
     d  len                           5u 0
      *
     d p               s               *
        len=%len(String)+1;
        p=%alloc(len);
        %str(p:len)=string;
        owned=*on;
        return p;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚edit numeric
      //‚-----------------------------------------------------------------------
     pint_editNumeric...
     p                 b                   export
     d int_editNumeric...
     d                 pi            32a   varying
     d  pBuffer                        *   const
     d  field                              const likeDs(tField)
      *
     d  w30s9          s             30s 9 inz(0)
     d  w30p9          s             30p 9 inz(0)
       if field.type='S';
       ifs_memcpy(%addr(w30s9)+30-field.len:pBuffer+field.posinbuffer
                                           :field.len);
       else;
       ifs_memcpy(%addr(w30p9)+16-field.len:pBuffer+field.posinbuffer
                                           :field.len);
         w30s9=w30p9;
       endIf;
       return int_editNumeric2(w30s9:field);
     p                 e
      //‚-----------------------------------------------------------------------
      //‚edit numeric 2
      //‚-----------------------------------------------------------------------
     pint_editNumeric2...
     p                 b
     d int_editNumeric2...
     d                 pi            32a   varying
     d w30s9                         30s 9 value
     d field                               const likeds(tField)
      *
     d val             s             32a   varying
     d p               s              3u 0
     d p1              s              3u 0
     d l               s              3u 0
       for p=1 to 9-field.dec;
         w30s9*=10;
       endFor;
       val=%editc(w30s9:'P');
       p=%scan('.':val);
       p1=p-field.digits+field.dec-1;
       l=1+field.digits+%int(field.dec>0);
       val=%subst(val:p1:l);
       return val;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚edit integer
      //‚-----------------------------------------------------------------------
     pint_editInteger...
     p                 b                   export
     d int_editInteger...
     d                 pi            32a   varying
     d  pBuffer                        *   const
     d  field                              const likeDs(tField)
      *
     d  int2           s              5i 0 inz(0)
     d  int4           s             10i 0 inz(0)
     d  int8           s             20i 0 inz(0)
       if field.len=2;
         ifs_memcpy(%addr(Int2):pBuffer+field.posinbuffer:2);
         return %char(int2);
       elseif field.len=4;
         ifs_memcpy(%addr(Int4):pBuffer+field.posinbuffer:4);
         return %editc(%dec(int4:9:0):'Q');
       elseif field.len=8;
         ifs_memcpy(%addr(Int8):pBuffer+field.posinbuffer:8);
         return %char(int8);
       endif;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get minus of 2 values
      //‚-----------------------------------------------------------------------
     pint_getMin       b                   export
     d int_getMin      pi             5u 0
     d  v1                            5u 0 const
     d  v2                            5u 0 const
       if v1<v2;
         return v1;
       else;
         return v2;
       endif;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚Complete with space/dot at left
      //‚-----------------------------------------------------------------------
     pint_AddSpaceDot...
     p                 b                   export
     d int_AddSpaceDot...
     d                 pi           255a   varying
     d  source                      255a   const varying
     d  lastPos                       3u 0 const
      *
     d  dest           s            255a   varying
     d xText           s            255a   inz(*all' .')
       if source='';
         return '';
       endif;
       dest=source;
       if %len(source)>lastPos;
         return %subst(source:1:lastPos);
       endIf;
       %subst(xText:1:%len(dest))=dest;
       return %subst(xText:1:lastPos);
     p                 e
      //‚-----------------------------------------------------------------------
      //‚Scan from Right
      //‚-----------------------------------------------------------------------
     pint_ScanR        b                   export
     D int_ScanR       PI             3u 0
     D  charFound                    10A   const varying
     D  String                      255A   const varying
     d  fromPos_                      3u 0 const options(*nopass)
      *
     d  fromPos        s              3u 0
     D  p              s              3u 0
       if %parms()=3;
         fromPos=fromPos_;
       else;
         fromPos=%len(String);
       endIf;
       for p=fromPos-%len(charFound)+1 downto 1;
         if %subst(String:p:%len(charFound))=CharFound;
           return p;
         endIf;
       endFor;
       return 0;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚load procedures
      //‚-----------------------------------------------------------------------
     pint_LoadProcs    b                   export
     d int_loadProcs   pi
       lProcs=tree_getnewlink(*null);
       int_loadProc(lProcs:'TODAY' :%pAddr(today));
       int_loadProc(lProcs:'CONCAT':%pAddr(concat));
       int_loadProc(lProcs:'%TRIM' :%pAddr(trim));
     p                 e
      //‚-----------------------------------------------------------------------
      //‚load procedure
      //‚-----------------------------------------------------------------------
     pint_LoadProc     b
     d int_loadProc    pi
     d  lProcs                         *
     d  ID                           35    varying const
     d  pAddr                          *   procptr const
      *
     d proc            ds                  likeDs(tProc) based(pProc)
       pProc=tree_getNewItem(%addr(tProc):%size(tProc));
       Proc.ID=ID;
       proc.pAddr=pAddr;
       tree_linktoParent(lProcs:tree_getNewLink(pProc));
     p                 e
      //‚-----------------------------------------------------------------------
      //‚pre-load the formula
      //‚-----------------------------------------------------------------------
     pint_FormulaLoad  b                   export
     d int_FormulaLoad...
     d                 pi              *
     d  formula_                   1000a   varying const
     d  lRep                           *   const
      *
     d lArg            s               *
     d p               s              5u 0
     d formula         s           1000a
       //‚the formula is empty ?
       if formula_='';
         return *null;
       endif;
       formula=formula_+' ';
       p=%check(' ':formula:1);
       if %scan(%subst(formula:p:1):min+maj+num+spec+'''')=0;
           return int_getNewlErr(
           'the first character is unexpected.');
       endif;
       lArg=int_getArg(formula:p:lRep);
       if tree_isofthekind(kErr:lArg) or p=0;
         return lArg;
       endif;
       p=%check(' ':formula:p);
       if p>0;
           return int_getNewlErr(
           'Unexpected character is found.');
       endif;
       return lArg;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get argument
      //‚-----------------------------------------------------------------------
     pint_getArg       b
     d int_getArg      pi              *
     d  formula                    1000a   varying const
     d  p                             5u 0
     d  lRep                           *   const
      *
     d  lArg           s               *
       lArg=int_getArg2(formula:p:lRep);
       if tree_isofthekind(kErr:lArg) or p=0;
         return lArg;
       endif;
       //
       p=%check(' ':formula:p);
       if p>0 and %subst(formula:p:1)='+';
         return int_plus(lArg:formula:p:lRep);
       endIf;
       return larg;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get argument (part 2)
      //‚-----------------------------------------------------------------------
     pint_getArg2      b
     d int_getArg2     pi              *
     d  formula                    1000a   varying const
     d  p                             5u 0
     d  lRep                           *   const
      *
     d p1              s              5u 0
     d p2              s              5u 0
     d p3              s              5u 0
     d keyWord         s             50a   varying
       //‚search for the next filled position
       p1=%check(' ':formula:p);
       if %subst(formula:p1:1)='''';
         p=p1;
         return int_getConst(formula:p);
       endif;
       //‚search for the next no meaning position
       p2=%check(min+maj+num+spec:formula:p1);
       //‚get the key word
       keyWord=%subst(formula:p1:p2-p1);
       //‚put the keyword on uppercase
       keyWord=%xlate(min:maj:keyWord);
       //‚get the next charactere
       p3=%check(' ':formula:p2);
       if p3>0 and %subst(formula:p3:1)='(';
         p=p3+1;
         return int_getProc(keyWord:formula:p:lRep);
       else;
         p=p3;
         return int_getField(keyWord:p:lRep);
       endIf;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get the field
      //‚-----------------------------------------------------------------------
     pint_getField     b
     d int_getField    pi              *
     d  keyword                      50a   const varying
     d  p                             5u 0
     d  lRep                           *   const
      *
     d lFmt            s               *
     d lFields         s               *
     d lField          s               *
       if tree_isOftheKind(kFormats:lRep);
         lFmt=tree_getFirst(lRep);
         dow lFmt<>*null;
           lFields=tree_getLinkFromList(lFmt:kFields);
           lField=tree_getLinkFromList(lFields:kField:keyWord);
           if lField<>*null;
             return lField;
           endif;
           lFmt=tree_getNext(lFmt);
         endDo;
       elseif tree_isOftheKind(kFormat:lRep);
         lFields=tree_getLinkFromList(lRep:kFields);
         lField=tree_getLinkFromList(lFields:kField:keyWord);
         if lField<>*null;
           return lField;
         endif;
       endif;
       return int_getNewlErr('The field '+keyWord+' is not defined');
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get the procedure
      //‚-----------------------------------------------------------------------
     pint_getProc      b
     d int_getProc     pi              *
     d  keyword                      50a   const varying
     d  formula                    1000a   varying const
     d  p                             5u 0
     d  lRep                           *   const
      *
     d lProc           s               *
       lProc=tree_getLinkFromList(lProcs:kProc:keyWord);
       if lProc=*null;
         return int_getNewlErr('The procedure '+keyWord+' is not defined');
       endIf;
       p=%check(' ':formula:p);
       //‚procedure without arguments
       if p>0 and %subst(formula:p:1)=')';
         p+=1;
         return lProc;
       endIf;
       //‚create a link to tie arguments
       return int_getArgs(lProc:formula:p:lRep);
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get the arguments of the procedure
      //‚-----------------------------------------------------------------------
     pint_getArgs      b
     d int_getArgs     pi              *
     d  lProc$                         *   const
     d  formula                    1000a   varying const
     d  p                             5u 0
     d  lRep                           *   const
      *
     d  lProc          s               *
     d  lArg           s               *
       lProc=tree_getNewLink(lProc$);
       dou p=0 or %subst(formula:p:1)<>':';
         p=%check(':':formula:p);
         lArg=int_getArg(formula:p:lRep);
         if tree_isOfTheKind(kErr:lArg);
           return lArg;
         elseif tree_isOfTheKind(klink:lArg);
           tree_linktoparent(lProc:lArg);
         else;
           tree_linktoparent(lProc:tree_getNewLink(lArg));
         endIf;
         p=%check(' ':formula:p);
       endDo;
       if p=0 or %subst(formula:p:1)<>')';
           return int_getNewlErr(
           'A right parenthesis is expected but is not found.');
       endif;
       p+=1;
       return lProc;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚concat arguments (triggered by plus)
      //‚-----------------------------------------------------------------------
     pint_plus         b
     d int_plus        pi              *
     d  lArg1                          *   const
     d  formula                    1000a   varying const
     d  p                             5u 0
     d  lRep                           *   const
      *
     d  lPlus          s               *
     d  lArg           s               *
       lPlus=tree_getNewLink(tree_getLinkFromList(lProcs:kProc:'CONCAT'));
         if tree_isOfTheKind(klink:lArg1);
           tree_linktoparent(lPlus:lArg1);
         else;
           tree_linktoparent(lPlus:tree_getNewLink(lArg1));
         endIf;
       dou p=0 or %subst(formula:p:1)<>'+';
         p=%check('+ ':formula:p);
         if p=0;
           return int_getNewlErr(
           'An argument is expected but not found.');
         endif;
         lArg=int_getArgPlus(formula:p:lRep);
         if tree_isOfTheKind(kErr:lArg);
           return lArg;
         elseif tree_isOfTheKind(klink:lArg);
           tree_linktoparent(lPlus:lArg);
         else;
           tree_linktoparent(lPlus:tree_getNewLink(lArg));
         endIf;
       endDo;
       return lPlus;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get argument in plus context
      //‚-----------------------------------------------------------------------
     pint_getArgPlus   b
     d int_getArgPlus  pi              *
     d  formula                    1000a   varying const
     d  p                             5u 0
     d  lRep                           *   const
      *
     d  lArg           s               *
       lArg=int_getArg2(formula:p:lRep);
       if tree_isofthekind(kErr:lArg) or p=0;
         return lArg;
       endif;
       //
       p=%check(' ':formula:p);
       return larg;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get const
      //‚-----------------------------------------------------------------------
     pint_getConst     b
     d int_getConst    pi              *
     d  formula                    1000a   varying const
     d  p                             5u 0
      *
     d  Str            s           2048a   varying
     d  p1             s              5u 0
     d  p2             s              5u 0
       p1=p+1;
       dow 1=1;
         p2=%scan('''':formula:p1);
         if p2=0;
           return int_getNewlErr('missing trailing apostrophe (pos='+
                                  %char(p)+')');
         endif;
         str+=%subst(formula:p1:p2-p1);
         if %subst(formula:p2:2)='''''';
           str+='''';
           p1=p2+2;
           iter;
         endif;
         leave;
       enddo;
       p=p2+1;
       return int_getNewlCst(str);
     p                 e
      //‚-----------------------------------------------------------------------
      //‚ create a new error
      //‚-----------------------------------------------------------------------
     pint_getNewlErr...
     p                 b
     d int_getNewlErr...
     d                 pi              *
     d  Str                        2048a   const varying
      *
     d err             ds                  likeDs(tErr) based(pErr)
       pErr=tree_getNewItem(%addr(tErr):%size(tErr));
       err.pStr=int_allocStr(str);
       return tree_getNewLink(pErr);
     p                 e
      //‚-----------------------------------------------------------------------
      //‚ create a new constant
      //‚-----------------------------------------------------------------------
     pint_getNewlCst...
     p                 b
     d int_getNewlCst...
     d                 pi              *
     d  Str                        2048a   const varying
      *
     d cst             ds                  likeDs(tCst) based(pCst)
       pCst=tree_getNewItem(%addr(tCst):%size(tCst));
       cst.pStr=int_allocStr(str);
       return tree_getNewLink(pCst);
     p                 e
      //‚-----------------------------------------------------------------------
      //‚ Alloc string
      //‚-----------------------------------------------------------------------
     pint_allocStr     b
     d int_allocStr    pi              *
     d  Str                        2048a   const varying
      *
     d pStr            s               *
     d len             s              5u 0
       len=%len(Str)+1;
       pStr=%alloc(len);
       %str(pStr:len)=str;
       return pStr;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚get string from argument
      //‚-----------------------------------------------------------------------
     pint_FormulaExec  b                   export
     dint_FormulaExec  pi         32000a   varying
     d  lArg                           *   const
     d  curBuffer                     3u 0 const options(*nopass)
      *
     d  lArg$          s               *
     d  field          ds                  likeDS(tField) based(pField)
     d  fmt            ds                  likeDS(tFormat) based(pFmt)
     d  err            ds                  likeDS(tErr) based(pErr)
     d  cst            ds                  likeDS(tCst) based(pCst)
     d  proc           ds                  likeDS(tProc) based(pProc)
     d  String         s          32000a   varying inz('?')
     d  buffer         s          32000a   based(pBuffer)
     d  pBuffer        s               *
      //˜procedure                                                          -
     d  procexe        pr         32000a   varying extproc(proc.pAddr)
     d                                 *   options(*nopass) const
       //‚the item/link is a link?take it as argument
       if not tree_isOfTheKind(kLink:lArg:lArg$);
         lArg$=lArg;
       endIf;
       //‚get the value from the kind of item
       if tree_isOfTheKind(kField:lArg$:pField);
         //‚field
         pFmt=tree_getItem(tree_getParent(tree_getParent(lArg$)));
         //
         if %parms()=1;
           pBuffer=fmt.pBuffer1;
         elseif curBuffer=1;
           pBuffer=fmt.pBuffer1;
         else;
           pBuffer=fmt.pBuffer0;
         endIf;
         //
         if %scan(field.type:'AOZLT')>0;
           String=%subst(buffer:field.posInBuffer+1:field.len);
         elseif %scan(field.type:'PS')>0;
           String=int_editNumeric(pBuffer:field);
         elseIf field.type='B';
           String=int_editInteger(pBuffer:field);
         elseIf field.type='V';
           ifs_memcpy(%addr(string):pBuffer+field.posInBuffer:field.len);
         endIf;
         return String;
       elseif tree_isOfTheKind(kErr:lArg$:pErr);
         //‚error
         String=%str(err.pStr);
         return String;
       elseif tree_isOfTheKind(kCst:lArg$:pCst);
         //‚constante
         String=%str(cst.pStr);
         return String;
       elseif tree_isOfTheKind(kProc:lArg$:pProc);
         //‚procedure
         String=procexe(lArg);
         return String;
       else;
         return '';
       endIf;
     p                 e
      //˜-----------------------------------------------------------------------
      //˜get today date
      //˜-----------------------------------------------------------------------
     ptoday            b
     d today           pi         32000a   varying
     d lArgs                           *   options(*nopass) const
      *
     d str             s          32000a   varying
       str=%char(%date());
       return str;
     p                 e
      //˜-----------------------------------------------------------------------
      //˜concatenation
      //˜-----------------------------------------------------------------------
     pConcat           b
     d concat          pi         32000a   varying
     d lArgs                           *   options(*nopass) const
      *
     d string          s          32000a   varying
     d lArg            s               *
       lArg=tree_getFirst(lArgs);
       dow lArg<>*null;
         String+=%trim(int_FormulaExec(lArg));
         lArg=tree_getNext(lArg);
       endDo;
       return string;
     p                 e
      //˜-----------------------------------------------------------------------
      //˜trim
      //˜-----------------------------------------------------------------------
     pTrim             b
     d trim            pi         32000a   varying
     d lArgs                           *   options(*nopass) const
      *
     d string          s          32000a   varying
     d lArg            s               *
      *
       lArg=tree_getFirst(lArgs);
       String=int_FormulaExec(lArg);
       string=%trim(string);
       return string;
     p                 e
