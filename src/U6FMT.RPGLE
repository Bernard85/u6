     H nomain option(*NOSHOWCPY)
      /copy cpy,u6int_h
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h
      /copy cpy,u6env_h

      /copy cpy,u6fmt_h
      //‚--------------------------------------------------------------------
      //‚get format from list
      //‚--------------------------------------------------------------------
     pfmt_getFormat    b                   export
     d fmt_getFormat   pi              *
     d  lFormats                       *
     d  formatID                     10a   const varying
      *
     d  lFormat        s               *
       if lFormats=*null;
         lformats=tree_getnewlink(
                  tree_getNewItem(%addr(tFormats):%size(tFormats)));
       endif;
       lFormat=tree_getLinkFromList(lFormats:kFormat:formatID);
       if lFormat=*null;
         lFormat=tree_Xml2Tree(env_getFileName(cFmt:formatId)
                              :%pAddr(Fmt_xmlInput));
         if lFormat<>*null;
           fmt_SubFormatsFormulaLoad(lFormat);
           tree_linktoparent(lFormats:lFormat);
         endif;
       endIf;
       return lFormat;
     p                 e
      //‚------------------------------------------------------------------*
      //‚get item for FORMAT family
      //‚-------------------------------------------------------------------
     pfmt_XmlInput     b                   export
     d fmt_xmlInput    pi              *
     d   ND                                const likeDs(xml_nodeDefine)
      *
     d   format        ds                  likeds(tFormat)    based(pFormat)
     d   fields        ds                  likeds(tFields)    based(pFields)
     d   field         ds                  likeds(tField)     based(pField)
     d   subFormats    ds                  likeds(tSubFormats)based(pSubFormats)
     d   subFormat     ds                  likeds(tSubFormat) based(pSubFormat)
       if ND.ID='FORMAT';
         pFormat=tree_getnewitem(%addr(tFormat):%size(tFormat));
         format.ID    =xml_getAttAsString('ID':ND.atts);
         format.len   =xml_getAttAsInteger('LEN':ND.atts);
         format.fldnbr=xml_getAttAsInteger('FLDNBR':ND.atts);
         format.pBuffer1=*null;
         format.pBuffer0=*null;
         return pFormat;

       elseIf ND.ID='FIELDS';
         pFields=tree_getnewitem(%addr(tFields):%size(tFields));
         return pFields;

       elseif ND.ID='FIELD';
         pField=tree_getnewitem(%addr(tField):%size(tField));
         field.ID  =xml_getAttAsString('ID':ND.atts);
         field.NO  =xml_getAttAsInteger('NO':ND.atts);
         field.type=xml_getAttAsString('TYPE':ND.atts);
         field.Len =xml_getAttAsInteger('LEN':ND.atts);
         field.dec =xml_getAttAsInteger('DEC':ND.atts);
         field.digits=xml_getAttAsInteger('DIGITS':ND.atts);
         field.posinbuffer=xml_getAttAsInteger('POS':ND.atts)-1;
         return pField;

       elseIf ND.ID='SUBFORMATS';
         pSubFormats=tree_getnewitem(%addr(tSubFormats):%size(tSubFormats));
         return pSubFormats;

       elseIf ND.ID='SUBFORMAT';
         pSubFormat=tree_getnewitem(%addr(tSubFormat):%size(tSubFormat));
         SubFormat.pos=xml_getAttAsInteger('POS':ND.atts)-1;
         SubFormat.formula=xml_getAttAsString('FORMULA':ND.atts);
         return pSubFormat;

       endIf;
       return *null;
     p                 e
      //‚------------------------------------------------------------------*
      //‚set item for FORMAT family
      //‚-------------------------------------------------------------------
     pfmt_XMLoutput    b                   export
     d fmt_XMLoutput   pi                  likeDs(xml_nodeDefine)
     d   lNode                         *   const
      *
     d   ND            ds                  likeDs(xml_nodeDefine)
     d   format        ds                  likeds(tFormat)    based(pFormat)
     d   fields        ds                  likeds(tFields)    based(pFields)
     d   field         ds                  likeds(tField)     based(pField)
     d   subFormats    ds                  likeds(tSubFormats)based(pSubFormats)
     d   subFormat     ds                  likeds(tSubFormat) based(pSubFormat)
       clear ND;

       if tree_isofthekind(kFormat:lNode:pFormat);
         ND.ID='FORMAT';
         xml_setAttfromString (ND.atts:'ID':format.ID);
         xml_setAttfromInteger(ND.atts:'LEN':format.len);
         xml_setAttfromInteger(ND.atts:'FLDNBR':format.fldnbr);

       elseIf tree_isofthekind(kFields:lNode:pFields);
         ND.ID='FIELDS';

       elseif tree_isofthekind(kField:lNode:pField);
         ND.ID='FIELD';
         xml_setAttfromString (ND.atts:'ID':field.ID);
         xml_setAttfromInteger(ND.atts:'NO':field.NO);
         xml_setAttfromString (ND.atts:'TYPE':field.type);
         xml_setAttfromInteger(ND.atts:'LEN':field.len);
         if %scan(field.type:'PS')>0;
           xml_setAttfromInteger(ND.atts:'DIGITS':field.digits);
           xml_setAttfromInteger(ND.atts:'DEC':field.dec);
         endIf;
         xml_setAttfromInteger(ND.atts:'POS':field.posinbuffer);

       elseIf tree_isofthekind(kSubFormats:lNode:pSubFormats);
         ND.ID='SUBFORMATS';

       elseIf tree_isofthekind(kSubFormat:lNode:pSubFormat);
         ND.ID='SUBFORMAT';
         xml_setAttfromInteger(ND.atts:'POS':SubFormat.pos);
         xml_setAttfromString (ND.atts:'FORMULA':SubFormat.formula);

       endIf;

       return ND;
     p                 e
      //‚------------------------------------------------------------------*
      //‚for SubFormats load there formula
      //‚-------------------------------------------------------------------
     pfmt_SubFormatsFormulaLoad...
     p                 b
     d fmt_SubFormatsFormulaLoad...
     d                 pi
     d  lFormat                        *
      *
     d  lSubFormats    s               *
     d  lSubFormat     s               *
     d  SubFormat      ds                  likeDs(tSubFormat)based(pSubFormat)
      *
       lSubFormats=tree_getLinkFromList(lFormat:kSubFormats);
       if lSubFormats=*null;
         return;
       endif;
       lSubFormat=tree_getFirst(lSubFormats);
       dow lSubFormat<>*null;
         pSubFormat=tree_getItem(lSubFormat);
         subFormat.lFormula=int_FormulaLoad(subFormat.Formula:lFormat);
         lSubFormat=tree_getNext(lSubFormat);
       endDo;
     p                 e
