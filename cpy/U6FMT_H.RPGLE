      //�--------------------------------------------------------------------
      //�FORMAT family
      //�--------------------------------------------------------------------
     d kFormats        c                   const('O')
     d kFormat         c                   const('o')
     d kField          c                   const('f')
      //�Format
     d tFormats        ds                  qualified
     d  kind                          1    inz(kFormats)
      //�Format
     d tFormat         ds                  qualified
     d  kind                          1    inz(kFormat)
     d  ID                           10    varying
     d  len                           5u 0
     d  fldnbr                        5u 0
     d  pBuffer1                       *
     d  pBuffer0                       *
      //�Field
     d tField          ds                  qualified
     d  kind                          1    inz(kField)
     d  ID                           10    varying
     d  NO                            3u 0
     d  type                          1
     d  len                           5u 0
     d  dec                           3u 0
     d  digits                        3u 0
     d  posInBuffer                   5u 0
      //�get format from list
     d fmt_getFormat   pr              *
     d  lFormats                       *
     d  formatID                     10a   const varying
      //�get item for FORMAT family
     d fmt_xmlInput    pr              *
     d   ND                                const likeDs(xml_nodeDefine)
      //�set item for FORMAT family
     d fmt_XMLoutput   pr                  likeDs(xml_nodeDefine)
     d   lNode                         *   const