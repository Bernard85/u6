      //‚FILE family
     d kFiles          c                   const('F')
     d kFile           c                   const('f')
      *
     d tFiles          ds                  qualified
     d  kind                          1    inz(kFiles)
     d tFile           ds                  qualified
     d  kind                          1    inz(kFile)
     d  ID                           10    varying
     d  format                       10    varying
     d  text                         50    varying
      //‚get item for FILE family from xml
     dfile_XmlInput...
     d                 pr              *
     d   ND                                const likeDs(xml_nodeDefine)
      //‚Set line for Xml parser from node on FILE family
     dfile_XmlOutput...
     d                 pr                  likeDs(xml_nodeDefine)
     d   lNode                         *   const
      //‚get file
     dfile_getFile     pr              *
     d  lFiles                         *
     d  fileID                       10a   const varying
