     H nomain option(*NOSHOWCPY)
      /copy cpy,u6env_h
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h
      /copy cpy,u6index_h
      //‚------------------------------------------------------------------*-
      //‚get item for index family for Xml parser
      //‚--------------------------------------------------------------------
     pindex_XmlInput...
     p                 b                   export
     d index_XmlInput...
     d                 pi              *
     d   ND                                const likeDs(xml_nodeDefine)
      *
     d   index         ds                  likeds(tIndex) based(pIndex)
     d   element       ds                  likeds(tElement) based(pElement)
       if ND.ID=iINDEX;
         pIndex=tree_getnewitem(%addr(tIndex):%size(tIndex));
         return pIndex;
       elseif ND.ID=iELEMENT;
         pElement=tree_getnewitem(%addr(tElement):%size(tElement));
         element.ID    =xml_getAttAsString ('ID' :ND.atts);
         element.Seq   =xml_getAttAsInteger('SEQ':ND.atts);
         return pElement;
       endIf;
       return *null;
     p                 e
      //‚--------------------------------------------------------------------
      //‚Set line for Xml parser from node on index family
      //‚--------------------------------------------------------------------
     pindex_XmlOutput...
     p                 b                   export
     d index_XmlOutput...
     d                 pi                  likeDs(xml_nodeDefine)
     d   lNode                         *   const
      *
     d   ND            ds                  likeDs(xml_nodeDefine)
     d   index         ds                  likeds(tIndex) based(pIndex)
     d   element       ds                  likeds(tElement) based(pElement)
       clear ND;
       if tree_getKind(lNode)=kIndex;
         ND.ID=iINDEX;
         pIndex=tree_getItem(lNode);
       elseif tree_getKind(lNode)=kElement;
         pElement=tree_getItem(lNode);
         if Element.seq>0;
           ND.ID=iELEMENT;
           xml_setAttfromInteger(ND.atts:'SEQ':element.seq);
           xml_setAttfromString(ND.atts:'ID':element.ID);
         endIf;
       endIf;
       return ND;
     p                 e
      //‚-----------------------------------------------------------------------
      //‚Comparator
      //‚-----------------------------------------------------------------------
     pindex_comparator...
     p                 b                   export
     d index_comparator...
     D                 PI             3i 0
     D  lElement1                      *   const
     D  lElement2                      *   const
      *
     D element1        ds                  likeDs(tElement) based(pElement1)
     D element2        ds                  likeDs(tElement) based(pElement2)
      *
        pElement1=tree_GetItem(lElement1);
        pElement2=tree_GetItem(lElement2);
        //‚-1 1st is lower than 2nd element                                   --
        //‚+1 1st is greater than 2nd element                                 --
        //‚0  they are equal                                                  --
        if     Element1.Seq>0 and Element2.Seq=0;
          return -1;
        elseif Element1.Seq=0 and Element2.Seq>0;
          return +1;
        elseif Element1.Seq<Element2.Seq;
          return -1;
        elseif Element1.Seq>Element2.Seq;
          return +1;
        elseif Element1.ID<Element2.ID;
          return -1;
        elseif Element1.ID>Element2.ID;
          return +1;
        endif;
        return 0;
     P                 E
