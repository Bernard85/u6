     h option(*NOSHOWCPY) nomain
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h

      /copy cpy,u6Struct_h
      //‚--------------------------------------------------------------------
      //‚get item for STRUCT family for Xml parser
      //‚--------------------------------------------------------------------
     pStruct_XmlInput...
     p                 b                   export
     d Struct_XmlInput...
     d                 pi              *
     d   ND                                const likeDs(xml_nodeDefine)
      *
     d   struct        ds                  likeds(tStruct) based(pStruct)
       if ND.ID='STRUCT';
         pStruct=tree_getNewItem(%addr(tStructHead):%size(tStructHead));
         StructHead.ID=xml_getAttAsString('ID':ND.atts);
         return pStructHead;
       endif;
       return *null;
     p                 e
