      //‚xml define
     d xml_NodeDefine  ds                  inz template qualified
     d   isOpen                        n
     d   isClose                       n
     d   ID                         128a   varying
     d   atts                      2048a   varying
     d   text                      2048a   varying
     d   level                        3u 0
      //‚xml_read
     d xml_read        pr
     d  path                        255a   varying const
     d  pProc1                         *   procptr const
     d  pBox                           *   const

      //‚get attribut as string
     dXML_getAttAsString...
     d                 pr           128    varying
     d  pty                         128    varying const
     d  ptys                       2048    varying const
      //‚get attribut as integer
     dXML_getAttAsInteger...
     d                 pr            10i 0
     d  pty                         128    varying const
     d  ptys                       2048    varying const
      //‚get attribut as boolean
     dXML_getAttAsBoolean...
     d                 pr              n
     d  pty                         128    varying const
     d  ptys                       2048    varying const
      //‚hide special characters
     dxml_HideSpecialCharacters...
     d                 pr          2048a   varying
     d                             2048a   varying const
      //‚seek special characters
     dxml_SeekSpecialCharacters...
     d                 pr          2048a   varying
     d                             2048a   varying const
      //‚set attribut from integer value
     dxml_setAttfromInteger...
     d                 pr
     d  atts                       2048    varying
     d  pty                         128    varying const
     d  val                          20i 0 const
      //‚set attribut from string value
     dxml_setAttfromString...
     d                 pr
     d  atts                       2048    varying
     d  pty                         128    varying const
     d  val                         128    varying const
      //‚set attribut from string value
     dxml_setAttfromBoolean...
     d                 pr
     d  atts                       2048    varying
     d  pty                         128    varying const
     d  val                            n           const
      //‚Save tree as XML
     d xml_tree2XML    pr
     d  xmlpath                     128a   const varying
     d  lRoot                          *   const
     d  pXX_XMLoutput                  *   const procptr
      //‚xml write node
     d xml_writeNode   pr
     d  hJRN                         10i 0 const
     d  ND                                 likeDs(xml_nodeDefine) const
