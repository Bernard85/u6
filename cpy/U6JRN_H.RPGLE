      //‚-----------------------------------------------------------------------
      //‚ Journal family
      //‚-----------------------------------------------------------------------
     d kJournal        c                   const('J')
     d kEntries        c                   const('E')
     d kEntry          c                   const('e')
      //˜journal
     d tJournal        ds                  qualified
     d  kind                          1    inz(kJournal)
     d  ID                           15    varying
     d  text                         50    inz('') varying
      //˜Entries
     d tEntries        ds                  qualified
     d  kind                          1    inz(kEntries)
      //˜entry
     d tJrnEntry     e ds                  extname(JRNENTRY) qualified template
     d tEntry          ds                  qualified
     d  kind                          1    inz(kEntry)
     d  pentry0                        *   inz(*null)
     d  det                                likeDs(tJrnEntry)
     d  lXView                         *
      //‚get item from JOURNAL family
     djrn_XMLinput...
     d                 pr              *
     d   ND                                const likeDs(xml_nodeDefine)
      //‚Set line for Xml parser from node on journal family
     d jrn_XmlOutput...
     d                 pr                  likeDs(xml_nodeDefine)
     d   lNode                         *   const
      //‚get roots of journal analysis
     d jrn_getRoots    pr
     d  lJrn                           *   const
     d  lEntries                       *
      //‚link entries
     d jrn_tieEntries  pr
     d  lEntries                       *   const
