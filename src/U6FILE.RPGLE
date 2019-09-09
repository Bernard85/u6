     H nomain option(*NOSHOWCPY)
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h
      /copy cpy,u6env_h

      /copy cpy,u6file_h
      //‚--------------------------------------------------------------------
      //‚get item for FILE family for Xml parser
      //‚--------------------------------------------------------------------
     pfile_XmlInput...
     p                 b                   export
     d file_XmlInput...
     d                 pi              *
     d   ND                                const likeDs(xml_nodeDefine)
      *
     d   file          ds                  likeds(tFile) based(pFile)
       if ND.ID='FILE';
         pFile=tree_getnewitem(%addr(tFile):%size(tFile));
         file.text=nd.text;
         file.ID=xml_getAttAsString('ID':ND.atts);
         file.format=xml_getAttAsString('FORMAT':ND.atts);
         return pFile;
       endIf;
       return *null;
     p                 e
      //‚--------------------------------------------------------------------
      //‚Set line for Xml parser from node on file family
      //‚--------------------------------------------------------------------
     pfile_XmlOutput...
     p                 b                   export
     d file_XmlOutput...
     d                 pi                  likeDs(xml_nodeDefine)
     d   lNode                         *   const
      *
     d   ND            ds                  likeDs(xml_nodeDefine)
     d   file          ds                  likeds(tFile) based(pFile)
       clear ND;
       if tree_isofthekind(kFile:lNode:pFile);
         ND.ID='FILE';
         nd.text=file.text;
         xml_setAttfromString(ND.atts:'ID':file.ID);
         xml_setAttfromString(ND.atts:'FORMAT':file.format);
       endIf;
       return ND;
     p                 e
      //‚--------------------------------------------------------------------
      //‚get file
      //‚--------------------------------------------------------------------
     pfile_getFile     b                   export
     d file_getFile    pi              *
     d  lFiles                         *
     d  fileID                       10a   const varying
      *
     d  lFile          s               *   inz(*null)
       if lFiles=*null;
         lFiles=tree_getnewlink(*null);
       endif;
       lFile=tree_getLinkFromList(lFiles:kFile:fileID);
       if lFile=*null;
         lFile=tree_Xml2Tree(env_getfilename(cFile:fileId)
                            :%pAddr(file_XmlInput));
         if lFile<>*null;
           tree_linktoparent(lFiles:lFile);
         endif;
       endIf;
       return lFile;
     p                 e
