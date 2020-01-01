      //‚-----------------------------------------------------------------------
      //‚ Journal family
      //‚-----------------------------------------------------------------------
     d kJournal        c                   const('J')
     d kEntries        c                   const('E')
     d kSection        c                   const('S')
     d kEntry          c                   const('e')
     d kSubEntry       c                   const('s')
      //˜journal
     d tJournal        ds                  qualified
     d  kind                          1    inz(kJournal)
     d  ID                           15    varying
     d  text                         50    inz('') varying
      //˜Entries
     d tEntries        ds                  qualified
     d  kind                          1    inz(kEntries)
      //˜Section
     d tSection        ds                  qualified
     d  kind                          1    inz(kSection)
     d  text                         50    inz('') varying
      //˜entry
     d tJrnEntry     e ds                  extname(JRNENTRY) qualified template
     d tEntry          ds                  qualified
     d  kind                          1    inz(kEntry)
     d  pEntry0                        *   inz(*null)
     d  det                                likeDs(tJrnEntry)
     d  lXView                         *   inz(*null)
     d  lYView                         *   inz(*null)
      //˜sub-entry
     d tSubEntry       ds                  qualified
     d  kind                          1    inz(kSubEntry)
     d  fmtID                        10    varying
     d  pos                           5u 0 inz(0)
     d  lXView                         *   inz(*null)
     d  lYView                         *   inz(*null)
      //‚get item from JOURNAL family
     djrn_XMLinput...
     d                 pr              *
     d   ND                                const likeDs(xml_nodeDefine)
      //‚Set line for Xml parser from node on journal family
     d jrn_XmlOutput...
     d                 pr                  likeDs(xml_nodeDefine)
     d   lNode                         *   const
      //‚link entries
     d jrn_tieEntries  pr
     d  lEntries                       *   const
