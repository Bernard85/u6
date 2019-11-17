      //‚FILTER family
     d kFilters        c                   const('F')
     d kFilter         c                   const('f')
     d kOmit           c                   const('o')
      *
     d tFilters        ds                  qualified
     d  kind                          1    inz(kFilters)
     d  activated                      n   inz(*on)
     d tFilter         ds                  qualified
     d  kind                          1    inz(kFilter)
     d  ID                           10    varying
     d tOmit           ds                  qualified
     d  kind                          1    inz(kOmit)
     d  ID                           30    varying
      //‚get item for FILTER family from xml
     dfilter_XmlInput...
     d                 pr              *
     d   ND                                const likeDs(xml_nodeDefine)
      //‚Set line for Xml parser from node on FILE family
     dfilter_XmlOutput...
     d                 pr                  likeDs(xml_nodeDefine)
     d   lNode                         *   const
