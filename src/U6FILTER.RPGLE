     H nomain option(*NOSHOWCPY)
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h
      /copy cpy,u6env_h

      /copy cpy,u6filter_h
      //‚--------------------------------------------------------------------
      //‚get item for filter family for Xml parser
      //‚--------------------------------------------------------------------
     pfilter_XmlInput...
     p                 b                   export
     d filter_XmlInput...
     d                 pi              *
     d  ND                                 const likeDs(xml_nodeDefine)
      *
     d filters         ds                  likeDs(tFilters) based(pFilters)
     d filter          ds                  likeDs(tFilter) based(pFilter)
     d omit            ds                  likeDs(tOmit) based(pOmit)
       if ND.ID='FILTERS';
         pFilters=tree_getnewitem(%addr(tFilters):%size(tFilters));
         filters.activated=xml_getAttAsBoolean('ACTIVATED':ND.atts);
         return pFilters;
       elseIf ND.ID='FILTER';
         pFilter=tree_getnewitem(%addr(tFilter):%size(tFilter));
         Filter.ID=xml_getAttAsString('ID':ND.atts);
         return pFilter;
       elseIf ND.ID='OMIT';
         pOmit=tree_getnewitem(%addr(tOmit):%size(tOmit));
         omit.ID=xml_getAttAsString('ID':ND.atts);
         return pOmit;
       endIf;
       return *null;
     p                 e
      //‚--------------------------------------------------------------------
      //‚Set line for Xml parser from node on filter family
      //‚--------------------------------------------------------------------
     pfilter_XmlOutput...
     p                 b                   export
     d filter_XmlOutput...
     d                 pi                  likeDs(xml_nodeDefine)
     d   lNode                         *   const
      *
     d   ND            ds                  likeDs(xml_nodeDefine)
     d   filters       ds                  likeds(tFilters) based(pFilters)
     d   filter        ds                  likeds(tFilter) based(pFilter)
     d   omit          ds                  likeds(tOmit) based(pOmit)
       clear ND;
       if tree_isofthekind(kFilters:lNode:pFilters);
         ND.ID='FILTERS';
         xml_setAttfromBoolean(ND.atts:'ACTIVATED':filters.activated);
       elseif tree_isofthekind(kFilter:lNode:pFilter);
         ND.ID='FILTER';
         xml_setAttfromString(ND.atts:'ID':filter.ID);
       elseif tree_isofthekind(kOmit:lNode:pOmit);
         ND.ID='OMIT';
         xml_setAttfromString(ND.atts:'ID':omit.ID);
       endIf;
       return ND;
     p                 e
