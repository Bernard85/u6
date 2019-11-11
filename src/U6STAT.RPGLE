     H nomain option(*NOSHOWCPY)
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h
      /copy cpy,u6env_h

      /copy cpy,u6stat_h
      //‚--------------------------------------------------------------------
      //‚get item for STAT family for Xml parser
      //‚--------------------------------------------------------------------
     pstat_XmlInput...
     p                 b                   export
     d stat_XmlInput...
     d                 pi              *
     d   ND                                const likeDs(xml_nodeDefine)
      *
     d   stats         ds                  likeds(tStats) based(pStats)
     d   stat          ds                  likeds(tStat)  based(pStat)
       if ND.ID='STATS';
         pStats=tree_getnewitem(%addr(tStats):%size(tStats));
         return pStats;
       elseif ND.ID='STAT';
         pStat=tree_getnewitem(%addr(tStat):%size(tStat));
         stat.ID      =xml_getAttAsString('ID':ND.atts);
         stat.formula =xml_getAttAsString('FORMULA':ND.atts);
         stat.text    =ND.text;
         return pStat;
       endIf;
       return *null;
     p                 e
