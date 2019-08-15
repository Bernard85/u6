     H nomain option(*NOSHOWCPY)
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
       lFormat=tree_getItemFromList(lFormats:kFormat:formatID);
       if lFormat=*null;
         lFormat=tree_Xml2Tree(env_getFileName(cFmt:formatId)
                              :%pAddr(Fmt_xmlInput));
         if lFormat<>*null;
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
     d   format        ds                  likeds(tFormat) based(pFormat)
     d   field         ds                  likeds(tField) based(pField)
       if ND.ID='FORMAT';
         pFormat=tree_getnewitem(%addr(tFormat):%size(tFormat));
         format.ID    =xml_getAttAsString('ID':ND.atts);
         format.len   =xml_getAttAsInteger('LEN':ND.atts);
         format.fldnbr=xml_getAttAsInteger('FLDNBR':ND.atts);
         format.pBuffer1=*null;
         format.pBuffer0=*null;
         return pFormat;

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
     d   format        ds                  likeds(tFormat) based(pFormat)
     d   field         ds                  likeds(tField) based(pField)
       clear ND;

       if tree_isofthekind(kFormat:lNode:pFormat);
         ND.ID='FORMAT';
         xml_setAttfromString (ND.atts:'ID':format.ID);
         xml_setAttfromInteger(ND.atts:'LEN':format.len);
         xml_setAttfromInteger(ND.atts:'FLDNBR':format.fldnbr);

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
       endIf;

       return ND;
     p                 e
