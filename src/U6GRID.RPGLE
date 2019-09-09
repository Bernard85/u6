     H nomain option(*NOSHOWCPY)
      /copy cpy,u6tree_h
      /copy cpy,u6xml_h
      /copy cpy,u6env_h

      /copy cpy,u6grid_h
      //‚--------------------------------------------------------------------
      //‚get item for FILE family for Xml parser
      //‚--------------------------------------------------------------------
     pgrid_XmlInput...
     p                 b                   export
     d grid_XmlInput...
     d                 pi              *
     d   ND                                const likeDs(xml_nodeDefine)
      *
     d   grid          ds                  likeds(tGrid)    based(pGrid)
     d   subGrid       ds                  likeds(tSubGrid) based(pSubGrid)
     d   column        ds                  likeds(tColumn)  based(pColumn)
       if ND.ID='GRID';
         pGrid=tree_getnewitem(%addr(tGrid):%size(tGrid));
         grid.ID=xml_getAttAsString('ID':ND.atts);
         grid.text=ND.text;
         return pGrid;
       elseIf ND.ID='SUBGRID';
         pSubGrid=tree_getnewitem(%addr(tSubGrid):%size(tSubGrid));
         subGrid.ID=xml_getAttAsString('ID':ND.atts);
         return pSubGrid;
       elseIf ND.ID='COLUMN';
         pColumn=tree_getnewitem(%addr(tColumn):%size(tColumn));
         column.ID      =xml_getAttAsString ('ID':ND.atts);
         column.seq     =xml_getAttAsInteger('SEQ':ND.atts);
         column.text    =ND.text;
         column.formula =xml_getAttAsString ('FORMULA':ND.atts);
         column.edtWidth=xml_getAttAsInteger('EDTWIDTH':ND.atts);
         column.hdrWidth=xml_getAttAsInteger('HDRWIDTH':ND.atts);
         column.maxWidth=xml_getAttAsInteger('MAXWIDTH':ND.atts);
         column.hdrFit  =xml_getAttAsInteger('HDRFIT':ND.atts);
         column.hdr1    =xml_getAttAsString ('HDR1':ND.atts);
         return pColumn;
       endIf;
       return *null;
     p                 e
      //‚--------------------------------------------------------------------
      //‚Set line for GRID family
      //‚--------------------------------------------------------------------
     pgrid_XmlOutput...
     p                 b                   export
     d grid_XmlOutput...
     d                 pi                  likeDs(xml_nodeDefine)
     d   lNode                         *   const
      *
     d   ND            ds                  likeDs(xml_nodeDefine)
     d   grid          ds                  likeds(tGrid) based(pGrid)
     d   subGrid       ds                  likeds(tSubGrid) based(pSubGrid)
     d   column        ds                  likeds(tColumn) based(pColumn)
       clear ND;
       if tree_isofthekind(kGrid:lNode:pGrid);
         ND.ID='GRID';
         xml_setAttfromString(ND.atts:'ID':grid.ID);
         ND.text=grid.text;
       elseIf tree_isofthekind(kSubGrid:lNode:pSubGrid);
         ND.ID='SUBGRID';
         xml_setAttfromString(ND.atts:'ID':subGrid.ID);
       elseIf tree_isofthekind(kColumn:lNode:pColumn);
         ND.ID='COLUMN';
         xml_setAttfromString (ND.atts:'ID':column.ID);
         xml_setAttfromInteger(ND.atts:'SEQ'     :column.seq);
         xml_setAttfromString (ND.atts:'FORMULA'  :column.formula);
         xml_setAttfromInteger(ND.atts:'EDTWIDTH':column.edtwidth);
         xml_setAttfromInteger(ND.atts:'HDRWIDTH':column.hdrwidth);
         xml_setAttfromInteger(ND.atts:'MAXWIDTH':column.maxwidth);
         xml_setAttfromInteger(ND.atts:'HDRFIT'  :column.hdrfit  );
         xml_setAttfromString (ND.atts:'HDR1'    :column.hdr1);
         ND.text=column.text;
       endIf;
       return ND;
     p                 e
      //‚--------------------------------------------------------------------
      //‚get grid
      //‚--------------------------------------------------------------------
     pgrid_getgrid     b                   export
     d grid_getgrid    pi              *
     d  lgrids                         *
     d  gridID                       10a   const varying
      *
     d  lGrid          s               *   inz(*null)
       if lGrids=*null;
         lGrids=tree_getnewlink(*null);
       endif;
       lGrid=tree_getLinkFromList(lGrids:kGrid:gridID);
       if lGrid=*null;
         lGrid=tree_Xml2Tree(env_getfilename(cGrid:GridId)
                            :%pAddr(grid_XmlInput));
         if lGrid<>*null;
           tree_linktoparent(lGrids:lGrid);
         endif;
       endIf;
       return lGrid;
     p                 e
