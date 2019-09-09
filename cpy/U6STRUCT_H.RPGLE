      //‚Head of structure
     d kStruct         c                   const('h')
     d tStruct         ds                  qualified
     d  kItem                         1a   inz(kStruct)
     d  ID                           50a   varying
     d  lFmt                           *   inz(*null)
     d  lRequestor                     *   inz(*null)
      //‚get item for family STRUCT for Xml parser
     d Struct_XmlInput...
     d                 pr              *
     d   ND                                const likeDs(xml_nodeDefine)
