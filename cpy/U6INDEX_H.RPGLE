      //‚INDEX family
     d iIndex          c                   const('INDEX')
     d iElement        c                   const('ELEMENT')
     d kIndex          c                   const('I')
     d kElement        c                   const('E')
      //‚index template
     d tIndex          ds                  qualified
     d  kind                          1    inz(kIndex)
      //‚element template
     d tElement        ds                  qualified
     d  kind                          1    inz(kElement)
     d  ID                           35A   varying
     d  seq                           5u 0
     d  text                         50a   varying
     d  exists                         n
      //‚get item for INDEX family
     dindex_XmlInput...
     d                 pr              *
     d   ND                                const likeDs(xml_nodeDefine)
      //‚Set item for INDEX family
     dindex_XmlOutput...
     d                 pr                  likeDs(xml_nodeDefine)
     d   lNode                         *   const
      //‚Comparator
     d index_comparator...
     D                 Pr             3i 0
     D  lElement1                      *   const
     D  lElement2                      *   const
