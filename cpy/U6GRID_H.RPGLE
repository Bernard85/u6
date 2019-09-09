      //‚GRID family
     d kGrid           c                   const('G')
     d kSubGrid        c                   const('S')
     d kColumn         c                   const('c')
      //‚grid
     d tGrid           ds                  qualified
     d  kind                          1    inz(kGrid)
     d  ID                           10    varying
     d  text                         50
     d  change                         n
     d  lFormat                        *   inz(*null)
      //‚sub-grid
     d tSubGrid        ds                  qualified
     d  kind                          1    inz(kSubGrid)
     d  ID                           10    varying
      //‚column
     d tColumn         ds                  qualified
     d  kind                          1    inz(kColumn)
     d  id                           10    varying
     d  seq                           5u 0
     d  edtWidth                      5u 0
     d  hdrfit                        3u 0
     d  hdrWidth                      5u 0
     d  maxWidth                      5u 0
     d  hdr1                         30    varying
     d  formula                      50    varying
     d  text                         50    varying
     d  lFormula                       *
     d  pos                           3u 0
      //‚get item from GRID family
     dgrid_XMLinput...
     d                 pr              *
     d   ND                                const likeDs(xml_nodeDefine)
      //‚set line for Xml parser from node
     dgrid_XmlOutput...
     d                 pr                  likeDs(xml_nodeDefine)
     d   lNode                         *   const
      //‚get grid from list
     d grid_getGrid    pr              *
     d  lgrids                         *
     d  gridID                       10a   const varying
